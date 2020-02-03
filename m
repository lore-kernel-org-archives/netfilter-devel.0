Return-Path: <SRS0=ffOv=3X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC65C3524D
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 11:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3792320721
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 11:20:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="tMIWQjza"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgBCLUY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 06:20:24 -0500
Received: from kadath.azazel.net ([81.187.231.250]:33248 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbgBCLUY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 06:20:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LXsxCAx33gxZBJljHWbJRxFEcyPvr+QoeGZZqx9y5vs=; b=tMIWQjzaL0HNCG7JaoM9ksUWQ2
        j7X+zRF1dqZyWq4Wjah84VGGoX9W1FJEYgamFz11w2dABI7i5/ZoJ7g75CWJzdlHfnG5X3GlLGHu8
        YYsgu+fF1ZHXFZzuKb6HcxewNbYHnXfwfkERaR5X+0NPc3AL0aF/w48Ta+OquzDGdFLpfDKB7q6Cu
        WYWwNMACghNTP+zvcROzl8HXNd0zIdPpLOKn3vEtqHpEtqGqGDjEtjXs5drhvwh9uUVFobRM6eefP
        s24rmdRSASoL1rVpxylUeXHDEvcWvYIAFtNTB1Fgjqfd+TzCLcmNCONqjVDqxbWApjP90c+ahtRaO
        /f0+YP5w==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iyZmB-0007Br-D8
        for netfilter-devel@vger.kernel.org; Mon, 03 Feb 2020 11:20:23 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v4 2/6] evaluate: correct variable name.
Date:   Mon,  3 Feb 2020 11:20:19 +0000
Message-Id: <20200203112023.646840-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200203112023.646840-1-jeremy@azazel.net>
References: <20200203112023.646840-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Rename the `lshift` variable used to store an right-shift expression to
`rshift`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 09dd493f0757..966582e44a7d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -450,7 +450,7 @@ static uint8_t expr_offset_shift(const struct expr *expr, unsigned int offset,
 
 static void expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 {
-	struct expr *expr = *exprp, *and, *mask, *lshift, *off;
+	struct expr *expr = *exprp, *and, *mask, *rshift, *off;
 	unsigned masklen, len = expr->len, extra_len = 0;
 	uint8_t shift;
 	mpz_t bitmask;
@@ -490,12 +490,12 @@ static void expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 					  BYTEORDER_BIG_ENDIAN,
 					  sizeof(shift), &shift);
 
-		lshift = binop_expr_alloc(&expr->location, OP_RSHIFT, and, off);
-		lshift->dtype		= expr->dtype;
-		lshift->byteorder	= expr->byteorder;
-		lshift->len		= masklen;
+		rshift = binop_expr_alloc(&expr->location, OP_RSHIFT, and, off);
+		rshift->dtype		= expr->dtype;
+		rshift->byteorder	= expr->byteorder;
+		rshift->len		= masklen;
 
-		*exprp = lshift;
+		*exprp = rshift;
 	} else
 		*exprp = and;
 
-- 
2.24.1

