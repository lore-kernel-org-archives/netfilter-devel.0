From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 09/11] netfilter: nf_tables: add stateful object reference to set elements
Date: Mon, 28 Nov 2016 01:01:08 +0100
Message-ID: <1480291270-3715-10-git-send-email-pablo@netfilter.org>
References: <1480291270-3715-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40128 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753809AbcK1ABa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Nov 2016 19:01:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D5916DA722
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C44E6524C1
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7DF4D524C1
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:27 +0100 (CET)
In-Reply-To: <1480291270-3715-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows you to refer to stateful objects from set elements.
This provides the infrastructure to create maps where the right hand
side of the mapping is a stateful object.

This allows us to build dictionaries of stateful objects, that you can
use to perform fast lookups using any arbitrary key combination.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |  9 ++++
 include/uapi/linux/netfilter/nf_tables.h |  8 ++++
 net/netfilter/nf_tables_api.c            | 70 +++++++++++++++++++++++++++-----
 3 files changed, 77 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index d9cf4bfe5fcf..0ab6dc25c5d3 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -335,6 +335,7 @@ void nft_unregister_set(struct nft_set_ops *ops);
  * 	@name: name of the set
  * 	@ktype: key type (numeric type defined by userspace, not used in the kernel)
  * 	@dtype: data type (verdict or numeric type defined by userspace)
+ * 	@objtype: object type (see NFT_OBJECT_* definitions)
  * 	@size: maximum set size
  * 	@nelems: number of elements
  * 	@ndeact: number of deactivated elements queued for removal
@@ -356,6 +357,7 @@ struct nft_set {
 	char				name[NFT_SET_MAXNAMELEN];
 	u32				ktype;
 	u32				dtype;
+	u32				objtype;
 	u32				size;
 	atomic_t			nelems;
 	u32				ndeact;
@@ -425,6 +427,7 @@ void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
  *	@NFT_SET_EXT_EXPIRATION: element expiration time
  *	@NFT_SET_EXT_USERDATA: user data associated with the element
  *	@NFT_SET_EXT_EXPR: expression assiociated with the element
+ *	@NFT_SET_EXT_OBJREF: stateful object reference associated with element
  *	@NFT_SET_EXT_NUM: number of extension types
  */
 enum nft_set_extensions {
@@ -435,6 +438,7 @@ enum nft_set_extensions {
 	NFT_SET_EXT_EXPIRATION,
 	NFT_SET_EXT_USERDATA,
 	NFT_SET_EXT_EXPR,
+	NFT_SET_EXT_OBJREF,
 	NFT_SET_EXT_NUM
 };
 
@@ -563,6 +567,11 @@ static inline struct nft_set_ext *nft_set_elem_ext(const struct nft_set *set,
 	return elem + set->ops->elemsize;
 }
 
+static inline struct nft_object **nft_set_ext_obj(const struct nft_set_ext *ext)
+{
+	return nft_set_ext(ext, NFT_SET_EXT_OBJREF);
+}
+
 void *nft_set_elem_init(const struct nft_set *set,
 			const struct nft_set_ext_tmpl *tmpl,
 			const u32 *key, const u32 *data,
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index cf2130457d00..6835d62c17c2 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -255,6 +255,7 @@ enum nft_rule_compat_attributes {
  * @NFT_SET_MAP: set is used as a dictionary
  * @NFT_SET_TIMEOUT: set uses timeouts
  * @NFT_SET_EVAL: set contains expressions for evaluation
+ * @NFT_SET_OBJECT: set contains stateful objects
  */
 enum nft_set_flags {
 	NFT_SET_ANONYMOUS		= 0x1,
@@ -263,6 +264,7 @@ enum nft_set_flags {
 	NFT_SET_MAP			= 0x8,
 	NFT_SET_TIMEOUT			= 0x10,
 	NFT_SET_EVAL			= 0x20,
+	NFT_SET_OBJECT			= 0x40,
 };
 
 /**
@@ -304,6 +306,7 @@ enum nft_set_desc_attributes {
  * @NFTA_SET_TIMEOUT: default timeout value (NLA_U64)
  * @NFTA_SET_GC_INTERVAL: garbage collection interval (NLA_U32)
  * @NFTA_SET_USERDATA: user data (NLA_BINARY)
+ * @NFTA_SET_OBJ_TYPE: stateful object type (NLA_U32: NFT_OBJECT_*)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -321,6 +324,7 @@ enum nft_set_attributes {
 	NFTA_SET_GC_INTERVAL,
 	NFTA_SET_USERDATA,
 	NFTA_SET_PAD,
+	NFTA_SET_OBJ_TYPE,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
@@ -344,6 +348,7 @@ enum nft_set_elem_flags {
  * @NFTA_SET_ELEM_EXPIRATION: expiration time (NLA_U64)
  * @NFTA_SET_ELEM_USERDATA: user data (NLA_BINARY)
  * @NFTA_SET_ELEM_EXPR: expression (NLA_NESTED: nft_expr_attributes)
+ * @NFTA_SET_ELEM_OBJREF: stateful object reference (NLA_STRING)
  */
 enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_UNSPEC,
@@ -355,6 +360,7 @@ enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_USERDATA,
 	NFTA_SET_ELEM_EXPR,
 	NFTA_SET_ELEM_PAD,
+	NFTA_SET_ELEM_OBJREF,
 	__NFTA_SET_ELEM_MAX
 };
 #define NFTA_SET_ELEM_MAX	(__NFTA_SET_ELEM_MAX - 1)
@@ -1237,6 +1243,8 @@ enum nft_fib_flags {
 #define NFT_OBJECT_UNSPEC	0
 #define NFT_OBJECT_COUNTER	1
 #define NFT_OBJECT_QUOTA	2
+#define __NFT_OBJECT_MAX	3
+#define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
 
 /**
  * enum nft_object_attributes - nf_tables stateful object netlink attributes
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b37c6b6d5ac4..fb5f7e474e85 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2480,6 +2480,7 @@ static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 	[NFTA_SET_GC_INTERVAL]		= { .type = NLA_U32 },
 	[NFTA_SET_USERDATA]		= { .type = NLA_BINARY,
 					    .len  = NFT_USERDATA_MAXLEN },
+	[NFTA_SET_OBJ_TYPE]		= { .type = NLA_U32 },
 };
 
 static const struct nla_policy nft_set_desc_policy[NFTA_SET_DESC_MAX + 1] = {
@@ -2637,6 +2638,9 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 		if (nla_put_be32(skb, NFTA_SET_DATA_LEN, htonl(set->dlen)))
 			goto nla_put_failure;
 	}
+	if (set->flags & NFT_SET_OBJECT &&
+	    nla_put_be32(skb, NFTA_SET_OBJ_TYPE, htonl(set->objtype)))
+		goto nla_put_failure;
 
 	if (set->timeout &&
 	    nla_put_be64(skb, NFTA_SET_TIMEOUT, cpu_to_be64(set->timeout),
@@ -2865,7 +2869,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	unsigned int size;
 	bool create;
 	u64 timeout;
-	u32 ktype, dtype, flags, policy, gc_int;
+	u32 ktype, dtype, flags, policy, gc_int, objtype;
 	struct nft_set_desc desc;
 	unsigned char *udata;
 	u16 udlen;
@@ -2895,11 +2899,12 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 		flags = ntohl(nla_get_be32(nla[NFTA_SET_FLAGS]));
 		if (flags & ~(NFT_SET_ANONYMOUS | NFT_SET_CONSTANT |
 			      NFT_SET_INTERVAL | NFT_SET_TIMEOUT |
-			      NFT_SET_MAP | NFT_SET_EVAL))
+			      NFT_SET_MAP | NFT_SET_EVAL |
+			      NFT_SET_OBJECT))
 			return -EINVAL;
-		/* Only one of both operations is supported */
-		if ((flags & (NFT_SET_MAP | NFT_SET_EVAL)) ==
-			     (NFT_SET_MAP | NFT_SET_EVAL))
+		/* Only one of these operations is supported */
+		if ((flags & (NFT_SET_MAP | NFT_SET_EVAL | NFT_SET_OBJECT)) ==
+			     (NFT_SET_MAP | NFT_SET_EVAL | NFT_SET_OBJECT))
 			return -EOPNOTSUPP;
 	}
 
@@ -2924,6 +2929,17 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	} else if (flags & NFT_SET_MAP)
 		return -EINVAL;
 
+	if (nla[NFTA_SET_OBJ_TYPE] != NULL) {
+		if (!(flags & NFT_SET_OBJECT))
+			return -EINVAL;
+
+		objtype = ntohl(nla_get_be32(nla[NFTA_SET_OBJ_TYPE]));
+		if (objtype == NFT_OBJECT_UNSPEC ||
+		    objtype > NFT_OBJECT_MAX)
+			return -EINVAL;
+	} else if (flags & NFT_SET_OBJECT)
+		return -EINVAL;
+
 	timeout = 0;
 	if (nla[NFTA_SET_TIMEOUT] != NULL) {
 		if (!(flags & NFT_SET_TIMEOUT))
@@ -3010,6 +3026,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	set->ktype = ktype;
 	set->klen  = desc.klen;
 	set->dtype = dtype;
+	set->objtype = objtype;
 	set->dlen  = desc.dlen;
 	set->flags = flags;
 	set->size  = desc.size;
@@ -3150,6 +3167,10 @@ const struct nft_set_ext_type nft_set_ext_types[] = {
 	[NFT_SET_EXT_EXPR]		= {
 		.align	= __alignof__(struct nft_expr),
 	},
+	[NFT_SET_EXT_OBJREF]		= {
+		.len	= sizeof(struct nft_object *),
+		.align	= __alignof__(struct nft_object *),
+	},
 	[NFT_SET_EXT_FLAGS]		= {
 		.len	= sizeof(u8),
 		.align	= __alignof__(u8),
@@ -3238,6 +3259,11 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 	    nft_expr_dump(skb, NFTA_SET_ELEM_EXPR, nft_set_ext_expr(ext)) < 0)
 		goto nla_put_failure;
 
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) &&
+	    nla_put_string(skb, NFTA_SET_ELEM_OBJREF,
+			   (*nft_set_ext_obj(ext))->name) < 0)
+		goto nla_put_failure;
+
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
 	    nla_put_be32(skb, NFTA_SET_ELEM_FLAGS,
 		         htonl(*nft_set_ext_flags(ext))))
@@ -3530,7 +3556,8 @@ void nft_set_elem_destroy(const struct nft_set *set, void *elem)
 		nft_data_uninit(nft_set_ext_data(ext), set->dtype);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
 		nf_tables_expr_destroy(NULL, nft_set_ext_expr(ext));
-
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF))
+		(*nft_set_ext_obj(ext))->use--;
 	kfree(elem);
 }
 EXPORT_SYMBOL_GPL(nft_set_elem_destroy);
@@ -3555,11 +3582,13 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr, u32 nlmsg_flags)
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
+	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_data_desc d1, d2;
 	struct nft_set_ext_tmpl tmpl;
 	struct nft_set_ext *ext, *ext2;
 	struct nft_set_elem elem;
 	struct nft_set_binding *binding;
+	struct nft_object *obj = NULL;
 	struct nft_userdata *udata;
 	struct nft_data data;
 	enum nft_registers dreg;
@@ -3621,6 +3650,20 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
 	}
 
+	if (nla[NFTA_SET_ELEM_OBJREF] != NULL) {
+		if (!(set->flags & NFT_SET_OBJECT)) {
+			err = -EINVAL;
+			goto err2;
+		}
+		obj = nf_tables_obj_lookup(ctx->table, nla[NFTA_SET_ELEM_OBJREF],
+					   set->objtype, genmask);
+		if (IS_ERR(obj)) {
+			err = PTR_ERR(obj);
+			goto err2;
+		}
+		nft_set_ext_add(&tmpl, NFT_SET_EXT_OBJREF);
+	}
+
 	if (nla[NFTA_SET_ELEM_DATA] != NULL) {
 		err = nft_data_init(ctx, &data, sizeof(data), &d2,
 				    nla[NFTA_SET_ELEM_DATA]);
@@ -3678,6 +3721,10 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		udata->len = ulen - 1;
 		nla_memcpy(&udata->data, nla[NFTA_SET_ELEM_USERDATA], ulen);
 	}
+	if (obj) {
+		*nft_set_ext_obj(ext) = obj;
+		obj->use++;
+	}
 
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL)
@@ -3687,10 +3734,13 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	err = set->ops->insert(ctx->net, set, &elem, &ext2);
 	if (err) {
 		if (err == -EEXIST) {
-			if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) &&
-			    nft_set_ext_exists(ext2, NFT_SET_EXT_DATA) &&
-			    memcmp(nft_set_ext_data(ext),
-				   nft_set_ext_data(ext2), set->dlen) != 0)
+			if ((nft_set_ext_exists(ext, NFT_SET_EXT_DATA) &&
+			     nft_set_ext_exists(ext2, NFT_SET_EXT_DATA) &&
+			     memcmp(nft_set_ext_data(ext),
+				    nft_set_ext_data(ext2), set->dlen) != 0) ||
+			    (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) &&
+			     nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF) &&
+			     *nft_set_ext_obj(ext) != *nft_set_ext_obj(ext2)))
 				err = -EBUSY;
 			else if (!(nlmsg_flags & NLM_F_EXCL))
 				err = 0;
-- 
2.1.4

