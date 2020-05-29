Return-Path: <SRS0=eCuo=7L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07909C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 17:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E426B2072D
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 17:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgE2Rui (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 May 2020 13:50:38 -0400
Received: from correo.us.es ([193.147.175.20]:58816 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727802AbgE2Ruh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 May 2020 13:50:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 99D9A8142C
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2020 19:50:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C4BBDA701
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2020 19:50:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 820B3DA714; Fri, 29 May 2020 19:50:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 459C1DA707;
        Fri, 29 May 2020 19:50:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 May 2020 19:50:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 19DA242EE38E;
        Fri, 29 May 2020 19:50:34 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 8/9] netfilter: nf_tables: allow to register flowtable with no devices
Date:   Fri, 29 May 2020 19:50:25 +0200
Message-Id: <20200529175026.30541-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529175026.30541-1-pablo@netfilter.org>
References: <20200529175026.30541-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A flowtable might be composed of dynamic interfaces only. Such dynamic
interfaces might show up at a later stage. This patch allows users to
register a flowtable with no devices. Once the dynamic interface becomes
available, the user adds the dynamic devices to the flowtable.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1c2c3bb78fa0..897ac5fbe079 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1724,8 +1724,6 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 			goto err_hook;
 		}
 	}
-	if (!n)
-		return -EINVAL;
 
 	return 0;
 
@@ -1762,6 +1760,9 @@ static int nft_chain_parse_netdev(struct net *net,
 						   hook_list);
 		if (err < 0)
 			return err;
+
+		if (list_empty(hook_list))
+			return -EINVAL;
 	} else {
 		return -EINVAL;
 	}
@@ -6209,8 +6210,7 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 		return err;
 
 	if (!tb[NFTA_FLOWTABLE_HOOK_NUM] ||
-	    !tb[NFTA_FLOWTABLE_HOOK_PRIORITY] ||
-	    !tb[NFTA_FLOWTABLE_HOOK_DEVS])
+	    !tb[NFTA_FLOWTABLE_HOOK_PRIORITY])
 		return -EINVAL;
 
 	hooknum = ntohl(nla_get_be32(tb[NFTA_FLOWTABLE_HOOK_NUM]));
@@ -6219,11 +6219,13 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 
 	priority = ntohl(nla_get_be32(tb[NFTA_FLOWTABLE_HOOK_PRIORITY]));
 
-	err = nf_tables_parse_netdev_hooks(ctx->net,
-					   tb[NFTA_FLOWTABLE_HOOK_DEVS],
-					   &flowtable_hook->list);
-	if (err < 0)
-		return err;
+	if (tb[NFTA_FLOWTABLE_HOOK_DEVS]) {
+		err = nf_tables_parse_netdev_hooks(ctx->net,
+						   tb[NFTA_FLOWTABLE_HOOK_DEVS],
+						   &flowtable_hook->list);
+		if (err < 0)
+			return err;
+	}
 
 	flowtable_hook->priority	= priority;
 	flowtable_hook->num		= hooknum;
-- 
2.20.1

