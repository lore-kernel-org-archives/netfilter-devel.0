From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 32/38] netfilter: nf_tables: use dedicated mutex to guard transactions
Date: Fri, 20 Jul 2018 15:09:00 +0200
Message-ID: <20180720130906.27687-33-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Continue to use nftnl subsys mutex to protect (un)registration of hook types,
expressions and so on, but force batch operations to do their own
locking.

This allows distinct net namespaces to perform transactions in parallel.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netns/nftables.h     |  1 +
 net/netfilter/nf_tables_api.c    | 88 +++++++++++++++++++++++++++++++---------
 net/netfilter/nfnetlink.c        | 10 ++---
 net/netfilter/nft_chain_filter.c |  4 +-
 net/netfilter/nft_dynset.c       |  2 +
 5 files changed, 77 insertions(+), 28 deletions(-)

diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index 94767ea3a490..286fd960896f 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -7,6 +7,7 @@
 struct netns_nftables {
 	struct list_head	tables;
 	struct list_head	commit_list;
+	struct mutex		commit_mutex;
 	unsigned int		base_seq;
 	u8			gencursor;
 	u8			validate_state;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 68436edd9cdf..c0fb2bcd30fe 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -480,12 +480,19 @@ static void nft_request_module(struct net *net, const char *fmt, ...)
 	if (WARN(ret >= MODULE_NAME_LEN, "truncated: '%s' (len %d)", module_name, ret))
 		return;
 
-	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
+	mutex_unlock(&net->nft.commit_mutex);
 	request_module("%s", module_name);
-	nfnl_lock(NFNL_SUBSYS_NFTABLES);
+	mutex_lock(&net->nft.commit_mutex);
 }
 #endif
 
+static void lockdep_nfnl_nft_mutex_not_held(void)
+{
+#ifdef CONFIG_PROVE_LOCKING
+	WARN_ON_ONCE(lockdep_nfnl_is_held(NFNL_SUBSYS_NFTABLES));
+#endif
+}
+
 static const struct nft_chain_type *
 nf_tables_chain_type_lookup(struct net *net, const struct nlattr *nla,
 			    u8 family, bool autoload)
@@ -495,6 +502,8 @@ nf_tables_chain_type_lookup(struct net *net, const struct nlattr *nla,
 	type = __nf_tables_chain_type_lookup(nla, family);
 	if (type != NULL)
 		return type;
+
+	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
 	if (autoload) {
 		nft_request_module(net, "nft-chain-%u-%.*s", family,
@@ -802,6 +811,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	struct nft_ctx ctx;
 	int err;
 
+	lockdep_assert_held(&net->nft.commit_mutex);
 	attr = nla[NFTA_TABLE_NAME];
 	table = nft_table_lookup(net, attr, family, genmask);
 	if (IS_ERR(table)) {
@@ -1042,7 +1052,17 @@ nft_chain_lookup_byhandle(const struct nft_table *table, u64 handle, u8 genmask)
 	return ERR_PTR(-ENOENT);
 }
 
-static struct nft_chain *nft_chain_lookup(struct nft_table *table,
+static bool lockdep_commit_lock_is_held(struct net *net)
+{
+#ifdef CONFIG_PROVE_LOCKING
+	return lockdep_is_held(&net->nft.commit_mutex);
+#else
+	return true;
+#endif
+}
+
+static struct nft_chain *nft_chain_lookup(struct net *net,
+					  struct nft_table *table,
 					  const struct nlattr *nla, u8 genmask)
 {
 	char search[NFT_CHAIN_MAXNAMELEN + 1];
@@ -1055,7 +1075,7 @@ static struct nft_chain *nft_chain_lookup(struct nft_table *table,
 	nla_strlcpy(search, nla, sizeof(search));
 
 	WARN_ON(!rcu_read_lock_held() &&
-		!lockdep_nfnl_is_held(NFNL_SUBSYS_NFTABLES));
+		!lockdep_commit_lock_is_held(net));
 
 	chain = ERR_PTR(-ENOENT);
 	rcu_read_lock();
@@ -1295,7 +1315,7 @@ static int nf_tables_getchain(struct net *net, struct sock *nlsk,
 		return PTR_ERR(table);
 	}
 
-	chain = nft_chain_lookup(table, nla[NFTA_CHAIN_NAME], genmask);
+	chain = nft_chain_lookup(net, table, nla[NFTA_CHAIN_NAME], genmask);
 	if (IS_ERR(chain)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_NAME]);
 		return PTR_ERR(chain);
@@ -1428,6 +1448,9 @@ static int nft_chain_parse_hook(struct net *net,
 	struct net_device *dev;
 	int err;
 
+	lockdep_assert_held(&net->nft.commit_mutex);
+	lockdep_nfnl_nft_mutex_not_held();
+
 	err = nla_parse_nested(ha, NFTA_HOOK_MAX, nla[NFTA_CHAIN_HOOK],
 			       nft_hook_policy, NULL);
 	if (err < 0)
@@ -1662,7 +1685,8 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	    nla[NFTA_CHAIN_NAME]) {
 		struct nft_chain *chain2;
 
-		chain2 = nft_chain_lookup(table, nla[NFTA_CHAIN_NAME], genmask);
+		chain2 = nft_chain_lookup(ctx->net, table,
+					  nla[NFTA_CHAIN_NAME], genmask);
 		if (!IS_ERR(chain2))
 			return -EEXIST;
 	}
@@ -1724,6 +1748,8 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
+	lockdep_assert_held(&net->nft.commit_mutex);
+
 	table = nft_table_lookup(net, nla[NFTA_CHAIN_TABLE], family, genmask);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_TABLE]);
@@ -1742,7 +1768,7 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 		}
 		attr = nla[NFTA_CHAIN_HANDLE];
 	} else {
-		chain = nft_chain_lookup(table, attr, genmask);
+		chain = nft_chain_lookup(net, table, attr, genmask);
 		if (IS_ERR(chain)) {
 			if (PTR_ERR(chain) != -ENOENT) {
 				NL_SET_BAD_ATTR(extack, attr);
@@ -1820,7 +1846,7 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
 		chain = nft_chain_lookup_byhandle(table, handle, genmask);
 	} else {
 		attr = nla[NFTA_CHAIN_NAME];
-		chain = nft_chain_lookup(table, attr, genmask);
+		chain = nft_chain_lookup(net, table, attr, genmask);
 	}
 	if (IS_ERR(chain)) {
 		NL_SET_BAD_ATTR(extack, attr);
@@ -1918,6 +1944,7 @@ static const struct nft_expr_type *nft_expr_type_get(struct net *net,
 	if (type != NULL && try_module_get(type->owner))
 		return type;
 
+	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
 	if (type == NULL) {
 		nft_request_module(net, "nft-expr-%u-%.*s", family,
@@ -2352,7 +2379,7 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 		return PTR_ERR(table);
 	}
 
-	chain = nft_chain_lookup(table, nla[NFTA_RULE_CHAIN], genmask);
+	chain = nft_chain_lookup(net, table, nla[NFTA_RULE_CHAIN], genmask);
 	if (IS_ERR(chain)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_CHAIN]);
 		return PTR_ERR(chain);
@@ -2386,6 +2413,7 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
 {
 	struct nft_expr *expr;
 
+	lockdep_assert_held(&ctx->net->nft.commit_mutex);
 	/*
 	 * Careful: some expressions might not be initialized in case this
 	 * is called on error from nf_tables_newrule().
@@ -2476,6 +2504,8 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	bool create;
 	u64 handle, pos_handle;
 
+	lockdep_assert_held(&net->nft.commit_mutex);
+
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
 	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask);
@@ -2484,7 +2514,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 		return PTR_ERR(table);
 	}
 
-	chain = nft_chain_lookup(table, nla[NFTA_RULE_CHAIN], genmask);
+	chain = nft_chain_lookup(net, table, nla[NFTA_RULE_CHAIN], genmask);
 	if (IS_ERR(chain)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_CHAIN]);
 		return PTR_ERR(chain);
@@ -2684,7 +2714,8 @@ static int nf_tables_delrule(struct net *net, struct sock *nlsk,
 	}
 
 	if (nla[NFTA_RULE_CHAIN]) {
-		chain = nft_chain_lookup(table, nla[NFTA_RULE_CHAIN], genmask);
+		chain = nft_chain_lookup(net, table, nla[NFTA_RULE_CHAIN],
+					 genmask);
 		if (IS_ERR(chain)) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_CHAIN]);
 			return PTR_ERR(chain);
@@ -2776,6 +2807,8 @@ nft_select_set_ops(const struct nft_ctx *ctx,
 	const struct nft_set_type *type;
 	u32 flags = 0;
 
+	lockdep_assert_held(&ctx->net->nft.commit_mutex);
+	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
 	if (list_empty(&nf_tables_set_types)) {
 		nft_request_module(ctx->net, "nft-set");
@@ -4820,6 +4853,7 @@ nft_obj_type_get(struct net *net, u32 objtype)
 	if (type != NULL && try_module_get(type->owner))
 		return type;
 
+	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
 	if (type == NULL) {
 		nft_request_module(net, "nft-obj-%u", objtype);
@@ -5379,6 +5413,7 @@ nft_flowtable_type_get(struct net *net, u8 family)
 	if (type != NULL && try_module_get(type->owner))
 		return type;
 
+	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
 	if (type == NULL) {
 		nft_request_module(net, "nf-flowtable-%u", family);
@@ -6232,9 +6267,9 @@ static void nf_tables_commit_chain_active(struct net *net, struct nft_chain *cha
 	next_genbit = nft_gencursor_next(net);
 
 	g0 = rcu_dereference_protected(chain->rules_gen_0,
-				       lockdep_nfnl_is_held(NFNL_SUBSYS_NFTABLES));
+				       lockdep_commit_lock_is_held(net));
 	g1 = rcu_dereference_protected(chain->rules_gen_1,
-				       lockdep_nfnl_is_held(NFNL_SUBSYS_NFTABLES));
+				       lockdep_commit_lock_is_held(net));
 
 	/* No changes to this chain? */
 	if (chain->rules_next == NULL) {
@@ -6442,6 +6477,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 
 	nf_tables_commit_release(net);
 	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
+	mutex_unlock(&net->nft.commit_mutex);
 
 	return 0;
 }
@@ -6593,12 +6629,25 @@ static void nf_tables_cleanup(struct net *net)
 
 static int nf_tables_abort(struct net *net, struct sk_buff *skb)
 {
-	return __nf_tables_abort(net);
+	int ret = __nf_tables_abort(net);
+
+	mutex_unlock(&net->nft.commit_mutex);
+
+	return ret;
 }
 
 static bool nf_tables_valid_genid(struct net *net, u32 genid)
 {
-	return genid == 0 || net->nft.base_seq == genid;
+	bool genid_ok;
+
+	mutex_lock(&net->nft.commit_mutex);
+
+	genid_ok = genid == 0 || net->nft.base_seq == genid;
+	if (!genid_ok)
+		mutex_unlock(&net->nft.commit_mutex);
+
+	/* else, commit mutex has to be released by commit or abort function */
+	return genid_ok;
 }
 
 static const struct nfnetlink_subsystem nf_tables_subsys = {
@@ -6937,8 +6986,8 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 	case NFT_GOTO:
 		if (!tb[NFTA_VERDICT_CHAIN])
 			return -EINVAL;
-		chain = nft_chain_lookup(ctx->table, tb[NFTA_VERDICT_CHAIN],
-					 genmask);
+		chain = nft_chain_lookup(ctx->net, ctx->table,
+					 tb[NFTA_VERDICT_CHAIN], genmask);
 		if (IS_ERR(chain))
 			return PTR_ERR(chain);
 		if (nft_is_base_chain(chain))
@@ -7183,6 +7232,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 {
 	INIT_LIST_HEAD(&net->nft.tables);
 	INIT_LIST_HEAD(&net->nft.commit_list);
+	mutex_init(&net->nft.commit_mutex);
 	net->nft.base_seq = 1;
 	net->nft.validate_state = NFT_VALIDATE_SKIP;
 
@@ -7191,11 +7241,11 @@ static int __net_init nf_tables_init_net(struct net *net)
 
 static void __net_exit nf_tables_exit_net(struct net *net)
 {
-	nfnl_lock(NFNL_SUBSYS_NFTABLES);
+	mutex_lock(&net->nft.commit_mutex);
 	if (!list_empty(&net->nft.commit_list))
 		__nf_tables_abort(net);
 	__nft_release_tables(net);
-	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
+	mutex_unlock(&net->nft.commit_mutex);
 	WARN_ON_ONCE(!list_empty(&net->nft.tables));
 }
 
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index dd1d7bc23b03..916913454624 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -350,6 +350,8 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return kfree_skb(skb);
 	}
 
+	nfnl_unlock(subsys_id);
+
 	while (skb->len >= nlmsg_total_size(0)) {
 		int msglen, type;
 
@@ -471,13 +473,8 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 done:
 	if (status & NFNL_BATCH_REPLAY) {
-		const struct nfnetlink_subsystem *ss2;
-
-		ss2 = nfnl_dereference_protected(subsys_id);
-		if (ss2 == ss)
-			ss->abort(net, oskb);
+		ss->abort(net, oskb);
 		nfnl_err_reset(&err_list);
-		nfnl_unlock(subsys_id);
 		kfree_skb(skb);
 		module_put(ss->owner);
 		goto replay;
@@ -497,7 +494,6 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 		ss->cleanup(net);
 
 	nfnl_err_deliver(&err_list, oskb);
-	nfnl_unlock(subsys_id);
 	kfree_skb(skb);
 	module_put(ss->owner);
 }
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index d21834bed805..ea5b7c4944f6 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -322,7 +322,7 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	if (!ctx.net)
 		return NOTIFY_DONE;
 
-	nfnl_lock(NFNL_SUBSYS_NFTABLES);
+	mutex_lock(&ctx.net->nft.commit_mutex);
 	list_for_each_entry(table, &ctx.net->nft.tables, list) {
 		if (table->family != NFPROTO_NETDEV)
 			continue;
@@ -337,7 +337,7 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 			nft_netdev_event(event, dev, &ctx);
 		}
 	}
-	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
+	mutex_unlock(&ctx.net->nft.commit_mutex);
 	put_net(ctx.net);
 
 	return NOTIFY_DONE;
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 27d7e4598ab6..81184c244d1a 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -118,6 +118,8 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	u64 timeout;
 	int err;
 
+	lockdep_assert_held(&ctx->net->nft.commit_mutex);
+
 	if (tb[NFTA_DYNSET_SET_NAME] == NULL ||
 	    tb[NFTA_DYNSET_OP] == NULL ||
 	    tb[NFTA_DYNSET_SREG_KEY] == NULL)
-- 
2.11.0
