Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8769DC77B7A
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Apr 2023 17:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjDTRGc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Apr 2023 13:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbjDTRGb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2023 13:06:31 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E79E24217
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2023 10:06:29 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v5 6/7] netfilter: nf_tables: allow to create netdev chain without device
Date:   Thu, 20 Apr 2023 18:56:02 +0200
Message-Id: <20230420165603.43876-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230420165603.43876-1-pablo@netfilter.org>
References: <20230420165603.43876-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Relax netdev chain creation to allow for loading the ruleset, then
adding/deleting devices at a later stage. Hardware offload does not
support for this feature yet.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v5: no changes.

 net/netfilter/nf_tables_api.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2d225e3261a7..e5937c4f9cc2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2024,10 +2024,9 @@ struct nft_chain_hook {
 	struct list_head		list;
 };
 
-static int nft_chain_parse_netdev(struct net *net,
-				  struct nlattr *tb[],
+static int nft_chain_parse_netdev(struct net *net, struct nlattr *tb[],
 				  struct list_head *hook_list,
-				  struct netlink_ext_ack *extack)
+				  struct netlink_ext_ack *extack, u32 flags)
 {
 	struct nft_hook *hook;
 	int err;
@@ -2046,12 +2045,12 @@ static int nft_chain_parse_netdev(struct net *net,
 		if (err < 0)
 			return err;
 
-		if (list_empty(hook_list))
-			return -EINVAL;
-	} else {
-		return -EINVAL;
 	}
 
+	if (flags & NFT_CHAIN_HW_OFFLOAD &&
+	    list_empty(hook_list))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -2059,7 +2058,7 @@ static int nft_chain_parse_hook(struct net *net,
 				struct nft_base_chain *basechain,
 				const struct nlattr * const nla[],
 				struct nft_chain_hook *hook, u8 family,
-				struct netlink_ext_ack *extack)
+				u32 flags, struct netlink_ext_ack *extack)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nlattr *ha[NFTA_HOOK_MAX + 1];
@@ -2119,7 +2118,7 @@ static int nft_chain_parse_hook(struct net *net,
 
 	INIT_LIST_HEAD(&hook->list);
 	if (nft_base_chain_netdev(family, hook->num)) {
-		err = nft_chain_parse_netdev(net, ha, &hook->list, extack);
+		err = nft_chain_parse_netdev(net, ha, &hook->list, extack, flags);
 		if (err < 0) {
 			module_put(type->owner);
 			return err;
@@ -2262,7 +2261,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		if (flags & NFT_CHAIN_BINDING)
 			return -EOPNOTSUPP;
 
-		err = nft_chain_parse_hook(net, NULL, nla, &hook, family,
+		err = nft_chain_parse_hook(net, NULL, nla, &hook, family, flags,
 					   extack);
 		if (err < 0)
 			return err;
@@ -2407,7 +2406,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 
 		basechain = nft_base_chain(chain);
 		err = nft_chain_parse_hook(ctx->net, basechain, nla, &hook,
-					   ctx->family, extack);
+					   ctx->family, flags, extack);
 		if (err < 0)
 			return err;
 
@@ -2683,7 +2682,7 @@ static int nft_delchain_hook(struct nft_ctx *ctx, struct nft_chain *chain,
 
 	basechain = nft_base_chain(chain);
 	err = nft_chain_parse_hook(ctx->net, basechain, nla, &chain_hook,
-				   ctx->family, extack);
+				   ctx->family, chain->flags, extack);
 	if (err < 0)
 		return err;
 
-- 
2.30.2

