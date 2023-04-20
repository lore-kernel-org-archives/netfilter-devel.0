Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B6F1C77B7C
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Apr 2023 22:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbjDTWlg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Apr 2023 18:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbjDTWlc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2023 18:41:32 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 863B33C21
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2023 15:41:30 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v6 1/7] netfilter: nf_tables: extended netlink error reporting for netdevice
Date:   Fri, 21 Apr 2023 00:34:28 +0200
Message-Id: <20230420223434.256393-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Flowtable and netdev chains are bound to one or several netdevice,
extend netlink error reporting to specify the the netdevice that
triggers the error.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v6: no changes

 net/netfilter/nf_tables_api.c | 38 ++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e48ab8dfb541..900abed9f534 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1955,7 +1955,8 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 
 static int nf_tables_parse_netdev_hooks(struct net *net,
 					const struct nlattr *attr,
-					struct list_head *hook_list)
+					struct list_head *hook_list,
+					struct netlink_ext_ack *extack)
 {
 	struct nft_hook *hook, *next;
 	const struct nlattr *tmp;
@@ -1969,10 +1970,12 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 
 		hook = nft_netdev_hook_alloc(net, tmp);
 		if (IS_ERR(hook)) {
+			NL_SET_BAD_ATTR(extack, tmp);
 			err = PTR_ERR(hook);
 			goto err_hook;
 		}
 		if (nft_hook_list_find(hook_list, hook)) {
+			NL_SET_BAD_ATTR(extack, tmp);
 			kfree(hook);
 			err = -EEXIST;
 			goto err_hook;
@@ -2005,20 +2008,23 @@ struct nft_chain_hook {
 
 static int nft_chain_parse_netdev(struct net *net,
 				  struct nlattr *tb[],
-				  struct list_head *hook_list)
+				  struct list_head *hook_list,
+				  struct netlink_ext_ack *extack)
 {
 	struct nft_hook *hook;
 	int err;
 
 	if (tb[NFTA_HOOK_DEV]) {
 		hook = nft_netdev_hook_alloc(net, tb[NFTA_HOOK_DEV]);
-		if (IS_ERR(hook))
+		if (IS_ERR(hook)) {
+			NL_SET_BAD_ATTR(extack, tb[NFTA_HOOK_DEV]);
 			return PTR_ERR(hook);
+		}
 
 		list_add_tail(&hook->list, hook_list);
 	} else if (tb[NFTA_HOOK_DEVS]) {
 		err = nf_tables_parse_netdev_hooks(net, tb[NFTA_HOOK_DEVS],
-						   hook_list);
+						   hook_list, extack);
 		if (err < 0)
 			return err;
 
@@ -2086,7 +2092,7 @@ static int nft_chain_parse_hook(struct net *net,
 
 	INIT_LIST_HEAD(&hook->list);
 	if (nft_base_chain_netdev(family, hook->num)) {
-		err = nft_chain_parse_netdev(net, ha, &hook->list);
+		err = nft_chain_parse_netdev(net, ha, &hook->list, extack);
 		if (err < 0) {
 			module_put(type->owner);
 			return err;
@@ -7568,7 +7574,8 @@ static const struct nla_policy nft_flowtable_hook_policy[NFTA_FLOWTABLE_HOOK_MAX
 static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 				    const struct nlattr *attr,
 				    struct nft_flowtable_hook *flowtable_hook,
-				    struct nft_flowtable *flowtable, bool add)
+				    struct nft_flowtable *flowtable,
+				    struct netlink_ext_ack *extack, bool add)
 {
 	struct nlattr *tb[NFTA_FLOWTABLE_HOOK_MAX + 1];
 	struct nft_hook *hook;
@@ -7615,7 +7622,8 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 	if (tb[NFTA_FLOWTABLE_HOOK_DEVS]) {
 		err = nf_tables_parse_netdev_hooks(ctx->net,
 						   tb[NFTA_FLOWTABLE_HOOK_DEVS],
-						   &flowtable_hook->list);
+						   &flowtable_hook->list,
+						   extack);
 		if (err < 0)
 			return err;
 	}
@@ -7758,7 +7766,8 @@ static void nft_flowtable_hooks_destroy(struct list_head *hook_list)
 }
 
 static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
-				struct nft_flowtable *flowtable)
+				struct nft_flowtable *flowtable,
+				struct netlink_ext_ack *extack)
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
@@ -7769,7 +7778,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 	int err;
 
 	err = nft_flowtable_parse_hook(ctx, nla[NFTA_FLOWTABLE_HOOK],
-				       &flowtable_hook, flowtable, false);
+				       &flowtable_hook, flowtable, extack, false);
 	if (err < 0)
 		return err;
 
@@ -7874,7 +7883,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 
 		nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
-		return nft_flowtable_update(&ctx, info->nlh, flowtable);
+		return nft_flowtable_update(&ctx, info->nlh, flowtable, extack);
 	}
 
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
@@ -7915,7 +7924,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 		goto err3;
 
 	err = nft_flowtable_parse_hook(&ctx, nla[NFTA_FLOWTABLE_HOOK],
-				       &flowtable_hook, flowtable, true);
+				       &flowtable_hook, flowtable, extack, true);
 	if (err < 0)
 		goto err4;
 
@@ -7967,7 +7976,8 @@ static void nft_flowtable_hook_release(struct nft_flowtable_hook *flowtable_hook
 }
 
 static int nft_delflowtable_hook(struct nft_ctx *ctx,
-				 struct nft_flowtable *flowtable)
+				 struct nft_flowtable *flowtable,
+				 struct netlink_ext_ack *extack)
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
@@ -7977,7 +7987,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	int err;
 
 	err = nft_flowtable_parse_hook(ctx, nla[NFTA_FLOWTABLE_HOOK],
-				       &flowtable_hook, flowtable, false);
+				       &flowtable_hook, flowtable, extack, false);
 	if (err < 0)
 		return err;
 
@@ -8059,7 +8069,7 @@ static int nf_tables_delflowtable(struct sk_buff *skb,
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 	if (nla[NFTA_FLOWTABLE_HOOK])
-		return nft_delflowtable_hook(&ctx, flowtable);
+		return nft_delflowtable_hook(&ctx, flowtable, extack);
 
 	if (flowtable->use > 0) {
 		NL_SET_BAD_ATTR(extack, attr);
-- 
2.30.2

