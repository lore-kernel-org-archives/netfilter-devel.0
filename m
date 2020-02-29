Return-Path: <SRS0=4Rej=4R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4418EC3F2CE
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F8E72469C
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:44:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="HTwzkd5H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgB2Lo3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Feb 2020 06:44:29 -0500
Received: from kadath.azazel.net ([81.187.231.250]:49490 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbgB2Lo3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Feb 2020 06:44:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VhIqMCPoOpG3rbu3PiHrGHKD9I375LMYzV3UEE4cU30=; b=HTwzkd5HiTRpWGGZSBFwWd23D4
        1GX06zLEwNCa6V8bVdESc/UpCezyjWmoykZUGNJwKNO6S0ACqKNeQNlAsGF3oFzy1emC2gT12G93w
        XapK/ZIWa5xbj1lbt5A9WeLLXci6eLFVZF1cQ/zfdGwqBImUp5MPkTQRKVE/6ciJw7wfm+Hopq5zO
        MFSFtpn0iZUUnc4WD7p3/RYFaLLQbz8lpdl2l6z0MoeiJhLDTy7zBBbZr4NTS/RWWY3Y1L/93bkz4
        IvPcH3gUo1EJCEaTp0iPw9x9KRTavupyuHMAgYE14ZLnv82m1RbA5pilA5Djf2f75jum9yWF/eLoc
        pNTsrHhA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j80HN-0003Wm-No; Sat, 29 Feb 2020 11:27:33 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 13/18] netlink_delinearize: refactor stmt_payload_binop_postprocess.
Date:   Sat, 29 Feb 2020 11:27:26 +0000
Message-Id: <20200229112731.796417-14-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200229112731.796417-1-jeremy@azazel.net>
References: <20200229112731.796417-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move the contents of the two major cases (I and II) into separate
functions.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 192 +++++++++++++++++++++-----------------
 1 file changed, 107 insertions(+), 85 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 4e5d64ede8bd..e8e9e5719ee8 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2514,6 +2514,109 @@ static void stmt_payload_binop_pp(struct rule_pp_ctx *ctx, struct expr *binop)
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
+	binop_postprocess(ctx, expr);
+	if (!payload_is_known(payload)) {
+		mpz_set(mask->value, tmp);
+	} else {
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
+	return true;
+}
+
 /**
  * stmt_payload_binop_postprocess - decode payload set binop
  *
@@ -2558,9 +2661,8 @@ static void stmt_payload_binop_pp(struct rule_pp_ctx *ctx, struct expr *binop)
  */
 static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
 {
-	struct expr *expr, *binop, *payload, *value, *mask;
+	struct expr *expr;
 	struct stmt *stmt = ctx->stmt;
-	mpz_t bitmask;
 
 	expr = stmt->payload.val;
 
@@ -2568,93 +2670,13 @@ static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
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
+	case EXPR_BINOP: /* I? */
+		if (stmt_payload_binop_postprocess_i(ctx))
 			return;
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
-		binop_postprocess(ctx, expr);
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
+		if (stmt_payload_binop_postprocess_ii(ctx))
 			return;
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
2.25.0

