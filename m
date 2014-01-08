From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 01/12] expr: replace PAYLOAD_PROTOCOL_EXPR by generic flag
Date: Wed,  8 Jan 2014 13:08:52 +0000
Message-ID: <1389186543-6919-2-git-send-email-kaber@trash.net>
References: <1389186543-6919-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40183 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbaAHNJL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:09:11 -0500
In-Reply-To: <1389186543-6919-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Introduce a generic flag to indicate that an expression describes the
upper layer protocol as replacement for the payload specific flag.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/expression.h      | 5 +++--
 include/payload.h         | 9 ---------
 src/netlink_delinearize.c | 2 +-
 src/payload.c             | 9 +++++----
 4 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index f0eb799..d8f2868 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -135,12 +135,14 @@ struct expr_ops {
  *
  * @EXPR_F_CONSTANT:		constant expression
  * @EXPR_F_SINGLETON:		singleton (implies primary and constant)
+ * @EXPR_F_PROTOCOL:		expressions describes upper layer protocol
  * @EXPR_F_INTERVAL_END:	set member ends an open interval
  */
 enum expr_flags {
 	EXPR_F_CONSTANT		= 0x1,
 	EXPR_F_SINGLETON	= 0x2,
-	EXPR_F_INTERVAL_END	= 0x4,
+	EXPR_F_PROTOCOL		= 0x4,
+	EXPR_F_INTERVAL_END	= 0x8,
 };
 
 #include <payload.h>
@@ -227,7 +229,6 @@ struct expr {
 			const struct payload_template	*tmpl;
 			enum payload_bases		base;
 			unsigned int			offset;
-			unsigned int			flags;
 		} payload;
 		struct {
 			/* EXPR_EXTHDR */
diff --git a/include/payload.h b/include/payload.h
index c9cc84f..fa8d82e 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -21,15 +21,6 @@ enum payload_bases {
 #define PAYLOAD_BASE_MAX	(__PAYLOAD_BASE_MAX - 1)
 
 /**
- * enum payload_expr_flags
- *
- * @PAYLOAD_PROTOCOL_EXPR:	payload expression contains upper layer protocol
- */
-enum payload_expr_flags {
-	PAYLOAD_PROTOCOL_EXPR		= 0x1,
-};
-
-/**
  * struct payload_template - template for a payload header expression
  *
  * @token:	parser token describing the header field
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index b771da5..8545273 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -622,7 +622,7 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 			 * payload expression.
 			 */
 			if (ctx->pbase == PAYLOAD_BASE_INVALID &&
-			    left->payload.flags & PAYLOAD_PROTOCOL_EXPR) {
+			    left->flags & EXPR_F_PROTOCOL) {
 				ctx->pbase = left->payload.base;
 				ctx->pdep  = nstmt;
 			} else
diff --git a/src/payload.c b/src/payload.c
index ea0d4e2..2a60a76 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -69,7 +69,6 @@ static void payload_expr_clone(struct expr *new, const struct expr *expr)
 	new->payload.tmpl   = expr->payload.tmpl;
 	new->payload.base   = expr->payload.base;
 	new->payload.offset = expr->payload.offset;
-	new->payload.flags  = expr->payload.flags;
 }
 
 static const struct expr_ops payload_expr_ops = {
@@ -92,7 +91,7 @@ struct expr *payload_expr_alloc(const struct location *loc,
 		tmpl = &desc->templates[type];
 		base = desc->base;
 		if (type == desc->protocol_key)
-			flags = PAYLOAD_PROTOCOL_EXPR;
+			flags = EXPR_F_PROTOCOL;
 	} else {
 		tmpl = &payload_unknown_template;
 		base = PAYLOAD_BASE_INVALID;
@@ -100,11 +99,13 @@ struct expr *payload_expr_alloc(const struct location *loc,
 
 	expr = expr_alloc(loc, &payload_expr_ops, tmpl->dtype,
 			  tmpl->dtype->byteorder, tmpl->len);
+	expr->flags |= flags;
+
 	expr->payload.desc   = desc;
 	expr->payload.tmpl   = tmpl;
 	expr->payload.base   = base;
 	expr->payload.offset = tmpl->offset;
-	expr->payload.flags  = flags;
+
 	return expr;
 }
 
@@ -256,7 +257,7 @@ void payload_ctx_update(struct payload_ctx *ctx, const struct expr *expr)
 	const struct expr *left = expr->left, *right = expr->right;
 	const struct payload_desc *base, *desc;
 
-	if (!(left->payload.flags & PAYLOAD_PROTOCOL_EXPR))
+	if (!(left->flags & EXPR_F_PROTOCOL))
 		return;
 
 	assert(expr->op == OP_EQ);
-- 
1.8.4.2

