Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B0A539ADB
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 19:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710876378; cv=none; b=bWXT9pXC3MbCPMPpy2hx0GIMaOauXqzpQRUTagstn1k2ssY7KRIRY6NlcGjmlK5TlNuWVAgDWL0gVCQ2DY1ihBv1oAOOrsSn+hV94IbZ+VZBnKYw0usMPvyTXp1e1dSZShjBUcn5mJ/Xm6o3q6P/tKxgulFP798ra4vrkEP8Ti4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710876378; c=relaxed/simple;
	bh=61niKJsVoA4rpmMs+k78+yyIBU1Ca18AE8D3DDqMF9U=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=S8h728EByT83fC9fGPFRt6sxms+pqRXFiHSc8bTVXuUgtHZHHj6xv5Pp97evbPMcoB5M/L/f08HkarhtORu/a1Kv8Q+FV1QjG+a3Ro60clYsgdwYe4xtIW8fsjehX4vfA7/8OSRYFZOxFbr6O9MLUH+LZwyRB1KD/cajgidRRvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] netlink_delinearize: reverse cross-day meta hour range
Date: Tue, 19 Mar 2024 20:26:09 +0100
Message-Id: <20240319192609.218891-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

f8f32deda31d ("meta: Introduce new conditions 'time', 'day' and 'hour'")
reverses the hour range in case that a cross-day range is used, eg.

  meta hour "03:01"-"08:00" counter accept

which results in (Sidney, Australia AEDT time):

  meta hour != "14:00"-"03:00" counter accept

from the list ruleset path, which not very intuitive to the reader.

Complete netlink delinearize path to reverse the cross-day meta range.

Note that kernel handles time in UTC, therefore, cross-day range may
not be look according to local time.

Update manpage to recommend to use a range expression when matching meta
hour range.

While at it, update manpage to recommend to use a range with meta time
and meta day too.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1737
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/primary-expression.txt | 12 +++++++++---
 include/expression.h       |  1 +
 include/meta.h             |  2 ++
 src/evaluate.c             |  8 ++++----
 src/netlink_delinearize.c  | 22 ++++++++++++++++++++++
 5 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index e13970cfb650..782494bda6f3 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -168,15 +168,18 @@ Either an integer or a date in ISO format. For example: "2019-06-06 17:00".
 Hour and seconds are optional and can be omitted if desired. If omitted,
 midnight will be assumed.
 The following three would be equivalent: "2019-06-06", "2019-06-06 00:00"
-and "2019-06-06 00:00:00".
+and "2019-06-06 00:00:00". Use a range expression such as
+"2019-06-06 10:00"-"2019-06-10 14:00" for matching a time range.
 When an integer is given, it is assumed to be a UNIX timestamp.
 |day|
 Either a day of week ("Monday", "Tuesday", etc.), or an integer between 0 and 6.
 Strings are matched case-insensitively, and a full match is not expected (e.g. "Mon" would match "Monday").
-When an integer is given, 0 is Sunday and 6 is Saturday.
+When an integer is given, 0 is Sunday and 6 is Saturday. Use a range expression
+such as "Monday"-"Wednesday" for matching a week day range.
 |hour|
 A string representing an hour in 24-hour format. Seconds can optionally be specified.
-For example, 17:00 and 17:00:00 would be equivalent.
+For example, 17:00 and 17:00:00 would be equivalent. Use a range expression such
+as "17:00"-"19:00" for matching a time range.
 |=============================
 
 .Using meta expressions
@@ -190,6 +193,9 @@ filter output oif eth0
 
 # incoming packet was subject to ipsec processing
 raw prerouting meta ipsec exists accept
+
+# match incoming packet from 03:00 to 14:00 local time
+raw prerouting meta hour "03:00"-"14:00" counter accept
 -----------------------
 
 SOCKET EXPRESSION
diff --git a/include/expression.h b/include/expression.h
index f5d7e160a9aa..01b45b7c83b9 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -530,5 +530,6 @@ struct expr *flagcmp_expr_alloc(const struct location *loc, enum ops op,
 
 extern void range_expr_value_low(mpz_t rop, const struct expr *expr);
 extern void range_expr_value_high(mpz_t rop, const struct expr *expr);
+void range_expr_swap_values(struct expr *range);
 
 #endif /* NFTABLES_EXPRESSION_H */
diff --git a/include/meta.h b/include/meta.h
index 1478902ed141..af2d772bb6a0 100644
--- a/include/meta.h
+++ b/include/meta.h
@@ -45,4 +45,6 @@ extern const struct datatype date_type;
 extern const struct datatype hour_type;
 extern const struct datatype day_type;
 
+bool lhs_is_meta_hour(const struct expr *meta);
+
 #endif /* NFTABLES_META_H */
diff --git a/src/evaluate.c b/src/evaluate.c
index 5b585714180d..e3ead3329636 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2470,7 +2470,7 @@ static int binop_transfer(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
-static bool lhs_is_meta_hour(const struct expr *meta)
+bool lhs_is_meta_hour(const struct expr *meta)
 {
 	if (meta->etype != EXPR_META)
 		return false;
@@ -2479,7 +2479,7 @@ static bool lhs_is_meta_hour(const struct expr *meta)
 	       meta->meta.key == NFT_META_TIME_DAY;
 }
 
-static void swap_values(struct expr *range)
+void range_expr_swap_values(struct expr *range)
 {
 	struct expr *left_tmp;
 
@@ -2561,10 +2561,10 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 					  "Inverting range values for cross-day hour matching\n\n");
 
 			if (rel->op == OP_EQ || rel->op == OP_IMPLICIT) {
-				swap_values(range);
+				range_expr_swap_values(range);
 				rel->op = OP_NEQ;
 			} else if (rel->op == OP_NEQ) {
-				swap_values(range);
+				range_expr_swap_values(range);
 				rel->op = OP_EQ;
 			}
 		}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 405a065bc98f..5a4cf1b88110 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2847,6 +2847,28 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 			expr_postprocess(ctx, &expr->left);
 			ctx->set = NULL;
 			break;
+		case EXPR_UNARY:
+			if (lhs_is_meta_hour(expr->left->arg) &&
+			    expr->right->etype == EXPR_RANGE) {
+				struct expr *range = expr->right;
+
+				/* Cross-day range needs to be reversed.
+				 * Kernel handles time in UTC. Therefore,
+				 * 03:00-14:00 AEDT (Sidney, Australia) time
+				 * is a cross-day range.
+				 */
+				if (mpz_cmp(range->left->value,
+					    range->right->value) <= 0) {
+					if (expr->op == OP_NEQ) {
+		                                range_expr_swap_values(range);
+		                                expr->op = OP_IMPLICIT;
+					} else if (expr->op == OP_IMPLICIT) {
+		                                range_expr_swap_values(range);
+					        expr->op = OP_NEG;
+					}
+				}
+			}
+			/* fallthrough */
 		default:
 			expr_postprocess(ctx, &expr->left);
 			break;
-- 
2.30.2

