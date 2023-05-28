Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D56FC7EE29
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 14:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjE1OBg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 10:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjE1OBe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 10:01:34 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A9DBE
        for <netfilter-devel@vger.kernel.org>; Sun, 28 May 2023 07:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=b9hQOEhXXcYfqfFFLTfwt5uzr9cPzLp69WgTS0CdMHA=; b=rTed2Ag4LUmC7R/Y32LrD95z3c
        qIpBochAs1VuD/gF75HQ4nOMSgcDxpirzrcOfvsnJklxdAyRCwc7HAjmYBODNwQ3U/9rvFFPbLxbH
        RoYiTLNoiXmbUnakunnP1OfGXUmTksPKkN34EtEh+oRxBLFwxSgoNhYQcLmo0C9p6Zi27sAArI1GG
        HZVyCSbfar9ZMxHI5vlfd3mZa+rdxjkDbphCboWD7rhH3V7BRZejVa3qEBnqFzlB/0qr37EcWOY9Z
        7YFKRTA9sfjTRll+0io8KvsHt8LtBtcBgOAP7DbzxAYpkVRloSN8skwJ47i38KyhunmaVJ0mCsuV4
        haldRDHg==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q3Gxe-008Xe1-9U; Sun, 28 May 2023 15:01:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [PATCH nft v5 3/8] netlink_delinearize: add support for processing variable payload statement arguments
Date:   Sun, 28 May 2023 15:00:53 +0100
Message-Id: <20230528140058.1218669-4-jeremy@azazel.net>
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

If a user uses a variable payload expression in a payload statement, the
structure of the statement value is not handled by the existing
statement postprocessing function, so we need to extend it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 86 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 80 insertions(+), 6 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index d729fb85a3ed..b36440e7c106 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -3112,7 +3112,7 @@ static void stmt_payload_binop_pp(struct rule_pp_ctx *ctx, struct expr *binop)
 	}
 }
 
-static bool stmt_payload_binop_postprocess_i(struct rule_pp_ctx *ctx)
+static bool stmt_payload_binop_postprocess_i_a(struct rule_pp_ctx *ctx)
 {
 	struct expr *expr, *binop, *payload, *value, *mask;
 	struct stmt *stmt = ctx->stmt;
@@ -3166,6 +3166,68 @@ static bool stmt_payload_binop_postprocess_i(struct rule_pp_ctx *ctx)
 	return true;
 }
 
+static bool stmt_payload_binop_postprocess_i_b(struct rule_pp_ctx *ctx)
+{
+	struct dl_proto_ctx *dl = dl_proto_ctx(ctx);
+	struct expr *expr, *payload, *mask, *xor;
+	struct stmt *stmt = ctx->stmt;
+	unsigned int shift;
+	mpz_t tmp, bitmask;
+
+	expr = stmt->payload.val;
+
+	if (expr->op != OP_XOR)
+		return false;
+
+	if (expr->left->etype != EXPR_BINOP)
+		return false;
+
+	if (expr->left->op != OP_AND)
+		return false;
+
+	if (expr->right->etype == EXPR_UNARY) {
+		/*
+		 * If the payload value was originally in a different byte-order
+		 * from the payload expression, there will be a byte-order
+		 * conversion to remove.
+		 */
+		xor = expr_get(expr->right->arg);
+		expr_free(expr->right);
+		expr->right = xor;
+	} else
+		xor = expr->right;
+
+	mask    = expr->left->right;
+	payload = expr->left->left;
+
+	mpz_init(tmp);
+	mpz_set(tmp, mask->value);
+
+	mpz_init_bitmask(bitmask, payload->len);
+	mpz_xor(bitmask, bitmask, mask->value);
+	mpz_set(mask->value, bitmask);
+	mpz_clear(bitmask);
+
+	if (payload_expr_trim(payload, mask, &dl->pctx, &shift))
+		payload_match_postprocess(ctx, expr->left, payload);
+
+	if (!payload_is_known(payload)) {
+		mpz_set(mask->value, tmp);
+	} else {
+		if (shift) {
+			expr->right = expr_get(xor->left);
+			expr_free(xor);
+		}
+		expr_free(stmt->payload.expr);
+		stmt->payload.expr = expr_get(payload);
+		stmt->payload.val = expr_get(expr->right);
+		expr_free(expr);
+	}
+
+	mpz_clear(tmp);
+	return true;
+}
+
 static bool stmt_payload_binop_postprocess_ii(struct rule_pp_ctx *ctx)
 {
 	struct expr *expr, *payload, *value;
@@ -3233,21 +3295,30 @@ static bool stmt_payload_binop_postprocess_ii(struct rule_pp_ctx *ctx)
  * and a mask to clear the real payload offset/length.
  *
  * So check if we have one of the following binops:
- * I)
+ *
+ * Ia)
  *           binop (|)
  *       binop(&)   value/set
  * payload   value(mask)
  *
- * This is the normal case, the | RHS is the value the user wants
- * to set, the & RHS is the mask value that discards bits we need
+ * This is the normal constant case, the | RHS is the value the user
+ * wants to set, the & RHS is the mask value that discards bits we need
  * to clear but retains everything unrelated to the set operation.
  *
+ * Ib)
+ *         binop (^)
+ *       binop(&)   value/set
+ * payload   value(mask)
+ *
+ * The user wants to set a variable payload argument.  The ^ RHS is the
+ * variable expression.  The mask is as above.
+ *
  * IIa)
  *     binop (&)
  * payload   mask
  *
  * User specified a zero set value -- netlink bitwise decoding
- * discarded the redundant "| 0" part.  This is identical to I),
+ * discarded the redundant "| 0" part.  This is identical to Ia),
  * we can just set value to 0 after we inferred the real payload size.
  *
  * IIb)
@@ -3270,7 +3341,10 @@ static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
 
 	switch (expr->left->etype) {
 	case EXPR_BINOP: /* I? */
-		if (stmt_payload_binop_postprocess_i(ctx))
+		if (stmt_payload_binop_postprocess_i_a(ctx))
+			return;
+
+		if (stmt_payload_binop_postprocess_i_b(ctx))
 			return;
 
 		break;
-- 
2.39.2

