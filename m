Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 597BEC77B7E
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 14:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjE1OBf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 10:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjE1OBe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 10:01:34 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BB0C7
        for <netfilter-devel@vger.kernel.org>; Sun, 28 May 2023 07:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ExHsRPHi8lRmIoEB6mUVHiBdbgkNAGYrJIqfPkOmyC0=; b=NV5gTTXJbqc0RsO76KKJYio0IY
        7oQWlaM1Mibcq6ab6I10SRrxXRvQweBeh8a7Qg7iXaJAFBN/3tV4jM58itnXwCoMKoIDbwmTAml/k
        UEvUb5Gf2mgSWlyHwMcL++u/NjiaeA18bVJDOPYbsht8eHBFx9UBOZxKetN0ghV07EtDd/Vw/S0TQ
        gxOP4dG/UD7xpULjWWUx68slg/ZC0UU+InoLwjNXK5Jd95JtZk1i/rqtODtOhxNbT+gZp6Vr85Dvu
        Od40hz9vw8dfiOt0wmamH/CotNHVWJkSU9POjV3hu0BAxr2NDup3W3jGO44HVi3eEHCrwsoNyXgCM
        ymAmKRTw==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q3Gxe-008Xe1-BI; Sun, 28 May 2023 15:01:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [PATCH nft v5 4/8] evaluate: prevent nested byte-order conversions
Date:   Sun, 28 May 2023 15:00:54 +0100
Message-Id: <20230528140058.1218669-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230528140058.1218669-1-jeremy@azazel.net>
References: <20230528140058.1218669-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is a an assertion in `expr_evaluate_unary` that checks that the
operand of the unary operation is not itself a unary expression.  Add a
check to `byteorder_conversion` to ensure that this is the case by
removing an existing unary operation, rather than adding a second one.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 17a437bd6530..77781f0ec6de 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -195,7 +195,12 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 
 	if (expr_is_constant(*expr) || div_round_up((*expr)->len, BITS_PER_BYTE) < 2)
 		(*expr)->byteorder = byteorder;
-	else {
+	else if ((*expr)->etype == EXPR_UNARY) {
+		/* Remove existing conversion */
+		struct expr *unary = *expr;
+		*expr = expr_get((*expr)->arg);
+		expr_free(unary);
+	} else {
 		op = byteorder_conversion_op(*expr, byteorder);
 		*expr = unary_expr_alloc(&(*expr)->location, op, *expr);
 		if (expr_evaluate(ctx, expr) < 0)
-- 
2.39.2

