Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3F226F2B2
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Oct 2025 08:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760688849; cv=none; b=jSARzo1+ECeshplaPs5Z8ewysTDXXN1AAkIZEgg3PuQv3KWc9RrpfYOKpazlPlNVKz6rINB4D3Z4Rn8cpxRG0FXf3DO/WLSO654CmArRdAexBBJMvdaRoIsaHij8JCZUXYVhaQk7azSGUrbe/8nQeVTQ3+i2cXA9jS/ha8wn+mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760688849; c=relaxed/simple;
	bh=d07fJ2siK/DduHW4EvHd2nsliQl3MR64QIshRWu8Ym8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DZQZDz70Hg6Co0bSIWMqOldDhl6yK+YB39wCkkH6Ce7s8ptUWT5mL2KTpczxJ9Ds5el6Y7PKBagSBKpsy2vK2L9wCaU6HNn/cm8sFY7pUpSeoyVHMC8Tdl/W6z9V/B5vZVMSFOUQCSiIuWxVQQWkwmNt3UoafZ9koYdTI3zReu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2F7F160329; Fri, 17 Oct 2025 10:14:05 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: add refcount asserts
Date: Fri, 17 Oct 2025 10:13:53 +0200
Message-ID: <20251017081355.23152-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

_get() functions must not be used when refcnt is 0, as expr_free()
releases expressions on 1 -> 0 transition.

Also, check that a refcount would not overflow from UINT_MAX to 0.
This helps catching use-after-free refcounting bugs even when nft
is built without ASAN support.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/rule.h   |  2 +-
 src/expression.c | 12 ++++++++++++
 src/rule.c       | 28 ++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

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
diff --git a/src/expression.c b/src/expression.c
index 019c263f187b..3e74a669c8a4 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -68,6 +68,11 @@ struct expr *expr_clone(const struct expr *expr)
 
 struct expr *expr_get(struct expr *expr)
 {
+	if (expr->refcnt == 0)
+		BUG("refcnt 0, use-after-free on type %s\n", expr_name(expr));
+	if (expr->refcnt == UINT_MAX)
+		BUG("refcnt overflow for type %s\n", expr_name(expr));
+
 	expr->refcnt++;
 	return expr;
 }
@@ -84,6 +89,10 @@ void expr_free(struct expr *expr)
 {
 	if (expr == NULL)
 		return;
+
+	if (expr->refcnt == 0)
+		BUG("refcnt 0, possible double-free on type %p %s\n",expr,  expr_name(expr));
+
 	if (--expr->refcnt > 0)
 		return;
 
@@ -343,11 +352,14 @@ static void variable_expr_clone(struct expr *new, const struct expr *expr)
 	new->scope      = expr->scope;
 	new->sym	= expr->sym;
 
+	assert(expr->sym->refcnt > 0);
+	assert(expr->sym->refcnt < UINT_MAX);
 	expr->sym->refcnt++;
 }
 
 static void variable_expr_destroy(struct expr *expr)
 {
+	assert(expr->sym->refcnt > 0);
 	expr->sym->refcnt--;
 }
 
diff --git a/src/rule.c b/src/rule.c
index d0a62a3ee002..722e48ae254b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -181,6 +181,8 @@ struct set *set_clone(const struct set *set)
 
 struct set *set_get(struct set *set)
 {
+	assert(set->refcnt > 0);
+	assert(set->refcnt < UINT_MAX);
 	set->refcnt++;
 	return set;
 }
@@ -189,6 +191,7 @@ void set_free(struct set *set)
 {
 	struct stmt *stmt, *next;
 
+	assert(set->refcnt > 0);
 	if (--set->refcnt > 0)
 		return;
 
@@ -484,12 +487,15 @@ struct rule *rule_alloc(const struct location *loc, const struct handle *h)
 
 struct rule *rule_get(struct rule *rule)
 {
+	assert(rule->refcnt > 0);
+	assert(rule->refcnt < UINT_MAX);
 	rule->refcnt++;
 	return rule;
 }
 
 void rule_free(struct rule *rule)
 {
+	assert(rule->refcnt > 0);
 	if (--rule->refcnt > 0)
 		return;
 	stmt_list_free(&rule->stmts);
@@ -606,13 +612,22 @@ struct symbol *symbol_get(const struct scope *scope, const char *identifier)
 	if (!sym)
 		return NULL;
 
+	if (sym->refcnt == 0)
+		BUG("sym->recnt is 0, use-after-free for identifier %s\n", identifier);
+
+	assert(sym->refcnt > 0);
 	sym->refcnt++;
 
+	if (sym->refcnt == UINT_MAX)
+		BUG("sym->refcnt overflow, identifier %s\n", identifier);
+
 	return sym;
 }
 
 static void symbol_put(struct symbol *sym)
 {
+	assert(sym->refcnt > 0);
+
 	if (--sym->refcnt == 0) {
 		free_const(sym->identifier);
 		expr_free(sym->expr);
@@ -732,6 +747,9 @@ struct chain *chain_alloc(void)
 
 struct chain *chain_get(struct chain *chain)
 {
+	assert(chain->refcnt > 0);
+	assert(chain->refcnt < UINT_MAX);
+
 	chain->refcnt++;
 	return chain;
 }
@@ -741,6 +759,7 @@ void chain_free(struct chain *chain)
 	struct rule *rule, *next;
 	int i;
 
+	assert(chain->refcnt > 0);
 	if (--chain->refcnt > 0)
 		return;
 	list_for_each_entry_safe(rule, next, &chain->rules, list)
@@ -1176,6 +1195,7 @@ void table_free(struct table *table)
 	struct set *set, *nset;
 	struct obj *obj, *nobj;
 
+	assert(table->refcnt > 0);
 	if (--table->refcnt > 0)
 		return;
 	if (table->comment)
@@ -1214,6 +1234,8 @@ void table_free(struct table *table)
 
 struct table *table_get(struct table *table)
 {
+	assert(table->refcnt > 0);
+	assert(table->refcnt < UINT_MAX);
 	table->refcnt++;
 	return table;
 }
@@ -1687,12 +1709,15 @@ struct obj *obj_alloc(const struct location *loc)
 
 struct obj *obj_get(struct obj *obj)
 {
+	assert(obj->refcnt > 0);
+	assert(obj->refcnt < UINT_MAX);
 	obj->refcnt++;
 	return obj;
 }
 
 void obj_free(struct obj *obj)
 {
+	assert(obj->refcnt > 0);
 	if (--obj->refcnt > 0)
 		return;
 	free_const(obj->comment);
@@ -2270,6 +2295,8 @@ struct flowtable *flowtable_alloc(const struct location *loc)
 
 struct flowtable *flowtable_get(struct flowtable *flowtable)
 {
+	assert(flowtable->refcnt > 0);
+	assert(flowtable->refcnt < UINT_MAX);
 	flowtable->refcnt++;
 	return flowtable;
 }
@@ -2278,6 +2305,7 @@ void flowtable_free(struct flowtable *flowtable)
 {
 	int i;
 
+	assert(flowtable->refcnt > 0);
 	if (--flowtable->refcnt > 0)
 		return;
 	handle_free(&flowtable->handle);
-- 
2.51.0

