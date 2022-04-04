Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3878DC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344763AbiDDMbN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344222AbiDDMbM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:31:12 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A4225280
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ThFC+nFqZWIg/sgI1KUnUaL2+RIP8NKFqYvlFXqaRhI=; b=GFnu4XkYfAN7L9RkCEylcfuXKH
        RBplG3qHjQfv1HDkwZaIfl35jBwmOfZnL/yuOqwJSGTpXo4mQCEQGC1m0A4ozOuSHrH2rUSYTtPnq
        dREmmPXiM6pkCRjp2j9g8Y5mInjZCiTKVUcQ0XNeYemlndFT+o1eWsTkeN2jIEv1KtYACH57OHLwJ
        eK1u+php+KSkzCtA1MkQXj4jfEXkr0/ZdHyBGP4zZFdQxs47lBCvlgw35wJ6OWjnIk2Vi/d/xfQjp
        vwJk69e6FwoPXUIaYBGDZYWlSCVGTIJ3/S0GPRGLFZGS4drUqni5IrLwGE9TlYE70BH+BIF1zo/Q8
        5z2vjQng==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbK-007FTC-S0; Mon, 04 Apr 2022 13:14:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 25/32] netlink_delinearize: refactor stmt_payload_binop_postprocess
Date:   Mon,  4 Apr 2022 13:14:03 +0100
Message-Id: <20220404121410.188509-26-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404121410.188509-1-jeremy@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We are about to add support for a new payload binop that needs to be
post-processed, so move the contents of the two major cases (I and II)
into separate functions to keep the function size reasonable.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 191 +++++++++++++++++++++-----------------
 1 file changed, 108 insertions(+), 83 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 8f19594a1633..4036646d57ac 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2862,6 +2862,110 @@ static void stmt_payload_binop_pp(struct rule_pp_ctx *ctx, struct expr *binop)
 	}
 }
 
+static bool stmt_payload_binop_postprocess_i(struct rule_pp_ctx *ctx)
+{
+	struct expr *expr, *binop, *payload, *value, *mask;
+	struct stmt *stmt = ctx->stmt;
+	mpz_t tmp, bitmask;
+
+	expr = stmt->payload.val;
+
+	if (expr->op != OP_OR)
+		return false;
+
+	value = expr->right;
+	if (value->etype != EXPR_VALUE)
+		return false;
+
+	binop = expr->left;
+	if (binop->op != OP_AND)
+		return false;
+
+	payload = binop->left;
+	if (payload->etype != EXPR_PAYLOAD)
+		return false;
+
+	if (!payload_expr_cmp(stmt->payload.expr, payload))
+		return false;
+
+	mask = binop->right;
+	if (mask->etype != EXPR_VALUE)
+		return false;
+
+	mpz_init(tmp);
+	mpz_set(tmp, mask->value);
+
+	mpz_init_bitmask(bitmask, payload->len);
+	mpz_xor(bitmask, bitmask, mask->value);
+	mpz_xor(bitmask, bitmask, value->value);
+	mpz_set(mask->value, bitmask);
+	mpz_clear(bitmask);
+
+	binop_postprocess(ctx, expr, &expr->left);
+	if (!payload_is_known(payload))
+		mpz_set(mask->value, tmp);
+	else {
+		expr_free(stmt->payload.expr);
+		stmt->payload.expr = expr_get(payload);
+		stmt->payload.val = expr_get(expr->right);
+		expr_free(expr);
+	}
+
+	mpz_clear(tmp);
+
+	return true;
+}
+
+static bool stmt_payload_binop_postprocess_ii(struct rule_pp_ctx *ctx)
+{
+	struct expr *expr, *payload, *value;
+	struct stmt *stmt = ctx->stmt;
+	mpz_t bitmask;
+
+	expr = stmt->payload.val;
+
+	value = expr->right;
+	if (value->etype != EXPR_VALUE)
+		return false;
+
+	switch (expr->op) {
+	case OP_AND: /* IIa */
+		payload = expr->left;
+		mpz_init_bitmask(bitmask, payload->len);
+		mpz_xor(bitmask, bitmask, value->value);
+		mpz_set(value->value, bitmask);
+		mpz_clear(bitmask);
+		break;
+	case OP_OR: /* IIb */
+		break;
+	default: /* No idea */
+		return false;
+	}
+
+	stmt_payload_binop_pp(ctx, expr);
+	if (!payload_is_known(expr->left))
+		return false;
+
+	expr_free(stmt->payload.expr);
+
+	switch (expr->op) {
+	case OP_AND:
+		/* Mask was used to match payload, i.e.
+		 * user asked to set zero value.
+		 */
+		mpz_set_ui(value->value, 0);
+		break;
+	default:
+		break;
+	}
+
+	stmt->payload.expr = expr_get(expr->left);
+	stmt->payload.val = expr_get(expr->right);
+	expr_free(expr);
+
+	return true;
+}
+
 /**
  * stmt_payload_binop_postprocess - decode payload set binop
  *
@@ -2906,9 +3010,8 @@ static void stmt_payload_binop_pp(struct rule_pp_ctx *ctx, struct expr *binop)
  */
 static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
 {
-	struct expr *expr, *binop, *payload, *value, *mask;
+	struct expr *expr;
 	struct stmt *stmt = ctx->stmt;
-	mpz_t bitmask;
 
 	expr = stmt->payload.val;
 
@@ -2916,93 +3019,15 @@ static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
 		return;
 
 	switch (expr->left->etype) {
-	case EXPR_BINOP: {/* I? */
-		mpz_t tmp;
-
-		if (expr->op != OP_OR)
-			return;
-
-		value = expr->right;
-		if (value->etype != EXPR_VALUE)
-			return;
-
-		binop = expr->left;
-		if (binop->op != OP_AND)
-			return;
-
-		payload = binop->left;
-		if (payload->etype != EXPR_PAYLOAD)
-			return;
-
-		if (!payload_expr_cmp(stmt->payload.expr, payload))
+	case EXPR_BINOP: /* I? */
+		if (stmt_payload_binop_postprocess_i(ctx))
 			return;
 
-		mask = binop->right;
-		if (mask->etype != EXPR_VALUE)
-			return;
-
-		mpz_init(tmp);
-		mpz_set(tmp, mask->value);
-
-		mpz_init_bitmask(bitmask, payload->len);
-		mpz_xor(bitmask, bitmask, mask->value);
-		mpz_xor(bitmask, bitmask, value->value);
-		mpz_set(mask->value, bitmask);
-		mpz_clear(bitmask);
-
-		binop_postprocess(ctx, expr, &expr->left);
-		if (!payload_is_known(payload)) {
-			mpz_set(mask->value, tmp);
-			mpz_clear(tmp);
-			return;
-		}
-
-		mpz_clear(tmp);
-		expr_free(stmt->payload.expr);
-		stmt->payload.expr = expr_get(payload);
-		stmt->payload.val = expr_get(expr->right);
-		expr_free(expr);
 		break;
-	}
 	case EXPR_PAYLOAD: /* II? */
-		value = expr->right;
-		if (value->etype != EXPR_VALUE)
+		if (stmt_payload_binop_postprocess_ii(ctx))
 			return;
 
-		switch (expr->op) {
-		case OP_AND: /* IIa */
-			payload = expr->left;
-			mpz_init_bitmask(bitmask, payload->len);
-			mpz_xor(bitmask, bitmask, value->value);
-			mpz_set(value->value, bitmask);
-			mpz_clear(bitmask);
-			break;
-		case OP_OR: /* IIb */
-			break;
-		default: /* No idea */
-			return;
-		}
-
-		stmt_payload_binop_pp(ctx, expr);
-		if (!payload_is_known(expr->left))
-			return;
-
-		expr_free(stmt->payload.expr);
-
-		switch (expr->op) {
-		case OP_AND:
-			/* Mask was used to match payload, i.e.
-			 * user asked to set zero value.
-			 */
-			mpz_set_ui(value->value, 0);
-			break;
-		default:
-			break;
-		}
-
-		stmt->payload.expr = expr_get(expr->left);
-		stmt->payload.val = expr_get(expr->right);
-		expr_free(expr);
 		break;
 	default: /* No idea */
 		break;
-- 
2.35.1

