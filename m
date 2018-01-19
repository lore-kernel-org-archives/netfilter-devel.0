From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: nf_tables: allocate handle and delete objects via handle
Date: Fri, 19 Jan 2018 13:21:42 +0100
Message-ID: <20180119122142.22232-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47336 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754104AbeASMVu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 07:21:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3E437DA72B
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:21:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 25E6FDA382
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:21:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B640DA84E
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:21:46 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id F1AE24265A2F
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:21:45 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Harsha Sharma <harshasharmaiitr@gmail.com>

This patch allows deletion of objects via unique handle which can be
listed via '-a' option.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Harsha: I have collapsed all of your patches to add handles everywhere before
	 pushing this into my nf-next.git tree.

 include/net/netfilter/nf_tables.h        |  11 ++-
 include/uapi/linux/netfilter/nf_tables.h |  10 +++
 net/netfilter/nf_tables_api.c            | 146 ++++++++++++++++++++++++++++---
 3 files changed, 153 insertions(+), 14 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4aca413367ee..663b015dace5 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -374,6 +374,7 @@ void nft_unregister_set(struct nft_set_type *type);
  *	@list: table set list node
  *	@bindings: list of set bindings
  * 	@name: name of the set
+ *	@handle: unique handle of the set
  * 	@ktype: key type (numeric type defined by userspace, not used in the kernel)
  * 	@dtype: data type (verdict or numeric type defined by userspace)
  * 	@objtype: object type (see NFT_OBJECT_* definitions)
@@ -396,6 +397,7 @@ struct nft_set {
 	struct list_head		list;
 	struct list_head		bindings;
 	char				*name;
+	u64				handle;
 	u32				ktype;
 	u32				dtype;
 	u32				objtype;
@@ -946,6 +948,7 @@ unsigned int nft_do_chain(struct nft_pktinfo *pkt, void *priv);
  *	@objects: stateful objects in the table
  *	@flowtables: flow tables in the table
  *	@hgenerator: handle generator state
+ *	@handle: table handle
  *	@use: number of chain references to this table
  *	@flags: table flag (see enum nft_table_flags)
  *	@genmask: generation mask
@@ -959,6 +962,7 @@ struct nft_table {
 	struct list_head		objects;
 	struct list_head		flowtables;
 	u64				hgenerator;
+	u64				handle;
 	u32				use;
 	u16				family:6,
 					flags:8,
@@ -983,9 +987,9 @@ int nft_verdict_dump(struct sk_buff *skb, int type,
  *	@name: name of this stateful object
  *	@genmask: generation mask
  *	@use: number of references to this stateful object
- * 	@data: object data, layout depends on type
+ *	@handle: unique object handle
  *	@ops: object operations
- *	@data: pointer to object data
+ * 	@data: object data, layout depends on type
  */
 struct nft_object {
 	struct list_head		list;
@@ -993,6 +997,7 @@ struct nft_object {
 	struct nft_table		*table;
 	u32				genmask:2,
 					use:30;
+	u64				handle;
 	/* runtime data below here */
 	const struct nft_object_ops	*ops ____cacheline_aligned;
 	unsigned char			data[]
@@ -1074,6 +1079,7 @@ void nft_unregister_obj(struct nft_object_type *obj_type);
  *	@ops_len: number of hooks in array
  *	@genmask: generation mask
  *	@use: number of references to this flow table
+ * 	@handle: unique object handle
  *	@data: rhashtable and garbage collector
  * 	@ops: array of hooks
  */
@@ -1086,6 +1092,7 @@ struct nft_flowtable {
 	int				ops_len;
 	u32				genmask:2,
 					use:30;
+	u64				handle;
 	/* runtime data below here */
 	struct nf_hook_ops		*ops ____cacheline_aligned;
 	struct nf_flowtable		data;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 53e8dd2a3a03..66dceee0ae30 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -174,6 +174,8 @@ enum nft_table_attributes {
 	NFTA_TABLE_NAME,
 	NFTA_TABLE_FLAGS,
 	NFTA_TABLE_USE,
+	NFTA_TABLE_HANDLE,
+	NFTA_TABLE_PAD,
 	__NFTA_TABLE_MAX
 };
 #define NFTA_TABLE_MAX		(__NFTA_TABLE_MAX - 1)
@@ -317,6 +319,7 @@ enum nft_set_desc_attributes {
  * @NFTA_SET_GC_INTERVAL: garbage collection interval (NLA_U32)
  * @NFTA_SET_USERDATA: user data (NLA_BINARY)
  * @NFTA_SET_OBJ_TYPE: stateful object type (NLA_U32: NFT_OBJECT_*)
+ * @NFTA_SET_HANDLE: set handle (NLA_U64)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -335,6 +338,7 @@ enum nft_set_attributes {
 	NFTA_SET_USERDATA,
 	NFTA_SET_PAD,
 	NFTA_SET_OBJ_TYPE,
+	NFTA_SET_HANDLE,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
@@ -1314,6 +1318,7 @@ enum nft_ct_helper_attributes {
  * @NFTA_OBJ_TYPE: stateful object type (NLA_U32)
  * @NFTA_OBJ_DATA: stateful object data (NLA_NESTED)
  * @NFTA_OBJ_USE: number of references to this expression (NLA_U32)
+ * @NFTA_OBJ_HANDLE: object handle (NLA_U64)
  */
 enum nft_object_attributes {
 	NFTA_OBJ_UNSPEC,
@@ -1322,6 +1327,8 @@ enum nft_object_attributes {
 	NFTA_OBJ_TYPE,
 	NFTA_OBJ_DATA,
 	NFTA_OBJ_USE,
+	NFTA_OBJ_HANDLE,
+	NFTA_OBJ_PAD,
 	__NFTA_OBJ_MAX
 };
 #define NFTA_OBJ_MAX		(__NFTA_OBJ_MAX - 1)
@@ -1333,6 +1340,7 @@ enum nft_object_attributes {
  * @NFTA_FLOWTABLE_NAME: name of this flow table (NLA_STRING)
  * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration(NLA_U32)
  * @NFTA_FLOWTABLE_USE: number of references to this flow table (NLA_U32)
+ * @NFTA_FLOWTABLE_HANDLE: object handle (NLA_U64)
  */
 enum nft_flowtable_attributes {
 	NFTA_FLOWTABLE_UNSPEC,
@@ -1340,6 +1348,8 @@ enum nft_flowtable_attributes {
 	NFTA_FLOWTABLE_NAME,
 	NFTA_FLOWTABLE_HOOK,
 	NFTA_FLOWTABLE_USE,
+	NFTA_FLOWTABLE_HANDLE,
+	NFTA_FLOWTABLE_PAD,
 	__NFTA_FLOWTABLE_MAX
 };
 #define NFTA_FLOWTABLE_MAX	(__NFTA_FLOWTABLE_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b541e5094dce..1addc401ff7d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -26,6 +26,7 @@
 static LIST_HEAD(nf_tables_expressions);
 static LIST_HEAD(nf_tables_objects);
 static LIST_HEAD(nf_tables_flowtables);
+static u64 table_handle;
 
 static void nft_ctx_init(struct nft_ctx *ctx,
 			 struct net *net,
@@ -332,6 +333,20 @@ static struct nft_table *nft_table_lookup(const struct net *net,
 	return NULL;
 }
 
+static struct nft_table *nft_table_lookup_byhandle(const struct net *net,
+						   const struct nlattr *nla,
+						   u8 genmask)
+{
+	struct nft_table *table;
+
+	list_for_each_entry(table, &net->nft.tables, list) {
+		if (be64_to_cpu(nla_get_be64(nla)) == table->handle &&
+		    nft_active_genmask(table, genmask))
+			return table;
+	}
+	return NULL;
+}
+
 static struct nft_table *nf_tables_table_lookup(const struct net *net,
 						const struct nlattr *nla,
 						u8 family, u8 genmask)
@@ -348,6 +363,22 @@ static struct nft_table *nf_tables_table_lookup(const struct net *net,
 	return ERR_PTR(-ENOENT);
 }
 
+static struct nft_table *nf_tables_table_lookup_byhandle(const struct net *net,
+							 const struct nlattr *nla,
+							 u8 genmask)
+{
+	struct nft_table *table;
+
+	if (nla == NULL)
+		return ERR_PTR(-EINVAL);
+
+	table = nft_table_lookup_byhandle(net, nla, genmask);
+	if (table != NULL)
+		return table;
+
+	return ERR_PTR(-ENOENT);
+}
+
 static inline u64 nf_tables_alloc_handle(struct nft_table *table)
 {
 	return ++table->hgenerator;
@@ -394,6 +425,7 @@ static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
 	[NFTA_TABLE_NAME]	= { .type = NLA_STRING,
 				    .len = NFT_TABLE_MAXNAMELEN - 1 },
 	[NFTA_TABLE_FLAGS]	= { .type = NLA_U32 },
+	[NFTA_TABLE_HANDLE]	= { .type = NLA_U64 },
 };
 
 static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
@@ -415,7 +447,9 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 
 	if (nla_put_string(skb, NFTA_TABLE_NAME, table->name) ||
 	    nla_put_be32(skb, NFTA_TABLE_FLAGS, htonl(table->flags)) ||
-	    nla_put_be32(skb, NFTA_TABLE_USE, htonl(table->use)))
+	    nla_put_be32(skb, NFTA_TABLE_USE, htonl(table->use)) ||
+	    nla_put_be64(skb, NFTA_TABLE_HANDLE, cpu_to_be64(table->handle),
+			 NFTA_TABLE_PAD))
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
@@ -674,6 +708,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	INIT_LIST_HEAD(&table->flowtables);
 	table->family = family;
 	table->flags = flags;
+	table->handle = ++table_handle;
 
 	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
 	err = nft_trans_table_add(&ctx, NFT_MSG_NEWTABLE);
@@ -791,11 +826,18 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 	struct nft_ctx ctx;
 
 	nft_ctx_init(&ctx, net, skb, nlh, 0, NULL, NULL, nla);
-	if (family == AF_UNSPEC || nla[NFTA_TABLE_NAME] == NULL)
+	if (family == AF_UNSPEC ||
+	    (!nla[NFTA_TABLE_NAME] && !nla[NFTA_TABLE_HANDLE]))
 		return nft_flush(&ctx, family);
 
-	table = nf_tables_table_lookup(net, nla[NFTA_TABLE_NAME], family,
-				       genmask);
+	if (nla[NFTA_TABLE_HANDLE])
+		table = nf_tables_table_lookup_byhandle(net,
+							nla[NFTA_TABLE_HANDLE],
+							genmask);
+	else
+		table = nf_tables_table_lookup(net, nla[NFTA_TABLE_NAME],
+					       family, genmask);
+
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -1539,6 +1581,7 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
 	struct nft_rule *rule;
 	int family = nfmsg->nfgen_family;
 	struct nft_ctx ctx;
+	u64 handle;
 	u32 use;
 	int err;
 
@@ -1547,7 +1590,12 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-	chain = nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME], genmask);
+	if (nla[NFTA_CHAIN_HANDLE]) {
+		handle = be64_to_cpu(nla_get_be64(nla[NFTA_CHAIN_HANDLE]));
+		chain = nf_tables_chain_lookup_byhandle(table, handle, genmask);
+	} else {
+		chain = nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME], genmask);
+	}
 	if (IS_ERR(chain))
 		return PTR_ERR(chain);
 
@@ -2503,6 +2551,7 @@ static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 	[NFTA_SET_USERDATA]		= { .type = NLA_BINARY,
 					    .len  = NFT_USERDATA_MAXLEN },
 	[NFTA_SET_OBJ_TYPE]		= { .type = NLA_U32 },
+	[NFTA_SET_HANDLE]		= { .type = NLA_U64 },
 };
 
 static const struct nla_policy nft_set_desc_policy[NFTA_SET_DESC_MAX + 1] = {
@@ -2546,6 +2595,22 @@ static struct nft_set *nf_tables_set_lookup(const struct nft_table *table,
 	return ERR_PTR(-ENOENT);
 }
 
+static struct nft_set *nf_tables_set_lookup_byhandle(const struct nft_table *table,
+						     const struct nlattr *nla, u8 genmask)
+{
+	struct nft_set *set;
+
+	if (nla == NULL)
+		return ERR_PTR(-EINVAL);
+
+	list_for_each_entry(set, &table->sets, list) {
+		if (be64_to_cpu(nla_get_be64(nla)) == set->handle &&
+		    nft_active_genmask(set, genmask))
+			return set;
+	}
+	return ERR_PTR(-ENOENT);
+}
+
 static struct nft_set *nf_tables_set_lookup_byid(const struct net *net,
 						 const struct nlattr *nla,
 						 u8 genmask)
@@ -2661,6 +2726,9 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 		goto nla_put_failure;
 	if (nla_put_string(skb, NFTA_SET_NAME, set->name))
 		goto nla_put_failure;
+	if (nla_put_be64(skb, NFTA_SET_HANDLE, cpu_to_be64(set->handle),
+			 NFTA_SET_PAD))
+		goto nla_put_failure;
 	if (set->flags != 0)
 		if (nla_put_be32(skb, NFTA_SET_FLAGS, htonl(set->flags)))
 			goto nla_put_failure;
@@ -3069,6 +3137,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	set->udata  = udata;
 	set->timeout = timeout;
 	set->gc_int = gc_int;
+	set->handle = nf_tables_alloc_handle(table);
 
 	err = ops->init(set, &desc, nla);
 	if (err < 0)
@@ -3126,7 +3195,10 @@ static int nf_tables_delset(struct net *net, struct sock *nlsk,
 	if (err < 0)
 		return err;
 
-	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_NAME], genmask);
+	if (nla[NFTA_SET_HANDLE])
+		set = nf_tables_set_lookup_byhandle(ctx.table, nla[NFTA_SET_HANDLE], genmask);
+	else
+		set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_NAME], genmask);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
@@ -4256,6 +4328,21 @@ struct nft_object *nf_tables_obj_lookup(const struct nft_table *table,
 }
 EXPORT_SYMBOL_GPL(nf_tables_obj_lookup);
 
+struct nft_object *nf_tables_obj_lookup_byhandle(const struct nft_table *table,
+						 const struct nlattr *nla,
+						 u32 objtype, u8 genmask)
+{
+	struct nft_object *obj;
+
+	list_for_each_entry(obj, &table->objects, list) {
+		if (be64_to_cpu(nla_get_be64(nla)) == obj->handle &&
+		    objtype == obj->ops->type->type &&
+		    nft_active_genmask(obj, genmask))
+			return obj;
+	}
+	return ERR_PTR(-ENOENT);
+}
+
 static const struct nla_policy nft_obj_policy[NFTA_OBJ_MAX + 1] = {
 	[NFTA_OBJ_TABLE]	= { .type = NLA_STRING,
 				    .len = NFT_TABLE_MAXNAMELEN - 1 },
@@ -4263,6 +4350,7 @@ static const struct nla_policy nft_obj_policy[NFTA_OBJ_MAX + 1] = {
 				    .len = NFT_OBJ_MAXNAMELEN - 1 },
 	[NFTA_OBJ_TYPE]		= { .type = NLA_U32 },
 	[NFTA_OBJ_DATA]		= { .type = NLA_NESTED },
+	[NFTA_OBJ_HANDLE]	= { .type = NLA_U64},
 };
 
 static struct nft_object *nft_obj_init(const struct nft_ctx *ctx,
@@ -4410,6 +4498,8 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 		goto err1;
 	}
 	obj->table = table;
+	obj->handle = nf_tables_alloc_handle(table);
+
 	obj->name = nla_strdup(nla[NFTA_OBJ_NAME], GFP_KERNEL);
 	if (!obj->name) {
 		err = -ENOMEM;
@@ -4456,7 +4546,9 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 	    nla_put_string(skb, NFTA_OBJ_NAME, obj->name) ||
 	    nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->ops->type->type)) ||
 	    nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
-	    nft_object_dump(skb, NFTA_OBJ_DATA, obj, reset))
+	    nft_object_dump(skb, NFTA_OBJ_DATA, obj, reset) ||
+	    nla_put_be64(skb, NFTA_OBJ_HANDLE, cpu_to_be64(obj->handle),
+			 NFTA_OBJ_PAD))
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
@@ -4654,7 +4746,7 @@ static int nf_tables_delobj(struct net *net, struct sock *nlsk,
 	u32 objtype;
 
 	if (!nla[NFTA_OBJ_TYPE] ||
-	    !nla[NFTA_OBJ_NAME])
+	    (!nla[NFTA_OBJ_NAME] && !nla[NFTA_OBJ_HANDLE]))
 		return -EINVAL;
 
 	table = nf_tables_table_lookup(net, nla[NFTA_OBJ_TABLE], family,
@@ -4663,7 +4755,12 @@ static int nf_tables_delobj(struct net *net, struct sock *nlsk,
 		return PTR_ERR(table);
 
 	objtype = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
-	obj = nf_tables_obj_lookup(table, nla[NFTA_OBJ_NAME], objtype, genmask);
+	if (nla[NFTA_OBJ_HANDLE])
+		obj = nf_tables_obj_lookup_byhandle(table, nla[NFTA_OBJ_HANDLE],
+						    objtype, genmask);
+	else
+		obj = nf_tables_obj_lookup(table, nla[NFTA_OBJ_NAME],
+					   objtype, genmask);
 	if (IS_ERR(obj))
 		return PTR_ERR(obj);
 	if (obj->use > 0)
@@ -4735,6 +4832,7 @@ static const struct nla_policy nft_flowtable_policy[NFTA_FLOWTABLE_MAX + 1] = {
 	[NFTA_FLOWTABLE_NAME]		= { .type = NLA_STRING,
 					    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_FLOWTABLE_HOOK]		= { .type = NLA_NESTED },
+	[NFTA_FLOWTABLE_HANDLE]		= { .type = NLA_U64 },
 };
 
 struct nft_flowtable *nf_tables_flowtable_lookup(const struct nft_table *table,
@@ -4752,6 +4850,20 @@ struct nft_flowtable *nf_tables_flowtable_lookup(const struct nft_table *table,
 }
 EXPORT_SYMBOL_GPL(nf_tables_flowtable_lookup);
 
+struct nft_flowtable *
+nf_tables_flowtable_lookup_byhandle(const struct nft_table *table,
+				    const struct nlattr *nla, u8 genmask)
+{
+       struct nft_flowtable *flowtable;
+
+       list_for_each_entry(flowtable, &table->flowtables, list) {
+               if (be64_to_cpu(nla_get_be64(nla)) == flowtable->handle &&
+                   nft_active_genmask(flowtable, genmask))
+                       return flowtable;
+       }
+       return ERR_PTR(-ENOENT);
+}
+
 #define NFT_FLOWTABLE_DEVICE_MAX	8
 
 static int nf_tables_parse_devices(const struct nft_ctx *ctx,
@@ -4960,6 +5072,8 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 		return -ENOMEM;
 
 	flowtable->table = table;
+	flowtable->handle = nf_tables_alloc_handle(table);
+
 	flowtable->name = nla_strdup(nla[NFTA_FLOWTABLE_NAME], GFP_KERNEL);
 	if (!flowtable->name) {
 		err = -ENOMEM;
@@ -5034,8 +5148,14 @@ static int nf_tables_delflowtable(struct net *net, struct sock *nlsk,
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-	flowtable = nf_tables_flowtable_lookup(table, nla[NFTA_FLOWTABLE_NAME],
-					       genmask);
+	if (nla[NFTA_FLOWTABLE_HANDLE])
+		flowtable = nf_tables_flowtable_lookup_byhandle(table,
+								nla[NFTA_FLOWTABLE_HANDLE],
+								genmask);
+	else
+		flowtable = nf_tables_flowtable_lookup(table,
+						       nla[NFTA_FLOWTABLE_NAME],
+						       genmask);
 	if (IS_ERR(flowtable))
                 return PTR_ERR(flowtable);
 	if (flowtable->use > 0)
@@ -5068,7 +5188,9 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 
 	if (nla_put_string(skb, NFTA_FLOWTABLE_TABLE, flowtable->table->name) ||
 	    nla_put_string(skb, NFTA_FLOWTABLE_NAME, flowtable->name) ||
-	    nla_put_be32(skb, NFTA_FLOWTABLE_USE, htonl(flowtable->use)))
+	    nla_put_be32(skb, NFTA_FLOWTABLE_USE, htonl(flowtable->use)) ||
+	    nla_put_be64(skb, NFTA_FLOWTABLE_HANDLE, cpu_to_be64(flowtable->handle),
+			 NFTA_FLOWTABLE_PAD))
 		goto nla_put_failure;
 
 	nest = nla_nest_start(skb, NFTA_FLOWTABLE_HOOK);
-- 
2.11.0

