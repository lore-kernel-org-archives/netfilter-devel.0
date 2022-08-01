Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1196C00144
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Aug 2022 13:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbiHAN4v (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Aug 2022 09:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiHAN4u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Aug 2022 09:56:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1062DE8
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2022 06:56:49 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oIVua-0000hB-38; Mon, 01 Aug 2022 15:56:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2 2/8] netlink_delinearize: postprocess binary ands in concatenations
Date:   Mon,  1 Aug 2022 15:56:27 +0200
Message-Id: <20220801135633.5317-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220801135633.5317-1-fw@strlen.de>
References: <20220801135633.5317-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Input:
update ether saddr . vlan id timeout 5s @macset
ether saddr . vlan id @macset

Before this patch, gets rendered as:
update @macset { @ll,48,48 . @ll,112,16 & 0xfff timeout 5s }
@ll,48,48 . @ll,112,16 & 0xfff @macset

After this, listing will show:
update @macset { @ll,48,48 . vlan id timeout 5s }
@ll,48,48 . vlan id @macset

The @ll, ... is due to vlan description replacing the ethernet one,
so payload decode fails to take the concatenation apart (the ethernet
header payload info is matched vs. vlan template).

This will be adjusted by a followup patch.

v2: expr_free() in __binop_postprocess needs to be moved
downwards, because expr and expr_binop are identical in the
OP_AND case. (Pablo).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: amend it to also handle 'set elem keys', not just
     concatenations.  Update comment and commit log.
 include/netlink.h         |  6 ++++++
 src/netlink_delinearize.c | 45 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index e8e0f68ae1a4..71c888fa0b40 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -42,10 +42,16 @@ struct netlink_parse_ctx {
 	struct netlink_ctx	*nlctx;
 };
 
+
+#define RULE_PP_IN_CONCATENATION	(1 << 0)
+
+#define RULE_PP_REMOVE_OP_AND		(RULE_PP_IN_CONCATENATION)
+
 struct rule_pp_ctx {
 	struct proto_ctx	pctx;
 	struct payload_dep_ctx	pdctx;
 	struct stmt		*stmt;
+	unsigned int		flags;
 };
 
 extern const struct input_descriptor indesc_netlink;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 3835b3e522b9..42221f8ca526 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2260,12 +2260,13 @@ static void binop_adjust(const struct expr *binop, struct expr *right,
 	}
 }
 
-static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr,
-			      struct expr **expr_binop)
+static void __binop_postprocess(struct rule_pp_ctx *ctx,
+				struct expr *expr,
+				struct expr *left,
+				struct expr *mask,
+				struct expr **expr_binop)
 {
 	struct expr *binop = *expr_binop;
-	struct expr *left = binop->left;
-	struct expr *mask = binop->right;
 	unsigned int shift;
 
 	assert(binop->etype == EXPR_BINOP);
@@ -2301,15 +2302,26 @@ static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr,
 
 		assert(binop->left == left);
 		*expr_binop = expr_get(left);
-		expr_free(binop);
 
 		if (left->etype == EXPR_PAYLOAD)
 			payload_match_postprocess(ctx, expr, left);
 		else if (left->etype == EXPR_EXTHDR && right)
 			expr_set_type(right, left->dtype, left->byteorder);
+
+		expr_free(binop);
 	}
 }
 
+static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr,
+			      struct expr **expr_binop)
+{
+	struct expr *binop = *expr_binop;
+	struct expr *left = binop->left;
+	struct expr *mask = binop->right;
+
+	__binop_postprocess(ctx, expr, left, mask, expr_binop);
+}
+
 static void map_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 {
 	struct expr *binop = expr->map;
@@ -2542,6 +2554,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		LIST_HEAD(tmp);
 		struct expr *n;
 
+		ctx->flags |= RULE_PP_IN_CONCATENATION;
 		list_for_each_entry_safe(i, n, &expr->expressions, list) {
 			if (type) {
 				dtype = concat_subtype_lookup(type, --off);
@@ -2553,6 +2566,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 
 			ntype = concat_subtype_add(ntype, i->dtype->type);
 		}
+		ctx->flags &= ~RULE_PP_IN_CONCATENATION;
 		list_splice(&tmp, &expr->expressions);
 		datatype_set(expr, concat_type_alloc(ntype));
 		break;
@@ -2569,6 +2583,27 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 			expr_set_type(expr->right, &integer_type,
 				      BYTEORDER_HOST_ENDIAN);
 			break;
+		case OP_AND:
+			expr_set_type(expr->right, expr->left->dtype,
+				      expr->left->byteorder);
+
+			/* Do not process OP_AND in ordinary rule context.
+			 *
+			 * Removal needs to be performed as part of the relational
+			 * operation because the RHS constant might need to be adjusted
+			 * (shifted).
+			 *
+			 * This is different in set element context or concatenations:
+			 * There is no relational operation (eq, neq and so on), thus
+			 * it needs to be processed right away.
+			 */
+			if ((ctx->flags & RULE_PP_REMOVE_OP_AND) &&
+			    expr->left->etype == EXPR_PAYLOAD &&
+			    expr->right->etype == EXPR_VALUE) {
+				__binop_postprocess(ctx, expr, expr->left, expr->right, exprp);
+				return;
+			}
+			break;
 		default:
 			expr_set_type(expr->right, expr->left->dtype,
 				      expr->left->byteorder);
-- 
2.35.1

