From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 1/4] payload: generate dependency in the appropriate byteorder
Date: Sun, 21 Sep 2014 21:32:34 +0200
Message-ID: <1411327957-19379-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:60858 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaIUTc1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Sep 2014 15:32:27 -0400
Received: by mail-wg0-f47.google.com with SMTP id y10so1949942wgg.6
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Sep 2014 12:32:26 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we add a dependency, the constant expression on the right
hand side must be represented in the appropriate order.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/payload.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/payload.c b/src/payload.c
index 1eee4e0..a3bbe51 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -216,8 +216,7 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 		left = payload_expr_alloc(&expr->location, desc, desc->protocol_key);
 
 	right = constant_expr_alloc(&expr->location, tmpl->dtype,
-				    BYTEORDER_HOST_ENDIAN,
-				    tmpl->len,
+				    tmpl->dtype->byteorder, tmpl->len,
 				    constant_data_ptr(protocol, tmpl->len));
 
 	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
-- 
1.7.10.4

