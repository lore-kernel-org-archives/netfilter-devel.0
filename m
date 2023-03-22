Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83745C6FD1F
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Mar 2023 21:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjCVVxS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Mar 2023 17:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjCVVxR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2023 17:53:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 192AA34016
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2023 14:53:09 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 3/8] evaluate: don't eval unary arguments
Date:   Wed, 22 Mar 2023 22:52:58 +0100
Message-Id: <20230322215303.239763-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230322215303.239763-1-pablo@netfilter.org>
References: <20230322215303.239763-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

When a unary expression is inserted to implement a byte-order
conversion, the expression being converted has already been evaluated
and so `expr_evaluate_unary` doesn't need to do so.

This is required by {ct|meta} statements with bitwise operations, which
might result in byteorder conversion of the expression.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 33161f1e2012..dfb1236e3b8a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1198,12 +1198,10 @@ static int expr_evaluate_range(struct eval_ctx *ctx, struct expr **expr)
  */
 static int expr_evaluate_unary(struct eval_ctx *ctx, struct expr **expr)
 {
-	struct expr *unary = *expr, *arg;
+	struct expr *unary = *expr, *arg = unary->arg;
 	enum byteorder byteorder;
 
-	if (expr_evaluate(ctx, &unary->arg) < 0)
-		return -1;
-	arg = unary->arg;
+	/* unary expression arguments has already been evaluated. */
 
 	assert(!expr_is_constant(arg));
 	assert(expr_basetype(arg)->type == TYPE_INTEGER);
-- 
2.30.2

