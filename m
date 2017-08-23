From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nf-next 1/3] netfilter: nf_tables: add select_ops for stateful objects
Date: Wed, 23 Aug 2017 22:41:23 +0200
Message-ID: <20170823204125.31427-1-pablombg@gmail.com>
Cc: pablo@netfilter.org, "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35903 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbdHWUmP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2017 16:42:15 -0400
Received: by mail-wm0-f67.google.com with SMTP id f127so702214wmf.3
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2017 13:42:15 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for overloading stateful objects operations
through the select_ops() callback, just as it is implemented for
expressions.

This change is needed for upcoming additions to the stateful objects
infrastructure.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 include/net/netfilter/nf_tables.h | 30 ++++++++++++++++++++++--------
 net/netfilter/nf_tables_api.c     | 27 ++++++++++++++++++++-------
 net/netfilter/nft_counter.c       | 12 ++++++++----
 net/netfilter/nft_ct.c            | 12 ++++++++----
 net/netfilter/nft_objref.c        |  4 ++--
 net/netfilter/nft_quota.c         | 12 ++++++++----
 6 files changed, 68 insertions(+), 29 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f9795fe394f3..b53639af1c7b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1008,6 +1008,7 @@ int nft_verdict_dump(struct sk_buff *skb, int type,
  *	@list: table stateful object list node
  *	@table: table this object belongs to
  *	@type: pointer to object type
+ *	@ops: object operations
  *	@data: pointer to object data
  *	@name: name of this stateful object
  *	@genmask: generation mask
@@ -1022,6 +1023,7 @@ struct nft_object {
 					use:30;
 	/* runtime data below here */
 	const struct nft_object_type	*type ____cacheline_aligned;
+	const struct nft_object_ops	*ops;
 	unsigned char			data[]
 		__attribute__((aligned(__alignof__(u64))));
 };
@@ -1044,27 +1046,39 @@ void nft_obj_notify(struct net *net, struct nft_table *table,
 /**
  *	struct nft_object_type - stateful object type
  *
- *	@eval: stateful object evaluation function
+ *	@select_ops: function to select nft_object_ops
+ *	@ops: default ops, used when no select_ops functions is present
  *	@list: list node in list of object types
  *	@type: stateful object numeric type
- *	@size: stateful object size
  *	@owner: module owner
  *	@maxattr: maximum netlink attribute
  *	@policy: netlink attribute policy
+ */
+struct nft_object_type {
+	const struct nft_object_ops	*(*select_ops)(const struct nft_ctx *,
+						       const struct nlattr * const tb[]);
+	const struct nft_object_ops	*ops;
+	struct list_head		list;
+	u32				type;
+	unsigned int                    maxattr;
+	struct module			*owner;
+	const struct nla_policy		*policy;
+};
+
+/**
+ *	struct nft_object_ops - stateful object operations
+ *
+ *	@eval: stateful object evaluation function
+ *	@size: stateful object size
  *	@init: initialize object from netlink attributes
  *	@destroy: release existing stateful object
  *	@dump: netlink dump stateful object
  */
-struct nft_object_type {
+struct nft_object_ops {
 	void				(*eval)(struct nft_object *obj,
 						struct nft_regs *regs,
 						const struct nft_pktinfo *pkt);
-	struct list_head		list;
-	u32				type;
 	unsigned int			size;
-	unsigned int			maxattr;
-	struct module			*owner;
-	const struct nla_policy		*policy;
 	int				(*init)(const struct nft_ctx *ctx,
 						const struct nlattr *const tb[],
 						struct nft_object *obj);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 149785ff1c7b..b946774707b1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4270,6 +4270,7 @@ static struct nft_object *nft_obj_init(const struct nft_ctx *ctx,
 				       const struct nlattr *attr)
 {
 	struct nlattr *tb[type->maxattr + 1];
+	const struct nft_object_ops *ops;
 	struct nft_object *obj;
 	int err;
 
@@ -4282,12 +4283,24 @@ static struct nft_object *nft_obj_init(const struct nft_ctx *ctx,
 		memset(tb, 0, sizeof(tb[0]) * (type->maxattr + 1));
 	}
 
+	if (type->select_ops) {
+		ops = type->select_ops(ctx, (const struct nlattr * const *)tb);
+		if (IS_ERR(ops)) {
+			err = PTR_ERR(ops);
+			goto err1;
+		}
+	} else {
+		ops = type->ops;
+	}
+
 	err = -ENOMEM;
-	obj = kzalloc(sizeof(struct nft_object) + type->size, GFP_KERNEL);
+	obj = kzalloc(sizeof(*obj) + ops->size, GFP_KERNEL);
 	if (obj == NULL)
 		goto err1;
 
-	err = type->init(ctx, (const struct nlattr * const *)tb, obj);
+	obj->ops = ops;
+
+	err = ops->init(ctx, (const struct nlattr * const *)tb, obj);
 	if (err < 0)
 		goto err2;
 
@@ -4307,7 +4320,7 @@ static int nft_object_dump(struct sk_buff *skb, unsigned int attr,
 	nest = nla_nest_start(skb, attr);
 	if (!nest)
 		goto nla_put_failure;
-	if (obj->type->dump(skb, obj, reset) < 0)
+	if (obj->ops->dump(skb, obj, reset) < 0)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest);
 	return 0;
@@ -4418,8 +4431,8 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 err3:
 	kfree(obj->name);
 err2:
-	if (obj->type->destroy)
-		obj->type->destroy(obj);
+	if (obj->ops->destroy)
+		obj->ops->destroy(obj);
 	kfree(obj);
 err1:
 	module_put(type->owner);
@@ -4628,8 +4641,8 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 
 static void nft_obj_destroy(struct nft_object *obj)
 {
-	if (obj->type->destroy)
-		obj->type->destroy(obj);
+	if (obj->ops->destroy)
+		obj->ops->destroy(obj);
 
 	module_put(obj->type->owner);
 	kfree(obj->name);
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 67a710ebde09..5ae8ae2a879e 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -175,15 +175,19 @@ static const struct nla_policy nft_counter_policy[NFTA_COUNTER_MAX + 1] = {
 	[NFTA_COUNTER_BYTES]	= { .type = NLA_U64 },
 };
 
-static struct nft_object_type nft_counter_obj __read_mostly = {
-	.type		= NFT_OBJECT_COUNTER,
+static const struct nft_object_ops nft_counter_obj_ops = {
 	.size		= sizeof(struct nft_counter_percpu_priv),
-	.maxattr	= NFTA_COUNTER_MAX,
-	.policy		= nft_counter_policy,
 	.eval		= nft_counter_obj_eval,
 	.init		= nft_counter_obj_init,
 	.destroy	= nft_counter_obj_destroy,
 	.dump		= nft_counter_obj_dump,
+};
+
+static struct nft_object_type nft_counter_obj __read_mostly = {
+	.type		= NFT_OBJECT_COUNTER,
+	.ops		= &nft_counter_obj_ops,
+	.maxattr	= NFTA_COUNTER_MAX,
+	.policy		= nft_counter_policy,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 1678e9e75e8e..39f10a0ede81 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -904,15 +904,19 @@ static const struct nla_policy nft_ct_helper_policy[NFTA_CT_HELPER_MAX + 1] = {
 	[NFTA_CT_HELPER_L4PROTO] = { .type = NLA_U8 },
 };
 
-static struct nft_object_type nft_ct_helper_obj __read_mostly = {
-	.type		= NFT_OBJECT_CT_HELPER,
+static const struct nft_object_ops nft_ct_helper_obj_ops = {
 	.size		= sizeof(struct nft_ct_helper_obj),
-	.maxattr	= NFTA_CT_HELPER_MAX,
-	.policy		= nft_ct_helper_policy,
 	.eval		= nft_ct_helper_obj_eval,
 	.init		= nft_ct_helper_obj_init,
 	.destroy	= nft_ct_helper_obj_destroy,
 	.dump		= nft_ct_helper_obj_dump,
+};
+
+static struct nft_object_type nft_ct_helper_obj __read_mostly = {
+	.type		= NFT_OBJECT_CT_HELPER,
+	.ops		= &nft_ct_helper_obj_ops,
+	.maxattr	= NFTA_CT_HELPER_MAX,
+	.policy		= nft_ct_helper_policy,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 1dd428fbaaa3..096468280a1e 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -22,7 +22,7 @@ static void nft_objref_eval(const struct nft_expr *expr,
 {
 	struct nft_object *obj = nft_objref_priv(expr);
 
-	obj->type->eval(obj, regs, pkt);
+	obj->ops->eval(obj, regs, pkt);
 }
 
 static int nft_objref_init(const struct nft_ctx *ctx,
@@ -104,7 +104,7 @@ static void nft_objref_map_eval(const struct nft_expr *expr,
 		return;
 	}
 	obj = *nft_set_ext_obj(ext);
-	obj->type->eval(obj, regs, pkt);
+	obj->ops->eval(obj, regs, pkt);
 }
 
 static int nft_objref_map_init(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 25e33159be57..f63c1797b8bc 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -151,14 +151,18 @@ static int nft_quota_obj_dump(struct sk_buff *skb, struct nft_object *obj,
 	return nft_quota_do_dump(skb, priv, reset);
 }
 
-static struct nft_object_type nft_quota_obj __read_mostly = {
-	.type		= NFT_OBJECT_QUOTA,
+static const struct nft_object_ops nft_quota_obj_ops = {
 	.size		= sizeof(struct nft_quota),
-	.maxattr	= NFTA_QUOTA_MAX,
-	.policy		= nft_quota_policy,
 	.init		= nft_quota_obj_init,
 	.eval		= nft_quota_obj_eval,
 	.dump		= nft_quota_obj_dump,
+};
+
+static struct nft_object_type nft_quota_obj __read_mostly = {
+	.type		= NFT_OBJECT_QUOTA,
+	.ops		= &nft_quota_obj_ops,
+	.maxattr	= NFTA_QUOTA_MAX,
+	.policy		= nft_quota_policy,
 	.owner		= THIS_MODULE,
 };
 
-- 
2.14.1

