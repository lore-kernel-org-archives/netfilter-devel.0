From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: fix export length and data corruption
Date: Mon, 16 Jan 2017 14:38:32 +0100
Message-ID: <1484573912-23612-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50156 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751279AbdAPNiP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 08:38:15 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo reported that ipv6 tests would fail on some systems:
WARNING: line: 5: 'src/nft add rule --debug=netlink ip6 test-ip6 input iif "lo" ip6 flowlabel set 0':
'[ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]' mismatches
'[ bitwise reg 1 = (reg=1 & 0x00000000 ) ^ 0x00000000 ]'
                                    ^ should be 'f'

Problem is that mpz_export_data expects the size of the output
buffer in bytes, but this gave bit-based size.

Then, when mpz_export_data clears the output buffer it will
also clear 8 extra bytes on stack; depending on compiler version (stack
layout) this will then clear the bitmask value that we want to export.

Fixes: 78936d50f306c ("evaluate: add support to set IPv6 non-byte header fields")
Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index cebc5a9ead7a..bcbced1e3dfa 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1798,7 +1798,7 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 	mpz_clear(ff);
 
 	assert(sizeof(data) * BITS_PER_BYTE >= masklen);
-	mpz_export_data(data, bitmask, BYTEORDER_HOST_ENDIAN, masklen);
+	mpz_export_data(data, bitmask, BYTEORDER_HOST_ENDIAN, sizeof(data));
 	mask = constant_expr_alloc(&payload->location, expr_basetype(payload),
 				   BYTEORDER_HOST_ENDIAN, masklen, data);
 
-- 
2.7.3

