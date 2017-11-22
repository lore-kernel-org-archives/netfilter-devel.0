From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 5/5] netfilter: nf_tables: remove multihook chains and families
Date: Wed, 22 Nov 2017 15:02:50 +0100
Message-ID: <20171122140250.14798-6-pablo@netfilter.org>
References: <20171122140250.14798-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45786 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751324AbdKVODe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 09:03:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 74FCD1D94C0
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:03:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2B11ADA912
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:03:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 929B9BAC2D
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:02:57 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 45C05403DFA0
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:02:57 +0100 (CET)
In-Reply-To: <20171122140250.14798-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since NFPROTO_INET is handled from the core, we don't need to maintain
extra infrastructure in nf_tables to handle the double hook
registration, one for IPv4 and another for IPv6.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h       |  9 +--
 net/bridge/netfilter/nf_tables_bridge.c |  1 -
 net/ipv4/netfilter/nf_tables_arp.c      |  1 -
 net/ipv4/netfilter/nf_tables_ipv4.c     |  1 -
 net/ipv6/netfilter/nf_tables_ipv6.c     |  1 -
 net/netfilter/nf_tables_api.c           | 97 ++++++++++++++-------------------
 net/netfilter/nf_tables_inet.c          |  1 -
 net/netfilter/nf_tables_netdev.c        |  3 +-
 net/netfilter/nft_compat.c              |  8 +--
 9 files changed, 46 insertions(+), 76 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index fecc6112c768..4d744c2c45c6 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -905,8 +905,6 @@ struct nft_stats {
 	struct u64_stats_sync	syncp;
 };
 
-#define NFT_HOOK_OPS_MAX		2
-
 /**
  *	struct nft_base_chain - nf_tables base chain
  *
@@ -918,7 +916,7 @@ struct nft_stats {
  *	@dev_name: device name that this base chain is attached to (if any)
  */
 struct nft_base_chain {
-	struct nf_hook_ops		ops[NFT_HOOK_OPS_MAX];
+	struct nf_hook_ops		ops;
 	const struct nf_chain_type	*type;
 	u8				policy;
 	u8				flags;
@@ -979,8 +977,6 @@ enum nft_af_flags {
  *	@owner: module owner
  *	@tables: used internally
  *	@flags: family flags
- *	@nops: number of hook ops in this family
- *	@hook_ops_init: initialization function for chain hook ops
  *	@hooks: hookfn overrides for packet validation
  */
 struct nft_af_info {
@@ -990,9 +986,6 @@ struct nft_af_info {
 	struct module			*owner;
 	struct list_head		tables;
 	u32				flags;
-	unsigned int			nops;
-	void				(*hook_ops_init)(struct nf_hook_ops *,
-							 unsigned int);
 	nf_hookfn			*hooks[NF_MAX_HOOKS];
 };
 
diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index 97afdc0744e6..2dfe500fa74a 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -44,7 +44,6 @@ static struct nft_af_info nft_af_bridge __read_mostly = {
 	.family		= NFPROTO_BRIDGE,
 	.nhooks		= NF_BR_NUMHOOKS,
 	.owner		= THIS_MODULE,
-	.nops		= 1,
 	.hooks		= {
 		[NF_BR_PRE_ROUTING]	= nft_do_chain_bridge,
 		[NF_BR_LOCAL_IN]	= nft_do_chain_bridge,
diff --git a/net/ipv4/netfilter/nf_tables_arp.c b/net/ipv4/netfilter/nf_tables_arp.c
index 4bbc273b45e8..981f7e283fca 100644
--- a/net/ipv4/netfilter/nf_tables_arp.c
+++ b/net/ipv4/netfilter/nf_tables_arp.c
@@ -30,7 +30,6 @@ static struct nft_af_info nft_af_arp __read_mostly = {
 	.family		= NFPROTO_ARP,
 	.nhooks		= NF_ARP_NUMHOOKS,
 	.owner		= THIS_MODULE,
-	.nops		= 1,
 	.hooks		= {
 		[NF_ARP_IN]		= nft_do_chain_arp,
 		[NF_ARP_OUT]		= nft_do_chain_arp,
diff --git a/net/ipv4/netfilter/nf_tables_ipv4.c b/net/ipv4/netfilter/nf_tables_ipv4.c
index d731a1c2e00a..69c58318e387 100644
--- a/net/ipv4/netfilter/nf_tables_ipv4.c
+++ b/net/ipv4/netfilter/nf_tables_ipv4.c
@@ -48,7 +48,6 @@ static struct nft_af_info nft_af_ipv4 __read_mostly = {
 	.family		= NFPROTO_IPV4,
 	.nhooks		= NF_INET_NUMHOOKS,
 	.owner		= THIS_MODULE,
-	.nops		= 1,
 	.hooks		= {
 		[NF_INET_LOCAL_IN]	= nft_do_chain_ipv4,
 		[NF_INET_LOCAL_OUT]	= nft_ipv4_output,
diff --git a/net/ipv6/netfilter/nf_tables_ipv6.c b/net/ipv6/netfilter/nf_tables_ipv6.c
index b6699ffbd430..2948b57dfd04 100644
--- a/net/ipv6/netfilter/nf_tables_ipv6.c
+++ b/net/ipv6/netfilter/nf_tables_ipv6.c
@@ -45,7 +45,6 @@ static struct nft_af_info nft_af_ipv6 __read_mostly = {
 	.family		= NFPROTO_IPV6,
 	.nhooks		= NF_INET_NUMHOOKS,
 	.owner		= THIS_MODULE,
-	.nops		= 1,
 	.hooks		= {
 		[NF_INET_LOCAL_IN]	= nft_do_chain_ipv6,
 		[NF_INET_LOCAL_OUT]	= nft_ipv6_output,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 10798b357481..3e6c201251cd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -139,29 +139,26 @@ static void nft_trans_destroy(struct nft_trans *trans)
 	kfree(trans);
 }
 
-static int nf_tables_register_hooks(struct net *net,
-				    const struct nft_table *table,
-				    struct nft_chain *chain,
-				    unsigned int hook_nops)
+static int nf_tables_register_hook(struct net *net,
+				   const struct nft_table *table,
+				   struct nft_chain *chain)
 {
 	if (table->flags & NFT_TABLE_F_DORMANT ||
 	    !nft_is_base_chain(chain))
 		return 0;
 
-	return nf_register_net_hooks(net, nft_base_chain(chain)->ops,
-				     hook_nops);
+	return nf_register_net_hook(net, &nft_base_chain(chain)->ops);
 }
 
-static void nf_tables_unregister_hooks(struct net *net,
-				       const struct nft_table *table,
-				       struct nft_chain *chain,
-				       unsigned int hook_nops)
+static void nf_tables_unregister_hook(struct net *net,
+				      const struct nft_table *table,
+				      struct nft_chain *chain)
 {
 	if (table->flags & NFT_TABLE_F_DORMANT ||
 	    !nft_is_base_chain(chain))
 		return;
 
-	nf_unregister_net_hooks(net, nft_base_chain(chain)->ops, hook_nops);
+	nf_unregister_net_hook(net, &nft_base_chain(chain)->ops);
 }
 
 static int nft_trans_table_add(struct nft_ctx *ctx, int msg_type)
@@ -595,8 +592,7 @@ static void _nf_tables_table_disable(struct net *net,
 		if (cnt && i++ == cnt)
 			break;
 
-		nf_unregister_net_hooks(net, nft_base_chain(chain)->ops,
-					afi->nops);
+		nf_unregister_net_hook(net, &nft_base_chain(chain)->ops);
 	}
 }
 
@@ -613,8 +609,7 @@ static int nf_tables_table_enable(struct net *net,
 		if (!nft_is_base_chain(chain))
 			continue;
 
-		err = nf_register_net_hooks(net, nft_base_chain(chain)->ops,
-					    afi->nops);
+		err = nf_register_net_hook(net, &nft_base_chain(chain)->ops);
 		if (err < 0)
 			goto err;
 
@@ -1026,7 +1021,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 
 	if (nft_is_base_chain(chain)) {
 		const struct nft_base_chain *basechain = nft_base_chain(chain);
-		const struct nf_hook_ops *ops = &basechain->ops[0];
+		const struct nf_hook_ops *ops = &basechain->ops;
 		struct nlattr *nest;
 
 		nest = nla_nest_start(skb, NFTA_CHAIN_HOOK);
@@ -1252,8 +1247,8 @@ static void nf_tables_chain_destroy(struct nft_chain *chain)
 		free_percpu(basechain->stats);
 		if (basechain->stats)
 			static_branch_dec(&nft_counters_enabled);
-		if (basechain->ops[0].dev != NULL)
-			dev_put(basechain->ops[0].dev);
+		if (basechain->ops.dev != NULL)
+			dev_put(basechain->ops.dev);
 		kfree(chain->name);
 		kfree(basechain);
 	} else {
@@ -1349,7 +1344,6 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	struct nft_stats __percpu *stats;
 	struct net *net = ctx->net;
 	struct nft_chain *chain;
-	unsigned int i;
 	int err;
 
 	if (table->use == UINT_MAX)
@@ -1388,19 +1382,15 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		basechain->type = hook.type;
 		chain = &basechain->chain;
 
-		for (i = 0; i < afi->nops; i++) {
-			ops = &basechain->ops[i];
-			ops->pf		= family;
-			ops->hooknum	= hook.num;
-			ops->priority	= hook.priority;
-			ops->priv	= chain;
-			ops->hook	= afi->hooks[ops->hooknum];
-			ops->dev	= hook.dev;
-			if (hookfn)
-				ops->hook = hookfn;
-			if (afi->hook_ops_init)
-				afi->hook_ops_init(ops, i);
-		}
+		ops		= &basechain->ops;
+		ops->pf		= family;
+		ops->hooknum	= hook.num;
+		ops->priority	= hook.priority;
+		ops->priv	= chain;
+		ops->hook	= afi->hooks[ops->hooknum];
+		ops->dev	= hook.dev;
+		if (hookfn)
+			ops->hook = hookfn;
 
 		chain->flags |= NFT_BASE_CHAIN;
 		basechain->policy = policy;
@@ -1418,7 +1408,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		goto err1;
 	}
 
-	err = nf_tables_register_hooks(net, table, chain, afi->nops);
+	err = nf_tables_register_hook(net, table, chain);
 	if (err < 0)
 		goto err1;
 
@@ -1432,7 +1422,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 	return 0;
 err2:
-	nf_tables_unregister_hooks(net, table, chain, afi->nops);
+	nf_tables_unregister_hook(net, table, chain);
 err1:
 	nf_tables_chain_destroy(chain);
 
@@ -1445,14 +1435,13 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_table *table = ctx->table;
 	struct nft_chain *chain = ctx->chain;
-	struct nft_af_info *afi = ctx->afi;
 	struct nft_base_chain *basechain;
 	struct nft_stats *stats = NULL;
 	struct nft_chain_hook hook;
 	const struct nlattr *name;
 	struct nf_hook_ops *ops;
 	struct nft_trans *trans;
-	int err, i;
+	int err;
 
 	if (nla[NFTA_CHAIN_HOOK]) {
 		if (!nft_is_base_chain(chain))
@@ -1469,14 +1458,12 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			return -EBUSY;
 		}
 
-		for (i = 0; i < afi->nops; i++) {
-			ops = &basechain->ops[i];
-			if (ops->hooknum != hook.num ||
-			    ops->priority != hook.priority ||
-			    ops->dev != hook.dev) {
-				nft_chain_release_hook(&hook);
-				return -EBUSY;
-			}
+		ops = &basechain->ops;
+		if (ops->hooknum != hook.num ||
+		    ops->priority != hook.priority ||
+		    ops->dev != hook.dev) {
+			nft_chain_release_hook(&hook);
+			return -EBUSY;
 		}
 		nft_chain_release_hook(&hook);
 	}
@@ -5127,10 +5114,9 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_DELCHAIN:
 			list_del_rcu(&trans->ctx.chain->list);
 			nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN);
-			nf_tables_unregister_hooks(trans->ctx.net,
-						   trans->ctx.table,
-						   trans->ctx.chain,
-						   trans->ctx.afi->nops);
+			nf_tables_unregister_hook(trans->ctx.net,
+						  trans->ctx.table,
+						  trans->ctx.chain);
 			break;
 		case NFT_MSG_NEWRULE:
 			nft_clear(trans->ctx.net, nft_trans_rule(trans));
@@ -5267,10 +5253,9 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb)
 			} else {
 				trans->ctx.table->use--;
 				list_del_rcu(&trans->ctx.chain->list);
-				nf_tables_unregister_hooks(trans->ctx.net,
-							   trans->ctx.table,
-							   trans->ctx.chain,
-							   trans->ctx.afi->nops);
+				nf_tables_unregister_hook(trans->ctx.net,
+							  trans->ctx.table,
+							  trans->ctx.chain);
 			}
 			break;
 		case NFT_MSG_DELCHAIN:
@@ -5371,7 +5356,7 @@ int nft_chain_validate_hooks(const struct nft_chain *chain,
 	if (nft_is_base_chain(chain)) {
 		basechain = nft_base_chain(chain);
 
-		if ((1 << basechain->ops[0].hooknum) & hook_flags)
+		if ((1 << basechain->ops.hooknum) & hook_flags)
 			return 0;
 
 		return -EOPNOTSUPP;
@@ -5859,8 +5844,7 @@ int __nft_release_basechain(struct nft_ctx *ctx)
 
 	BUG_ON(!nft_is_base_chain(ctx->chain));
 
-	nf_tables_unregister_hooks(ctx->net, ctx->chain->table, ctx->chain,
-				   ctx->afi->nops);
+	nf_tables_unregister_hook(ctx->net, ctx->chain->table, ctx->chain);
 	list_for_each_entry_safe(rule, nr, &ctx->chain->rules, list) {
 		list_del(&rule->list);
 		ctx->chain->use--;
@@ -5889,8 +5873,7 @@ static void __nft_release_afinfo(struct net *net, struct nft_af_info *afi)
 
 	list_for_each_entry_safe(table, nt, &afi->tables, list) {
 		list_for_each_entry(chain, &table->chains, list)
-			nf_tables_unregister_hooks(net, table, chain,
-						   afi->nops);
+			nf_tables_unregister_hook(net, table, chain);
 		/* No packets are walking on these chains anymore. */
 		ctx.table = table;
 		list_for_each_entry(chain, &table->chains, list) {
diff --git a/net/netfilter/nf_tables_inet.c b/net/netfilter/nf_tables_inet.c
index 4ddd055f3aed..78f0289ea339 100644
--- a/net/netfilter/nf_tables_inet.c
+++ b/net/netfilter/nf_tables_inet.c
@@ -70,7 +70,6 @@ static struct nft_af_info nft_af_inet __read_mostly = {
 	.family		= NFPROTO_INET,
 	.nhooks		= NF_INET_NUMHOOKS,
 	.owner		= THIS_MODULE,
-	.nops		= 1,
 	.hooks		= {
 		[NF_INET_LOCAL_IN]	= nft_do_chain_inet,
 		[NF_INET_LOCAL_OUT]	= nft_inet_output,
diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
index 403432988313..aabb00b462de 100644
--- a/net/netfilter/nf_tables_netdev.c
+++ b/net/netfilter/nf_tables_netdev.c
@@ -41,7 +41,6 @@ static struct nft_af_info nft_af_netdev __read_mostly = {
 	.nhooks		= NF_NETDEV_NUMHOOKS,
 	.owner		= THIS_MODULE,
 	.flags		= NFT_AF_NEEDS_DEV,
-	.nops		= 1,
 	.hooks		= {
 		[NF_NETDEV_INGRESS]	= nft_do_chain_netdev,
 	},
@@ -96,7 +95,7 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 		__nft_release_basechain(ctx);
 		break;
 	case NETDEV_CHANGENAME:
-		if (dev->ifindex != basechain->ops[0].dev->ifindex)
+		if (dev->ifindex != basechain->ops.dev->ifindex)
 			return;
 
 		strncpy(basechain->dev_name, dev->name, IFNAMSIZ);
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index b89f4f65b2a0..dcff0dc8d28b 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -169,7 +169,7 @@ nft_target_set_tgchk_param(struct xt_tgchk_param *par,
 	if (nft_is_base_chain(ctx->chain)) {
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
-		const struct nf_hook_ops *ops = &basechain->ops[0];
+		const struct nf_hook_ops *ops = &basechain->ops;
 
 		par->hook_mask = 1 << ops->hooknum;
 	} else {
@@ -302,7 +302,7 @@ static int nft_target_validate(const struct nft_ctx *ctx,
 	if (nft_is_base_chain(ctx->chain)) {
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
-		const struct nf_hook_ops *ops = &basechain->ops[0];
+		const struct nf_hook_ops *ops = &basechain->ops;
 
 		hook_mask = 1 << ops->hooknum;
 		if (target->hooks && !(hook_mask & target->hooks))
@@ -383,7 +383,7 @@ nft_match_set_mtchk_param(struct xt_mtchk_param *par, const struct nft_ctx *ctx,
 	if (nft_is_base_chain(ctx->chain)) {
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
-		const struct nf_hook_ops *ops = &basechain->ops[0];
+		const struct nf_hook_ops *ops = &basechain->ops;
 
 		par->hook_mask = 1 << ops->hooknum;
 	} else {
@@ -481,7 +481,7 @@ static int nft_match_validate(const struct nft_ctx *ctx,
 	if (nft_is_base_chain(ctx->chain)) {
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
-		const struct nf_hook_ops *ops = &basechain->ops[0];
+		const struct nf_hook_ops *ops = &basechain->ops;
 
 		hook_mask = 1 << ops->hooknum;
 		if (match->hooks && !(hook_mask & match->hooks))
-- 
2.11.0

