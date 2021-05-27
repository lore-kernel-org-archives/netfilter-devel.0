Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF24C47089
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 19:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADB8F6103E
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 19:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbhE0TDF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 May 2021 15:03:05 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38832 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236118AbhE0TC6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 May 2021 15:02:58 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7E08864505;
        Thu, 27 May 2021 21:00:21 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/5] netfilter: nf_tables: extended netlink error reporting for chain type
Date:   Thu, 27 May 2021 21:01:13 +0200
Message-Id: <20210527190115.98503-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210527190115.98503-1-pablo@netfilter.org>
References: <20210527190115.98503-1-pablo@netfilter.org>
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
index 5a02b48af7fb..c34a3c0a0d9c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1905,7 +1905,7 @@ static int nft_chain_parse_netdev(struct net *net,
 static int nft_chain_parse_hook(struct net *net,
 				const struct nlattr * const nla[],
 				struct nft_chain_hook *hook, u8 family,
-				bool autoload)
+				struct netlink_ext_ack *extack, bool autoload)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nlattr *ha[NFTA_HOOK_MAX + 1];
@@ -1935,8 +1935,10 @@ static int nft_chain_parse_hook(struct net *net,
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
@@ -1945,8 +1947,11 @@ static int nft_chain_parse_hook(struct net *net,
 	    hook->priority <= NF_IP_PRI_CONNTRACK)
 		return -EOPNOTSUPP;
 
-	if (!try_module_get(type->owner))
+	if (!try_module_get(type->owner)) {
+		if (nla[NFTA_CHAIN_TYPE])
+			NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_TYPE]);
 		return -ENOENT;
+	}
 
 	hook->type = type;
 
@@ -2057,7 +2062,8 @@ static int nft_chain_add(struct nft_table *table, struct nft_chain *chain)
 static u64 chain_id;
 
 static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
-			      u8 policy, u32 flags)
+			      u8 policy, u32 flags,
+			      struct netlink_ext_ack *extack)
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_table *table = ctx->table;
@@ -2079,7 +2085,8 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		if (flags & NFT_CHAIN_BINDING)
 			return -EOPNOTSUPP;
 
-		err = nft_chain_parse_hook(net, nla, &hook, family, true);
+		err = nft_chain_parse_hook(net, nla, &hook, family, extack,
+					   true);
 		if (err < 0)
 			return err;
 
@@ -2234,7 +2241,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			return -EEXIST;
 		}
 		err = nft_chain_parse_hook(ctx->net, nla, &hook, ctx->family,
-					   false);
+					   extack, false);
 		if (err < 0)
 			return err;
 
@@ -2447,7 +2454,7 @@ static int nf_tables_newchain(struct sk_buff *skb, const struct nfnl_info *info,
 					  extack);
 	}
 
-	return nf_tables_addchain(&ctx, family, genmask, policy, flags);
+	return nf_tables_addchain(&ctx, family, genmask, policy, flags, extack);
 }
 
 static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
-- 
2.30.2

