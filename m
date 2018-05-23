From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 07/18] netfilter: nf_tables: allow chain type to override hook register
Date: Wed, 23 May 2018 20:42:43 +0200
Message-ID: <20180523184254.22599-8-pablo@netfilter.org>
References: <20180523184254.22599-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523184254.22599-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Will be used in followup patch when nat types no longer
use nf_register_net_hook() but will instead register with the nat core.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h       |  8 ++++----
 net/ipv4/netfilter/nft_chain_nat_ipv4.c | 19 +++++++++++++------
 net/ipv6/netfilter/nft_chain_nat_ipv6.c | 20 ++++++++++++++------
 net/netfilter/nf_tables_api.c           | 23 ++++++++++++++++-------
 4 files changed, 47 insertions(+), 23 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 435c9e3b9181..a94fd0c730d6 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -880,8 +880,8 @@ enum nft_chain_types {
  * 	@owner: module owner
  * 	@hook_mask: mask of valid hooks
  * 	@hooks: array of hook functions
- *	@init: chain initialization function
- *	@free: chain release function
+ *	@ops_register: base chain register function
+ *	@ops_unregister: base chain unregister function
  */
 struct nft_chain_type {
 	const char			*name;
@@ -890,8 +890,8 @@ struct nft_chain_type {
 	struct module			*owner;
 	unsigned int			hook_mask;
 	nf_hookfn			*hooks[NF_MAX_HOOKS];
-	int				(*init)(struct nft_ctx *ctx);
-	void				(*free)(struct nft_ctx *ctx);
+	int				(*ops_register)(struct net *net, const struct nf_hook_ops *ops);
+	void				(*ops_unregister)(struct net *net, const struct nf_hook_ops *ops);
 };
 
 int nft_chain_validate_dependency(const struct nft_chain *chain,
diff --git a/net/ipv4/netfilter/nft_chain_nat_ipv4.c b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
index 285baccfbdea..bbcb624b6b81 100644
--- a/net/ipv4/netfilter/nft_chain_nat_ipv4.c
+++ b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
@@ -66,14 +66,21 @@ static unsigned int nft_nat_ipv4_local_fn(void *priv,
 	return nf_nat_ipv4_local_fn(priv, skb, state, nft_nat_do_chain);
 }
 
-static int nft_nat_ipv4_init(struct nft_ctx *ctx)
+static int nft_nat_ipv4_reg(struct net *net, const struct nf_hook_ops *ops)
 {
-	return nf_ct_netns_get(ctx->net, ctx->family);
+	int ret = nf_register_net_hook(net, ops);
+	if (ret == 0) {
+		ret = nf_ct_netns_get(net, NFPROTO_IPV4);
+		if (ret)
+			 nf_unregister_net_hook(net, ops);
+	}
+	return ret;
 }
 
-static void nft_nat_ipv4_free(struct nft_ctx *ctx)
+static void nft_nat_ipv4_unreg(struct net *net, const struct nf_hook_ops *ops)
 {
-	nf_ct_netns_put(ctx->net, ctx->family);
+	nf_unregister_net_hook(net, ops);
+	nf_ct_netns_put(net, NFPROTO_IPV4);
 }
 
 static const struct nft_chain_type nft_chain_nat_ipv4 = {
@@ -91,8 +98,8 @@ static const struct nft_chain_type nft_chain_nat_ipv4 = {
 		[NF_INET_LOCAL_OUT]	= nft_nat_ipv4_local_fn,
 		[NF_INET_LOCAL_IN]	= nft_nat_ipv4_fn,
 	},
-	.init		= nft_nat_ipv4_init,
-	.free		= nft_nat_ipv4_free,
+	.ops_register = nft_nat_ipv4_reg,
+	.ops_unregister = nft_nat_ipv4_unreg,
 };
 
 static int __init nft_chain_nat_init(void)
diff --git a/net/ipv6/netfilter/nft_chain_nat_ipv6.c b/net/ipv6/netfilter/nft_chain_nat_ipv6.c
index 100a6bd1046a..05bcb2c23125 100644
--- a/net/ipv6/netfilter/nft_chain_nat_ipv6.c
+++ b/net/ipv6/netfilter/nft_chain_nat_ipv6.c
@@ -64,14 +64,22 @@ static unsigned int nft_nat_ipv6_local_fn(void *priv,
 	return nf_nat_ipv6_local_fn(priv, skb, state, nft_nat_do_chain);
 }
 
-static int nft_nat_ipv6_init(struct nft_ctx *ctx)
+static int nft_nat_ipv6_reg(struct net *net, const struct nf_hook_ops *ops)
 {
-	return nf_ct_netns_get(ctx->net, ctx->family);
+	int ret = nf_register_net_hook(net, ops);
+	if (ret == 0) {
+		ret = nf_ct_netns_get(net, NFPROTO_IPV6);
+		if (ret)
+			 nf_unregister_net_hook(net, ops);
+	}
+
+	return ret;
 }
 
-static void nft_nat_ipv6_free(struct nft_ctx *ctx)
+static void nft_nat_ipv6_unreg(struct net *net, const struct nf_hook_ops *ops)
 {
-	nf_ct_netns_put(ctx->net, ctx->family);
+	nf_unregister_net_hook(net, ops);
+	nf_ct_netns_put(net, NFPROTO_IPV6);
 }
 
 static const struct nft_chain_type nft_chain_nat_ipv6 = {
@@ -89,8 +97,8 @@ static const struct nft_chain_type nft_chain_nat_ipv6 = {
 		[NF_INET_LOCAL_OUT]	= nft_nat_ipv6_local_fn,
 		[NF_INET_LOCAL_IN]	= nft_nat_ipv6_fn,
 	},
-	.init		= nft_nat_ipv6_init,
-	.free		= nft_nat_ipv6_free,
+	.ops_register		= nft_nat_ipv6_reg,
+	.ops_unregister		= nft_nat_ipv6_unreg,
 };
 
 static int __init nft_chain_nat_ipv6_init(void)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 18bd584fadda..ded54b2abfbc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -129,6 +129,7 @@ static int nf_tables_register_hook(struct net *net,
 				   const struct nft_table *table,
 				   struct nft_chain *chain)
 {
+	const struct nft_base_chain *basechain;
 	struct nf_hook_ops *ops;
 	int ret;
 
@@ -136,7 +137,12 @@ static int nf_tables_register_hook(struct net *net,
 	    !nft_is_base_chain(chain))
 		return 0;
 
-	ops = &nft_base_chain(chain)->ops;
+	basechain = nft_base_chain(chain);
+	ops = &basechain->ops;
+
+	if (basechain->type->ops_register)
+		return basechain->type->ops_register(net, ops);
+
 	ret = nf_register_net_hook(net, ops);
 	if (ret == -EBUSY && nf_tables_allow_nat_conflict(net, ops)) {
 		ops->nat_hook = false;
@@ -151,11 +157,19 @@ static void nf_tables_unregister_hook(struct net *net,
 				      const struct nft_table *table,
 				      struct nft_chain *chain)
 {
+	const struct nft_base_chain *basechain;
+	const struct nf_hook_ops *ops;
+
 	if (table->flags & NFT_TABLE_F_DORMANT ||
 	    !nft_is_base_chain(chain))
 		return;
+	basechain = nft_base_chain(chain);
+	ops = &basechain->ops;
+
+	if (basechain->type->ops_unregister)
+		return basechain->type->ops_unregister(net, ops);
 
-	nf_unregister_net_hook(net, &nft_base_chain(chain)->ops);
+	nf_unregister_net_hook(net, ops);
 }
 
 static int nft_trans_table_add(struct nft_ctx *ctx, int msg_type)
@@ -1262,8 +1276,6 @@ static void nf_tables_chain_destroy(struct nft_ctx *ctx)
 	if (nft_is_base_chain(chain)) {
 		struct nft_base_chain *basechain = nft_base_chain(chain);
 
-		if (basechain->type->free)
-			basechain->type->free(ctx);
 		module_put(basechain->type->owner);
 		free_percpu(basechain->stats);
 		if (basechain->stats)
@@ -1396,9 +1408,6 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		}
 
 		basechain->type = hook.type;
-		if (basechain->type->init)
-			basechain->type->init(ctx);
-
 		chain = &basechain->chain;
 
 		ops		= &basechain->ops;
-- 
2.11.0
