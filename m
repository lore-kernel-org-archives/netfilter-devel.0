Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9354EC4167B
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Nov 2023 21:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjKEV3A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Nov 2023 16:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjKEV27 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Nov 2023 16:28:59 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 45444CC
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Nov 2023 13:28:56 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft] evaluate: place byteorder conversion before rshift in payload expressions
Date:   Sun,  5 Nov 2023 22:28:46 +0100
Message-Id: <20231105212846.311755-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the key from the evaluation context to perform the byteorder
conversion in case that this expression is used for lookups and updates
on explicit sets.

 # nft --debug=netlink add rule ip6 t output ip6 dscp @mapv6
 ip6 t output
  [ payload load 2b @ network header + 0 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]   <-------------- this was missing!
  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
  [ lookup reg 1 set mapv6 ]

Also with set statements (updates from packet path):

 # nft --debug=netlink add rule ip6 t output update @mapv6 { ip6 dscp }
 ip6 t output
  [ payload load 2b @ network header + 0 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]   <------------- also here!
  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
  [ dynset update reg_key 1 set mapv6 ]

Simple matches on values and implicit sets rely on the binary transfer
mechanism to propagate the shift to the constant, no explicit byteorder
is required in such case.

Fixes: 668c18f67203 ("evaluate: place byteorder conversion before rshift in payload statement")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Test not yet in this patch, I plan to send a v2.

 src/evaluate.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 65e4cef9c147..5bbb834b6a6d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -545,7 +545,8 @@ static void expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 	and->len	= masklen;
 
 	if (shift) {
-		if (ctx->stmt_len > 0 && div_round_up(masklen, BITS_PER_BYTE) > 1) {
+		if ((ctx->ectx.key || ctx->stmt_len > 0) &&
+		    div_round_up(masklen, BITS_PER_BYTE) > 1) {
 			int op = byteorder_conversion_op(expr, BYTEORDER_HOST_ENDIAN);
 			and = unary_expr_alloc(&expr->location, op, and);
 			and->len = masklen;
@@ -574,6 +575,7 @@ static void expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 
 static int __expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 {
+	const struct expr *key = ctx->ectx.key;
 	struct expr *expr = *exprp;
 
 	if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
@@ -582,6 +584,8 @@ static int __expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 	if (expr_evaluate_primary(ctx, exprp) < 0)
 		return -1;
 
+	ctx->ectx.key = key;
+
 	if (expr->exthdr.offset % BITS_PER_BYTE != 0 ||
 	    expr->len % BITS_PER_BYTE != 0)
 		expr_evaluate_bits(ctx, exprp);
@@ -878,6 +882,7 @@ static bool payload_needs_adjustment(const struct expr *expr)
 
 static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **exprp)
 {
+	const struct expr *key = ctx->ectx.key;
 	struct expr *expr = *exprp;
 
 	if (expr->payload.evaluated)
@@ -889,6 +894,8 @@ static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **exprp)
 	if (expr_evaluate_primary(ctx, exprp) < 0)
 		return -1;
 
+	ctx->ectx.key = key;
+
 	if (payload_needs_adjustment(expr))
 		expr_evaluate_bits(ctx, exprp);
 
-- 
2.30.2

