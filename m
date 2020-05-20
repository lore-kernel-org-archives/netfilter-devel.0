Return-Path: <SRS0=7yxH=7C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14869C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 024A520671
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgETSRF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 May 2020 14:17:05 -0400
Received: from correo.us.es ([193.147.175.20]:43502 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbgETSRE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 May 2020 14:17:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DF333DA722
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:17:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CFF5EDA712
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:17:02 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C5B89DA711; Wed, 20 May 2020 20:17:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DAED8DA713
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:17:00 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 May 2020 20:16:59 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C7B2642EF42A
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:17:00 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 7/7] netfilter: nf_tables: allow to register flowtable with no devices
Date:   Wed, 20 May 2020 20:16:52 +0200
Message-Id: <20200520181652.30285-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200520181652.30285-1-pablo@netfilter.org>
References: <20200520181652.30285-1-pablo@netfilter.org>
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

