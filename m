From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/3] concat: add concat subtype lookup/id helpers
Date: Sun, 11 Jan 2015 08:41:56 +0000
Message-ID: <1420965718-24339-2-git-send-email-kaber@trash.net>
References: <1420965718-24339-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54994 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbbAKImE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jan 2015 03:42:04 -0500
In-Reply-To: <1420965718-24339-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/datatype.h | 16 ++++++++++++++++
 src/datatype.c     |  4 ++--
 src/evaluate.c     |  9 +++------
 src/parser_bison.y |  3 +--
 4 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index f05f987..3c3f42f 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -215,4 +215,20 @@ extern const struct datatype time_type;
 extern const struct datatype *concat_type_alloc(uint32_t type);
 extern void concat_type_destroy(const struct datatype *dtype);
 
+static inline uint32_t concat_subtype_add(uint32_t type, uint32_t subtype)
+{
+	return type << TYPE_BITS | subtype;
+}
+
+static inline uint32_t concat_subtype_id(uint32_t type, unsigned int n)
+{
+	return (type >> TYPE_BITS * n) & TYPE_MASK;
+}
+
+static inline const struct datatype *
+concat_subtype_lookup(uint32_t type, unsigned int n)
+{
+	return datatype_lookup(concat_subtype_id(type, n));
+}
+
 #endif /* NFTABLES_DATATYPE_H */
diff --git a/src/datatype.c b/src/datatype.c
index 76f2af1..c93f76a 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -931,8 +931,8 @@ const struct datatype *concat_type_alloc(uint32_t type)
 	unsigned int size = 0, subtypes = 0, n;
 
 	n = div_round_up(fls(type), TYPE_BITS);
-	while ((type >> TYPE_BITS * --n) & TYPE_MASK) {
-		i = datatype_lookup((type >> TYPE_BITS * n) & TYPE_MASK);
+	while (concat_subtype_id(type, --n)) {
+		i = concat_subtype_lookup(type, n);
 		if (i == NULL)
 			return NULL;
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 00c6d91..53f3cf0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -612,25 +612,22 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 	int off = dtype ? dtype->subtypes : 0;
 	unsigned int flags = EXPR_F_CONSTANT | EXPR_F_SINGLETON;
 	struct expr *i, *next;
-	unsigned int n;
 
-	n = 1;
 	list_for_each_entry_safe(i, next, &(*expr)->expressions, list) {
 		if (dtype && off == 0)
 			return expr_binary_error(ctx->msgs, i, *expr,
 						 "unexpected concat component, "
 						 "expecting %s",
 						 dtype->desc);
-		tmp = datatype_lookup((type >> TYPE_BITS * --off) & TYPE_MASK);
+
+		tmp = concat_subtype_lookup(type, --off);
 		expr_set_context(&ctx->ectx, tmp, tmp->size);
 
 		if (list_member_evaluate(ctx, &i) < 0)
 			return -1;
 		flags &= i->flags;
 
-		ntype <<= TYPE_BITS;
-		ntype  |= i->dtype->type;
-		n++;
+		ntype = concat_subtype_add(ntype, i->dtype->type);
 	}
 
 	(*expr)->flags |= flags;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index b20f4de..6c46d09 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1020,8 +1020,7 @@ type_identifier		:	identifier
 						   state->msgs);
 					YYERROR;
 				}
-				$$ <<= TYPE_BITS;
-				$$ |= dtype->type;
+				$$ = concat_subtype_add($$, dtype->type);
 			}
 			;
 
-- 
2.1.0

