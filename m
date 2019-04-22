Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 632A7C10F11
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30BBB206A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbfDVUsO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 16:48:14 -0400
Received: from mail.us.es ([193.147.175.20]:46700 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730464AbfDVUsN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 16:48:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BEF1644382D
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 22:48:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF254DA703
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 22:48:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A41BDDA705; Mon, 22 Apr 2019 22:48:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A5FCADA703;
        Mon, 22 Apr 2019 22:48:08 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 22 Apr 2019 22:48:08 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 71FCF4265A32;
        Mon, 22 Apr 2019 22:48:08 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/10] netfilter: nf_tables: prevent shift wrap in nft_chain_parse_hook()
Date:   Mon, 22 Apr 2019 22:47:57 +0200
Message-Id: <20190422204801.26321-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190422204801.26321-1-pablo@netfilter.org>
References: <20190422204801.26321-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

I believe that "hook->num" can be up to UINT_MAX.  Shifting more than
31 bits would is undefined in C but in practice it would lead to shift
wrapping.  That would lead to an array overflow in nf_tables_addchain():

	ops->hook       = hook.type->hooks[ops->hooknum];

Fixes: fe19c04ca137 ("netfilter: nf_tables: remove nhooks field from struct nft_af_info")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ef7772e976cc..1606eaa5ae0d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1545,7 +1545,7 @@ static int nft_chain_parse_hook(struct net *net,
 		if (IS_ERR(type))
 			return PTR_ERR(type);
 	}
-	if (!(type->hook_mask & (1 << hook->num)))
+	if (hook->num > NF_MAX_HOOKS || !(type->hook_mask & (1 << hook->num)))
 		return -EOPNOTSUPP;
 
 	if (type->type == NFT_CHAIN_T_NAT &&
-- 
2.11.0

