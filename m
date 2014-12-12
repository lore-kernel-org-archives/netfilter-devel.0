From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 5/6] datatype: change concat_type_alloc() to construct type from id
Date: Fri, 12 Dec 2014 00:22:35 +0000
Message-ID: <1418343756-2886-6-git-send-email-kaber@trash.net>
References: <1418343756-2886-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57281 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965167AbaLLAWp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Dec 2014 19:22:45 -0500
In-Reply-To: <1418343756-2886-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The kernel only stored the id so we need to be able to reconstruct
the datatype from the id only.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/datatype.h |  2 +-
 src/datatype.c     | 21 ++++++++++++---------
 src/evaluate.c     | 11 ++++++-----
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index ca6ba9f..f05f987 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -212,7 +212,7 @@ extern const struct datatype icmpv6_code_type;
 extern const struct datatype icmpx_code_type;
 extern const struct datatype time_type;
 
-extern const struct datatype *concat_type_alloc(const struct expr *expr);
+extern const struct datatype *concat_type_alloc(uint32_t type);
 extern void concat_type_destroy(const struct datatype *dtype);
 
 #endif /* NFTABLES_DATATYPE_H */
diff --git a/src/datatype.c b/src/datatype.c
index b63d96d..cfb63b7 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -923,25 +923,28 @@ static struct datatype *dtype_alloc(void)
 	return dtype;
 }
 
-const struct datatype *concat_type_alloc(const struct expr *expr)
+const struct datatype *concat_type_alloc(uint32_t type)
 {
+	const struct datatype *i;
 	struct datatype *dtype;
-	struct expr *i;
 	char desc[256] = "concatenation of (";
 	char name[256] = "";
-	unsigned int type = 0, size = 0, subtypes = 0;
+	unsigned int size = 0, subtypes = 0, n;
+
+	n = div_round_up(fls(type), TYPE_BITS);
+	while ((type >> TYPE_BITS * --n) & TYPE_MASK) {
+		i = datatype_lookup((type >> TYPE_BITS * n) & TYPE_MASK);
+		if (i == NULL)
+			return NULL;
 
-	list_for_each_entry(i, &expr->expressions, list) {
 		if (subtypes != 0) {
 			strncat(desc, ", ", sizeof(desc) - strlen(desc) - 1);
 			strncat(name, " . ", sizeof(name) - strlen(name) - 1);
 		}
-		strncat(desc, i->dtype->desc, sizeof(desc) - strlen(desc) - 1);
-		strncat(name, i->dtype->name, sizeof(name) - strlen(name) - 1);
+		strncat(desc, i->desc, sizeof(desc) - strlen(desc) - 1);
+		strncat(name, i->name, sizeof(name) - strlen(name) - 1);
 
-		type <<= TYPE_BITS;
-		type  |= i->dtype->type;
-		size  += i->dtype->size;
+		size += i->size;
 		subtypes++;
 	}
 	strncat(desc, ")", sizeof(desc) - strlen(desc) - 1);
diff --git a/src/evaluate.c b/src/evaluate.c
index 9cb2376..8f0acf7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -604,11 +604,11 @@ static int list_member_evaluate(struct eval_ctx *ctx, struct expr **expr)
 static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 {
 	const struct datatype *dtype = ctx->ectx.dtype, *tmp;
-	unsigned int type = dtype ? dtype->type : 0;
+	uint32_t type = dtype ? dtype->type : 0, ntype = 0;
 	int off = dtype ? dtype->subtypes : 0;
 	unsigned int flags = EXPR_F_CONSTANT | EXPR_F_SINGLETON;
 	struct expr *i, *next;
-	unsigned int n, len = 0;
+	unsigned int n;
 
 	n = 1;
 	list_for_each_entry_safe(i, next, &(*expr)->expressions, list) {
@@ -624,13 +624,14 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 			return -1;
 		flags &= i->flags;
 
-		len += i->len;
+		ntype <<= TYPE_BITS;
+		ntype  |= i->dtype->type;
 		n++;
 	}
 
 	(*expr)->flags |= flags;
-	(*expr)->dtype = concat_type_alloc(*expr);
-	(*expr)->len   = len;
+	(*expr)->dtype = concat_type_alloc(ntype);
+	(*expr)->len   = (*expr)->dtype->size;
 
 	if (off > 0)
 		return expr_error(ctx->msgs, *expr,
-- 
2.1.0

