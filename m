From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/6] datatype: add new subtypes field to account number of concat data types
Date: Fri, 12 Dec 2014 00:22:32 +0000
Message-ID: <1418343756-2886-3-git-send-email-kaber@trash.net>
References: <1418343756-2886-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57279 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965037AbaLLAWn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Dec 2014 19:22:43 -0500
In-Reply-To: <1418343756-2886-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Using the size is confusing since it usually holds the size of
the data. Add a new "subtypes" member, which holds the number
of datatypes the concat type is made of.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/datatype.h | 2 ++
 src/datatype.c     | 8 +++++---
 src/evaluate.c     | 6 ++++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 3f13dcd..50b85c3 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -115,6 +115,7 @@ enum datatype_flags {
  * @byteorder:	byteorder of type (non-basetypes only)
  * @flags:	flags
  * @size:	type size (fixed sized non-basetypes only)
+ * @subtypes:	number of subtypes (concat type)
  * @name:	type name
  * @desc:	type description
  * @basetype:	basetype for subtypes, determines type compatibilty
@@ -128,6 +129,7 @@ struct datatype {
 	enum byteorder			byteorder;
 	unsigned int			flags;
 	unsigned int			size;
+	unsigned int			subtypes;
 	const char			*name;
 	const char			*desc;
 	const struct datatype		*basetype;
diff --git a/src/datatype.c b/src/datatype.c
index 29c967b..7fc3287 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -928,10 +928,10 @@ const struct datatype *concat_type_alloc(const struct expr *expr)
 	struct expr *i;
 	char desc[256] = "concatenation of (";
 	char name[256] = "";
-	unsigned int type = 0, size = 0;
+	unsigned int type = 0, size = 0, subtypes = 0;
 
 	list_for_each_entry(i, &expr->expressions, list) {
-		if (size != 0) {
+		if (subtypes != 0) {
 			strncat(desc, ", ", sizeof(desc) - strlen(desc) - 1);
 			strncat(name, " . ", sizeof(name) - strlen(name) - 1);
 		}
@@ -940,13 +940,15 @@ const struct datatype *concat_type_alloc(const struct expr *expr)
 
 		type <<= 8;
 		type  |= i->dtype->type;
-		size++;
+		size  += i->dtype->size;
+		subtypes++;
 	}
 	strncat(desc, ")", sizeof(desc) - strlen(desc) - 1);
 
 	dtype		= dtype_alloc();
 	dtype->type	= type;
 	dtype->size	= size;
+	dtype->subtypes = subtypes;
 	dtype->name	= xstrdup(name);
 	dtype->desc	= xstrdup(desc);
 	dtype->parse	= concat_type_parse;
diff --git a/src/evaluate.c b/src/evaluate.c
index 0732660..79edf02 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -605,10 +605,10 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 {
 	const struct datatype *dtype = ctx->ectx.dtype, *tmp;
 	unsigned int type = dtype ? dtype->type : 0;
-	int off = dtype ? dtype->size: 0;
+	int off = dtype ? dtype->subtypes : 0;
 	unsigned int flags = EXPR_F_CONSTANT | EXPR_F_SINGLETON;
 	struct expr *i, *next;
-	unsigned int n;
+	unsigned int n, len = 0;
 
 	n = 1;
 	list_for_each_entry_safe(i, next, &(*expr)->expressions, list) {
@@ -624,11 +624,13 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 			return -1;
 		flags &= i->flags;
 
+		len += i->len;
 		n++;
 	}
 
 	(*expr)->flags |= flags;
 	(*expr)->dtype = concat_type_alloc(*expr);
+	(*expr)->len   = len;
 
 	if (off > 0)
 		return expr_error(ctx->msgs, *expr,
-- 
2.1.0

