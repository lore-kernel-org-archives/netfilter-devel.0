Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397E5C76195
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Mar 2023 09:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjCQJ6n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Mar 2023 05:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCQJ6m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2023 05:58:42 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE44912F03
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2023 02:58:40 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 4/9] evaluate: don't eval unary arguments
Date:   Fri, 17 Mar 2023 10:58:28 +0100
Message-Id: <20230317095833.1225401-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230317095833.1225401-1-pablo@netfilter.org>
References: <20230317095833.1225401-1-pablo@netfilter.org>
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
index 06aa71561619..6d61cdb25f3d 100644
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

