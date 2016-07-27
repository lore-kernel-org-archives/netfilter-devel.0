From: Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 6/7] netlink: make checksum fixup work with odd-sized header fields
Date: Wed, 27 Jul 2016 02:43:15 +0200
Message-ID: <1469580196-2100-7-git-send-email-fw@strlen.de>
References: <1469580196-2100-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60768 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758136AbcG0BPY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 21:15:24 -0400
In-Reply-To: <1469580196-2100-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The kernel checksum functions want even-sized lengths except for
the last block at the end of the data.

This means that

nft --debug=netlink add rule filter output ip ecn set 1

must generate a two byte read and a two byte write:

[ payload load 2b @ network header + 0 => reg 1 ]
[ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000100 ]
[ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]

Otherwise, while a one-byte write is enough, the kernel will
generate invalid checksums (unless checksum is offloaded).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index e6d4642..eca46f7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1606,14 +1606,24 @@ static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static bool stmt_evaluate_payload_need_csum(const struct expr *payload)
+{
+	const struct proto_desc *desc;
+
+	desc = payload->payload.desc;
+
+	return desc && desc->checksum_key;
+}
+
 static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	struct expr *binop, *mask, *and, *payload_bytes;
 	unsigned int masklen, extra_len = 0;
-	unsigned int payload_byte_size;
+	unsigned int payload_byte_size, payload_byte_offset;
 	uint8_t shift_imm, data[16];
 	struct expr *payload;
 	mpz_t bitmask, ff;
+	bool need_csum;
 
 	if (__expr_evaluate_payload(ctx, stmt->payload.expr) < 0)
 		return -1;
@@ -1623,10 +1633,18 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 			      &stmt->payload.val) < 0)
 		return -1;
 
+	need_csum = stmt_evaluate_payload_need_csum(payload);
+
 	/* Normal case: byte sized and byte aligned */
 	if (payload->payload.offset % BITS_PER_BYTE == 0 &&
-	    payload->len % BITS_PER_BYTE == 0)
-		return 0;
+	    payload->len % BITS_PER_BYTE == 0) {
+
+		if (!need_csum || ((payload->len / BITS_PER_BYTE) & 1) == 0)
+			return 0;
+		 /* Can't deal with odd checksum fixup in kernel */
+	}
+
+	payload_byte_offset = payload->payload.offset / BITS_PER_BYTE;
 
 	shift_imm = expr_offset_shift(payload, payload->payload.offset, &extra_len);
 	if (shift_imm) {
@@ -1647,6 +1665,16 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 
 	payload_byte_size = round_up(payload->len, BITS_PER_BYTE) / BITS_PER_BYTE;
 	payload_byte_size += (extra_len / BITS_PER_BYTE);
+
+	if (need_csum && payload_byte_size & 1) {
+		payload_byte_size++;
+
+		if (payload_byte_offset & 1) { /* prefer 16bit aligned fetch */
+			payload_byte_offset--;
+			assert(payload->payload.offset >= BITS_PER_BYTE);
+		}
+	}
+
 	masklen = payload_byte_size * BITS_PER_BYTE;
 	mpz_init_bitmask(ff, masklen);
 
@@ -1664,7 +1692,7 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 
 	payload_bytes = payload_expr_alloc(&payload->location, NULL, 0);
 	payload_init_raw(payload_bytes, payload->payload.base,
-			 (payload->payload.offset / BITS_PER_BYTE) * BITS_PER_BYTE,
+			 payload_byte_offset * BITS_PER_BYTE,
 			 payload_byte_size * BITS_PER_BYTE);
 
 	payload_bytes->payload.desc	 = payload->payload.desc;
-- 
2.7.3

