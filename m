From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 2/2] payload: fix update context with wrong byteorder
Date: Thu, 17 Jul 2014 19:27:39 +0200
Message-ID: <1405618059-13739-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:48534 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaGQR2A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:28:00 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so7250929wiw.12
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Jul 2014 10:27:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In the evaluation step and delinealize step, we update the protocol
context. When we update the context, we expect that the expressions
are in host endian but the expressions are in big endian from this
two steps.

To fix this, We do the correct byteorder conversion for finding the
protocol number for updating the context. Example:

nft add rule bridge filter input ether type ip

We have a expression like this:

[ payload load 2b @ link header + 12 => reg 1 ]
  [ cmp eq reg 1 0x00000008 ]

The byteorder of this expressions is big endian and it's in
host endian, for that when we try to update the context, we
don't find the protocol with this number. This is a output,
example:

update network layer protocol context:
 link layer          : ether
 network layer       : none <-
 transport layer     : none

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[Tested with the rules]
* nft add rule filter input ip protocol tcp counter
* nft add rule filter input tcp dport 22 counter
* nft add rule filter bridge input ether type ip

 src/payload.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/payload.c b/src/payload.c
index 432ce44..8b10a79 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -69,13 +69,18 @@ static void payload_expr_pctx_update(struct proto_ctx *ctx,
 {
 	const struct expr *left = expr->left, *right = expr->right;
 	const struct proto_desc *base, *desc;
+	const struct proto_hdr_template *tmpl;
+	uint32_t value = 0;
 
 	if (!(left->flags & EXPR_F_PROTOCOL))
 		return;
 
 	assert(expr->op == OP_EQ);
 	base = ctx->protocol[left->payload.base].desc;
-	desc = proto_find_upper(base, mpz_get_uint32(right->value));
+	tmpl = left->payload.tmpl;
+	mpz_export_data(&value, right->value, tmpl->dtype->byteorder,
+			div_round_up(tmpl->len, BITS_PER_BYTE));
+	desc = proto_find_upper(base, value);
 
 	proto_ctx_update(ctx, left->payload.base + 1, &expr->location, desc);
 }
-- 
1.7.10.4

