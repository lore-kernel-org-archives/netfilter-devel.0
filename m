Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44649C3F2CD
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 10:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A820214DB
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 10:14:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="UmodllVE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgCCKOX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 05:14:23 -0500
Received: from kadath.azazel.net ([81.187.231.250]:41896 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbgCCKOX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 05:14:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NC32fWxc2bv2VGuR1Bhak1t38P1C+TSgdw5bWQxp+X4=; b=UmodllVE3IUKQ1voadModqdf8x
        tT8WmnK6TdRjVah5DisktvKZkwma5dWyp29rI0J2JzqI+nf2sa6inypIw293+9mOIOCDqC+WeLsmQ
        kBe3b0toEZij3zI7bSWiWs5LCV6ztrOQl5fSkFfNlCJ9nLltc8JWKlZj5WIf5ImIfJgvd7kI7ec+l
        Nl306hQYUpN2d7N1kExUJDTRUWjc6YOLIgTG+nTQIFKjnuOORGykIVW7F45qcH0lhJzT4SUojaw78
        z6tJ6yGLmb5s1qCJ69BvwFTmzmIDt9iNStHYGFmeFgCu8LISKJnSHfnQckb/WGPX87kIFoKvWfIov
        QuUiCfdw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j94AR-00081M-2y; Tue, 03 Mar 2020 09:48:47 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3 14/18] netlink_delinearize: add support for processing variable payload statement arguments.
Date:   Tue,  3 Mar 2020 09:48:40 +0000
Message-Id: <20200303094844.26694-15-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303094844.26694-1-jeremy@azazel.net>
References: <20200303094844.26694-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If a user uses a variable payload expression in a payload statement, the
structure of the statement value is not handled by the existing
statement postprocessing function, so we need to extend it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 74 +++++++++++++++++++++++++++++++++++----
 1 file changed, 68 insertions(+), 6 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index e8e9e5719ee8..571cab1d932b 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2514,7 +2514,7 @@ static void stmt_payload_binop_pp(struct rule_pp_ctx *ctx, struct expr *binop)
 	}
 }
 
-static bool stmt_payload_binop_postprocess_i(struct rule_pp_ctx *ctx)
+static bool stmt_payload_binop_postprocess_i_a(struct rule_pp_ctx *ctx)
 {
 	struct expr *expr, *binop, *payload, *value, *mask;
 	struct stmt *stmt = ctx->stmt;
@@ -2568,6 +2568,56 @@ static bool stmt_payload_binop_postprocess_i(struct rule_pp_ctx *ctx)
 	return true;
 }
 
+static bool stmt_payload_binop_postprocess_i_b(struct rule_pp_ctx *ctx)
+{
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
+	xor     = expr->right;
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
+	if (payload_expr_trim(payload, mask, &ctx->pctx, &shift))
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
@@ -2634,21 +2684,30 @@ static bool stmt_payload_binop_postprocess_ii(struct rule_pp_ctx *ctx)
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
@@ -2671,7 +2730,10 @@ static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
 
 	switch (expr->left->etype) {
 	case EXPR_BINOP: /* I? */
-		if (stmt_payload_binop_postprocess_i(ctx))
+		if (stmt_payload_binop_postprocess_i_a(ctx))
+			return;
+
+		if (stmt_payload_binop_postprocess_i_b(ctx))
 			return;
 		break;
 	case EXPR_PAYLOAD: /* II? */
-- 
2.25.1

