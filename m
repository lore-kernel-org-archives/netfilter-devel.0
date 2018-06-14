From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next,RFC 09/13] netfilter: nf_flow_table: add hooknum to flowtable type
Date: Thu, 14 Jun 2018 16:19:43 +0200
Message-ID: <20180614141947.3580-10-pablo@netfilter.org>
References: <20180614141947.3580-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, steffen.klassert@secunet.com
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180614141947.3580-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This allows us to register different flowtable variants depending on the
hook type, hence we can define flowtable for new hook types.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/netfilter/nf_flow_table.h   |   1 +
 net/ipv4/netfilter/nf_flow_table_ipv4.c |   1 +
 net/ipv6/netfilter/nf_flow_table_ipv6.c |   1 +
 net/netfilter/nf_flow_table_inet.c      |   1 +
 net/netfilter/nf_tables_api.c           | 120 +++++++++++++++++---------------
 5 files changed, 67 insertions(+), 57 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index ba9fa4592f2b..4606bad41155 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -14,6 +14,7 @@ struct nf_flowtable;
 struct nf_flowtable_type {
 	struct list_head		list;
 	int				family;
+	unsigned int			hooknum;
 	int				(*init)(struct nf_flowtable *ft);
 	void				(*free)(struct nf_flowtable *ft);
 	nf_hookfn			*hook;
diff --git a/net/ipv4/netfilter/nf_flow_table_ipv4.c b/net/ipv4/netfilter/nf_flow_table_ipv4.c
index e1e56d7123d2..681c0d5c47d7 100644
--- a/net/ipv4/netfilter/nf_flow_table_ipv4.c
+++ b/net/ipv4/netfilter/nf_flow_table_ipv4.c
@@ -7,6 +7,7 @@
 
 static struct nf_flowtable_type flowtable_ipv4 = {
 	.family		= NFPROTO_IPV4,
+	.hooknum	= NF_NETDEV_INGRESS,
 	.init		= nf_flow_table_init,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_ip_hook,
diff --git a/net/ipv6/netfilter/nf_flow_table_ipv6.c b/net/ipv6/netfilter/nf_flow_table_ipv6.c
index c511d206bf9b..f1f976bdc151 100644
--- a/net/ipv6/netfilter/nf_flow_table_ipv6.c
+++ b/net/ipv6/netfilter/nf_flow_table_ipv6.c
@@ -8,6 +8,7 @@
 
 static struct nf_flowtable_type flowtable_ipv6 = {
 	.family		= NFPROTO_IPV6,
+	.hooknum	= NF_NETDEV_INGRESS,
 	.init		= nf_flow_table_init,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_ipv6_hook,
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index 99771aa7e7ea..347a640d9723 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -22,6 +22,7 @@ nf_flow_offload_inet_hook(void *priv, struct sk_buff *skb,
 
 static struct nf_flowtable_type flowtable_inet = {
 	.family		= NFPROTO_INET,
+	.hooknum	= NF_NETDEV_INGRESS,
 	.init		= nf_flow_table_init,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_inet_hook,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ca4c4d994ddb..5d6c3b9eee6b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5266,6 +5266,40 @@ static int nf_tables_parse_devices(const struct nft_ctx *ctx,
 	return err;
 }
 
+static const struct nf_flowtable_type *__nft_flowtable_type_get(u8 family,
+								int hooknum)
+{
+	const struct nf_flowtable_type *type;
+
+	list_for_each_entry(type, &nf_tables_flowtables, list) {
+		if (family == type->family &&
+		    hooknum == type->hooknum)
+			return type;
+	}
+	return NULL;
+}
+
+static const struct nf_flowtable_type *nft_flowtable_type_get(u8 family,
+							      int hooknum)
+{
+	const struct nf_flowtable_type *type;
+
+	type = __nft_flowtable_type_get(family, hooknum);
+	if (type != NULL && try_module_get(type->owner))
+		return type;
+
+#ifdef CONFIG_MODULES
+	if (type == NULL) {
+		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
+		request_module("nf-flowtable-%u", family);
+		nfnl_lock(NFNL_SUBSYS_NFTABLES);
+		if (__nft_flowtable_type_get(family, hooknum))
+			return ERR_PTR(-EAGAIN);
+	}
+#endif
+	return ERR_PTR(-ENOENT);
+}
+
 static const struct nla_policy nft_flowtable_hook_policy[NFTA_FLOWTABLE_HOOK_MAX + 1] = {
 	[NFTA_FLOWTABLE_HOOK_NUM]	= { .type = NLA_U32 },
 	[NFTA_FLOWTABLE_HOOK_PRIORITY]	= { .type = NLA_U32 },
@@ -5278,6 +5312,7 @@ static int nf_tables_flowtable_parse_hook(const struct nft_ctx *ctx,
 {
 	struct net_device *dev_array[NFT_FLOWTABLE_DEVICE_MAX];
 	struct nlattr *tb[NFTA_FLOWTABLE_HOOK_MAX + 1];
+	const struct nf_flowtable_type *type;
 	struct nf_hook_ops *ops;
 	int hooknum, priority;
 	int err, n = 0, i;
@@ -5293,19 +5328,31 @@ static int nf_tables_flowtable_parse_hook(const struct nft_ctx *ctx,
 		return -EINVAL;
 
 	hooknum = ntohl(nla_get_be32(tb[NFTA_FLOWTABLE_HOOK_NUM]));
-	if (hooknum != NF_NETDEV_INGRESS)
+	if (hooknum != NF_NETDEV_INGRESS &&
+	    hooknum != NF_NETDEV_EARLY_INGRESS)
 		return -EINVAL;
 
+	type = nft_flowtable_type_get(ctx->family, hooknum);
+	if (IS_ERR(type))
+		return PTR_ERR(type);
+
+	flowtable->data.type = type;
+	err = type->init(&flowtable->data);
+	if (err < 0)
+		goto err1;
+
 	priority = ntohl(nla_get_be32(tb[NFTA_FLOWTABLE_HOOK_PRIORITY]));
 
 	err = nf_tables_parse_devices(ctx, tb[NFTA_FLOWTABLE_HOOK_DEVS],
 				      dev_array, &n);
 	if (err < 0)
-		return err;
+		goto err2;
 
 	ops = kzalloc(sizeof(struct nf_hook_ops) * n, GFP_KERNEL);
-	if (!ops)
-		return -ENOMEM;
+	if (!ops) {
+		err = -ENOMEM;
+		goto err2;
+	}
 
 	flowtable->hooknum	= hooknum;
 	flowtable->priority	= priority;
@@ -5323,38 +5370,13 @@ static int nf_tables_flowtable_parse_hook(const struct nft_ctx *ctx,
 							  GFP_KERNEL);
 	}
 
-	return err;
-}
-
-static const struct nf_flowtable_type *__nft_flowtable_type_get(u8 family)
-{
-	const struct nf_flowtable_type *type;
-
-	list_for_each_entry(type, &nf_tables_flowtables, list) {
-		if (family == type->family)
-			return type;
-	}
-	return NULL;
-}
-
-static const struct nf_flowtable_type *nft_flowtable_type_get(u8 family)
-{
-	const struct nf_flowtable_type *type;
-
-	type = __nft_flowtable_type_get(family);
-	if (type != NULL && try_module_get(type->owner))
-		return type;
+	return 0;
+err2:
+	flowtable->data.type->free(&flowtable->data);
+err1:
+	module_put(type->owner);
 
-#ifdef CONFIG_MODULES
-	if (type == NULL) {
-		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
-		request_module("nf-flowtable-%u", family);
-		nfnl_lock(NFNL_SUBSYS_NFTABLES);
-		if (__nft_flowtable_type_get(family))
-			return ERR_PTR(-EAGAIN);
-	}
-#endif
-	return ERR_PTR(-ENOENT);
+	return err;
 }
 
 static void nft_unregister_flowtable_net_hooks(struct net *net,
@@ -5377,7 +5399,6 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 				  struct netlink_ext_ack *extack)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	const struct nf_flowtable_type *type;
 	struct nft_flowtable *flowtable, *ft;
 	u8 genmask = nft_genmask_next(net);
 	int family = nfmsg->nfgen_family;
@@ -5429,21 +5450,10 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 		goto err1;
 	}
 
-	type = nft_flowtable_type_get(family);
-	if (IS_ERR(type)) {
-		err = PTR_ERR(type);
-		goto err2;
-	}
-
-	flowtable->data.type = type;
-	err = type->init(&flowtable->data);
-	if (err < 0)
-		goto err3;
-
 	err = nf_tables_flowtable_parse_hook(&ctx, nla[NFTA_FLOWTABLE_HOOK],
 					     flowtable);
 	if (err < 0)
-		goto err4;
+		goto err2;
 
 	for (i = 0; i < flowtable->ops_len; i++) {
 		if (!flowtable->ops[i].dev)
@@ -5457,37 +5467,33 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 				if (flowtable->ops[i].dev == ft->ops[k].dev &&
 				    flowtable->ops[i].pf == ft->ops[k].pf) {
 					err = -EBUSY;
-					goto err5;
+					goto err3;
 				}
 			}
 		}
 
 		err = nf_register_net_hook(net, &flowtable->ops[i]);
 		if (err < 0)
-			goto err5;
+			goto err3;
 	}
 
 	err = nft_trans_flowtable_add(&ctx, NFT_MSG_NEWFLOWTABLE, flowtable);
 	if (err < 0)
-		goto err6;
+		goto err4;
 
 	list_add_tail_rcu(&flowtable->list, &table->flowtables);
 	table->use++;
 
 	return 0;
-err6:
+err4:
 	i = flowtable->ops_len;
-err5:
+err3:
 	for (k = i - 1; k >= 0; k--) {
 		kfree(flowtable->dev_name[k]);
 		nf_unregister_net_hook(net, &flowtable->ops[k]);
 	}
 
 	kfree(flowtable->ops);
-err4:
-	flowtable->data.type->free(&flowtable->data);
-err3:
-	module_put(type->owner);
 err2:
 	kfree(flowtable->name);
 err1:
-- 
2.11.0
