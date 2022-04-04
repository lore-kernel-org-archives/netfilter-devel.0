Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36250C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344081AbiDDMaX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344755AbiDDMaT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:30:19 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F863D1DB
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nmShUkBOrJUFAxnCKqqWvOadVjEjYOtLkrRiPiMBxkA=; b=tR4dIP6MWWhATusSwN7+D5KtL5
        fgVkjSPCJ2luseX9UzVG4etxENtsBJsKYUfgr/4ZPR0pX/tuTDVVKsziR7vEMdKBLlUib6B/tOsfP
        8JX31vPOZD0yBkFvJGIQr9Gj8EC9I9GKZA/3Tuwh9GVBT9ZnRakECQreV474RlFWZv+RXcif5w3+Z
        dC8EiSTrGJ5lXxDsKlp82k/PEOsPrPZCQA2PKBB+cgvzm7QrPo1gfzgycAyAeeiR1UJvA+n4JXO0A
        ktBlMMjuskk/2Res438g+LrCdU+Dnu0v0YEkgQ3eyUg+WxdwKdNO6+8/2XoIjloml5nXQr0h/Cr2G
        bPdhc0RQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbK-007FTC-GU; Mon, 04 Apr 2022 13:14:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 21/32] evaluate: don't clobber binop lengths
Date:   Mon,  4 Apr 2022 13:13:59 +0100
Message-Id: <20220404121410.188509-22-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404121410.188509-1-jeremy@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Binops with variable RHS operands will make it possible to do thing like
this:

  nft add rule t c ip dscp set ip dscp and 0xc

However, the netlink dump reveals a problem:

  [ payload load 2b @ network header + 0 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
  [ payload load 1b @ network header + 1 => reg 2 ]
  [ bitwise reg 2 = ( reg 2 & 0x0000003c ) ^ 0x00000000 ]
  [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
  [ bitwise reg 2 = ( reg 2 & 0x0000000c ) ^ 0x00000000 ]
  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]

The mask at line 4 should be 0xfc, not 0x3c.

Evaluation of the payload expression munges it from `ip dscp` to
`(ip dscp & 0xfc) >> 2`, because although `ip dscp` is only 6 bits long,
those 6 bits are the top bits in a byte, and to make the arithmetic
simpler when we perform comparisons and assignments, we mask and shift
the field.  When the AND expression is allocated, its length is
correctly set to 8.  However, when a binop is evaluated, it is assumed
that the length has not been set and it always set to the length of the
left operand, incorrectly to 6 in this case.  When the bitwise netlink
expression is generated, the length of the AND is used to generate the
mask, 0x3f, used in combining the binop's.  The upshot of this is that
the original mask gets mangled to 0x3c.

We can fix this by changing the evaluation of binops only to set the
op's length if it is not already set.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 3f697eb1dd43..e19f6300fe2c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1121,7 +1121,7 @@ static int expr_evaluate_shift(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *op = *expr, *left = op->left, *right = op->right;
 	unsigned int shift = mpz_get_uint32(right->value);
-	unsigned int op_len = left->len;
+	unsigned int op_len = op->len ? : left->len;
 
 	if (shift >= op_len) {
 		if (shift >= ctx->ectx.len)
@@ -1158,7 +1158,7 @@ static int expr_evaluate_bitwise(struct eval_ctx *ctx, struct expr **expr)
 
 	op->dtype     = left->dtype;
 	op->byteorder = left->byteorder;
-	op->len	      = left->len;
+	op->len	      = op->len ? : left->len;
 
 	if (expr_is_constant(left))
 		return constant_binop_simplify(ctx, expr);
-- 
2.35.1

