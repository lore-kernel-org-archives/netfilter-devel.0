From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] payload: fix endianess issue in payload_expr_pctx_update()
Date: Thu,  4 Dec 2014 14:25:11 +0100
Message-ID: <1417699511-10777-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, christophe.leroy@c-s.fr
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33203 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaLDNXD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:23:03 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use constant_data_ptr() to point to the right memory position on
big endian when exporting data that is stored in a larger variable.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/payload.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/payload.c b/src/payload.c
index ebf8079..83742fb 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -79,8 +79,8 @@ static void payload_expr_pctx_update(struct proto_ctx *ctx,
 
 	/* Export the data in the correct byte order */
 	assert(right->len / BITS_PER_BYTE <= sizeof(proto));
-	mpz_export_data(&proto, right->value, right->byteorder,
-			right->len / BITS_PER_BYTE);
+	mpz_export_data(constant_data_ptr(proto, right->len), right->value,
+			right->byteorder, right->len / BITS_PER_BYTE);
 
 	base = ctx->protocol[left->payload.base].desc;
 	desc = proto_find_upper(base, proto);
-- 
1.7.10.4

