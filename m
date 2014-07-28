From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 1/4] payload: fix update context with wrong byteorder
Date: Mon, 28 Jul 2014 13:51:48 +0200
Message-ID: <1406548311-31354-2-git-send-email-alvaroneay@gmail.com>
References: <1406548311-31354-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:46553 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaG1Lv7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:51:59 -0400
Received: by mail-we0-f177.google.com with SMTP id w62so7055438wes.8
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Jul 2014 04:51:58 -0700 (PDT)
In-Reply-To: <1406548311-31354-1-git-send-email-alvaroneay@gmail.com>
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
 * nft add rule filter input ip protocol udp counter
 * nft add rule filter input tcp dport 22 counter
 * nft add rule filter bridge input ether type ip

 src/payload.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/payload.c b/src/payload.c
index a1785a5..be3d610 100644
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

