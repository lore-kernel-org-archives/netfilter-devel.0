From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 3/9] src: return value on setters that internally allocate memory
Date: Tue, 14 Jun 2016 15:18:39 +0200
Message-ID: <1465910325-13286-3-git-send-email-pablo@netfilter.org>
References: <1465910325-13286-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55943 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbcFNNTD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 09:19:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8238DE7DBA
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6DD3B9EBA5
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E76099EBA8
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:52 +0200 (CEST)
In-Reply-To: <1465910325-13286-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So the client can bail out of memory allocation errors. Or in case of
daemon, make sure things are left in consistent state before bailing
out.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/chain.h |  4 ++--
 include/libnftnl/expr.h  |  4 ++--
 include/libnftnl/gen.h   |  6 +++---
 include/libnftnl/rule.h  |  8 ++++----
 include/libnftnl/set.h   | 12 ++++++------
 include/libnftnl/table.h |  6 +++---
 src/chain.c              | 15 +++++++++++----
 src/expr.c               | 15 +++++++--------
 src/gen.c                |  9 +++++----
 src/rule.c               | 19 ++++++++++++-------
 src/set.c                | 17 +++++++++++------
 src/set_elem.c           | 13 ++++++-------
 src/table.c              | 11 +++++++----
 13 files changed, 79 insertions(+), 60 deletions(-)

diff --git a/include/libnftnl/chain.h b/include/libnftnl/chain.h
index b72741f..8d7ff9f 100644
--- a/include/libnftnl/chain.h
+++ b/include/libnftnl/chain.h
@@ -37,13 +37,13 @@ enum nftnl_chain_attr {
 bool nftnl_chain_is_set(const struct nftnl_chain *c, uint16_t attr);
 void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr);
 void nftnl_chain_set(struct nftnl_chain *t, uint16_t attr, const void *data);
-void nftnl_chain_set_data(struct nftnl_chain *t, uint16_t attr,
+int nftnl_chain_set_data(struct nftnl_chain *t, uint16_t attr,
 			     const void *data, uint32_t data_len);
 void nftnl_chain_set_u8(struct nftnl_chain *t, uint16_t attr, uint8_t data);
 void nftnl_chain_set_u32(struct nftnl_chain *t, uint16_t attr, uint32_t data);
 void nftnl_chain_set_s32(struct nftnl_chain *t, uint16_t attr, int32_t data);
 void nftnl_chain_set_u64(struct nftnl_chain *t, uint16_t attr, uint64_t data);
-void nftnl_chain_set_str(struct nftnl_chain *t, uint16_t attr, const char *str);
+int nftnl_chain_set_str(struct nftnl_chain *t, uint16_t attr, const char *str);
 
 const void *nftnl_chain_get(const struct nftnl_chain *c, uint16_t attr);
 const void *nftnl_chain_get_data(const struct nftnl_chain *c, uint16_t attr,
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index aa6dfdd..eea2b95 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -20,13 +20,13 @@ struct nftnl_expr *nftnl_expr_alloc(const char *name);
 void nftnl_expr_free(const struct nftnl_expr *expr);
 
 bool nftnl_expr_is_set(const struct nftnl_expr *expr, uint16_t type);
-void nftnl_expr_set(struct nftnl_expr *expr, uint16_t type, const void *data, uint32_t data_len);
+int nftnl_expr_set(struct nftnl_expr *expr, uint16_t type, const void *data, uint32_t data_len);
 #define nftnl_expr_set_data nftnl_expr_set
 void nftnl_expr_set_u8(struct nftnl_expr *expr, uint16_t type, uint8_t data);
 void nftnl_expr_set_u16(struct nftnl_expr *expr, uint16_t type, uint16_t data);
 void nftnl_expr_set_u32(struct nftnl_expr *expr, uint16_t type, uint32_t data);
 void nftnl_expr_set_u64(struct nftnl_expr *expr, uint16_t type, uint64_t data);
-void nftnl_expr_set_str(struct nftnl_expr *expr, uint16_t type, const char *str);
+int nftnl_expr_set_str(struct nftnl_expr *expr, uint16_t type, const char *str);
 
 const void *nftnl_expr_get(const struct nftnl_expr *expr, uint16_t type, uint32_t *data_len);
 #define nftnl_expr_get_data nftnl_expr_get
diff --git a/include/libnftnl/gen.h b/include/libnftnl/gen.h
index f69bf2f..b55bded 100644
--- a/include/libnftnl/gen.h
+++ b/include/libnftnl/gen.h
@@ -25,9 +25,9 @@ enum {
 
 bool nftnl_gen_is_set(const struct nftnl_gen *gen, uint16_t attr);
 void nftnl_gen_unset(struct nftnl_gen *gen, uint16_t attr);
-void nftnl_gen_set(struct nftnl_gen *gen, uint16_t attr, const void *data);
-void nftnl_gen_set_data(struct nftnl_gen *gen, uint16_t attr,
-			     const void *data, uint32_t data_len);
+int nftnl_gen_set(struct nftnl_gen *gen, uint16_t attr, const void *data);
+int nftnl_gen_set_data(struct nftnl_gen *gen, uint16_t attr,
+		       const void *data, uint32_t data_len);
 const void *nftnl_gen_get(const struct nftnl_gen *gen, uint16_t attr);
 const void *nftnl_gen_get_data(const struct nftnl_gen *gen, uint16_t attr,
 			       uint32_t *data_len);
diff --git a/include/libnftnl/rule.h b/include/libnftnl/rule.h
index d9a8e12..eff68da 100644
--- a/include/libnftnl/rule.h
+++ b/include/libnftnl/rule.h
@@ -33,12 +33,12 @@ enum nftnl_rule_attr {
 
 void nftnl_rule_unset(struct nftnl_rule *r, uint16_t attr);
 bool nftnl_rule_is_set(const struct nftnl_rule *r, uint16_t attr);
-void nftnl_rule_set(struct nftnl_rule *r, uint16_t attr, const void *data);
-void nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
-			    const void *data, uint32_t data_len);
+int nftnl_rule_set(struct nftnl_rule *r, uint16_t attr, const void *data);
+int nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
+			const void *data, uint32_t data_len);
 void nftnl_rule_set_u32(struct nftnl_rule *r, uint16_t attr, uint32_t val);
 void nftnl_rule_set_u64(struct nftnl_rule *r, uint16_t attr, uint64_t val);
-void nftnl_rule_set_str(struct nftnl_rule *r, uint16_t attr, const char *str);
+int nftnl_rule_set_str(struct nftnl_rule *r, uint16_t attr, const char *str);
 
 const void *nftnl_rule_get(const struct nftnl_rule *r, uint16_t attr);
 const void *nftnl_rule_get_data(const struct nftnl_rule *r, uint16_t attr,
diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 00868c5..46fa8f4 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -35,12 +35,12 @@ struct nftnl_set *nftnl_set_clone(const struct nftnl_set *set);
 
 bool nftnl_set_is_set(const struct nftnl_set *s, uint16_t attr);
 void nftnl_set_unset(struct nftnl_set *s, uint16_t attr);
-void nftnl_set_set(struct nftnl_set *s, uint16_t attr, const void *data);
-void nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
-			   uint32_t data_len);
+int nftnl_set_set(struct nftnl_set *s, uint16_t attr, const void *data);
+int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
+		       uint32_t data_len);
 void nftnl_set_set_u32(struct nftnl_set *s, uint16_t attr, uint32_t val);
 void nftnl_set_set_u64(struct nftnl_set *s, uint16_t attr, uint64_t val);
-void nftnl_set_set_str(struct nftnl_set *s, uint16_t attr, const char *str);
+int nftnl_set_set_str(struct nftnl_set *s, uint16_t attr, const char *str);
 
 const void *nftnl_set_get(const struct nftnl_set *s, uint16_t attr);
 const void *nftnl_set_get_data(const struct nftnl_set *s, uint16_t attr,
@@ -106,10 +106,10 @@ struct nftnl_set_elem *nftnl_set_elem_clone(struct nftnl_set_elem *elem);
 void nftnl_set_elem_add(struct nftnl_set *s, struct nftnl_set_elem *elem);
 
 void nftnl_set_elem_unset(struct nftnl_set_elem *s, uint16_t attr);
-void nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr, const void *data, uint32_t data_len);
+int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr, const void *data, uint32_t data_len);
 void nftnl_set_elem_set_u32(struct nftnl_set_elem *s, uint16_t attr, uint32_t val);
 void nftnl_set_elem_set_u64(struct nftnl_set_elem *s, uint16_t attr, uint64_t val);
-void nftnl_set_elem_set_str(struct nftnl_set_elem *s, uint16_t attr, const char *str);
+int nftnl_set_elem_set_str(struct nftnl_set_elem *s, uint16_t attr, const char *str);
 
 const void *nftnl_set_elem_get(struct nftnl_set_elem *s, uint16_t attr, uint32_t *data_len);
 const char *nftnl_set_elem_get_str(struct nftnl_set_elem *s, uint16_t attr);
diff --git a/include/libnftnl/table.h b/include/libnftnl/table.h
index d2557ba..87c51b4 100644
--- a/include/libnftnl/table.h
+++ b/include/libnftnl/table.h
@@ -29,15 +29,15 @@ enum nftnl_table_attr {
 bool nftnl_table_is_set(const struct nftnl_table *t, uint16_t attr);
 void nftnl_table_unset(struct nftnl_table *t, uint16_t attr);
 void nftnl_table_set(struct nftnl_table *t, uint16_t attr, const void *data);
-void nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
-			     const void *data, uint32_t data_len);
+int nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
+			 const void *data, uint32_t data_len);
 const void *nftnl_table_get(const struct nftnl_table *t, uint16_t attr);
 const void *nftnl_table_get_data(const struct nftnl_table *t, uint16_t attr,
 				 uint32_t *data_len);
 
 void nftnl_table_set_u8(struct nftnl_table *t, uint16_t attr, uint8_t data);
 void nftnl_table_set_u32(struct nftnl_table *t, uint16_t attr, uint32_t data);
-void nftnl_table_set_str(struct nftnl_table *t, uint16_t attr, const char *str);
+int nftnl_table_set_str(struct nftnl_table *t, uint16_t attr, const char *str);
 uint8_t nftnl_table_get_u8(const struct nftnl_table *t, uint16_t attr);
 uint32_t nftnl_table_get_u32(const struct nftnl_table *t, uint16_t attr);
 const char *nftnl_table_get_str(const struct nftnl_table *t, uint16_t attr);
diff --git a/src/chain.c b/src/chain.c
index 4c487cc..6a2cfae 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -165,8 +165,8 @@ static uint32_t nftnl_chain_validate[NFTNL_CHAIN_MAX + 1] = {
 	[NFTNL_CHAIN_FAMILY]		= sizeof(uint32_t),
 };
 
-void nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
-			     const void *data, uint32_t data_len)
+int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
+			 const void *data, uint32_t data_len)
 {
 	nftnl_assert_attr_exists(attr, NFTNL_CHAIN_MAX);
 	nftnl_assert_validate(data, nftnl_chain_validate, attr, data_len);
@@ -180,6 +180,8 @@ void nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 			xfree(c->table);
 
 		c->table = strdup(data);
+		if (!c->table)
+			return -1;
 		break;
 	case NFTNL_CHAIN_HOOKNUM:
 		memcpy(&c->hooknum, data, sizeof(c->hooknum));
@@ -210,15 +212,20 @@ void nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 			xfree(c->type);
 
 		c->type = strdup(data);
+		if (!c->type)
+			return -1;
 		break;
 	case NFTNL_CHAIN_DEV:
 		if (c->dev)
 			xfree(c->dev);
 
 		c->dev = strdup(data);
+		if (!c->type)
+			return -1;
 		break;
 	}
 	c->flags |= (1 << attr);
+	return 0;
 }
 EXPORT_SYMBOL(nftnl_chain_set_data);
 
@@ -252,9 +259,9 @@ void nftnl_chain_set_u8(struct nftnl_chain *c, uint16_t attr, uint8_t data)
 }
 EXPORT_SYMBOL(nftnl_chain_set_u8);
 
-void nftnl_chain_set_str(struct nftnl_chain *c, uint16_t attr, const char *str)
+int nftnl_chain_set_str(struct nftnl_chain *c, uint16_t attr, const char *str)
 {
-	nftnl_chain_set_data(c, attr, str, strlen(str));
+	return nftnl_chain_set_data(c, attr, str, strlen(str));
 }
 EXPORT_SYMBOL(nftnl_chain_set_str);
 
diff --git a/src/expr.c b/src/expr.c
index aa920dd..40960f8 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -60,18 +60,18 @@ bool nftnl_expr_is_set(const struct nftnl_expr *expr, uint16_t type)
 }
 EXPORT_SYMBOL(nftnl_expr_is_set);
 
-void
-nftnl_expr_set(struct nftnl_expr *expr, uint16_t type,
-		  const void *data, uint32_t data_len)
+int nftnl_expr_set(struct nftnl_expr *expr, uint16_t type,
+		   const void *data, uint32_t data_len)
 {
 	switch(type) {
 	case NFTNL_EXPR_NAME:	/* cannot be modified */
-		return;
+		return 0;
 	default:
 		if (expr->ops->set(expr, type, data, data_len) < 0)
-			return;
+			return -1;
 	}
 	expr->flags |= (1 << type);
+	return 0;
 }
 EXPORT_SYMBOL(nftnl_expr_set);
 
@@ -103,10 +103,9 @@ nftnl_expr_set_u64(struct nftnl_expr *expr, uint16_t type, uint64_t data)
 }
 EXPORT_SYMBOL(nftnl_expr_set_u64);
 
-void
-nftnl_expr_set_str(struct nftnl_expr *expr, uint16_t type, const char *str)
+int nftnl_expr_set_str(struct nftnl_expr *expr, uint16_t type, const char *str)
 {
-	nftnl_expr_set(expr, type, str, strlen(str)+1);
+	return nftnl_expr_set(expr, type, str, strlen(str) + 1);
 }
 EXPORT_SYMBOL(nftnl_expr_set_str);
 
diff --git a/src/gen.c b/src/gen.c
index 698b9b9..d303036 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -64,8 +64,8 @@ static uint32_t nftnl_gen_validate[NFTNL_GEN_MAX + 1] = {
 	[NFTNL_GEN_ID]	= sizeof(uint32_t),
 };
 
-void nftnl_gen_set_data(struct nftnl_gen *gen, uint16_t attr,
-			   const void *data, uint32_t data_len)
+int nftnl_gen_set_data(struct nftnl_gen *gen, uint16_t attr,
+		       const void *data, uint32_t data_len)
 {
 	nftnl_assert_attr_exists(attr, NFTNL_GEN_MAX);
 	nftnl_assert_validate(data, nftnl_gen_validate, attr, data_len);
@@ -76,12 +76,13 @@ void nftnl_gen_set_data(struct nftnl_gen *gen, uint16_t attr,
 		break;
 	}
 	gen->flags |= (1 << attr);
+	return 0;
 }
 EXPORT_SYMBOL(nftnl_gen_set_data);
 
-void nftnl_gen_set(struct nftnl_gen *gen, uint16_t attr, const void *data)
+int nftnl_gen_set(struct nftnl_gen *gen, uint16_t attr, const void *data)
 {
-	nftnl_gen_set_data(gen, attr, data, nftnl_gen_validate[attr]);
+	return nftnl_gen_set_data(gen, attr, data, nftnl_gen_validate[attr]);
 }
 EXPORT_SYMBOL(nftnl_gen_set);
 
diff --git a/src/rule.c b/src/rule.c
index 21d94aa..310332f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -127,8 +127,8 @@ static uint32_t nftnl_rule_validate[NFTNL_RULE_MAX + 1] = {
 	[NFTNL_RULE_POSITION]	= sizeof(uint64_t),
 };
 
-void nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
-			    const void *data, uint32_t data_len)
+int nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
+			const void *data, uint32_t data_len)
 {
 	nftnl_assert_attr_exists(attr, NFTNL_RULE_MAX);
 	nftnl_assert_validate(data, nftnl_rule_validate, attr, data_len);
@@ -139,12 +139,16 @@ void nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
 			xfree(r->table);
 
 		r->table = strdup(data);
+		if (!r->table)
+			return -1;
 		break;
 	case NFTNL_RULE_CHAIN:
 		if (r->chain)
 			xfree(r->chain);
 
 		r->chain = strdup(data);
+		if (!r->chain)
+			return -1;
 		break;
 	case NFTNL_RULE_HANDLE:
 		r->handle = *((uint64_t *)data);
@@ -167,19 +171,20 @@ void nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
 
 		r->user.data = malloc(data_len);
 		if (!r->user.data)
-			return;
+			return -1;
 
 		memcpy(r->user.data, data, data_len);
 		r->user.len = data_len;
 		break;
 	}
 	r->flags |= (1 << attr);
+	return 0;
 }
 EXPORT_SYMBOL(nftnl_rule_set_data);
 
-void nftnl_rule_set(struct nftnl_rule *r, uint16_t attr, const void *data)
+int nftnl_rule_set(struct nftnl_rule *r, uint16_t attr, const void *data)
 {
-	nftnl_rule_set_data(r, attr, data, nftnl_rule_validate[attr]);
+	return nftnl_rule_set_data(r, attr, data, nftnl_rule_validate[attr]);
 }
 EXPORT_SYMBOL(nftnl_rule_set);
 
@@ -195,9 +200,9 @@ void nftnl_rule_set_u64(struct nftnl_rule *r, uint16_t attr, uint64_t val)
 }
 EXPORT_SYMBOL(nftnl_rule_set_u64);
 
-void nftnl_rule_set_str(struct nftnl_rule *r, uint16_t attr, const char *str)
+int nftnl_rule_set_str(struct nftnl_rule *r, uint16_t attr, const char *str)
 {
-	nftnl_rule_set_data(r, attr, str, strlen(str));
+	return nftnl_rule_set_data(r, attr, str, strlen(str));
 }
 EXPORT_SYMBOL(nftnl_rule_set_str);
 
diff --git a/src/set.c b/src/set.c
index bc8c8bc..797c6ca 100644
--- a/src/set.c
+++ b/src/set.c
@@ -113,8 +113,8 @@ static uint32_t nftnl_set_validate[NFTNL_SET_MAX + 1] = {
 	[NFTNL_SET_GC_INTERVAL]	= sizeof(uint32_t),
 };
 
-void nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
-			   uint32_t data_len)
+int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
+		       uint32_t data_len)
 {
 	nftnl_assert_attr_exists(attr, NFTNL_SET_MAX);
 	nftnl_assert_validate(data, nftnl_set_validate, attr, data_len);
@@ -125,12 +125,16 @@ void nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 			xfree(s->table);
 
 		s->table = strdup(data);
+		if (!s->table)
+			return -1;
 		break;
 	case NFTNL_SET_NAME:
 		if (s->name)
 			xfree(s->name);
 
 		s->name = strdup(data);
+		if (!s->name)
+			return -1;
 		break;
 	case NFTNL_SET_FLAGS:
 		s->set_flags = *((uint32_t *)data);
@@ -167,12 +171,13 @@ void nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 		break;
 	}
 	s->flags |= (1 << attr);
+	return 0;
 }
 EXPORT_SYMBOL(nftnl_set_set_data);
 
-void nftnl_set_set(struct nftnl_set *s, uint16_t attr, const void *data)
+int nftnl_set_set(struct nftnl_set *s, uint16_t attr, const void *data)
 {
-	nftnl_set_set_data(s, attr, data, nftnl_set_validate[attr]);
+	return nftnl_set_set_data(s, attr, data, nftnl_set_validate[attr]);
 }
 EXPORT_SYMBOL(nftnl_set_set);
 
@@ -188,9 +193,9 @@ void nftnl_set_set_u64(struct nftnl_set *s, uint16_t attr, uint64_t val)
 }
 EXPORT_SYMBOL(nftnl_set_set_u64);
 
-void nftnl_set_set_str(struct nftnl_set *s, uint16_t attr, const char *str)
+int nftnl_set_set_str(struct nftnl_set *s, uint16_t attr, const char *str)
 {
-	nftnl_set_set(s, attr, str);
+	return nftnl_set_set(s, attr, str);
 }
 EXPORT_SYMBOL(nftnl_set_set_str);
 
diff --git a/src/set_elem.c b/src/set_elem.c
index da30b02..645bca8 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -97,8 +97,8 @@ void nftnl_set_elem_unset(struct nftnl_set_elem *s, uint16_t attr)
 }
 EXPORT_SYMBOL(nftnl_set_elem_unset);
 
-void nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
-			   const void *data, uint32_t data_len)
+int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
+		       const void *data, uint32_t data_len)
 {
 	switch(attr) {
 	case NFTNL_SET_ELEM_FLAGS:
@@ -130,14 +130,13 @@ void nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 
 		s->user.data = malloc(data_len);
 		if (!s->user.data)
-			return;
+			return -1;
 		memcpy(s->user.data, data, data_len);
 		s->user.len = data_len;
 		break;
-	default:
-		return;
 	}
 	s->flags |= (1 << attr);
+	return -1;
 }
 EXPORT_SYMBOL(nftnl_set_elem_set);
 
@@ -153,9 +152,9 @@ void nftnl_set_elem_set_u64(struct nftnl_set_elem *s, uint16_t attr, uint64_t va
 }
 EXPORT_SYMBOL(nftnl_set_elem_set_u64);
 
-void nftnl_set_elem_set_str(struct nftnl_set_elem *s, uint16_t attr, const char *str)
+int nftnl_set_elem_set_str(struct nftnl_set_elem *s, uint16_t attr, const char *str)
 {
-	nftnl_set_elem_set(s, attr, str, strlen(str));
+	return nftnl_set_elem_set(s, attr, str, strlen(str));
 }
 EXPORT_SYMBOL(nftnl_set_elem_set_str);
 
diff --git a/src/table.c b/src/table.c
index 406babf..595b0ac 100644
--- a/src/table.c
+++ b/src/table.c
@@ -84,8 +84,8 @@ static uint32_t nftnl_table_validate[NFTNL_TABLE_MAX + 1] = {
 	[NFTNL_TABLE_FAMILY]	= sizeof(uint32_t),
 };
 
-void nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
-			     const void *data, uint32_t data_len)
+int nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
+			 const void *data, uint32_t data_len)
 {
 	nftnl_assert_attr_exists(attr, NFTNL_TABLE_MAX);
 	nftnl_assert_validate(data, nftnl_table_validate, attr, data_len);
@@ -96,6 +96,8 @@ void nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
 			xfree(t->name);
 
 		t->name = strdup(data);
+		if (!t->name)
+			return -1;
 		break;
 	case NFTNL_TABLE_FLAGS:
 		t->table_flags = *((uint32_t *)data);
@@ -108,6 +110,7 @@ void nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
 		break;
 	}
 	t->flags |= (1 << attr);
+	return 0;
 }
 EXPORT_SYMBOL(nftnl_table_set_data);
 
@@ -129,9 +132,9 @@ void nftnl_table_set_u8(struct nftnl_table *t, uint16_t attr, uint8_t val)
 }
 EXPORT_SYMBOL(nftnl_table_set_u8);
 
-void nftnl_table_set_str(struct nftnl_table *t, uint16_t attr, const char *str)
+int nftnl_table_set_str(struct nftnl_table *t, uint16_t attr, const char *str)
 {
-	nftnl_table_set_data(t, attr, str, 0);
+	return nftnl_table_set_data(t, attr, str, 0);
 }
 EXPORT_SYMBOL(nftnl_table_set_str);
 
-- 
2.1.4

