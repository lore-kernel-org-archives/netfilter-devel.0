From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nf_tables: fix rule batch with anonymous set and module autoload
Date: Fri, 14 Feb 2014 12:27:08 +0100
Message-ID: <1392377228-3748-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46598 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbaBNL1R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:27:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If some modules are missing while processing a rule batch, the updates
are aborted to start scratch since the nfnl lock was released. If the
rule-set contains this configuration (in this order):

 #1 rule using anonymous set
 #2 rule requiring module autoload

The anonymous set will be released when aborting. This patch fixes this
by passing a context variable (autoload) that can be used to decide if
the anonymous set has to be released or not.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I guess we can encapsulate that autoload into a context information structure
in the future in case any other information is needed in the rule destroy path
to make this look nicer.

I started hacking on two patches to net-next, one to include table, chains and
set into the batch and follow up to add atomic updates for sets. @Patrick: I
think that should not interfer with your set enhancements.

 include/linux/netfilter/nfnetlink.h |    2 +-
 include/net/netfilter/nf_tables.h   |    5 +++--
 net/netfilter/nf_tables_api.c       |   21 +++++++++++----------
 net/netfilter/nfnetlink.c           |    4 ++--
 net/netfilter/nft_compat.c          |    4 ++--
 net/netfilter/nft_ct.c              |    2 +-
 net/netfilter/nft_immediate.c       |    2 +-
 net/netfilter/nft_log.c             |    2 +-
 net/netfilter/nft_lookup.c          |    4 ++--
 9 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 28c7436..69febee 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -27,7 +27,7 @@ struct nfnetlink_subsystem {
 	__u8 cb_count;			/* number of callbacks */
 	const struct nfnl_callback *cb;	/* callback for individual types */
 	int (*commit)(struct sk_buff *skb);
-	int (*abort)(struct sk_buff *skb);
+	int (*abort)(struct sk_buff *skb, bool autoload);
 };
 
 int nfnetlink_subsys_register(const struct nfnetlink_subsystem *n);
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e7e14ff..ccc4be6 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -239,7 +239,7 @@ struct nft_set_binding {
 int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		       struct nft_set_binding *binding);
 void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
-			  struct nft_set_binding *binding);
+			  struct nft_set_binding *binding, bool autoload);
 
 
 /**
@@ -288,7 +288,8 @@ struct nft_expr_ops {
 	int				(*init)(const struct nft_ctx *ctx,
 						const struct nft_expr *expr,
 						const struct nlattr * const tb[]);
-	void				(*destroy)(const struct nft_expr *expr);
+	void				(*destroy)(const struct nft_expr *expr,
+						   bool autoload);
 	int				(*dump)(struct sk_buff *skb,
 						const struct nft_expr *expr);
 	int				(*validate)(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index adce01e..f92d99d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1254,10 +1254,10 @@ err1:
 	return err;
 }
 
-static void nf_tables_expr_destroy(struct nft_expr *expr)
+static void nf_tables_expr_destroy(struct nft_expr *expr, bool autoload)
 {
 	if (expr->ops->destroy)
-		expr->ops->destroy(expr);
+		expr->ops->destroy(expr, autoload);
 	module_put(expr->ops->type->owner);
 }
 
@@ -1531,7 +1531,7 @@ err:
 	return err;
 }
 
-static void nf_tables_rule_destroy(struct nft_rule *rule)
+static void nf_tables_rule_destroy(struct nft_rule *rule, bool autoload)
 {
 	struct nft_expr *expr;
 
@@ -1541,7 +1541,7 @@ static void nf_tables_rule_destroy(struct nft_rule *rule)
 	 */
 	expr = nft_expr_first(rule);
 	while (expr->ops && expr != nft_expr_last(rule)) {
-		nf_tables_expr_destroy(expr);
+		nf_tables_expr_destroy(expr, autoload);
 		expr = nft_expr_next(expr);
 	}
 	kfree(rule);
@@ -1709,7 +1709,7 @@ err3:
 		kfree(repl);
 	}
 err2:
-	nf_tables_rule_destroy(rule);
+	nf_tables_rule_destroy(rule, false);
 err1:
 	for (i = 0; i < n; i++) {
 		if (info[i].ops != NULL)
@@ -1840,7 +1840,7 @@ static int nf_tables_commit(struct sk_buff *skb)
 
 	/* Now we can safely release unused old rules */
 	list_for_each_entry_safe(rupd, tmp, &net->nft.commit_list, list) {
-		nf_tables_rule_destroy(rupd->rule);
+		nf_tables_rule_destroy(rupd->rule, false);
 		list_del(&rupd->list);
 		kfree(rupd);
 	}
@@ -1848,7 +1848,7 @@ static int nf_tables_commit(struct sk_buff *skb)
 	return 0;
 }
 
-static int nf_tables_abort(struct sk_buff *skb)
+static int nf_tables_abort(struct sk_buff *skb, bool autoload)
 {
 	struct net *net = sock_net(skb->sk);
 	struct nft_rule_trans *rupd, *tmp;
@@ -1869,7 +1869,7 @@ static int nf_tables_abort(struct sk_buff *skb)
 	synchronize_rcu();
 
 	list_for_each_entry_safe(rupd, tmp, &net->nft.commit_list, list) {
-		nf_tables_rule_destroy(rupd->rule);
+		nf_tables_rule_destroy(rupd->rule, autoload);
 		list_del(&rupd->list);
 		kfree(rupd);
 	}
@@ -2518,11 +2518,12 @@ bind:
 }
 
 void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
-			  struct nft_set_binding *binding)
+			  struct nft_set_binding *binding, bool autoload)
 {
 	list_del(&binding->list);
 
-	if (list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS)
+	if (list_empty(&set->bindings) &&
+	    set->flags & NFT_SET_ANONYMOUS && !autoload)
 		nf_tables_set_destroy(ctx, set);
 }
 
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 046aa13..61fb987 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -325,7 +325,7 @@ replay:
 			 * original skb.
 			 */
 			if (err == -EAGAIN) {
-				ss->abort(skb);
+				ss->abort(skb, true);
 				nfnl_unlock(subsys_id);
 				kfree_skb(nskb);
 				goto replay;
@@ -351,7 +351,7 @@ done:
 	if (success && done)
 		ss->commit(skb);
 	else
-		ss->abort(skb);
+		ss->abort(skb, false);
 
 	nfnl_unlock(subsys_id);
 	kfree_skb(nskb);
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 82cb823..d1e02d9 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -192,7 +192,7 @@ err:
 }
 
 static void
-nft_target_destroy(const struct nft_expr *expr)
+nft_target_destroy(const struct nft_expr *expr, bool autoload)
 {
 	struct xt_target *target = expr->ops->data;
 
@@ -379,7 +379,7 @@ err:
 }
 
 static void
-nft_match_destroy(const struct nft_expr *expr)
+nft_match_destroy(const struct nft_expr *expr, bool autoload)
 {
 	struct xt_match *match = expr->ops->data;
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 46e2754..178d2be 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -297,7 +297,7 @@ static int nft_ct_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static void nft_ct_destroy(const struct nft_expr *expr)
+static void nft_ct_destroy(const struct nft_expr *expr, bool autoload)
 {
 	struct nft_ct *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index f169501..961042f 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -70,7 +70,7 @@ err1:
 	return err;
 }
 
-static void nft_immediate_destroy(const struct nft_expr *expr)
+static void nft_immediate_destroy(const struct nft_expr *expr, bool autoload)
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
 	return nft_data_uninit(&priv->data, nft_dreg_to_type(priv->dreg));
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 26c5154..b018eba 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -74,7 +74,7 @@ static int nft_log_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static void nft_log_destroy(const struct nft_expr *expr)
+static void nft_log_destroy(const struct nft_expr *expr, bool autoload)
 {
 	struct nft_log *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index bb4ef4c..c2b30c2 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -89,11 +89,11 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static void nft_lookup_destroy(const struct nft_expr *expr)
+static void nft_lookup_destroy(const struct nft_expr *expr, bool autoload)
 {
 	struct nft_lookup *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(NULL, priv->set, &priv->binding);
+	nf_tables_unbind_set(NULL, priv->set, &priv->binding, autoload);
 }
 
 static int nft_lookup_dump(struct sk_buff *skb, const struct nft_expr *expr)
-- 
1.7.10.4

