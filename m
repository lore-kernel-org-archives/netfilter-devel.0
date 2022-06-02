Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41626CCA479
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Jun 2022 07:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiFBHoE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Jun 2022 03:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiFBHoD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Jun 2022 03:44:03 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C29413129F
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2022 00:44:01 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/3,v3] netfilter: nf_tables: delete flowtable hooks via transaction list
Date:   Thu,  2 Jun 2022 09:43:55 +0200
Message-Id: <20220602074357.332409-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove inactive bool field in nft_hook object that was introduced in
abadb2f865d7 ("netfilter: nf_tables: delete devices from flowtable").
Move stale flowtable hooks to transaction list instead.

Deleting twice the same device does not result in ENOENT.

Fixes: abadb2f865d7 ("netfilter: nf_tables: delete devices from flowtable")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: incorrect update of nft_commit_release()

 include/net/netfilter/nf_tables.h |  1 -
 net/netfilter/nf_tables_api.c     | 35 +++++++------------------------
 2 files changed, 8 insertions(+), 28 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 20af9d3557b9..279ae0fff7ad 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1090,7 +1090,6 @@ struct nft_stats {
 
 struct nft_hook {
 	struct list_head	list;
-	bool			inactive;
 	struct nf_hook_ops	ops;
 	struct rcu_head		rcu;
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 129d3ebd6ce5..5ee4e7b28b61 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1914,7 +1914,6 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 		goto err_hook_dev;
 	}
 	hook->ops.dev = dev;
-	hook->inactive = false;
 
 	return hook;
 
@@ -7618,7 +7617,8 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
-	struct nft_hook *this, *hook;
+	struct nft_hook *this, *next, *hook;
+	LIST_HEAD(flowtable_del_list);
 	struct nft_trans *trans;
 	int err;
 
@@ -7627,13 +7627,13 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	list_for_each_entry(this, &flowtable_hook.list, list) {
+	list_for_each_entry_safe(this, next, &flowtable_hook.list, list) {
 		hook = nft_hook_list_find(&flowtable->hook_list, this);
 		if (!hook) {
 			err = -ENOENT;
 			goto err_flowtable_del_hook;
 		}
-		hook->inactive = true;
+		list_move(&hook->list, &flowtable_del_list);
 	}
 
 	trans = nft_trans_alloc(ctx, NFT_MSG_DELFLOWTABLE,
@@ -7646,6 +7646,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	nft_trans_flowtable(trans) = flowtable;
 	nft_trans_flowtable_update(trans) = true;
 	INIT_LIST_HEAD(&nft_trans_flowtable_hooks(trans));
+	list_splice(&flowtable_del_list, &nft_trans_flowtable_hooks(trans));
 	nft_flowtable_hook_release(&flowtable_hook);
 
 	nft_trans_commit_list_add_tail(ctx->net, trans);
@@ -7653,13 +7654,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	return 0;
 
 err_flowtable_del_hook:
-	list_for_each_entry(this, &flowtable_hook.list, list) {
-		hook = nft_hook_list_find(&flowtable->hook_list, this);
-		if (!hook)
-			break;
-
-		hook->inactive = false;
-	}
+	list_splice(&flowtable_del_list, &flowtable->hook_list);
 	nft_flowtable_hook_release(&flowtable_hook);
 
 	return err;
@@ -8563,17 +8558,6 @@ void nft_chain_del(struct nft_chain *chain)
 	list_del_rcu(&chain->list);
 }
 
-static void nft_flowtable_hooks_del(struct nft_flowtable *flowtable,
-				    struct list_head *hook_list)
-{
-	struct nft_hook *hook, *next;
-
-	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
-		if (hook->inactive)
-			list_move(&hook->list, hook_list);
-	}
-}
-
 static void nf_tables_module_autoload_cleanup(struct net *net)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -8918,8 +8902,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			break;
 		case NFT_MSG_DELFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
-				nft_flowtable_hooks_del(nft_trans_flowtable(trans),
-							&nft_trans_flowtable_hooks(trans));
 				nf_tables_flowtable_notify(&trans->ctx,
 							   nft_trans_flowtable(trans),
 							   &nft_trans_flowtable_hooks(trans),
@@ -9000,7 +8982,6 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
-	struct nft_hook *hook;
 
 	if (action == NFNL_ABORT_VALIDATE &&
 	    nf_tables_validate(net) < 0)
@@ -9131,8 +9112,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_DELFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
-				list_for_each_entry(hook, &nft_trans_flowtable(trans)->hook_list, list)
-					hook->inactive = false;
+				list_splice(&nft_trans_flowtable_hooks(trans),
+					    &nft_trans_flowtable(trans)->hook_list);
 			} else {
 				trans->ctx.table->use++;
 				nft_clear(trans->ctx.net, nft_trans_flowtable(trans));
-- 
2.30.2

