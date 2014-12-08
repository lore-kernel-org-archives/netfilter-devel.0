From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/3] netlink_delinearize: fix listing of set members in host byteorder using integer_type
Date: Mon,  8 Dec 2014 23:24:33 +0100
Message-ID: <1418077474-6431-2-git-send-email-pablo@netfilter.org>
References: <1418077474-6431-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37511 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755493AbaLHWWU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:22:20 -0500
In-Reply-To: <1418077474-6431-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 nft list table filter
 ...
        cpu { 50331648, 33554432, 0, 16777216} counter packets 8 bytes 344

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index c809bb6..e9a04dd 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -742,6 +742,29 @@ static void payload_dependency_store(struct rule_pp_ctx *ctx,
 	ctx->pdep  = stmt;
 }
 
+static void integer_type_postprocess(struct expr *expr)
+{
+	struct expr *i;
+
+	switch (expr->ops->type) {
+	case EXPR_VALUE:
+		if (expr->byteorder == BYTEORDER_HOST_ENDIAN) {
+			uint32_t len = div_round_up(expr->len, BITS_PER_BYTE);
+
+			mpz_switch_byteorder(expr->value, len);
+		}
+		break;
+	case EXPR_SET_REF:
+		list_for_each_entry(i, &expr->set->init->expressions, list) {
+			expr_set_type(i, expr->dtype, expr->byteorder);
+			integer_type_postprocess(i);
+		}
+		break;
+	default:
+		break;
+	}
+}
+
 static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 				      struct stmt *stmt, struct expr *expr)
 {
@@ -805,6 +828,12 @@ static void meta_match_postprocess(struct rule_pp_ctx *ctx,
 		    left->flags & EXPR_F_PROTOCOL)
 			payload_dependency_store(ctx, stmt, left->meta.base);
 		break;
+	case OP_LOOKUP:
+		expr_set_type(expr->right, expr->left->dtype,
+			      expr->left->byteorder);
+		if (expr->right->dtype == &integer_type)
+			integer_type_postprocess(expr->right);
+		break;
 	default:
 		break;
 	}
-- 
1.7.10.4

