From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/3] expr: make expr_binary_error() usable outside of evaluation
Date: Fri,  7 Mar 2014 10:28:39 +0100
Message-ID: <1394184521-11419-2-git-send-email-kaber@trash.net>
References: <1394184521-11419-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35820 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaCGJ2z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:28:55 -0500
In-Reply-To: <1394184521-11419-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Turn the eval_ctx argument into a list_head to queue the error to.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/expression.h | 6 +++---
 src/expression.c     | 4 ++--
 src/payload.c        | 8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index ac6a4f4..354e679 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -268,12 +268,12 @@ extern void expr_set_type(struct expr *expr, const struct datatype *dtype,
 			  enum byteorder byteorder);
 
 struct eval_ctx;
-extern int expr_binary_error(struct eval_ctx *ctx,
+extern int expr_binary_error(struct list_head *msgs,
 			     const struct expr *e1, const struct expr *e2,
 			     const char *fmt, ...) __gmp_fmtstring(4, 5);
 
-#define expr_error(ctx, expr, fmt, args...) \
-	expr_binary_error(ctx, expr, NULL, fmt, ## args)
+#define expr_error(msgs, expr, fmt, args...) \
+	expr_binary_error(msgs, expr, NULL, fmt, ## args)
 
 static inline bool expr_is_constant(const struct expr *expr)
 {
diff --git a/src/expression.c b/src/expression.c
index adaf6e7..cdc2b7b 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -127,7 +127,7 @@ const struct datatype *expr_basetype(const struct expr *expr)
 	return type;
 }
 
-int __fmtstring(4, 5) expr_binary_error(struct eval_ctx *ctx,
+int __fmtstring(4, 5) expr_binary_error(struct list_head *msgs,
 					const struct expr *e1, const struct expr *e2,
 					const char *fmt, ...)
 {
@@ -139,7 +139,7 @@ int __fmtstring(4, 5) expr_binary_error(struct eval_ctx *ctx,
 	if (e2 != NULL)
 		erec_add_location(erec, &e2->location);
 	va_end(ap);
-	erec_queue(erec, ctx->msgs);
+	erec_queue(erec, msgs);
 	return -1;
 }
 
diff --git a/src/payload.c b/src/payload.c
index a312e07..9f2db6d 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -154,12 +154,12 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 
 	if (expr->payload.base < h->base) {
 		if (expr->payload.base < h->base - 1)
-			return expr_error(ctx, expr,
+			return expr_error(ctx->msgs, expr,
 					  "payload base is invalid for this "
 					  "family");
 
 		if (proto_dev_type(expr->payload.desc, &type) < 0)
-			return expr_error(ctx, expr,
+			return expr_error(ctx->msgs, expr,
 					  "protocol specification is invalid "
 					  "for this family");
 
@@ -181,14 +181,14 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 		desc = &proto_inet_service;
 
 	if (desc == NULL)
-		return expr_error(ctx, expr,
+		return expr_error(ctx->msgs, expr,
 				  "ambiguous payload specification: "
 				  "no %s protocol specified",
 				  proto_base_names[expr->payload.base - 1]);
 
 	protocol = proto_find_num(desc, expr->payload.desc);
 	if (protocol < 0)
-		return expr_error(ctx, expr,
+		return expr_error(ctx->msgs, expr,
 				  "conflicting protocols specified: %s vs. %s",
 				  desc->name, expr->payload.desc->name);
 
-- 
1.8.5.3

