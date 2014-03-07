From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/3] expr: add comparison function for singleton expressions
Date: Fri,  7 Mar 2014 10:28:40 +0100
Message-ID: <1394184521-11419-3-git-send-email-kaber@trash.net>
References: <1394184521-11419-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35818 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaCGJ2z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:28:55 -0500
In-Reply-To: <1394184521-11419-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Singed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/expression.h |  4 ++++
 src/ct.c             |  6 ++++++
 src/expression.c     | 32 ++++++++++++++++++++++++++++++++
 src/exthdr.c         |  7 +++++++
 src/meta.c           |  6 ++++++
 src/payload.c        |  9 +++++++++
 6 files changed, 64 insertions(+)

diff --git a/include/expression.h b/include/expression.h
index 354e679..d974131 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -120,6 +120,7 @@ static inline void expr_set_context(struct expr_ctx *ctx,
  * @destroy:	destructor, must release inner expressions
  * @set_type:	function to promote type and byteorder of inner types
  * @print:	function to print the expression
+ * @cmp:	function to compare two expressions of the same types
  * @pctx_update:update protocol context
  */
 struct proto_ctx;
@@ -132,6 +133,8 @@ struct expr_ops {
 					    const struct datatype *dtype,
 					    enum byteorder byteorder);
 	void			(*print)(const struct expr *expr);
+	bool			(*cmp)(const struct expr *e1,
+				       const struct expr *e2);
 	void			(*pctx_update)(struct proto_ctx *ctx,
 					       const struct expr *expr);
 };
@@ -261,6 +264,7 @@ extern struct expr *expr_clone(const struct expr *expr);
 extern struct expr *expr_get(struct expr *expr);
 extern void expr_free(struct expr *expr);
 extern void expr_print(const struct expr *expr);
+extern bool expr_cmp(const struct expr *e1, const struct expr *e2);
 extern void expr_describe(const struct expr *expr);
 
 extern const struct datatype *expr_basetype(const struct expr *expr);
diff --git a/src/ct.c b/src/ct.c
index 32f22a5..a27621e 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -204,6 +204,11 @@ static void ct_expr_print(const struct expr *expr)
 	printf("ct %s", ct_templates[expr->ct.key].token);
 }
 
+static bool ct_expr_cmp(const struct expr *e1, const struct expr *e2)
+{
+	return e1->ct.key == e2->ct.key;
+}
+
 static void ct_expr_clone(struct expr *new, const struct expr *expr)
 {
 	new->ct.key = expr->ct.key;
@@ -233,6 +238,7 @@ static const struct expr_ops ct_expr_ops = {
 	.type		= EXPR_CT,
 	.name		= "ct",
 	.print		= ct_expr_print,
+	.cmp		= ct_expr_cmp,
 	.clone		= ct_expr_clone,
 	.pctx_update	= ct_expr_pctx_update,
 };
diff --git a/src/expression.c b/src/expression.c
index cdc2b7b..1313925 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -74,6 +74,17 @@ void expr_print(const struct expr *expr)
 	expr->ops->print(expr);
 }
 
+bool expr_cmp(const struct expr *e1, const struct expr *e2)
+{
+	assert(e1->flags & EXPR_F_SINGLETON);
+	assert(e2->flags & EXPR_F_SINGLETON);
+
+	if (e1->ops->type != e2->ops->type)
+		return false;
+
+	return e1->ops->cmp(e1, e2);
+}
+
 void expr_describe(const struct expr *expr)
 {
 	const struct datatype *dtype = expr->dtype;
@@ -148,6 +159,19 @@ static void verdict_expr_print(const struct expr *expr)
 	datatype_print(expr);
 }
 
+static bool verdict_expr_cmp(const struct expr *e1, const struct expr *e2)
+{
+	if (e1->verdict != e2->verdict)
+		return false;
+
+	if ((e1->verdict == NFT_JUMP ||
+	     e1->verdict == NFT_GOTO) &&
+	    strcmp(e1->chain, e2->chain))
+		return false;
+
+	return true;
+}
+
 static void verdict_expr_clone(struct expr *new, const struct expr *expr)
 {
 	new->verdict = expr->verdict;
@@ -164,6 +188,7 @@ static const struct expr_ops verdict_expr_ops = {
 	.type		= EXPR_VERDICT,
 	.name		= "verdict",
 	.print		= verdict_expr_print,
+	.cmp		= verdict_expr_cmp,
 	.clone		= verdict_expr_clone,
 	.destroy	= verdict_expr_destroy,
 };
@@ -226,6 +251,12 @@ static void constant_expr_print(const struct expr *expr)
 	datatype_print(expr);
 }
 
+static bool constant_expr_cmp(const struct expr *e1, const struct expr *e2)
+{
+	return expr_basetype(e1) == expr_basetype(e2) &&
+	       !mpz_cmp(e1->value, e2->value);
+}
+
 static void constant_expr_clone(struct expr *new, const struct expr *expr)
 {
 	mpz_init_set(new->value, expr->value);
@@ -240,6 +271,7 @@ static const struct expr_ops constant_expr_ops = {
 	.type		= EXPR_VALUE,
 	.name		= "value",
 	.print		= constant_expr_print,
+	.cmp		= constant_expr_cmp,
 	.clone		= constant_expr_clone,
 	.destroy	= constant_expr_destroy,
 };
diff --git a/src/exthdr.c b/src/exthdr.c
index 458f9d6..a619ecc 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -27,6 +27,12 @@ static void exthdr_expr_print(const struct expr *expr)
 	printf("%s %s", expr->exthdr.desc->name, expr->exthdr.tmpl->token);
 }
 
+static bool exthdr_expr_cmp(const struct expr *e1, const struct expr *e2)
+{
+	return e1->exthdr.desc == e2->exthdr.desc &&
+	       e1->exthdr.tmpl == e2->exthdr.tmpl;
+}
+
 static void exthdr_expr_clone(struct expr *new, const struct expr *expr)
 {
 	new->exthdr.desc = expr->exthdr.desc;
@@ -37,6 +43,7 @@ static const struct expr_ops exthdr_expr_ops = {
 	.type		= EXPR_EXTHDR,
 	.name		= "exthdr",
 	.print		= exthdr_expr_print,
+	.cmp		= exthdr_expr_cmp,
 	.clone		= exthdr_expr_clone,
 };
 
diff --git a/src/meta.c b/src/meta.c
index af5c3f9..ebc0c54 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -350,6 +350,11 @@ static void meta_expr_print(const struct expr *expr)
 	}
 }
 
+static bool meta_expr_cmp(const struct expr *e1, const struct expr *e2)
+{
+	return e1->meta.key == e2->meta.key;
+}
+
 static void meta_expr_clone(struct expr *new, const struct expr *expr)
 {
 	new->meta.key = expr->meta.key;
@@ -407,6 +412,7 @@ static const struct expr_ops meta_expr_ops = {
 	.type		= EXPR_META,
 	.name		= "meta",
 	.print		= meta_expr_print,
+	.cmp		= meta_expr_cmp,
 	.clone		= meta_expr_clone,
 	.pctx_update	= meta_expr_pctx_update,
 };
diff --git a/src/payload.c b/src/payload.c
index 9f2db6d..427080c 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -40,6 +40,14 @@ static void payload_expr_print(const struct expr *expr)
 		       expr->payload.offset, expr->len);
 }
 
+static bool payload_expr_cmp(const struct expr *e1, const struct expr *e2)
+{
+	return e1->payload.desc   == e2->payload.desc &&
+	       e1->payload.tmpl   == e2->payload.tmpl &&
+	       e1->payload.base   == e2->payload.base &&
+	       e1->payload.offset == e2->payload.offset;
+}
+
 static void payload_expr_clone(struct expr *new, const struct expr *expr)
 {
 	new->payload.desc   = expr->payload.desc;
@@ -76,6 +84,7 @@ static const struct expr_ops payload_expr_ops = {
 	.type		= EXPR_PAYLOAD,
 	.name		= "payload",
 	.print		= payload_expr_print,
+	.cmp		= payload_expr_cmp,
 	.clone		= payload_expr_clone,
 	.pctx_update	= payload_expr_pctx_update,
 };
-- 
1.8.5.3

