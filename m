From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 41/47] netfilter: nf_tables: enable conntrack if NAT chain is registered
Date: Fri, 30 Mar 2018 13:46:13 +0200
Message-ID: <20180330114619.18797-2-pablo@netfilter.org>
References: <20180330114619.18797-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114619.18797-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Register conntrack hooks if the user adds NAT chains. Users get confused
with the existing behaviour since they will see no packets hitting this
chain until they add the first rule that refers to conntrack.

This patch adds new ->init() and ->free() indirections to chain types
that can be used by NAT chains to invoke the conntrack dependency.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h       |  4 ++++
 net/ipv4/netfilter/nft_chain_nat_ipv4.c | 12 ++++++++++++
 net/ipv6/netfilter/nft_chain_nat_ipv6.c | 12 ++++++++++++
 net/netfilter/nf_tables_api.c           | 24 +++++++++++++++++-------
 4 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 77c3c04c27ac..e26b94a61a99 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -884,6 +884,8 @@ enum nft_chain_types {
  * 	@owner: module owner
  * 	@hook_mask: mask of valid hooks
  * 	@hooks: array of hook functions
+ *	@init: chain initialization function
+ *	@free: chain release function
  */
 struct nft_chain_type {
 	const char			*name;
@@ -892,6 +894,8 @@ struct nft_chain_type {
 	struct module			*owner;
 	unsigned int			hook_mask;
 	nf_hookfn			*hooks[NF_MAX_HOOKS];
+	int				(*init)(struct nft_ctx *ctx);
+	void				(*free)(struct nft_ctx *ctx);
 };
 
 int nft_chain_validate_dependency(const struct nft_chain *chain,
diff --git a/net/ipv4/netfilter/nft_chain_nat_ipv4.c b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
index 9864f5b3279c..b5464a3f253b 100644
--- a/net/ipv4/netfilter/nft_chain_nat_ipv4.c
+++ b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
@@ -67,6 +67,16 @@ static unsigned int nft_nat_ipv4_local_fn(void *priv,
 	return nf_nat_ipv4_local_fn(priv, skb, state, nft_nat_do_chain);
 }
 
+static int nft_nat_ipv4_init(struct nft_ctx *ctx)
+{
+	return nf_ct_netns_get(ctx->net, ctx->family);
+}
+
+static void nft_nat_ipv4_free(struct nft_ctx *ctx)
+{
+	nf_ct_netns_put(ctx->net, ctx->family);
+}
+
 static const struct nft_chain_type nft_chain_nat_ipv4 = {
 	.name		= "nat",
 	.type		= NFT_CHAIN_T_NAT,
@@ -82,6 +92,8 @@ static const struct nft_chain_type nft_chain_nat_ipv4 = {
 		[NF_INET_LOCAL_OUT]	= nft_nat_ipv4_local_fn,
 		[NF_INET_LOCAL_IN]	= nft_nat_ipv4_fn,
 	},
+	.init		= nft_nat_ipv4_init,
+	.free		= nft_nat_ipv4_free,
 };
 
 static int __init nft_chain_nat_init(void)
diff --git a/net/ipv6/netfilter/nft_chain_nat_ipv6.c b/net/ipv6/netfilter/nft_chain_nat_ipv6.c
index c95d9a97d425..3557b114446c 100644
--- a/net/ipv6/netfilter/nft_chain_nat_ipv6.c
+++ b/net/ipv6/netfilter/nft_chain_nat_ipv6.c
@@ -65,6 +65,16 @@ static unsigned int nft_nat_ipv6_local_fn(void *priv,
 	return nf_nat_ipv6_local_fn(priv, skb, state, nft_nat_do_chain);
 }
 
+static int nft_nat_ipv6_init(struct nft_ctx *ctx)
+{
+	return nf_ct_netns_get(ctx->net, ctx->family);
+}
+
+static void nft_nat_ipv6_free(struct nft_ctx *ctx)
+{
+	nf_ct_netns_put(ctx->net, ctx->family);
+}
+
 static const struct nft_chain_type nft_chain_nat_ipv6 = {
 	.name		= "nat",
 	.type		= NFT_CHAIN_T_NAT,
@@ -80,6 +90,8 @@ static const struct nft_chain_type nft_chain_nat_ipv6 = {
 		[NF_INET_LOCAL_OUT]	= nft_nat_ipv6_local_fn,
 		[NF_INET_LOCAL_IN]	= nft_nat_ipv6_fn,
 	},
+	.init		= nft_nat_ipv6_init,
+	.free		= nft_nat_ipv6_free,
 };
 
 static int __init nft_chain_nat_ipv6_init(void)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 97ec1c388bfe..af8b6a7488bd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1211,13 +1211,17 @@ static void nft_chain_stats_replace(struct nft_base_chain *chain,
 		rcu_assign_pointer(chain->stats, newstats);
 }
 
-static void nf_tables_chain_destroy(struct nft_chain *chain)
+static void nf_tables_chain_destroy(struct nft_ctx *ctx)
 {
+	struct nft_chain *chain = ctx->chain;
+
 	BUG_ON(chain->use > 0);
 
 	if (nft_is_base_chain(chain)) {
 		struct nft_base_chain *basechain = nft_base_chain(chain);
 
+		if (basechain->type->free)
+			basechain->type->free(ctx);
 		module_put(basechain->type->owner);
 		free_percpu(basechain->stats);
 		if (basechain->stats)
@@ -1354,6 +1358,9 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		}
 
 		basechain->type = hook.type;
+		if (basechain->type->init)
+			basechain->type->init(ctx);
+
 		chain = &basechain->chain;
 
 		ops		= &basechain->ops;
@@ -1374,6 +1381,8 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		if (chain == NULL)
 			return -ENOMEM;
 	}
+	ctx->chain = chain;
+
 	INIT_LIST_HEAD(&chain->rules);
 	chain->handle = nf_tables_alloc_handle(table);
 	chain->table = table;
@@ -1387,7 +1396,6 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	if (err < 0)
 		goto err1;
 
-	ctx->chain = chain;
 	err = nft_trans_chain_add(ctx, NFT_MSG_NEWCHAIN);
 	if (err < 0)
 		goto err2;
@@ -1399,7 +1407,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 err2:
 	nf_tables_unregister_hook(net, table, chain);
 err1:
-	nf_tables_chain_destroy(chain);
+	nf_tables_chain_destroy(ctx);
 
 	return err;
 }
@@ -5678,7 +5686,7 @@ static void nf_tables_commit_release(struct nft_trans *trans)
 		nf_tables_table_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_DELCHAIN:
-		nf_tables_chain_destroy(trans->ctx.chain);
+		nf_tables_chain_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_DELRULE:
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
@@ -5849,7 +5857,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		nf_tables_table_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_NEWCHAIN:
-		nf_tables_chain_destroy(trans->ctx.chain);
+		nf_tables_chain_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_NEWRULE:
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
@@ -6499,7 +6507,7 @@ int __nft_release_basechain(struct nft_ctx *ctx)
 	}
 	list_del(&ctx->chain->list);
 	ctx->table->use--;
-	nf_tables_chain_destroy(ctx->chain);
+	nf_tables_chain_destroy(ctx);
 
 	return 0;
 }
@@ -6515,6 +6523,7 @@ static void __nft_release_tables(struct net *net)
 	struct nft_set *set, *ns;
 	struct nft_ctx ctx = {
 		.net	= net,
+		.family	= NFPROTO_NETDEV,
 	};
 
 	list_for_each_entry_safe(table, nt, &net->nft.tables, list) {
@@ -6551,9 +6560,10 @@ static void __nft_release_tables(struct net *net)
 			nft_obj_destroy(obj);
 		}
 		list_for_each_entry_safe(chain, nc, &table->chains, list) {
+			ctx.chain = chain;
 			list_del(&chain->list);
 			table->use--;
-			nf_tables_chain_destroy(chain);
+			nf_tables_chain_destroy(&ctx);
 		}
 		list_del(&table->list);
 		nf_tables_table_destroy(&ctx);
-- 
2.11.0
