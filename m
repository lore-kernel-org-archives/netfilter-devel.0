From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/7] src: add nft_*_attr_{set|get}_data interface
Date: Wed, 26 Feb 2014 02:51:55 +0100
Message-ID: <1393379519-16189-4-git-send-email-pablo@netfilter.org>
References: <1393379519-16189-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40464 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaBZBwM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:52:12 -0500
In-Reply-To: <1393379519-16189-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds two functions that allows you to validate the size
of the attribute. This new functions provide a replacement for
nft_rule_attr_set and nft_rule_attr_get.

The data_len parameter was already passed to the {_set|_get} funcion
in expressions. For consistency, add nft_rule_expr_{set|get}_data
alias.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Make_global.am           |    2 +-
 include/libnftnl/chain.h |    4 +++
 include/libnftnl/expr.h  |    2 ++
 include/libnftnl/rule.h  |    4 +++
 include/libnftnl/set.h   |    4 +++
 include/libnftnl/table.h |    4 +++
 src/chain.c              |   74 +++++++++++++++++++++++++++++++++++++++-------
 src/libnftnl.map         |   11 +++++++
 src/rule.c               |   58 +++++++++++++++++++++++++++++++-----
 src/set.c                |   42 ++++++++++++++++++++++++--
 src/table.c              |   35 ++++++++++++++++++----
 11 files changed, 212 insertions(+), 28 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 8205938..5bbcf9c 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -18,7 +18,7 @@
 # set age to 0.
 # </snippet>
 #
-LIBVERSION=0:0:0
+LIBVERSION=1:0:1
 
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_srcdir}/include ${LIBMNL_CFLAGS} ${LIBMXML_CFLAGS}
 AM_CFLAGS = ${regular_CFLAGS} ${GCC_FVISIBILITY_HIDDEN}
diff --git a/include/libnftnl/chain.h b/include/libnftnl/chain.h
index 27de302..c11cb5e 100644
--- a/include/libnftnl/chain.h
+++ b/include/libnftnl/chain.h
@@ -36,6 +36,8 @@ enum {
 bool nft_chain_attr_is_set(const struct nft_chain *c, uint16_t attr);
 void nft_chain_attr_unset(struct nft_chain *c, uint16_t attr);
 void nft_chain_attr_set(struct nft_chain *t, uint16_t attr, const void *data);
+void nft_chain_attr_set_data(struct nft_chain *t, uint16_t attr,
+			     const void *data, uint32_t data_len);
 void nft_chain_attr_set_u8(struct nft_chain *t, uint16_t attr, uint8_t data);
 void nft_chain_attr_set_u32(struct nft_chain *t, uint16_t attr, uint32_t data);
 void nft_chain_attr_set_s32(struct nft_chain *t, uint16_t attr, int32_t data);
@@ -43,6 +45,8 @@ void nft_chain_attr_set_u64(struct nft_chain *t, uint16_t attr, uint64_t data);
 void nft_chain_attr_set_str(struct nft_chain *t, uint16_t attr, const char *str);
 
 const void *nft_chain_attr_get(struct nft_chain *c, uint16_t attr);
+const void *nft_chain_attr_get_data(struct nft_chain *c, uint16_t attr,
+				    uint32_t *data_len);
 const char *nft_chain_attr_get_str(struct nft_chain *c, uint16_t attr);
 uint8_t nft_chain_attr_get_u8(struct nft_chain *c, uint16_t attr);
 uint32_t nft_chain_attr_get_u32(struct nft_chain *c, uint16_t attr);
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 6ec05a6..2cfb4dc 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -21,6 +21,7 @@ void nft_rule_expr_free(struct nft_rule_expr *expr);
 
 bool nft_rule_expr_is_set(const struct nft_rule_expr *expr, uint16_t type);
 void nft_rule_expr_set(struct nft_rule_expr *expr, uint16_t type, const void *data, uint32_t data_len);
+#define nft_rule_expr_set_data nft_rule_expr_set
 void nft_rule_expr_set_u8(struct nft_rule_expr *expr, uint16_t type, uint8_t data);
 void nft_rule_expr_set_u16(struct nft_rule_expr *expr, uint16_t type, uint16_t data);
 void nft_rule_expr_set_u32(struct nft_rule_expr *expr, uint16_t type, uint32_t data);
@@ -28,6 +29,7 @@ void nft_rule_expr_set_u64(struct nft_rule_expr *expr, uint16_t type, uint64_t d
 void nft_rule_expr_set_str(struct nft_rule_expr *expr, uint16_t type, const char *str);
 
 const void *nft_rule_expr_get(const struct nft_rule_expr *expr, uint16_t type, uint32_t *data_len);
+#define nft_rule_expr_get_data nft_rule_expr_get
 uint8_t nft_rule_expr_get_u8(const struct nft_rule_expr *expr, uint16_t type);
 uint16_t nft_rule_expr_get_u16(const struct nft_rule_expr *expr, uint16_t type);
 uint32_t nft_rule_expr_get_u32(const struct nft_rule_expr *expr, uint16_t type);
diff --git a/include/libnftnl/rule.h b/include/libnftnl/rule.h
index 13e6c14..9e6efaf 100644
--- a/include/libnftnl/rule.h
+++ b/include/libnftnl/rule.h
@@ -33,11 +33,15 @@ enum {
 void nft_rule_attr_unset(struct nft_rule *r, uint16_t attr);
 bool nft_rule_attr_is_set(const struct nft_rule *r, uint16_t attr);
 void nft_rule_attr_set(struct nft_rule *r, uint16_t attr, const void *data);
+void nft_rule_attr_set_data(struct nft_rule *r, uint16_t attr,
+			    const void *data, uint32_t data_len);
 void nft_rule_attr_set_u32(struct nft_rule *r, uint16_t attr, uint32_t val);
 void nft_rule_attr_set_u64(struct nft_rule *r, uint16_t attr, uint64_t val);
 void nft_rule_attr_set_str(struct nft_rule *r, uint16_t attr, const char *str);
 
 const void *nft_rule_attr_get(const struct nft_rule *r, uint16_t attr);
+const void *nft_rule_attr_get_data(const struct nft_rule *r, uint16_t attr,
+				   uint32_t *data_len);
 const char *nft_rule_attr_get_str(const struct nft_rule *r, uint16_t attr);
 uint8_t nft_rule_attr_get_u8(const struct nft_rule *r, uint16_t attr);
 uint32_t nft_rule_attr_get_u32(const struct nft_rule *r, uint16_t attr);
diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index ba11315..fcb1a7e 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -29,10 +29,14 @@ void nft_set_free(struct nft_set *s);
 bool nft_set_attr_is_set(const struct nft_set *s, uint16_t attr);
 void nft_set_attr_unset(struct nft_set *s, uint16_t attr);
 void nft_set_attr_set(struct nft_set *s, uint16_t attr, const void *data);
+void nft_set_attr_set_data(struct nft_set *s, uint16_t attr, const void *data,
+			   uint32_t data_len);
 void nft_set_attr_set_u32(struct nft_set *s, uint16_t attr, uint32_t val);
 void nft_set_attr_set_str(struct nft_set *s, uint16_t attr, const char *str);
 
 const void *nft_set_attr_get(struct nft_set *s, uint16_t attr);
+const void *nft_set_attr_get_data(struct nft_set *s, uint16_t attr,
+				  uint32_t *data_len);
 const char *nft_set_attr_get_str(struct nft_set *s, uint16_t attr);
 uint32_t nft_set_attr_get_u32(struct nft_set *s, uint16_t attr);
 
diff --git a/include/libnftnl/table.h b/include/libnftnl/table.h
index 96f2668..fac79e7 100644
--- a/include/libnftnl/table.h
+++ b/include/libnftnl/table.h
@@ -29,7 +29,11 @@ enum {
 bool nft_table_attr_is_set(const struct nft_table *t, uint16_t attr);
 void nft_table_attr_unset(struct nft_table *t, uint16_t attr);
 void nft_table_attr_set(struct nft_table *t, uint16_t attr, const void *data);
+void nft_table_attr_set_data(struct nft_table *t, uint16_t attr,
+			     const void *data, uint32_t data_len);
 const void *nft_table_attr_get(struct nft_table *t, uint16_t attr);
+const void *nft_table_attr_get_data(struct nft_table *t, uint16_t attr,
+				    uint32_t *data_len);
 
 void nft_table_attr_set_u8(struct nft_table *t, uint16_t attr, uint8_t data);
 void nft_table_attr_set_u32(struct nft_table *t, uint16_t attr, uint32_t data);
diff --git a/src/chain.c b/src/chain.c
index 19e7950..a704502 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -140,11 +140,24 @@ void nft_chain_attr_unset(struct nft_chain *c, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_chain_attr_unset);
 
-void nft_chain_attr_set(struct nft_chain *c, uint16_t attr, const void *data)
+static uint32_t nft_chain_attr_validate[NFT_CHAIN_ATTR_MAX + 1] = {
+	[NFT_CHAIN_ATTR_HOOKNUM]	= sizeof(uint32_t),
+	[NFT_CHAIN_ATTR_PRIO]		= sizeof(int32_t),
+	[NFT_CHAIN_ATTR_POLICY]		= sizeof(uint32_t),
+	[NFT_CHAIN_ATTR_BYTES]		= sizeof(uint64_t),
+	[NFT_CHAIN_ATTR_PACKETS]	= sizeof(uint64_t),
+	[NFT_CHAIN_ATTR_HANDLE]		= sizeof(uint64_t),
+	[NFT_CHAIN_ATTR_FAMILY]		= sizeof(uint8_t),
+};
+
+void nft_chain_attr_set_data(struct nft_chain *c, uint16_t attr,
+			     const void *data, uint32_t data_len)
 {
 	if (attr > NFT_CHAIN_ATTR_MAX)
 		return;
 
+	nft_assert_validate(nft_chain_attr_validate, attr, data_len);
+
 	switch(attr) {
 	case NFT_CHAIN_ATTR_NAME:
 		strncpy(c->name, data, NFT_CHAIN_MAXNAMELEN);
@@ -188,39 +201,46 @@ void nft_chain_attr_set(struct nft_chain *c, uint16_t attr, const void *data)
 	}
 	c->flags |= (1 << attr);
 }
+EXPORT_SYMBOL(nft_chain_attr_set_data);
+
+void nft_chain_attr_set(struct nft_chain *c, uint16_t attr, const void *data)
+{
+	nft_chain_attr_set_data(c, attr, data, nft_chain_attr_validate[attr]);
+}
 EXPORT_SYMBOL(nft_chain_attr_set);
 
 void nft_chain_attr_set_u32(struct nft_chain *c, uint16_t attr, uint32_t data)
 {
-	nft_chain_attr_set(c, attr, &data);
+	nft_chain_attr_set_data(c, attr, &data, sizeof(uint32_t));
 }
 EXPORT_SYMBOL(nft_chain_attr_set_u32);
 
 void nft_chain_attr_set_s32(struct nft_chain *c, uint16_t attr, int32_t data)
 {
-	nft_chain_attr_set(c, attr, &data);
+	nft_chain_attr_set_data(c, attr, &data, sizeof(int32_t));
 }
 EXPORT_SYMBOL(nft_chain_attr_set_s32);
 
 void nft_chain_attr_set_u64(struct nft_chain *c, uint16_t attr, uint64_t data)
 {
-	nft_chain_attr_set(c, attr, &data);
+	nft_chain_attr_set_data(c, attr, &data, sizeof(uint64_t));
 }
 EXPORT_SYMBOL(nft_chain_attr_set_u64);
 
 void nft_chain_attr_set_u8(struct nft_chain *c, uint16_t attr, uint8_t data)
 {
-	nft_chain_attr_set(c, attr, &data);
+	nft_chain_attr_set_data(c, attr, &data, sizeof(uint8_t));
 }
 EXPORT_SYMBOL(nft_chain_attr_set_u8);
 
 void nft_chain_attr_set_str(struct nft_chain *c, uint16_t attr, const char *str)
 {
-	nft_chain_attr_set(c, attr, str);
+	nft_chain_attr_set_data(c, attr, str, strlen(str));
 }
 EXPORT_SYMBOL(nft_chain_attr_set_str);
 
-const void *nft_chain_attr_get(struct nft_chain *c, uint16_t attr)
+const void *nft_chain_attr_get_data(struct nft_chain *c, uint16_t attr,
+				    uint32_t *data_len)
 {
 	if (!(c->flags & (1 << attr)))
 		return NULL;
@@ -231,26 +251,42 @@ const void *nft_chain_attr_get(struct nft_chain *c, uint16_t attr)
 	case NFT_CHAIN_ATTR_TABLE:
 		return c->table;
 	case NFT_CHAIN_ATTR_HOOKNUM:
+		*data_len = sizeof(uint32_t);
 		return &c->hooknum;
 	case NFT_CHAIN_ATTR_PRIO:
+		*data_len = sizeof(int32_t);
 		return &c->prio;
 	case NFT_CHAIN_ATTR_POLICY:
+		*data_len = sizeof(uint32_t);
 		return &c->policy;
 	case NFT_CHAIN_ATTR_USE:
+		*data_len = sizeof(uint32_t);
 		return &c->use;
 	case NFT_CHAIN_ATTR_BYTES:
+		*data_len = sizeof(uint64_t);
 		return &c->bytes;
 	case NFT_CHAIN_ATTR_PACKETS:
+		*data_len = sizeof(uint64_t);
 		return &c->packets;
 	case NFT_CHAIN_ATTR_HANDLE:
+		*data_len = sizeof(uint64_t);
 		return &c->handle;
 	case NFT_CHAIN_ATTR_FAMILY:
+		*data_len = sizeof(uint8_t);
 		return &c->family;
 	case NFT_CHAIN_ATTR_TYPE:
+		*data_len = sizeof(uint32_t);
 		return c->type;
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(nft_chain_attr_get_data);
+
+const void *nft_chain_attr_get(struct nft_chain *c, uint16_t attr)
+{
+	uint32_t data_len;
+	return nft_chain_attr_get_data(c, attr, &data_len);
+}
 EXPORT_SYMBOL(nft_chain_attr_get);
 
 const char *nft_chain_attr_get_str(struct nft_chain *c, uint16_t attr)
@@ -261,28 +297,44 @@ EXPORT_SYMBOL(nft_chain_attr_get_str);
 
 uint32_t nft_chain_attr_get_u32(struct nft_chain *c, uint16_t attr)
 {
-	const uint32_t *val = nft_chain_attr_get(c, attr);
+	uint32_t data_len;
+	const uint32_t *val = nft_chain_attr_get_data(c, attr, &data_len);
+
+	nft_assert(attr, data_len == sizeof(uint32_t));
+
 	return val ? *val : 0;
 }
 EXPORT_SYMBOL(nft_chain_attr_get_u32);
 
 int32_t nft_chain_attr_get_s32(struct nft_chain *c, uint16_t attr)
 {
-	const int32_t *val = nft_chain_attr_get(c, attr);
+	uint32_t data_len;
+	const int32_t *val = nft_chain_attr_get_data(c, attr, &data_len);
+
+	nft_assert(attr, data_len == sizeof(int32_t));
+
 	return val ? *val : 0;
 }
 EXPORT_SYMBOL(nft_chain_attr_get_s32);
 
 uint64_t nft_chain_attr_get_u64(struct nft_chain *c, uint16_t attr)
 {
-	const uint64_t *val = nft_chain_attr_get(c, attr);
+	uint32_t data_len;
+	const uint64_t *val = nft_chain_attr_get_data(c, attr, &data_len);
+
+	nft_assert(attr, data_len == sizeof(int64_t));
+
 	return val ? *val : 0;
 }
 EXPORT_SYMBOL(nft_chain_attr_get_u64);
 
 uint8_t nft_chain_attr_get_u8(struct nft_chain *c, uint16_t attr)
 {
-	const uint8_t *val = nft_chain_attr_get(c, attr);
+	uint32_t data_len;
+	const uint8_t *val = nft_chain_attr_get_data(c, attr, &data_len);
+
+	nft_assert(attr, data_len == sizeof(int8_t));
+
 	return val ? *val : 0;
 }
 EXPORT_SYMBOL(nft_chain_attr_get_u8);
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 43378ed..7c4e6ca 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -196,3 +196,14 @@ global:
 
 local: *;
 };
+
+LIBNFTNL_1.1 {
+  nft_table_attr_set_data;
+  nft_table_attr_get_data;
+  nft_chain_attr_set_data;
+  nft_chain_attr_get_data;
+  nft_rule_attr_set_data;
+  nft_rule_attr_get_data;
+  nft_set_attr_set_data;
+  nft_set_attr_get_data;
+} LIBNFTNL_1.0;
diff --git a/src/rule.c b/src/rule.c
index 5e149c7..ca4235b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -113,11 +113,22 @@ void nft_rule_attr_unset(struct nft_rule *r, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_rule_attr_unset);
 
-void nft_rule_attr_set(struct nft_rule *r, uint16_t attr, const void *data)
+static uint32_t nft_rule_attr_validate[NFT_RULE_ATTR_MAX + 1] = {
+	[NFT_RULE_ATTR_HANDLE]		= sizeof(uint64_t),
+	[NFT_RULE_ATTR_COMPAT_PROTO]	= sizeof(uint32_t),
+	[NFT_RULE_ATTR_COMPAT_FLAGS]	= sizeof(uint32_t),
+	[NFT_RULE_ATTR_FAMILY]		= sizeof(uint8_t),
+	[NFT_RULE_ATTR_POSITION]	= sizeof(uint64_t),
+};
+
+void nft_rule_attr_set_data(struct nft_rule *r, uint16_t attr,
+			    const void *data, uint32_t data_len)
 {
 	if (attr > NFT_RULE_ATTR_MAX)
 		return;
 
+	nft_assert_validate(nft_rule_attr_validate, attr, data_len);
+
 	switch(attr) {
 	case NFT_RULE_ATTR_TABLE:
 		if (r->table)
@@ -149,49 +160,68 @@ void nft_rule_attr_set(struct nft_rule *r, uint16_t attr, const void *data)
 	}
 	r->flags |= (1 << attr);
 }
+EXPORT_SYMBOL(nft_rule_attr_set_data);
+
+void nft_rule_attr_set(struct nft_rule *r, uint16_t attr, const void *data)
+{
+	nft_rule_attr_set_data(r, attr, data, nft_rule_attr_validate[attr]);
+}
 EXPORT_SYMBOL(nft_rule_attr_set);
 
 void nft_rule_attr_set_u32(struct nft_rule *r, uint16_t attr, uint32_t val)
 {
-	nft_rule_attr_set(r, attr, &val);
+	nft_rule_attr_set_data(r, attr, &val, sizeof(uint32_t));
 }
 EXPORT_SYMBOL(nft_rule_attr_set_u32);
 
 void nft_rule_attr_set_u64(struct nft_rule *r, uint16_t attr, uint64_t val)
 {
-	nft_rule_attr_set(r, attr, &val);
+	nft_rule_attr_set_data(r, attr, &val, sizeof(uint64_t));
 }
 EXPORT_SYMBOL(nft_rule_attr_set_u64);
 
 void nft_rule_attr_set_str(struct nft_rule *r, uint16_t attr, const char *str)
 {
-	nft_rule_attr_set(r, attr, str);
+	nft_rule_attr_set_data(r, attr, str, strlen(str));
 }
 EXPORT_SYMBOL(nft_rule_attr_set_str);
 
-const void *nft_rule_attr_get(const struct nft_rule *r, uint16_t attr)
+const void *nft_rule_attr_get_data(const struct nft_rule *r, uint16_t attr,
+				   uint32_t *data_len)
 {
 	if (!(r->flags & (1 << attr)))
 		return NULL;
 
 	switch(attr) {
 	case NFT_RULE_ATTR_FAMILY:
+		*data_len = sizeof(uint8_t);
 		return &r->family;
 	case NFT_RULE_ATTR_TABLE:
 		return r->table;
 	case NFT_RULE_ATTR_CHAIN:
 		return r->chain;
 	case NFT_RULE_ATTR_HANDLE:
+		*data_len = sizeof(uint64_t);
 		return &r->handle;
 	case NFT_RULE_ATTR_COMPAT_PROTO:
+		*data_len = sizeof(uint32_t);
 		return &r->compat.proto;
 	case NFT_RULE_ATTR_COMPAT_FLAGS:
+		*data_len = sizeof(uint32_t);
 		return &r->compat.flags;
 	case NFT_RULE_ATTR_POSITION:
+		*data_len = sizeof(uint64_t);
 		return &r->position;
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(nft_rule_attr_get_data);
+
+const void *nft_rule_attr_get(const struct nft_rule *r, uint16_t attr)
+{
+	uint32_t data_len;
+	return nft_rule_attr_get_data(r, attr, &data_len);
+}
 EXPORT_SYMBOL(nft_rule_attr_get);
 
 const char *nft_rule_attr_get_str(const struct nft_rule *r, uint16_t attr)
@@ -202,21 +232,33 @@ EXPORT_SYMBOL(nft_rule_attr_get_str);
 
 uint32_t nft_rule_attr_get_u32(const struct nft_rule *r, uint16_t attr)
 {
-	const uint32_t *val = nft_rule_attr_get(r, attr);
+	uint32_t data_len;
+	const uint32_t *val = nft_rule_attr_get_data(r, attr, &data_len);
+
+	nft_assert(attr, data_len == sizeof(uint32_t));
+
 	return val ? *val : 0;
 }
 EXPORT_SYMBOL(nft_rule_attr_get_u32);
 
 uint64_t nft_rule_attr_get_u64(const struct nft_rule *r, uint16_t attr)
 {
-	const uint64_t *val = nft_rule_attr_get(r, attr);
+	uint32_t data_len;
+	const uint64_t *val = nft_rule_attr_get_data(r, attr, &data_len);
+
+	nft_assert(attr, data_len == sizeof(uint64_t));
+
 	return val ? *val : 0;
 }
 EXPORT_SYMBOL(nft_rule_attr_get_u64);
 
 uint8_t nft_rule_attr_get_u8(const struct nft_rule *r, uint16_t attr)
 {
-	const uint8_t *val = nft_rule_attr_get(r, attr);
+	uint32_t data_len;
+	const uint8_t *val = nft_rule_attr_get_data(r, attr, &data_len);
+
+	nft_assert(attr, data_len == sizeof(uint8_t));
+
 	return val ? *val : 0;
 }
 EXPORT_SYMBOL(nft_rule_attr_get_u8);
diff --git a/src/set.c b/src/set.c
index c8b5ccf..ef10af5 100644
--- a/src/set.c
+++ b/src/set.c
@@ -96,11 +96,23 @@ void nft_set_attr_unset(struct nft_set *s, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_set_attr_unset);
 
-void nft_set_attr_set(struct nft_set *s, uint16_t attr, const void *data)
+static uint32_t nft_set_attr_validate[NFT_SET_ATTR_MAX + 1] = {
+	[NFT_SET_ATTR_FLAGS]		= sizeof(uint32_t),
+	[NFT_SET_ATTR_KEY_TYPE]		= sizeof(uint32_t),
+	[NFT_SET_ATTR_KEY_LEN]		= sizeof(uint32_t),
+	[NFT_SET_ATTR_DATA_TYPE]	= sizeof(uint32_t),
+	[NFT_SET_ATTR_DATA_LEN]		= sizeof(uint32_t),
+	[NFT_SET_ATTR_FAMILY]		= sizeof(uint32_t),
+};
+
+void nft_set_attr_set_data(struct nft_set *s, uint16_t attr, const void *data,
+			   uint32_t data_len)
 {
 	if (attr > NFT_SET_ATTR_MAX)
 		return;
 
+	nft_assert_validate(nft_set_attr_validate, attr, data_len);
+
 	switch(attr) {
 	case NFT_SET_ATTR_TABLE:
 		if (s->table)
@@ -135,6 +147,12 @@ void nft_set_attr_set(struct nft_set *s, uint16_t attr, const void *data)
 	}
 	s->flags |= (1 << attr);
 }
+EXPORT_SYMBOL(nft_set_attr_set_data);
+
+void nft_set_attr_set(struct nft_set *s, uint16_t attr, const void *data)
+{
+	nft_set_attr_set_data(s, attr, data, nft_set_attr_validate[attr]);
+}
 EXPORT_SYMBOL(nft_set_attr_set);
 
 void nft_set_attr_set_u32(struct nft_set *s, uint16_t attr, uint32_t val)
@@ -149,7 +167,8 @@ void nft_set_attr_set_str(struct nft_set *s, uint16_t attr, const char *str)
 }
 EXPORT_SYMBOL(nft_set_attr_set_str);
 
-const void *nft_set_attr_get(struct nft_set *s, uint16_t attr)
+const void *nft_set_attr_get_data(struct nft_set *s, uint16_t attr,
+				  uint32_t *data_len)
 {
 	if (!(s->flags & (1 << attr)))
 		return NULL;
@@ -160,20 +179,33 @@ const void *nft_set_attr_get(struct nft_set *s, uint16_t attr)
 	case NFT_SET_ATTR_NAME:
 		return s->name;
 	case NFT_SET_ATTR_FLAGS:
+		*data_len = sizeof(uint32_t);
 		return &s->set_flags;
 	case NFT_SET_ATTR_KEY_TYPE:
+		*data_len = sizeof(uint32_t);
 		return &s->key_type;
 	case NFT_SET_ATTR_KEY_LEN:
+		*data_len = sizeof(uint32_t);
 		return &s->key_len;
 	case NFT_SET_ATTR_DATA_TYPE:
+		*data_len = sizeof(uint32_t);
 		return &s->data_type;
 	case NFT_SET_ATTR_DATA_LEN:
+		*data_len = sizeof(uint32_t);
 		return &s->data_len;
 	case NFT_SET_ATTR_FAMILY:
+		*data_len = sizeof(uint32_t);
 		return &s->family;
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(nft_set_attr_get_data);
+
+const void *nft_set_attr_get(struct nft_set *s, uint16_t attr)
+{
+	uint32_t data_len;
+	return nft_set_attr_get_data(s, attr, &data_len);
+}
 EXPORT_SYMBOL(nft_set_attr_get);
 
 const char *nft_set_attr_get_str(struct nft_set *s, uint16_t attr)
@@ -184,7 +216,11 @@ EXPORT_SYMBOL(nft_set_attr_get_str);
 
 uint32_t nft_set_attr_get_u32(struct nft_set *s, uint16_t attr)
 {
-	const uint32_t *val = nft_set_attr_get(s, attr);
+	uint32_t data_len;
+	const uint32_t *val = nft_set_attr_get_data(s, attr, &data_len);
+
+	nft_assert(attr, data_len == sizeof(uint32_t));
+
 	return val ? *val : 0;
 }
 EXPORT_SYMBOL(nft_set_attr_get_u32);
diff --git a/src/table.c b/src/table.c
index af4b13c..33d6a8d 100644
--- a/src/table.c
+++ b/src/table.c
@@ -79,11 +79,19 @@ void nft_table_attr_unset(struct nft_table *t, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_table_attr_unset);
 
-void nft_table_attr_set(struct nft_table *t, uint16_t attr, const void *data)
+static uint32_t nft_table_attr_validate[NFT_TABLE_ATTR_MAX + 1] = {
+	[NFT_TABLE_ATTR_FLAGS]	= sizeof(uint32_t),
+	[NFT_TABLE_ATTR_FAMILY]	= sizeof(uint8_t),
+};
+
+void nft_table_attr_set_data(struct nft_table *t, uint16_t attr,
+			     const void *data, uint32_t data_len)
 {
 	if (attr > NFT_TABLE_ATTR_MAX)
 		return;
 
+	nft_assert_validate(nft_table_attr_validate, attr, data_len);
+
 	switch (attr) {
 	case NFT_TABLE_ATTR_NAME:
 		if (t->name)
@@ -103,27 +111,34 @@ void nft_table_attr_set(struct nft_table *t, uint16_t attr, const void *data)
 	}
 	t->flags |= (1 << attr);
 }
+EXPORT_SYMBOL(nft_table_attr_set_data);
+
+void nft_table_attr_set(struct nft_table *t, uint16_t attr, const void *data)
+{
+	nft_table_attr_set_data(t, attr, data, nft_table_attr_validate[attr]);
+}
 EXPORT_SYMBOL(nft_table_attr_set);
 
 void nft_table_attr_set_u32(struct nft_table *t, uint16_t attr, uint32_t val)
 {
-	nft_table_attr_set(t, attr, &val);
+	nft_table_attr_set_data(t, attr, &val, sizeof(uint32_t));
 }
 EXPORT_SYMBOL(nft_table_attr_set_u32);
 
 void nft_table_attr_set_u8(struct nft_table *t, uint16_t attr, uint8_t val)
 {
-	nft_table_attr_set(t, attr, &val);
+	nft_table_attr_set_data(t, attr, &val, sizeof(uint8_t));
 }
 EXPORT_SYMBOL(nft_table_attr_set_u8);
 
 void nft_table_attr_set_str(struct nft_table *t, uint16_t attr, const char *str)
 {
-	nft_table_attr_set(t, attr, str);
+	nft_table_attr_set_data(t, attr, str, 0);
 }
 EXPORT_SYMBOL(nft_table_attr_set_str);
 
-const void *nft_table_attr_get(struct nft_table *t, uint16_t attr)
+const void *nft_table_attr_get_data(struct nft_table *t, uint16_t attr,
+				    uint32_t *data_len)
 {
 	if (!(t->flags & (1 << attr)))
 		return NULL;
@@ -132,14 +147,24 @@ const void *nft_table_attr_get(struct nft_table *t, uint16_t attr)
 	case NFT_TABLE_ATTR_NAME:
 		return t->name;
 	case NFT_TABLE_ATTR_FLAGS:
+		*data_len = sizeof(uint32_t);
 		return &t->table_flags;
 	case NFT_TABLE_ATTR_FAMILY:
+		*data_len = sizeof(uint8_t);
 		return &t->family;
 	case NFT_TABLE_ATTR_USE:
+		*data_len = sizeof(uint32_t);
 		return &t->use;
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(nft_table_attr_get_data);
+
+const void *nft_table_attr_get(struct nft_table *t, uint16_t attr)
+{
+	uint32_t data_len;
+	return nft_table_attr_get_data(t, attr, &data_len);
+}
 EXPORT_SYMBOL(nft_table_attr_get);
 
 uint32_t nft_table_attr_get_u32(struct nft_table *t, uint16_t attr)
-- 
1.7.10.4

