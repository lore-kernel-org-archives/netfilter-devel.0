Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73BC1C75E2
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Feb 2025 21:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740776995; cv=none; b=E5RYT5mraLrtYGyZIsmrUQnVHYEIPJyfOhCtso3mcfPtEVPsfLI+ELIcNejtpwOMcodhJg41DBbOyINOXQnj+y+/P1nC6tsL/BTdd+nMpBj/awIYW+mx+v7rabCxTT0byxNbwsmzTfAujYwpwHRtmcLx4uC1etTCyeC8i4DJSp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740776995; c=relaxed/simple;
	bh=KuAia98R15QuTp8Dtyyah9sIpGaU4qXn7BerBxwDhmU=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uzGzBOCVp6TSp33bibvN4ow30obw2Dw9J5jPVocAX1RDvWAXf726sTC+XoikXIEMdeLvBWqTo5WSrAx8N6iXxibS3BgzrZBjSzfLB2roe9+bBrqa3b9sLh2OOQQzkQPRvx0HLrStwOaae0I4Y9g1J6GKSGI2EhcvHFMturV3mKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OOUBndPD; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OOUBndPD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OOUBndPD";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OOUBndPD"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A3DC36030A; Fri, 28 Feb 2025 22:09:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740776985;
	bh=h7cX6uDfU9UjKR0SF7vbaQ0Rru/ZVo5fPKX/IOtUXVc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OOUBndPDTTUWauLhax0jKruXM7l+VWZ25MaPyYrX2XAObry9dr5ZIZmniKL0xNcpa
	 wMiGf9gUQ8waLZeqtadNbkK0gj9UqUFvuZ9K6Y9gzQpxcRVc2G1Pe9+0iY4mJrLOcy
	 4A5pIUL2aI/aRg38QT3Jv5GRMqpkeD55EQ3Q6mYwKDu9yrxrUNtM6RiB/j7O77DIZQ
	 bMdLpzoCiYnuQ8VCvh/w8UwgfdEpBGrzpOanvc6WhFginQs0QJZqvLmByoBWlmpPS2
	 oiPCd+fk0aGbjhPD5neWylEq+En+v0cX1F5l/lwBLLYemPJr3DUbQGKu1BlI9HIf6Z
	 NjpijT450MYWw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 28B566030A
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Feb 2025 22:09:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740776985;
	bh=h7cX6uDfU9UjKR0SF7vbaQ0Rru/ZVo5fPKX/IOtUXVc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OOUBndPDTTUWauLhax0jKruXM7l+VWZ25MaPyYrX2XAObry9dr5ZIZmniKL0xNcpa
	 wMiGf9gUQ8waLZeqtadNbkK0gj9UqUFvuZ9K6Y9gzQpxcRVc2G1Pe9+0iY4mJrLOcy
	 4A5pIUL2aI/aRg38QT3Jv5GRMqpkeD55EQ3Q6mYwKDu9yrxrUNtM6RiB/j7O77DIZQ
	 bMdLpzoCiYnuQ8VCvh/w8UwgfdEpBGrzpOanvc6WhFginQs0QJZqvLmByoBWlmpPS2
	 oiPCd+fk0aGbjhPD5neWylEq+En+v0cX1F5l/lwBLLYemPJr3DUbQGKu1BlI9HIf6Z
	 NjpijT450MYWw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/4] evaluate: support for bitfield payload statement with binary operation
Date: Fri, 28 Feb 2025 22:09:38 +0100
Message-Id: <20250228210939.3319333-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250228210939.3319333-1-pablo@netfilter.org>
References: <20250228210939.3319333-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update bitfield payload statement support to allow for bitwise
and/or/xor updates. Adjust payload expression to fetch 16-bits for
mangling while leaving unmodified bits intact.

 # nft --debug=netlink add rule x y ip dscp set ip dscp or 0x1
 ip x y
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000fbff ) ^ 0x00000400 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]

Skip expr_evaluate_bits() transformation since these are only useful
for payload matching and set lookups.

Listing still shows a raw expression:

  # nft list ruleset
    ...
                    @nh,8,5 set 0x0

The follow up patch completes it:

  ("netlink_delinearize: support for bitfield payload statement with binary operation")

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1698
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index d7915ed19d59..c9c56588cee4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -569,6 +569,13 @@ static int expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 	uint8_t shift;
 	mpz_t bitmask;
 
+	/* payload statement with relational expression as a value does not
+	 * require the transformations that are needed for payload matching,
+	 * skip this.
+	 */
+	if (ctx->stmt && ctx->stmt->ops->type == STMT_PAYLOAD)
+		return 0;
+
 	switch (expr->etype) {
 	case EXPR_PAYLOAD:
 		shift = expr_offset_shift(expr, expr->payload.offset,
@@ -3281,10 +3288,10 @@ static int stmt_evaluate_exthdr(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	struct expr *mask, *and, *xor, *payload_bytes;
-	unsigned int masklen, extra_len = 0;
+	struct expr *mask, *and, *xor, *expr, *payload_bytes;
 	unsigned int payload_byte_size, payload_byte_offset;
 	uint8_t shift_imm, data[NFT_REG_SIZE];
+	unsigned int masklen, extra_len = 0;
 	struct expr *payload;
 	mpz_t bitmask, ff;
 	bool need_csum;
@@ -3350,6 +3357,60 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 		if (shift_imm)
 			mpz_lshift_ui(stmt->payload.val->value, shift_imm);
 		break;
+	case EXPR_BINOP:
+		expr = stmt->payload.val;
+		while (expr->left->etype == EXPR_BINOP)
+			expr = expr->left;
+
+		if (expr->left->etype != EXPR_PAYLOAD)
+			break;
+
+		if (!payload_expr_cmp(payload, expr->left))
+			break;
+
+		/* Adjust payload to fetch 16-bits. */
+		expr->left->payload.offset = payload_byte_offset * BITS_PER_BYTE;
+		expr->left->len = payload_byte_size * BITS_PER_BYTE;
+		expr->left->payload.is_raw = 1;
+
+		switch (expr->right->etype) {
+		case EXPR_VALUE:
+			if (shift_imm)
+				mpz_lshift_ui(expr->right->value, shift_imm);
+
+			/* build bitmask to keep unmodified bits intact */
+			if (expr->op == OP_AND) {
+				masklen = payload_byte_size * BITS_PER_BYTE;
+				mpz_init_bitmask(ff, masklen);
+
+				mpz_init2(bitmask, masklen);
+				mpz_bitmask(bitmask, payload->len);
+				mpz_lshift_ui(bitmask, shift_imm);
+
+				mpz_xor(bitmask, ff, bitmask);
+				mpz_clear(ff);
+
+				mpz_ior(bitmask, expr->right->value, bitmask);
+				mpz_set(expr->right->value, bitmask);
+
+				mpz_clear(bitmask);
+			}
+			break;
+		default:
+			return expr_error(ctx->msgs, expr->right,
+					  "payload statement for this expression is not supported");
+		}
+
+		expr_free(stmt->payload.expr);
+		/* statement payload is the same in expr and value, update it. */
+		stmt->payload.expr = expr_clone(expr->left);
+		payload = stmt->payload.expr;
+		ctx->stmt_len = stmt->payload.expr->len;
+
+		if (expr_evaluate(ctx, &stmt->payload.val) < 0)
+			return -1;
+
+		return 0;
 	default:
 		return expr_error(ctx->msgs, stmt->payload.val,
 				  "payload statement for this expression is not supported");
-- 
2.30.2

