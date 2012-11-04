From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: nf_tables: improve deletion performance
Date: Sun, 4 Nov 2012 19:44:20 +0100
Message-ID: <20121104184420.GA22844@1984>
References: <1351785744-7492-1-git-send-email-pablo@netfilter.org>
 <1351785744-7492-3-git-send-email-pablo@netfilter.org>
 <50938CDC.4000902@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37615 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab2KDSo0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Nov 2012 13:44:26 -0500
Content-Disposition: inline
In-Reply-To: <50938CDC.4000902@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Tomasz,

On Fri, Nov 02, 2012 at 11:05:32AM +0200, Tomasz Bursztyka wrote:
> Hi Pablo,
> 
> >--- a/net/netfilter/nf_tables_api.c
> >+++ b/net/netfilter/nf_tables_api.c
> >@@ -1289,7 +1289,7 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
> >  		nf_tables_expr_destroy(ctx, expr);
> >  		expr = nft_expr_next(expr);
> >  	}
> >-	kfree(rule);
> >+	kfree_rcu(rule, rcu_head);
> >  }
> 
> Shouldn't it free the expression list at the same moment when the
> rule will actually be freed?
> So call_rcu() instead of kfree_rcu().

You're right. New patch attached using the call_rcu approach.

--envbJBWh7q8WU6mo
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nf_tables-improve-deletion-performance.patch"

>From 568faf7915bd2c24a0980ba04f5dec403eecdd38 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sun, 28 Oct 2012 22:15:36 +0100
Subject: [PATCH] netfilter: nf_tables: improve deletion performance

Simple solution: Use call_rcu to delay object release until we reach
RCU quiescent state instead of synchronize_rcu which is synchronous
and too expensive. On the contrary, this increases the size of the
struct nft_rule.

Regarding caching issues, I think it would be good to place
struct rcu_head at the end of struct nft_rule. However, the expression
area of one rule has variable length.

After this patch, rule object release becomes an asynchronous due
to the usage of call_rcu. Therefore, we cannot pass the context
information to the destroy callback to every expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |    5 +++--
 net/netfilter/nf_tables_api.c     |   37 ++++++++++++++-----------------------
 net/netfilter/nft_compat.c        |    4 ++--
 net/netfilter/nft_ct.c            |    9 ++++++---
 net/netfilter/nft_immediate.c     |    3 +--
 net/netfilter/nft_log.c           |    3 +--
 6 files changed, 27 insertions(+), 34 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index b49243b..ea5df3f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -140,8 +140,7 @@ struct nft_expr_ops {
 	int				(*init)(const struct nft_ctx *ctx,
 						const struct nft_expr *expr,
 						const struct nlattr * const tb[]);
-	void				(*destroy)(const struct nft_ctx *ctx,
-						   const struct nft_expr *expr);
+	void				(*destroy)(const struct nft_expr *expr);
 	int				(*dump)(struct sk_buff *skb,
 						const struct nft_expr *expr);
 	const struct nft_expr_type	*type;
@@ -171,12 +170,14 @@ static inline void *nft_expr_priv(const struct nft_expr *expr)
  *	struct nft_rule - nf_tables rule
  *
  *	@list: used internally
+ *	@rcu_head: used internally for rcu
  *	@handle: rule handle
  *	@dlen: length of expression data
  *	@data: expression data
  */
 struct nft_rule {
 	struct list_head		list;
+	struct rcu_head			rcu_head;
 	u64				handle;
 	u16				dlen;
 	unsigned char			data[]
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8bcd991..c818924 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1046,11 +1046,10 @@ err1:
 	return err;
 }
 
-static void nf_tables_expr_destroy(const struct nft_ctx *ctx,
-				   struct nft_expr *expr)
+static void nf_tables_expr_destroy(struct nft_expr *expr)
 {
 	if (expr->ops->destroy)
-		expr->ops->destroy(ctx, expr);
+		expr->ops->destroy(expr);
 	module_put(expr->ops->type->owner);
 }
 
@@ -1273,9 +1272,9 @@ err:
 	return err;
 }
 
-static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
-				   struct nft_rule *rule)
+static void nf_tables_rcu_rule_destroy(struct rcu_head *head)
 {
+	struct nft_rule *rule = container_of(head, struct nft_rule, rcu_head);
 	struct nft_expr *expr;
 
 	/*
@@ -1284,12 +1283,17 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
 	 */
 	expr = nft_expr_first(rule);
 	while (expr->ops && expr != nft_expr_last(rule)) {
-		nf_tables_expr_destroy(ctx, expr);
+		nf_tables_expr_destroy(expr);
 		expr = nft_expr_next(expr);
 	}
 	kfree(rule);
 }
 
+static void nf_tables_rule_destroy(struct nft_rule *rule)
+{
+	call_rcu(&rule->rcu_head, nf_tables_rcu_rule_destroy);
+}
+
 #define NFT_RULE_MAXEXPRS	12
 
 static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
@@ -1389,12 +1393,9 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 
 		list_replace_rcu(&old_rule->list, &rule->list);
 
-		// FIXME: this makes deletion performance *really* suck
-		synchronize_rcu();
-
 		nf_tables_rule_notify(skb, nlh, table, chain, old_rule,
 				      NFT_MSG_DELRULE, nfmsg->nfgen_family);
-		nf_tables_rule_destroy(&ctx, old_rule);
+		nf_tables_rule_destroy(old_rule);
 	} else if (nlh->nlmsg_flags & NLM_F_APPEND)
 		list_add_tail_rcu(&rule->list, &chain->rules);
 	else
@@ -1405,7 +1406,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	return 0;
 
 err2:
-	nf_tables_rule_destroy(&ctx, rule);
+	nf_tables_rule_destroy(rule);
 err1:
 	for (i = 0; i < n; i++) {
 		if (info[i].ops != NULL)
@@ -1423,7 +1424,6 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	const struct nft_table *table;
 	struct nft_chain *chain;
 	struct nft_rule *rule, *tmp;
-	struct nft_ctx ctx;
 	int family = nfmsg->nfgen_family;
 
 	afi = nf_tables_afinfo_lookup(family, false);
@@ -1446,26 +1446,17 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 		/* List removal must be visible before destroying expressions */
 		list_del_rcu(&rule->list);
 
-		// FIXME: this makes deletion performance *really* suck
-		synchronize_rcu();
-
 		nf_tables_rule_notify(skb, nlh, table, chain, rule,
 				      NFT_MSG_DELRULE, family);
-		nft_ctx_init(&ctx, skb, nlh, afi, table, chain);
-		nf_tables_rule_destroy(&ctx, rule);
+		nf_tables_rule_destroy(rule);
 	} else {
 		/* Remove all rules in this chain */
 		list_for_each_entry_safe(rule, tmp, &chain->rules, list) {
 			list_del_rcu(&rule->list);
 
-			// FIXME: this makes deletion performance *really* suck
-			synchronize_rcu();
-
 			nf_tables_rule_notify(skb, nlh, table, chain, rule,
 					      NFT_MSG_DELRULE, family);
-
-			nft_ctx_init(&ctx, skb, nlh, afi, table, chain);
-			nf_tables_rule_destroy(&ctx, rule);
+			nf_tables_rule_destroy(rule);
 		}
 	}
 
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index aa2e3be..b4a3ad3 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -182,7 +182,7 @@ err:
 }
 
 static void
-nft_target_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
+nft_target_destroy(const struct nft_expr *expr)
 {
 	struct nft_target *priv = nft_expr_priv(expr);
 
@@ -317,7 +317,7 @@ err:
 }
 
 static void
-nft_match_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
+nft_match_destroy(const struct nft_expr *expr)
 {
 	struct nft_match *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 1fffe27..5df7c76 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -23,6 +23,7 @@ struct nft_ct {
 	enum nft_ct_keys	key:8;
 	enum ip_conntrack_dir	dir:8;
 	enum nft_registers	dreg:8;
+	uint8_t			family;
 };
 
 static void nft_ct_eval(const struct nft_expr *expr,
@@ -178,6 +179,7 @@ static int nft_ct_init(const struct nft_ctx *ctx,
 	err = nf_ct_l3proto_try_module_get(ctx->afi->family);
 	if (err < 0)
 		return err;
+	priv->family = ctx->afi->family;
 
 	priv->dreg = ntohl(nla_get_be32(tb[NFTA_CT_DREG]));
 	err = nft_validate_output_register(priv->dreg);
@@ -194,10 +196,11 @@ err1:
 	return err;
 }
 
-static void nft_ct_destroy(const struct nft_ctx *ctx,
-			   const struct nft_expr *expr)
+static void nft_ct_destroy(const struct nft_expr *expr)
 {
-	nf_ct_l3proto_module_put(ctx->afi->family);
+	struct nft_ct *priv = nft_expr_priv(expr);
+
+	nf_ct_l3proto_module_put(priv->family);
 }
 
 static int nft_ct_dump(struct sk_buff *skb, const struct nft_expr *expr)
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 4b61563..d1e901e 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -70,8 +70,7 @@ err1:
 	return err;
 }
 
-static void nft_immediate_destroy(const struct nft_ctx *ctx,
-				  const struct nft_expr *expr)
+static void nft_immediate_destroy(const struct nft_expr *expr)
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
 	return nft_data_uninit(&priv->data, nft_dreg_to_type(priv->dreg));
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 9fe2be2..bbec4062 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -72,8 +72,7 @@ static int nft_log_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static void nft_log_destroy(const struct nft_ctx *ctx,
-			    const struct nft_expr *expr)
+static void nft_log_destroy(const struct nft_expr *expr)
 {
 	struct nft_log *priv = nft_expr_priv(expr);
 
-- 
1.7.10.4


--envbJBWh7q8WU6mo--
