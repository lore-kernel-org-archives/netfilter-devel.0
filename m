From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: nf_tables: attach net_device to basechain
Date: Fri, 12 Jun 2015 13:55:41 +0200
Message-ID: <1434110141-5827-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45345 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbbFLLu3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 07:50:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The device is part of the hook configuration, so instead of a global
configuration per table, set it to each of the basechain that we create.

This patch reworks ebddf1a8d78a ("netfilter: nf_tables: allow to bind table to
net_device").

Suggested-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Patrick: I found another problem regarding the net_device pointer that I keep
in struct nft_basechain: dev_hold() doesn't increase the module refcount so one
could remove the net_device driver, which will keep us looping on:

 unregister_netdevice: waiting for eth0 to become free. Usage count = 1

I think we can store the ifname instead and subscribe to netdev events, if the
interface goes down, we unregister the existing hooks. Then, if it comes back
up, we register them back again.

The idea is to pass the devname to the nf hook core, it takes care of this.

 include/net/netfilter/nf_tables.h        |    2 -
 include/uapi/linux/netfilter/nf_tables.h |    4 +-
 net/netfilter/nf_tables_api.c            |   76 +++++++++++++++---------------
 3 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3d6f48c..8d9c307 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -819,7 +819,6 @@ unsigned int nft_do_chain(struct nft_pktinfo *pkt,
  *	@use: number of chain references to this table
  *	@flags: table flag (see enum nft_table_flags)
  *	@name: name of the table
- *	@dev: this table is bound to this device (if any)
  */
 struct nft_table {
 	struct list_head		list;
@@ -829,7 +828,6 @@ struct nft_table {
 	u32				use;
 	u16				flags;
 	char				name[NFT_TABLE_MAXNAMELEN];
-	struct net_device		*dev;
 };
 
 enum nft_af_flags {
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 17db26c..d02d7d2 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -122,11 +122,13 @@ enum nft_list_attributes {
  *
  * @NFTA_HOOK_HOOKNUM: netfilter hook number (NLA_U32)
  * @NFTA_HOOK_PRIORITY: netfilter hook priority (NLA_U32)
+ * @NFTA_HOOK_DEV: netdevice name (NLA_STRING)
  */
 enum nft_hook_attributes {
 	NFTA_HOOK_UNSPEC,
 	NFTA_HOOK_HOOKNUM,
 	NFTA_HOOK_PRIORITY,
+	NFTA_HOOK_DEV,
 	__NFTA_HOOK_MAX
 };
 #define NFTA_HOOK_MAX		(__NFTA_HOOK_MAX - 1)
@@ -146,14 +148,12 @@ enum nft_table_flags {
  * @NFTA_TABLE_NAME: name of the table (NLA_STRING)
  * @NFTA_TABLE_FLAGS: bitmask of enum nft_table_flags (NLA_U32)
  * @NFTA_TABLE_USE: number of chains in this table (NLA_U32)
- * @NFTA_TABLE_DEV: net device name (NLA_STRING)
  */
 enum nft_table_attributes {
 	NFTA_TABLE_UNSPEC,
 	NFTA_TABLE_NAME,
 	NFTA_TABLE_FLAGS,
 	NFTA_TABLE_USE,
-	NFTA_TABLE_DEV,
 	__NFTA_TABLE_MAX
 };
 #define NFTA_TABLE_MAX		(__NFTA_TABLE_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 48c4844..a1feba3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -399,8 +399,6 @@ static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
 	[NFTA_TABLE_NAME]	= { .type = NLA_STRING,
 				    .len = NFT_TABLE_MAXNAMELEN - 1 },
 	[NFTA_TABLE_FLAGS]	= { .type = NLA_U32 },
-	[NFTA_TABLE_DEV]	= { .type = NLA_STRING,
-				    .len = IFNAMSIZ - 1 },
 };
 
 static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
@@ -425,10 +423,6 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 	    nla_put_be32(skb, NFTA_TABLE_USE, htonl(table->use)))
 		goto nla_put_failure;
 
-	if (table->dev &&
-	    nla_put_string(skb, NFTA_TABLE_DEV, table->dev->name))
-		goto nla_put_failure;
-
 	nlmsg_end(skb, nlh);
 	return 0;
 
@@ -615,11 +609,6 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	if (flags == ctx->table->flags)
 		return 0;
 
-	if ((ctx->afi->flags & NFT_AF_NEEDS_DEV) &&
-	    ctx->nla[NFTA_TABLE_DEV] &&
-	    nla_strcmp(ctx->nla[NFTA_TABLE_DEV], ctx->table->dev->name))
-		return -EOPNOTSUPP;
-
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWTABLE,
 				sizeof(struct nft_trans_table));
 	if (trans == NULL)
@@ -657,7 +646,6 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_table *table;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
-	struct net_device *dev = NULL;
 	u32 flags = 0;
 	struct nft_ctx ctx;
 	int err;
@@ -692,20 +680,6 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 			return -EINVAL;
 	}
 
-	if (afi->flags & NFT_AF_NEEDS_DEV) {
-		char ifname[IFNAMSIZ];
-
-		if (!nla[NFTA_TABLE_DEV])
-			return -EOPNOTSUPP;
-
-		nla_strlcpy(ifname, nla[NFTA_TABLE_DEV], IFNAMSIZ);
-		dev = dev_get_by_name(net, ifname);
-		if (!dev)
-			return -ENOENT;
-	} else if (nla[NFTA_TABLE_DEV]) {
-		return -EOPNOTSUPP;
-	}
-
 	err = -EAFNOSUPPORT;
 	if (!try_module_get(afi->owner))
 		goto err1;
@@ -719,7 +693,6 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 	INIT_LIST_HEAD(&table->chains);
 	INIT_LIST_HEAD(&table->sets);
 	table->flags = flags;
-	table->dev   = dev;
 
 	nft_ctx_init(&ctx, skb, nlh, afi, table, NULL, nla);
 	err = nft_trans_table_add(&ctx, NFT_MSG_NEWTABLE);
@@ -733,9 +706,6 @@ err3:
 err2:
 	module_put(afi->owner);
 err1:
-	if (dev != NULL)
-		dev_put(dev);
-
 	return err;
 }
 
@@ -839,9 +809,6 @@ static void nf_tables_table_destroy(struct nft_ctx *ctx)
 {
 	BUG_ON(ctx->table->use > 0);
 
-	if (ctx->table->dev)
-		dev_put(ctx->table->dev);
-
 	kfree(ctx->table);
 	module_put(ctx->afi->owner);
 }
@@ -917,6 +884,8 @@ static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] = {
 static const struct nla_policy nft_hook_policy[NFTA_HOOK_MAX + 1] = {
 	[NFTA_HOOK_HOOKNUM]	= { .type = NLA_U32 },
 	[NFTA_HOOK_PRIORITY]	= { .type = NLA_U32 },
+	[NFTA_HOOK_DEV]		= { .type = NLA_STRING,
+				    .len = IFNAMSIZ - 1 },
 };
 
 static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
@@ -990,6 +959,9 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 			goto nla_put_failure;
 		if (nla_put_be32(skb, NFTA_HOOK_PRIORITY, htonl(ops->priority)))
 			goto nla_put_failure;
+		if (ops->dev != NULL &&
+		    nla_put_string(skb, NFTA_HOOK_DEV, ops->dev->name))
+			goto nla_put_failure;
 		nla_nest_end(skb, nest);
 
 		if (nla_put_be32(skb, NFTA_CHAIN_POLICY,
@@ -1201,9 +1173,13 @@ static void nf_tables_chain_destroy(struct nft_chain *chain)
 	BUG_ON(chain->use > 0);
 
 	if (chain->flags & NFT_BASE_CHAIN) {
-		module_put(nft_base_chain(chain)->type->owner);
-		free_percpu(nft_base_chain(chain)->stats);
-		kfree(nft_base_chain(chain));
+		struct nft_base_chain *basechain = nft_base_chain(chain);
+
+		module_put(basechain->type->owner);
+		free_percpu(basechain->stats);
+		if (basechain->ops[0].dev != NULL)
+			dev_put(basechain->ops[0].dev);
+		kfree(basechain);
 	} else {
 		kfree(chain);
 	}
@@ -1222,6 +1198,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	struct nlattr *ha[NFTA_HOOK_MAX + 1];
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
+	struct net_device *dev = NULL;
 	u8 policy = NF_ACCEPT;
 	u64 handle = 0;
 	unsigned int i;
@@ -1361,9 +1338,30 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			return -ENOENT;
 		hookfn = type->hooks[hooknum];
 
+		if (afi->flags & NFT_AF_NEEDS_DEV) {
+			char ifname[IFNAMSIZ];
+
+			if (!ha[NFTA_HOOK_DEV]) {
+				module_put(type->owner);
+				return -EOPNOTSUPP;
+			}
+
+			nla_strlcpy(ifname, ha[NFTA_HOOK_DEV], IFNAMSIZ);
+			dev = dev_get_by_name(net, ifname);
+			if (!dev) {
+				module_put(type->owner);
+				return -ENOENT;
+			}
+		} else if (ha[NFTA_HOOK_DEV]) {
+			module_put(type->owner);
+			return -EOPNOTSUPP;
+		}
+
 		basechain = kzalloc(sizeof(*basechain), GFP_KERNEL);
 		if (basechain == NULL) {
 			module_put(type->owner);
+			if (dev != NULL)
+				dev_put(dev);
 			return -ENOMEM;
 		}
 
@@ -1372,6 +1370,8 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			if (IS_ERR(stats)) {
 				module_put(type->owner);
 				kfree(basechain);
+				if (dev != NULL)
+					dev_put(dev);
 				return PTR_ERR(stats);
 			}
 			basechain->stats = stats;
@@ -1380,6 +1380,8 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			if (stats == NULL) {
 				module_put(type->owner);
 				kfree(basechain);
+				if (dev != NULL)
+					dev_put(dev);
 				return -ENOMEM;
 			}
 			rcu_assign_pointer(basechain->stats, stats);
@@ -1397,7 +1399,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			ops->priority	= priority;
 			ops->priv	= chain;
 			ops->hook	= afi->hooks[ops->hooknum];
-			ops->dev	= table->dev;
+			ops->dev	= dev;
 			if (hookfn)
 				ops->hook = hookfn;
 			if (afi->hook_ops_init)
-- 
1.7.10.4

