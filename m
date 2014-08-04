From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 1/5] payload: fix update context with wrong byteorder
Date: Mon,  4 Aug 2014 18:00:07 +0200
Message-ID: <1407168011-6424-2-git-send-email-alvaroneay@gmail.com>
References: <1407168011-6424-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:33601 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaHDQAa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:00:30 -0400
Received: by mail-we0-f179.google.com with SMTP id u57so8074106wes.10
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Aug 2014 09:00:29 -0700 (PDT)
In-Reply-To: <1407168011-6424-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In the evaluation and delinealize steps, we update the protocol
context. The expression must be in host endian byteorder when we update the
context. However, this is not the case because we see them in network
byteorder.

Fix this by converting to the appropriate byteorder before updating
the protocol context otherwise this doesn't work.

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

