Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F69C04A68
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jul 2022 11:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiG0LUU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Jul 2022 07:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiG0LUU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Jul 2022 07:20:20 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C29B1400D
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Jul 2022 04:20:19 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oGf5N-0003bY-KP; Wed, 27 Jul 2022 13:20:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/7] netlink_delinearize: postprocess binary ands in set expressions
Date:   Wed, 27 Jul 2022 13:19:58 +0200
Message-Id: <20220727112003.26022-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220727112003.26022-1-fw@strlen.de>
References: <20220727112003.26022-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Input:
update ether saddr . vlan id timeout 5s @macset

is now rendered as:
update @macset { @ll,48,48 . vlan id timeout 5s }

The @ll, ... is due to vlan description replacing the ethernet one,
so payload decode fails to take the concatenation apart (the ethernet
header payload info is matched vs. vlan template).

This will be adjusted by a followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/netlink.h         |  4 ++++
 src/netlink_delinearize.c | 39 +++++++++++++++++++++++++++++++++++----
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index e8e0f68ae1a4..2d5532387c0c 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -42,10 +42,14 @@ struct netlink_parse_ctx {
 	struct netlink_ctx	*nlctx;
 };
 
+
+#define RULE_PP_IN_CONCATENATION	(1 << 0)
+
 struct rule_pp_ctx {
 	struct proto_ctx	pctx;
 	struct payload_dep_ctx	pdctx;
 	struct stmt		*stmt;
+	unsigned int		flags;
 };
 
 extern const struct input_descriptor indesc_netlink;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 3835b3e522b9..652c4975f8a5 100644
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
@@ -2310,6 +2311,16 @@ static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr,
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
@@ -2542,6 +2553,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		LIST_HEAD(tmp);
 		struct expr *n;
 
+		ctx->flags |= RULE_PP_IN_CONCATENATION;
 		list_for_each_entry_safe(i, n, &expr->expressions, list) {
 			if (type) {
 				dtype = concat_subtype_lookup(type, --off);
@@ -2553,6 +2565,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 
 			ntype = concat_subtype_add(ntype, i->dtype->type);
 		}
+		ctx->flags &= ~RULE_PP_IN_CONCATENATION;
 		list_splice(&tmp, &expr->expressions);
 		datatype_set(expr, concat_type_alloc(ntype));
 		break;
@@ -2569,6 +2582,24 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 			expr_set_type(expr->right, &integer_type,
 				      BYTEORDER_HOST_ENDIAN);
 			break;
+		case OP_AND:
+			expr_set_type(expr->right, expr->left->dtype,
+				      expr->left->byteorder);
+
+			/* Only process OP_AND if we are inside a concatenation.
+			 *
+			 * Else, we remove it too early, for normal contect OP_AND
+			 * removal needs to be performed as part of the relational
+			 * operation because the RHS constant might need to be adjusted
+			 * (shifted).
+			 */
+			if ((ctx->flags & RULE_PP_IN_CONCATENATION) &&
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

