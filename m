Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D281264A90
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 07:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760945395; cv=none; b=iQUVRq406Fm6tWYcaUqLb9MOL17wcivqyRY8iOz2cTswFJUALYRIS2D2H2dkc4nXK94w0nKGxzOhnRkHyqKWilbi7IX6RWwXdTbd9OQyJD+dBdXG220ZDkpJmny+wV5IMg69xL9QgcRsN6/77T5zkNde4ymc3xqjfHHmJY2VTKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760945395; c=relaxed/simple;
	bh=Y+0fQZiSd8bVq+kbSzojAC/gKzo58NNGcB7zSEA2RqM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f8x7ChXfOATQL5OA3EJBELLxDd/dRm+WDWBTnqF00HJ4ek0S7M/wmqmT8Oz5BlSGkmMj52jQS6XWSQQfV6ASX4VXRbf6hkhYWseOZfch6b2GbUcfzsTewoJ00SF03FQUrKrVmUk57wt6+0KZgTZKGMZ+Kb7et5q9UOnIyUIsNYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1FCB361117; Mon, 20 Oct 2025 09:29:51 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nft] src: add and use refcount assert helper
Date: Mon, 20 Oct 2025 09:29:34 +0200
Message-ID: <20251020072937.1938-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

_get() functions must not be used when refcnt is 0, as expr_free() releases
expressions on 1 -> 0 transition.

Also, check that a refcount would not overflow from UINT_MAX to 0.
Use INT_MAX to also catch refcount leaks sooner, we don't expect 2**31
get()s on same object.

This helps catching use-after-free refcounting bugs even when nft is built
without ASAN support.

v2: Use a generic helper instead of open-coding.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/rule.h   |  2 +-
 include/utils.h  |  7 +++++++
 src/expression.c |  5 +++++
 src/rule.c       | 14 ++++++++++++++
 4 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/rule.h b/include/rule.h
index 8d2f29d09337..bcdc50cad59d 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -115,7 +115,7 @@ struct symbol {
 	struct list_head	list;
 	const char		*identifier;
 	struct expr		*expr;
-	int			refcnt;
+	unsigned int		refcnt;
 };
 
 extern void symbol_bind(struct scope *scope, const char *identifier,
diff --git a/include/utils.h b/include/utils.h
index 474c7595f7cd..3594ce6edf32 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -6,6 +6,7 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <assert.h>
+#include <limits.h>
 #include <list.h>
 #include <gmputil.h>
 
@@ -39,6 +40,12 @@
 #define __must_be_array(a) \
 	BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
 
+static inline void assert_refcount_safe(unsigned int ref)
+{
+	assert(ref > 0);
+	assert(ref < INT_MAX);
+}
+
 #define container_of(ptr, type, member) ({			\
 	typeof( ((type *)0)->member ) *__mptr = (ptr);		\
 	(type *)( (void *)__mptr - offsetof(type,member) );})
diff --git a/src/expression.c b/src/expression.c
index 019c263f187b..6c7bebe0a3d1 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -68,6 +68,7 @@ struct expr *expr_clone(const struct expr *expr)
 
 struct expr *expr_get(struct expr *expr)
 {
+	assert_refcount_safe(expr->refcnt);
 	expr->refcnt++;
 	return expr;
 }
@@ -84,6 +85,8 @@ void expr_free(struct expr *expr)
 {
 	if (expr == NULL)
 		return;
+
+	assert_refcount_safe(expr->refcnt);
 	if (--expr->refcnt > 0)
 		return;
 
@@ -343,11 +346,13 @@ static void variable_expr_clone(struct expr *new, const struct expr *expr)
 	new->scope      = expr->scope;
 	new->sym	= expr->sym;
 
+	assert_refcount_safe(expr->sym->refcnt);
 	expr->sym->refcnt++;
 }
 
 static void variable_expr_destroy(struct expr *expr)
 {
+	assert_refcount_safe(expr->sym->refcnt);
 	expr->sym->refcnt--;
 }
 
diff --git a/src/rule.c b/src/rule.c
index d0a62a3ee002..f51d605cc1ad 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -181,6 +181,7 @@ struct set *set_clone(const struct set *set)
 
 struct set *set_get(struct set *set)
 {
+	assert_refcount_safe(set->refcnt);
 	set->refcnt++;
 	return set;
 }
@@ -189,6 +190,7 @@ void set_free(struct set *set)
 {
 	struct stmt *stmt, *next;
 
+	assert_refcount_safe(set->refcnt);
 	if (--set->refcnt > 0)
 		return;
 
@@ -484,12 +486,14 @@ struct rule *rule_alloc(const struct location *loc, const struct handle *h)
 
 struct rule *rule_get(struct rule *rule)
 {
+	assert_refcount_safe(rule->refcnt);
 	rule->refcnt++;
 	return rule;
 }
 
 void rule_free(struct rule *rule)
 {
+	assert_refcount_safe(rule->refcnt);
 	if (--rule->refcnt > 0)
 		return;
 	stmt_list_free(&rule->stmts);
@@ -606,6 +610,7 @@ struct symbol *symbol_get(const struct scope *scope, const char *identifier)
 	if (!sym)
 		return NULL;
 
+	assert_refcount_safe(sym->refcnt);
 	sym->refcnt++;
 
 	return sym;
@@ -613,6 +618,7 @@ struct symbol *symbol_get(const struct scope *scope, const char *identifier)
 
 static void symbol_put(struct symbol *sym)
 {
+	assert_refcount_safe(sym->refcnt);
 	if (--sym->refcnt == 0) {
 		free_const(sym->identifier);
 		expr_free(sym->expr);
@@ -732,6 +738,7 @@ struct chain *chain_alloc(void)
 
 struct chain *chain_get(struct chain *chain)
 {
+	assert_refcount_safe(chain->refcnt);
 	chain->refcnt++;
 	return chain;
 }
@@ -741,6 +748,7 @@ void chain_free(struct chain *chain)
 	struct rule *rule, *next;
 	int i;
 
+	assert_refcount_safe(chain->refcnt);
 	if (--chain->refcnt > 0)
 		return;
 	list_for_each_entry_safe(rule, next, &chain->rules, list)
@@ -1176,6 +1184,7 @@ void table_free(struct table *table)
 	struct set *set, *nset;
 	struct obj *obj, *nobj;
 
+	assert_refcount_safe(table->refcnt);
 	if (--table->refcnt > 0)
 		return;
 	if (table->comment)
@@ -1214,6 +1223,7 @@ void table_free(struct table *table)
 
 struct table *table_get(struct table *table)
 {
+	assert_refcount_safe(table->refcnt);
 	table->refcnt++;
 	return table;
 }
@@ -1687,12 +1697,14 @@ struct obj *obj_alloc(const struct location *loc)
 
 struct obj *obj_get(struct obj *obj)
 {
+	assert_refcount_safe(obj->refcnt);
 	obj->refcnt++;
 	return obj;
 }
 
 void obj_free(struct obj *obj)
 {
+	assert_refcount_safe(obj->refcnt);
 	if (--obj->refcnt > 0)
 		return;
 	free_const(obj->comment);
@@ -2270,6 +2282,7 @@ struct flowtable *flowtable_alloc(const struct location *loc)
 
 struct flowtable *flowtable_get(struct flowtable *flowtable)
 {
+	assert_refcount_safe(flowtable->refcnt);
 	flowtable->refcnt++;
 	return flowtable;
 }
@@ -2278,6 +2291,7 @@ void flowtable_free(struct flowtable *flowtable)
 {
 	int i;
 
+	assert_refcount_safe(flowtable->refcnt);
 	if (--flowtable->refcnt > 0)
 		return;
 	handle_free(&flowtable->handle);
-- 
2.51.0

