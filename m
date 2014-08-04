From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 2/5] payload: generate dependency in the correct byteorder
Date: Mon,  4 Aug 2014 18:00:08 +0200
Message-ID: <1407168011-6424-3-git-send-email-alvaroneay@gmail.com>
References: <1407168011-6424-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:57190 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaHDQAb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:00:31 -0400
Received: by mail-wg0-f50.google.com with SMTP id n12so7948028wgh.33
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Aug 2014 09:00:30 -0700 (PDT)
In-Reply-To: <1407168011-6424-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, we suppose that all the dependency are in host endian. The problem
is if we try to add a dependency with big endian byteorder, we create
this dependency wrong. For example, if we add a ether type dependency in bridge,
we must use big endian byteorder and we use host endian and we create wrong the
payload.

Now, we are going to create the dependency taking account the byteorder.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/payload.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/payload.c b/src/payload.c
index be3d610..8b10a79 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -213,8 +213,7 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 		left = payload_expr_alloc(&expr->location, desc, desc->protocol_key);
 
 	right = constant_expr_alloc(&expr->location, tmpl->dtype,
-				    BYTEORDER_HOST_ENDIAN,
-				    tmpl->len,
+				    tmpl->dtype->byteorder, tmpl->len,
 				    constant_data_ptr(protocol, tmpl->len));
 
 	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
-- 
1.7.10.4

