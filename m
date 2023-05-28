Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02635C7EE31
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 14:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjE1OBi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 10:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjE1OBf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 10:01:35 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3075D8
        for <netfilter-devel@vger.kernel.org>; Sun, 28 May 2023 07:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ueHrCm9ru1w4aRGbwNEd+G8hOxIoBkPGYE36QmlyGZU=; b=DRR2sF5gtL7CHDXS3q1v8gaYx2
        pw7hnXAOxugajPGWZvMBqV9oDKbFzg0FJf416nkOJV/zxSjC1USgqVvtqgqIb+XqtCEcgC2o8MxX4
        ZWCU+vvSTdRHayCva3ZAZFd5RCnuH+Pb1ziyn1eJ0Y3u/fgMvD8P7AkI3w9+x5vhItfEALwPfQGyC
        K73HNbHaEj1b9lOgBuA0Q4igESQESUV8rG0DODHYmWgRVaREYGkc9pNNZ7qKNP2k18JwtuXtFJXLL
        wWbXv0o7KGbLnsyqj91+m2KyNTl7pOFrrz/DszR6OiSP8wcptVWz/SsQqc8PafhIQROvV7dnpoc/k
        c3I7XGiA==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q3Gxe-008Xe1-7h; Sun, 28 May 2023 15:01:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [PATCH nft v5 2/8] netlink_delinearize: refactor stmt_payload_binop_postprocess
Date:   Sun, 28 May 2023 15:00:52 +0100
Message-Id: <20230528140058.1218669-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230528140058.1218669-1-jeremy@azazel.net>
References: <20230528140058.1218669-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We are about to add support for a new payload binop that needs to be
post-processed, so move the contents of the two major cases (I and II)
into separate functions to keep the function size reasonable.

Fix a typo in a comment while we're at it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 193 +++++++++++++++++++++-----------------
 1 file changed, 109 insertions(+), 84 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index bdd3242bf5ec..d729fb85a3ed 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -3112,6 +3112,110 @@ static void stmt_payload_binop_pp(struct rule_pp_ctx *ctx, struct expr *binop)
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
@@ -3128,7 +3232,7 @@ static void stmt_payload_binop_pp(struct rule_pp_ctx *ctx, struct expr *binop)
  * a binop expression with a munged payload expression on the left
  * and a mask to clear the real payload offset/length.
  *
- * So chech if we have one of the following binops:
+ * So check if we have one of the following binops:
  * I)
  *           binop (|)
  *       binop(&)   value/set
@@ -3156,9 +3260,8 @@ static void stmt_payload_binop_pp(struct rule_pp_ctx *ctx, struct expr *binop)
  */
 static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
 {
-	struct expr *expr, *binop, *payload, *value, *mask;
+	struct expr *expr;
 	struct stmt *stmt = ctx->stmt;
-	mpz_t bitmask;
 
 	expr = stmt->payload.val;
 
@@ -3166,93 +3269,15 @@ static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
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
-			return;
-
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
+	case EXPR_BINOP: /* I? */
+		if (stmt_payload_binop_postprocess_i(ctx))
 			return;
-		}
 
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
-			return;
-
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
+		if (stmt_payload_binop_postprocess_ii(ctx))
 			return;
 
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
2.39.2

