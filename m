From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables PATCH v4 4/5] helpers
Date: Wed, 27 Aug 2014 09:25:58 +0200
Message-ID: <20140827072447.2762.61934.stgit@nfdev.cica.es>
References: <20140827072217.2762.69989.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55348 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752248AbaH0H0I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:26:08 -0400
In-Reply-To: <20140827072217.2762.69989.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch refactor the code to schedule objects deletion.

They are useful in follow-up patches.

In order to be able to use these new helper functions in all the code,
they are placed in the top of the file, with all the dependant functions
and symbols.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: rebased: now, nft_del*() functions use list_del_rcu().
v3: rebased on top of patch 1/5.
v4: The v3 version had several issues due to the rebase. Fixed in this v4.

 net/netfilter/nf_tables_api.c |  361 ++++++++++++++++++++++-------------------
 1 file changed, 193 insertions(+), 168 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index eac4fab..8f9bcce 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -136,6 +136,195 @@ static void nf_tables_unregister_hooks(const struct nft_table *table,
 		nf_unregister_hooks(nft_base_chain(chain)->ops, hook_nops);
 }
 
+/* Internal table flags */
+#define NFT_TABLE_INACTIVE	(1 << 15)
+
+static int nft_trans_table_add(struct nft_ctx *ctx, int msg_type)
+{
+	struct nft_trans *trans;
+
+	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_table));
+	if (trans == NULL)
+		return -ENOMEM;
+
+	if (msg_type == NFT_MSG_NEWTABLE)
+		ctx->table->flags |= NFT_TABLE_INACTIVE;
+
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+	return 0;
+}
+
+static int nft_deltable(struct nft_ctx *ctx)
+{
+	int err;
+
+	err = nft_trans_table_add(ctx, NFT_MSG_DELTABLE);
+	if (err < 0)
+		return err;
+
+	list_del_rcu(&ctx->table->list);
+	return err;
+}
+
+static int nft_trans_chain_add(struct nft_ctx *ctx, int msg_type)
+{
+	struct nft_trans *trans;
+
+	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_chain));
+	if (trans == NULL)
+		return -ENOMEM;
+
+	if (msg_type == NFT_MSG_NEWCHAIN)
+		ctx->chain->flags |= NFT_CHAIN_INACTIVE;
+
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+	return 0;
+}
+
+static int nft_delchain(struct nft_ctx *ctx)
+{
+	int err;
+
+	err = nft_trans_chain_add(ctx, NFT_MSG_DELCHAIN);
+	if (err < 0)
+		return err;
+
+	ctx->table->use--;
+	list_del_rcu(&ctx->chain->list);
+
+	return err;
+}
+
+static inline bool
+nft_rule_is_active(struct net *net, const struct nft_rule *rule)
+{
+	return (rule->genmask & (1 << net->nft.gencursor)) == 0;
+}
+
+static inline int gencursor_next(struct net *net)
+{
+	return net->nft.gencursor+1 == 1 ? 1 : 0;
+}
+
+static inline int
+nft_rule_is_active_next(struct net *net, const struct nft_rule *rule)
+{
+	return (rule->genmask & (1 << gencursor_next(net))) == 0;
+}
+
+static inline void
+nft_rule_activate_next(struct net *net, struct nft_rule *rule)
+{
+	/* Now inactive, will be active in the future */
+	rule->genmask = (1 << net->nft.gencursor);
+}
+
+static inline void
+nft_rule_disactivate_next(struct net *net, struct nft_rule *rule)
+{
+	rule->genmask = (1 << gencursor_next(net));
+}
+
+static inline void nft_rule_clear(struct net *net, struct nft_rule *rule)
+{
+	rule->genmask = 0;
+}
+
+static int
+nf_tables_delrule_deactivate(struct nft_ctx *ctx, struct nft_rule *rule)
+{
+	/* You cannot delete the same rule twice */
+	if (nft_rule_is_active_next(ctx->net, rule)) {
+		nft_rule_disactivate_next(ctx->net, rule);
+		ctx->chain->use--;
+		return 0;
+	}
+	return -ENOENT;
+}
+
+static struct nft_trans *nft_trans_rule_add(struct nft_ctx *ctx, int msg_type,
+					    struct nft_rule *rule)
+{
+	struct nft_trans *trans;
+
+	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_rule));
+	if (trans == NULL)
+		return NULL;
+
+	nft_trans_rule(trans) = rule;
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+
+	return trans;
+}
+
+static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
+{
+	struct nft_trans *trans;
+	int err;
+
+	trans = nft_trans_rule_add(ctx, NFT_MSG_DELRULE, rule);
+	if (trans == NULL)
+		return -ENOMEM;
+
+	err = nf_tables_delrule_deactivate(ctx, rule);
+	if (err < 0) {
+		nft_trans_destroy(trans);
+		return err;
+	}
+
+	return 0;
+}
+
+static int nft_delrule_by_chain(struct nft_ctx *ctx)
+{
+	struct nft_rule *rule;
+	int err;
+
+	list_for_each_entry(rule, &ctx->chain->rules, list) {
+		err = nft_delrule(ctx, rule);
+		if (err < 0)
+			return err;
+	}
+	return 0;
+}
+
+/* Internal set flag */
+#define NFT_SET_INACTIVE	(1 << 15)
+
+static int nft_trans_set_add(struct nft_ctx *ctx, int msg_type,
+			     struct nft_set *set)
+{
+	struct nft_trans *trans;
+
+	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_set));
+	if (trans == NULL)
+		return -ENOMEM;
+
+	if (msg_type == NFT_MSG_NEWSET && ctx->nla[NFTA_SET_ID] != NULL) {
+		nft_trans_set_id(trans) =
+			ntohl(nla_get_be32(ctx->nla[NFTA_SET_ID]));
+		set->flags |= NFT_SET_INACTIVE;
+	}
+	nft_trans_set(trans) = set;
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+
+	return 0;
+}
+
+static int nft_delset(struct nft_ctx *ctx, struct nft_set *set)
+{
+	int err;
+
+	err = nft_trans_set_add(ctx, NFT_MSG_DELSET, set);
+	if (err < 0)
+		return err;
+
+	list_del_rcu(&set->list);
+	ctx->table->use--;
+
+	return err;
+}
+
 /*
  * Tables
  */
@@ -318,9 +507,6 @@ done:
 	return skb->len;
 }
 
-/* Internal table flags */
-#define NFT_TABLE_INACTIVE	(1 << 15)
-
 static int nf_tables_gettable(struct sock *nlsk, struct sk_buff *skb,
 			      const struct nlmsghdr *nlh,
 			      const struct nlattr * const nla[])
@@ -452,21 +638,6 @@ err:
 	return ret;
 }
 
-static int nft_trans_table_add(struct nft_ctx *ctx, int msg_type)
-{
-	struct nft_trans *trans;
-
-	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_table));
-	if (trans == NULL)
-		return -ENOMEM;
-
-	if (msg_type == NFT_MSG_NEWTABLE)
-		ctx->table->flags |= NFT_TABLE_INACTIVE;
-
-	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
-	return 0;
-}
-
 static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 			      const struct nlmsghdr *nlh,
 			      const struct nlattr * const nla[])
@@ -544,7 +715,7 @@ static int nf_tables_deltable(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_af_info *afi;
 	struct nft_table *table;
 	struct net *net = sock_net(skb->sk);
-	int family = nfmsg->nfgen_family, err;
+	int family = nfmsg->nfgen_family;
 	struct nft_ctx ctx;
 
 	afi = nf_tables_afinfo_lookup(net, family, false);
@@ -560,12 +731,8 @@ static int nf_tables_deltable(struct sock *nlsk, struct sk_buff *skb,
 		return -EBUSY;
 
 	nft_ctx_init(&ctx, skb, nlh, afi, table, NULL, nla);
-	err = nft_trans_table_add(&ctx, NFT_MSG_DELTABLE);
-	if (err < 0)
-		return err;
 
-	list_del_rcu(&table->list);
-	return 0;
+	return nft_deltable(&ctx);
 }
 
 static void nf_tables_table_destroy(struct nft_ctx *ctx)
@@ -922,21 +1089,6 @@ static void nft_chain_stats_replace(struct nft_base_chain *chain,
 		rcu_assign_pointer(chain->stats, newstats);
 }
 
-static int nft_trans_chain_add(struct nft_ctx *ctx, int msg_type)
-{
-	struct nft_trans *trans;
-
-	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_chain));
-	if (trans == NULL)
-		return -ENOMEM;
-
-	if (msg_type == NFT_MSG_NEWCHAIN)
-		ctx->chain->flags |= NFT_CHAIN_INACTIVE;
-
-	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
-	return 0;
-}
-
 static void nf_tables_chain_destroy(struct nft_chain *chain)
 {
 	BUG_ON(chain->use > 0);
@@ -1183,7 +1335,6 @@ static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nft_ctx ctx;
-	int err;
 
 	afi = nf_tables_afinfo_lookup(net, family, false);
 	if (IS_ERR(afi))
@@ -1204,13 +1355,8 @@ static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
 		return -EBUSY;
 
 	nft_ctx_init(&ctx, skb, nlh, afi, table, chain, nla);
-	err = nft_trans_chain_add(&ctx, NFT_MSG_DELCHAIN);
-	if (err < 0)
-		return err;
 
-	table->use--;
-	list_del_rcu(&chain->list);
-	return 0;
+	return nft_delchain(&ctx);
 }
 
 /*
@@ -1532,41 +1678,6 @@ err:
 	return err;
 }
 
-static inline bool
-nft_rule_is_active(struct net *net, const struct nft_rule *rule)
-{
-	return (rule->genmask & (1 << net->nft.gencursor)) == 0;
-}
-
-static inline int gencursor_next(struct net *net)
-{
-	return net->nft.gencursor+1 == 1 ? 1 : 0;
-}
-
-static inline int
-nft_rule_is_active_next(struct net *net, const struct nft_rule *rule)
-{
-	return (rule->genmask & (1 << gencursor_next(net))) == 0;
-}
-
-static inline void
-nft_rule_activate_next(struct net *net, struct nft_rule *rule)
-{
-	/* Now inactive, will be active in the future */
-	rule->genmask = (1 << net->nft.gencursor);
-}
-
-static inline void
-nft_rule_disactivate_next(struct net *net, struct nft_rule *rule)
-{
-	rule->genmask = (1 << gencursor_next(net));
-}
-
-static inline void nft_rule_clear(struct net *net, struct nft_rule *rule)
-{
-	rule->genmask = 0;
-}
-
 static int nf_tables_dump_rules(struct sk_buff *skb,
 				struct netlink_callback *cb)
 {
@@ -1692,21 +1803,6 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
 	kfree(rule);
 }
 
-static struct nft_trans *nft_trans_rule_add(struct nft_ctx *ctx, int msg_type,
-					    struct nft_rule *rule)
-{
-	struct nft_trans *trans;
-
-	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_rule));
-	if (trans == NULL)
-		return NULL;
-
-	nft_trans_rule(trans) = rule;
-	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
-
-	return trans;
-}
-
 #define NFT_RULE_MAXEXPRS	128
 
 static struct nft_expr_info *info;
@@ -1872,49 +1968,6 @@ err1:
 	return err;
 }
 
-static int
-nf_tables_delrule_deactivate(struct nft_ctx *ctx, struct nft_rule *rule)
-{
-	/* You cannot delete the same rule twice */
-	if (nft_rule_is_active_next(ctx->net, rule)) {
-		nft_rule_disactivate_next(ctx->net, rule);
-		ctx->chain->use--;
-		return 0;
-	}
-	return -ENOENT;
-}
-
-static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
-{
-	struct nft_trans *trans;
-	int err;
-
-	trans = nft_trans_rule_add(ctx, NFT_MSG_DELRULE, rule);
-	if (trans == NULL)
-		return -ENOMEM;
-
-	err = nf_tables_delrule_deactivate(ctx, rule);
-	if (err < 0) {
-		nft_trans_destroy(trans);
-		return err;
-	}
-
-	return 0;
-}
-
-static int nft_delrule_by_chain(struct nft_ctx *ctx)
-{
-	struct nft_rule *rule;
-	int err;
-
-	list_for_each_entry(rule, &ctx->chain->rules, list) {
-		err = nft_delrule(ctx, rule);
-		if (err < 0)
-			return err;
-	}
-	return 0;
-}
-
 static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 			     const struct nlmsghdr *nlh,
 			     const struct nlattr * const nla[])
@@ -2343,8 +2396,6 @@ static int nf_tables_dump_sets_done(struct netlink_callback *cb)
 	return 0;
 }
 
-#define NFT_SET_INACTIVE	(1 << 15)	/* Internal set flag */
-
 static int nf_tables_getset(struct sock *nlsk, struct sk_buff *skb,
 			    const struct nlmsghdr *nlh,
 			    const struct nlattr * const nla[])
@@ -2419,26 +2470,6 @@ static int nf_tables_set_desc_parse(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static int nft_trans_set_add(struct nft_ctx *ctx, int msg_type,
-			     struct nft_set *set)
-{
-	struct nft_trans *trans;
-
-	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_set));
-	if (trans == NULL)
-		return -ENOMEM;
-
-	if (msg_type == NFT_MSG_NEWSET && ctx->nla[NFTA_SET_ID] != NULL) {
-		nft_trans_set_id(trans) =
-			ntohl(nla_get_be32(ctx->nla[NFTA_SET_ID]));
-		set->flags |= NFT_SET_INACTIVE;
-	}
-	nft_trans_set(trans) = set;
-	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
-
-	return 0;
-}
-
 static int nf_tables_newset(struct sock *nlsk, struct sk_buff *skb,
 			    const struct nlmsghdr *nlh,
 			    const struct nlattr * const nla[])
@@ -2632,13 +2663,7 @@ static int nf_tables_delset(struct sock *nlsk, struct sk_buff *skb,
 	if (!list_empty(&set->bindings))
 		return -EBUSY;
 
-	err = nft_trans_set_add(&ctx, NFT_MSG_DELSET, set);
-	if (err < 0)
-		return err;
-
-	list_del_rcu(&set->list);
-	ctx.table->use--;
-	return 0;
+	return nft_delset(&ctx, set);
 }
 
 static int nf_tables_bind_check_setelem(const struct nft_ctx *ctx,

