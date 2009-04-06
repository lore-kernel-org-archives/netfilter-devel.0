From: Patrick McHardy <kaber@trash.net>
Subject: netfilter: nf_tables: add netlink set API
Date: Mon, 06 Apr 2009 14:58:19 +0200
Message-ID: <49D9FC6B.2080309@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050405090509070900020405"
Cc: =?ISO-8859-15?Q?fr=E9d=E9ric_ferrandis?=
	<frederic.ferrandis@gmail.com>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44614 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbZDFM6b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2009 08:58:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050405090509070900020405
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

I've done some work on a netlink API for maintaining sets independently
of rulesets and I'll probably commit this patch to my tree tonight
(I'll post some information about userspace seperately once I've
commited everything).

It allows to create, delete and query sets and add or delete set
elements incrementally. The "lookup" expression binds to an existing
set for use in the ruleset.

Unlike with rules, we can't determine the data types stored in a set
based on ruleset analysis, so the type is supplied to the kernel by
userspace for informational purposes. The kernel itself knows only
of a generic data type and the verdict type, everything but a small
reserved range can be used to encode userspace types.

The main thing missing in this patch is set implementation selection.
Currently sets are selected only based on the requested features.
Eventually the plan is to have userspace supply a description of
the set members (number of members, range, etc.) and select an
implementation based on expected performance and memory use.

Comments and bug spotting welcome :)



--------------050405090509070900020405
Content-Type: text/x-patch;
 name="set-api.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="set-api.diff"

commit 22306b2e88159cae9ae85cc5907eba4d267506e5
Author: Patrick McHardy <kaber@trash.net>
Date:   Mon Apr 6 04:36:53 2009 +0200

    netfilter: nf_tables: add netlink set API
    
    Add new netlink API for maintaining nf_tables sets independently of the
    ruleset. The API supports the following operations:
    
    - creation of sets
    - deletion of sets
    - querying of specific sets
    - dumping of all sets
    
    - addition of set elements
    - removal of set elements
    - dumping of all set elements
    
    Sets are identified by name, each table defines an individual namespace.
    The name of a set may be allocated automatically, this is mostly useful
    in combination with the NFT_SET_ANONYMOUS flag, which destroys a set
    automatically once the last reference has been released.
    
    Sets can be marked constant, meaning they're not allowed to change while
    linked to a rule. This allows to perform lockless operation for set
    types that would otherwise require locking.
    
    Additionally, if the implementation supports it, sets can (as before) be
    used as maps, associating a data value with each key (or range), by
    specifying the NFT_SET_MAP flag and can be used for interval queries by
    specifying the NFT_SET_INTERVAL flag.
    
    Set elements are added and removed incrementally. All element operations
    support batching, reducing netlink message and set lookup overhead.
    
    The old "set" and "hash" expressions are replaced by a generic "lookup"
    expression, which binds to the specified set. Userspace is not aware
    of the actual set implementation used by the kernel anymore, all
    configuration options are generic.
    
    Currently the implementation selection logic is largely missing and the
    kernel will simply use the first registered implementation supporting the
    requested operation. Eventually, the plan is to have userspace supply a
    description of the data characteristics and select the implementation
    based on expected performance and memory use.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 0309b9d..cb7d8f3 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -29,6 +29,12 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWRULE,
 	NFT_MSG_GETRULE,
 	NFT_MSG_DELRULE,
+	NFT_MSG_NEWSET,
+	NFT_MSG_GETSET,
+	NFT_MSG_DELSET,
+	NFT_MSG_NEWSETELEM,
+	NFT_MSG_GETSETELEM,
+	NFT_MSG_DELSETELEM,
 	NFT_MSG_MAX,
 };
 
@@ -73,6 +79,107 @@ enum nft_rule_attributes {
 };
 #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
 
+/**
+ * enum nft_set_flags - nf_tables set flags
+ *
+ * @NFT_SET_ANONYMOUS: name allocation, automatic cleanup on unlink
+ * @NFT_SET_CONSTANT: set contents may not change while bound
+ * @NFT_SET_INTERVAL: set contains intervals
+ * @NFT_SET_MAP: set is used as a dictionary
+ */
+enum nft_set_flags {
+	NFT_SET_ANONYMOUS		= 0x1,
+	NFT_SET_CONSTANT		= 0x2,
+	NFT_SET_INTERVAL		= 0x4,
+	NFT_SET_MAP			= 0x8,
+};
+
+/**
+ * enum nft_set_attributes - nf_tables set netlink attributes
+ *
+ * @NFTA_SET_TABLE: table name (NLA_STRING)
+ * @NFTA_SET_NAME: set name (NLA_STRING)
+ * @NFTA_SET_FLAGS: bitmask of enum nft_set_flags (NLA_U32)
+ * @NFTA_SET_KEY_TYPE: key data type, informational purpose only (NLA_U32)
+ * @NFTA_SET_KEY_LEN: key data length (NLA_U32)
+ * @NFTA_SET_DATA_TYPE: mapping data type (NLA_U32)
+ * @NFTA_SET_DATA_LEN: mapping data length (NLA_U32)
+ */
+enum nft_set_attributes {
+	NFTA_SET_UNSPEC,
+	NFTA_SET_TABLE,
+	NFTA_SET_NAME,
+	NFTA_SET_FLAGS,
+	NFTA_SET_KEY_TYPE,
+	NFTA_SET_KEY_LEN,
+	NFTA_SET_DATA_TYPE,
+	NFTA_SET_DATA_LEN,
+	__NFTA_SET_MAX
+};
+#define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
+
+/**
+ * enum nft_set_elem_flags - nf_tables set element flags
+ *
+ * @NFT_SET_ELEM_INTERVAL_END: element ends the previous interval
+ */
+enum nft_set_elem_flags {
+	NFT_SET_ELEM_INTERVAL_END	= 0x1,
+};
+
+/**
+ * enum nft_set_elem_attributes - nf_tables set element netlink attributes
+ *
+ * @NFTA_SET_ELEM_KEY: key value (NLA_NESTED: nft_data)
+ * @NFTA_SET_ELEM_DATA: data value of mapping (NLA_NESTED: nft_data_attributes)
+ * @NFTA_SET_ELEM_FLAGS: bitmask of nft_set_elem_flags (NLA_U32)
+ */
+enum nft_set_elem_attributes {
+	NFTA_SET_ELEM_UNSPEC,
+	NFTA_SET_ELEM_KEY,
+	NFTA_SET_ELEM_DATA,
+	NFTA_SET_ELEM_FLAGS,
+	__NFTA_SET_ELEM_MAX
+};
+#define NFTA_SET_ELEM_MAX	(__NFTA_SET_ELEM_MAX - 1)
+
+/**
+ * enum nft_set_elem_list_attributes - nf_tables set element list netlink attributes
+ *
+ * @NFTA_SET_ELEM_LIST_TABLE: table of the set to be changed (NLA_STRING)
+ * @NFTA_SET_ELEM_LIST_SET: name of the set to be changed (NLA_STRING)
+ * @NFTA_SET_ELEM_LIST_ELEMENTS: list of set elements (NLA_NESTED: nft_set_elem_attributes)
+ */
+enum nft_set_elem_list_attributes {
+	NFTA_SET_ELEM_LIST_UNSPEC,
+	NFTA_SET_ELEM_LIST_TABLE,
+	NFTA_SET_ELEM_LIST_SET,
+	NFTA_SET_ELEM_LIST_ELEMENTS,
+	__NFTA_SET_ELEM_LIST_MAX
+};
+#define NFTA_SET_ELEM_LIST_MAX	(__NFTA_SET_ELEM_LIST_MAX - 1)
+
+/**
+ * enum nft_data_types - nf_tables data types
+ *
+ * @NFT_DATA_VALUE: generic data
+ * @NFT_DATA_VERDICT: netfilter verdict
+ *
+ * The type of data is usually determined by the kernel directly and is not
+ * explicitly specified by userspace. The only difference are sets, where
+ * userspace specifies the key and mapping data types.
+ *
+ * The values 0xffffff00-0xffffffff are reserved for internally used types.
+ * The remaining range can be freely used by userspace to encode types, all
+ * values are equivalent to NFT_DATA_VALUE.
+ */
+enum nft_data_types {
+	NFT_DATA_VALUE,
+	NFT_DATA_VERDICT	= 0xffffff00U,
+};
+
+#define NFT_DATA_RESERVED_MASK	0xffffff00U
+
 enum nft_data_attributes {
 	NFTA_DATA_UNSPEC,
 	NFTA_DATA_VALUE,
@@ -150,58 +257,14 @@ enum nft_cmp_attributes {
 };
 #define NFTA_CMP_MAX		(__NFTA_CMP_MAX - 1)
 
-enum nft_set_elem_flags {
-	NFT_SE_INTERVAL_END	= 0x1,
-};
-
-enum nft_set_elem_attributes {
-	NFTA_SE_UNSPEC,
-	NFTA_SE_KEY,
-	NFTA_SE_DATA,
-	NFTA_SE_FLAGS,
-	__NFTA_SE_MAX
-};
-#define NFTA_SE_MAX		(__NFTA_SE_MAX - 1)
-
-enum nft_set_flags {
-	NFT_SET_INTERVAL	= 0x1,
-	NFT_SET_MAP		= 0x2,
-};
-
-enum nft_set_attributes {
-	NFTA_SET_UNSPEC,
-	NFTA_SET_FLAGS,
-	NFTA_SET_SREG,
-	NFTA_SET_DREG,
-	NFTA_SET_KLEN,
-	NFTA_SET_DLEN,
-	NFTA_SET_ELEMENTS,
-	__NFTA_SET_MAX
-};
-#define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
-
-enum nft_hash_flags {
-	NFT_HASH_MAP		= 0x1,
-};
-
-enum nft_hash_elem_attributes {
-	NFTA_HE_UNSPEC,
-	NFTA_HE_KEY,
-	NFTA_HE_DATA,
-	__NFTA_HE_MAX
-};
-#define NFTA_HE_MAX		(__NFTA_HE_MAX - 1)
-
-enum nft_hash_attributes {
-	NFTA_HASH_UNSPEC,
-	NFTA_HASH_FLAGS,
-	NFTA_HASH_SREG,
-	NFTA_HASH_DREG,
-	NFTA_HASH_KLEN,
-	NFTA_HASH_ELEMENTS,
-	__NFTA_HASH_MAX
+enum nft_lookup_attributes {
+	NFTA_LOOKUP_UNSPEC,
+	NFTA_LOOKUP_SET,
+	NFTA_LOOKUP_SREG,
+	NFTA_LOOKUP_DREG,
+	__NFTA_LOOKUP_MAX
 };
-#define NFTA_HASH_MAX		(__NFTA_HASH_MAX - 1)
+#define NFTA_LOOKUP_MAX		(__NFTA_LOOKUP_MAX - 1)
 
 enum nft_payload_bases {
 	NFT_PAYLOAD_LL_HEADER,
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 0b76fa7..94fb55b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -6,6 +6,8 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netlink.h>
 
+#define NFT_JUMP_STACK_SIZE	16
+
 struct nft_pktinfo {
 	struct sk_buff			*skb;
 	const struct net_device		*in;
@@ -48,23 +50,22 @@ static inline void nft_data_debug(const struct nft_data *data)
 }
 
 /**
- *	struct nft_ctx - nf_tables rule context
+ *	struct nft_ctx - nf_tables rule/set context
  *
+ * 	@skb: netlink skb
+ * 	@nlh: netlink message header
  * 	@afi: address family info
  * 	@table: the table the chain is contained in
  * 	@chain: the chain the rule is contained in
  */
 struct nft_ctx {
+	const struct sk_buff		*skb;
+	const struct nlmsghdr		*nlh;
 	const struct nft_af_info	*afi;
 	const struct nft_table		*table;
 	const struct nft_chain		*chain;
 };
 
-enum nft_data_types {
-	NFT_DATA_VALUE,
-	NFT_DATA_VERDICT,
-};
-
 struct nft_data_desc {
 	enum nft_data_types		type;
 	unsigned int			len;
@@ -83,6 +84,11 @@ static inline enum nft_data_types nft_dreg_to_type(enum nft_registers reg)
 	return reg == NFT_REG_VERDICT ? NFT_DATA_VERDICT : NFT_DATA_VALUE;
 }
 
+static inline enum nft_registers nft_type_to_reg(enum nft_data_types type)
+{
+	return type == NFT_DATA_VERDICT ? NFT_REG_VERDICT : NFT_REG_1;
+}
+
 extern int nft_validate_input_register(enum nft_registers reg);
 extern int nft_validate_output_register(enum nft_registers reg);
 extern int nft_validate_data_load(const struct nft_ctx *ctx,
@@ -91,6 +97,130 @@ extern int nft_validate_data_load(const struct nft_ctx *ctx,
 				  enum nft_data_types type);
 
 /**
+ * struct nft_set_elem - generic representation of set elements
+ *
+ * @cookie: implementation specific element cookie
+ * @key: element key
+ * @data: element data (maps only)
+ * @flags: element flags (end of interval)
+ *
+ * The cookie can be used to store a handle to the element for subsequent
+ * removal.
+ */
+struct nft_set_elem {
+	void			*cookie;
+	struct nft_data		key;
+	struct nft_data		data;
+	u32			flags;
+};
+
+struct nft_set;
+struct nft_set_iter {
+	unsigned int	count;
+	unsigned int	skip;
+	int		err;
+	int		(*fn)(const struct nft_set *set,
+			      const struct nft_set_iter *iter,
+			      const struct nft_set_elem *elem);
+};
+
+/**
+ *	struct nft_set_ops - nf_tables set operations
+ *
+ *	@lookup: look up an element within the set
+ *	@insert: insert new element into set
+ *	@remove: remove element from set
+ *	@walk: iterate over all set elemeennts
+ *	@privsize: function to return size of set private data
+ *	@init: initialize private data of new set instance
+ *	@destroy: destroy private data of set instance
+ *	@list: nf_tables_set_ops list node
+ *	@owner: module reference
+ *	@features: features supported by the implementation
+ */
+struct nft_set_ops {
+	bool				(*lookup)(const struct nft_set *set,
+						  const struct nft_data *key,
+						  struct nft_data *data);
+	int				(*get)(const struct nft_set *set,
+					       struct nft_set_elem *elem);
+	int				(*insert)(const struct nft_set *set,
+						  const struct nft_set_elem *elem);
+	void				(*remove)(const struct nft_set *set,
+						  const struct nft_set_elem *elem);
+	void				(*walk)(const struct nft_set *set,
+						struct nft_set_iter *iter);
+
+	unsigned int			(*privsize)(const struct nlattr * const nla[]);
+	int				(*init)(const struct nft_set *set,
+						const struct nlattr * const nla[]);
+	void				(*destroy)(const struct nft_set *set);
+
+	struct list_head		list;
+	struct module			*owner;
+	u32				features;
+};
+
+extern int nft_register_set(struct nft_set_ops *ops);
+extern void nft_unregister_set(struct nft_set_ops *ops);
+
+/**
+ * 	struct nft_set - nf_tables set instance
+ *
+ *	@list: table set list node
+ *	@bindings: list of set bindings
+ * 	@name: name of the set
+ * 	@ktype: key type (numeric type defined by userspace, not used in the kernel)
+ * 	@dtype: data type (verdict or numeric type defined by userspace)
+ * 	@ops: set ops
+ * 	@flags: set flags
+ * 	@klen: key length
+ * 	@dlen: data length
+ * 	@data: private set data
+ */
+struct nft_set {
+	struct list_head		list;
+	struct list_head		bindings;
+	char				name[IFNAMSIZ];
+	u32				ktype;
+	u32				dtype;
+	/* runtime data below here */
+	const struct nft_set_ops	*ops ____cacheline_aligned;
+	u16				flags;
+	u8				klen;
+	u8				dlen;
+	unsigned char			data[]
+		__attribute__((aligned(__alignof__(u64))));
+};
+
+static inline void *nft_set_priv(const struct nft_set *set)
+{
+	return (void *)set->data;
+}
+
+extern struct nft_set *nf_tables_set_lookup(const struct nft_table *table,
+					    const struct nlattr *nla);
+
+/**
+ *	struct nft_set_binding - nf_tables set binding
+ *
+ *	@list: set bindings list node
+ *	@chain: chain containing the rule bound to the set
+ *
+ *	A set binding contains all information necessary for validation
+ *	of new elements added to a bound set.
+ */
+struct nft_set_binding {
+	struct list_head		list;
+	const struct nft_chain		*chain;
+};
+
+extern int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
+			      struct nft_set_binding *binding);
+extern void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
+				 struct nft_set_binding *binding);
+
+/**
  *	struct nft_expr_ops - nf_tables expression operations
  *
  *	@eval: Expression evaluation function
@@ -242,12 +372,14 @@ enum nft_table_flags {
  *
  *	@list: used internally
  *	@chains: chains in the table
+ *	@sets: sets in the table
  *	@flags: bitmask of enum nft_table_flags
  *	@name: name of the table
  */
 struct nft_table {
 	struct list_head		list;
 	struct list_head		chains;
+	struct list_head		sets;
 	u16				flags;
 	char				name[];
 };
@@ -289,4 +421,10 @@ extern void nft_unregister_expr(struct nft_expr_ops *);
 #define MODULE_ALIAS_NFT_EXPR(name) \
 	MODULE_ALIAS("nft-expr-" name)
 
+#define MODULE_ALIAS_NFT_SET() \
+	MODULE_ALIAS("nft-set")
+
+extern int nft_lookup_module_init(void);
+extern void nft_lookup_module_exit(void);
+
 #endif /* _NET_NF_TABLES_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index b98b498..466a6bb 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -312,13 +312,13 @@ config NFT_CT
 	depends on NF_CONNTRACK
 	tristate "Netfilter nf_tables conntrack module"
 
-config NFT_SET
+config NFT_RBTREE
 	depends on NF_TABLES
-	tristate "Netfilter nf_tables set module"
+	tristate "Netfilter nf_tables rbtree set module"
 
 config NFT_HASH
 	depends on NF_TABLES
-	tristate "Netfilter nf_tables hash module"
+	tristate "Netfilter nf_tables hash set module"
 
 config NFT_COUNTER
 	depends on NF_TABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 3c5d85d..4de7642 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -39,6 +39,8 @@ obj-$(CONFIG_NETFILTER_TPROXY) += nf_tproxy_core.o
 
 # nf_tables
 nf_tables-objs += nf_tables_core.o nf_tables_api.o
+nf_tables-objs += nft_lookup.o
+
 obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
 obj-$(CONFIG_NF_TABLES)		+= nft_immediate.o
 obj-$(CONFIG_NF_TABLES)		+= nft_bitwise.o
@@ -50,7 +52,7 @@ obj-$(CONFIG_NFT_META)		+= nft_meta.o
 obj-$(CONFIG_NFT_CT)		+= nft_ct.o
 obj-$(CONFIG_NFT_LIMIT)		+= nft_limit.o
 #nf_tables-objs			+= nft_meta_target.o
-obj-$(CONFIG_NFT_SET)		+= nft_set.o
+obj-$(CONFIG_NFT_RBTREE)	+= nft_rbtree.o
 obj-$(CONFIG_NFT_HASH)		+= nft_hash.o
 obj-$(CONFIG_NFT_COUNTER)	+= nft_counter.o
 obj-$(CONFIG_NFT_LOG)		+= nft_log.o
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 76afd89..839f764 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2007, 2008 Patrick McHardy <kaber@trash.net>
+ * Copyright (c) 2007-2009 Patrick McHardy <kaber@trash.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -301,6 +301,7 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 
 	nla_strlcpy(table->name, name, nla_len(name));
 	INIT_LIST_HEAD(&table->chains);
+	INIT_LIST_HEAD(&table->sets);
 
 	list_add_tail(&table->list, &afi->tables);
 	nf_tables_table_notify(skb, nlh, table, NFT_MSG_NEWTABLE, family);
@@ -737,10 +738,14 @@ static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
 }
 
 static void nft_ctx_init(struct nft_ctx *ctx,
+			 const struct sk_buff *skb,
+			 const struct nlmsghdr *nlh,
 			 const struct nft_af_info *afi,
 			 const struct nft_table *table,
 			 const struct nft_chain *chain)
 {
+	ctx->skb   = skb;
+	ctx->nlh   = nlh;
 	ctx->afi   = afi;
 	ctx->table = table;
 	ctx->chain = chain;
@@ -1218,7 +1223,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	rule->handle = handle;
 	rule->dlen   = size;
 
-	nft_ctx_init(&ctx, afi, table, chain);
+	nft_ctx_init(&ctx, skb, nlh, afi, table, chain);
 	expr = nft_expr_first(rule);
 	for (i = 0; i < n; i++) {
 		err = nf_tables_newexpr(&ctx, &info[i], expr);
@@ -1288,7 +1293,7 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 
 	nf_tables_rule_notify(skb, nlh, table, chain, rule, NFT_MSG_DELRULE,
 			      family);
-	nft_ctx_init(&ctx, afi, table, chain);
+	nft_ctx_init(&ctx, skb, nlh, afi, table, chain);
 	nf_tables_rule_destroy(&ctx, rule);
 
 	/* Unregister hook when last rule from base chain is deleted */
@@ -1298,6 +1303,858 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	return 0;
 }
 
+/*
+ * Sets
+ */
+
+static LIST_HEAD(nf_tables_set_ops);
+
+int nft_register_set(struct nft_set_ops *ops)
+{
+	nfnl_lock();
+	list_add_tail(&ops->list, &nf_tables_set_ops);
+	nfnl_unlock();
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nft_register_set);
+
+void nft_unregister_set(struct nft_set_ops *ops)
+{
+	nfnl_lock();
+	list_del(&ops->list);
+	nfnl_unlock();
+}
+EXPORT_SYMBOL_GPL(nft_unregister_set);
+
+static const struct nft_set_ops *nft_select_set_ops(const struct nlattr * const nla[])
+{
+	const struct nft_set_ops *ops;
+	u32 features;
+
+#ifdef CONFIG_MODULES
+	if (list_empty(&nf_tables_set_ops)) {
+		nfnl_unlock();
+		request_module("nft-set");
+		nfnl_lock();
+		if (!list_empty(&nf_tables_set_ops))
+			return ERR_PTR(-EAGAIN);
+	}
+#endif
+	features = 0;
+	if (nla[NFTA_SET_FLAGS] != NULL) {
+		features = ntohl(nla_get_be32(nla[NFTA_SET_FLAGS]));
+		features &= NFT_SET_INTERVAL | NFT_SET_MAP;
+	}
+
+	// FIXME: implement selection properly
+	list_for_each_entry(ops, &nf_tables_set_ops, list) {
+		if ((ops->features & features) != features)
+			continue;
+		if (!try_module_get(ops->owner))
+			continue;
+		return ops;
+	}
+
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
+	[NFTA_SET_TABLE]		= { .type = NLA_STRING },
+	[NFTA_SET_NAME]			= { .type = NLA_STRING },
+	[NFTA_SET_FLAGS]		= { .type = NLA_U32 },
+	[NFTA_SET_KEY_TYPE]		= { .type = NLA_U32 },
+	[NFTA_SET_KEY_LEN]		= { .type = NLA_U32 },
+	[NFTA_SET_DATA_TYPE]		= { .type = NLA_U32 },
+	[NFTA_SET_DATA_LEN]		= { .type = NLA_U32 },
+};
+
+static int nft_ctx_init_from_setattr(struct nft_ctx *ctx,
+				     const struct sk_buff *skb,
+				     const struct nlmsghdr *nlh,
+				     const struct nlattr * const nla[])
+{
+	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	const struct nft_af_info *afi;
+	const struct nft_table *table;
+
+	afi = nf_tables_afinfo_lookup(nfmsg->nfgen_family, false);
+	if (IS_ERR(afi))
+		return PTR_ERR(afi);
+
+	table = nf_tables_table_lookup(afi, nla[NFTA_SET_TABLE], false);
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+
+	nft_ctx_init(ctx, skb, nlh, afi, table, NULL);
+	return 0;
+}
+
+struct nft_set *nf_tables_set_lookup(const struct nft_table *table,
+				     const struct nlattr *nla)
+{
+	struct nft_set *set;
+
+	if (nla == NULL)
+		return ERR_PTR(-EINVAL);
+
+	list_for_each_entry(set, &table->sets, list) {
+		if (!nla_strcmp(nla, set->name))
+			return set;
+	}
+	return ERR_PTR(-ENOENT);
+}
+
+static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
+				    const char *name)
+{
+	const struct nft_set *i;
+	const char *p;
+	unsigned long *inuse;
+	unsigned int n = 0;
+
+	p = strnchr(name, IFNAMSIZ, '%');
+	if (p != NULL) {
+		if (p[1] != 'd' || strchr(p + 2, '%'))
+			return -EINVAL;
+
+		inuse = (unsigned long *)get_zeroed_page(GFP_KERNEL);
+		if (inuse == NULL)
+			return -ENOMEM;
+
+		list_for_each_entry(i, &ctx->table->sets, list) {
+			if (!sscanf(i->name, name, &n))
+				continue;
+			if (n < 0 || n > BITS_PER_LONG * PAGE_SIZE)
+				continue;
+			set_bit(n, inuse);
+		}
+
+		n = find_first_zero_bit(inuse, BITS_PER_LONG * PAGE_SIZE);
+		free_page((unsigned long)inuse);
+	}
+
+	snprintf(set->name, sizeof(set->name), name, n);
+	list_for_each_entry(i, &ctx->table->sets, list) {
+		if (!strcmp(set->name, i->name))
+			return -ENFILE;
+	}
+	return 0;
+}
+
+static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
+			      const struct nft_set *set, u16 event, u16 flags)
+{
+	struct nfgenmsg *nfmsg;
+	struct nlmsghdr *nlh;
+	u32 pid = NETLINK_CB(ctx->skb).pid;
+	u32 seq = ctx->nlh->nlmsg_seq;
+
+	event |= NFNL_SUBSYS_NFTABLES << 8;
+	nlh = nlmsg_put(skb, pid, seq, event, sizeof(struct nfgenmsg), flags);
+	if (nlh == NULL)
+		goto nla_put_failure;
+
+	nfmsg = nlmsg_data(nlh);
+	nfmsg->nfgen_family	= ctx->afi->family;
+	nfmsg->version		= NFNETLINK_V0;
+	nfmsg->res_id		= 0;
+
+	NLA_PUT_STRING(skb, NFTA_SET_TABLE, ctx->table->name);
+	NLA_PUT_STRING(skb, NFTA_SET_NAME, set->name);
+	if (set->flags != 0)
+		NLA_PUT_BE32(skb, NFTA_SET_FLAGS, htonl(set->flags));
+
+	NLA_PUT_BE32(skb, NFTA_SET_KEY_TYPE, htonl(set->ktype));
+	NLA_PUT_BE32(skb, NFTA_SET_KEY_LEN, htonl(set->klen));
+	if (set->flags & NFT_SET_MAP) {
+		NLA_PUT_BE32(skb, NFTA_SET_DATA_TYPE, htonl(set->dtype));
+		NLA_PUT_BE32(skb, NFTA_SET_DATA_LEN, htonl(set->dlen));
+	}
+
+	return nlmsg_end(skb, nlh);
+
+nla_put_failure:
+	nlmsg_trim(skb, nlh);
+	return -1;
+}
+
+static int nf_tables_set_notify(const struct nft_ctx *ctx,
+				const struct nft_set *set,
+				int event)
+{
+	struct sk_buff *skb;
+	u32 pid = NETLINK_CB(ctx->skb).pid;
+	bool report;
+	int err;
+
+	report = nlmsg_report(ctx->nlh);
+	if (!report && !nfnetlink_has_listeners(NFNLGRP_NFTABLES))
+		return 0;
+
+	err = -ENOBUFS;
+	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (skb == NULL)
+		goto err;
+
+	err = nf_tables_fill_set(skb, ctx, set, event, 0);
+	if (err < 0) {
+		kfree_skb(skb);
+		goto err;
+	}
+
+	err = nfnetlink_send(skb, pid, NFNLGRP_NFTABLES, report);
+err:
+	if (err < 0)
+		nfnetlink_set_err(pid, NFNLGRP_NFTABLES, err);
+	return err;
+}
+
+static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
+	struct nlattr *nla[NFTA_SET_MAX + 1];
+	const struct nft_set *set;
+	struct nft_ctx ctx;
+	unsigned int idx = 0, s_idx = cb->args[0];
+	int err;
+
+	err = nlmsg_parse(cb->nlh, sizeof(*nfmsg), nla, NFTA_SET_MAX,
+			  nft_set_policy);
+	if (err < 0)
+		return err;
+
+	err = nft_ctx_init_from_setattr(&ctx, cb->skb, cb->nlh, (void *)nla);
+	if (err < 0)
+		return err;
+
+	list_for_each_entry(set, &ctx.table->sets, list) {
+		if (idx < s_idx)
+			goto cont;
+		if (idx > s_idx)
+			memset(&cb->args[1], 0,
+			       sizeof(cb->args) - sizeof(cb->args[0]));
+		if (nf_tables_fill_set(skb, &ctx, set, NFT_MSG_NEWSET,
+				       NLM_F_MULTI) < 0)
+			goto done;
+cont:
+		idx++;
+	}
+done:
+	cb->args[0] = idx;
+	return skb->len;
+}
+
+static int nf_tables_getset(struct sock *nlsk, struct sk_buff *skb,
+			    const struct nlmsghdr *nlh,
+			    const struct nlattr * const nla[])
+{
+	const struct nft_set *set;
+	struct nft_ctx ctx;
+	struct sk_buff *skb2;
+	int err;
+
+	/* Verify existance before starting dump */
+	err = nft_ctx_init_from_setattr(&ctx, skb, nlh, nla);
+	if (err < 0)
+		return err;
+
+	if (nlh->nlmsg_flags & NLM_F_DUMP)
+		return netlink_dump_start(nlsk, skb, nlh, nf_tables_dump_sets,
+					  NULL);
+
+	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_NAME]);
+	if (IS_ERR(set))
+		return PTR_ERR(set);
+
+	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (skb2 == NULL)
+		return -ENOMEM;
+
+	err = nf_tables_fill_set(skb2, &ctx, set, NFT_MSG_NEWSET, 0);
+	if (err < 0)
+		goto err;
+
+	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).pid);
+
+err:
+	kfree_skb(skb2);
+	return err;
+}
+
+static int nf_tables_newset(struct sock *nlsk, struct sk_buff *skb,
+			    const struct nlmsghdr *nlh,
+			    const struct nlattr * const nla[])
+{
+	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	const struct nft_set_ops *ops;
+	const struct nft_af_info *afi;
+	struct nft_table *table;
+	struct nft_set *set;
+	struct nft_ctx ctx;
+	char name[IFNAMSIZ];
+	unsigned int size;
+	bool create;
+	u32 ktype, klen, dlen, dtype;
+	u16 flags;
+	int err;
+
+	if (nla[NFTA_SET_TABLE] == NULL ||
+	    nla[NFTA_SET_NAME] == NULL ||
+	    nla[NFTA_SET_KEY_LEN] == NULL)
+		return -EINVAL;
+
+	ktype = NFT_DATA_VALUE;
+	if (nla[NFTA_SET_KEY_TYPE] != NULL) {
+		ktype = ntohl(nla_get_be32(nla[NFTA_SET_KEY_TYPE]));
+		if ((ktype & NFT_DATA_RESERVED_MASK) == NFT_DATA_RESERVED_MASK)
+			return -EINVAL;
+	}
+
+	klen = ntohl(nla_get_be32(nla[NFTA_SET_KEY_LEN]));
+	if (klen == 0 || klen > FIELD_SIZEOF(struct nft_data, data))
+		return -EINVAL;
+
+	flags = 0;
+	if (nla[NFTA_SET_FLAGS] != NULL) {
+		flags = ntohl(nla_get_be32(nla[NFTA_SET_FLAGS]));
+		if (flags & ~(NFT_SET_ANONYMOUS | NFT_SET_CONSTANT |
+			      NFT_SET_INTERVAL | NFT_SET_MAP))
+			return -EINVAL;
+	}
+
+	dtype = 0;
+	dlen  = 0;
+	if (nla[NFTA_SET_DATA_TYPE] != NULL) {
+		if (!(flags & NFT_SET_MAP))
+			return -EINVAL;
+
+		dtype = ntohl(nla_get_be32(nla[NFTA_SET_DATA_TYPE]));
+		if ((dtype & NFT_DATA_RESERVED_MASK) == NFT_DATA_RESERVED_MASK &&
+		    dtype != NFT_DATA_VERDICT)
+			return -EINVAL;
+
+		if (dtype != NFT_DATA_VERDICT) {
+			if (nla[NFTA_SET_DATA_LEN] == NULL)
+				return -EINVAL;
+			dlen = ntohl(nla_get_be32(nla[NFTA_SET_DATA_LEN]));
+			if (dlen == 0 ||
+			    dlen > FIELD_SIZEOF(struct nft_data, data))
+				return -EINVAL;
+		} else
+			dlen = sizeof(struct nft_data);
+	} else if (flags & NFT_SET_MAP)
+		return -EINVAL;
+
+	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
+
+	afi = nf_tables_afinfo_lookup(nfmsg->nfgen_family, create);
+	if (IS_ERR(afi))
+		return PTR_ERR(afi);
+
+	table = nf_tables_table_lookup(afi, nla[NFTA_SET_TABLE], create);
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+
+	nft_ctx_init(&ctx, skb, nlh, afi, table, NULL);
+
+	set = nf_tables_set_lookup(table, nla[NFTA_SET_NAME]);
+	if (IS_ERR(set)) {
+		if (PTR_ERR(set) != -ENOENT)
+			return PTR_ERR(set);
+		set = NULL;
+	}
+
+	if (set != NULL) {
+		if (nlh->nlmsg_flags & NLM_F_EXCL)
+			return -EEXIST;
+		if (nlh->nlmsg_flags & NLM_F_REPLACE)
+			return -EOPNOTSUPP;
+		return 0;
+	}
+
+	if (!(nlh->nlmsg_flags & NLM_F_CREATE))
+		return -ENOENT;
+
+	ops = nft_select_set_ops(nla);
+	if (IS_ERR(ops))
+		return PTR_ERR(ops);
+
+	size = 0;
+	if (ops->privsize != NULL)
+		size = ops->privsize(nla);
+
+	err = -ENOMEM;
+	set = kzalloc(sizeof(*set) + size, GFP_KERNEL);
+	if (set == NULL)
+		goto err1;
+
+	nla_strlcpy(name, nla[NFTA_SET_NAME], sizeof(set->name));
+	err = nf_tables_set_alloc_name(&ctx, set, name);
+	if (err < 0)
+		goto err2;
+
+	INIT_LIST_HEAD(&set->bindings);
+	set->ops   = ops;
+	set->ktype = ktype;
+	set->klen  = klen;
+	set->dtype = dtype;
+	set->dlen  = dlen;
+	set->flags = flags;
+
+	err = ops->init(set, nla);
+	if (err < 0)
+		goto err2;
+
+	list_add_tail(&set->list, &table->sets);
+	nf_tables_set_notify(&ctx, set, NFT_MSG_NEWSET);
+	return 0;
+
+err2:
+	kfree(set);
+err1:
+	module_put(ops->owner);
+	return err;
+}
+
+static void nf_tables_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
+{
+	list_del(&set->list);
+	nf_tables_set_notify(ctx, set, NFT_MSG_DELSET);
+
+	set->ops->destroy(set);
+	module_put(set->ops->owner);
+	kfree(set);
+}
+
+static int nf_tables_delset(struct sock *nlsk, struct sk_buff *skb,
+			    const struct nlmsghdr *nlh,
+			    const struct nlattr * const nla[])
+{
+	struct nft_set *set;
+	struct nft_ctx ctx;
+	int err;
+
+	err = nft_ctx_init_from_setattr(&ctx, skb, nlh, nla);
+	if (err < 0)
+		return err;
+
+	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_NAME]);
+	if (IS_ERR(set))
+		return PTR_ERR(set);
+	if (!list_empty(&set->bindings))
+		return -EBUSY;
+
+	nf_tables_set_destroy(&ctx, set);
+	return 0;
+}
+
+struct nft_set_bind_check_args {
+	struct nft_set_iter		iter;
+	const struct nft_ctx		*ctx;
+};
+
+static int nf_tables_bind_check_setelem(const struct nft_set *set,
+					const struct nft_set_iter *iter,
+					const struct nft_set_elem *elem)
+		
+{
+	struct nft_set_bind_check_args *args;
+	enum nft_registers dreg;
+
+	args = container_of(iter, struct nft_set_bind_check_args, iter);
+	dreg = nft_type_to_reg(set->dtype);
+	return nft_validate_data_load(args->ctx, dreg, &elem->data, set->dtype);
+}
+
+int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
+		       struct nft_set_binding *binding)
+{
+	struct nft_set_bind_check_args args;
+
+	if (set->flags & NFT_SET_MAP) {
+		args.iter.skip 	= 0;
+		args.iter.count	= 0;
+		args.iter.err   = 0;
+		args.iter.fn	= nf_tables_bind_check_setelem;
+		args.ctx	= ctx;
+
+		set->ops->walk(set, &args.iter);
+		if (args.iter.err < 0)
+			return args.iter.err;
+	}
+
+	binding->chain = ctx->chain;
+	list_add_tail(&binding->list, &set->bindings);
+	return 0;
+}
+
+void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
+			  struct nft_set_binding *binding)
+{
+	list_del(&binding->list);
+
+	if (list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS)
+		nf_tables_set_destroy(ctx, set);
+}
+
+/*
+ * Set elements
+ */
+
+static const struct nla_policy nft_set_elem_policy[NFTA_SET_ELEM_MAX + 1] = {
+	[NFTA_SET_ELEM_KEY]		= { .type = NLA_NESTED },
+	[NFTA_SET_ELEM_DATA]		= { .type = NLA_NESTED },
+	[NFTA_SET_ELEM_FLAGS]		= { .type = NLA_U32 },
+};
+
+static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX + 1] = {
+	[NFTA_SET_ELEM_LIST_TABLE]	= { .type = NLA_STRING },
+	[NFTA_SET_ELEM_LIST_SET]	= { .type = NLA_STRING },
+	[NFTA_SET_ELEM_LIST_ELEMENTS]	= { .type = NLA_NESTED },
+};
+
+static int nft_ctx_init_from_elemattr(struct nft_ctx *ctx,
+				      const struct sk_buff *skb,
+				      const struct nlmsghdr *nlh,
+				      const struct nlattr * const nla[])
+{
+	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	const struct nft_af_info *afi;
+	const struct nft_table *table;
+
+	afi = nf_tables_afinfo_lookup(nfmsg->nfgen_family, false);
+	if (IS_ERR(afi))
+		return PTR_ERR(afi);
+
+	table = nf_tables_table_lookup(afi, nla[NFTA_SET_ELEM_LIST_TABLE], false);
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+
+	nft_ctx_init(ctx, skb, nlh, afi, table, NULL);
+	return 0;
+}
+
+static int nf_tables_fill_setelem(struct sk_buff *skb,
+				  const struct nft_set *set,
+				  const struct nft_set_elem *elem)
+{
+	unsigned char *b = skb_tail_pointer(skb);
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, NFTA_LIST_ELEM);
+	if (nest == NULL)
+		goto nla_put_failure;
+
+	if (nft_data_dump(skb, NFTA_SET_ELEM_KEY, &elem->key, NFT_DATA_VALUE,
+			  set->klen) < 0)
+		goto nla_put_failure;
+
+	if (set->flags & NFT_SET_MAP &&
+	    !(elem->flags & NFT_SET_ELEM_INTERVAL_END) &&
+	    nft_data_dump(skb, NFTA_SET_ELEM_DATA, &elem->data,
+		    	  set->dtype == NFT_DATA_VERDICT ? : NFT_DATA_VALUE,
+		    	  set->dlen) < 0)
+		goto nla_put_failure;
+
+	if (elem->flags != 0)
+		NLA_PUT_BE32(skb, NFTA_SET_ELEM_FLAGS, htonl(elem->flags));
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nlmsg_trim(skb, b);
+	return -EMSGSIZE;
+}
+
+struct nft_set_dump_args {
+	const struct netlink_callback	*cb;
+	struct nft_set_iter		iter;
+	struct sk_buff			*skb;
+};
+
+static int nf_tables_dump_setelem(const struct nft_set *set,
+				  const struct nft_set_iter *iter,
+				  const struct nft_set_elem *elem)
+{
+	struct nft_set_dump_args *args;
+     
+	args = container_of(iter, struct nft_set_dump_args, iter);
+	return nf_tables_fill_setelem(args->skb, set, elem);
+}
+
+static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	const struct nft_set *set;
+	struct nft_set_dump_args args;
+	struct nft_ctx ctx;
+	struct nlattr *nla[NFTA_SET_ELEM_LIST_MAX + 1];
+	struct nfgenmsg *nfmsg;
+	struct nlmsghdr *nlh;
+	struct nlattr *nest;
+	u32 pid, seq;
+	int event, err;
+
+	nfmsg = nlmsg_data(cb->nlh);
+	err = nlmsg_parse(cb->nlh, sizeof(*nfmsg), nla, NFTA_SET_ELEM_LIST_MAX,
+			  nft_set_elem_list_policy);
+	if (err < 0)
+		return err;
+
+	err = nft_ctx_init_from_elemattr(&ctx, cb->skb, cb->nlh, (void *)nla);
+	if (err < 0)
+		return err;
+
+	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_ELEM_LIST_SET]);
+	if (IS_ERR(set))
+		return PTR_ERR(set);
+
+	event  = NFT_MSG_NEWSETELEM;
+	event |= NFNL_SUBSYS_NFTABLES << 8;
+	pid    = NETLINK_CB(cb->skb).pid;
+	seq    = cb->nlh->nlmsg_seq;
+
+	nlh = nlmsg_put(skb, pid, seq, event, sizeof(struct nfgenmsg),
+			NLM_F_MULTI);
+	if (nlh == NULL)
+		goto nla_put_failure;
+
+	nfmsg = nlmsg_data(nlh);
+	nfmsg->nfgen_family = AF_UNSPEC;
+	nfmsg->version      = NFNETLINK_V0;
+	nfmsg->res_id       = 0;
+
+	NLA_PUT_STRING(skb, NFTA_SET_ELEM_LIST_TABLE, ctx.table->name);
+	NLA_PUT_STRING(skb, NFTA_SET_ELEM_LIST_SET, set->name);
+
+	nest = nla_nest_start(skb, NFTA_SET_ELEM_LIST_ELEMENTS);
+	if (nest == NULL)
+		goto nla_put_failure;
+
+	args.cb		= cb;
+	args.skb	= skb;
+	args.iter.skip 	= cb->args[0];
+	args.iter.count	= 0;
+	args.iter.err   = 0;
+	args.iter.fn	= nf_tables_dump_setelem;
+	set->ops->walk(set, &args.iter);
+
+	nla_nest_end(skb, nest);
+	nlmsg_end(skb, nlh);
+
+	if (args.iter.err && args.iter.err != -EMSGSIZE)
+		return args.iter.err;
+	if (args.iter.count == cb->args[0])
+		return 0;
+
+	cb->args[0] = args.iter.count;
+	return skb->len;
+
+nla_put_failure:
+	return -ENOSPC;
+}
+
+static int nf_tables_getsetelem(struct sock *nlsk, struct sk_buff *skb,
+				const struct nlmsghdr *nlh,
+				const struct nlattr * const nla[])
+{
+	const struct nft_set *set;
+	struct nft_ctx ctx;
+	int err;
+
+	err = nft_ctx_init_from_elemattr(&ctx, skb, nlh, nla);
+	if (err < 0)
+		return err;
+
+	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_ELEM_LIST_SET]);
+	if (IS_ERR(set))
+		return PTR_ERR(set);
+
+	if (nlh->nlmsg_flags & NLM_F_DUMP)
+		return netlink_dump_start(nlsk, skb, nlh, nf_tables_dump_set,
+					  NULL);
+	return -EOPNOTSUPP;
+}
+
+static int nft_add_set_elem(const struct nft_ctx *ctx, struct nft_set *set,
+			    const struct nlattr *attr)
+{
+	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
+	struct nft_data_desc d1, d2;
+	struct nft_set_elem elem;
+	struct nft_set_binding *binding;
+	enum nft_registers dreg;
+	int err;
+
+	err = nla_parse_nested(nla, NFTA_SET_ELEM_MAX, attr,
+			       nft_set_elem_policy);
+	if (err < 0)
+		return err;
+
+	if (nla[NFTA_SET_ELEM_KEY] == NULL)
+		return -EINVAL;
+
+	elem.flags = 0;
+	if (nla[NFTA_SET_ELEM_FLAGS] != NULL) {
+		elem.flags = ntohl(nla_get_be32(nla[NFTA_SET_ELEM_FLAGS]));
+		if (elem.flags & ~NFT_SET_ELEM_INTERVAL_END)
+			return -EINVAL;
+	}
+
+	if (set->flags & NFT_SET_MAP) {
+		if (nla[NFTA_SET_ELEM_DATA] == NULL &&
+		    !(elem.flags & NFT_SET_ELEM_INTERVAL_END))
+			return -EINVAL;
+	} else {
+		if (nla[NFTA_SET_ELEM_DATA] != NULL)
+			return -EINVAL;
+	}
+
+	err = nft_data_init(ctx, &elem.key, &d1, nla[NFTA_SET_ELEM_KEY]);
+	if (err < 0)
+		goto err1;
+	err = -EINVAL;
+	if (d1.type != NFT_DATA_VALUE || d1.len != set->klen)
+		goto err2;
+
+	err = -EEXIST;
+	if (set->ops->get(set, &elem) == 0)
+		goto err2;
+
+	if (nla[NFTA_SET_ELEM_DATA] != NULL) {
+		err = nft_data_init(ctx, &elem.data, &d2, nla[NFTA_SET_ELEM_DATA]);
+		if (err < 0)
+			goto err2;
+
+		err = -EINVAL;
+		if (set->dtype != NFT_DATA_VERDICT && d2.len != set->dlen)
+			goto err3;
+
+		dreg = nft_type_to_reg(set->dtype);
+		list_for_each_entry(binding, &set->bindings, list) {
+			struct nft_ctx bind_ctx = {
+				.afi	= ctx->afi,
+				.table	= ctx->table,
+				.chain	= binding->chain,
+			};
+
+			err = nft_validate_data_load(&bind_ctx, dreg,
+						     &elem.data, d2.type);
+			if (err < 0)
+				goto err3;
+		}
+	}
+
+	err = set->ops->insert(set, &elem);
+	if (err < 0)
+		goto err3;
+
+	return 0;
+
+err3:
+	if (nla[NFTA_SET_ELEM_DATA] != NULL)
+		nft_data_uninit(&elem.data, d2.type);
+err2:
+	nft_data_uninit(&elem.key, d1.type);
+err1:
+	return err;
+}
+
+static int nf_tables_newsetelem(struct sock *nlsk, struct sk_buff *skb,
+				const struct nlmsghdr *nlh,
+				const struct nlattr * const nla[])
+{
+	const struct nlattr *attr;
+	struct nft_set *set;
+	struct nft_ctx ctx;
+	int rem, err;
+
+	err = nft_ctx_init_from_elemattr(&ctx, skb, nlh, nla);
+	if (err < 0)
+		return err;
+
+	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_ELEM_LIST_SET]);
+	if (IS_ERR(set))
+		return PTR_ERR(set);
+	if (!list_empty(&set->bindings) && set->flags & NFT_SET_CONSTANT)
+		return -EBUSY;
+
+	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
+		err = nft_add_set_elem(&ctx, set, attr);
+		if (err < 0)
+			return err;
+	}
+	return 0;
+}
+
+static int nft_del_setelem(const struct nft_ctx *ctx, struct nft_set *set,
+			   const struct nlattr *attr)
+{
+	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
+	struct nft_data_desc desc;
+	struct nft_set_elem elem;
+	int err;
+
+	err = nla_parse_nested(nla, NFTA_SET_ELEM_MAX, attr,
+			       nft_set_elem_policy);
+	if (err < 0)
+		goto err1;
+
+	err = -EINVAL;
+	if (nla[NFTA_SET_ELEM_KEY] == NULL)
+		goto err1;
+
+	err = nft_data_init(ctx, &elem.key, &desc, nla[NFTA_SET_ELEM_KEY]);
+	if (err < 0)
+		goto err1;
+
+	err = -EINVAL;
+	if (desc.type != NFT_DATA_VALUE || desc.len != set->klen)
+		goto err2;
+
+	err = set->ops->get(set, &elem);
+	if (err < 0)
+		goto err2;
+
+	set->ops->remove(set, &elem);
+
+	nft_data_uninit(&elem.key, NFT_DATA_VALUE);
+	if (set->flags & NFT_SET_MAP)
+		nft_data_uninit(&elem.data, set->dtype);
+
+err2:
+	nft_data_uninit(&elem.key, desc.type);
+err1:
+	return err;
+}
+
+static int nf_tables_delsetelem(struct sock *nlsk, struct sk_buff *skb,
+				const struct nlmsghdr *nlh,
+				const struct nlattr * const nla[])
+{
+	const struct nlattr *attr;
+	struct nft_set *set;
+	struct nft_ctx ctx;
+	int rem, err;
+
+	err = nft_ctx_init_from_elemattr(&ctx, skb, nlh, nla);
+	if (err < 0)
+		return err;
+
+	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_ELEM_LIST_SET]);
+	if (IS_ERR(set))
+		return PTR_ERR(set);
+	if (!list_empty(&set->bindings) && set->flags & NFT_SET_CONSTANT)
+		return -EBUSY;
+
+	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
+		err = nft_del_setelem(&ctx, set, attr);
+		if (err < 0)
+			return err;
+	}
+	return 0;
+}
+
 static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	[NFT_MSG_NEWTABLE] = {
 		.call		= nf_tables_newtable,
@@ -1344,6 +2201,36 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_RULE_MAX,
 		.policy		= nft_rule_policy,
 	},
+	[NFT_MSG_NEWSET] = {
+		.call		= nf_tables_newset,
+		.attr_count	= NFTA_SET_MAX,
+		.policy		= nft_set_policy,
+	},
+	[NFT_MSG_GETSET] = {
+		.call		= nf_tables_getset,
+		.attr_count	= NFTA_SET_MAX,
+		.policy		= nft_set_policy,
+	},
+	[NFT_MSG_DELSET] = {
+		.call		= nf_tables_delset,
+		.attr_count	= NFTA_SET_MAX,
+		.policy		= nft_set_policy,
+	},
+	[NFT_MSG_NEWSETELEM] = {
+		.call		= nf_tables_newsetelem,
+		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
+		.policy		= nft_set_elem_list_policy,
+	},
+	[NFT_MSG_GETSETELEM] = {
+		.call		= nf_tables_getsetelem,
+		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
+		.policy		= nft_set_elem_list_policy,
+	},
+	[NFT_MSG_DELSETELEM] = {
+		.call		= nf_tables_delsetelem,
+		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
+		.policy		= nft_set_elem_list_policy,
+	},
 };
 
 static const struct nfnetlink_subsystem nf_tables_subsys = {
@@ -1410,6 +2297,13 @@ int nft_validate_data_load(const struct nft_ctx *ctx, enum nft_registers reg,
 	case NFT_REG_VERDICT:
 		if (data == NULL || type != NFT_DATA_VERDICT)
 			return -EINVAL;
+
+		if (ctx->chain->level + 1 > data->chain->level) {
+			if (ctx->chain->level + 1 == NFT_JUMP_STACK_SIZE)
+				return -EMLINK;
+			data->chain->level = ctx->chain->level + 1;
+		}
+
 		// FIXME: do loop detection
 		return 0;
 	default:
@@ -1460,11 +2354,6 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 		if (chain->flags & NFT_BASE_CHAIN)
 			return -EOPNOTSUPP;
 
-		if (ctx->chain->level + 1 > chain->level) {
-			if (ctx->chain->level + 1 == 16)
-				return -EMLINK;
-			chain->level = ctx->chain->level + 1;
-		}
 		chain->use++;
 		data->chain = chain;
 		desc->len = sizeof(data);
@@ -1597,13 +2486,27 @@ EXPORT_SYMBOL_GPL(nft_data_dump);
 
 static int __init nf_tables_init(void)
 {
-	pr_info("nf_tables: (c) 2007-2008 Patrick McHardy <kaber@trash.net>\n");
-	return nfnetlink_subsys_register(&nf_tables_subsys);
+	int err;
+
+	err = nft_lookup_module_init();
+	if (err < 0)
+		goto err1;
+	err = nfnetlink_subsys_register(&nf_tables_subsys);
+	if (err < 0)
+		goto err2;
+	pr_info("nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>\n");
+	return 0;
+
+err2:
+	nft_lookup_module_exit();
+err1:
+	return err;
 }
 
 static void __exit nf_tables_exit(void)
 {
 	nfnetlink_subsys_unregister(&nf_tables_subsys);
+	nft_lookup_module_exit();
 }
 
 module_init(nf_tables_init);
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index a40248b..f535907 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
+ * Copyright (c) 2008-2009 Patrick McHardy <kaber@trash.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -20,11 +20,6 @@
 struct nft_hash {
 	struct hlist_head	*hash;
 	unsigned int		hsize;
-	enum nft_registers	sreg:8;
-	enum nft_registers	dreg:8;
-	u8			klen;
-	u8			dlen;
-	u16			flags;
 };
 
 struct nft_hash_elem {
@@ -41,215 +36,142 @@ static unsigned int nft_hash_data(const struct nft_data *data,
 {
 	unsigned int h;
 
-	// FIXME: can we reasonably guarantee the upper bits are fixed?
-	h = jhash2(data->data, len >> 2, nft_hash_rnd);
+	h = jhash(data->data, len, nft_hash_rnd);
 	return ((u64)h * hsize) >> 32;
 }
 
-static void nft_hash_eval(const struct nft_expr *expr,
-			  struct nft_data data[NFT_REG_MAX + 1],
-			  const struct nft_pktinfo *pkt)
+static bool nft_hash_lookup(const struct nft_set *set,
+			    const struct nft_data *key,
+			    struct nft_data *data)
 {
-	const struct nft_hash *priv = nft_expr_priv(expr);
+	const struct nft_hash *priv = nft_set_priv(set);
 	const struct nft_hash_elem *elem;
-	const struct nft_data *key = &data[priv->sreg];
 	const struct hlist_node *n;
 	unsigned int h;
 
-	h = nft_hash_data(key, priv->hsize, priv->klen);
+	h = nft_hash_data(key, priv->hsize, set->klen);
 	hlist_for_each_entry(elem, n, &priv->hash[h], hnode) {
-		if (nft_data_cmp(&elem->key, key, priv->klen))
+		if (nft_data_cmp(&elem->key, key, set->klen))
 			continue;
-		if (priv->flags & NFT_HASH_MAP)
-			nft_data_copy(&data[priv->dreg], elem->data);
-		return;
+		if (set->flags & NFT_SET_MAP)
+			nft_data_copy(data, elem->data);
+		return true;
 	}
-	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
+	return false;
 }
 
-static void nft_hash_elem_destroy(const struct nft_expr *expr,
+static void nft_hash_elem_destroy(const struct nft_set *set,
 				  struct nft_hash_elem *elem)
 {
-	const struct nft_hash *priv = nft_expr_priv(expr);
-
 	nft_data_uninit(&elem->key, NFT_DATA_VALUE);
-	if (priv->flags & NFT_HASH_MAP)
-		nft_data_uninit(elem->data, nft_dreg_to_type(priv->dreg));
+	if (set->flags & NFT_SET_MAP)
+		nft_data_uninit(elem->data, set->dtype);
 	kfree(elem);
 }
 
-static const struct nla_policy nft_he_policy[NFTA_HE_MAX + 1] = {
-	[NFTA_HE_KEY]		= { .type = NLA_NESTED },
-	[NFTA_HE_DATA]		= { .type = NLA_NESTED },
-};
-
-static int nft_hash_elem_init(const struct nft_ctx *ctx,
-			      const struct nft_expr *expr,
-			      const struct nlattr *nla,
-			      struct nft_hash_elem **new)
+static int nft_hash_insert(const struct nft_set *set,
+			   const struct nft_set_elem *e)
 {
-	struct nft_hash *priv = nft_expr_priv(expr);
-	struct nlattr *tb[NFTA_HE_MAX + 1];
+	struct nft_hash *priv = nft_set_priv(set);
 	struct nft_hash_elem *elem;
-	struct nft_data_desc d1, d2;
-	unsigned int size;
-	int err;
-
-	err = nla_parse_nested(tb, NFTA_HE_MAX, nla, nft_he_policy);
-	if (err < 0)
-		return err;
+	unsigned int size, h;
 
-	if (tb[NFTA_HE_KEY] == NULL)
+	if (e->flags != 0)
 		return -EINVAL;
-	size = sizeof(*elem);
 
-	if (priv->flags & NFT_HASH_MAP) {
-		if (tb[NFTA_HE_DATA] == NULL)
-			return -EINVAL;
+	size = sizeof(*elem);
+	if (set->flags & NFT_SET_MAP)
 		size += sizeof(elem->data[0]);
-	} else {
-		if (tb[NFTA_HE_DATA] != NULL)
-			return -EINVAL;
-	}
 
 	elem = kzalloc(size, GFP_KERNEL);
 	if (elem == NULL)
 		return -ENOMEM;
 
-	err = nft_data_init(ctx, &elem->key, &d1, tb[NFTA_HE_KEY]);
-	if (err < 0)
-		goto err1;
-	err = -EINVAL;
-	if (d1.type != NFT_DATA_VALUE || d1.len != priv->klen)
-		goto err2;
-
-	if (tb[NFTA_HE_DATA] != NULL) {
-		err = nft_data_init(ctx, elem->data, &d2, tb[NFTA_HE_DATA]);
-		if (err < 0)
-			goto err2;
-		err = nft_validate_data_load(ctx, priv->dreg, elem->data, d2.type);
-		if (err < 0)
-			goto err3;
-	}
+	nft_data_copy(&elem->key, &e->key);
+	if (set->flags & NFT_SET_MAP)
+		nft_data_copy(elem->data, &e->data);
 
-	*new = elem;
+	h = nft_hash_data(&elem->key, priv->hsize, set->klen);
+	hlist_add_head_rcu(&elem->hnode, &priv->hash[h]);
 	return 0;
-
-err3:
-	nft_data_uninit(elem->data, d2.type);
-err2:
-	nft_data_uninit(&elem->key, d1.type);
-err1:
-	kfree(elem);
-	return err;
 }
 
-static int nft_hash_elem_dump(struct sk_buff *skb, const struct nft_expr *expr,
-			      const struct nft_hash_elem *elem)
-
+static void nft_hash_remove(const struct nft_set *set,
+			    const struct nft_set_elem *e)
 {
-	const struct nft_hash *priv = nft_expr_priv(expr);
-	struct nlattr *nest;
-
-	nest = nla_nest_start(skb, NFTA_LIST_ELEM);
-	if (nest == NULL)
-		goto nla_put_failure;
+	struct nft_hash_elem *elem = e->cookie;
 
-	if (nft_data_dump(skb, NFTA_HE_KEY, &elem->key,
-			  NFT_DATA_VALUE, priv->klen) < 0)
-		goto nla_put_failure;
+	hlist_del_rcu(&elem->hnode);
+	nft_hash_elem_destroy(set, elem);
+}
 
-	if (priv->flags & NFT_HASH_MAP) {
-		if (nft_data_dump(skb, NFTA_HE_DATA, elem->data,
-				  NFT_DATA_VALUE, priv->dlen) < 0)
-			goto nla_put_failure;
-	}
+static int nft_hash_get(const struct nft_set *set, struct nft_set_elem *elem)
+{
+	const struct nft_hash *priv = nft_set_priv(set);
+	const struct hlist_node *n;
+	struct nft_hash_elem *e;
+	unsigned int h;
 
-	nla_nest_end(skb, nest);
-	return 0;
+	h = nft_hash_data(&elem->key, priv->hsize, set->klen);
+	hlist_for_each_entry(e, n, &priv->hash[h], hnode) {
+		if (nft_data_cmp(&e->key, &elem->key, set->klen))
+			continue;
 
-nla_put_failure:
-	return -1;
+		elem->cookie = e;
+		elem->flags  = 0;
+		if (set->flags & NFT_SET_MAP)
+			nft_data_copy(&elem->data, e->data);
+		return 0;
+	}
+	return -ENOENT;
 }
 
-static void nft_hash_destroy(const struct nft_ctx *ctx,
-			     const struct nft_expr *expr)
+static void nft_hash_walk(const struct nft_set *set, struct nft_set_iter *iter)
 {
-	const struct nft_hash *priv = nft_expr_priv(expr);
-	const struct hlist_node *n, *next;
-	struct nft_hash_elem *elem;
+	const struct nft_hash *priv = nft_set_priv(set);
+	const struct nft_hash_elem *e;
+	const struct hlist_node *n;
+	struct nft_set_elem elem;
 	unsigned int i;
 
 	for (i = 0; i < priv->hsize; i++) {
-		hlist_for_each_entry_safe(elem, n, next, &priv->hash[i], hnode) {
-			hlist_del(&elem->hnode);
-			nft_hash_elem_destroy(expr, elem);
+		hlist_for_each_entry(e, n, &priv->hash[i], hnode) {
+			if (iter->count < iter->skip)
+				goto cont;
+
+			memcpy(&elem.key, &e->key, sizeof(elem.key));
+			if (set->flags & NFT_SET_MAP)
+				memcpy(&elem.data, e->data, sizeof(elem.data));
+			elem.flags = 0;
+
+			iter->err = iter->fn(set, iter, &elem);
+			if (iter->err < 0)
+				return;
+cont:
+			iter->count++;
 		}
 	}
-	kfree(priv->hash);
 }
 
-static const struct nla_policy nft_hash_policy[NFTA_HASH_MAX + 1] = {
-	[NFTA_HASH_FLAGS]	= { .type = NLA_U32 },
-	[NFTA_HASH_SREG]	= { .type = NLA_U32 },
-	[NFTA_HASH_DREG]	= { .type = NLA_U32 },
-	[NFTA_HASH_KLEN]	= { .type = NLA_U32 },
-	[NFTA_HASH_ELEMENTS]	= { .type = NLA_NESTED },
-};
+static unsigned int nft_hash_privsize(const struct nlattr * const nla[])
+{
+	return sizeof(struct nft_hash);
+}
 
-static int nft_hash_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
-			 const struct nlattr * const tb[])
+static int nft_hash_init(const struct nft_set *set,
+			 const struct nlattr * const nla[])
 {
-	struct nft_hash *priv = nft_expr_priv(expr);
-	struct nft_hash_elem *elem, *uninitialized_var(new);
-	const struct hlist_node *n;
-	const struct nlattr *nla;
+	struct nft_hash *priv = nft_set_priv(set);
 	unsigned int cnt, i;
-	unsigned int h;
-	int err, rem;
 
 	if (unlikely(!nft_hash_rnd_initted)) {
 		get_random_bytes(&nft_hash_rnd, 4);
 		nft_hash_rnd_initted = true;
 	}
 
-	if (tb[NFTA_HASH_SREG] == NULL ||
-	    tb[NFTA_HASH_KLEN] == NULL ||
-	    tb[NFTA_HASH_ELEMENTS] == NULL)
-		return -EINVAL;
-
-	if (tb[NFTA_HASH_FLAGS] != NULL) {
-		priv->flags = ntohl(nla_get_be32(tb[NFTA_HASH_FLAGS]));
-		if (priv->flags & ~NFT_HASH_MAP)
-			return -EINVAL;
-	}
-
-	priv->sreg = ntohl(nla_get_be32(tb[NFTA_HASH_SREG]));
-	err = nft_validate_input_register(priv->sreg);
-	if (err < 0)
-		return err;
-
-	if (tb[NFTA_HASH_DREG] != NULL) {
-		if (!(priv->flags & NFT_HASH_MAP))
-			return -EINVAL;
-		priv->dreg = ntohl(nla_get_be32(tb[NFTA_HASH_DREG]));
-		err = nft_validate_output_register(priv->dreg);
-		if (err < 0)
-			return err;
-	}
-
-	priv->klen = ntohl(nla_get_be32(tb[NFTA_HASH_KLEN]));
-	if (priv->klen == 0)
-		return -EINVAL;
-
-	cnt = 0;
-	nla_for_each_nested(nla, tb[NFTA_HASH_ELEMENTS], rem) {
-		if (nla_type(nla) != NFTA_LIST_ELEM)
-			return -EINVAL;
-		cnt++;
-	}
-
 	/* Aim for a load factor of 0.75 */
+	// FIXME: temporarily broken until we have set descriptions
+	cnt = 100;
 	cnt = cnt * 4 / 3;
 
 	priv->hash = kcalloc(cnt, sizeof(struct hlist_head), GFP_KERNEL);
@@ -259,83 +181,46 @@ static int nft_hash_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 	for (i = 0; i < cnt; i++)
 		INIT_HLIST_HEAD(&priv->hash[i]);
-
-	err = -ENOMEM;
-	nla_for_each_nested(nla, tb[NFTA_HASH_ELEMENTS], rem) {
-		err = nft_hash_elem_init(ctx, expr, nla, &new);
-		if (err < 0)
-			goto err1;
-
-		h = nft_hash_data(&new->key, priv->hsize, priv->klen);
-		hlist_for_each_entry(elem, n, &priv->hash[h], hnode) {
-			if (nft_data_cmp(&elem->key, &new->key, priv->klen))
-				continue;
-			nft_hash_elem_destroy(expr, new);
-			err = -EEXIST;
-			goto err1;
-		}
-		hlist_add_head(&new->hnode, &priv->hash[h]);
-	}
 	return 0;
-
-err1:
-	nft_hash_destroy(ctx, expr);
-	return err;
 }
 
-static int nft_hash_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static void nft_hash_destroy(const struct nft_set *set)
 {
-	const struct nft_hash *priv = nft_expr_priv(expr);
-	const struct nft_hash_elem *elem;
-	const struct hlist_node *n;
-	struct nlattr *list;
+	const struct nft_hash *priv = nft_set_priv(set);
+	const struct hlist_node *n, *next;
+	struct nft_hash_elem *elem;
 	unsigned int i;
 
-	if (priv->flags)
-		NLA_PUT_BE32(skb, NFTA_HASH_FLAGS, htonl(priv->flags));
-	NLA_PUT_BE32(skb, NFTA_HASH_SREG, htonl(priv->sreg));
-	if (priv->flags & NFT_HASH_MAP)
-		NLA_PUT_BE32(skb, NFTA_HASH_DREG, htonl(priv->dreg));
-	NLA_PUT_BE32(skb, NFTA_HASH_KLEN, htonl(priv->klen));
-
-	list = nla_nest_start(skb, NFTA_HASH_ELEMENTS);
-	if (list == NULL)
-		goto nla_put_failure;
-
 	for (i = 0; i < priv->hsize; i++) {
-		hlist_for_each_entry(elem, n, &priv->hash[i], hnode) {
-			if (nft_hash_elem_dump(skb, expr, elem) < 0)
-				goto nla_put_failure;
+		hlist_for_each_entry_safe(elem, n, next, &priv->hash[i], hnode) {
+			hlist_del(&elem->hnode);
+			nft_hash_elem_destroy(set, elem);
 		}
 	}
-
-	nla_nest_end(skb, list);
-	return 0;
-
-nla_put_failure:
-	return -1;
+	kfree(priv->hash);
 }
 
-static struct nft_expr_ops nft_hash_ops __read_mostly = {
-	.name		= "hash",
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_hash)),
-	.owner		= THIS_MODULE,
-	.eval		= nft_hash_eval,
+static struct nft_set_ops nft_hash_ops __read_mostly = {
+	.privsize	= nft_hash_privsize,
 	.init		= nft_hash_init,
 	.destroy	= nft_hash_destroy,
-	.dump		= nft_hash_dump,
-	.policy		= nft_hash_policy,
-	.maxattr	= NFTA_HASH_MAX,
+	.get		= nft_hash_get,
+	.insert		= nft_hash_insert,
+	.remove		= nft_hash_remove,
+	.lookup		= nft_hash_lookup,
+	.walk		= nft_hash_walk,
+	.features	= NFT_SET_MAP,
+	.owner		= THIS_MODULE,
 };
 
 static int __init nft_hash_module_init(void)
 {
-	return nft_register_expr(&nft_hash_ops);
+	return nft_register_set(&nft_hash_ops);
 }
 
 static void __exit nft_hash_module_exit(void)
 {
-	nft_unregister_expr(&nft_hash_ops);
+	nft_unregister_set(&nft_hash_ops);
 }
 
 module_init(nft_hash_module_init);
@@ -343,4 +228,4 @@ module_exit(nft_hash_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_EXPR("hash");
+MODULE_ALIAS_NFT_SET();
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
new file mode 100644
index 0000000..20e18dd
--- /dev/null
+++ b/net/netfilter/nft_lookup.c
@@ -0,0 +1,133 @@
+/*
+ * Copyright (c) 2009 Patrick McHardy <kaber@trash.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Development of this code funded by Astaro AG (http://www.astaro.com/)
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/rbtree.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+
+struct nft_lookup {
+	struct nft_set			*set;
+	enum nft_registers		sreg:8;
+	enum nft_registers		dreg:8;
+	struct nft_set_binding		binding;
+};
+
+static void nft_lookup_eval(const struct nft_expr *expr,
+			    struct nft_data data[NFT_REG_MAX + 1],
+			    const struct nft_pktinfo *pkt)
+{
+	const struct nft_lookup *priv = nft_expr_priv(expr);
+	const struct nft_set *set = priv->set;
+
+	if (set->ops->lookup(set, &data[priv->sreg], &data[priv->dreg]))
+		return;
+	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
+}
+
+static const struct nla_policy nft_lookup_policy[NFTA_LOOKUP_MAX + 1] = {
+	[NFTA_LOOKUP_SET]	= { .type = NLA_STRING },
+	[NFTA_LOOKUP_SREG]	= { .type = NLA_U32 },
+	[NFTA_LOOKUP_DREG]	= { .type = NLA_U32 },
+};
+
+static int nft_lookup_init(const struct nft_ctx *ctx,
+			   const struct nft_expr *expr,
+			   const struct nlattr * const tb[])
+{
+	struct nft_lookup *priv = nft_expr_priv(expr);
+	struct nft_set *set;
+	int err;
+
+	if (tb[NFTA_LOOKUP_SET] == NULL ||
+	    tb[NFTA_LOOKUP_SREG] == NULL)
+		return -EINVAL;
+
+	set = nf_tables_set_lookup(ctx->table, tb[NFTA_LOOKUP_SET]);
+	if (IS_ERR(set))
+		return PTR_ERR(set);
+
+	priv->sreg = ntohl(nla_get_be32(tb[NFTA_LOOKUP_SREG]));
+	err = nft_validate_input_register(priv->sreg);
+	if (err < 0)
+		return err;
+
+	if (tb[NFTA_LOOKUP_DREG] != NULL) {
+		if (!(set->flags & NFT_SET_MAP))
+			return -EINVAL;
+
+		priv->dreg = ntohl(nla_get_be32(tb[NFTA_LOOKUP_DREG]));
+		err = nft_validate_output_register(priv->dreg);
+		if (err < 0)
+			return err;
+
+		if (priv->dreg == NFT_REG_VERDICT) {
+			if (set->dtype != NFT_DATA_VERDICT)
+				return -EINVAL;
+		} else if (set->dtype == NFT_DATA_VERDICT)
+			return -EINVAL;
+	} else if (set->flags & NFT_SET_MAP)
+		return -EINVAL;
+
+	err = nf_tables_bind_set(ctx, set, &priv->binding);
+	if (err < 0)
+		return err;
+
+	priv->set = set;
+	return 0;
+}
+
+static void nft_lookup_destroy(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr)
+{
+	struct nft_lookup *priv = nft_expr_priv(expr);
+
+	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+}
+
+static int nft_lookup_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_lookup *priv = nft_expr_priv(expr);
+
+	NLA_PUT_STRING(skb, NFTA_LOOKUP_SET, priv->set->name);
+	NLA_PUT_BE32(skb, NFTA_LOOKUP_SREG, htonl(priv->sreg));
+	if (priv->set->flags & NFT_SET_MAP)
+		NLA_PUT_BE32(skb, NFTA_LOOKUP_DREG, htonl(priv->dreg));
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static struct nft_expr_ops nft_lookup_ops __read_mostly = {
+	.name		= "lookup",
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_lookup)),
+	.owner		= THIS_MODULE,
+	.eval		= nft_lookup_eval,
+	.init		= nft_lookup_init,
+	.destroy	= nft_lookup_destroy,
+	.dump		= nft_lookup_dump,
+	.policy		= nft_lookup_policy,
+	.maxattr	= NFTA_LOOKUP_MAX,
+};
+
+int __init nft_lookup_module_init(void)
+{
+	return nft_register_expr(&nft_lookup_ops);
+}
+
+void nft_lookup_module_exit(void)
+{
+	nft_unregister_expr(&nft_lookup_ops);
+}
diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
new file mode 100644
index 0000000..456089b
--- /dev/null
+++ b/net/netfilter/nft_rbtree.c
@@ -0,0 +1,244 @@
+/*
+ * Copyright (c) 2008-2009 Patrick McHardy <kaber@trash.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Development of this code funded by Astaro AG (http://www.astaro.com/)
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/rbtree.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+
+struct nft_rbtree {
+	struct rb_root		root;
+};
+
+struct nft_rbtree_elem {
+	struct rb_node		node;
+	u16			flags;
+	struct nft_data		key;
+	struct nft_data		data[];
+};
+
+static bool nft_rbtree_lookup(const struct nft_set *set,
+			      const struct nft_data *key,
+			      struct nft_data *data)
+{
+	const struct nft_rbtree *priv = nft_set_priv(set);
+	const struct nft_rbtree_elem *elem, *interval = NULL;
+	const struct rb_node *parent = priv->root.rb_node;
+	int d;
+
+	while (parent != NULL) {
+		elem = rb_entry(parent, struct nft_rbtree_elem, node);
+
+		d = nft_data_cmp(&elem->key, key, set->klen);
+		if (d < 0) {
+			parent = parent->rb_left;
+			interval = elem;
+		} else if (d > 0)
+			parent = parent->rb_right;
+		else {
+found:
+			if (elem->flags & NFT_SET_ELEM_INTERVAL_END)
+				goto out;
+			if (set->flags & NFT_SET_MAP)
+				nft_data_copy(data, elem->data);
+			return true;
+		}
+	}
+
+	if (set->flags & NFT_SET_INTERVAL && interval != NULL) {
+		elem = interval;
+		goto found;
+	}
+out:
+	return false;
+}
+
+static void nft_rbtree_elem_destroy(const struct nft_set *set,
+				    struct nft_rbtree_elem *elem)
+{
+	nft_data_uninit(&elem->key, NFT_DATA_VALUE);
+	if (set->flags & NFT_SET_MAP)
+		nft_data_uninit(elem->data, set->dtype);
+	kfree(elem);
+}
+
+static int __nft_rbtree_insert(const struct nft_set *set,
+			       struct nft_rbtree_elem *new)
+{
+	struct nft_rbtree *priv = nft_set_priv(set);
+	struct nft_rbtree_elem *elem;
+	struct rb_node *parent, **p;
+	int d;
+
+	parent = NULL;
+	p = &priv->root.rb_node;
+	while (*p != NULL) {
+		parent = *p;
+		elem = rb_entry(parent, struct nft_rbtree_elem, node);
+		d = nft_data_cmp(&elem->key, &new->key, set->klen);
+		if (d < 0)
+			p = &parent->rb_left;
+		else if (d > 0)
+			p = &parent->rb_right;
+		else
+			return -EEXIST;
+	}
+	rb_link_node(&new->node, parent, p);
+	rb_insert_color(&new->node, &priv->root);
+	return 0;
+}
+
+static int nft_rbtree_insert(const struct nft_set *set,
+			     const struct nft_set_elem *elem)
+{
+	struct nft_rbtree_elem *e;
+	unsigned int size;
+	int err;
+
+	size = sizeof(*e);
+	if (set->flags & NFT_SET_MAP)
+		size += sizeof(e->data[0]);
+
+	e = kzalloc(size, GFP_KERNEL);
+	if (e == NULL)
+		return -ENOMEM;
+
+	e->flags = elem->flags;
+	nft_data_copy(&e->key, &elem->key);
+	if (set->flags & NFT_SET_MAP)
+		nft_data_copy(e->data, &elem->data);
+
+	err = __nft_rbtree_insert(set, e);
+	if (err < 0)
+		kfree(elem);
+	return err;
+}
+
+static void nft_rbtree_remove(const struct nft_set *set,
+			      const struct nft_set_elem *elem)
+{
+	struct nft_rbtree *priv = nft_set_priv(set);
+	struct nft_rbtree_elem *e = elem->cookie;
+
+	rb_erase(&e->node, &priv->root);
+	nft_rbtree_elem_destroy(set, e);
+}
+
+static int nft_rbtree_get(const struct nft_set *set, struct nft_set_elem *elem)
+{
+	const struct nft_rbtree *priv = nft_set_priv(set);
+	const struct rb_node *parent = priv->root.rb_node;
+	struct nft_rbtree_elem *e;
+	int d;
+
+	while (parent != NULL) {
+		e = rb_entry(parent, struct nft_rbtree_elem, node);
+
+		d = nft_data_cmp(&e->key, &elem->key, set->klen);
+		if (d < 0)
+			parent = parent->rb_left;
+		else if (d > 0)
+			parent = parent->rb_right;
+		else {
+			elem->cookie = e;
+			if (set->flags & NFT_SET_MAP)
+				nft_data_copy(&elem->data, e->data);
+			elem->flags = e->flags;
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
+static void nft_rbtree_walk(const struct nft_set *set, struct nft_set_iter *iter)
+{
+	const struct nft_rbtree *priv = nft_set_priv(set);
+	const struct nft_rbtree_elem *e;
+	struct nft_set_elem elem;
+	struct rb_node *node;
+
+	for (node = rb_first(&priv->root); node != NULL; node = rb_next(node)) {
+		if (iter->count < iter->skip)
+			goto cont;
+
+		e = rb_entry(node, struct nft_rbtree_elem, node);
+		nft_data_copy(&elem.key, &e->key);
+		if (set->flags & NFT_SET_MAP)
+			nft_data_copy(&elem.data, e->data);
+		elem.flags = e->flags;
+
+		iter->err = iter->fn(set, iter, &elem);
+		if (iter->err < 0)
+			return;
+cont:
+		iter->count++;
+	}
+}
+
+static unsigned int nft_rbtree_privsize(const struct nlattr * const nla[])
+{
+	return sizeof(struct nft_rbtree);
+}
+
+static int nft_rbtree_init(const struct nft_set *set,
+			   const struct nlattr * const nla[])
+{
+	struct nft_rbtree *priv = nft_set_priv(set);
+
+	priv->root = RB_ROOT;
+	return 0;
+}
+
+static void nft_rbtree_destroy(const struct nft_set *set)
+{
+	struct nft_rbtree *priv = nft_set_priv(set);
+	struct nft_rbtree_elem *elem;
+	struct rb_node *node;
+
+	while ((node = priv->root.rb_node) != NULL) {
+		rb_erase(node, &priv->root);
+		elem = rb_entry(node, struct nft_rbtree_elem, node);
+		nft_rbtree_elem_destroy(set, elem);
+	}
+}
+
+static struct nft_set_ops nft_rbtree_ops __read_mostly = {
+	.privsize	= nft_rbtree_privsize,
+	.init		= nft_rbtree_init,
+	.destroy	= nft_rbtree_destroy,
+	.insert		= nft_rbtree_insert,
+	.remove		= nft_rbtree_remove,
+	.get		= nft_rbtree_get,
+	.lookup		= nft_rbtree_lookup,
+	.walk		= nft_rbtree_walk,
+	.features	= NFT_SET_INTERVAL | NFT_SET_MAP,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_rbtree_module_init(void)
+{
+	return nft_register_set(&nft_rbtree_ops);
+}
+
+static void __exit nft_rbtree_module_exit(void)
+{
+	nft_unregister_set(&nft_rbtree_ops);
+}
+
+module_init(nft_rbtree_module_init);
+module_exit(nft_rbtree_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_ALIAS_NFT_SET();
diff --git a/net/netfilter/nft_set.c b/net/netfilter/nft_set.c
deleted file mode 100644
index 0e6727c..0000000
--- a/net/netfilter/nft_set.c
+++ /dev/null
@@ -1,373 +0,0 @@
-/*
- * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Development of this code funded by Astaro AG (http://www.astaro.com/)
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/list.h>
-#include <linux/rbtree.h>
-#include <linux/netlink.h>
-#include <linux/netfilter.h>
-#include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables.h>
-
-struct nft_set {
-	struct rb_root		root;
-	enum nft_registers	sreg:8;
-	enum nft_registers	dreg:8;
-	u8			klen;
-	u8			dlen;
-	u16			flags;
-};
-
-struct nft_set_elem {
-	struct rb_node		node;
-	enum nft_set_elem_flags	flags;
-	struct nft_data		key;
-	struct nft_data		data[];
-};
-
-static void nft_set_eval(const struct nft_expr *expr,
-			 struct nft_data data[NFT_REG_MAX + 1],
-			 const struct nft_pktinfo *pkt)
-{
-	const struct nft_set *priv = nft_expr_priv(expr);
-	const struct rb_node *parent = priv->root.rb_node;
-	const struct nft_set_elem *elem, *interval = NULL;
-	const struct nft_data *key = &data[priv->sreg];
-	int d;
-
-	while (parent != NULL) {
-		elem = rb_entry(parent, struct nft_set_elem, node);
-
-		d = nft_data_cmp(&elem->key, key, priv->klen);
-		if (d < 0) {
-			parent = parent->rb_left;
-			interval = elem;
-		} else if (d > 0)
-			parent = parent->rb_right;
-		else {
-found:
-			if (elem->flags & NFT_SE_INTERVAL_END)
-				goto out;
-			if (priv->flags & NFT_SET_MAP)
-				nft_data_copy(&data[priv->dreg], elem->data);
-			return;
-		}
-	}
-
-	if (priv->flags & NFT_SET_INTERVAL && interval != NULL) {
-		elem = interval;
-		goto found;
-	}
-out:
-	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
-}
-
-static void nft_set_elem_destroy(const struct nft_expr *expr,
-				 struct nft_set_elem *elem)
-{
-	const struct nft_set *priv = nft_expr_priv(expr);
-
-	nft_data_uninit(&elem->key, NFT_DATA_VALUE);
-	if (priv->flags & NFT_SET_MAP)
-		nft_data_uninit(elem->data, nft_dreg_to_type(priv->dreg));
-	kfree(elem);
-}
-
-static const struct nla_policy nft_se_policy[NFTA_SE_MAX + 1] = {
-	[NFTA_SE_KEY]		= { .type = NLA_NESTED },
-	[NFTA_SE_DATA]		= { .type = NLA_NESTED },
-	[NFTA_SE_FLAGS]		= { .type = NLA_U32 },
-};
-
-static int nft_set_elem_init(const struct nft_ctx *ctx,
-			     const struct nft_expr *expr,
-			     const struct nlattr *nla,
-			     struct nft_set_elem **new)
-{
-	struct nft_set *priv = nft_expr_priv(expr);
-	struct nlattr *tb[NFTA_SE_MAX + 1];
-	struct nft_set_elem *elem;
-	struct nft_data_desc d1, d2;
-	enum nft_set_elem_flags flags = 0;
-	unsigned int size;
-	int err;
-
-	err = nla_parse_nested(tb, NFTA_SE_MAX, nla, nft_se_policy);
-	if (err < 0)
-		return err;
-
-	if (tb[NFTA_SE_KEY] == NULL)
-		return -EINVAL;
-
-	if (tb[NFTA_SE_FLAGS] != NULL) {
-		flags = ntohl(nla_get_be32(tb[NFTA_SE_FLAGS]));
-		if (flags & ~NFT_SE_INTERVAL_END)
-			return -EINVAL;
-	}
-
-	size = sizeof(*elem);
-	if (priv->flags & NFT_SET_MAP) {
-		if (tb[NFTA_SE_DATA] == NULL && !(flags & NFT_SE_INTERVAL_END))
-			return -EINVAL;
-		size += sizeof(elem->data[0]);
-	} else {
-		if (tb[NFTA_SE_DATA] != NULL)
-			return -EINVAL;
-	}
-
-	elem = kzalloc(size, GFP_KERNEL);
-	if (elem == NULL)
-		return -ENOMEM;
-	elem->flags = flags;
-
-	err = nft_data_init(ctx, &elem->key, &d1, tb[NFTA_SE_KEY]);
-	if (err < 0)
-		goto err1;
-	err = -EINVAL;
-	if (d1.type != NFT_DATA_VALUE || d1.len != priv->klen)
-		goto err2;
-
-	if (tb[NFTA_SE_DATA] != NULL) {
-		err = nft_data_init(ctx, elem->data, &d2, tb[NFTA_SE_DATA]);
-		if (err < 0)
-			goto err2;
-		err = -EINVAL;
-		if (priv->dreg != NFT_REG_VERDICT && d2.len != priv->dlen)
-			goto err2;
-		err = nft_validate_data_load(ctx, priv->dreg, elem->data, d2.type);
-		if (err < 0)
-			goto err3;
-	}
-
-	*new = elem;
-	return 0;
-
-err3:
-	nft_data_uninit(elem->data, d2.type);
-err2:
-	nft_data_uninit(&elem->key, d1.type);
-err1:
-	kfree(elem);
-	return err;
-}
-
-static int nft_set_elem_dump(struct sk_buff *skb, const struct nft_expr *expr,
-			     const struct nft_set_elem *elem)
-
-{
-	const struct nft_set *priv = nft_expr_priv(expr);
-	struct nlattr *nest;
-
-	nest = nla_nest_start(skb, NFTA_LIST_ELEM);
-	if (nest == NULL)
-		goto nla_put_failure;
-
-	if (nft_data_dump(skb, NFTA_SE_KEY, &elem->key,
-			  NFT_DATA_VALUE, priv->klen) < 0)
-		goto nla_put_failure;
-
-	if (priv->flags & NFT_SET_MAP && !(elem->flags & NFT_SE_INTERVAL_END)) {
-		if (nft_data_dump(skb, NFTA_SE_DATA, elem->data,
-				  nft_dreg_to_type(priv->dreg), priv->dlen) < 0)
-			goto nla_put_failure;
-	}
-
-	if (elem->flags)
-		NLA_PUT_BE32(skb, NFTA_SE_FLAGS, htonl(elem->flags));
-
-	nla_nest_end(skb, nest);
-	return 0;
-
-nla_put_failure:
-	return -1;
-}
-
-static void nft_set_destroy(const struct nft_ctx *ctx,
-			    const struct nft_expr *expr)
-{
-	struct nft_set *priv = nft_expr_priv(expr);
-	struct nft_set_elem *elem;
-	struct rb_node *node;
-
-	while ((node = priv->root.rb_node) != NULL) {
-		rb_erase(node, &priv->root);
-		elem = rb_entry(node, struct nft_set_elem, node);
-		nft_set_elem_destroy(expr, elem);
-	}
-}
-
-static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
-	[NFTA_SET_FLAGS]	= { .type = NLA_U32 },
-	[NFTA_SET_SREG]		= { .type = NLA_U32 },
-	[NFTA_SET_DREG]		= { .type = NLA_U32 },
-	[NFTA_SET_KLEN]		= { .type = NLA_U32 },
-	[NFTA_SET_DLEN]		= { .type = NLA_U32 },
-	[NFTA_SET_ELEMENTS]	= { .type = NLA_NESTED },
-};
-
-static int nft_set_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
-			const struct nlattr * const tb[])
-{
-	struct nft_set *priv = nft_expr_priv(expr);
-	struct nft_set_elem *elem, *uninitialized_var(new);
-	struct rb_node *parent, **p;
-	const struct nlattr *nla;
-	int err, rem, d;
-
-	if (tb[NFTA_SET_SREG] == NULL ||
-	    tb[NFTA_SET_KLEN] == NULL ||
-	    tb[NFTA_SET_ELEMENTS] == NULL)
-		return -EINVAL;
-
-	priv->root = RB_ROOT;
-
-	if (tb[NFTA_SET_FLAGS] != NULL) {
-		priv->flags = ntohl(nla_get_be32(tb[NFTA_SET_FLAGS]));
-		if (priv->flags & ~(NFT_SET_INTERVAL | NFT_SET_MAP))
-			return -EINVAL;
-	}
-
-	priv->sreg = ntohl(nla_get_be32(tb[NFTA_SET_SREG]));
-	err = nft_validate_input_register(priv->sreg);
-	if (err < 0)
-		return err;
-
-	if (tb[NFTA_SET_DREG] != NULL) {
-		if (!(priv->flags & NFT_SET_MAP))
-			return -EINVAL;
-		if (tb[NFTA_SET_DLEN] == NULL)
-			return -EINVAL;
-
-		priv->dreg = ntohl(nla_get_be32(tb[NFTA_SET_DREG]));
-		err = nft_validate_output_register(priv->dreg);
-		if (err < 0)
-			return err;
-
-		if (priv->dreg == NFT_REG_VERDICT)
-			priv->dlen = FIELD_SIZEOF(struct nft_data, data);
-		else {
-			priv->dlen = ntohl(nla_get_be32(tb[NFTA_SET_DLEN]));
-			if (priv->dlen == 0 ||
-			    priv->dlen > FIELD_SIZEOF(struct nft_data, data))
-				return -EINVAL;
-		}
-	} else {
-		if (priv->flags & NFT_SET_MAP)
-			return -EINVAL;
-		if (tb[NFTA_SET_DLEN] != NULL)
-			return -EINVAL;
-	}
-
-	priv->klen = ntohl(nla_get_be32(tb[NFTA_SET_KLEN]));
-	if (priv->klen == 0 ||
-	    priv->klen > FIELD_SIZEOF(struct nft_data, data))
-		return -EINVAL;
-
-	nla_for_each_nested(nla, tb[NFTA_SET_ELEMENTS], rem) {
-		err = -EINVAL;
-		if (nla_type(nla) != NFTA_LIST_ELEM)
-			goto err1;
-
-		err = nft_set_elem_init(ctx, expr, nla, &new);
-		if (err < 0)
-			goto err1;
-
-		parent = NULL;
-		p = &priv->root.rb_node;
-		while (*p != NULL) {
-			parent = *p;
-			elem = rb_entry(parent, struct nft_set_elem, node);
-			d = nft_data_cmp(&elem->key, &new->key, priv->klen);
-			if (d < 0)
-				p = &parent->rb_left;
-			else if (d > 0)
-				p = &parent->rb_right;
-			else {
-				err = -EEXIST;
-				goto err2;
-			}
-		}
-		rb_link_node(&new->node, parent, p);
-		rb_insert_color(&new->node, &priv->root);
-	}
-
-	return 0;
-
-err2:
-	nft_set_elem_destroy(expr, new);
-err1:
-	nft_set_destroy(ctx, expr);
-	return err;
-}
-
-static int nft_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
-{
-	struct nft_set *priv = nft_expr_priv(expr);
-	const struct nft_set_elem *elem;
-	struct rb_node *node;
-	struct nlattr *list;
-
-	if (priv->flags)
-		NLA_PUT_BE32(skb, NFTA_SET_FLAGS, htonl(priv->flags));
-
-	NLA_PUT_BE32(skb, NFTA_SET_SREG, htonl(priv->sreg));
-	NLA_PUT_BE32(skb, NFTA_SET_KLEN, htonl(priv->klen));
-
-	if (priv->flags & NFT_SET_MAP) {
-		NLA_PUT_BE32(skb, NFTA_SET_DREG, htonl(priv->dreg));
-		NLA_PUT_BE32(skb, NFTA_SET_DLEN, htonl(priv->dlen));
-	}
-
-	list = nla_nest_start(skb, NFTA_SET_ELEMENTS);
-	if (list == NULL)
-		goto nla_put_failure;
-
-	for (node = rb_first(&priv->root); node; node = rb_next(node)) {
-		elem = rb_entry(node, struct nft_set_elem, node);
-		if (nft_set_elem_dump(skb, expr, elem) < 0)
-			goto nla_put_failure;
-	}
-
-	nla_nest_end(skb, list);
-	return 0;
-
-nla_put_failure:
-	return -1;
-}
-
-static struct nft_expr_ops nft_set_ops __read_mostly = {
-	.name		= "set",
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_set)),
-	.owner		= THIS_MODULE,
-	.eval		= nft_set_eval,
-	.init		= nft_set_init,
-	.destroy	= nft_set_destroy,
-	.dump		= nft_set_dump,
-	.policy		= nft_set_policy,
-	.maxattr	= NFTA_SET_MAX,
-};
-
-static int __init nft_set_module_init(void)
-{
-	return nft_register_expr(&nft_set_ops);
-}
-
-static void __exit nft_set_module_exit(void)
-{
-	nft_unregister_expr(&nft_set_ops);
-}
-
-module_init(nft_set_module_init);
-module_exit(nft_set_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_EXPR("set");

--------------050405090509070900020405--
