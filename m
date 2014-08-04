From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 4/5 v2] src: fix byteorder conversions in range values
Date: Mon,  4 Aug 2014 18:00:10 +0200
Message-ID: <1407168011-6424-5-git-send-email-alvaroneay@gmail.com>
References: <1407168011-6424-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41118 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaHDQBD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:01:03 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so7857477wgh.27
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Aug 2014 09:00:58 -0700 (PDT)
In-Reply-To: <1407168011-6424-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently when we try to use range values in nft rules doesn't
work correctly. Usually this problem is related to incorrect byteorder
conversion. I make the following solution for showing the range in
the correct byteorder.

Example:
* nft add rule filter input tcp checksum 22-55
* nft list table filter
    tcp checksum >= 5632 tcp checksum <= 14080

And now, if we show it:
* nft add rule filter input tcp checksum 22-55
* nft list table filter
    tcp checksum >= 22 tcp checksum <= 55

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v2]
* Changed the solution for big endian and host endian cases.

 src/netlink_delinearize.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 1035e32..af18dcc 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -627,6 +627,17 @@ static void payload_dependency_store(struct rule_pp_ctx *ctx,
 	ctx->pdep  = stmt;
 }
 
+static void payload_elem_postprocess(struct expr *expr)
+{
+	switch (expr->ops->type) {
+	case EXPR_VALUE:
+		expr_switch_byteorder(expr);
+		break;
+	default:
+		break;
+	}
+}
+
 static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 				      struct stmt *stmt, struct expr *expr)
 {
@@ -677,6 +688,14 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 		payload_expr_complete(left, &ctx->pctx);
 		expr_set_type(expr->right, expr->left->dtype,
 			      expr->left->byteorder);
+
+		/* If we have rules that we have used payload with ranges or set
+		 * we must to convert it to host endian for representing it
+		 * correctly
+		 */
+		if (left->dtype->byteorder == BYTEORDER_BIG_ENDIAN)
+			payload_elem_postprocess(expr->right);
+
 		payload_dependency_kill(ctx, expr->left);
 		break;
 	}
-- 
1.7.10.4

