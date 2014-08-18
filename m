From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/3] payload: take endianess into account when updating the payload context
Date: Tue, 19 Aug 2014 00:27:29 +0100
Message-ID: <1408404451-9075-2-git-send-email-kaber@trash.net>
References: <1408404451-9075-1-git-send-email-kaber@trash.net>
Cc: alvaroneay@gmail.com, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53270 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbaHRX1i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2014 19:27:38 -0400
In-Reply-To: <1408404451-9075-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

payload_expr_pctx_update() uses the numeric protocol value in host byte
order to find the upper layer protocol. This obviously doesn't work for
protocol expressions in other byte orders, such as the ethernet protocol
on little endian.

Export the protocol value in the correct byte order and use that value
to look up the upper layer protocol.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/payload.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/src/payload.c b/src/payload.c
index a1785a5..47861ed 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -69,13 +69,20 @@ static void payload_expr_pctx_update(struct proto_ctx *ctx,
 {
 	const struct expr *left = expr->left, *right = expr->right;
 	const struct proto_desc *base, *desc;
+	unsigned int proto = 0;
 
 	if (!(left->flags & EXPR_F_PROTOCOL))
 		return;
 
 	assert(expr->op == OP_EQ);
+
+	/* Export the data in the correct byte order */
+	assert(right->len / BITS_PER_BYTE <= sizeof(proto));
+	mpz_export_data(&proto, right->value, right->byteorder,
+			right->len / BITS_PER_BYTE);
+
 	base = ctx->protocol[left->payload.base].desc;
-	desc = proto_find_upper(base, mpz_get_uint32(right->value));
+	desc = proto_find_upper(base, proto);
 
 	proto_ctx_update(ctx, left->payload.base + 1, &expr->location, desc);
 }
-- 
1.9.3

