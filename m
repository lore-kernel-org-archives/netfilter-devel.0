From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] netfilter: nf_tables: allocate obj handle and delete obj via obj handle
Date: Fri, 19 Jan 2018 00:23:45 +0530
Message-ID: <20180118185345.9179-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:39174 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755827AbeARSyF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jan 2018 13:54:05 -0500
Received: by mail-pg0-f66.google.com with SMTP id w17so9198141pgv.6
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jan 2018 10:54:05 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch add code to allocate unique object handles and delete objects
via those unique object handles.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 include/net/netfilter/nf_tables.h        |  2 ++
 include/uapi/linux/netfilter/nf_tables.h |  3 +++
 net/netfilter/nf_tables_api.c            | 30 +++++++++++++++++++++++++++---
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 144ffc750358..3bf552cf59f4 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1018,6 +1018,7 @@ int nft_verdict_dump(struct sk_buff *skb, int type,
  *	@list: table stateful object list node
  *	@table: table this object belongs to
  *	@name: name of this stateful object
+ *	@handle: unique object handle
  *	@genmask: generation mask
  *	@use: number of references to this stateful object
  * 	@data: object data, layout depends on type
@@ -1030,6 +1031,7 @@ struct nft_object {
 	struct nft_table		*table;
 	u32				genmask:2,
 					use:30;
+	u64				handle;
 	/* runtime data below here */
 	const struct nft_object_ops	*ops ____cacheline_aligned;
 	unsigned char			data[]
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 240fe7d98604..0f4fe2fd5508 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1296,6 +1296,7 @@ enum nft_ct_helper_attributes {
  *
  * @NFTA_OBJ_TABLE: name of the table containing the expression (NLA_STRING)
  * @NFTA_OBJ_NAME: name of this expression type (NLA_STRING)
+ * @NFTA_OBJ_HANDLE: object handle (NLA_U64)
  * @NFTA_OBJ_TYPE: stateful object type (NLA_U32)
  * @NFTA_OBJ_DATA: stateful object data (NLA_NESTED)
  * @NFTA_OBJ_USE: number of references to this expression (NLA_U32)
@@ -1307,6 +1308,8 @@ enum nft_object_attributes {
 	NFTA_OBJ_TYPE,
 	NFTA_OBJ_DATA,
 	NFTA_OBJ_USE,
+	NFTA_OBJ_HANDLE,
+	NFTA_OBJ_PAD,
 	__NFTA_OBJ_MAX
 };
 #define NFTA_OBJ_MAX		(__NFTA_OBJ_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4f2ebcd16a1c..514196719c95 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4451,6 +4451,21 @@ struct nft_object *nf_tables_obj_lookup(const struct nft_table *table,
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
@@ -4458,6 +4473,7 @@ static const struct nla_policy nft_obj_policy[NFTA_OBJ_MAX + 1] = {
 				    .len = NFT_OBJ_MAXNAMELEN - 1 },
 	[NFTA_OBJ_TYPE]		= { .type = NLA_U32 },
 	[NFTA_OBJ_DATA]		= { .type = NLA_NESTED },
+	[NFTA_OBJ_HANDLE]	= { .type = NLA_U64},
 };
 
 static struct nft_object *nft_obj_init(const struct nft_ctx *ctx,
@@ -4610,6 +4626,7 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 	}
 	obj->table = table;
 	obj->name = nla_strdup(nla[NFTA_OBJ_NAME], GFP_KERNEL);
+	obj->handle = nf_tables_alloc_handle(table);
 	if (!obj->name) {
 		err = -ENOMEM;
 		goto err2;
@@ -4655,7 +4672,9 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 	    nla_put_string(skb, NFTA_OBJ_NAME, obj->name) ||
 	    nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->ops->type->type)) ||
 	    nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
-	    nft_object_dump(skb, NFTA_OBJ_DATA, obj, reset))
+	    nft_object_dump(skb, NFTA_OBJ_DATA, obj, reset) ||
+	    nla_put_be64(skb, NFTA_OBJ_HANDLE, cpu_to_be64(obj->handle),
+			 NFTA_OBJ_PAD))
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
@@ -4858,7 +4877,7 @@ static int nf_tables_delobj(struct net *net, struct sock *nlsk,
 	u32 objtype;
 
 	if (!nla[NFTA_OBJ_TYPE] ||
-	    !nla[NFTA_OBJ_NAME])
+	    (!nla[NFTA_OBJ_NAME] && !nla[NFTA_OBJ_HANDLE]))
 		return -EINVAL;
 
 	afi = nf_tables_afinfo_lookup(net, family, true);
@@ -4870,7 +4889,12 @@ static int nf_tables_delobj(struct net *net, struct sock *nlsk,
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
-- 
2.11.0

