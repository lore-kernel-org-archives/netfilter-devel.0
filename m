From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] evaluate: fix wrong port natting in little endian
Date: Mon, 22 Dec 2014 12:31:26 +0100
Message-ID: <1419247886-3820-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, christophe.leroy@c-s.fr
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36134 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215AbaLVL3D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:29:03 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use a 4-bytes word to store the immediate expression that stores the
port number (instead of 2-bytes). The port netlink attribute is 4-bytes
long, if we use a 2-bytes word the kernel misinterprets the 2-bytes
value in little endian.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Christophe: Could you test this patch in you little-endian testbed?
Thanks.

 src/evaluate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 8f0acf7..37350b4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1516,7 +1516,7 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 						 "valid after transport protocol match");
 
 		expr_set_context(&ctx->ectx, &inet_service_type,
-				 2 * BITS_PER_BYTE);
+				 4 * BITS_PER_BYTE);
 		err = expr_evaluate(ctx, &stmt->nat.proto);
 		if (err < 0)
 			return err;
@@ -1578,7 +1578,7 @@ static int stmt_evaluate_redir(struct eval_ctx *ctx, struct stmt *stmt)
 						 "missing transport protocol match");
 
 		expr_set_context(&ctx->ectx, &inet_service_type,
-				 2 * BITS_PER_BYTE);
+				 4 * BITS_PER_BYTE);
 		err = expr_evaluate(ctx, &stmt->redir.proto);
 		if (err < 0)
 			return err;
-- 
1.7.10.4

