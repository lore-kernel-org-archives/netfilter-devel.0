Return-Path: <SRS0=4Rej=4R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C149AC3F2CE
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98D182469C
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:44:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="skvT3o2q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgB2Lod (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Feb 2020 06:44:33 -0500
Received: from kadath.azazel.net ([81.187.231.250]:49518 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgB2Lod (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Feb 2020 06:44:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VF9PJtQVHttxupgh26QbmOWyOBY15GiFDyyUXLnv5t4=; b=skvT3o2qf1ammyRCwFRESsTCTY
        ETVgvUEtqEzFwNAxsv42JPODKMC6lAzv4tA2WNEd2IvLK72Lmu9wVgjSat+q5OJDMsyw/XaT+PJIj
        pVGHg3nc6BZlImLI0oUOnoabsqbyJNZP9AaLyIdC84PDS4cqW/xxX85o3SIAOKjMVgNbCiivqxno0
        x4PuaqEZKLrxmoew4J3v8b7o1AeVOS6hiJwC7z3TseDCbmbbiqoCNGR8fa6UPaBnY0GvJPDwqVsKH
        iLDp7CzBPN7SyeetXHxnle6X0u8e7FfFO1R+QSPLQP5Q4ScxVk2JZ4FAE/lyQzsDejeNKvfYGPiOs
        U06aYr+g==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j80HN-0003Wm-7F; Sat, 29 Feb 2020 11:27:33 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 10/18] evaluate: allow boolean binop expressions with variable righthand arguments.
Date:   Sat, 29 Feb 2020 11:27:23 +0000
Message-Id: <20200229112731.796417-11-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200229112731.796417-1-jeremy@azazel.net>
References: <20200229112731.796417-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hitherto, the kernel has required constant values for the xor and mask
attributes of boolean bitwise expressions.  This has meant that the
righthand argument of a boolean binop must be constant.  Now the kernel
supports passing mask and xor via registers, we can relax this
restriction.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 34b71d1312cb..b3735cd01c46 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1135,7 +1135,7 @@ static int expr_evaluate_bitwise(struct eval_ctx *ctx, struct expr **expr)
 	op->byteorder = left->byteorder;
 	op->len	      = left->len;
 
-	if (expr_is_constant(left))
+	if (expr_is_constant(left) && expr_is_constant(op->right))
 		return constant_binop_simplify(ctx, expr);
 	return 0;
 }
@@ -1179,23 +1179,22 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 					 "for %s expressions",
 					 sym, expr_name(left));
 
-	if (!expr_is_constant(right))
-		return expr_binary_error(ctx->msgs, right, op,
-					 "Right hand side of binary operation "
-					 "(%s) must be constant", sym);
-
-	if (!expr_is_singleton(right))
-		return expr_binary_error(ctx->msgs, left, op,
-					 "Binary operation (%s) is undefined "
-					 "for %s expressions",
-					 sym, expr_name(right));
-
 	/* The grammar guarantees this */
 	assert(expr_basetype(left) == expr_basetype(right));
 
 	switch (op->op) {
 	case OP_LSHIFT:
 	case OP_RSHIFT:
+		if (!expr_is_constant(right))
+			return expr_binary_error(ctx->msgs, right, op,
+						 "Right hand side of binary operation "
+						 "(%s) must be constant", sym);
+
+		if (!expr_is_singleton(right))
+			return expr_binary_error(ctx->msgs, left, op,
+						 "Binary operation (%s) is undefined "
+						 "for %s expressions",
+						 sym, expr_name(right));
 		return expr_evaluate_shift(ctx, expr);
 	case OP_AND:
 	case OP_XOR:
-- 
2.25.0

