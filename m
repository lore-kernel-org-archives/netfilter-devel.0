From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/20] netfilter: nf_tables: use call_rcu in netlink dumps
Date: Sat,  2 Jun 2018 02:22:49 +0200
Message-ID: <20180602002259.4024-11-pablo@netfilter.org>
References: <20180602002259.4024-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602002259.4024-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

We can make all dumps and lookups lockless.

Dumps currently only hold the nfnl mutex on the dump request itself.
Dumps can span multiple syscalls, dump continuation doesn't acquire the
nfnl mutex anywhere, i.e. the dump callbacks in nf_tables already use
rcu and never rely on nfnl mutex being held.

So, just switch all dumpers to rcu.

This requires taking a module reference before dropping the rcu lock
so rmmod is blocked, we also need to hold module reference over
the entire dump operation sequence. netlink already supports this
via the .module member in the netlink_dump_control struct.

For the non-dump case (i.e. lookup of a specific tables, chains, etc),
we need to swtich to _rcu list iteration primitive and make sure we
use GFP_ATOMIC.

This patch also adds the new nft_netlink_dump_start_rcu() helper that
takes care of the get_ref, drop-rcu-lock,start dump,
get-rcu-lock,put-ref sequence.

The helper will be reused for all dumps.

Rationale in all dump requests is:

 - use the nft_netlink_dump_start_rcu helper added in first patch
 - use GFP_ATOMIC and rcu list iteration
 - switch to .call_rcu

... thus making all dumps in nf_tables not depend on the
nfnl mutex anymore.

In the nf_tables_getgen: This callback just fetches the current base
sequence, there is no need to serialize this with nfnl nft mutex.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 111 +++++++++++++++++++++++++++---------------
 1 file changed, 72 insertions(+), 39 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8f04bfc41bf9..3b2ad96a9a05 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -373,7 +373,7 @@ static struct nft_table *nft_table_lookup(const struct net *net,
 	if (nla == NULL)
 		return ERR_PTR(-EINVAL);
 
-	list_for_each_entry(table, &net->nft.tables, list) {
+	list_for_each_entry_rcu(table, &net->nft.tables, list) {
 		if (!nla_strcmp(nla, table->name) &&
 		    table->family == family &&
 		    nft_active_genmask(table, genmask))
@@ -546,6 +546,24 @@ static int nf_tables_dump_tables(struct sk_buff *skb,
 	return skb->len;
 }
 
+static int nft_netlink_dump_start_rcu(struct sock *nlsk, struct sk_buff *skb,
+				      const struct nlmsghdr *nlh,
+				      struct netlink_dump_control *c)
+{
+	int err;
+
+	if (!try_module_get(THIS_MODULE))
+		return -EINVAL;
+
+	rcu_read_unlock();
+	err = netlink_dump_start(nlsk, skb, nlh, c);
+	rcu_read_lock();
+	module_put(THIS_MODULE);
+
+	return err;
+}
+
+/* called with rcu_read_lock held */
 static int nf_tables_gettable(struct net *net, struct sock *nlsk,
 			      struct sk_buff *skb, const struct nlmsghdr *nlh,
 			      const struct nlattr * const nla[],
@@ -561,8 +579,10 @@ static int nf_tables_gettable(struct net *net, struct sock *nlsk,
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = nf_tables_dump_tables,
+			.module = THIS_MODULE,
 		};
-		return netlink_dump_start(nlsk, skb, nlh, &c);
+
+		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
 	}
 
 	table = nft_table_lookup(net, nla[NFTA_TABLE_NAME], family, genmask);
@@ -571,7 +591,7 @@ static int nf_tables_gettable(struct net *net, struct sock *nlsk,
 		return PTR_ERR(table);
 	}
 
-	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb2)
 		return -ENOMEM;
 
@@ -933,7 +953,7 @@ static struct nft_chain *nft_chain_lookup(const struct nft_table *table,
 	if (nla == NULL)
 		return ERR_PTR(-EINVAL);
 
-	list_for_each_entry(chain, &table->chains, list) {
+	list_for_each_entry_rcu(chain, &table->chains, list) {
 		if (!nla_strcmp(nla, chain->name) &&
 		    nft_active_genmask(chain, genmask))
 			return chain;
@@ -1135,6 +1155,7 @@ static int nf_tables_dump_chains(struct sk_buff *skb,
 	return skb->len;
 }
 
+/* called with rcu_read_lock held */
 static int nf_tables_getchain(struct net *net, struct sock *nlsk,
 			      struct sk_buff *skb, const struct nlmsghdr *nlh,
 			      const struct nlattr * const nla[],
@@ -1151,8 +1172,10 @@ static int nf_tables_getchain(struct net *net, struct sock *nlsk,
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = nf_tables_dump_chains,
+			.module = THIS_MODULE,
 		};
-		return netlink_dump_start(nlsk, skb, nlh, &c);
+
+		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
 	}
 
 	table = nft_table_lookup(net, nla[NFTA_CHAIN_TABLE], family, genmask);
@@ -1167,7 +1190,7 @@ static int nf_tables_getchain(struct net *net, struct sock *nlsk,
 		return PTR_ERR(chain);
 	}
 
-	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb2)
 		return -ENOMEM;
 
@@ -1969,7 +1992,7 @@ static struct nft_rule *__nft_rule_lookup(const struct nft_chain *chain,
 	struct nft_rule *rule;
 
 	// FIXME: this sucks
-	list_for_each_entry(rule, &chain->rules, list) {
+	list_for_each_entry_rcu(rule, &chain->rules, list) {
 		if (handle == rule->handle)
 			return rule;
 	}
@@ -2165,6 +2188,7 @@ static int nf_tables_dump_rules_done(struct netlink_callback *cb)
 	return 0;
 }
 
+/* called with rcu_read_lock held */
 static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 			     struct sk_buff *skb, const struct nlmsghdr *nlh,
 			     const struct nlattr * const nla[],
@@ -2183,18 +2207,19 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 		struct netlink_dump_control c = {
 			.dump = nf_tables_dump_rules,
 			.done = nf_tables_dump_rules_done,
+			.module = THIS_MODULE,
 		};
 
 		if (nla[NFTA_RULE_TABLE] || nla[NFTA_RULE_CHAIN]) {
 			struct nft_rule_dump_ctx *ctx;
 
-			ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+			ctx = kzalloc(sizeof(*ctx), GFP_ATOMIC);
 			if (!ctx)
 				return -ENOMEM;
 
 			if (nla[NFTA_RULE_TABLE]) {
 				ctx->table = nla_strdup(nla[NFTA_RULE_TABLE],
-							GFP_KERNEL);
+							GFP_ATOMIC);
 				if (!ctx->table) {
 					kfree(ctx);
 					return -ENOMEM;
@@ -2202,7 +2227,7 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 			}
 			if (nla[NFTA_RULE_CHAIN]) {
 				ctx->chain = nla_strdup(nla[NFTA_RULE_CHAIN],
-							GFP_KERNEL);
+							GFP_ATOMIC);
 				if (!ctx->chain) {
 					kfree(ctx->table);
 					kfree(ctx);
@@ -2212,7 +2237,7 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 			c.data = ctx;
 		}
 
-		return netlink_dump_start(nlsk, skb, nlh, &c);
+		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
 	}
 
 	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask);
@@ -2233,7 +2258,7 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 		return PTR_ERR(rule);
 	}
 
-	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb2)
 		return -ENOMEM;
 
@@ -2704,7 +2729,7 @@ static struct nft_set *nft_set_lookup(const struct nft_table *table,
 	if (nla == NULL)
 		return ERR_PTR(-EINVAL);
 
-	list_for_each_entry(set, &table->sets, list) {
+	list_for_each_entry_rcu(set, &table->sets, list) {
 		if (!nla_strcmp(nla, set->name) &&
 		    nft_active_genmask(set, genmask))
 			return set;
@@ -3009,6 +3034,7 @@ static int nf_tables_dump_sets_done(struct netlink_callback *cb)
 	return 0;
 }
 
+/* called with rcu_read_lock held */
 static int nf_tables_getset(struct net *net, struct sock *nlsk,
 			    struct sk_buff *skb, const struct nlmsghdr *nlh,
 			    const struct nlattr * const nla[],
@@ -3031,17 +3057,18 @@ static int nf_tables_getset(struct net *net, struct sock *nlsk,
 		struct netlink_dump_control c = {
 			.dump = nf_tables_dump_sets,
 			.done = nf_tables_dump_sets_done,
+			.module = THIS_MODULE,
 		};
 		struct nft_ctx *ctx_dump;
 
-		ctx_dump = kmalloc(sizeof(*ctx_dump), GFP_KERNEL);
+		ctx_dump = kmalloc(sizeof(*ctx_dump), GFP_ATOMIC);
 		if (ctx_dump == NULL)
 			return -ENOMEM;
 
 		*ctx_dump = ctx;
 		c.data = ctx_dump;
 
-		return netlink_dump_start(nlsk, skb, nlh, &c);
+		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
 	}
 
 	/* Only accept unspec with dump */
@@ -3054,7 +3081,7 @@ static int nf_tables_getset(struct net *net, struct sock *nlsk,
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
-	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (skb2 == NULL)
 		return -ENOMEM;
 
@@ -3795,7 +3822,7 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	ext = nft_set_elem_ext(set, &elem);
 
 	err = -ENOMEM;
-	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (skb == NULL)
 		goto err1;
 
@@ -3817,6 +3844,7 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	return err == -EAGAIN ? -ENOBUFS : err;
 }
 
+/* called with rcu_read_lock held */
 static int nf_tables_getsetelem(struct net *net, struct sock *nlsk,
 				struct sk_buff *skb, const struct nlmsghdr *nlh,
 				const struct nlattr * const nla[],
@@ -3841,10 +3869,11 @@ static int nf_tables_getsetelem(struct net *net, struct sock *nlsk,
 		struct netlink_dump_control c = {
 			.dump = nf_tables_dump_set,
 			.done = nf_tables_dump_set_done,
+			.module = THIS_MODULE,
 		};
 		struct nft_set_dump_ctx *dump_ctx;
 
-		dump_ctx = kmalloc(sizeof(*dump_ctx), GFP_KERNEL);
+		dump_ctx = kmalloc(sizeof(*dump_ctx), GFP_ATOMIC);
 		if (!dump_ctx)
 			return -ENOMEM;
 
@@ -3852,7 +3881,7 @@ static int nf_tables_getsetelem(struct net *net, struct sock *nlsk,
 		dump_ctx->ctx = ctx;
 
 		c.data = dump_ctx;
-		return netlink_dump_start(nlsk, skb, nlh, &c);
+		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
 	}
 
 	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
@@ -4475,7 +4504,7 @@ struct nft_object *nft_obj_lookup(const struct nft_table *table,
 {
 	struct nft_object *obj;
 
-	list_for_each_entry(obj, &table->objects, list) {
+	list_for_each_entry_rcu(obj, &table->objects, list) {
 		if (!nla_strcmp(nla, obj->name) &&
 		    objtype == obj->ops->type->type &&
 		    nft_active_genmask(obj, genmask))
@@ -4805,12 +4834,12 @@ nft_obj_filter_alloc(const struct nlattr * const nla[])
 {
 	struct nft_obj_filter *filter;
 
-	filter = kzalloc(sizeof(*filter), GFP_KERNEL);
+	filter = kzalloc(sizeof(*filter), GFP_ATOMIC);
 	if (!filter)
 		return ERR_PTR(-ENOMEM);
 
 	if (nla[NFTA_OBJ_TABLE]) {
-		filter->table = nla_strdup(nla[NFTA_OBJ_TABLE], GFP_KERNEL);
+		filter->table = nla_strdup(nla[NFTA_OBJ_TABLE], GFP_ATOMIC);
 		if (!filter->table) {
 			kfree(filter);
 			return ERR_PTR(-ENOMEM);
@@ -4822,6 +4851,7 @@ nft_obj_filter_alloc(const struct nlattr * const nla[])
 	return filter;
 }
 
+/* called with rcu_read_lock held */
 static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 			    struct sk_buff *skb, const struct nlmsghdr *nlh,
 			    const struct nlattr * const nla[],
@@ -4841,6 +4871,7 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 		struct netlink_dump_control c = {
 			.dump = nf_tables_dump_obj,
 			.done = nf_tables_dump_obj_done,
+			.module = THIS_MODULE,
 		};
 
 		if (nla[NFTA_OBJ_TABLE] ||
@@ -4853,7 +4884,7 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 
 			c.data = filter;
 		}
-		return netlink_dump_start(nlsk, skb, nlh, &c);
+		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
 	}
 
 	if (!nla[NFTA_OBJ_NAME] ||
@@ -4873,7 +4904,7 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 		return PTR_ERR(obj);
 	}
 
-	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb2)
 		return -ENOMEM;
 
@@ -5018,7 +5049,7 @@ struct nft_flowtable *nft_flowtable_lookup(const struct nft_table *table,
 {
 	struct nft_flowtable *flowtable;
 
-	list_for_each_entry(flowtable, &table->flowtables, list) {
+	list_for_each_entry_rcu(flowtable, &table->flowtables, list) {
 		if (!nla_strcmp(nla, flowtable->name) &&
 		    nft_active_genmask(flowtable, genmask))
 			return flowtable;
@@ -5479,13 +5510,13 @@ nft_flowtable_filter_alloc(const struct nlattr * const nla[])
 {
 	struct nft_flowtable_filter *filter;
 
-	filter = kzalloc(sizeof(*filter), GFP_KERNEL);
+	filter = kzalloc(sizeof(*filter), GFP_ATOMIC);
 	if (!filter)
 		return ERR_PTR(-ENOMEM);
 
 	if (nla[NFTA_FLOWTABLE_TABLE]) {
 		filter->table = nla_strdup(nla[NFTA_FLOWTABLE_TABLE],
-					   GFP_KERNEL);
+					   GFP_ATOMIC);
 		if (!filter->table) {
 			kfree(filter);
 			return ERR_PTR(-ENOMEM);
@@ -5494,6 +5525,7 @@ nft_flowtable_filter_alloc(const struct nlattr * const nla[])
 	return filter;
 }
 
+/* called with rcu_read_lock held */
 static int nf_tables_getflowtable(struct net *net, struct sock *nlsk,
 				  struct sk_buff *skb,
 				  const struct nlmsghdr *nlh,
@@ -5512,6 +5544,7 @@ static int nf_tables_getflowtable(struct net *net, struct sock *nlsk,
 		struct netlink_dump_control c = {
 			.dump = nf_tables_dump_flowtable,
 			.done = nf_tables_dump_flowtable_done,
+			.module = THIS_MODULE,
 		};
 
 		if (nla[NFTA_FLOWTABLE_TABLE]) {
@@ -5523,7 +5556,7 @@ static int nf_tables_getflowtable(struct net *net, struct sock *nlsk,
 
 			c.data = filter;
 		}
-		return netlink_dump_start(nlsk, skb, nlh, &c);
+		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
 	}
 
 	if (!nla[NFTA_FLOWTABLE_NAME])
@@ -5539,7 +5572,7 @@ static int nf_tables_getflowtable(struct net *net, struct sock *nlsk,
 	if (IS_ERR(flowtable))
 		return PTR_ERR(flowtable);
 
-	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb2)
 		return -ENOMEM;
 
@@ -5703,7 +5736,7 @@ static int nf_tables_getgen(struct net *net, struct sock *nlsk,
 	struct sk_buff *skb2;
 	int err;
 
-	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (skb2 == NULL)
 		return -ENOMEM;
 
@@ -5725,7 +5758,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_table_policy,
 	},
 	[NFT_MSG_GETTABLE] = {
-		.call		= nf_tables_gettable,
+		.call_rcu	= nf_tables_gettable,
 		.attr_count	= NFTA_TABLE_MAX,
 		.policy		= nft_table_policy,
 	},
@@ -5740,7 +5773,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_chain_policy,
 	},
 	[NFT_MSG_GETCHAIN] = {
-		.call		= nf_tables_getchain,
+		.call_rcu	= nf_tables_getchain,
 		.attr_count	= NFTA_CHAIN_MAX,
 		.policy		= nft_chain_policy,
 	},
@@ -5755,7 +5788,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_rule_policy,
 	},
 	[NFT_MSG_GETRULE] = {
-		.call		= nf_tables_getrule,
+		.call_rcu	= nf_tables_getrule,
 		.attr_count	= NFTA_RULE_MAX,
 		.policy		= nft_rule_policy,
 	},
@@ -5770,7 +5803,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_set_policy,
 	},
 	[NFT_MSG_GETSET] = {
-		.call		= nf_tables_getset,
+		.call_rcu	= nf_tables_getset,
 		.attr_count	= NFTA_SET_MAX,
 		.policy		= nft_set_policy,
 	},
@@ -5785,7 +5818,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_set_elem_list_policy,
 	},
 	[NFT_MSG_GETSETELEM] = {
-		.call		= nf_tables_getsetelem,
+		.call_rcu	= nf_tables_getsetelem,
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
 	},
@@ -5795,7 +5828,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_set_elem_list_policy,
 	},
 	[NFT_MSG_GETGEN] = {
-		.call		= nf_tables_getgen,
+		.call_rcu	= nf_tables_getgen,
 	},
 	[NFT_MSG_NEWOBJ] = {
 		.call_batch	= nf_tables_newobj,
@@ -5803,7 +5836,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_obj_policy,
 	},
 	[NFT_MSG_GETOBJ] = {
-		.call		= nf_tables_getobj,
+		.call_rcu	= nf_tables_getobj,
 		.attr_count	= NFTA_OBJ_MAX,
 		.policy		= nft_obj_policy,
 	},
@@ -5813,7 +5846,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_obj_policy,
 	},
 	[NFT_MSG_GETOBJ_RESET] = {
-		.call		= nf_tables_getobj,
+		.call_rcu	= nf_tables_getobj,
 		.attr_count	= NFTA_OBJ_MAX,
 		.policy		= nft_obj_policy,
 	},
@@ -5823,7 +5856,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_flowtable_policy,
 	},
 	[NFT_MSG_GETFLOWTABLE] = {
-		.call		= nf_tables_getflowtable,
+		.call_rcu	= nf_tables_getflowtable,
 		.attr_count	= NFTA_FLOWTABLE_MAX,
 		.policy		= nft_flowtable_policy,
 	},
-- 
2.11.0
