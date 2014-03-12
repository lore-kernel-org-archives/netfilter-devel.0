From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] src: fix expr_binary_error()-related compilation warnings
Date: Wed, 12 Mar 2014 16:53:22 +0100
Message-ID: <20140312155322.23689.60367.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36468 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754436AbaCLPxc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:53:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The commit e7b43ec0 [expr: make expr_binary_error() usable outside of e=
valuation]
seem to change expr_binary_error() interface.

Later, several compilation warning appears.

The expr_binary_error() function and expr_error() macro both expect
`struct list_head *', so I simply changed callers to send `ctx->msgs'.

[...]
src/evaluate.c: In function =E2=80=98byteorder_conversion=E2=80=99:
src/evaluate.c:166:3: warning: passing argument 1 of =E2=80=98expr_bina=
ry_error=E2=80=99 from incompatible pointer type [enabled by default]
In file included from src/evaluate.c:21:0:
include/expression.h:275:12: note: expected =E2=80=98struct list_head *=
=E2=80=99 but argument is of type =E2=80=98struct eval_ctx *=E2=80=99
src/evaluate.c: In function =E2=80=98expr_evaluate_symbol=E2=80=99:
src/evaluate.c:204:4: warning: passing argument 1 of =E2=80=98expr_bina=
ry_error=E2=80=99 from incompatible pointer type [enabled by default]
In file included from src/evaluate.c:21:0:
include/expression.h:275:12: note: expected =E2=80=98struct list_head *=
=E2=80=99 but argument is of type =E2=80=98struct eval_ctx *=E2=80=99
[...]

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/evaluate.c |   82 ++++++++++++++++++++++++++++++------------------=
--------
 1 file changed, 44 insertions(+), 38 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 0c19c9f..fff8fef 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -163,7 +163,7 @@ static int byteorder_conversion(struct eval_ctx *ct=
x, struct expr **expr,
 	if ((*expr)->byteorder =3D=3D byteorder)
 		return 0;
 	if (expr_basetype(*expr)->type !=3D TYPE_INTEGER)
-		return expr_error(ctx, *expr,
+		return expr_error(ctx->msgs, *expr,
 			 	  "Byteorder mismatch: expected %s, got %s",
 				  byteorder_names[byteorder],
 				  byteorder_names[(*expr)->byteorder]);
@@ -201,7 +201,7 @@ static int expr_evaluate_symbol(struct eval_ctx *ct=
x, struct expr **expr)
 	case SYMBOL_DEFINE:
 		sym =3D symbol_lookup((*expr)->scope, (*expr)->identifier);
 		if (sym =3D=3D NULL)
-			return expr_error(ctx, *expr,
+			return expr_error(ctx->msgs, *expr,
 					  "undefined identifier '%s'",
 					  (*expr)->identifier);
 		new =3D expr_clone(sym->expr);
@@ -228,7 +228,7 @@ static int expr_evaluate_value(struct eval_ctx *ctx=
, struct expr **expr)
 	case TYPE_INTEGER:
 		mpz_init_bitmask(mask, ctx->ectx.len);
 		if (mpz_cmp((*expr)->value, mask) > 0) {
-			expr_error(ctx, *expr,
+			expr_error(ctx->msgs, *expr,
 				   "Value %Zu exceeds valid range 0-%Zu",
 				   (*expr)->value, mask);
 			mpz_clear(mask);
@@ -240,7 +240,7 @@ static int expr_evaluate_value(struct eval_ctx *ctx=
, struct expr **expr)
 	case TYPE_STRING:
 		if (ctx->ectx.len > 0) {
 			if ((*expr)->len > ctx->ectx.len)
-				return expr_error(ctx, *expr,
+				return expr_error(ctx->msgs, *expr,
 						  "String exceeds maximum length of %u",
 						  ctx->ectx.len / BITS_PER_BYTE);
 			(*expr)->len =3D ctx->ectx.len;
@@ -281,7 +281,7 @@ static int expr_evaluate_payload(struct eval_ctx *c=
tx, struct expr **expr)
 			return -1;
 		list_add_tail(&nstmt->list, &ctx->stmt->list);
 	} else if (ctx->pctx.protocol[base].desc !=3D payload->payload.desc)
-		return expr_error(ctx, payload,
+		return expr_error(ctx->msgs, payload,
 				  "conflicting protocols specified: %s vs. %s",
 				  ctx->pctx.protocol[base].desc->name,
 				  payload->payload.desc->name);
@@ -315,17 +315,17 @@ static int expr_evaluate_prefix(struct eval_ctx *=
ctx, struct expr **expr)
 	base =3D prefix->prefix;
=20
 	if (!expr_is_constant(base))
-		return expr_error(ctx, prefix,
+		return expr_error(ctx->msgs, prefix,
 				  "Prefix expression is undefined for "
 				  "non-constant expressions");
=20
 	if (expr_basetype(base)->type !=3D TYPE_INTEGER)
-		return expr_error(ctx, prefix,
+		return expr_error(ctx->msgs, prefix,
 				  "Prefix expression is undefined for "
 				  "%s types", base->dtype->desc);
=20
 	if (prefix->prefix_len > base->len)
-		return expr_error(ctx, prefix,
+		return expr_error(ctx->msgs, prefix,
 				  "Prefix length %u is invalid for type "
 				  "of %u bits width",
 				  prefix->prefix_len, base->len);
@@ -360,11 +360,11 @@ static int expr_evaluate_range_expr(struct eval_c=
tx *ctx,
 		return -1;
=20
 	if (expr_basetype(*expr)->type !=3D TYPE_INTEGER)
-		return expr_binary_error(ctx, *expr, range,
+		return expr_binary_error(ctx->msgs, *expr, range,
 					 "Range expression is undefined for "
 					 "%s types", (*expr)->dtype->desc);
 	if (!expr_is_constant(*expr))
-		return expr_binary_error(ctx, *expr, range,
+		return expr_binary_error(ctx->msgs, *expr, range,
 					 "Range is not constant");
 	return 0;
 }
@@ -382,7 +382,8 @@ static int expr_evaluate_range(struct eval_ctx *ctx=
, struct expr **expr)
 	right =3D range->right;
=20
 	if (mpz_cmp(left->value, right->value) >=3D 0)
-		return expr_error(ctx, range, "Range has zero or negative size");
+		return expr_error(ctx->msgs, range,
+				  "Range has zero or negative size");
=20
 	range->dtype =3D left->dtype;
 	range->flags |=3D EXPR_F_CONSTANT;
@@ -487,7 +488,7 @@ static int expr_evaluate_shift(struct eval_ctx *ctx=
, struct expr **expr)
 	struct expr *op =3D *expr, *left =3D op->left, *right =3D op->right;
=20
 	if (mpz_get_uint32(right->value) >=3D left->len)
-		return expr_binary_error(ctx, right, left,
+		return expr_binary_error(ctx->msgs, right, left,
 					 "%s shift of %u bits is undefined "
 					 "for type of %u bits width",
 					 op->op =3D=3D OP_LSHIFT ? "Left" : "Right",
@@ -548,24 +549,24 @@ static int expr_evaluate_binop(struct eval_ctx *c=
tx, struct expr **expr)
 	right =3D op->right;
=20
 	if (expr_basetype(left)->type !=3D TYPE_INTEGER)
-		return expr_binary_error(ctx, left, op,
+		return expr_binary_error(ctx->msgs, left, op,
 					 "Binary operation (%s) is undefined "
 					 "for %s types",
 					 sym, left->dtype->desc);
=20
 	if (expr_is_constant(left) && !expr_is_singleton(left))
-		return expr_binary_error(ctx, left, op,
+		return expr_binary_error(ctx->msgs, left, op,
 					 "Binary operation (%s) is undefined "
 					 "for %s expressions",
 					 sym, left->ops->name);
=20
 	if (!expr_is_constant(right))
-		return expr_binary_error(ctx, right, op,
+		return expr_binary_error(ctx->msgs, right, op,
 					 "Right hand side of binary operation "
 					 "(%s) must be constant", sym);
=20
 	if (!expr_is_singleton(right))
-		return expr_binary_error(ctx, left, op,
+		return expr_binary_error(ctx->msgs, left, op,
 					 "Binary operation (%s) is undefined "
 					 "for %s expressions",
 					 sym, right->ops->name);
@@ -610,7 +611,7 @@ static int expr_evaluate_concat(struct eval_ctx *ct=
x, struct expr **expr)
 	n =3D 1;
 	list_for_each_entry_safe(i, next, &(*expr)->expressions, list) {
 		if (dtype && off =3D=3D 0)
-			return expr_binary_error(ctx, i, *expr,
+			return expr_binary_error(ctx->msgs, i, *expr,
 						 "unexpected concat component, "
 						 "expecting %s",
 						 dtype->desc);
@@ -628,7 +629,7 @@ static int expr_evaluate_concat(struct eval_ctx *ct=
x, struct expr **expr)
 	(*expr)->dtype =3D concat_type_alloc(*expr);
=20
 	if (off > 0)
-		return expr_error(ctx, *expr,
+		return expr_error(ctx->msgs, *expr,
 				  "datatype mismatch, expected %s, "
 				  "expression has type %s",
 				  dtype->desc, (*expr)->dtype->desc);
@@ -648,11 +649,11 @@ static int expr_evaluate_list(struct eval_ctx *ct=
x, struct expr **expr)
 		if (list_member_evaluate(ctx, &i) < 0)
 			return -1;
 		if (i->ops->type !=3D EXPR_VALUE)
-			return expr_error(ctx, i,
+			return expr_error(ctx->msgs, i,
 					  "List member must be a constant "
 					  "value");
 		if (i->dtype->basetype->type !=3D TYPE_BITMASK)
-			return expr_error(ctx, i,
+			return expr_error(ctx->msgs, i,
 					  "Basetype of type %s is not bitmask",
 					  i->dtype->desc);
 		mpz_ior(val, val, i->value);
@@ -677,7 +678,8 @@ static int expr_evaluate_set(struct eval_ctx *ctx, =
struct expr **expr)
 			return -1;
=20
 		if (!expr_is_constant(i))
-			return expr_error(ctx, i, "Set member is not constant");
+			return expr_error(ctx->msgs, i,
+					  "Set member is not constant");
=20
 		if (i->ops->type =3D=3D EXPR_SET) {
 			/* Merge recursive set definitions */
@@ -704,7 +706,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, =
struct expr **expr)
 	if (expr_evaluate(ctx, &map->map) < 0)
 		return -1;
 	if (expr_is_constant(map->map))
-		return expr_error(ctx, map->map,
+		return expr_error(ctx->msgs, map->map,
 				  "Map expression can not be constant");
=20
 	mappings =3D map->mappings;
@@ -730,7 +732,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, =
struct expr **expr)
 		if (expr_evaluate(ctx, &map->mappings) < 0)
 			return -1;
 		if (map->mappings->ops->type !=3D EXPR_SET_REF)
-			return expr_error(ctx, map->mappings,
+			return expr_error(ctx->msgs, map->mappings,
 					  "Expression is not a map");
 		break;
 	default:
@@ -755,7 +757,8 @@ static int expr_evaluate_mapping(struct eval_ctx *c=
tx, struct expr **expr)
 	struct set *set =3D ctx->set;
=20
 	if (set =3D=3D NULL)
-		return expr_error(ctx, mapping, "mapping outside of map context");
+		return expr_error(ctx->msgs, mapping,
+				  "mapping outside of map context");
 	if (!(set->flags & SET_F_MAP))
 		return set_error(ctx, set, "set is not a map");
=20
@@ -763,16 +766,19 @@ static int expr_evaluate_mapping(struct eval_ctx =
*ctx, struct expr **expr)
 	if (expr_evaluate(ctx, &mapping->left) < 0)
 		return -1;
 	if (!expr_is_constant(mapping->left))
-		return expr_error(ctx, mapping->left, "Key must be a constant");
+		return expr_error(ctx->msgs, mapping->left,
+				  "Key must be a constant");
 	mapping->flags |=3D mapping->left->flags & EXPR_F_SINGLETON;
=20
 	expr_set_context(&ctx->ectx, set->datatype, set->datalen);
 	if (expr_evaluate(ctx, &mapping->right) < 0)
 		return -1;
 	if (!expr_is_constant(mapping->right))
-		return expr_error(ctx, mapping->right, "Value must be a constant");
+		return expr_error(ctx->msgs, mapping->right,
+				  "Value must be a constant");
 	if (!expr_is_singleton(mapping->right))
-		return expr_error(ctx, mapping->right, "Value must be a singleton");
+		return expr_error(ctx->msgs, mapping->right,
+				  "Value must be a singleton");
=20
 	mapping->flags |=3D EXPR_F_CONSTANT;
 	return 0;
@@ -789,7 +795,7 @@ static int binop_can_transfer(struct eval_ctx *ctx,
 	switch (left->op) {
 	case OP_LSHIFT:
 		if (mpz_scan1(right->value, 0) < mpz_get_uint32(left->right->value))
-			return expr_binary_error(ctx, right, left,
+			return expr_binary_error(ctx->msgs, right, left,
 						 "Comparison is always false");
 		return 1;
 	case OP_XOR:
@@ -896,12 +902,12 @@ static int expr_evaluate_relational(struct eval_c=
tx *ctx, struct expr **expr)
 	}
=20
 	if (!expr_is_constant(right))
-		return expr_binary_error(ctx, right, rel,
+		return expr_binary_error(ctx->msgs, right, rel,
 					 "Right hand side of relational "
 					 "expression (%s) must be constant",
 					 expr_op_symbols[rel->op]);
 	if (expr_is_constant(left))
-		return expr_binary_error(ctx, left, right,
+		return expr_binary_error(ctx->msgs, left, right,
 					 "Relational expression (%s) has "
 					 "constant value",
 					 expr_op_symbols[rel->op]);
@@ -913,7 +919,7 @@ static int expr_evaluate_relational(struct eval_ctx=
 *ctx, struct expr **expr)
 			right =3D rel->right =3D
 				implicit_set_declaration(ctx, left->dtype, left->len, right);
 		else if (!datatype_equal(left->dtype, right->dtype))
-			return expr_binary_error(ctx, right, left,
+			return expr_binary_error(ctx->msgs, right, left,
 						 "datatype mismatch, expected %s, "
 						 "set has type %s",
 						 left->dtype->desc,
@@ -928,7 +934,7 @@ static int expr_evaluate_relational(struct eval_ctx=
 *ctx, struct expr **expr)
 		break;
 	case OP_EQ:
 		if (!datatype_equal(left->dtype, right->dtype))
-			return expr_binary_error(ctx, right, left,
+			return expr_binary_error(ctx->msgs, right, left,
 						 "datatype mismatch, expected %s, "
 						 "expression has type %s",
 						 left->dtype->desc,
@@ -948,7 +954,7 @@ static int expr_evaluate_relational(struct eval_ctx=
 *ctx, struct expr **expr)
 	case OP_NEQ:
 	case OP_FLAGCMP:
 		if (!datatype_equal(left->dtype, right->dtype))
-			return expr_binary_error(ctx, right, left,
+			return expr_binary_error(ctx->msgs, right, left,
 						 "datatype mismatch, expected %s, "
 						 "expression has type %s",
 						 left->dtype->desc,
@@ -974,7 +980,7 @@ static int expr_evaluate_relational(struct eval_ctx=
 *ctx, struct expr **expr)
 	case OP_LTE:
 	case OP_GTE:
 		if (!datatype_equal(left->dtype, right->dtype))
-			return expr_binary_error(ctx, right, left,
+			return expr_binary_error(ctx->msgs, right, left,
 						 "datatype mismatch, expected %s, "
 						 "expression has type %s",
 						 left->dtype->desc,
@@ -982,7 +988,7 @@ static int expr_evaluate_relational(struct eval_ctx=
 *ctx, struct expr **expr)
=20
 		switch (left->ops->type) {
 		case EXPR_CONCAT:
-			return expr_binary_error(ctx, left, rel,
+			return expr_binary_error(ctx->msgs, left, rel,
 					"Relational expression (%s) is undefined "
 				        "for %s expressions",
 					expr_op_symbols[rel->op],
@@ -992,7 +998,7 @@ static int expr_evaluate_relational(struct eval_ctx=
 *ctx, struct expr **expr)
 		}
=20
 		if (!expr_is_singleton(right))
-			return expr_binary_error(ctx, right, rel,
+			return expr_binary_error(ctx->msgs, right, rel,
 					"Relational expression (%s) is undefined "
 				        "for %s expressions",
 					expr_op_symbols[rel->op],
@@ -1005,7 +1011,7 @@ static int expr_evaluate_relational(struct eval_c=
tx *ctx, struct expr **expr)
 		break;
 	case OP_RANGE:
 		if (!datatype_equal(left->dtype, right->dtype))
-			return expr_binary_error(ctx, right, left,
+			return expr_binary_error(ctx->msgs, right, left,
 						 "datatype mismatch, expected %s, "
 						 "expression has type %s",
 						 left->dtype->desc,
@@ -1014,7 +1020,7 @@ static int expr_evaluate_relational(struct eval_c=
tx *ctx, struct expr **expr)
 range:
 		switch (left->ops->type) {
 		case EXPR_CONCAT:
-			return expr_binary_error(ctx, left, rel,
+			return expr_binary_error(ctx->msgs, left, rel,
 					"Relational expression (%s) is undefined"
 				        "for %s expressions",
 					expr_op_symbols[rel->op],

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
