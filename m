From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 10/11] netfilter: nft_objref: support for stateful object maps
Date: Mon, 28 Nov 2016 01:01:09 +0100
Message-ID: <1480291270-3715-11-git-send-email-pablo@netfilter.org>
References: <1480291270-3715-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40130 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753481AbcK1ABb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Nov 2016 19:01:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 77E9AD1631
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56B3F524C2
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 355ED524C5
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:28 +0100 (CET)
In-Reply-To: <1480291270-3715-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows us to refer to stateful object dictionaries, the
source register indicates the key data to be used to look up for the
corresponding state object. We can refer to these maps through names or,
alternatively, the map transaction id. This allows us to refer to both
anonymous and named maps.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |   6 ++
 net/netfilter/nf_tables_api.c            |   4 ++
 net/netfilter/nft_objref.c               | 116 ++++++++++++++++++++++++++++++-
 3 files changed, 125 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 6835d62c17c2..dd481f0e7517 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1183,11 +1183,17 @@ enum nft_fwd_attributes {
  *
  * @NFTA_OBJREF_TYPE: source register of output interface (NLA_U32: nft_register)
  * @NFTA_OBJREF_NAME: source register of output interface (NLA_STRING)
+ * @NFTA_OBJREF_SREG: source register of the data to look for (NLA_U32: nft_registers)
+ * @NFTA_OBJREF_MAP: name of the map where to look for (NLA_STRING)
+ * @NFTA_OBJREF_MAP_ID: id of the map where to look for in this transaction (NLA_U32)
  */
 enum nft_objref_attributes {
 	NFTA_OBJREF_UNSPEC,
 	NFTA_OBJREF_TYPE,
 	NFTA_OBJREF_NAME,
+	NFTA_OBJREF_SREG,
+	NFTA_OBJREF_MAP,
+	NFTA_OBJREF_MAP_ID,
 	__NFTA_OBJREF_MAX
 };
 #define NFTA_OBJREF_MAX	(__NFTA_OBJREF_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fb5f7e474e85..a69c5febcb1b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2532,6 +2532,7 @@ struct nft_set *nf_tables_set_lookup(const struct nft_table *table,
 	}
 	return ERR_PTR(-ENOENT);
 }
+EXPORT_SYMBOL_GPL(nf_tables_set_lookup);
 
 struct nft_set *nf_tables_set_lookup_byid(const struct net *net,
 					  const struct nlattr *nla,
@@ -2550,6 +2551,7 @@ struct nft_set *nf_tables_set_lookup_byid(const struct net *net,
 	}
 	return ERR_PTR(-ENOENT);
 }
+EXPORT_SYMBOL_GPL(nf_tables_set_lookup_byid);
 
 static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 				    const char *name)
@@ -3146,6 +3148,7 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 	list_add_tail_rcu(&binding->list, &set->bindings);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nf_tables_bind_set);
 
 void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 			  struct nft_set_binding *binding)
@@ -3156,6 +3159,7 @@ void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 	    nft_is_active(ctx->net, set))
 		nf_tables_set_destroy(ctx, set);
 }
+EXPORT_SYMBOL_GPL(nf_tables_unbind_set);
 
 const struct nft_set_ext_type nft_set_ext_types[] = {
 	[NFT_SET_EXT_KEY]		= {
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index a7078055d564..285db02feb1b 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -81,15 +81,129 @@ static const struct nft_expr_ops nft_objref_ops = {
 	.dump		= nft_objref_dump,
 };
 
+struct nft_objref_map {
+	struct nft_set		*set;
+	enum nft_registers	sreg:8;
+	struct nft_set_binding	binding;
+};
+
+static void nft_objref_map_eval(const struct nft_expr *expr,
+				struct nft_regs *regs,
+				const struct nft_pktinfo *pkt)
+{
+	struct nft_objref_map *priv = nft_expr_priv(expr);
+	const struct nft_set *set = priv->set;
+	const struct nft_set_ext *ext;
+	struct nft_object *obj;
+	bool found;
+
+	found = set->ops->lookup(nft_net(pkt), set, &regs->data[priv->sreg],
+				 &ext);
+	if (!found) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+	obj = *nft_set_ext_obj(ext);
+	obj->type->eval(obj->data, regs, pkt);
+}
+
+static int nft_objref_map_init(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr,
+			       const struct nlattr * const tb[])
+{
+	struct nft_objref_map *priv = nft_expr_priv(expr);
+	u8 genmask = nft_genmask_next(ctx->net);
+	struct nft_set *set;
+	int err;
+
+	set = nf_tables_set_lookup(ctx->table, tb[NFTA_OBJREF_MAP], genmask);
+	if (IS_ERR(set)) {
+		if (tb[NFTA_OBJREF_MAP_ID]) {
+			set = nf_tables_set_lookup_byid(ctx->net,
+							tb[NFTA_OBJREF_MAP_ID],
+							genmask);
+		}
+		if (IS_ERR(set))
+			return PTR_ERR(set);
+	}
+
+	if (!(set->flags & NFT_SET_OBJECT))
+		return -EINVAL;
+
+	priv->sreg = nft_parse_register(tb[NFTA_OBJREF_SREG]);
+	err = nft_validate_register_load(priv->sreg, set->klen);
+	if (err < 0)
+		return err;
+
+	priv->binding.flags = set->flags & NFT_SET_OBJECT;
+
+	err = nf_tables_bind_set(ctx, set, &priv->binding);
+	if (err < 0)
+		return err;
+
+	priv->set = set;
+	return 0;
+}
+
+static int nft_objref_map_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_objref_map *priv = nft_expr_priv(expr);
+
+	if (nft_dump_register(skb, NFTA_OBJREF_SREG, priv->sreg) ||
+	    nla_put_string(skb, NFTA_OBJREF_MAP, priv->set->name))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static void nft_objref_map_destroy(const struct nft_ctx *ctx,
+				   const struct nft_expr *expr)
+{
+	struct nft_objref_map *priv = nft_expr_priv(expr);
+
+	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+}
+
+static struct nft_expr_type nft_objref_type;
+static const struct nft_expr_ops nft_objref_map_ops = {
+	.type		= &nft_objref_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_objref_map)),
+	.eval		= nft_objref_map_eval,
+	.init		= nft_objref_map_init,
+	.destroy	= nft_objref_map_destroy,
+	.dump		= nft_objref_map_dump,
+};
+
+static const struct nft_expr_ops *
+nft_objref_select_ops(const struct nft_ctx *ctx,
+                      const struct nlattr * const tb[])
+{
+	if (tb[NFTA_OBJREF_SREG] &&
+	    (tb[NFTA_OBJREF_MAP] ||
+	     tb[NFTA_OBJREF_MAP_ID]))
+		return &nft_objref_map_ops;
+	else if (tb[NFTA_OBJREF_NAME] &&
+		 tb[NFTA_OBJREF_TYPE])
+		return &nft_objref_ops;
+
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static const struct nla_policy nft_objref_policy[NFTA_OBJREF_MAX + 1] = {
 	[NFTA_OBJREF_NAME]	= { .type = NLA_STRING },
 	[NFTA_OBJREF_TYPE]	= { .type = NLA_U32 },
+	[NFTA_OBJREF_SREG]	= { .type = NLA_U32 },
+	[NFTA_OBJREF_MAP]	= { .type = NLA_STRING },
+	[NFTA_OBJREF_MAP_ID]	= { .type = NLA_U32 } ,
 };
 
 static struct nft_expr_type nft_objref_type __read_mostly = {
 	.name		= "objref",
 	.type		= NFT_EXPR_OBJREF,
-	.ops		= &nft_objref_ops,
+	.select_ops	= nft_objref_select_ops,
 	.policy		= nft_objref_policy,
 	.maxattr	= NFTA_OBJREF_MAX,
 	.owner		= THIS_MODULE,
-- 
2.1.4

