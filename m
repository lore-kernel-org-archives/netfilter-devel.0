From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nftables PATCH] netlink: Allow invert the ranges
Date: Tue, 27 May 2014 19:15:34 +0200
Message-ID: <1401210934-4900-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:51218 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaE0RRN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 May 2014 13:17:13 -0400
Received: by mail-wg0-f52.google.com with SMTP id l18so9747749wgh.11
        for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2014 10:17:11 -0700 (PDT)
Received: from localhost.localdomain (85.136.70.56.dyn.user.ono.com. [85.136.70.56])
        by mx.google.com with ESMTPSA id em5sm9847493wic.23.2014.05.27.10.17.10
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 May 2014 10:17:10 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

This patch fix the bug:

http://bugzilla.netfilter.org/show_bug.cgi?id=3D924

Before, nftables doesn't permit invert ranges. This patch allows
add rules like this:

nft add rule ip test input ip daddr !=3D 192.168.1.2-192.168.1.55

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/netlink_linearize.c |   43 +++++++++++++++++++++++++++++++++++++--=
----
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index e3f06af..4b6400a 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -182,6 +182,10 @@ static enum nft_cmp_ops netlink_gen_cmp_op(enum op=
s op)
 	}
 }
=20
+static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
+			      const struct expr *expr,
+			      enum nft_registers dreg);
+
 static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 			    const struct expr *expr,
 			    enum nft_registers dreg)
@@ -196,7 +200,8 @@ static void netlink_gen_cmp(struct netlink_lineariz=
e_ctx *ctx,
 	sreg =3D get_register(ctx);
 	netlink_gen_expr(ctx, expr->left, sreg);
=20
-	if (expr->right->ops->type =3D=3D EXPR_PREFIX) {
+	switch (expr->right->ops->type) {
+	case EXPR_PREFIX: {
 		mpz_t mask;
=20
 		mpz_init(mask);
@@ -216,7 +221,11 @@ static void netlink_gen_cmp(struct netlink_lineari=
ze_ctx *ctx,
 		nft_rule_add_expr(ctx->nlr, nle);
=20
 		right =3D expr->right->prefix;
-	} else {
+		break;
+		}
+	case EXPR_RANGE:
+		return netlink_gen_range(ctx, expr, dreg);
+	default:
 		right =3D expr->right;
 	}
=20
@@ -247,16 +256,38 @@ static void netlink_gen_range(struct netlink_line=
arize_ctx *ctx,
=20
 	nle =3D alloc_nft_expr("cmp");
 	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_SREG, sreg);
-	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_OP,
-			      netlink_gen_cmp_op(OP_GTE));
+	switch (expr->op) {
+	case OP_EQ:
+		nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_OP,
+				      netlink_gen_cmp_op(OP_GTE));
+		break;
+	case OP_NEQ:
+		nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_OP,
+				      netlink_gen_cmp_op(OP_LT));
+		break;
+	default:
+		BUG("invalid comparison operation %u\n", expr->op);
+	}
+
 	netlink_gen_data(range->left, &nld);
 	nft_rule_expr_set(nle, NFT_EXPR_CMP_DATA, nld.value, nld.len);
 	nft_rule_add_expr(ctx->nlr, nle);
=20
 	nle =3D alloc_nft_expr("cmp");
 	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_SREG, sreg);
-	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_OP,
-			      netlink_gen_cmp_op(OP_LTE));
+	switch (expr->op) {
+	case OP_EQ:
+		nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_OP,
+				      netlink_gen_cmp_op(OP_LTE));
+		break;
+	case OP_NEQ:
+		nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_OP,
+				      netlink_gen_cmp_op(OP_GT));
+		break;
+	default:
+		BUG("invalid comparison operation %u\n", expr->op);
+	}
+
 	netlink_gen_data(range->right, &nld);
 	nft_rule_expr_set(nle, NFT_EXPR_CMP_DATA, nld.value, nld.len);
 	nft_rule_add_expr(ctx->nlr, nle);
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
