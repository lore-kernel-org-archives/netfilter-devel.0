From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] evaluate: shift immediate value when adjusting size for csum fixup
Date: Wed, 16 Aug 2017 19:01:55 +0200
Message-ID: <20170816170156.11594-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:47182 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751943AbdHPRBi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2017 13:01:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft add rule .. ip ttl set 64

erronously mangles ip protocol instead of ttl.

Because the kernel can't deal with odd-sized data (ttl is one byte) when
doing checksum fixups, so the write to 'ttl' is turned into

[ payload load 2b @ network header + 8 => reg 1 ]
[ bitwise reg 1 = (reg=1 & 0x000000ff ) ^ $new_value ]
[ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]

While doing so, we did fail to shift the imm value, i.e.
we clear the wrong half of the u16 (protocol) instead of csum.

The correct mask is 0xff00, and $new_value needs to be shifted
so we leave the protocol value (which is next to ttl) alone.

Fixes: f9069cefdf ("netlink: make checksum fixup work with odd-sized header fields")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 0fad0913488d..f52a0843a0c0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1869,6 +1869,20 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 
 	shift_imm = expr_offset_shift(payload, payload->payload.offset,
 				      &extra_len);
+	payload_byte_size = round_up(payload->len, BITS_PER_BYTE) / BITS_PER_BYTE;
+	payload_byte_size += (extra_len / BITS_PER_BYTE);
+
+	if (need_csum && payload_byte_size & 1) {
+		payload_byte_size++;
+
+		if (payload_byte_offset & 1) { /* prefer 16bit aligned fetch */
+			payload_byte_offset--;
+			assert(payload->payload.offset >= BITS_PER_BYTE);
+		} else {
+			shift_imm += BITS_PER_BYTE;
+		}
+	}
+
 	if (shift_imm) {
 		struct expr *off;
 
@@ -1885,17 +1899,6 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 		stmt->payload.val = binop;
 	}
 
-	payload_byte_size = round_up(payload->len, BITS_PER_BYTE) / BITS_PER_BYTE;
-	payload_byte_size += (extra_len / BITS_PER_BYTE);
-
-	if (need_csum && payload_byte_size & 1) {
-		payload_byte_size++;
-
-		if (payload_byte_offset & 1) { /* prefer 16bit aligned fetch */
-			payload_byte_offset--;
-			assert(payload->payload.offset >= BITS_PER_BYTE);
-		}
-	}
 
 	masklen = payload_byte_size * BITS_PER_BYTE;
 	mpz_init_bitmask(ff, masklen);
-- 
2.13.0

