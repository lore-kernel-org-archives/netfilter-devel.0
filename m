Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3193E3140
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2026 19:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789414150; cv=none; b=Ee1VwZp5EcVT6SpAVM4k0L0+rNsg44PaAgJHRpdZGrwpF+TogxOQ5gDV1quHXuc7AHE/JG0E/OwzH0jV3Cbax+GqaI2D7gTziuJ5VKmsG4ein1qP8o7LZgkc4JRJrltVrOeQRVZUID8gFnpgANaUTYUti+LXgFhAsUwrp6c6Bhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789414150; c=relaxed/simple;
	bh=K7DEGR0dFdz/7b3BQGiRcgeCW+BMS0s1MvGG0KLGr1U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aW0PDwDaffcoBbOhqrW2g1EEBLBsymrwNW8Uqf0XtKgsDyz1VyV+Anj9+NkiQxL4zX1VVATpbjJIuuvrV02ZOZj7wC8z0T8wLYdEURi2cdin4+9diJsDn6cCkdpIG+e61kgwKeJM7CJdaYGx8w1zroolIM4Q+V04CRyrDRTDsV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qM7w6CfG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qM7w6CfG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789414139;
	bh=gQZAxWUQwnBI0an6PO2I2BXS/h8sH+5gN5ozNbgXbkc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qM7w6CfGbl3G9hsT6XN48kY7NVOr2qSjhVrojGKLXjBXgPbgpoZvx0K9vESRTpt2W
	 Gfb97ZprcwFSjm30ewhRKT39AEGBGy2CFNTB12kVv7mVI+UUlJY1K/p1gZHrfvVAnu
	 1uOwkdR1uUbDqxZplz7VG0/jYkb/337qMU5+58Y1knQpW7SdajrGPce45X6sgUKp/C
	 Kxxm0E9ofF7/ia9pseC5Meo9q+1vKEoUjFDY8TAVov4DQySLozbyQcGBFpus389Pd1
	 JzsYDlpp2TIgR5imC2ImOY3BsUtPIqb0oNyQzgla5zRCB3GK2W+QGasm/Zv4yNqnwS
	 geoU9gcrKcK3w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2944E6005D
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2026 21:28:59 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] remove EXPR_SET_ELEM, replace it by struct set_elem
Date: Mon, 14 Sep 2026 21:28:54 +0200
Message-ID: <20260914192854.2052448-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914192854.2052448-1-pablo@netfilter.org>
References: <20260914192854.2052448-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

QUICK HACK to see how it looks, very broken

replace:

expr_set(init)->expressions

by

expr_set(init)->nelems

git grep expr_set.*expressions

BROKEN; but works for initial simple sets to collect numbers.

- json parser
- dynset / meter statements (peel off EXPR_SET_ELEM).
- expr_value(...) and i->key->... preparation work

Further => remove EXPR_MAPPING and place two pointers in struct
set_elem for key and data (it saves one struct expr per mapping).
Make variable length struct set_elem.
---
 Makefile.am                                   |   2 +
 include/elem.h                                |  32 +++
 include/expression.h                          |  22 +-
 include/intervals.h                           |   4 +-
 include/netlink.h                             |   2 +-
 include/nftables.h                            |   1 +
 include/rule.h                                |   2 +-
 include/statement.h                           |   8 +-
 src/cmd.c                                     |   4 +-
 src/elem.c                                    | 133 ++++++++++
 src/evaluate.c                                | 154 ++++++-----
 src/expression.c                              | 166 ++----------
 src/intervals.c                               | 244 +++++++-----------
 src/json.c                                    |  65 +++--
 src/mergesort.c                               |  14 +-
 src/mnl.c                                     |  32 +--
 src/monitor.c                                 |  12 +-
 src/netlink.c                                 |  69 +++--
 src/netlink_delinearize.c                     |  57 ++--
 src/netlink_linearize.c                       |  14 +-
 src/optimize.c                                |  55 ++--
 src/parser_bison.y                            |  86 +++---
 src/parser_json.c                             | 206 ++++++++++-----
 src/payload.c                                 |  14 +-
 src/segtree.c                                 | 223 +++++++---------
 src/statement.c                               |  16 +-
 tests/shell/testcases/sets/0038meter_list_0   |   2 +-
 .../testcases/sets/dumps/0038meter_list_0.nft |   2 +-
 28 files changed, 825 insertions(+), 816 deletions(-)
 create mode 100644 include/elem.h
 create mode 100644 src/elem.c

diff --git a/Makefile.am b/Makefile.am
index 5778dd29828e..9dcd5472755e 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -73,6 +73,7 @@ noinst_HEADERS = \
 	include/ct.h \
 	include/datatype.h \
 	include/dccpopt.h \
+	include/elem.h \
 	include/erec.h \
 	include/expression.h \
 	include/exthdr.h \
@@ -223,6 +224,7 @@ src_libnftables_la_SOURCES = \
 	src/ct.c \
 	src/datatype.c \
 	src/dccpopt.c \
+	src/elem.c \
 	src/erec.c \
 	src/evaluate.c \
 	src/expression.c \
diff --git a/include/elem.h b/include/elem.h
new file mode 100644
index 000000000000..542195b04c1e
--- /dev/null
+++ b/include/elem.h
@@ -0,0 +1,32 @@
+#ifndef NFTABLES_SET_ELEM_H
+#define NFTABLES_SET_ELEM_H
+
+#include <list.h>
+#include <stdint.h>
+
+struct expr;
+
+struct set_elem {
+	struct list_head	list;
+	struct expr		*key;
+	uint64_t		timeout;
+	uint64_t		expiration;
+	const char		*comment;
+	struct list_head	stmt_list;
+};
+
+struct set_elem *set_elem_alloc(struct expr *key);
+struct set_elem *set_elem_clone(struct set_elem *orig);
+void set_elem_copy(struct set_elem *dst, const struct set_elem *src);
+void set_elem_free(const struct set_elem *set_elem);
+
+struct output_ctx;
+void set_elem_print(const struct set_elem *elem,
+		    struct output_ctx *octx);
+
+void set_elem_add(struct expr *set, struct set_elem *elem);
+
+void list_elems_sort(struct list_head *head);
+void list_splice_sorted(struct list_head *list, struct list_head *head);
+
+#endif
diff --git a/include/expression.h b/include/expression.h
index e6a05603552b..4dcb2cbb9f2f 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -35,7 +35,6 @@
  * @EXPR_LIST:		list of expressions
  * @EXPR_SET:		literal set
  * @EXPR_SET_REF:	set reference
- * @EXPR_SET_ELEM:	set element
  * @EXPR_MAPPING:	a single mapping (key : value)
  * @EXPR_MAP:		map operation (expr map { EXPR_MAPPING, ... })
  * @EXPR_UNARY:		byteorder conversion, generated during evaluation
@@ -68,7 +67,6 @@ enum expr_types {
 	EXPR_LIST,
 	EXPR_SET,
 	EXPR_SET_REF,
-	EXPR_SET_ELEM,
 	EXPR_MAPPING,
 	EXPR_MAP,
 	EXPR_UNARY,
@@ -304,7 +302,7 @@ struct expr {
 		} expr_concat;
 		struct expr_set {
 			/* EXPR_SET */
-			struct list_head	expressions;
+			struct list_head	elems;
 			unsigned int		size;
 			uint32_t		set_flags;
 		} expr_set;
@@ -317,14 +315,6 @@ struct expr {
 			/* EXPR_SET_REF */
 			struct set		*set;
 		};
-		struct {
-			/* EXPR_SET_ELEM */
-			struct expr		*key;
-			uint64_t		timeout;
-			uint64_t		expiration;
-			const char		*comment;
-			struct list_head	stmt_list;
-		};
 		struct {
 			/* EXPR_UNARY */
 			struct expr		*arg;
@@ -523,9 +513,6 @@ extern struct expr *range_expr_alloc(const struct location *loc,
 				     struct expr *low, struct expr *high);
 struct expr *range_expr_to_prefix(struct expr *range);
 
-extern void list_expr_sort(struct list_head *head);
-extern void list_splice_sorted(struct list_head *list, struct list_head *head);
-
 extern struct expr *concat_expr_alloc(const struct location *loc);
 void concat_expr_add(struct expr *concat, struct expr *item);
 void concat_expr_remove(struct expr *concat, struct expr *expr);
@@ -537,8 +524,8 @@ struct expr *list_expr_to_binop(struct expr *expr);
 
 extern struct expr *set_expr_alloc(const struct location *loc,
 				   const struct set *set);
-void set_expr_add(struct expr *set, struct expr *elem);
-void set_expr_remove(struct expr *expr, struct expr *item);
+void set_expr_add(struct expr *set, struct set_elem *elem);
+void set_expr_remove(struct expr *expr, struct set_elem *item);
 
 extern void concat_range_aggregate(struct expr *set);
 extern void interval_map_decompose(struct expr *set);
@@ -556,9 +543,6 @@ extern struct expr *map_expr_alloc(const struct location *loc,
 extern struct expr *set_ref_expr_alloc(const struct location *loc,
 				       struct set *set);
 
-extern struct expr *set_elem_expr_alloc(const struct location *loc,
-					struct expr *key);
-
 struct expr *set_elem_catchall_expr_alloc(const struct location *loc);
 
 #define expr_type_catchall(__expr)			\
diff --git a/include/intervals.h b/include/intervals.h
index 2366c295ca08..514b2dd56890 100644
--- a/include/intervals.h
+++ b/include/intervals.h
@@ -7,7 +7,7 @@ int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
 	       struct expr *init, unsigned int debug_mask);
 int set_overlap(struct list_head *msgs, struct set *set, struct expr *init);
 int set_to_intervals(const struct set *set, struct expr *init, bool add);
-int setelem_to_interval(const struct set *set, struct expr *elem,
-			struct expr *next_elem, struct list_head *interval_list);
+int setelem_to_interval(const struct set *set, struct set_elem *elem,
+			struct set_elem *next_elem, struct list_head *interval_list);
 
 #endif
diff --git a/include/netlink.h b/include/netlink.h
index aa25094dc7c1..6400d9ca077b 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -91,7 +91,7 @@ struct netlink_ctx {
 extern struct nftnl_expr *alloc_nft_expr(const char *name);
 extern void alloc_setelem_cache(const struct expr *set, struct nftnl_set *nls);
 struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
-					   const struct expr *expr);
+					   const struct set_elem *elem);
 
 extern struct nftnl_table *netlink_table_alloc(const struct nlmsghdr *nlh);
 extern struct nftnl_chain *netlink_chain_alloc(const struct nlmsghdr *nlh);
diff --git a/include/nftables.h b/include/nftables.h
index 538150126816..d75232feec9f 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -5,6 +5,7 @@
 #include <limits.h>
 #include <utils.h>
 #include <cache.h>
+#include <elem.h>
 #include <nftables/libnftables.h>
 
 struct cookie {
diff --git a/include/rule.h b/include/rule.h
index 7b7b7eb1012d..9460e7dddeb1 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -354,7 +354,7 @@ struct set {
 	uint32_t		objtype;
 	struct set		*existing_set;
 	struct expr		*init;
-	struct expr		*rg_cache;
+	struct set_elem		*rg_cache;
 	uint32_t		policy;
 	struct list_head	stmt_list;
 	bool			root;
diff --git a/include/statement.h b/include/statement.h
index e8724dde63d0..475bb1b9575c 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -214,7 +214,7 @@ uint32_t fwd_stmt_type(const char *type);
 
 struct set_stmt {
 	struct expr		*set;
-	struct expr		*key;
+	struct set_elem		*key;
 	struct list_head	stmt_list;
 	enum nft_dynset_ops	op;
 };
@@ -225,8 +225,8 @@ extern struct stmt *set_stmt_alloc(const struct location *loc);
 
 struct map_stmt {
 	struct expr		*set;
-	struct expr		*key;
-	struct expr		*data;
+	struct set_elem		*key;
+	struct set_elem		*data;
 	struct list_head	stmt_list;
 	enum nft_dynset_ops	op;
 };
@@ -243,7 +243,7 @@ extern struct stmt *synproxy_stmt_alloc(const struct location *loc);
 
 struct meter_stmt {
 	struct expr		*set;
-	struct expr		*key;
+	struct set_elem		*elem;
 	struct stmt		*stmt;
 	const char		*name;
 	uint32_t		size;
diff --git a/src/cmd.c b/src/cmd.c
index 9d5544f03c32..76bc06c0636c 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -401,8 +401,8 @@ bool nft_cmd_collapse_elems(enum cmd_ops op, struct list_head *cmds,
 	    strcmp(last_cmd->handle.set.name, handle->set.name))
 		return false;
 
-	list_splice_tail_init(&expr_set(init)->expressions,
-			      &expr_set(last_cmd->expr)->expressions);
+	list_splice_tail_init(&expr_set(init)->elems,
+			      &expr_set(last_cmd->expr)->elems);
 	expr_set(last_cmd->expr)->size += expr_set(init)->size;
 
 	return true;
diff --git a/src/elem.c b/src/elem.c
new file mode 100644
index 000000000000..cfc5f00d5b2d
--- /dev/null
+++ b/src/elem.c
@@ -0,0 +1,133 @@
+/*
+ * Copyright (c) 2013-2026 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
+ */
+
+#include <nft.h>
+#include <utils.h>
+#include <elem.h>
+#include <expression.h>
+
+struct set_elem *set_elem_alloc(struct expr *key)
+{
+	struct set_elem *set_elem;
+
+	set_elem = xzalloc(sizeof(*set_elem));
+	set_elem->key = key;
+	init_list_head(&set_elem->stmt_list);
+
+	return set_elem;
+}
+
+/* This only works for the supported stateful statements. */
+static void set_elem_stmt_clone(struct set_elem *dst, const struct set_elem *src)
+{
+	struct stmt *stmt, *nstmt;
+
+	list_for_each_entry(stmt, &src->stmt_list, list) {
+		nstmt = xzalloc(sizeof(*stmt));
+		*nstmt = *stmt;
+		list_add_tail(&nstmt->list, &dst->stmt_list);
+	}
+}
+
+void set_elem_copy(struct set_elem *dst, const struct set_elem *src)
+{
+        if (src->comment)
+                dst->comment = xstrdup(src->comment);
+        if (src->timeout)
+                dst->timeout = src->timeout;
+        if (src->expiration)
+                dst->expiration = src->expiration;
+
+        set_elem_stmt_clone(dst, src);
+}
+
+static void __set_elem_clone(struct set_elem *new, const struct set_elem *orig)
+{
+	new->expiration = orig->expiration;
+	new->timeout = orig->timeout;
+	if (orig->comment)
+		new->comment = xstrdup(orig->comment);
+
+	init_list_head(&new->stmt_list);
+	set_elem_stmt_clone(new, orig);
+}
+
+struct set_elem *set_elem_clone(struct set_elem *orig)
+{
+	struct set_elem *set_elem;
+	struct expr *expr;
+
+	expr = expr_clone(orig->key);
+	set_elem = set_elem_alloc(expr);
+	__set_elem_clone(set_elem, orig);
+
+	return set_elem;
+}
+
+void set_elem_free(const struct set_elem *elem)
+{
+	struct stmt *stmt, *next;
+
+	list_for_each_entry_safe(stmt, next, &elem->stmt_list, list) {
+		list_del(&stmt->list);
+		stmt_free(stmt);
+	}
+	free_const(elem->comment);
+	expr_free(elem->key);
+	free_const(elem);
+}
+
+void set_elem_print(const struct set_elem *elem, struct output_ctx *octx)
+{
+	struct stmt *stmt;
+
+	/* The mapping output needs to print lhs first, then timeout, expires,
+	 * comment and list of statements and finally rhs.
+	 *
+	 * Because struct set_elem always comes before EXPR_MAPPING, add this
+	 * special handling to print the output accordingly.
+	 */
+	if (elem->key->etype == EXPR_MAPPING)
+		expr_print(elem->key->left, octx);
+	else
+		expr_print(elem->key, octx);
+
+	list_for_each_entry(stmt, &elem->stmt_list, list) {
+		nft_print(octx, " ");
+		stmt_print(stmt, octx);
+	}
+
+	if (elem->timeout) {
+		nft_print(octx, " timeout ");
+		if (elem->timeout == NFT_NEVER_TIMEOUT)
+			nft_print(octx, "never");
+		else
+			time_print(elem->timeout, octx);
+	}
+	if (!nft_output_stateless(octx) &&
+	    elem->timeout != NFT_NEVER_TIMEOUT &&
+	    elem->expiration) {
+		nft_print(octx, " expires ");
+		time_print(elem->expiration, octx);
+	}
+	if (elem->comment)
+		nft_print(octx, " comment \"%s\"", elem->comment);
+
+	if (elem->key->etype == EXPR_MAPPING) {
+		nft_print(octx, " : ");
+		expr_print(elem->key->right, octx);
+	}
+}
+
+void set_elem_add(struct expr *set, struct set_elem *elem)
+{
+	struct expr_set *expr_set = expr_set(set);
+
+	list_add_tail(&elem->list, &expr_set->elems);
+	expr_set->size++;
+}
diff --git a/src/evaluate.c b/src/evaluate.c
index 4f5f2694e7ed..539228336fa9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1747,7 +1747,6 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 		case EXPR_META:
 		case EXPR_RT:
 		case EXPR_CT:
-		case EXPR_SET_ELEM:
 		case EXPR_NUMGEN:
 		case EXPR_HASH:
 		case EXPR_FIB:
@@ -1887,7 +1886,7 @@ static int expr_evaluate_list(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
-static int __expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr *elem)
+static int __evaluate_set_elem(struct eval_ctx *ctx, struct set_elem *elem)
 {
 	int num_elem_exprs = 0, num_set_exprs = 0;
 	struct set *set = ctx->set;
@@ -1955,13 +1954,12 @@ static bool elem_key_compatible(const struct expr *set_key,
 	return datatype_compatible(set_key->dtype, elem_key->dtype);
 }
 
-static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
+static int evaluate_set_elem(struct eval_ctx *ctx, struct set_elem *elem)
 {
-	struct expr *elem = *expr;
 	const struct expr *key;
 
 	if (ctx->set) {
-		if (__expr_evaluate_set_elem(ctx, elem) < 0)
+		if (__evaluate_set_elem(ctx, elem) < 0)
 			return -1;
 
 		key = ctx->set->key;
@@ -2003,9 +2001,6 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 				  set_is_map(ctx->set->flags) ? "map" : "set",
 				  ctx->set->key->dtype->desc, elem->key->dtype->desc);
 
-	datatype_set(elem, elem->key->dtype);
-	elem->len   = elem->key->len;
-
 	return 0;
 
 err_missing_flag:
@@ -2014,6 +2009,22 @@ err_missing_flag:
 			  set_is_map(ctx->set->flags) ? "map" : "set", expr_name(key));
 }
 
+static int set_elem_list_member_evaluate(struct eval_ctx *ctx, struct set_elem *elem)
+{
+	int err;
+
+	/* should never be hit in practice */
+	if (ctx->recursion.list >= USHRT_MAX)
+		return expr_binary_error(ctx->msgs, elem->key, NULL,
+					 "List limit %u reached ",
+					 ctx->recursion.list);
+
+	ctx->recursion.list++;
+	err = evaluate_set_elem(ctx, elem);
+	ctx->recursion.list--;
+	return err;
+}
+
 static int expr_evaluate_set_elem_catchall(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *elem = *expr;
@@ -2071,30 +2082,28 @@ static void expr_evaluate_set_ref(struct eval_ctx *ctx, struct expr *expr)
 
 static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 {
-	struct expr *set = *expr, *i, *next;
-
-	list_for_each_entry_safe(i, next, &expr_set(set)->expressions, list) {
-		assert(i->etype == EXPR_SET_ELEM);
+	struct set_elem *i, *next;
+	struct expr *set = *expr;
 
-		if (list_member_evaluate(ctx, &i) < 0)
+	list_for_each_entry_safe(i, next, &expr_set(set)->elems, list) {
+		if (set_elem_list_member_evaluate(ctx, i) < 0)
 			return -1;
 
 		if (i->key->etype == EXPR_MAPPING &&
 		    i->key->left->etype == EXPR_SET) {
-			struct expr *new, *j;
-
-			list_for_each_entry(j, &expr_set(i->key->left)->expressions, list) {
-				assert(j->etype == EXPR_SET_ELEM);
+			struct set_elem *j, *elem;
+			struct expr *new;
 
-				new = mapping_expr_alloc(&i->location,
+			list_for_each_entry(j, &expr_set(i->key->left)->elems, list) {
+				new = mapping_expr_alloc(&i->key->location,
 							 expr_get(j->key),
 							 expr_get(i->key->right));
-				new = set_elem_expr_alloc(&i->location, new);
-				list_add_tail(&new->list, &expr_set(set)->expressions);
+				elem = set_elem_alloc(new);
+				list_add_tail(&elem->list, &expr_set(set)->elems);
 				expr_set(set)->size++;
 			}
 			list_del(&i->list);
-			expr_free(i);
+			set_elem_free(i);
 			continue;
 		}
 
@@ -2108,11 +2117,11 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 
 		if (i->key->etype == EXPR_SET) {
 			/* Merge recursive set definitions */
-			list_splice_tail_init(&expr_set(i->key)->expressions, &i->list);
+			list_splice_tail_init(&expr_set(i->key)->elems, &i->list);
 			list_del(&i->list);
 			expr_set(set)->size      += expr_set(i->key)->size - 1;
 			expr_set(set)->set_flags |= expr_set(i->key)->set_flags;
-			expr_free(i);
+			set_elem_free(i);
 		} else if (!expr_is_singleton(i->key)) {
 			expr_set(set)->set_flags |= NFT_SET_INTERVAL;
 			if ((i->key->etype == EXPR_MAPPING &&
@@ -2182,17 +2191,15 @@ static void __mapping_expr_expand(struct expr *i)
 
 static int mapping_expr_expand(struct eval_ctx *ctx)
 {
-	struct expr *i;
+	struct set_elem *i;
 
 	if (!set_is_anonymous(ctx->set->flags))
 		return 0;
 
-	list_for_each_entry(i, &expr_set(ctx->set->init)->expressions, list) {
-		assert(i->etype == EXPR_SET_ELEM);
-
+	list_for_each_entry(i, &expr_set(ctx->set->init)->elems, list) {
 		if (i->key->etype != EXPR_MAPPING)
-			return expr_error(ctx->msgs, i,
-					  "expected mapping, not %s", expr_name(i));
+			return expr_error(ctx->msgs, i->key,
+					  "expected mapping, not %s", expr_name(i->key));
 		__mapping_expr_expand(i->key);
 	}
 
@@ -2571,8 +2578,6 @@ static int binop_can_transfer(struct eval_ctx *ctx,
 	switch (right->etype) {
 	case EXPR_VALUE:
 		break;
-	case EXPR_SET_ELEM:
-		return binop_can_transfer(ctx, left, right->key);
 	case EXPR_RANGE:
 		err = binop_can_transfer(ctx, left, right->left);
 		if (err <= 0)
@@ -2615,8 +2620,6 @@ static int binop_transfer_one(struct eval_ctx *ctx,
 		return binop_transfer_one(ctx, left, &(*right)->left);
 	case EXPR_VALUE:
 		break;
-	case EXPR_SET_ELEM:
-		return binop_transfer_one(ctx, left, &(*right)->key);
 	case EXPR_RANGE:
 		err = binop_transfer_one(ctx, left, &(*right)->left);
 		if (err < 0)
@@ -2676,7 +2679,7 @@ static void binop_transfer_handle_lhs(struct expr **expr)
 static int __binop_transfer(struct eval_ctx *ctx,
 			    struct expr *left, struct expr **right)
 {
-	struct expr *i, *next;
+	struct set_elem *i, *next;
 	int err;
 
 	assert(left->etype == EXPR_BINOP);
@@ -2697,19 +2700,13 @@ static int __binop_transfer(struct eval_ctx *ctx,
 			return -1;
 		break;
 	case EXPR_SET:
-		list_for_each_entry(i, &expr_set(*right)->expressions, list) {
-			assert(i->etype == EXPR_SET_ELEM);
-
-			err = binop_can_transfer(ctx, left, i);
+		list_for_each_entry(i, &expr_set(*right)->elems, list) {
+			err = binop_can_transfer(ctx, left, i->key);
 			if (err <= 0)
 				return err;
 		}
-		list_for_each_entry_safe(i, next, &expr_set(*right)->expressions, list) {
-			assert(i->etype == EXPR_SET_ELEM);
-
-			list_del(&i->list);
-			err = binop_transfer_one(ctx, left, &i);
-			list_add_tail(&i->list, &next->list);
+		list_for_each_entry_safe(i, next, &expr_set(*right)->elems, list) {
+			err = binop_transfer_one(ctx, left, &i->key);
 			if (err < 0)
 				return err;
 		}
@@ -2770,10 +2767,10 @@ static bool range_needs_swap(const struct expr *range)
 
 static void optimize_singleton_set(struct expr *rel, struct expr **expr)
 {
-	struct expr *set = rel->right, *i;
+	struct expr *set = rel->right;
+	struct set_elem *i;
 
-	i = list_first_entry(&expr_set(set)->expressions, struct expr, list);
-	assert (i->etype == EXPR_SET_ELEM);
+	i = list_first_entry(&expr_set(set)->elems, struct set_elem, list);
 
 	if (list_empty(&i->stmt_list)) {
 		switch (i->key->etype) {
@@ -3214,8 +3211,6 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		return expr_evaluate_list(ctx, expr);
 	case EXPR_SET:
 		return expr_evaluate_set(ctx, expr);
-	case EXPR_SET_ELEM:
-		return expr_evaluate_set_elem(ctx, expr);
 	case EXPR_MAP:
 		return expr_evaluate_map(ctx, expr);
 	case EXPR_MAPPING:
@@ -3232,6 +3227,8 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		return expr_evaluate_set_elem_catchall(ctx, expr);
 	case EXPR_RANGE_SYMBOL:
 		return expr_evaluate_symbol_range(ctx, expr);
+	case EXPR_RANGE_VALUE:
+		return 0;
 	default:
 		BUG("unknown expression type %s", expr_name(*expr));
 	}
@@ -3677,30 +3674,30 @@ static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
 				 family2str(existing_set->handle.family));
 
 	expr_set_context(&ctx->ectx, NULL, 0);
-	if (expr_evaluate(ctx, &stmt->meter.key) < 0)
+	if (evaluate_set_elem(ctx, stmt->meter.elem) < 0)
 		return -1;
-	if (expr_is_constant(stmt->meter.key->key))
-		return expr_error(ctx->msgs, stmt->meter.key->key,
+	if (expr_is_constant(stmt->meter.elem->key))
+		return expr_error(ctx->msgs, stmt->meter.elem->key,
 				  "Meter key expression can not be constant");
-	if (stmt->meter.key->comment)
-		return expr_error(ctx->msgs, stmt->meter.key->key,
+	if (stmt->meter.elem->comment)
+		return expr_error(ctx->msgs, stmt->meter.elem->key,
 				  "Meter key expression can not contain comments");
 
 	/* Declare an empty set */
-	key = stmt->meter.key;
+	key = stmt->meter.elem->key;
 	if (existing_set) {
-		if ((existing_set->flags & NFT_SET_TIMEOUT) && !key->timeout)
-			return expr_error(ctx->msgs, stmt->meter.key->key,
+		if ((existing_set->flags & NFT_SET_TIMEOUT) && !stmt->meter.elem->timeout)
+			return expr_error(ctx->msgs, stmt->meter.elem->key,
 					  "existing set '%s' has timeout flag",
 					  stmt->meter.name);
 
-		if ((existing_set->flags & NFT_SET_TIMEOUT) == 0 && key->timeout)
-			return expr_error(ctx->msgs, stmt->meter.key->key,
+		if ((existing_set->flags & NFT_SET_TIMEOUT) == 0 && stmt->meter.elem->timeout)
+			return expr_error(ctx->msgs, stmt->meter.elem->key,
 					  "existing set '%s' lacks timeout flag",
 					  stmt->meter.name);
 
 		if (stmt->meter.size > 0 && existing_set->desc.size != stmt->meter.size)
-			return expr_error(ctx->msgs, stmt->meter.key->key,
+			return expr_error(ctx->msgs, stmt->meter.elem->key,
 					  "existing set '%s' has size %u, meter has %u",
 					  stmt->meter.name, existing_set->desc.size,
 					  stmt->meter.size);
@@ -3709,7 +3706,7 @@ static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
 		struct expr *set;
 
 		set = set_expr_alloc(&key->location, existing_set);
-		if (key->timeout)
+		if (stmt->meter.elem->timeout)
 			expr_set(set)->set_flags |= NFT_SET_TIMEOUT;
 
 		expr_set(set)->set_flags |= NFT_SET_EVAL;
@@ -4467,16 +4464,14 @@ out:
 
 static bool nat_concat_map(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	struct expr *i;
+	struct set_elem *i;
 
 	if (stmt->nat.addr->etype != EXPR_MAP)
 		return false;
 
 	switch (stmt->nat.addr->mappings->etype) {
 	case EXPR_SET:
-		list_for_each_entry(i, &expr_set(stmt->nat.addr->mappings)->expressions, list) {
-			assert(i->etype == EXPR_SET_ELEM);
-
+		list_for_each_entry(i, &expr_set(stmt->nat.addr->mappings)->elems, list) {
 			if (i->key->etype == EXPR_MAPPING &&
 			    i->key->right->etype == EXPR_CONCAT) {
 				stmt->nat.type_flags |= STMT_NAT_F_CONCAT;
@@ -4905,10 +4900,10 @@ static int stmt_evaluate_map(struct eval_ctx *ctx, struct stmt *stmt)
 			      &stmt->map.data->key) < 0)
 		return -1;
 	if (stmt->map.data->comment != NULL)
-		return expr_error(ctx->msgs, stmt->map.data,
+		return expr_error(ctx->msgs, stmt->map.data->key,
 				  "Data expression comments are not supported");
 	if (stmt->map.data->timeout > 0)
-		return expr_error(ctx->msgs, stmt->map.data,
+		return expr_error(ctx->msgs, stmt->map.data->key,
 				  "Data expression timeouts are not supported");
 
 	list_for_each_entry(this, &stmt->map.stmt_list, list) {
@@ -5308,18 +5303,17 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	}
 
 	if (set_is_anonymous(set->flags) && set->key->etype == EXPR_CONCAT) {
-		struct expr *i, *key;
-
-		list_for_each_entry(i, &expr_set(set->init)->expressions, list) {
-			assert (i->etype == EXPR_SET_ELEM);
+		const struct expr *key;
+		struct set_elem *i;
 
+		list_for_each_entry(i, &expr_set(set->init)->elems, list) {
 			key = i->key;
 			if (key->etype == EXPR_MAPPING)
 				key = key->left;
 
 			if (key->etype != EXPR_CONCAT &&
 			    key->etype != EXPR_SET_ELEM_CATCHALL)
-				return expr_error(ctx->msgs, i, "expression is not a concatenation");
+				return expr_error(ctx->msgs, key, "expression is not a concatenation");
 		}
 	}
 
@@ -5466,18 +5460,16 @@ static bool evaluate_expr_variable(struct eval_ctx *ctx, struct expr **exprp)
 
 static struct expr *expr_set_to_list(struct eval_ctx *ctx, struct expr *dev_expr)
 {
-	struct expr *expr, *next, *key;
+	struct set_elem *i, *next;
+	struct expr *key;
 	struct location loc;
 	LIST_HEAD(tmp);
 
-	list_for_each_entry_safe(expr, next, &expr_set(dev_expr)->expressions, list) {
-		assert(expr->etype == EXPR_SET_ELEM);
-
-		list_del(&expr->list);
-		key = expr_clone(expr->key);
-		expr_free(expr);
-		expr = key;
-		list_add(&expr->list, &tmp);
+	list_for_each_entry_safe(i, next, &expr_set(dev_expr)->elems, list) {
+		list_del(&i->list);
+		key = expr_clone(i->key);
+		set_elem_free(i);
+		list_add(&key->list, &tmp);
 	}
 
 	loc = dev_expr->location;
diff --git a/src/expression.c b/src/expression.c
index bf60aa3ce42a..fbc246c741be 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -934,7 +934,7 @@ void relational_expr_pctx_update(struct proto_ctx *ctx,
 {
 	const struct expr *left = expr->left, *right = expr->right;
 	const struct expr_ops *ops;
-	const struct expr *i;
+	const struct set_elem *i;
 
 	assert(expr->etype == EXPR_RELATIONAL);
 	assert(expr->op == OP_EQ || expr->op == OP_IMPLICIT);
@@ -945,9 +945,7 @@ void relational_expr_pctx_update(struct proto_ctx *ctx,
 		if (expr_is_singleton(right))
 			ops->pctx_update(ctx, &expr->location, left, right);
 		else if (right->etype == EXPR_SET) {
-			list_for_each_entry(i, &expr_set(right)->expressions, list) {
-				assert(i->etype == EXPR_SET_ELEM);
-
+			list_for_each_entry(i, &expr_set(right)->elems, list) {
 				if (i->key->etype == EXPR_VALUE)
 					ops->pctx_update(ctx, &expr->location, left, i->key);
 			}
@@ -1378,17 +1376,15 @@ static const char *calculate_delim(const struct expr *expr, int *count,
 
 static void set_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	const struct expr *i;
+	const struct set_elem *i;
 	const char *d = "";
 	int count = 0;
 
 	nft_print(octx, "{ ");
 
-	list_for_each_entry(i, &expr_set(expr)->expressions, list) {
-		assert(i->etype == EXPR_SET_ELEM);
-
+	list_for_each_entry(i, &expr_set(expr)->elems, list) {
 		nft_print(octx, "%s", d);
-		expr_print(i, octx);
+		set_elem_print(i, octx);
 		count++;
 		d = calculate_delim(expr, &count, octx);
 	}
@@ -1398,34 +1394,29 @@ static void set_expr_print(const struct expr *expr, struct output_ctx *octx)
 
 static void set_expr_clone(struct expr *new, const struct expr *expr)
 {
-	struct expr *i;
+	struct set_elem *i;
 
-	init_list_head(&expr_set(new)->expressions);
-	list_for_each_entry(i, &expr_set(expr)->expressions, list)
-		set_expr_add(new, expr_clone(i));
+	init_list_head(&expr_set(new)->elems);
+	list_for_each_entry(i, &expr_set(expr)->elems, list)
+		set_elem_add(new, set_elem_clone(i));
 }
 
 static void set_expr_destroy(struct expr *expr)
 {
-	struct expr *i, *next;
+	struct set_elem *i, *next;
 
-	list_for_each_entry_safe(i, next, &expr_set(expr)->expressions, list) {
-		assert(i->etype == EXPR_SET_ELEM);
-		expr_free(i);
-	}
+	list_for_each_entry_safe(i, next, &expr_set(expr)->elems, list)
+		set_elem_free(i);
 }
 
 static void set_expr_set_type(const struct expr *expr,
 			      const struct datatype *dtype,
 			      enum byteorder byteorder)
 {
-	struct expr *i;
+	struct set_elem *i;
 
-	list_for_each_entry(i, &expr_set(expr)->expressions, list) {
-		assert(i->etype == EXPR_SET_ELEM);
-
-		expr_set_type(i, dtype, byteorder);
-	}
+	list_for_each_entry(i, &expr_set(expr)->elems, list)
+		expr_set_type(i->key, dtype, byteorder);
 }
 
 static const struct expr_ops set_expr_ops = {
@@ -1443,7 +1434,7 @@ struct expr *set_expr_alloc(const struct location *loc, const struct set *set)
 	struct expr *set_expr;
 
 	set_expr = expr_alloc(loc, EXPR_SET, &invalid_type, BYTEORDER_INVALID, 0);
-	init_list_head(&expr_set(set_expr)->expressions);
+	init_list_head(&expr_set(set_expr)->elems);
 
 	if (!set)
 		return set_expr;
@@ -1454,22 +1445,18 @@ struct expr *set_expr_alloc(const struct location *loc, const struct set *set)
 	return set_expr;
 }
 
-void set_expr_add(struct expr *set, struct expr *elem)
+void set_expr_add(struct expr *set, struct set_elem *elem)
 {
 	struct expr_set *expr_set = expr_set(set);
 
-	assert(elem->etype == EXPR_SET_ELEM);
-
-	list_add_tail(&elem->list, &expr_set->expressions);
+	list_add_tail(&elem->list, &expr_set->elems);
 	expr_set->size++;
 }
 
-void set_expr_remove(struct expr *set, struct expr *expr)
+void set_expr_remove(struct expr *set, struct set_elem *elem)
 {
-	assert(expr->etype == EXPR_SET_ELEM);
-
 	expr_set(set)->size--;
-	list_del(&expr->list);
+	list_del(&elem->list);
 }
 
 static void mapping_expr_print(const struct expr *expr, struct output_ctx *octx)
@@ -1522,14 +1509,12 @@ struct expr *mapping_expr_alloc(const struct location *loc,
 
 static bool __set_expr_is_vmap(const struct expr *mappings)
 {
-	const struct expr *elem;
+	const struct set_elem *elem;
 
-	if (list_empty(&expr_set(mappings)->expressions))
+	if (list_empty(&expr_set(mappings)->elems))
 		return false;
 
-	elem = list_first_entry(&expr_set(mappings)->expressions, struct expr, list);
-	assert(elem->etype == EXPR_SET_ELEM);
-
+	elem = list_first_entry(&expr_set(mappings)->elems, struct set_elem, list);
 	if (elem->key->etype == EXPR_MAPPING &&
 	    elem->key->right->etype == EXPR_VERDICT)
 		return true;
@@ -1657,102 +1642,9 @@ struct expr *set_ref_expr_alloc(const struct location *loc, struct set *set)
 	return expr;
 }
 
-static void set_elem_expr_print(const struct expr *expr,
-				 struct output_ctx *octx)
+static void set_elem_catchall_expr_clone(struct expr *new,
+					 const struct expr *expr)
 {
-	struct stmt *stmt;
-
-	/* The mapping output needs to print lhs first, then timeout, expires,
-	 * comment and list of statements and finally rhs.
-	 *
-	 * Because EXPR_SET_ELEM always comes before EXPR_MAPPING, add this
-	 * special handling to print the output accordingly.
-	 */
-	if (expr->key->etype == EXPR_MAPPING)
-		expr_print(expr->key->left, octx);
-	else
-		expr_print(expr->key, octx);
-
-	list_for_each_entry(stmt, &expr->stmt_list, list) {
-		nft_print(octx, " ");
-		stmt_print(stmt, octx);
-	}
-	if (expr->timeout) {
-		nft_print(octx, " timeout ");
-		if (expr->timeout == NFT_NEVER_TIMEOUT)
-			nft_print(octx, "never");
-		else
-			time_print(expr->timeout, octx);
-	}
-	if (!nft_output_stateless(octx) &&
-	    expr->timeout != NFT_NEVER_TIMEOUT &&
-	    expr->expiration) {
-		nft_print(octx, " expires ");
-		time_print(expr->expiration, octx);
-	}
-	if (expr->comment)
-		nft_print(octx, " comment \"%s\"", expr->comment);
-
-	if (expr->key->etype == EXPR_MAPPING) {
-		nft_print(octx, " : ");
-		expr_print(expr->key->right, octx);
-	}
-}
-
-static void set_elem_expr_destroy(struct expr *expr)
-{
-	struct stmt *stmt, *next;
-
-	assert(expr->flags == 0);
-
-	free_const(expr->comment);
-	expr_free(expr->key);
-	list_for_each_entry_safe(stmt, next, &expr->stmt_list, list)
-		stmt_free(stmt);
-}
-
-static void __set_elem_expr_clone(struct expr *new, const struct expr *expr)
-{
-	new->expiration = expr->expiration;
-	new->timeout = expr->timeout;
-	if (expr->comment)
-		new->comment = xstrdup(expr->comment);
-	init_list_head(&new->stmt_list);
-}
-
-static void set_elem_expr_clone(struct expr *new, const struct expr *expr)
-{
-	new->key = expr_clone(expr->key);
-	__set_elem_expr_clone(new, expr);
-}
-
-static void set_elem_expr_set_type(const struct expr *expr,
-				   const struct datatype *dtype,
-				   enum byteorder byteorder)
-{
-       expr_set_type(expr->key, dtype, byteorder);
-}
-
-static const struct expr_ops set_elem_expr_ops = {
-	.type		= EXPR_SET_ELEM,
-	.name		= "set element",
-	.clone		= set_elem_expr_clone,
-	.print		= set_elem_expr_print,
-	.json		= set_elem_expr_json,
-	.destroy	= set_elem_expr_destroy,
-	.set_type	= set_elem_expr_set_type,
-};
-
-struct expr *set_elem_expr_alloc(const struct location *loc, struct expr *key)
-{
-	struct expr *expr;
-
-	expr = expr_alloc(loc, EXPR_SET_ELEM, key->dtype,
-			  key->byteorder, key->len);
-	expr->key = key;
-	init_list_head(&expr->stmt_list);
-
-	return expr;
 }
 
 static void set_elem_catchall_expr_print(const struct expr *expr,
@@ -1761,17 +1653,12 @@ static void set_elem_catchall_expr_print(const struct expr *expr,
 	nft_print(octx, "*");
 }
 
-static void set_elem_catchall_expr_clone(struct expr *new, const struct expr *expr)
-{
-	__set_elem_expr_clone(new, expr);
-}
-
 static const struct expr_ops set_elem_catchall_expr_ops = {
 	.type		= EXPR_SET_ELEM_CATCHALL,
 	.name		= "catch-all set element",
 	.print		= set_elem_catchall_expr_print,
-	.json		= set_elem_catchall_expr_json,
 	.clone		= set_elem_catchall_expr_clone,
+	.json		= set_elem_catchall_expr_json,
 };
 
 struct expr *set_elem_catchall_expr_alloc(const struct location *loc)
@@ -1848,7 +1735,6 @@ static const struct expr_ops *__expr_ops_by_type(enum expr_types etype)
 	case EXPR_LIST: return &list_expr_ops;
 	case EXPR_SET: return &set_expr_ops;
 	case EXPR_SET_REF: return &set_ref_expr_ops;
-	case EXPR_SET_ELEM: return &set_elem_expr_ops;
 	case EXPR_MAPPING: return &mapping_expr_ops;
 	case EXPR_MAP: return &map_expr_ops;
 	case EXPR_UNARY: return &unary_expr_ops;
diff --git a/src/intervals.c b/src/intervals.c
index 1bfb59a5b868..1b5bb02b38b9 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -12,10 +12,11 @@
 #include <expression.h>
 #include <intervals.h>
 #include <rule.h>
+#include <elem.h>
 
-static void __set_expr_add(struct expr *set, struct expr *elem)
+static void __set_elem_add(struct expr *set, struct set_elem *elem)
 {
-	list_add_tail(&elem->list, &expr_set(set)->expressions);
+	list_add_tail(&elem->list, &expr_set(set)->elems);
 }
 
 static void set_to_range(struct expr *init);
@@ -76,18 +77,16 @@ static void __setelem_expr_to_range(struct expr **exprp)
 		*exprp = key;
 		break;
 	default:
-		BUG("unhandled key type %s", expr_name(expr->key));
+		BUG("unhandled key type %s", expr_name(expr));
 	}
 }
 
-static void setelem_expr_to_range(struct expr *expr)
+static void setelem_expr_to_range(struct set_elem *set_elem)
 {
-	assert(expr->etype == EXPR_SET_ELEM);
-
-	if (expr->key->etype == EXPR_MAPPING)
-		__setelem_expr_to_range(&expr->key->left);
+	if (set_elem->key->etype == EXPR_MAPPING)
+		__setelem_expr_to_range(&set_elem->key->left);
 	else
-		__setelem_expr_to_range(&expr->key);
+		__setelem_expr_to_range(&set_elem->key);
 }
 
 struct set_automerge_ctx {
@@ -97,18 +96,18 @@ struct set_automerge_ctx {
 	unsigned int	debug_mask;
 };
 
-static void purge_elem(struct set_automerge_ctx *ctx, struct expr *i)
+static void purge_elem(struct set_automerge_ctx *ctx, struct set_elem *i)
 {
 	if (ctx->debug_mask & NFT_DEBUG_SEGTREE) {
 		pr_gmp_debug("remove: [%Zx-%Zx]\n",
 			     i->key->range.low,
 			     i->key->range.high);
 	}
-	list_move_tail(&i->list, &expr_set(ctx->purge)->expressions);
+	list_move_tail(&i->list, &expr_set(ctx->purge)->elems);
 }
 
 static void remove_overlapping_range(struct set_automerge_ctx *ctx,
-				     struct expr *prev, struct expr *i)
+				     struct set_elem *prev, struct set_elem *i)
 {
 	if (i->key->flags & EXPR_F_KERNEL) {
 		i->key->location = prev->key->location;
@@ -116,7 +115,7 @@ static void remove_overlapping_range(struct set_automerge_ctx *ctx,
 		return;
 	}
 	list_del(&i->list);
-	expr_free(i);
+	set_elem_free(i);
 	expr_set(ctx->init)->size--;
 }
 
@@ -126,7 +125,7 @@ struct range {
 };
 
 static bool merge_ranges(struct set_automerge_ctx *ctx,
-			 struct expr *prev, struct expr *i,
+			 struct set_elem *prev, struct set_elem *i,
 			 struct range *prev_range, struct range *range)
 {
 	if (prev->key->flags & EXPR_F_KERNEL) {
@@ -144,7 +143,7 @@ static bool merge_ranges(struct set_automerge_ctx *ctx,
 		mpz_set(prev->key->range.high, i->key->range.high);
 		mpz_set(prev_range->high, range->high);
 		list_del(&i->list);
-		expr_free(i);
+		set_elem_free(i);
 		expr_set(ctx->init)->size--;
 	}
 	return false;
@@ -155,22 +154,22 @@ static void set_sort_splice(struct expr *init, struct set *set)
 	struct set *existing_set = set->existing_set;
 
 	set_to_range(init);
-	list_expr_sort(&expr_set(init)->expressions);
+	list_elems_sort(&expr_set(init)->elems);
 
 	if (!existing_set || existing_set->errors)
 		return;
 
 	if (existing_set->init) {
 		set_to_range(existing_set->init);
-		list_splice_sorted(&expr_set(existing_set->init)->expressions,
-				   &expr_set(init)->expressions);
-		init_list_head(&expr_set(existing_set->init)->expressions);
+		list_splice_sorted(&expr_set(existing_set->init)->elems,
+				   &expr_set(init)->elems);
+		init_list_head(&expr_set(existing_set->init)->elems);
 	} else {
 		existing_set->init = set_expr_alloc(&internal_location, set);
 	}
 }
 
-static void set_prev_elem(struct expr **prev, struct expr *i,
+static void set_prev_elem(struct set_elem **prev, struct set_elem *i,
 			  struct range *prev_range, struct range *range)
 {
 	*prev = i;
@@ -180,7 +179,7 @@ static void set_prev_elem(struct expr **prev, struct expr *i,
 
 static void setelem_automerge(struct set_automerge_ctx *ctx)
 {
-	struct expr *i, *next, *prev = NULL;
+	struct set_elem *i, *next, *prev = NULL;
 	struct range range, prev_range;
 	mpz_t rop;
 
@@ -190,9 +189,7 @@ static void setelem_automerge(struct set_automerge_ctx *ctx)
 	mpz_init(range.high);
 	mpz_init(rop);
 
-	list_for_each_entry_safe(i, next, &expr_set(ctx->init)->expressions, list) {
-		assert(i->etype == EXPR_SET_ELEM);
-
+	list_for_each_entry_safe(i, next, &expr_set(ctx->init)->elems, list) {
 		if (expr_type_catchall(i->key))
 			continue;
 
@@ -234,13 +231,10 @@ static void setelem_automerge(struct set_automerge_ctx *ctx)
 
 static void set_to_range(struct expr *init)
 {
-	struct expr *i;
-
-	list_for_each_entry(i, &expr_set(init)->expressions, list) {
-		assert(i->etype == EXPR_SET_ELEM);
+	struct set_elem *i;
 
+	list_for_each_entry(i, &expr_set(init)->elems, list)
 		setelem_expr_to_range(i);
-	}
 }
 
 int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
@@ -252,13 +246,13 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
 		.init		= init,
 		.debug_mask	= debug_mask,
 	};
-	struct expr *i, *next, *clone;
+	struct set_elem *i, *next, *clone;
 	struct cmd *purge_cmd;
 	struct handle h = {};
 
 	if (set->flags & NFT_SET_MAP) {
 		set_to_range(init);
-		list_expr_sort(&expr_set(init)->expressions);
+		list_elems_sort(&expr_set(init)->elems);
 		return 0;
 	}
 
@@ -268,23 +262,21 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
 
 	setelem_automerge(&ctx);
 
-	list_for_each_entry_safe(i, next, &expr_set(init)->expressions, list) {
-		assert(i->etype == EXPR_SET_ELEM);
-
+	list_for_each_entry_safe(i, next, &expr_set(init)->elems, list) {
 		if (i->key->flags & EXPR_F_KERNEL) {
-			list_move_tail(&i->list, &expr_set(existing_set->init)->expressions);
+			list_move_tail(&i->list, &expr_set(existing_set->init)->elems);
 		} else if (existing_set) {
 			if (debug_mask & NFT_DEBUG_SEGTREE) {
 				pr_gmp_debug("add: [%Zx-%Zx]\n",
 					     i->key->range.low, i->key->range.high);
 			}
-			clone = expr_clone(i);
+			clone = set_elem_clone(i);
 			clone->key->flags |= EXPR_F_KERNEL;
-			__set_expr_add(existing_set->init, clone);
+			__set_elem_add(existing_set->init, clone);
 		}
 	}
 
-	if (list_empty(&expr_set(ctx.purge)->expressions)) {
+	if (list_empty(&expr_set(ctx.purge)->elems)) {
 		expr_free(ctx.purge);
 		return 0;
 	}
@@ -297,25 +289,25 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
 	return 0;
 }
 
-static void remove_elem(struct expr *prev, struct set *set, struct expr *purge)
+static void remove_elem(struct set_elem *prev, struct set *set, struct expr *purge)
 {
-	struct expr *clone;
+	struct set_elem *clone;
 
 	if (prev->key->flags & EXPR_F_KERNEL) {
-		clone = expr_clone(prev);
-		list_add_tail(&clone->list, &expr_set(purge)->expressions);
+		clone = set_elem_clone(prev);
+		list_add_tail(&clone->list, &expr_set(purge)->elems);
 	}
 }
 
-static void __adjust_elem_left(struct set *set, struct expr *prev, struct expr *i)
+static void __adjust_elem_left(struct set *set, struct set_elem *prev, struct set_elem *i)
 {
 	prev->key->flags &= ~EXPR_F_KERNEL;
 	mpz_set(prev->key->range.low, i->key->range.high);
 	mpz_add_ui(prev->key->range.low, prev->key->range.low, 1);
-	list_move(&prev->list, &expr_set(set->existing_set->init)->expressions);
+	list_move(&prev->list, &expr_set(set->existing_set->init)->elems);
 }
 
-static void adjust_elem_left(struct set *set, struct expr *prev, struct expr *i,
+static void adjust_elem_left(struct set *set, struct set_elem *prev, struct set_elem *i,
 			     struct expr *purge)
 {
 	prev->key->location = i->key->location;
@@ -323,18 +315,18 @@ static void adjust_elem_left(struct set *set, struct expr *prev, struct expr *i,
 	__adjust_elem_left(set, prev, i);
 
 	list_del(&i->list);
-	expr_free(i);
+	set_elem_free(i);
 }
 
-static void __adjust_elem_right(struct set *set, struct expr *prev, struct expr *i)
+static void __adjust_elem_right(struct set *set, struct set_elem *prev, struct set_elem *i)
 {
 	prev->key->flags &= ~EXPR_F_KERNEL;
 	mpz_set(prev->key->range.high, i->key->range.low);
 	mpz_sub_ui(prev->key->range.high, prev->key->range.high, 1);
-	list_move(&prev->list, &expr_set(set->existing_set->init)->expressions);
+	list_move(&prev->list, &expr_set(set->existing_set->init)->elems);
 }
 
-static void adjust_elem_right(struct set *set, struct expr *prev, struct expr *i,
+static void adjust_elem_right(struct set *set, struct set_elem *prev, struct set_elem *i,
 			      struct expr *purge)
 {
 	prev->key->location = i->key->location;
@@ -342,38 +334,38 @@ static void adjust_elem_right(struct set *set, struct expr *prev, struct expr *i
 	__adjust_elem_right(set, prev, i);
 
 	list_del(&i->list);
-	expr_free(i);
+	set_elem_free(i);
 }
 
-static void split_range(struct set *set, struct expr *prev, struct expr *i,
+static void split_range(struct set *set, struct set_elem *prev, struct set_elem *i,
 			struct expr *purge)
 {
-	struct expr *clone;
+	struct set_elem *clone;
 
 	prev->key->location = i->key->location;
 
 	if (prev->key->flags & EXPR_F_KERNEL) {
-		clone = expr_clone(prev);
-		list_add_tail(&clone->list, &expr_set(purge)->expressions);
+		clone = set_elem_clone(prev);
+		list_add_tail(&clone->list, &expr_set(purge)->elems);
 	}
 
 	prev->key->flags &= ~EXPR_F_KERNEL;
-	clone = expr_clone(prev);
+	clone = set_elem_clone(prev);
 	mpz_set(clone->key->range.low, i->key->range.high);
 	mpz_add_ui(clone->key->range.low, i->key->range.high, 1);
-	__set_expr_add(set->existing_set->init, clone);
+	__set_elem_add(set->existing_set->init, clone);
 
 	mpz_set(prev->key->range.high, i->key->range.low);
 	mpz_sub_ui(prev->key->range.high, i->key->range.low, 1);
-	list_move(&prev->list, &expr_set(set->existing_set->init)->expressions);
+	list_move(&prev->list, &expr_set(set->existing_set->init)->elems);
 
 	list_del(&i->list);
-	expr_free(i);
+	set_elem_free(i);
 }
 
 static int setelem_adjust(struct set *set, struct expr *purge,
 			  struct range *prev_range, struct range *range,
-			  struct expr *prev, struct expr *i)
+			  struct set_elem *prev, struct set_elem *i)
 {
 	if (mpz_cmp(prev_range->low, range->low) == 0 &&
 	    mpz_cmp(prev_range->high, range->high) > 0) {
@@ -398,7 +390,7 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 			  struct expr *purge, struct expr *elems,
 			  unsigned int debug_mask)
 {
-	struct expr *i, *next, *prev = NULL;
+	struct set_elem *i, *next, *prev = NULL;
 	struct range range, prev_range;
 	int err = 0;
 	mpz_t rop;
@@ -409,9 +401,7 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 	mpz_init(range.high);
 	mpz_init(rop);
 
-	list_for_each_entry_safe(i, next, &expr_set(elems)->expressions, list) {
-		assert(i->etype == EXPR_SET_ELEM);
-
+	list_for_each_entry_safe(i, next, &expr_set(elems)->elems, list) {
 		if (expr_type_catchall(i->key)) {
 			uint32_t len;
 
@@ -447,11 +437,11 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 			if (i->key->flags & EXPR_F_REMOVE) {
 				if (prev->key->flags & EXPR_F_KERNEL) {
 					prev->key->location = i->key->location;
-					list_move_tail(&prev->list, &expr_set(purge)->expressions);
+					list_move_tail(&prev->list, &expr_set(purge)->elems);
 				}
 
 				list_del(&i->list);
-				expr_free(i);
+				set_elem_free(i);
 			}
 		} else if (set->automerge) {
 			if (setelem_adjust(set, purge, &prev_range, &range, prev, i) < 0) {
@@ -486,18 +476,18 @@ static void automerge_delete(struct list_head *msgs, struct set *set,
 	};
 
 	ctx.purge = set_expr_alloc(&internal_location, set);
-	list_expr_sort(&expr_set(init)->expressions);
+	list_elems_sort(&expr_set(init)->elems);
 	setelem_automerge(&ctx);
 	expr_free(ctx.purge);
 }
 
-static int __set_delete(struct list_head *msgs, struct expr *i,	struct set *set,
+static int __set_delete(struct list_head *msgs, struct set_elem *i, struct set *set,
 			struct expr *init, struct set *existing_set,
 			unsigned int debug_mask)
 {
 	i->key->flags |= EXPR_F_REMOVE;
-	list_move_tail(&i->list, &expr_set(existing_set->init)->expressions);
-	list_expr_sort(&expr_set(existing_set->init)->expressions);
+	list_move_tail(&i->list, &expr_set(existing_set->init)->elems);
+	list_elems_sort(&expr_set(existing_set->init)->elems);
 
 	return setelem_delete(msgs, set, init, existing_set->init, debug_mask);
 }
@@ -507,10 +497,11 @@ int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
 	       struct expr *init, unsigned int debug_mask)
 {
 	struct set *existing_set = set->existing_set;
-	struct expr *i, *next, *add, *clone;
+	struct set_elem *i, *next, *clone;
 	struct handle h = {};
 	struct cmd *add_cmd;
 	LIST_HEAD(del_list);
+	struct expr *add;
 	int err;
 
 	set_to_range(init);
@@ -523,38 +514,38 @@ int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
 		existing_set->init = set_expr_alloc(&internal_location, set);
 	}
 
-	list_splice_init(&expr_set(init)->expressions, &del_list);
+	list_splice_init(&expr_set(init)->elems, &del_list);
 
 	list_for_each_entry_safe(i, next, &del_list, list) {
 		err = __set_delete(msgs, i, set, init, existing_set, debug_mask);
 		if (err < 0) {
-			list_splice(&del_list, &expr_set(init)->expressions);
+			list_splice(&del_list, &expr_set(init)->elems);
 			return err;
 		}
 	}
 
 	add = set_expr_alloc(&internal_location, set);
-	list_for_each_entry(i, &expr_set(existing_set->init)->expressions, list) {
+	list_for_each_entry(i, &expr_set(existing_set->init)->elems, list) {
 		if (!(i->key->flags & EXPR_F_KERNEL)) {
-			clone = expr_clone(i);
-			__set_expr_add(add, clone);
+			clone = set_elem_clone(i);
+			__set_elem_add(add, clone);
 			i->key->flags |= EXPR_F_KERNEL;
 		}
 	}
 
 	if (debug_mask & NFT_DEBUG_SEGTREE) {
-		list_for_each_entry(i, &expr_set(init)->expressions, list)
+		list_for_each_entry(i, &expr_set(init)->elems, list)
 			pr_gmp_debug("remove: [%Zx-%Zx]\n",
 				     i->key->range.low, i->key->range.high);
-		list_for_each_entry(i, &expr_set(add)->expressions, list)
+		list_for_each_entry(i, &expr_set(add)->elems, list)
 			pr_gmp_debug("add: [%Zx-%Zx]\n",
 				     i->key->range.low, i->key->range.high);
-		list_for_each_entry(i, &expr_set(existing_set->init)->expressions, list)
+		list_for_each_entry(i, &expr_set(existing_set->init)->elems, list)
 			pr_gmp_debug("existing: [%Zx-%Zx]\n",
 				     i->key->range.low, i->key->range.high);
 	}
 
-	if (list_empty(&expr_set(add)->expressions)) {
+	if (list_empty(&expr_set(add)->elems)) {
 		expr_free(add);
 		return 0;
 	}
@@ -570,7 +561,7 @@ int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
 static int setelem_overlap(struct list_head *msgs, struct set *set,
 			   struct expr *init)
 {
-	struct expr *i, *next, *prev = NULL;
+	struct set_elem *i, *next, *prev = NULL;
 	struct range range, prev_range;
 	int err = 0;
 	mpz_t rop;
@@ -581,9 +572,7 @@ static int setelem_overlap(struct list_head *msgs, struct set *set,
 	mpz_init(range.high);
 	mpz_init(rop);
 
-	list_for_each_entry_safe(i, next, &expr_set(init)->expressions, list) {
-		assert(i->etype == EXPR_SET_ELEM);
-
+	list_for_each_entry_safe(i, next, &expr_set(init)->elems, list) {
 		if (expr_type_catchall(i->key))
 			continue;
 
@@ -643,22 +632,20 @@ err_out:
 int set_overlap(struct list_head *msgs, struct set *set, struct expr *init)
 {
 	struct set *existing_set = set->existing_set;
-	struct expr *i, *n, *clone;
+	struct set_elem *i, *n, *clone;
 	int err;
 
 	set_sort_splice(init, set);
 
 	err = setelem_overlap(msgs, set, init);
 
-	list_for_each_entry_safe(i, n, &expr_set(init)->expressions, list) {
-		assert(i->etype == EXPR_SET_ELEM);
-
+	list_for_each_entry_safe(i, n, &expr_set(init)->elems, list) {
 		if (i->key->flags & EXPR_F_KERNEL)
-			list_move_tail(&i->list, &expr_set(existing_set->init)->expressions);
+			list_move_tail(&i->list, &expr_set(existing_set->init)->elems);
 		else if (existing_set) {
-			clone = expr_clone(i);
+			clone = set_elem_clone(i);
 			clone->key->flags |= EXPR_F_KERNEL;
-			__set_expr_add(existing_set->init, clone);
+			__set_elem_add(existing_set->init, clone);
 		}
 	}
 
@@ -705,12 +692,13 @@ static bool range_low_is_non_zero(const struct expr *expr)
 
 int set_to_intervals(const struct set *set, struct expr *init, bool add)
 {
-	struct expr *i, *n, *prev = NULL, *root, *expr;
+	struct set_elem *i, *n, *prev = NULL;
+	struct set_elem *root;
 	LIST_HEAD(intervals);
+	struct expr *expr;
 	mpz_t p;
 
-	list_for_each_entry_safe(i, n, &expr_set(init)->expressions, list) {
-
+	list_for_each_entry_safe(i, n, &expr_set(init)->elems, list) {
 		if (expr_type_catchall(i->key))
 			continue;
 
@@ -727,7 +715,7 @@ int set_to_intervals(const struct set *set, struct expr *init, bool add)
 							 set->key->len, p, p);
 			mpz_clear(p);
 
-			root = set_elem_expr_alloc(&internal_location, expr);
+			root = set_elem_alloc(expr);
 
 			root->key->flags |= EXPR_F_INTERVAL_END;
 			list_add(&root->list, &intervals);
@@ -736,57 +724,24 @@ int set_to_intervals(const struct set *set, struct expr *init, bool add)
 		prev = i;
 	}
 
-	list_splice_init(&intervals, &expr_set(init)->expressions);
+	list_splice_init(&intervals, &expr_set(init)->elems);
 
 	return 0;
 }
 
-/* This only works for the supported stateful statements. */
-static void set_elem_stmt_clone(struct expr *dst, const struct expr *src)
-{
-	struct stmt *stmt, *nstmt;
-
-	list_for_each_entry(stmt, &src->stmt_list, list) {
-		nstmt = xzalloc(sizeof(*stmt));
-		*nstmt = *stmt;
-		list_add_tail(&nstmt->list, &dst->stmt_list);
-	}
-}
-
-static void set_elem_expr_copy(struct expr *dst, const struct expr *src)
-{
-	if (src->comment)
-		dst->comment = xstrdup(src->comment);
-	if (src->timeout)
-		dst->timeout = src->timeout;
-	if (src->expiration)
-		dst->expiration = src->expiration;
-
-	set_elem_stmt_clone(dst, src);
-}
-
-static struct expr *setelem_key(struct expr *expr)
+static struct expr *setelem_key(struct set_elem *elem)
 {
-	struct expr *key;
-
-	switch (expr->etype) {
-	case EXPR_SET_ELEM:
-		if (expr->key->etype == EXPR_MAPPING)
-			return expr->key->left;
-
-		return expr->key;
-	default:
-		BUG("unhandled expression type %d", expr->etype);
-		return NULL;
-	}
+	if (elem->key->etype == EXPR_MAPPING)
+		return elem->key->left;
 
-	return key;
+	return elem->key;
 }
 
-int setelem_to_interval(const struct set *set, struct expr *elem,
-			struct expr *next_elem, struct list_head *intervals)
+int setelem_to_interval(const struct set *set, struct set_elem *elem,
+			struct set_elem *next_elem, struct list_head *intervals)
 {
 	struct expr *key, *next_key = NULL, *low, *high;
+	struct set_elem *elem_low, *elem_high;
 	bool adjacent = false;
 
 	key = setelem_key(elem);
@@ -822,22 +777,22 @@ int setelem_to_interval(const struct set *set, struct expr *elem,
 	mpz_set(low->value, key->range.low);
 
 	if (elem->key->etype == EXPR_MAPPING)
-		low = mapping_expr_alloc(&elem->location,
+		low = mapping_expr_alloc(&elem->key->location,
 					 low, expr_get(elem->key->right));
 
-	low = set_elem_expr_alloc(&key->location, low);
-	set_elem_expr_copy(low, elem);
+	elem_low = set_elem_alloc(low);
+	set_elem_copy(elem_low, elem);
 
-	list_add_tail(&low->list, intervals);
+	list_add_tail(&elem_low->list, intervals);
 
 	if (adjacent)
 		return 0;
 	else if (!mpz_cmp_ui(key->range.low, 0) &&
 		 elem->key->flags & EXPR_F_INTERVAL_END) {
-		low->key->flags |= EXPR_F_INTERVAL_END;
+		elem_low->key->flags |= EXPR_F_INTERVAL_END;
 		return 0;
 	} else if (mpz_scan0(key->range.high, 0) == set->key->len) {
-		low->key->flags |= EXPR_F_INTERVAL_OPEN;
+		elem_low->key->flags |= EXPR_F_INTERVAL_OPEN;
 		return 0;
 	}
 
@@ -848,10 +803,9 @@ int setelem_to_interval(const struct set *set, struct expr *elem,
 	mpz_add_ui(high->value, high->value, 1);
 	high->byteorder = BYTEORDER_BIG_ENDIAN;
 
-	high = set_elem_expr_alloc(&key->location, high);
-
-	high->key->flags |= EXPR_F_INTERVAL_END;
-	list_add_tail(&high->list, intervals);
+	elem_high = set_elem_alloc(high);
+	elem_high->key->flags |= EXPR_F_INTERVAL_END;
+	list_add_tail(&elem_high->list, intervals);
 
 	return 0;
 }
diff --git a/src/json.c b/src/json.c
index f0ae48361aaa..3197b025e7ec 100644
--- a/src/json.c
+++ b/src/json.c
@@ -166,6 +166,8 @@ static json_t *set_stmt_list_json(const struct list_head *stmt_list,
 	return root;
 }
 
+static json_t *set_elem_print_json(const struct set_elem *elem, struct output_ctx *octx);
+
 static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 {
 	json_t *root, *tmp, *datatype_ext = NULL;
@@ -234,13 +236,10 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 
 	if (!nft_output_terse(octx) && set->init && expr_set(set->init)->size > 0) {
 		json_t *array = json_array();
-		const struct expr *i;
-
-		list_for_each_entry(i, &expr_set(set->init)->expressions, list) {
-			assert(i->etype == EXPR_SET_ELEM);
+		const struct set_elem *i;
 
-			json_array_append_new(array, expr_print_json(i, octx));
-		}
+		list_for_each_entry(i, &expr_set(set->init)->elems, list)
+			json_array_append_new(array, set_elem_print_json(i, octx));
 
 		json_object_set_new(root, "elem", array);
 	}
@@ -791,12 +790,10 @@ json_t *concat_expr_json(const struct expr *expr, struct output_ctx *octx)
 json_t *set_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
 	json_t *array = json_array();
-	const struct expr *i;
+	const struct set_elem *i;
 
-	list_for_each_entry(i, &expr_set(expr)->expressions, list) {
-		assert(i->etype == EXPR_SET_ELEM);
-
-		json_array_append_new(array, expr_print_json(i, octx));
+	list_for_each_entry(i, &expr_set(expr)->elems, list) {
+		json_array_append_new(array, expr_print_json(i->key, octx));
 	}
 
 	return nft_json_pack("{s:o}", "set", array);
@@ -811,7 +808,7 @@ json_t *set_ref_expr_json(const struct expr *expr, struct output_ctx *octx)
 	}
 }
 
-static json_t *__set_elem_expr_json(const struct expr *expr,
+static json_t *__set_elem_expr_json(const struct set_elem *elem,
 				    const struct expr *val,
 				    struct output_ctx *octx)
 {
@@ -820,25 +817,23 @@ static json_t *__set_elem_expr_json(const struct expr *expr,
 	json_t *tmp;
 
 	/* these element attributes require formal set elem syntax */
-	if (expr->timeout || expr->expiration || expr->comment ||
-	    !list_empty(&expr->stmt_list)) {
-		assert(expr->etype == EXPR_SET_ELEM);
-
+	if (elem->timeout || elem->expiration || elem->comment ||
+	    !list_empty(&elem->stmt_list)) {
 		root = nft_json_pack("{s:o}", "val", root);
 
-		if (expr->timeout) {
-			tmp = json_integer(expr->timeout / 1000);
+		if (elem->timeout) {
+			tmp = json_integer(elem->timeout / 1000);
 			json_object_set_new(root, "timeout", tmp);
 		}
-		if (expr->expiration) {
-			tmp = json_integer(expr->expiration / 1000);
+		if (elem->expiration) {
+			tmp = json_integer(elem->expiration / 1000);
 			json_object_set_new(root, "expires", tmp);
 		}
-		if (expr->comment) {
-			tmp = json_string(expr->comment);
+		if (elem->comment) {
+			tmp = json_string(elem->comment);
 			json_object_set_new(root, "comment", tmp);
 		}
-		list_for_each_entry(stmt, &expr->stmt_list, list) {
+		list_for_each_entry(stmt, &elem->stmt_list, list) {
 			tmp = stmt_print_json(stmt, octx);
 			/* XXX: detect and complain about clashes? */
 			json_object_update_missing(root, tmp);
@@ -850,25 +845,23 @@ static json_t *__set_elem_expr_json(const struct expr *expr,
 	return root;
 }
 
-json_t *set_elem_expr_json(const struct expr *expr, struct output_ctx *octx)
+static json_t *set_elem_print_json(const struct set_elem *elem, struct output_ctx *octx)
 {
 	json_t *left, *right;
 
-	assert(expr->etype == EXPR_SET_ELEM);
-
 	/* Special handling to retain backwards compatibility: json exposes
-	 * EXPR_MAPPING { left: EXPR_SET_ELEM, right: EXPR_{VALUE,CONCAT,SYMBOL}.
+	 * EXPR_MAPPING { left: set_elem, right: EXPR_{VALUE,CONCAT,SYMBOL}.
 	 * Revisit this at some point to accept the following input:
-	 * EXPR_SET_ELEM -> EXPR_MAPPING { left, right }
+	 * set_elem -> EXPR_MAPPING { left, right }
 	 */
-	if (expr->key->etype == EXPR_MAPPING) {
-		left = __set_elem_expr_json(expr, expr->key->left, octx);
-		right = expr_print_json(expr->key->right, octx);
+	if (elem->key->etype == EXPR_MAPPING) {
+		left = __set_elem_expr_json(elem, elem->key->left, octx);
+		right = expr_print_json(elem->key->right, octx);
 
 		return nft_json_pack("[o, o]", left, right);
 	}
 
-	return __set_elem_expr_json(expr, expr->key, octx);
+	return __set_elem_expr_json(elem, elem->key, octx);
 }
 
 json_t *prefix_expr_json(const struct expr *expr, struct output_ctx *octx)
@@ -1678,7 +1671,7 @@ json_t *set_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 
 	root = nft_json_pack("{s:s, s:o, s:s+}",
 			 "op", set_stmt_op_names[stmt->set.op],
-			 "elem", expr_print_json(stmt->set.key, octx),
+			 "elem", set_elem_print_json(stmt->set.key, octx),
 			 "set", "@", stmt->set.set->set->handle.set.name);
 
 	if (!list_empty(&stmt->set.stmt_list)) {
@@ -1696,8 +1689,8 @@ json_t *map_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 
 	root = nft_json_pack("{s:s, s:o, s:o, s:s+}",
 			 "op", set_stmt_op_names[stmt->map.op],
-			 "elem", expr_print_json(stmt->map.key, octx),
-			 "data", expr_print_json(stmt->map.data, octx),
+			 "elem", set_elem_print_json(stmt->map.key, octx),
+			 "data", set_elem_print_json(stmt->map.data, octx),
 			 "map", "@", stmt->map.set->set->handle.set.name);
 
 	if (!list_empty(&stmt->map.stmt_list)) {
@@ -1731,7 +1724,7 @@ json_t *meter_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 	octx->flags = flags;
 
 	root = nft_json_pack("{s:o, s:o, s:i}",
-			 "key", expr_print_json(stmt->meter.key, octx),
+			 "key", set_elem_print_json(stmt->meter.elem, octx),
 			 "stmt", tmp,
 			 "size", stmt->meter.size);
 	if (stmt->meter.set) {
diff --git a/src/mergesort.c b/src/mergesort.c
index f4b4d56b579c..6d32d7072c4f 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -88,7 +88,7 @@ static mpz_srcptr expr_msort_value(const struct expr *expr, mpz_t value)
 	return value;
 }
 
-static int expr_msort_cmp(const struct expr *e1, const struct expr *e2)
+static int set_elem_msort_cmp(const struct set_elem *e1, const struct set_elem *e2)
 {
 	mpz_srcptr value1;
 	mpz_srcptr value2;
@@ -96,8 +96,6 @@ static int expr_msort_cmp(const struct expr *e1, const struct expr *e2)
 	mpz_t value2_tmp;
 	int ret;
 
-	assert(e1->etype == EXPR_SET_ELEM && e2->etype == EXPR_SET_ELEM);
-
 	mpz_init(value1_tmp);
 	mpz_init(value2_tmp);
 	value1 = expr_msort_value(e1->key, value1_tmp);
@@ -116,8 +114,8 @@ void list_splice_sorted(struct list_head *list, struct list_head *head)
 
 	while (l != list) {
 		if (h == head ||
-		    expr_msort_cmp(list_entry(l, typeof(struct expr), list),
-				   list_entry(h, typeof(struct expr), list)) <= 0) {
+		    set_elem_msort_cmp(list_entry(l, typeof(struct set_elem), list),
+				       list_entry(h, typeof(struct set_elem), list)) <= 0) {
 			l = l->next;
 			list_add_tail(l->prev, h);
 			continue;
@@ -142,7 +140,7 @@ static void list_cut_middle(struct list_head *list, struct list_head *head)
 	__list_cut_position(list, head, s);
 }
 
-void list_expr_sort(struct list_head *head)
+void list_elems_sort(struct list_head *head)
 {
 	struct list_head *list;
 	LIST_HEAD(temp);
@@ -154,8 +152,8 @@ void list_expr_sort(struct list_head *head)
 
 	list_cut_middle(list, head);
 
-	list_expr_sort(head);
-	list_expr_sort(list);
+	list_elems_sort(head);
+	list_elems_sort(list);
 
 	list_splice_sorted(list, head);
 }
diff --git a/src/mnl.c b/src/mnl.c
index a6d8d3d3ca08..c04db8138b02 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1957,12 +1957,12 @@ static void netlink_dump_setelem_done(struct netlink_ctx *ctx)
 
 static struct nftnl_set_elem *
 alloc_nftnl_setelem_interval(const struct set *set, const struct expr *init,
-			     struct expr *elem, struct expr *next_elem,
+			     struct set_elem *elem, struct set_elem *next_elem,
 			     struct nftnl_set_elem **nlse_high)
 {
 	struct nftnl_set_elem *nlse[2] = {};
+	struct set_elem *set_elem, *next;
 	LIST_HEAD(interval_list);
-	struct expr *expr, *next;
 	int i = 0;
 
 	if (setelem_to_interval(set, elem, next_elem, &interval_list) < 0)
@@ -1974,10 +1974,10 @@ alloc_nftnl_setelem_interval(const struct set *set, const struct expr *init,
 		return nlse[0];
 	}
 
-	list_for_each_entry_safe(expr, next, &interval_list, list) {
-		nlse[i++] = alloc_nftnl_setelem(init, expr);
-		list_del(&expr->list);
-		expr_free(expr);
+	list_for_each_entry_safe(set_elem, next, &interval_list, list) {
+		nlse[i++] = alloc_nftnl_setelem(init, set_elem);
+		list_del(&set_elem->list);
+		set_elem_free(set_elem);
 	}
 	*nlse_high = nlse[1];
 
@@ -1993,7 +1993,7 @@ static int mnl_nft_setelem_batch(const struct nftnl_set *nls, struct cmd *cmd,
 {
 	struct nftnl_set_elem *nlse, *nlse_high = NULL;
 	struct nlattr *nest1, *nest2, *nest3;
-	struct expr *expr = NULL, *next;
+	struct set_elem *elem, *next = NULL;
 	unsigned int nest_len = 0;
 	struct nlmsghdr *nlh;
 	int i = 0;
@@ -2002,7 +2002,7 @@ static int mnl_nft_setelem_batch(const struct nftnl_set *nls, struct cmd *cmd,
 		flags |= NLM_F_CREATE;
 
 	if (init)
-		expr = list_first_entry(&expr_set(init)->expressions, struct expr, list);
+		elem = list_first_entry(&expr_set(init)->elems, struct set_elem, list);
 
 next:
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(batch), msg_type,
@@ -2022,26 +2022,26 @@ next:
 				 htonl(nftnl_set_get_u32(nls, NFTNL_SET_ID)));
 	}
 
-	if (!init || list_empty(&expr_set(init)->expressions))
+	if (!init || list_empty(&expr_set(init)->elems))
 		return 0;
 
-	assert(expr);
+	assert(elem);
 	nest1 = mnl_attr_nest_start(nlh, NFTA_SET_ELEM_LIST_ELEMENTS);
-	list_for_each_entry_from(expr, &expr_set(init)->expressions, list) {
+	list_for_each_entry_from(elem, &expr_set(init)->elems, list) {
 
 		if (set_is_non_concat_range(set)) {
 			if (set_is_anonymous(set->flags) &&
-			    !list_is_last(&expr->list, &expr_set(init)->expressions))
-				next = list_next_entry(expr, list);
+			    !list_is_last(&elem->list, &expr_set(init)->elems))
+				next = list_next_entry(elem, list);
 			else
 				next = NULL;
 
-			nlse = alloc_nftnl_setelem_interval(set, init, expr, next, &nlse_high);
+			nlse = alloc_nftnl_setelem_interval(set, init, elem, next, &nlse_high);
 		} else {
-			nlse = alloc_nftnl_setelem(init, expr);
+			nlse = alloc_nftnl_setelem(init, elem);
 		}
 
-		cmd_add_loc(cmd, nlh, &expr->location);
+		cmd_add_loc(cmd, nlh, &elem->key->location);
 
 		nest2 = mnl_attr_nest_start(nlh, ++i);
 		nftnl_set_elem_nlmsg_build_payload(nlh, nlse);
diff --git a/src/monitor.c b/src/monitor.c
index e5803e32a467..9fcac48fef0e 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -379,12 +379,10 @@ static bool netlink_event_ignore_range_event(struct nftnl_set_elem *nlse)
 static bool set_elem_is_open_interval(struct expr *elem)
 {
 	switch (elem->etype) {
-	case EXPR_SET_ELEM:
-		return elem->key->flags & EXPR_F_INTERVAL_OPEN;
 	case EXPR_MAPPING:
 		return set_elem_is_open_interval(elem->left);
 	default:
-		return false;
+		return elem->flags & EXPR_F_INTERVAL_OPEN;
 	}
 }
 
@@ -392,7 +390,7 @@ static bool set_elem_is_open_interval(struct expr *elem)
 static bool netlink_event_range_cache(struct set *cached_set,
 				      struct set *dummyset)
 {
-	struct expr *elem;
+	struct set_elem *elem;
 
 	/* not an interval ? */
 	if (!(cached_set->flags & NFT_SET_INTERVAL))
@@ -406,10 +404,10 @@ static bool netlink_event_range_cache(struct set *cached_set,
 	}
 
 	/* don't cache half-open range elements */
-	elem = list_entry(expr_set(dummyset->init)->expressions.prev, struct expr, list);
-	if (!set_elem_is_open_interval(elem) &&
+	elem = list_entry(expr_set(dummyset->init)->elems.prev, struct set_elem, list);
+	if (!set_elem_is_open_interval(elem->key) &&
 	    dummyset->desc.field_count <= 1) {
-		cached_set->rg_cache = expr_clone(elem);
+		cached_set->rg_cache = set_elem_clone(elem);
 		return true;
 	}
 
diff --git a/src/netlink.c b/src/netlink.c
index 8916370604c0..acb01ecf8411 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -40,6 +40,7 @@
 #include <statement.h>
 #include <gmputil.h>
 #include <utils.h>
+#include <elem.h>
 #include <erec.h>
 
 #define nft_mon_print(monh, ...) nft_print(&monh->ctx->nft->output, __VA_ARGS__)
@@ -101,9 +102,9 @@ static void __netlink_gen_data(const struct expr *expr,
 			       struct nft_data_linearize *data, bool expand);
 
 struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
-					   const struct expr *expr)
+					   const struct set_elem *elem)
 {
-	const struct expr *data, *elem;
+	const struct expr *data;
 	struct nftnl_set_elem *nlse;
 	struct nft_data_linearize nld;
 	struct nftnl_udata_buf *udbuf = NULL;
@@ -116,21 +117,16 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 	if (nlse == NULL)
 		memory_allocation_error();
 
-	if (expr->etype != EXPR_SET_ELEM)
-		BUG("Unexpected expression type: got %d\n", expr->etype);
-
 	data = NULL;
-	if (expr->key->etype == EXPR_MAPPING) {
-		if (!(expr->key->flags & EXPR_F_INTERVAL_END))
-			data = expr->key->right;
+	if (elem->key->etype == EXPR_MAPPING) {
+		if (!(elem->key->flags & EXPR_F_INTERVAL_END))
+			data = elem->key->right;
 
-		key = expr->key->left;
+		key = elem->key->left;
 	} else {
-		key = expr->key;
+		key = elem->key;
 	}
 
-	elem = expr;
-
 	switch (key->etype) {
 	case EXPR_SET_ELEM_CATCHALL:
 		break;
@@ -186,7 +182,7 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 						netlink_gen_stmt_stateful(stmt));
 		}
 	}
-	if (elem->comment || expr->key->flags & EXPR_F_INTERVAL_OPEN) {
+	if (elem->comment || elem->key->flags & EXPR_F_INTERVAL_OPEN) {
 		udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
 		if (!udbuf)
 			memory_allocation_error();
@@ -196,7 +192,7 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 					  elem->comment))
 			memory_allocation_error();
 	}
-	if (expr->key->flags & EXPR_F_INTERVAL_OPEN) {
+	if (elem->key->flags & EXPR_F_INTERVAL_OPEN) {
 		if (!nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_ELEM_FLAGS,
 					 NFTNL_SET_ELEM_F_INTERVAL_OPEN))
 			memory_allocation_error();
@@ -239,7 +235,7 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 				   nld.value, nld.len);
 	}
 
-	if (expr->key->flags & EXPR_F_INTERVAL_END)
+	if (elem->key->flags & EXPR_F_INTERVAL_END)
 		flags |= NFT_SET_ELEM_INTERVAL_END;
 	if (key->etype == EXPR_SET_ELEM_CATCHALL)
 		flags |= NFT_SET_ELEM_CATCHALL;
@@ -1306,12 +1302,10 @@ out:
 void alloc_setelem_cache(const struct expr *set, struct nftnl_set *nls)
 {
 	struct nftnl_set_elem *nlse;
-	const struct expr *expr;
-
-	list_for_each_entry(expr, &expr_set(set)->expressions, list) {
-		assert(expr->etype == EXPR_SET_ELEM);
+	const struct set_elem *elem;
 
-		nlse = alloc_nftnl_setelem(set, expr);
+	list_for_each_entry(elem, &expr_set(set)->elems, list) {
+		nlse = alloc_nftnl_setelem(set, elem);
 		nftnl_set_elem_add(nls, nlse);
 	}
 }
@@ -1538,7 +1532,7 @@ static int set_elem_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 }
 
 static void set_elem_parse_udata(struct nftnl_set_elem *nlse,
-				 struct expr *expr)
+				 struct set_elem *elem, struct expr *key)
 {
 	const struct nftnl_udata *ud[NFTNL_UDATA_SET_ELEM_MAX + 1] = {};
 	const void *data;
@@ -1549,7 +1543,7 @@ static void set_elem_parse_udata(struct nftnl_set_elem *nlse,
 		return;
 
 	if (ud[NFTNL_UDATA_SET_ELEM_COMMENT])
-		expr->comment =
+		elem->comment =
 			xstrdup(nftnl_udata_get(ud[NFTNL_UDATA_SET_ELEM_COMMENT]));
 	if (ud[NFTNL_UDATA_SET_ELEM_FLAGS]) {
 		uint32_t elem_flags;
@@ -1557,7 +1551,7 @@ static void set_elem_parse_udata(struct nftnl_set_elem *nlse,
 		elem_flags =
 			nftnl_udata_get_u32(ud[NFTNL_UDATA_SET_ELEM_FLAGS]);
 		if (elem_flags & NFTNL_SET_ELEM_F_INTERVAL_OPEN)
-			expr->key->flags |= EXPR_F_INTERVAL_OPEN;
+			key->flags |= EXPR_F_INTERVAL_OPEN;
 	}
 }
 
@@ -1570,7 +1564,8 @@ int netlink_delinearize_setelem(struct netlink_ctx *ctx,
 		.cache	= &ctx->nft->cache,
 	};
 	struct nft_data_delinearize nld;
-	struct expr *expr, *key, *data;
+	struct expr *key, *data;
+	struct set_elem *elem;
 	uint32_t flags = 0;
 
 	init_list_head(&setelem_parse_ctx.stmt_list);
@@ -1654,20 +1649,20 @@ key_end:
 		key = mapping_expr_alloc(&netlink_location, key, data);
 	}
 out:
-	expr = set_elem_expr_alloc(&netlink_location, key);
-	expr->key->flags |= EXPR_F_KERNEL;
+	elem = set_elem_alloc(key);
+	key->flags |= EXPR_F_KERNEL;
 
 	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_TIMEOUT)) {
-		expr->timeout	 = nftnl_set_elem_get_u64(nlse, NFTNL_SET_ELEM_TIMEOUT);
-		if (expr->timeout == 0)
-			expr->timeout	 = NFT_NEVER_TIMEOUT;
+		elem->timeout	 = nftnl_set_elem_get_u64(nlse, NFTNL_SET_ELEM_TIMEOUT);
+		if (elem->timeout == 0)
+			elem->timeout	 = NFT_NEVER_TIMEOUT;
 	}
 
 	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_EXPIRATION))
-		expr->expiration = nftnl_set_elem_get_u64(nlse, NFTNL_SET_ELEM_EXPIRATION);
+		elem->expiration = nftnl_set_elem_get_u64(nlse, NFTNL_SET_ELEM_EXPIRATION);
 	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_USERDATA)) {
-		set_elem_parse_udata(nlse, expr);
-		if (expr->comment)
+		set_elem_parse_udata(nlse, elem, key);
+		if (elem->comment)
 			set->elem_has_comment = true;
 	}
 	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_EXPR)) {
@@ -1681,14 +1676,14 @@ out:
 		nftnl_set_elem_expr_foreach(nlse, set_elem_parse_expressions,
 					    &setelem_parse_ctx);
 	}
-	list_splice_tail_init(&setelem_parse_ctx.stmt_list, &expr->stmt_list);
+	list_splice_tail_init(&setelem_parse_ctx.stmt_list, &elem->stmt_list);
 
 	if (flags & NFT_SET_ELEM_INTERVAL_END) {
-		expr->key->flags |= EXPR_F_INTERVAL_END;
+		key->flags |= EXPR_F_INTERVAL_END;
 		if (mpz_cmp_ui(set->key->value, 0) == 0)
 			set->root = true;
 	}
-	set_expr_add(set->init, expr);
+	set_elem_add(set->init, elem);
 
 	if (!(flags & NFT_SET_ELEM_INTERVAL_END) &&
 	    nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_KEY_END)) {
@@ -1777,7 +1772,7 @@ int netlink_list_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	else if (set->flags & NFT_SET_INTERVAL)
 		interval_map_decompose(set->init);
 	else
-		list_expr_sort(&expr_set(ctx->set->init)->expressions);
+		list_elems_sort(&expr_set(ctx->set->init)->elems);
 
 	nftnl_set_free(nls);
 	ctx->set = NULL;
@@ -1821,7 +1816,7 @@ int netlink_get_setelem(struct netlink_ctx *ctx, const struct handle *h,
 	else if (set->flags & NFT_SET_INTERVAL)
 		err = get_set_decompose(cache_set, set);
 	else
-		list_expr_sort(&expr_set(ctx->set->init)->expressions);
+		list_elems_sort(&expr_set(ctx->set->init)->elems);
 
 	nftnl_set_free(nls);
 	nftnl_set_free(nls_out);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 81763206f136..27a9d99d0310 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1759,6 +1759,7 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 	enum nft_registers sreg, sreg_data;
 	struct stmt *stmt, *dstmt, *next;
 	const struct nftnl_expr *dnle;
+	struct set_elem *elem;
 	struct set *set;
 	const char *name;
 
@@ -1786,8 +1787,8 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 		expr_set_type(expr, datatype_get(set->key->dtype), set->key->byteorder);
 	}
 
-	expr = set_elem_expr_alloc(&expr->location, expr);
-	expr->timeout = nftnl_expr_get_u64(nle, NFTNL_EXPR_DYNSET_TIMEOUT);
+	elem = set_elem_alloc(expr);
+	elem->timeout = nftnl_expr_get_u64(nle, NFTNL_EXPR_DYNSET_TIMEOUT);
 
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_DYNSET_EXPR)) {
 		dstmt = NULL;
@@ -1827,8 +1828,8 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 		expr_set_type(expr_data, set->data->dtype, set->data->byteorder);
 		stmt = map_stmt_alloc(loc);
 		stmt->map.set	= set_ref_expr_alloc(loc, set);
-		stmt->map.key	= expr;
-		stmt->map.data	= expr_data;
+		stmt->map.key	= elem;
+		stmt->map.data	= set_elem_alloc(expr_data);
 		stmt->map.op	= nftnl_expr_get_u32(nle, NFTNL_EXPR_DYNSET_OP);
 		list_splice_tail(&dynset_parse_ctx.stmt_list,
 				 &stmt->map.stmt_list);
@@ -1837,7 +1838,7 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 		    set_is_anonymous(set->flags)) {
 			stmt = meter_stmt_alloc(loc);
 			stmt->meter.set  = set_ref_expr_alloc(loc, set);
-			stmt->meter.key  = expr;
+			stmt->meter.elem  = elem;
 			stmt->meter.stmt = list_first_entry(&dynset_parse_ctx.stmt_list,
 							    struct stmt, list);
 			stmt->meter.size = set->desc.size;
@@ -1845,7 +1846,7 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 			stmt = set_stmt_alloc(loc);
 			stmt->set.set   = set_ref_expr_alloc(loc, set);
 			stmt->set.op    = nftnl_expr_get_u32(nle, NFTNL_EXPR_DYNSET_OP);
-			stmt->set.key   = expr;
+			stmt->set.key   = elem;
 			list_splice_tail(&dynset_parse_ctx.stmt_list,
 					 &stmt->set.stmt_list);
 		}
@@ -1857,7 +1858,7 @@ out_err:
 	list_for_each_entry_safe(dstmt, next, &dynset_parse_ctx.stmt_list, list)
 		stmt_free(dstmt);
 
-	expr_free(expr);
+	set_elem_free(elem);
 }
 
 static void netlink_parse_objref(struct netlink_parse_ctx *ctx,
@@ -2202,12 +2203,10 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 
 			if (set_is_anonymous(set->flags) &&
 			    set->init &&
-			    !list_empty(&expr_set(set->init)->expressions)) {
-				struct expr *elem;
-
-				elem = list_first_entry(&expr_set(set->init)->expressions, struct expr, list);
-				assert(elem->etype == EXPR_SET_ELEM);
+			    !list_empty(&expr_set(set->init)->elems)) {
+				struct set_elem *elem;
 
+				elem = list_first_entry(&expr_set(set->init)->elems, struct set_elem, list);
 				if (elem->key->etype == EXPR_VALUE)
 					payload_icmp_check(ctx, payload, elem->key);
 			}
@@ -2482,7 +2481,7 @@ static void binop_adjust_one(const struct expr *binop, struct expr *value,
 static void binop_adjust(const struct expr *binop, struct expr *right,
 			 unsigned int shift)
 {
-	struct expr *i;
+	struct set_elem *i;
 
 	switch (right->etype) {
 	case EXPR_VALUE:
@@ -2492,9 +2491,7 @@ static void binop_adjust(const struct expr *binop, struct expr *right,
 		if (!set_is_anonymous(right->set->flags))
 			break;
 
-		list_for_each_entry(i, &expr_set(right->set->init)->expressions, list) {
-			assert(i->etype == EXPR_SET_ELEM);
-
+		list_for_each_entry(i, &expr_set(right->set->init)->elems, list) {
 			switch (i->key->etype) {
 			case EXPR_VALUE:
 				binop_adjust_one(binop, i->key, shift);
@@ -2863,7 +2860,8 @@ static void expr_postprocess_concat(struct rule_pp_ctx *ctx, struct expr **exprp
 static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 {
 	struct dl_proto_ctx *dl = dl_proto_ctx(ctx);
-	struct expr *expr = *exprp, *i;
+	struct expr *expr = *exprp;
+	struct set_elem *i;
 
 	switch (expr->etype) {
 	case EXPR_MAP:
@@ -2883,10 +2881,10 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		expr_postprocess(ctx, &expr->right);
 		break;
 	case EXPR_SET:
-		list_for_each_entry(i, &expr_set(expr)->expressions, list) {
-			assert(i->etype == EXPR_SET_ELEM);
-
-			expr_postprocess(ctx, &i);
+		list_for_each_entry(i, &expr_set(expr)->elems, list) {
+			ctx->flags |= RULE_PP_IN_SET_ELEM;
+			expr_postprocess(ctx, &i->key);
+			ctx->flags &= RULE_PP_IN_SET_ELEM;
 		}
 		break;
 	case EXPR_CONCAT:
@@ -3033,11 +3031,6 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 	case EXPR_PREFIX:
 		expr_postprocess(ctx, &expr->prefix);
 		break;
-	case EXPR_SET_ELEM:
-		ctx->flags |= RULE_PP_IN_SET_ELEM;
-		expr_postprocess(ctx, &expr->key);
-		ctx->flags &= ~RULE_PP_IN_SET_ELEM;
-		break;
 	case EXPR_EXTHDR:
 		exthdr_dependency_kill(&dl->pdctx, expr, dl->pctx.family);
 		break;
@@ -3467,8 +3460,6 @@ static bool has_inner_desc(const struct expr *expr)
 		return expr->meta.inner_desc;
 	case EXPR_PAYLOAD:
 		return expr->payload.inner_desc;
-	case EXPR_SET_ELEM:
-		return has_inner_desc(expr->key);
 	default:
 		break;
 	}
@@ -3487,7 +3478,7 @@ static struct dl_proto_ctx *rule_update_dl_proto_ctx(struct rule_pp_ctx *rctx)
 			inner = true;
 		break;
 	case STMT_SET:
-		if (has_inner_desc(stmt->set.key))
+		if (has_inner_desc(stmt->set.key->key))
 			inner = true;
 		break;
 	default:
@@ -3528,7 +3519,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 			stmt_payload_postprocess(&rctx);
 			break;
 		case STMT_METER:
-			expr_postprocess(&rctx, &stmt->meter.key);
+			expr_postprocess(&rctx, &stmt->meter.elem->key);
 			break;
 		case STMT_META:
 			if (stmt->meta.expr != NULL)
@@ -3564,11 +3555,11 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 			stmt_reject_postprocess(&rctx);
 			break;
 		case STMT_SET:
-			expr_postprocess(&rctx, &stmt->set.key);
+			expr_postprocess(&rctx, &stmt->set.key->key);
 			break;
 		case STMT_MAP:
-			expr_postprocess(&rctx, &stmt->map.key);
-			expr_postprocess(&rctx, &stmt->map.data);
+			expr_postprocess(&rctx, &stmt->map.key->key);
+			expr_postprocess(&rctx, &stmt->map.data->key);
 			break;
 		case STMT_DUP:
 			if (stmt->dup.to != NULL)
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index dfa841c6a407..85185892673d 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -944,8 +944,6 @@ static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_rt(ctx, expr, dreg);
 	case EXPR_CT:
 		return netlink_gen_ct(ctx, expr, dreg);
-	case EXPR_SET_ELEM:
-		return netlink_gen_expr(ctx, expr->key, dreg);
 	case EXPR_NUMGEN:
 		return netlink_gen_numgen(ctx, expr, dreg);
 	case EXPR_HASH:
@@ -1686,21 +1684,21 @@ static void netlink_gen_meter_stmt(struct netlink_linearize_ctx *ctx,
 	enum nft_dynset_ops op;
 	struct set *set;
 
-	sreg_key = get_register(ctx, stmt->meter.key->key);
-	netlink_gen_expr(ctx, stmt->meter.key->key, sreg_key);
-	release_register(ctx, stmt->meter.key->key);
+	sreg_key = get_register(ctx, stmt->meter.elem->key);
+	netlink_gen_expr(ctx, stmt->meter.elem->key, sreg_key);
+	release_register(ctx, stmt->meter.elem->key);
 
 	set = stmt->meter.set->set;
-	if (stmt->meter.key->timeout)
+	if (stmt->meter.elem->timeout)
 		op = NFT_DYNSET_OP_UPDATE;
 	else
 		op = NFT_DYNSET_OP_ADD;
 
 	nle = alloc_nft_expr("dynset");
 	netlink_put_register(nle, NFTNL_EXPR_DYNSET_SREG_KEY, sreg_key);
-	if (stmt->meter.key->timeout)
+	if (stmt->meter.elem->timeout)
 		nftnl_expr_set_u64(nle, NFTNL_EXPR_DYNSET_TIMEOUT,
-				   stmt->meter.key->timeout);
+				   stmt->meter.elem->timeout);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_OP, op);
 	nftnl_expr_set_str(nle, NFTNL_EXPR_DYNSET_SET_NAME, set->handle.set.name);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_SET_ID, set->handle.set_id);
diff --git a/src/optimize.c b/src/optimize.c
index a2bd3aab72d0..069cad41f6b4 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -565,7 +565,8 @@ static void merge_expr_stmts(const struct optimize_ctx *ctx,
 			     const struct merge *merge,
 			     struct stmt *stmt_a)
 {
-	struct expr *expr_a, *expr_b, *set, *elem;
+	struct expr *expr_a, *expr_b, *set;
+	struct set_elem *elem;
 	struct stmt *stmt_b;
 	uint32_t i;
 
@@ -573,13 +574,13 @@ static void merge_expr_stmts(const struct optimize_ctx *ctx,
 	expr_set(set)->set_flags |= NFT_SET_ANONYMOUS;
 
 	expr_a = stmt_a->expr->right;
-	elem = set_elem_expr_alloc(&internal_location, expr_get(expr_a));
+	elem = set_elem_alloc(expr_get(expr_a));
 	set_expr_add(set, elem);
 
 	for (i = from + 1; i <= to; i++) {
 		stmt_b = ctx->stmt_matrix[i][merge->stmt[0]];
 		expr_b = stmt_b->expr->right;
-		elem = set_elem_expr_alloc(&internal_location, expr_get(expr_b));
+		elem = set_elem_alloc(expr_get(expr_b));
 		set_expr_add(set, elem);
 	}
 
@@ -590,12 +591,12 @@ static void merge_expr_stmts(const struct optimize_ctx *ctx,
 static void merge_vmap(const struct optimize_ctx *ctx,
 		       struct stmt *stmt_a, const struct stmt *stmt_b)
 {
-	struct expr *mappings, *mapping, *expr;
+	struct set_elem *elem, *mapping;
+	struct expr *mappings;
 
 	mappings = stmt_b->expr->mappings;
-	list_for_each_entry(expr, &expr_set(mappings)->expressions, list) {
-		assert(expr->etype == EXPR_SET_ELEM);
-		mapping = expr_clone(expr);
+	list_for_each_entry(elem, &expr_set(mappings)->elems, list) {
+		mapping = set_elem_clone(elem);
 		set_expr_add(stmt_a->expr->mappings, mapping);
 	}
 }
@@ -649,6 +650,7 @@ static void __merge_concat(const struct optimize_ctx *ctx, uint32_t i,
 {
 	struct expr *concat, *next, *expr, *concat_clone, *clone;
 	LIST_HEAD(pending_list);
+	struct set_elem *elem;
 	struct stmt *stmt_a;
 	uint32_t k;
 
@@ -660,10 +662,9 @@ static void __merge_concat(const struct optimize_ctx *ctx, uint32_t i,
 			stmt_a = ctx->stmt_matrix[i][merge->stmt[k]];
 			switch (stmt_a->expr->right->etype) {
 			case EXPR_SET:
-				list_for_each_entry(expr, &expr_set(stmt_a->expr->right)->expressions, list) {
-					assert(expr->etype == EXPR_SET_ELEM);
+				list_for_each_entry(elem, &expr_set(stmt_a->expr->right)->elems, list) {
 					concat_clone = expr_clone(concat);
-					clone = expr_clone(expr->key);
+					clone = expr_clone(elem->key);
 					concat_expr_add(concat_clone, clone);
 					list_add_tail(&concat_clone->list, &pending_list);
 				}
@@ -701,14 +702,15 @@ static void __merge_concat(const struct optimize_ctx *ctx, uint32_t i,
 static void __merge_concat_stmts(const struct optimize_ctx *ctx, uint32_t i,
 				 const struct merge *merge, struct expr *set)
 {
-	struct expr *concat, *next, *elem;
+	struct expr *concat, *next;
 	LIST_HEAD(concat_list);
+	struct set_elem *elem;
 
 	__merge_concat(ctx, i, merge, &concat_list);
 
 	list_for_each_entry_safe(concat, next, &concat_list, list) {
 		list_del(&concat->list);
-		elem = set_elem_expr_alloc(&internal_location, concat);
+		elem = set_elem_alloc(concat);
 		set_expr_add(set, elem);
 	}
 }
@@ -752,7 +754,8 @@ static void merge_concat_stmts(const struct optimize_ctx *ctx,
 static void build_verdict_map(struct expr *expr, struct stmt *verdict,
 			      struct expr *set, struct stmt *counter)
 {
-	struct expr *item, *elem, *mapping;
+	struct set_elem *elem_item, *elem;
+	struct expr *item, *mapping;
 	struct stmt *counter_elem;
 
 	switch (expr->etype) {
@@ -761,7 +764,7 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict,
 			mapping = mapping_expr_alloc(&internal_location, expr_get(item),
 						     expr_get(verdict->expr));
 
-			elem = set_elem_expr_alloc(&internal_location, mapping);
+			elem = set_elem_alloc(mapping);
 			if (counter) {
 				counter_elem = counter_stmt_alloc(&counter->location);
 				list_add_tail(&counter_elem->list, &elem->stmt_list);
@@ -772,12 +775,11 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict,
 		stmt_free(counter);
 		break;
 	case EXPR_SET:
-		list_for_each_entry(item, &expr_set(expr)->expressions, list) {
-			assert(item->etype == EXPR_SET_ELEM);
-			mapping = mapping_expr_alloc(&internal_location, expr_get(item->key),
+		list_for_each_entry(elem_item, &expr_set(expr)->elems, list) {
+			mapping = mapping_expr_alloc(&internal_location, expr_get(elem_item->key),
 						     expr_get(verdict->expr));
 
-			elem = set_elem_expr_alloc(&internal_location, mapping);
+			elem = set_elem_alloc(mapping);
 			if (counter) {
 				counter_elem = counter_stmt_alloc(&counter->location);
 				list_add_tail(&counter_elem->list, &elem->stmt_list);
@@ -797,7 +799,7 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict,
 		mapping = mapping_expr_alloc(&internal_location, expr_get(expr),
 					     expr_get(verdict->expr));
 
-		elem = set_elem_expr_alloc(&internal_location, mapping);
+		elem = set_elem_alloc(mapping);
 		if (counter)
 			list_add_tail(&counter->list, &elem->stmt_list);
 
@@ -892,9 +894,10 @@ static void __merge_concat_stmts_vmap(const struct optimize_ctx *ctx,
 				      uint32_t i, const struct merge *merge,
 				      struct expr *set, struct stmt *verdict)
 {
-	struct expr *concat, *next, *elem, *mapping;
+	struct expr *concat, *next, *mapping;
 	struct stmt *counter, *counter_elem;
 	LIST_HEAD(concat_list);
+	struct set_elem *elem;
 
 	counter = zap_counter(ctx, i);
 	__merge_concat(ctx, i, merge, &concat_list);
@@ -905,7 +908,7 @@ static void __merge_concat_stmts_vmap(const struct optimize_ctx *ctx,
 		mapping = mapping_expr_alloc(&internal_location, concat,
 					     expr_get(verdict->expr));
 
-		elem = set_elem_expr_alloc(&internal_location, mapping);
+		elem = set_elem_alloc(mapping);
 		if (counter) {
 			counter_elem = counter_stmt_alloc(&counter->location);
 			list_add_tail(&counter_elem->list, &elem->stmt_list);
@@ -1054,9 +1057,10 @@ static void merge_nat(const struct optimize_ctx *ctx,
 		      uint32_t from, uint32_t to,
 		      const struct merge *merge)
 {
-	struct expr *expr, *set, *elem, *nat_expr, *mapping, *left;
+	struct expr *expr, *set, *nat_expr, *mapping, *left;
 	int k, family = NFPROTO_UNSPEC;
 	struct stmt *stmt, *nat_stmt;
+	struct set_elem *elem;
 	uint32_t i;
 
 	k = stmt_nat_find(ctx, from);
@@ -1073,7 +1077,7 @@ static void merge_nat(const struct optimize_ctx *ctx,
 		nat_expr = stmt_nat_expr(nat_stmt);
 
 		mapping = mapping_expr_alloc(&internal_location, expr_get(expr), nat_expr);
-		elem = set_elem_expr_alloc(&internal_location, mapping);
+		elem = set_elem_alloc(mapping);
 		set_expr_add(set, elem);
 	}
 
@@ -1106,9 +1110,10 @@ static void merge_concat_nat(const struct optimize_ctx *ctx,
 			     uint32_t from, uint32_t to,
 			     const struct merge *merge)
 {
-	struct expr *expr, *set, *elem, *nat_expr, *mapping, *left, *concat;
+	struct expr *expr, *set, *nat_expr, *mapping, *left, *concat;
 	int k, family = NFPROTO_UNSPEC;
 	struct stmt *stmt, *nat_stmt;
+	struct set_elem *elem;
 	uint32_t i, j;
 
 	k = stmt_nat_find(ctx, from);
@@ -1130,7 +1135,7 @@ static void merge_concat_nat(const struct optimize_ctx *ctx,
 		nat_expr = stmt_nat_expr(nat_stmt);
 
 		mapping = mapping_expr_alloc(&internal_location, concat, nat_expr);
-		elem = set_elem_expr_alloc(&internal_location, mapping);
+		elem = set_elem_alloc(mapping);
 		set_expr_add(set, elem);
 	}
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index f76216ccbfba..162ca9316c54 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -245,6 +245,7 @@ int nft_lex(void *, void *, void *);
 	struct rule		*rule;
 	struct stmt		*stmt;
 	struct expr		*expr;
+	struct set_elem		*elem;
 	struct set		*set;
 	struct obj		*obj;
 	struct flowtable	*flowtable;
@@ -911,18 +912,28 @@ int nft_lex(void *, void *, void *);
 %type <expr>			verdict_map_stmt
 %destructor { expr_free($$); }	verdict_map_stmt
 
-%type <expr>			verdict_map_expr verdict_map_list_expr verdict_map_list_member_expr
-%destructor { expr_free($$); }	verdict_map_expr verdict_map_list_expr verdict_map_list_member_expr
+%type <elem>			verdict_map_list_member_expr
+%destructor { set_elem_free($$); } verdict_map_list_member_expr
 
-%type <expr>			set_expr set_block_expr set_list_expr set_list_member_expr flowtable_expr flowtable_list_expr flowtable_expr_member
-%destructor { expr_free($$); }	set_expr set_block_expr set_list_expr set_list_member_expr flowtable_expr flowtable_list_expr flowtable_expr_member
-%type <expr>			set_elem_expr set_elem_expr_alloc set_lhs_expr set_rhs_expr
-%destructor { expr_free($$); }	set_elem_expr set_elem_expr_alloc set_lhs_expr set_rhs_expr
-%type <expr>			set_elem_expr_stmt set_elem_expr_stmt_alloc
-%destructor { expr_free($$); }	set_elem_expr_stmt set_elem_expr_stmt_alloc
+%type <expr>			verdict_map_expr verdict_map_list_expr
+%destructor { expr_free($$); }	verdict_map_expr verdict_map_list_expr
 
-%type <expr>			meter_key_expr meter_key_expr_alloc
-%destructor { expr_free($$); }	meter_key_expr meter_key_expr_alloc
+%type <elem>			set_list_member_expr
+%destructor { set_elem_free($$); } set_list_member_expr
+
+%type <expr>			set_expr set_block_expr set_list_expr flowtable_expr flowtable_list_expr flowtable_expr_member
+%destructor { expr_free($$); }	set_expr set_block_expr set_list_expr flowtable_expr flowtable_list_expr flowtable_expr_member
+
+%type <elem>			set_elem_expr_alloc set_elem_expr
+%destructor { set_elem_free($$); } set_elem_expr_alloc set_elem_expr
+
+%type <expr>			set_lhs_expr set_rhs_expr
+%destructor { expr_free($$); }	set_lhs_expr set_rhs_expr
+%type <elem>			set_elem_expr_stmt set_elem_expr_stmt_alloc
+%destructor { set_elem_free($$); }	set_elem_expr_stmt set_elem_expr_stmt_alloc
+
+%type <elem>		meter_key_expr meter_key_expr_alloc
+%destructor { set_elem_free($$); }	meter_key_expr meter_key_expr_alloc
 
 %type <expr>			expr initializer_expr keyword_expr
 %destructor { expr_free($$); }	expr initializer_expr keyword_expr
@@ -3422,11 +3433,11 @@ verdict_map_expr	:	'{'	verdict_map_list_expr	'}'
 verdict_map_list_expr	:	verdict_map_list_member_expr
 			{
 				$$ = set_expr_alloc(&@$, NULL);
-				set_expr_add($$, $1);
+				set_elem_add($$, $1);
 			}
 			|	verdict_map_list_expr	COMMA	verdict_map_list_member_expr
 			{
-				set_expr_add($1, $3);
+				set_elem_add($1, $3);
 				$$ = $1;
 			}
 			|	verdict_map_list_expr	COMMA	opt_newline
@@ -3434,10 +3445,10 @@ verdict_map_list_expr	:	verdict_map_list_member_expr
 
 verdict_map_list_member_expr:	opt_newline	set_elem_expr	COLON	verdict_expr	opt_newline
 			{
-				struct expr *expr = $2;
+				struct set_elem *set_elem = $2;
 
-				expr->key = mapping_expr_alloc(&@2, $2->key, $4);
-				$$ = expr;
+				set_elem->key = mapping_expr_alloc(&@2, $2->key, $4);
+				$$ = set_elem;
 			}
 			;
 
@@ -4324,7 +4335,7 @@ set_elem_expr_stmt	:	set_elem_expr_stmt_alloc
 
 set_elem_expr_stmt_alloc:	concat_expr
 			{
-				$$ = set_elem_expr_alloc(&@1, $1);
+				$$ = set_elem_alloc($1);
 			}
 			;
 
@@ -4383,7 +4394,7 @@ meter_stmt 		:	METER	identifier		'{' meter_key_expr stmt '}'
 				$$ = meter_stmt_alloc(&@$);
 				$$->meter.name = $2;
 				$$->meter.size = 0;
-				$$->meter.key  = $4;
+				$$->meter.elem  = $4;
 				$$->meter.stmt = $5;
 				$$->location  = @$;
 			}
@@ -4392,7 +4403,7 @@ meter_stmt 		:	METER	identifier		'{' meter_key_expr stmt '}'
 				$$ = meter_stmt_alloc(&@$);
 				$$->meter.name = $2;
 				$$->meter.size = $4;
-				$$->meter.key  = $6;
+				$$->meter.elem  = $6;
 				$$->meter.stmt = $7;
 				$$->location  = @$;
 			}
@@ -4641,11 +4652,11 @@ set_expr		:	'{'	set_list_expr		'}'
 set_list_expr		:	set_list_member_expr
 			{
 				$$ = set_expr_alloc(&@$, NULL);
-				set_expr_add($$, $1);
+				set_elem_add($$, $1);
 			}
 			|	set_list_expr		COMMA	set_list_member_expr
 			{
-				set_expr_add($1, $3);
+				set_elem_add($1, $3);
 				$$ = $1;
 			}
 			|	set_list_expr		COMMA	opt_newline
@@ -4653,7 +4664,7 @@ set_list_expr		:	set_list_member_expr
 
 set_list_member_expr	:	opt_newline	set_expr	opt_newline
 			{
-				$$ = set_elem_expr_alloc(&@$, $2);
+				$$ = set_elem_alloc($2);
 			}
 			|	opt_newline	set_elem_expr	opt_newline
 			{
@@ -4661,24 +4672,23 @@ set_list_member_expr	:	opt_newline	set_expr	opt_newline
 			}
 			|	opt_newline	set_elem_expr	COLON	set_rhs_expr	opt_newline
 			{
-				struct expr *expr = $2;
+				struct set_elem *set_elem = $2;
 
-				expr->key = mapping_expr_alloc(&@2, $2->key, $4);
-				$$ = expr;
+				set_elem->key = mapping_expr_alloc(&@2, $2->key, $4);
+				$$ = set_elem;
 			}
 			;
 
 meter_key_expr		:	meter_key_expr_alloc
 			|	meter_key_expr_alloc		set_elem_options
 			{
-				$$->location = @$;
 				$$ = $1;
 			}
 			;
 
 meter_key_expr_alloc	:	concat_expr
 			{
-				$$ = set_elem_expr_alloc(&@1, $1);
+				$$ = set_elem_alloc($1);
 			}
 			;
 
@@ -4698,19 +4708,19 @@ set_elem_key_expr	:	set_lhs_expr		{ $$ = $1; }
 
 set_elem_expr_alloc	:	set_elem_key_expr	set_elem_stmt_list
 			{
-				$$ = set_elem_expr_alloc(&@1, $1);
+				$$ = set_elem_alloc($1);
 				list_splice_tail($2, &$$->stmt_list);
 				free($2);
 			}
 			|	set_elem_key_expr
 			{
-				$$ = set_elem_expr_alloc(&@1, $1);
+				$$ = set_elem_alloc($1);
 			}
 			;
 
 set_elem_options	:	set_elem_option
 			{
-				$<expr>$	= $<expr>0;
+				$<elem>$	= $<elem>0;
 			}
 			|	set_elem_options	set_elem_option
 			;
@@ -4738,25 +4748,25 @@ set_elem_time_spec	:	STRING
 
 set_elem_option		:	TIMEOUT		time_spec
 			{
-				$<expr>0->timeout = $2;
+				$<elem>0->timeout = $2;
 			}
 			|	EXPIRES		time_spec
 			{
-				$<expr>0->expiration = $2;
+				$<elem>0->expiration = $2;
 			}
 			|	comment_spec
 			{
-				if (already_set($<expr>0->comment, &@1, state)) {
+				if (already_set($<elem>0->comment, &@1, state)) {
 					free_const($1);
 					YYERROR;
 				}
-				$<expr>0->comment = $1;
+				$<elem>0->comment = $1;
 			}
 			;
 
 set_elem_expr_options	:	set_elem_expr_option
 			{
-				$<expr>$	= $<expr>0;
+				$<elem>$	= $<elem>0;
 			}
 			|	set_elem_expr_options	set_elem_expr_option
 			;
@@ -4783,19 +4793,19 @@ set_elem_stmt		:	counter_stmt	close_scope_counter
 
 set_elem_expr_option	:	TIMEOUT		set_elem_time_spec
 			{
-				$<expr>0->timeout = $2;
+				$<elem>0->timeout = $2;
 			}
 			|	EXPIRES		time_spec
 			{
-				$<expr>0->expiration = $2;
+				$<elem>0->expiration = $2;
 			}
 			|	comment_spec
 			{
-				if (already_set($<expr>0->comment, &@1, state)) {
+				if (already_set($<elem>0->comment, &@1, state)) {
 					free_const($1);
 					YYERROR;
 				}
-				$<expr>0->comment = $1;
+				$<elem>0->comment = $1;
 			}
 			;
 
diff --git a/src/parser_json.c b/src/parser_json.c
index 0522b2cd80b9..86fc09dadc16 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -111,7 +111,6 @@ static struct expr *json_parse_rhs_expr(struct json_ctx *ctx, json_t *root);
 static struct expr *json_parse_stmt_expr(struct json_ctx *ctx, json_t *root);
 static struct expr *json_parse_primary_expr(struct json_ctx *ctx, json_t *root);
 static struct expr *json_parse_set_rhs_expr(struct json_ctx *ctx, json_t *root);
-static struct expr *json_parse_set_elem_expr_stmt(struct json_ctx *ctx, json_t *root);
 static struct expr *json_parse_map_lhs_expr(struct json_ctx *ctx, json_t *root);
 static struct expr *json_parse_concat_elem_expr(struct json_ctx *ctx, json_t *root);
 static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root);
@@ -1457,10 +1456,30 @@ static struct expr *json_parse_verdict_expr(struct json_ctx *ctx,
 	return NULL;
 }
 
+static int json_unpack_elem(struct json_ctx *ctx, json_t *root,
+			    const char **key, json_t **value)
+{
+	assert(key);
+	assert(value);
+
+	if (json_object_size(root) != 1)
+		return 1;
+
+	json_object_foreach(root, *key, *value)
+		return 0;
+
+	/* not reached */
+	return 1;
+}
+
+
+static struct set_elem *json_parse_set_elem(struct json_ctx *ctx, json_t *root);
+
 static struct expr *json_parse_set_expr(struct json_ctx *ctx,
 					const char *type, json_t *root)
 {
 	struct expr *expr, *set_expr = NULL;
+	struct set_elem *elem;
 	json_t *value;
 	size_t index;
 
@@ -1473,32 +1492,40 @@ static struct expr *json_parse_set_expr(struct json_ctx *ctx,
 		    expr->symtype == SYMBOL_SET)
 			return expr;
 
-		expr = set_elem_expr_alloc(int_loc, expr);
+		elem = set_elem_alloc(expr);
 		set_expr = set_expr_alloc(int_loc, NULL);
-		set_expr_add(set_expr, expr);
+		set_expr_add(set_expr, elem);
 		return set_expr;
 	}
 
 	json_array_foreach(root, index, value) {
-		struct expr *expr, *elem;
 		json_t *jleft, *jright;
+		struct set_elem *elem;
+		struct expr *expr;
 
 		if (!json_unpack(value, "[o, o!]", &jleft, &jright)) {
 			struct expr *expr2;
-
-			expr = json_parse_rhs_expr(ctx, jleft);
-			if (!expr) {
-				json_error(ctx, "Invalid set elem at index %zu.", index);
-				expr_free(set_expr);
-				return NULL;
-			}
-
-			if (expr->etype != EXPR_SET_ELEM) {
-				elem = set_elem_expr_alloc(int_loc, expr);
+			const char *key;
+			json_t *val;
+
+			if (!json_unpack_elem(ctx, jleft, &key, &val) &&
+			    !strcmp(key, "elem")) {
+				elem = json_parse_set_elem(ctx, val);
+				if (!elem) {
+					json_error(ctx, "Invalid set elem at index %zu.", index);
+					expr_free(set_expr);
+					return NULL;
+				}
 			} else {
-				elem = expr;
-				expr = expr->key;
+				expr = json_parse_rhs_expr(ctx, jleft);
+				if (!expr) {
+					json_error(ctx, "Invalid set elem at index %zu.", index);
+					expr_free(set_expr);
+					return NULL;
+				}
+				elem = set_elem_alloc(expr);
 			}
+			expr = elem->key;
 
 			expr2 = json_parse_set_rhs_expr(ctx, jright);
 			if (!expr2) {
@@ -1509,23 +1536,32 @@ static struct expr *json_parse_set_expr(struct json_ctx *ctx,
 			}
 			expr2 = mapping_expr_alloc(int_loc, expr, expr2);
 			elem->key = expr2;
-			expr = elem;
 		} else {
-			expr = json_parse_rhs_expr(ctx, value);
-
-			if (!expr) {
-				json_error(ctx, "Invalid set elem at index %zu.", index);
-				expr_free(set_expr);
-				return NULL;
+			const char *key;
+			json_t *val;
+
+			if (!json_unpack_elem(ctx, value, &key, &val) &&
+			    !strcmp(key, "elem")) {
+				elem = json_parse_set_elem(ctx, val);
+				if (!elem) {
+					json_error(ctx, "Invalid set elem at index %zu.", index);
+					expr_free(set_expr);
+					return NULL;
+				}
+			} else {
+				expr = json_parse_rhs_expr(ctx, value);
+				if (!expr) {
+	                                json_error(ctx, "Invalid set elem at index %zu.", index);
+					expr_free(set_expr);
+	                                return NULL;
+	                        }
+				elem = set_elem_alloc(expr);
 			}
-
-			if (expr->etype != EXPR_SET_ELEM)
-				expr = set_elem_expr_alloc(int_loc, expr);
 		}
 
 		if (!set_expr)
 			set_expr = set_expr_alloc(int_loc, NULL);
-		set_expr_add(set_expr, expr);
+		set_elem_add(set_expr, elem);
 	}
 	return set_expr;
 }
@@ -1556,30 +1592,27 @@ static struct expr *json_parse_map_expr(struct json_ctx *ctx,
 	return map_expr_alloc(int_loc, key, data);
 }
 
-static struct expr *json_parse_set_elem_expr(struct json_ctx *ctx,
-					     const char *type, json_t *root)
+static struct set_elem *json_parse_set_elem_expr(struct json_ctx *ctx, json_t *root)
 {
+	struct set_elem *elem;
+	const char *comment;
 	struct expr *expr;
-	json_t *tmp;
 	uint64_t i;
 
-	if (json_unpack_err(ctx, root, "{s:o}", "val", &tmp))
-		return NULL;
-
-	expr = json_parse_expr(ctx, tmp);
+	expr = json_parse_expr(ctx, root);
 	if (!expr)
 		return NULL;
 
-	expr = set_elem_expr_alloc(int_loc, expr);
+	elem = set_elem_alloc(expr);
 
 	if (!json_unpack(root, "{s:I}", "timeout", &i))
-		expr->timeout = i * 1000;
+		elem->timeout = i * 1000;
 	if (!json_unpack(root, "{s:I}", "expires", &i))
-		expr->expiration = i * 1000;
-	if (!json_unpack(root, "{s:s}", "comment", &expr->comment))
-		expr->comment = xstrdup(expr->comment);
+		elem->expiration = i * 1000;
+	if (!json_unpack(root, "{s:s}", "comment", &comment))
+		elem->comment = xstrdup(comment);
 
-	return expr;
+	return elem;
 }
 
 static struct expr *json_parse_xfrm_expr(struct json_ctx *ctx,
@@ -1685,7 +1718,7 @@ static struct expr *json_parse_expr(struct json_ctx *ctx, json_t *root)
 		{ "jump", json_parse_verdict_expr, CTX_F_RHS | CTX_F_SET_RHS },
 		{ "goto", json_parse_verdict_expr, CTX_F_RHS | CTX_F_SET_RHS },
 		{ "return", json_parse_verdict_expr, CTX_F_RHS | CTX_F_SET_RHS },
-		{ "elem", json_parse_set_elem_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SES },
+//		{ "elem", json_parse_set_elem_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SES },
 	};
 	struct expr *list;
 	const char *type;
@@ -1792,14 +1825,9 @@ static struct expr *json_parse_mangle_lhs_expr(struct json_ctx *ctx, json_t *roo
 	return json_parse_flagged_expr(ctx, CTX_F_MANGLE, root);
 }
 
-static struct expr *json_parse_set_elem_expr_stmt(struct json_ctx *ctx, json_t *root)
+static struct set_elem *json_parse_set_elem_expr_stmt(struct json_ctx *ctx, json_t *root)
 {
-	struct expr *expr = json_parse_flagged_expr(ctx, CTX_F_SES, root);
-
-	if (expr && expr->etype != EXPR_SET_ELEM)
-		expr = set_elem_expr_alloc(int_loc, expr);
-
-	return expr;
+	return json_parse_set_elem_expr(ctx, root);
 }
 
 static struct expr *json_parse_map_lhs_expr(struct json_ctx *ctx, json_t *root)
@@ -2481,9 +2509,10 @@ static int json_parse_set_stmt_list(struct json_ctx *ctx,
 static struct stmt *json_parse_set_stmt(struct json_ctx *ctx,
 					const char *key, json_t *value)
 {
-	const char *opstr, *set;
-	struct expr *expr, *expr2;
+	struct set_elem *set_elem;
 	json_t *elem, *stmt_json;
+	const char *opstr, *set;
+	struct expr *expr2;
 	struct stmt *stmt;
 	int op;
 
@@ -2502,22 +2531,22 @@ static struct stmt *json_parse_set_stmt(struct json_ctx *ctx,
 		return NULL;
 	}
 
-	expr = json_parse_set_elem_expr_stmt(ctx, elem);
-	if (!expr) {
+	set_elem = json_parse_set_elem_expr_stmt(ctx, elem);
+	if (!set_elem) {
 		json_error(ctx, "Illegal set statement element.");
 		return NULL;
 	}
 
 	if (set[0] != '@') {
 		json_error(ctx, "Illegal set reference in set statement.");
-		expr_free(expr);
+		set_elem_free(set_elem);
 		return NULL;
 	}
 	expr2 = symbol_expr_alloc(int_loc, SYMBOL_SET, NULL, set + 1);
 
 	stmt = set_stmt_alloc(int_loc);
 	stmt->set.op = op;
-	stmt->set.key = expr;
+	stmt->set.key = set_elem;
 	stmt->set.set = expr2;
 
 	if (!json_unpack(value, "{s:o}", "stmt", &stmt_json) &&
@@ -2532,9 +2561,10 @@ static struct stmt *json_parse_set_stmt(struct json_ctx *ctx,
 static struct stmt *json_parse_map_stmt(struct json_ctx *ctx,
 					const char *key, json_t *value)
 {
-	struct expr *expr, *expr2, *expr_data;
+	struct set_elem *set_elem, *elem_data;
 	json_t *elem, *data, *stmt_json;
 	const char *opstr, *set;
+	struct expr *expr2;
 	struct stmt *stmt;
 	int op;
 
@@ -2553,31 +2583,31 @@ static struct stmt *json_parse_map_stmt(struct json_ctx *ctx,
 		return NULL;
 	}
 
-	expr = json_parse_set_elem_expr_stmt(ctx, elem);
-	if (!expr) {
+	set_elem = json_parse_set_elem_expr_stmt(ctx, elem);
+	if (!set_elem) {
 		json_error(ctx, "Illegal map statement element.");
 		return NULL;
 	}
 
-	expr_data = json_parse_set_elem_expr_stmt(ctx, data);
-	if (!expr_data) {
+	elem_data = json_parse_set_elem_expr_stmt(ctx, data);
+	if (!elem_data) {
 		json_error(ctx, "Illegal map expression data.");
-		expr_free(expr);
+		set_elem_free(set_elem);
 		return NULL;
 	}
 
 	if (set[0] != '@') {
 		json_error(ctx, "Illegal map reference in map statement.");
-		expr_free(expr);
-		expr_free(expr_data);
+		set_elem_free(set_elem);
+		set_elem_free(elem_data);
 		return NULL;
 	}
 	expr2 = symbol_expr_alloc(int_loc, SYMBOL_SET, NULL, set + 1);
 
 	stmt = map_stmt_alloc(int_loc);
 	stmt->map.op = op;
-	stmt->map.key = expr;
-	stmt->map.data = expr_data;
+	stmt->map.key = set_elem;
+	stmt->map.data = elem_data;
 	stmt->map.set = expr2;
 
 	if (!json_unpack(value, "{s:o}", "stmt", &stmt_json) &&
@@ -2796,8 +2826,8 @@ static struct stmt *json_parse_meter_stmt(struct json_ctx *ctx,
 	stmt->meter.name = xstrdup(name);
 	stmt->meter.size = size;
 
-	stmt->meter.key = json_parse_set_elem_expr_stmt(ctx, jkey);
-	if (!stmt->meter.key) {
+	stmt->meter.elem = json_parse_set_elem_expr_stmt(ctx, jkey);
+	if (!stmt->meter.elem) {
 		json_error(ctx, "Invalid meter key.");
 		stmt_free(stmt);
 		return NULL;
@@ -2934,8 +2964,9 @@ static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root)
 	unsigned int i;
 	json_t *tmp;
 
-	if (json_unpack_stmt(ctx, root, &type, &tmp))
+	if (json_unpack_stmt(ctx, root, &type, &tmp)) {
 		return NULL;
+	}
 
 	/* Yes, verdict_map_stmt is actually an expression */
 	if (!strcmp(type, "vmap")) {
@@ -2962,6 +2993,47 @@ static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root)
 	return NULL;
 }
 
+static struct set_elem *json_parse_set_elem(struct json_ctx *ctx, json_t *root)
+{
+	struct {
+		const char *key;
+		struct stmt *(*cb)(struct json_ctx *, const char *, json_t *);
+	} set_elem_parser_tbl[] = {
+		{ "counter", json_parse_counter_stmt },
+		{ "limit", json_parse_limit_stmt },
+		{ "quota", json_parse_quota_stmt },
+		{ "connlimit", json_parse_connlimit_stmt },
+		{ "last", json_parse_last_stmt },
+	};
+	struct set_elem *elem = NULL;
+	struct stmt *stmt;
+	const char *key;
+	unsigned int i;
+	json_t *val;
+
+	json_object_foreach(root, key, val) {
+		if (!strcmp(key, "val")) {
+			elem = json_parse_set_elem_expr(ctx, val);
+			if (!elem)
+				return NULL;
+		} else if (elem) {
+			for (i = 0; i < array_size(set_elem_parser_tbl); i++) {
+				if (!strcmp(key, set_elem_parser_tbl[i].key)) {
+					stmt = set_elem_parser_tbl[i].cb(ctx, key, val);
+					if (!stmt)
+						return NULL;
+
+					list_add_tail(&stmt->list, &elem->stmt_list);
+				}
+			}
+		} else {
+			return NULL;
+		}
+	}
+
+	return elem;
+}
+
 static struct cmd *json_parse_cmd_add_table(struct json_ctx *ctx, json_t *root,
 					    enum cmd_ops op, enum cmd_obj obj)
 {
diff --git a/src/payload.c b/src/payload.c
index 162367eb7fd0..0664a95b7268 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -1525,6 +1525,7 @@ __payload_gen_icmp_echo_dependency(struct eval_ctx *ctx, const struct expr *expr
 				   const struct proto_desc *desc)
 {
 	struct expr *left, *right, *dep, *set;
+	struct set_elem *elem;
 
 	left = payload_expr_alloc(&expr->location, desc, desc->protocol_key);
 
@@ -1533,14 +1534,14 @@ __payload_gen_icmp_echo_dependency(struct eval_ctx *ctx, const struct expr *expr
 	right = constant_expr_alloc(&expr->location, icmp_type,
 				    BYTEORDER_BIG_ENDIAN, BITS_PER_BYTE,
 				    constant_data_ptr(echo, BITS_PER_BYTE));
-	right = set_elem_expr_alloc(&expr->location, right);
-	set_expr_add(set, right);
+	elem = set_elem_alloc(right);
+	set_expr_add(set, elem);
 
 	right = constant_expr_alloc(&expr->location, icmp_type,
 				    BYTEORDER_BIG_ENDIAN, BITS_PER_BYTE,
 				    constant_data_ptr(reply, BITS_PER_BYTE));
-	right = set_elem_expr_alloc(&expr->location, right);
-	set_expr_add(set, right);
+	elem = set_elem_alloc(right);
+	set_expr_add(set, elem);
 
 	dep = relational_expr_alloc(&expr->location, OP_IMPLICIT, left, set);
 	return expr_stmt_alloc(&dep->location, dep);
@@ -1559,6 +1560,7 @@ __payload_gen_icmp6_addr_dependency(struct eval_ctx *ctx, const struct expr *exp
 		ND_REDIRECT
 	};
 	struct expr *left, *right, *dep, *set;
+	struct set_elem *elem;
 	size_t i;
 
 	left = payload_expr_alloc(&expr->location, desc, desc->protocol_key);
@@ -1570,8 +1572,8 @@ __payload_gen_icmp6_addr_dependency(struct eval_ctx *ctx, const struct expr *exp
 					    BYTEORDER_BIG_ENDIAN, BITS_PER_BYTE,
 					    constant_data_ptr(icmp_addr_types[i],
 							      BITS_PER_BYTE));
-		right = set_elem_expr_alloc(&expr->location, right);
-		set_expr_add(set, right);
+		elem = set_elem_alloc(right);
+		set_expr_add(set, elem);
 	}
 
 	dep = relational_expr_alloc(&expr->location, OP_IMPLICIT, left, set);
diff --git a/src/segtree.c b/src/segtree.c
index 1dc94688aee1..8b11f1eeda27 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -19,6 +19,7 @@
 #include <expression.h>
 #include <gmputil.h>
 #include <utils.h>
+#include <elem.h>
 
 static enum byteorder get_key_byteorder(const struct expr *e)
 {
@@ -41,11 +42,8 @@ static enum byteorder get_key_byteorder(const struct expr *e)
 	return BYTEORDER_INVALID;
 }
 
-static void interval_expr_copy(struct expr *dst, struct expr *src)
+static void interval_expr_copy(struct set_elem *dst, struct set_elem *src)
 {
-	assert(dst->etype == EXPR_SET_ELEM);
-	assert(src->etype == EXPR_SET_ELEM);
-
 	if (src->comment)
 		dst->comment = xstrdup(src->comment);
 	if (src->timeout)
@@ -59,15 +57,16 @@ static void interval_expr_copy(struct expr *dst, struct expr *src)
 static void set_elem_expr_add(const struct set *set, struct expr *init,
 			      mpz_t value, uint32_t flags, enum byteorder byteorder)
 {
+	struct set_elem *elem;
 	struct expr *expr;
 
 	expr = constant_expr_alloc(&internal_location, set->key->dtype,
 				   byteorder, set->key->len, NULL);
 	mpz_set(expr->value, value);
-	expr = set_elem_expr_alloc(&internal_location, expr);
-	expr->key->flags = flags;
+	elem = set_elem_alloc(expr);
+	elem->key->flags = flags;
 
-	set_expr_add(init, expr);
+	set_elem_add(init, elem);
 }
 
 struct expr *get_set_intervals(const struct set *set, const struct expr *init)
@@ -75,7 +74,7 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 	enum byteorder byteorder = get_key_byteorder(set->key);
 	mpz_t low, high, mask;
 	struct expr *new_init;
-	struct expr *i;
+	struct set_elem *i;
 
 	mpz_init2(low, set->key->len);
 	mpz_init2(high, set->key->len);
@@ -83,21 +82,19 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 
 	new_init = set_expr_alloc(&internal_location, NULL);
 
-	list_for_each_entry(i, &expr_set(init)->expressions, list) {
-		assert(i->etype == EXPR_SET_ELEM);
-
+	list_for_each_entry(i, &expr_set(init)->elems, list) {
 		switch (i->key->etype) {
 		case EXPR_VALUE:
 			set_elem_expr_add(set, new_init, i->key->value,
 					  i->key->flags, byteorder);
 			break;
 		case EXPR_CONCAT:
-			set_expr_add(new_init, expr_clone(i));
+			set_elem_add(new_init, set_elem_clone(i));
 			i->key->flags |= EXPR_F_INTERVAL_END;
-			set_expr_add(new_init, expr_clone(i));
+			set_elem_add(new_init, set_elem_clone(i));
 			break;
 		case EXPR_SET_ELEM_CATCHALL:
-			set_expr_add(new_init, expr_clone(i));
+			set_elem_add(new_init, set_elem_clone(i));
 			break;
 		case EXPR_PREFIX:
 		case EXPR_RANGE:
@@ -106,7 +103,7 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 			range_expr_value_low(low, i->key);
 			set_elem_expr_add(set, new_init, low, 0, byteorder);
 			range_expr_value_high(high, i->key);
-			mpz_bitmask(mask, i->len);
+			mpz_bitmask(mask, i->key->len);
 			if (set_is_non_concat_range(set) &&
 			    !mpz_cmp(mask, high))
 				break;
@@ -128,33 +125,27 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 	return new_init;
 }
 
-static struct expr *expr_value(struct expr *expr)
+static struct expr *expr_value(struct set_elem *elem)
 {
-	assert(expr->etype == EXPR_SET_ELEM);
-
-	if (expr->key->etype == EXPR_MAPPING)
-		return expr->key->left;
+	if (elem->key->etype == EXPR_MAPPING)
+		return elem->key->left;
 
-	return expr->key;
+	return elem->key;
 }
 
-static struct expr *get_set_interval_find(const struct set *cache_set,
-					  struct expr *left,
-					  struct expr *right)
+static struct set_elem *get_set_interval_find(const struct set *cache_set,
+					      struct set_elem *left,
+					      struct set_elem *right)
 {
 	const struct set *set = cache_set;
-	struct expr *range = NULL;
-	struct expr *i, *key;
+	struct set_elem *range = NULL;
+	struct set_elem *i;
+	struct expr *key;
 	mpz_t val;
 
-	assert(left->etype == EXPR_SET_ELEM);
-	assert(!right || right->etype == EXPR_SET_ELEM);
-
 	mpz_init2(val, set->key->len);
 
-	list_for_each_entry(i, &expr_set(set->init)->expressions, list) {
-		assert(i->etype == EXPR_SET_ELEM);
-
+	list_for_each_entry(i, &expr_set(set->init)->elems, list) {
 		key = expr_value(i);
 		switch (key->etype) {
 		case EXPR_VALUE:
@@ -172,7 +163,7 @@ static struct expr *get_set_interval_find(const struct set *cache_set,
 			if (right && mpz_cmp(expr_value(right)->value, val))
 				break;
 
-			range = expr_clone(i);
+			range = set_elem_clone(i);
 			goto out;
 		default:
 			break;
@@ -184,72 +175,63 @@ out:
 	return range;
 }
 
-static struct expr *__expr_to_set_elem(struct expr *low, struct expr *expr)
+static struct set_elem *__expr_to_set_elem(struct set_elem *low, struct expr *expr)
 {
-	struct expr *elem;
-
-	assert(low->etype == EXPR_SET_ELEM);
+	struct set_elem *elem;
 
 	if (low->key->etype == EXPR_MAPPING) {
-		expr = mapping_expr_alloc(&low->location, expr,
+		expr = mapping_expr_alloc(&low->key->location, expr,
 					  expr_clone(low->key->right));
 	}
 
-	elem = set_elem_expr_alloc(&low->location, expr);
+	elem = set_elem_alloc(expr);
 	elem->key->flags |= EXPR_F_KERNEL;
 	interval_expr_copy(elem, low);
 
 	return elem;
 }
 
-static struct expr *expr_to_set_elem(struct expr *e)
+static struct set_elem *expr_to_set_elem(struct set_elem *e)
 {
-	unsigned int len = div_round_up(e->len, BITS_PER_BYTE);
+	unsigned int len = div_round_up(e->key->len, BITS_PER_BYTE);
 	struct expr *expr, *key;
 	unsigned int str_len;
 	char data[len + 1];
 
-	assert(e->etype == EXPR_SET_ELEM);
-
 	key = expr_value(e);
 	if (expr_basetype(key)->type != TYPE_STRING)
-		return expr_clone(e);
+		return set_elem_clone(e);
 
 	mpz_export_data(data, key->value, BYTEORDER_BIG_ENDIAN, len);
 
 	str_len = strnlen(data, len);
 	if (str_len >= len || str_len == 0)
-		return expr_clone(e);
+		return set_elem_clone(e);
 
 	data[str_len] = '*';
 
-	expr = constant_expr_alloc(&e->location, e->dtype,
+	expr = constant_expr_alloc(&e->key->location, e->key->dtype,
 				   BYTEORDER_HOST_ENDIAN,
 				   (str_len + 1) * BITS_PER_BYTE, data);
 
 	return __expr_to_set_elem(e, expr);
 }
 
-static void set_expr_add_splice(struct expr *compound, struct expr *expr, struct expr *orig)
+static void set_elem_add_splice(struct expr *compound, struct set_elem *elem, struct set_elem *orig)
 {
-	assert(expr->etype == EXPR_SET_ELEM);
-	assert(orig->etype == EXPR_SET_ELEM);
-
-	list_splice_init(&orig->stmt_list, &expr->stmt_list);
-	set_expr_add(compound, expr);
+	list_splice_init(&orig->stmt_list, &elem->stmt_list);
+	set_elem_add(compound, elem);
 }
 
 int get_set_decompose(struct set *cache_set, struct set *set)
 {
-	struct expr *i, *next, *range;
-	struct expr *left = NULL;
+	struct set_elem *i, *next, *range;
+	struct set_elem *left = NULL;
 	struct expr *new_init;
 
 	new_init = set_expr_alloc(&internal_location, set);
 
-	list_for_each_entry_safe(i, next, &expr_set(set->init)->expressions, list) {
-		assert(i->etype == EXPR_SET_ELEM);
-
+	list_for_each_entry_safe(i, next, &expr_set(set->init)->elems, list) {
 		if (i->key->flags & EXPR_F_INTERVAL_END && left) {
 			list_del(&left->list);
 			list_del(&i->list);
@@ -259,17 +241,17 @@ int get_set_decompose(struct set *cache_set, struct set *set)
 			mpz_sub_ui(i->key->value, i->key->value, 1);
 			range = get_set_interval_find(cache_set, left, i);
 			if (!range) {
-				expr_free(left);
-				expr_free(i);
+				set_elem_free(left);
+				set_elem_free(i);
 				expr_free(new_init);
 				errno = ENOENT;
 				return -1;
 			}
 
-			set_expr_add_splice(new_init, range, left);
+			set_elem_add_splice(new_init, range, left);
 
-			expr_free(left);
-			expr_free(i);
+			set_elem_free(left);
+			set_elem_free(i);
 
 			left = NULL;
 		} else {
@@ -278,9 +260,9 @@ int get_set_decompose(struct set *cache_set, struct set *set)
 							      left, NULL);
 
 				if (range)
-					set_expr_add_splice(new_init, range, left);
+					set_elem_add_splice(new_init, range, left);
 				else
-					set_expr_add_splice(new_init,
+					set_elem_add_splice(new_init,
 							      expr_to_set_elem(left), left);
 			}
 			left = i;
@@ -289,9 +271,9 @@ int get_set_decompose(struct set *cache_set, struct set *set)
 	if (left) {
 		range = get_set_interval_find(cache_set, left, NULL);
 		if (range)
-			set_expr_add_splice(new_init, range, left);
+			set_elem_add_splice(new_init, range, left);
 		else
-			set_expr_add_splice(new_init, expr_to_set_elem(left), left);
+			set_elem_add_splice(new_init, expr_to_set_elem(left), left);
 	}
 
 	expr_free(set->init);
@@ -315,14 +297,11 @@ static bool range_is_prefix(const mpz_t range)
 
 static int expr_value_cmp(const void *p1, const void *p2)
 {
-	struct expr *e1 = *(void * const *)p1;
-	struct expr *e2 = *(void * const *)p2;
+	struct set_elem *e1 = *(void * const *)p1;
+	struct set_elem *e2 = *(void * const *)p2;
 	struct expr *key_e1, *key_e2;
 	int ret;
 
-	assert(e1->etype == EXPR_SET_ELEM);
-	assert(e2->etype == EXPR_SET_ELEM);
-
 	key_e1 = expr_value(e1);
 	if (key_e1->etype == EXPR_CONCAT)
 		return -1;
@@ -375,14 +354,14 @@ static int range_mask_len(const mpz_t start, const mpz_t end, unsigned int len)
  */
 void concat_range_aggregate(struct expr *set)
 {
-	struct expr *i, *start, *end, *prev = NULL, *r1, *r2, *next, *r1_next, *tmp;
+	struct set_elem *i, *next, *prev = NULL;
+	struct expr *r1, *r2, *r1_next, *tmp;
 	struct list_head *r2_next;
+	struct expr *start, *end;
 	int prefix_len, free_r1;
 	mpz_t range, p;
 
-	list_for_each_entry_safe(i, next, &expr_set(set)->expressions, list) {
-		assert(i->etype == EXPR_SET_ELEM);
-
+	list_for_each_entry_safe(i, next, &expr_set(set)->elems, list) {
 		if (!prev) {
 			prev = i;
 			continue;
@@ -494,23 +473,20 @@ next:
 		}
 
 		set_expr_remove(set, prev);
-		expr_free(prev);
+		set_elem_free(prev);
 		prev = NULL;
 	}
 }
 
-static struct expr *interval_to_prefix(struct expr *low, struct expr *i, const mpz_t range)
+static struct set_elem *interval_to_prefix(struct set_elem *low, struct set_elem *i, const mpz_t range)
 {
 	unsigned int prefix_len;
 	struct expr *prefix;
 	struct expr *key;
 
-	assert(low->etype == EXPR_SET_ELEM);
-	assert(i->etype == EXPR_SET_ELEM);
-
 	key = expr_value(i);
 	prefix_len = key->len - mpz_scan0(range, 0);
-	prefix = prefix_expr_alloc(&low->location,
+	prefix = prefix_expr_alloc(&low->key->location,
 				   expr_clone(expr_value(low)),
 						   prefix_len);
 	prefix->len = key->len;
@@ -518,21 +494,18 @@ static struct expr *interval_to_prefix(struct expr *low, struct expr *i, const m
 	return __expr_to_set_elem(low, prefix);
 }
 
-static struct expr *interval_to_string(struct expr *low, struct expr *i, const mpz_t range)
+static struct set_elem *interval_to_string(struct set_elem *low, struct set_elem *i, const mpz_t range)
 {
-	unsigned int len = div_round_up(i->len, BITS_PER_BYTE);
+	unsigned int len = div_round_up(i->key->len, BITS_PER_BYTE);
 	unsigned int prefix_len, str_len;
 	char data[len + 2];
 	struct expr *expr;
 	struct expr *key;
 
-	assert(low->etype == EXPR_SET_ELEM);
-	assert(i->etype == EXPR_SET_ELEM);
-
 	key = expr_value(i);
 	prefix_len = key->len - mpz_scan0(range, 0);
 
-	if (prefix_len > i->len || prefix_len % BITS_PER_BYTE)
+	if (prefix_len > i->key->len || prefix_len % BITS_PER_BYTE)
 		return interval_to_prefix(low, i, range);
 
 	mpz_export_data(data, expr_value(low)->value, BYTEORDER_BIG_ENDIAN, len);
@@ -543,42 +516,37 @@ static struct expr *interval_to_string(struct expr *low, struct expr *i, const m
 
 	data[str_len] = '*';
 
-	expr = constant_expr_alloc(&low->location, low->dtype,
+	expr = constant_expr_alloc(&low->key->location, low->key->dtype,
 				   BYTEORDER_HOST_ENDIAN,
 				   len * BITS_PER_BYTE, data);
 
 	return __expr_to_set_elem(low, expr);
 }
 
-static struct expr *interval_to_range(struct expr *low, struct expr *i, mpz_t range)
+static struct set_elem *interval_to_range(struct set_elem *low, struct set_elem *i, mpz_t range)
 {
 	struct expr *tmp, *key;
 
-	assert(low->etype == EXPR_SET_ELEM);
-	assert(i->etype == EXPR_SET_ELEM);
-
 	key = expr_value(low);
-	tmp = constant_expr_alloc(&low->location, low->dtype,
-				  low->byteorder, key->len,
+	tmp = constant_expr_alloc(&key->location, key->dtype,
+				  key->byteorder, key->len,
 				  NULL);
 
 	mpz_add(range, range, key->value);
 	mpz_set(tmp->value, range);
 
-	tmp = range_expr_alloc(&low->location, expr_clone(key), tmp);
+	tmp = range_expr_alloc(&key->location, expr_clone(key), tmp);
 
 	return __expr_to_set_elem(low, tmp);
 }
 
 static void
-add_interval(struct expr *set, struct expr *low, struct expr *i, bool closed)
+add_interval(struct expr *set, struct set_elem *low, struct set_elem *i, bool closed)
 {
-	struct expr *expr, *key;
+	struct set_elem *elem;
+	struct expr *key;
 	mpz_t range, p;
 
-	assert(low->etype == EXPR_SET_ELEM);
-	assert(i->etype == EXPR_SET_ELEM);
-
 	mpz_init(range);
 	mpz_init(p);
 
@@ -594,7 +562,7 @@ add_interval(struct expr *set, struct expr *low, struct expr *i, bool closed)
 	mpz_and(p, key->value, range);
 
 	if (!mpz_cmp_ui(range, 0)) {
-		if (expr_basetype(low)->type == TYPE_STRING)
+		if (expr_basetype(low->key)->type == TYPE_STRING)
 			mpz_switch_byteorder(key->value,
 					     key->len / BITS_PER_BYTE);
 
@@ -606,19 +574,19 @@ add_interval(struct expr *set, struct expr *low, struct expr *i, bool closed)
 				low->key = bitmask_expr_to_binops(low->key);
 		}
 		low->key->flags |= EXPR_F_KERNEL;
-		expr = expr_get(low);
+		elem = set_elem_clone(low);
 	} else if (range_is_prefix(range) && !mpz_cmp_ui(p, 0)) {
 
-		if (datatype_prefix_notation(i->dtype))
-			expr = interval_to_prefix(low, i, range);
-		else if (expr_basetype(i)->type == TYPE_STRING)
-			expr = interval_to_string(low, i, range);
+		if (datatype_prefix_notation(i->key->dtype))
+			elem = interval_to_prefix(low, i, range);
+		else if (expr_basetype(i->key)->type == TYPE_STRING)
+			elem = interval_to_string(low, i, range);
 		else
-			expr = interval_to_range(low, i, range);
+			elem = interval_to_range(low, i, range);
 	} else
-		expr = interval_to_range(low, i, range);
+		elem = interval_to_range(low, i, range);
 
-	set_expr_add(set, expr);
+	set_expr_add(set, elem);
 
 	mpz_clear(range);
 	mpz_clear(p);
@@ -626,22 +594,21 @@ add_interval(struct expr *set, struct expr *low, struct expr *i, bool closed)
 
 void interval_map_decompose(struct expr *set)
 {
-	struct expr *i, *next, *low = NULL, *end, *catchall = NULL, *key;
-	struct expr **elements, **ranges;
+	struct set_elem *low = NULL, *i, *next, *catchall = NULL, *end;
+	struct set_elem **elements, **ranges;
+	struct expr *key, *close;
 	unsigned int n, m, size;
 	bool interval;
 
 	if (expr_set(set)->size == 0)
 		return;
 
-	elements = xmalloc_array(expr_set(set)->size, sizeof(struct expr *));
-	ranges = xmalloc_array(expr_set(set)->size * 2, sizeof(struct expr *));
+	elements = xmalloc_array(expr_set(set)->size, sizeof(struct set_elem *));
+	ranges = xmalloc_array(expr_set(set)->size * 2, sizeof(struct set_elem *));
 
 	/* Sort elements */
 	n = 0;
-	list_for_each_entry_safe(i, next, &expr_set(set)->expressions, list) {
-		assert(i->etype == EXPR_SET_ELEM);
-
+	list_for_each_entry_safe(i, next, &expr_set(set)->elems, list) {
 		key = i->key;
 		if (expr_type_catchall(key)) {
 			list_del(&i->list);
@@ -660,12 +627,10 @@ void interval_map_decompose(struct expr *set)
 	for (m = 0; m < size; m++) {
 		i = elements[m];
 
-		assert(i->etype == EXPR_SET_ELEM);
-
 		if (i->key->flags & EXPR_F_INTERVAL_END)
 			interval = false;
 		else if (interval) {
-			end = expr_clone(i);
+			end = set_elem_clone(i);
 			end->key->flags |= EXPR_F_INTERVAL_END;
 			ranges[n++] = end;
 		} else
@@ -678,14 +643,12 @@ void interval_map_decompose(struct expr *set)
 	for (n = 0; n < size; n++) {
 		i = ranges[n];
 
-		assert(i->etype == EXPR_SET_ELEM);
-
 		if (low == NULL) {
 			if (i->key->flags & EXPR_F_INTERVAL_END) {
 				/*
 				 * End of interval mark
 				 */
-				expr_free(i);
+				set_elem_free(i);
 				continue;
 			} else {
 				/*
@@ -699,29 +662,29 @@ void interval_map_decompose(struct expr *set)
 		add_interval(set, low, i, true);
 
 		if (i->key->flags & EXPR_F_INTERVAL_END) {
-			expr_free(low);
+			set_elem_free(low);
 			low = NULL;
 		}
-		expr_free(i);
+		set_elem_free(i);
 	}
 
 	if (!low) /* no unclosed interval at end */
 		goto out;
 
 	key = expr_value(low);
-	i = constant_expr_alloc(&low->location, low->dtype,
-				low->byteorder, key->len, NULL);
-	mpz_bitmask(i->value, i->len);
-	i = set_elem_expr_alloc(&low->location, i);
+	close = constant_expr_alloc(&low->key->location, low->key->dtype,
+				    low->key->byteorder, key->len, NULL);
+	mpz_bitmask(close->value, close->len);
+	i = set_elem_alloc(close);
 
 	if (!mpz_cmp(i->key->value, key->value)) {
 		set_expr_add(set, low);
 	} else {
 		add_interval(set, low, i, false);
-		expr_free(low);
+		set_elem_free(low);
 	}
 
-	expr_free(i);
+	set_elem_free(i);
 
 out:
 	if (catchall) {
diff --git a/src/statement.c b/src/statement.c
index 9cfbe9b3ac94..d5a5a4d274b3 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -173,7 +173,7 @@ static void meter_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 		nft_print(octx, " ");
 	}
 	nft_print(octx, "size %u { ", stmt->meter.size);
-	expr_print(stmt->meter.key, octx);
+	set_elem_print(stmt->meter.elem, octx);
 	nft_print(octx, " ");
 
 	octx->flags |= NFT_CTX_OUTPUT_STATELESS;
@@ -186,7 +186,7 @@ static void meter_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 
 static void meter_stmt_destroy(struct stmt *stmt)
 {
-	expr_free(stmt->meter.key);
+	set_elem_free(stmt->meter.elem);
 	expr_free(stmt->meter.set);
 	stmt_free(stmt->meter.stmt);
 	free_const(stmt->meter.name);
@@ -777,7 +777,7 @@ static void set_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	nft_print(octx, "%s ", set_stmt_op_names[stmt->set.op]);
 	expr_print(stmt->set.set, octx);
 	nft_print(octx, " { ");
-	expr_print(stmt->set.key, octx);
+	set_elem_print(stmt->set.key, octx);
 	list_for_each_entry(this, &stmt->set.stmt_list, list) {
 		nft_print(octx, " ");
 		octx->flags |= NFT_CTX_OUTPUT_STATELESS;
@@ -791,7 +791,7 @@ static void set_stmt_destroy(struct stmt *stmt)
 {
 	struct stmt *this, *next;
 
-	expr_free(stmt->set.key);
+	set_elem_free(stmt->set.key);
 	expr_free(stmt->set.set);
 	list_for_each_entry_safe(this, next, &stmt->set.stmt_list, list)
 		stmt_free(this);
@@ -823,7 +823,7 @@ static void map_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	nft_print(octx, "%s ", set_stmt_op_names[stmt->map.op]);
 	expr_print(stmt->map.set, octx);
 	nft_print(octx, " { ");
-	expr_print(stmt->map.key, octx);
+	set_elem_print(stmt->map.key, octx);
 	list_for_each_entry(this, &stmt->map.stmt_list, list) {
 		nft_print(octx, " ");
 		octx->flags |= NFT_CTX_OUTPUT_STATELESS;
@@ -831,7 +831,7 @@ static void map_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 		octx->flags = flags;
 	}
 	nft_print(octx, " : ");
-	expr_print(stmt->map.data, octx);
+	set_elem_print(stmt->map.data, octx);
 	nft_print(octx, " }");
 }
 
@@ -839,8 +839,8 @@ static void map_stmt_destroy(struct stmt *stmt)
 {
 	struct stmt *this, *next;
 
-	expr_free(stmt->map.key);
-	expr_free(stmt->map.data);
+	set_elem_free(stmt->map.key);
+	set_elem_free(stmt->map.data);
 	expr_free(stmt->map.set);
 	list_for_each_entry_safe(this, next, &stmt->map.stmt_list, list)
 		stmt_free(this);
diff --git a/tests/shell/testcases/sets/0038meter_list_0 b/tests/shell/testcases/sets/0038meter_list_0
index 7c37c1d81131..020cc49583d5 100755
--- a/tests/shell/testcases/sets/0038meter_list_0
+++ b/tests/shell/testcases/sets/0038meter_list_0
@@ -20,7 +20,7 @@ expected_output="table ip t {
 		flags dynamic,timeout
 	}
 	set m {
-		type ipv4_addr
+		typeof ip saddr
 		size 128
 		flags dynamic
 	}
diff --git a/tests/shell/testcases/sets/dumps/0038meter_list_0.nft b/tests/shell/testcases/sets/dumps/0038meter_list_0.nft
index 8037dfa502b4..6cb9cfc7c475 100644
--- a/tests/shell/testcases/sets/dumps/0038meter_list_0.nft
+++ b/tests/shell/testcases/sets/dumps/0038meter_list_0.nft
@@ -6,7 +6,7 @@ table ip t {
 	}
 
 	set m {
-		type ipv4_addr
+		typeof ip saddr
 		size 128
 		flags dynamic
 	}
-- 
2.47.3

