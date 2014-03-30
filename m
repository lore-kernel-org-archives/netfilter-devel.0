From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/8] netfilter: nf_tables: generalise transaction infrastructure
Date: Sun, 30 Mar 2014 14:04:47 +0200
Message-ID: <1396181094-8140-2-git-send-email-pablo@netfilter.org>
References: <1396181094-8140-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45386 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbaC3MFF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Mar 2014 08:05:05 -0400
In-Reply-To: <1396181094-8140-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch generalises the existing rule transaction infrastructure
so it can be used to handle set, table and chain object transactions
as well.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |    9 +--
 net/netfilter/nf_tables_api.c     |  113 +++++++++++++++++++++----------------
 2 files changed, 68 insertions(+), 54 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 13cd713..4b28242 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -341,16 +341,17 @@ struct nft_rule {
 };
 
 /**
- *	struct nft_rule_trans - nf_tables rule update in transaction
+ *	struct nft_trans - nf_tables object update in transaction
  *
  *	@list: used internally
  *	@ctx: rule context
- *	@rule: rule that needs to be updated
  */
-struct nft_rule_trans {
+struct nft_trans {
 	struct list_head		list;
 	struct nft_ctx			ctx;
-	struct nft_rule			*rule;
+	union {
+		struct nft_rule		*rule;
+	};
 };
 
 static inline struct nft_expr *nft_expr_first(const struct nft_rule *rule)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 48a5645..8b67d39 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -105,6 +105,25 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 	ctx->nla   = nla;
 }
 
+static struct nft_trans *nft_trans_alloc(struct nft_ctx *ctx)
+{
+	struct nft_trans *trans;
+
+	trans = kzalloc(sizeof(struct nft_trans), GFP_KERNEL);
+	if (trans == NULL)
+		return NULL;
+
+	trans->ctx	= *ctx;
+
+	return trans;
+}
+
+static void nft_trans_destroy(struct nft_trans *trans)
+{
+	list_del(&trans->list);
+	kfree(trans);
+}
+
 /*
  * Tables
  */
@@ -1558,20 +1577,19 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
 
 static struct nft_expr_info *info;
 
-static struct nft_rule_trans *
-nf_tables_trans_add(struct nft_ctx *ctx, struct nft_rule *rule)
+static struct nft_trans *
+nft_rule_trans_add(struct nft_ctx *ctx, struct nft_rule *rule)
 {
-	struct nft_rule_trans *rupd;
+	struct nft_trans *trans;
 
-	rupd = kmalloc(sizeof(struct nft_rule_trans), GFP_KERNEL);
-	if (rupd == NULL)
-	       return NULL;
+	trans = nft_trans_alloc(ctx);
+	if (trans == NULL)
+		return NULL;
 
-	rupd->ctx = *ctx;
-	rupd->rule = rule;
-	list_add_tail(&rupd->list, &ctx->net->nft.commit_list);
+	trans->rule = rule;
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 
-	return rupd;
+	return trans;
 }
 
 static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
@@ -1584,7 +1602,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_table *table;
 	struct nft_chain *chain;
 	struct nft_rule *rule, *old_rule = NULL;
-	struct nft_rule_trans *repl = NULL;
+	struct nft_trans *trans = NULL;
 	struct nft_expr *expr;
 	struct nft_ctx ctx;
 	struct nlattr *tmp;
@@ -1682,8 +1700,8 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 
 	if (nlh->nlmsg_flags & NLM_F_REPLACE) {
 		if (nft_rule_is_active_next(net, old_rule)) {
-			repl = nf_tables_trans_add(&ctx, old_rule);
-			if (repl == NULL) {
+			trans = nft_rule_trans_add(&ctx, old_rule);
+			if (trans == NULL) {
 				err = -ENOMEM;
 				goto err2;
 			}
@@ -1705,7 +1723,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 			list_add_rcu(&rule->list, &chain->rules);
 	}
 
-	if (nf_tables_trans_add(&ctx, rule) == NULL) {
+	if (nft_rule_trans_add(&ctx, rule) == NULL) {
 		err = -ENOMEM;
 		goto err3;
 	}
@@ -1713,11 +1731,10 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 
 err3:
 	list_del_rcu(&rule->list);
-	if (repl) {
-		list_del_rcu(&repl->rule->list);
-		list_del(&repl->list);
-		nft_rule_clear(net, repl->rule);
-		kfree(repl);
+	if (trans) {
+		list_del_rcu(&trans->rule->list);
+		nft_rule_clear(net, trans->rule);
+		nft_trans_destroy(trans);
 	}
 err2:
 	nf_tables_rule_destroy(&ctx, rule);
@@ -1734,7 +1751,7 @@ nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule)
 {
 	/* You cannot delete the same rule twice */
 	if (nft_rule_is_active_next(ctx->net, rule)) {
-		if (nf_tables_trans_add(ctx, rule) == NULL)
+		if (nft_rule_trans_add(ctx, rule) == NULL)
 			return -ENOMEM;
 		nft_rule_disactivate_next(ctx->net, rule);
 		return 0;
@@ -1810,7 +1827,7 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 static int nf_tables_commit(struct sk_buff *skb)
 {
 	struct net *net = sock_net(skb->sk);
-	struct nft_rule_trans *rupd, *tmp;
+	struct nft_trans *trans, *next;
 
 	/* Bump generation counter, invalidate any dump in progress */
 	net->nft.genctr++;
@@ -1823,38 +1840,36 @@ static int nf_tables_commit(struct sk_buff *skb)
 	 */
 	synchronize_rcu();
 
-	list_for_each_entry_safe(rupd, tmp, &net->nft.commit_list, list) {
+	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		/* This rule was inactive in the past and just became active.
 		 * Clear the next bit of the genmask since its meaning has
 		 * changed, now it is the future.
 		 */
-		if (nft_rule_is_active(net, rupd->rule)) {
-			nft_rule_clear(net, rupd->rule);
-			nf_tables_rule_notify(skb, rupd->ctx.nlh,
-					      rupd->ctx.table, rupd->ctx.chain,
-					      rupd->rule, NFT_MSG_NEWRULE, 0,
-					      rupd->ctx.afi->family);
-			list_del(&rupd->list);
-			kfree(rupd);
+		if (nft_rule_is_active(net, trans->rule)) {
+			nft_rule_clear(net, trans->rule);
+			nf_tables_rule_notify(skb, trans->ctx.nlh,
+					      trans->ctx.table, trans->ctx.chain,
+					      trans->rule, NFT_MSG_NEWRULE, 0,
+					      trans->ctx.afi->family);
+			nft_trans_destroy(trans);
 			continue;
 		}
 
 		/* This rule is in the past, get rid of it */
-		list_del_rcu(&rupd->rule->list);
-		nf_tables_rule_notify(skb, rupd->ctx.nlh,
-				      rupd->ctx.table, rupd->ctx.chain,
-				      rupd->rule, NFT_MSG_DELRULE, 0,
-				      rupd->ctx.afi->family);
+		list_del_rcu(&trans->rule->list);
+		nf_tables_rule_notify(skb, trans->ctx.nlh,
+				      trans->ctx.table, trans->ctx.chain,
+				      trans->rule, NFT_MSG_DELRULE, 0,
+				      trans->ctx.afi->family);
 	}
 
 	/* Make sure we don't see any packet traversing old rules */
 	synchronize_rcu();
 
 	/* Now we can safely release unused old rules */
-	list_for_each_entry_safe(rupd, tmp, &net->nft.commit_list, list) {
-		nf_tables_rule_destroy(&rupd->ctx, rupd->rule);
-		list_del(&rupd->list);
-		kfree(rupd);
+	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
+		nf_tables_rule_destroy(&trans->ctx, trans->rule);
+		nft_trans_destroy(trans);
 	}
 
 	return 0;
@@ -1863,27 +1878,25 @@ static int nf_tables_commit(struct sk_buff *skb)
 static int nf_tables_abort(struct sk_buff *skb)
 {
 	struct net *net = sock_net(skb->sk);
-	struct nft_rule_trans *rupd, *tmp;
+	struct nft_trans *trans, *next;
 
-	list_for_each_entry_safe(rupd, tmp, &net->nft.commit_list, list) {
-		if (!nft_rule_is_active_next(net, rupd->rule)) {
-			nft_rule_clear(net, rupd->rule);
-			list_del(&rupd->list);
-			kfree(rupd);
+	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
+		if (!nft_rule_is_active_next(net, trans->rule)) {
+			nft_rule_clear(net, trans->rule);
+			nft_trans_destroy(trans);
 			continue;
 		}
 
 		/* This rule is inactive, get rid of it */
-		list_del_rcu(&rupd->rule->list);
+		list_del_rcu(&trans->rule->list);
 	}
 
 	/* Make sure we don't see any packet accessing aborted rules */
 	synchronize_rcu();
 
-	list_for_each_entry_safe(rupd, tmp, &net->nft.commit_list, list) {
-		nf_tables_rule_destroy(&rupd->ctx, rupd->rule);
-		list_del(&rupd->list);
-		kfree(rupd);
+	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
+		nf_tables_rule_destroy(&trans->ctx, trans->rule);
+		nft_trans_destroy(trans);
 	}
 
 	return 0;
-- 
1.7.10.4

