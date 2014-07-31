From: Yuxuan Shui <yshuiv7@gmail.com>
Subject: [nftables PATCH] expr: Interpret OP_NEQ against a set as OP_LOOKUP
Date: Fri,  1 Aug 2014 00:40:21 +0800
Message-ID: <1406824821-16111-3-git-send-email-yshuiv7@gmail.com>
References: <1406824821-16111-1-git-send-email-yshuiv7@gmail.com>
Cc: tomasz.bursztyka@linux.intel.com, netfilter-devel@vger.kernel.org,
	Yuxuan Shui <yshuiv7@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45131 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaGaQkk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:40:40 -0400
Received: by mail-pa0-f43.google.com with SMTP id lf10so3972578pab.2
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2014 09:40:40 -0700 (PDT)
In-Reply-To: <1406824821-16111-1-git-send-email-yshuiv7@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes bug 888.

v2: Fix macro naming.

Signed-off-by: Yuxuan Shui <yshuiv7@gmail.com>
---
 include/linux/netfilter/nf_tables.h |  9 +++++++++
 src/evaluate.c                      | 12 ++++++++++++
 src/netlink_delinearize.c           |  7 +++++++
 src/netlink_linearize.c             |  5 +++++
 4 files changed, 33 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index dfdb251..3177b77 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -449,6 +449,15 @@ enum nft_cmp_attributes {
 #define NFTA_CMP_MAX		(__NFTA_CMP_MAX - 1)
 
 /**
+ * enum nft_lookup_flags - flags for nft_lookup operator
+ *
+ * @NFT_LOOKUP_F_NEG: negate the result
+ */
+enum nft_lookup_flags {
+	NFT_LOOKUP_F_NEG = 1,
+};
+
+/**
  * enum nft_lookup_attributes - nf_tables set lookup expression netlink attributes
  *
  * @NFTA_LOOKUP_SET: name of the set where to look for (NLA_STRING)
diff --git a/src/evaluate.c b/src/evaluate.c
index e05473a..a0af0f7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -972,6 +972,18 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 			if (byteorder_conversion(ctx, &rel->right, left->byteorder) < 0)
 				return -1;
 			break;
+		case EXPR_SET:
+			assert(rel->op == OP_NEQ);
+			right = rel->right =
+				implicit_set_declaration(ctx, left->dtype, left->len, right);
+			if (right->set->flags & SET_F_INTERVAL &&
+			    byteorder_conversion(ctx, &rel->left,
+						 BYTEORDER_BIG_ENDIAN) < 0)
+				return -1;
+			break;
+		case EXPR_SET_REF:
+			assert(rel->op == OP_NEQ);
+			break;
 		default:
 			BUG("invalid expression type %s\n", right->ops->name);
 		}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 5c6ca80..46e0ab6 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -160,6 +160,7 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 	struct expr *expr, *left, *right;
 	struct set *set;
 	enum nft_registers dreg;
+	uint32_t flag;
 
 	left = netlink_get_register(ctx, loc,
 			nft_rule_expr_get_u32(nle, NFT_EXPR_LOOKUP_SREG));
@@ -185,6 +186,12 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 		expr = relational_expr_alloc(loc, OP_LOOKUP, left, right);
 	}
 
+	if (nft_rule_expr_is_set(nle, NFT_EXPR_LOOKUP_FLAGS)) {
+		flag = nft_rule_expr_get_u32(nle, NFT_EXPR_LOOKUP_FLAGS);
+		if (flag & NFT_LOOKUP_F_NEG)
+			expr->op = OP_NEQ;
+	}
+
 	stmt = expr_stmt_alloc(loc, expr);
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 5c1b46d..49e705b 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -157,6 +157,8 @@ static void netlink_gen_lookup(struct netlink_linearize_ctx *ctx,
 			      expr->right->set->handle.set);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_LOOKUP_SET_ID,
 			      expr->right->set->handle.set_id);
+	if (expr->op == OP_NEQ)
+		nft_rule_expr_set_u32(nle, NFT_EXPR_LOOKUP_FLAGS, NFT_LOOKUP_F_NEG);
 
 	release_register(ctx);
 	nft_rule_add_expr(ctx->nlr, nle);
@@ -225,6 +227,9 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 		}
 	case EXPR_RANGE:
 		return netlink_gen_range(ctx, expr, dreg);
+	case EXPR_SET:
+	case EXPR_SET_REF:
+		return netlink_gen_lookup(ctx, expr, dreg);
 	default:
 		right = expr->right;
 	}
-- 
2.0.1

