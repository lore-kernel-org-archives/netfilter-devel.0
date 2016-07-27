From: Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 3/7] evaluate: add support to set IPv6 non-byte header fields
Date: Wed, 27 Jul 2016 02:43:12 +0200
Message-ID: <1469580196-2100-4-git-send-email-fw@strlen.de>
References: <1469580196-2100-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60754 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756066AbcG0BPO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 21:15:14 -0400
In-Reply-To: <1469580196-2100-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

'ip6 ecn set 1' will generate a zero-sized write operation.
Just like when matching on bit-sized header fields we need to
round up to a byte-sized quantity and add a mask to retain those
bits outside of the header bits that we want to change.

Example:

ip6 ecn set ce
  [ payload load 1b @ network header + 1 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x000000cf ) ^ 0x00000030 ]
  [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 ]

1. Load the full byte containing the ecn bits
2 .Mask out everything *BUT* the ecn bits
3 .Set the CE mark

This patch only works if the protcol doesn't need a checksum fixup.
Will address this in a followup patch.

This also doesn't yet include the needed reverse translation.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 77 insertions(+), 4 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 8116735..e6d4642 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1608,13 +1608,86 @@ static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 {
+	struct expr *binop, *mask, *and, *payload_bytes;
+	unsigned int masklen, extra_len = 0;
+	unsigned int payload_byte_size;
+	uint8_t shift_imm, data[16];
+	struct expr *payload;
+	mpz_t bitmask, ff;
+
 	if (__expr_evaluate_payload(ctx, stmt->payload.expr) < 0)
 		return -1;
 
-	return stmt_evaluate_arg(ctx, stmt,
-				 stmt->payload.expr->dtype,
-				 stmt->payload.expr->len,
-				 &stmt->payload.val);
+	payload = stmt->payload.expr;
+	if (stmt_evaluate_arg(ctx, stmt, payload->dtype, payload->len,
+			      &stmt->payload.val) < 0)
+		return -1;
+
+	/* Normal case: byte sized and byte aligned */
+	if (payload->payload.offset % BITS_PER_BYTE == 0 &&
+	    payload->len % BITS_PER_BYTE == 0)
+		return 0;
+
+	shift_imm = expr_offset_shift(payload, payload->payload.offset, &extra_len);
+	if (shift_imm) {
+		struct expr *off;
+
+		off = constant_expr_alloc(&payload->location,
+					  expr_basetype(payload),
+					  BYTEORDER_HOST_ENDIAN,
+					  sizeof(shift_imm), &shift_imm);
+
+		binop = binop_expr_alloc(&payload->location, OP_LSHIFT,
+					 stmt->payload.val, off);
+		binop->dtype		= payload->dtype;
+		binop->byteorder		= payload->byteorder;
+
+		stmt->payload.val = binop;
+	}
+
+	payload_byte_size = round_up(payload->len, BITS_PER_BYTE) / BITS_PER_BYTE;
+	payload_byte_size += (extra_len / BITS_PER_BYTE);
+	masklen = payload_byte_size * BITS_PER_BYTE;
+	mpz_init_bitmask(ff, masklen);
+
+	mpz_init2(bitmask, masklen);
+	mpz_bitmask(bitmask, payload->len);
+	mpz_lshift_ui(bitmask, shift_imm);
+
+	mpz_xor(bitmask, ff, bitmask);
+	mpz_clear(ff);
+
+	assert(sizeof(data) * BITS_PER_BYTE >= masklen);
+	mpz_export_data(data, bitmask, BYTEORDER_HOST_ENDIAN, masklen);
+	mask = constant_expr_alloc(&payload->location, expr_basetype(payload),
+				   BYTEORDER_HOST_ENDIAN, masklen, data);
+
+	payload_bytes = payload_expr_alloc(&payload->location, NULL, 0);
+	payload_init_raw(payload_bytes, payload->payload.base,
+			 (payload->payload.offset / BITS_PER_BYTE) * BITS_PER_BYTE,
+			 payload_byte_size * BITS_PER_BYTE);
+
+	payload_bytes->payload.desc	 = payload->payload.desc;
+	payload_bytes->dtype		 = &integer_type;
+	payload_bytes->byteorder	 = payload->byteorder;
+
+	payload->len = payload_bytes->len;
+	payload->payload.offset = payload_bytes->payload.offset;
+
+	and = binop_expr_alloc(&payload->location, OP_AND, payload_bytes, mask);
+
+	and->dtype		 = payload_bytes->dtype;
+	and->byteorder		 = payload_bytes->byteorder;
+	and->len		 = payload_bytes->len;
+
+	binop = binop_expr_alloc(&payload->location, OP_XOR, and,
+				 stmt->payload.val);
+	binop->dtype		= payload->dtype;
+	binop->byteorder	= payload->byteorder;
+	binop->len		= mask->len;
+	stmt->payload.val = binop;
+
+	return expr_evaluate(ctx, &stmt->payload.val);
 }
 
 static int stmt_evaluate_flow(struct eval_ctx *ctx, struct stmt *stmt)
-- 
2.7.3

