Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F323FC433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 21:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE96861006
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 21:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhESVPM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 May 2021 17:15:12 -0400
Received: from mail.netfilter.org ([217.70.188.207]:46818 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhESVPL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 May 2021 17:15:11 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 059C26417E
        for <netfilter-devel@vger.kernel.org>; Wed, 19 May 2021 23:12:54 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: extended netlink error reporting for chain type
Date:   Wed, 19 May 2021 23:13:47 +0200
Message-Id: <20210519211347.265265-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Users that forget to select the NAT chain type in netfilter's Kconfig
hit ENOENT when adding the basechain.

This report is however sparse since it might be the table, the chain
or the kernel module that is missing/does not exist.

This patch provides extended netlink error reporting for the
NFTA_CHAIN_TYPE netlink attribute, which conveys the basechain type.
If the user selects a basechain that his custom kernel does not support,
the netlink extended error provides a more accurate hint on the
described issue.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 11e7edc1e9e4..aea571e924a8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1854,7 +1854,7 @@ static int nft_chain_parse_netdev(struct net *net,
 static int nft_chain_parse_hook(struct net *net,
 				const struct nlattr * const nla[],
 				struct nft_chain_hook *hook, u8 family,
-				bool autoload)
+				struct netlink_ext_ack *extack, bool autoload)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nlattr *ha[NFTA_HOOK_MAX + 1];
@@ -1884,8 +1884,10 @@ static int nft_chain_parse_hook(struct net *net,
 	if (nla[NFTA_CHAIN_TYPE]) {
 		type = nf_tables_chain_type_lookup(net, nla[NFTA_CHAIN_TYPE],
 						   family, autoload);
-		if (IS_ERR(type))
+		if (IS_ERR(type)) {
+			NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_TYPE]);
 			return PTR_ERR(type);
+		}
 	}
 	if (hook->num >= NFT_MAX_HOOKS || !(type->hook_mask & (1 << hook->num)))
 		return -EOPNOTSUPP;
@@ -1894,8 +1896,11 @@ static int nft_chain_parse_hook(struct net *net,
 	    hook->priority <= NF_IP_PRI_CONNTRACK)
 		return -EOPNOTSUPP;
 
-	if (!try_module_get(type->owner))
+	if (!try_module_get(type->owner)) {
+		if (nla[NFTA_CHAIN_TYPE])
+			NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_TYPE]);
 		return -ENOENT;
+	}
 
 	hook->type = type;
 
@@ -2006,7 +2011,8 @@ static int nft_chain_add(struct nft_table *table, struct nft_chain *chain)
 static u64 chain_id;
 
 static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
-			      u8 policy, u32 flags)
+			      u8 policy, u32 flags,
+			      struct netlink_ext_ack *extack)
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_table *table = ctx->table;
@@ -2028,7 +2034,8 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		if (flags & NFT_CHAIN_BINDING)
 			return -EOPNOTSUPP;
 
-		err = nft_chain_parse_hook(net, nla, &hook, family, true);
+		err = nft_chain_parse_hook(net, nla, &hook, family, extack,
+					   true);
 		if (err < 0)
 			return err;
 
@@ -2183,7 +2190,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			return -EEXIST;
 		}
 		err = nft_chain_parse_hook(ctx->net, nla, &hook, ctx->family,
-					   false);
+					   extack, false);
 		if (err < 0)
 			return err;
 
@@ -2396,7 +2403,7 @@ static int nf_tables_newchain(struct sk_buff *skb, const struct nfnl_info *info,
 					  extack);
 	}
 
-	return nf_tables_addchain(&ctx, family, genmask, policy, flags);
+	return nf_tables_addchain(&ctx, family, genmask, policy, flags, extack);
 }
 
 static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
-- 
2.30.2

