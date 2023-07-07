Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E99EB64D9
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jul 2023 22:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjGGWCL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Jul 2023 18:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjGGWCK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jul 2023 18:02:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34DD5FF
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jul 2023 15:02:08 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: place byteorder conversion before rshift
Date:   Sat,  8 Jul 2023 00:02:01 +0200
Message-Id: <20230707220201.150177-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For bitfield that spans more than one byte, such as ip6 dscp, byteorder
conversion needs to be done before rshift. Add unary expression for this
conversion only in the case of meta and ct statements.

Before this patch:

 # nft --debug=netlink add rule ip6 x y 'meta mark set ip6 dscp'
 ip6 x y
  [ payload load 2b @ network header + 0 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ] <--------- incorrect
  [ meta set mark with reg 1 ]

After this patch:

 # nft --debug=netlink add rule ip6 x y 'meta mark set ip6 dscp'
 ip6 x y
  [ payload load 2b @ network header + 0 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ] <-------- correct
  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
  [ meta set mark with reg 1 ]

For the matching case, binary transfer already deals the rshift to
adjust left and right hand side, the unary conversion is not needed
in such case.

Fixes: 8221d86e616b ("tests: py: add test-cases for ct and packet mark payload expressions")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c              | 12 +++++++++++-
 tests/py/ip6/ct.t.payload   | 10 +++++-----
 tests/py/ip6/meta.t.payload |  4 ++--
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 687f9a7b5924..678ad9b8907d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -508,6 +508,7 @@ static void expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 {
 	struct expr *expr = *exprp, *and, *mask, *rshift, *off;
 	unsigned masklen, len = expr->len, extra_len = 0;
+	enum byteorder byteorder;
 	uint8_t shift;
 	mpz_t bitmask;
 
@@ -542,6 +543,15 @@ static void expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 	and->len	= masklen;
 
 	if (shift) {
+		if (ctx->stmt_len > 0 && div_round_up(masklen, BITS_PER_BYTE) > 1) {
+			int op = byteorder_conversion_op(expr, BYTEORDER_HOST_ENDIAN);
+			and = unary_expr_alloc(&expr->location, op, and);
+			and->len = masklen;
+			byteorder = BYTEORDER_HOST_ENDIAN;
+		} else {
+			byteorder = expr->byteorder;
+		}
+
 		off = constant_expr_alloc(&expr->location,
 					  expr_basetype(expr),
 					  BYTEORDER_HOST_ENDIAN,
@@ -549,7 +559,7 @@ static void expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 
 		rshift = binop_expr_alloc(&expr->location, OP_RSHIFT, and, off);
 		rshift->dtype		= expr->dtype;
-		rshift->byteorder	= expr->byteorder;
+		rshift->byteorder	= byteorder;
 		rshift->len		= masklen;
 
 		*exprp = rshift;
diff --git a/tests/py/ip6/ct.t.payload b/tests/py/ip6/ct.t.payload
index 9b85c75aca30..944208f2dde4 100644
--- a/tests/py/ip6/ct.t.payload
+++ b/tests/py/ip6/ct.t.payload
@@ -2,8 +2,8 @@
 ip6 test-ip6 output
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
-  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
   [ ct set mark with reg 1 ]
@@ -12,8 +12,8 @@ ip6 test-ip6 output
 ip6 test-ip6 output
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
-  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
   [ ct set mark with reg 1 ]
@@ -22,8 +22,8 @@ ip6 test-ip6 output
 ip6 test-ip6 output
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
-  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ bitwise reg 1 = ( reg 1 & 0xfffffffb ) ^ 0x00000004 ]
   [ ct set mark with reg 1 ]
 
@@ -31,8 +31,8 @@ ip6 test-ip6 output
 ip6 test-ip6 output
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
-  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ bitwise reg 1 = ( reg 1 & 0x00ffffff ) ^ 0xff000000 ]
   [ ct set mark with reg 1 ]
 
@@ -40,7 +40,7 @@ ip6 test-ip6 output
 ip6 test-ip6 output
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
-  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ bitwise reg 1 = ( reg 1 & 0x0000003c ) ^ 0x00000000 ]
   [ ct set mark with reg 1 ]
diff --git a/tests/py/ip6/meta.t.payload b/tests/py/ip6/meta.t.payload
index 379a9c133c4a..6a37f1dee7ed 100644
--- a/tests/py/ip6/meta.t.payload
+++ b/tests/py/ip6/meta.t.payload
@@ -65,8 +65,8 @@ ip6 test-ip6 input
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
-  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
   [ meta set mark with reg 1 ]
@@ -75,8 +75,8 @@ ip6 test-ip6 input
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
-  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
   [ meta set mark with reg 1 ]
-- 
2.30.2

