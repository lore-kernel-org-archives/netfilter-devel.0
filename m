Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3984C7EE2F
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 14:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjE1OBh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 10:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjE1OBe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 10:01:34 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A282BCF
        for <netfilter-devel@vger.kernel.org>; Sun, 28 May 2023 07:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/cvai6cbsVzloqQxr6zIxMWMSjb7kobvQEcBmhQRxUU=; b=HsMGKdU4A/x2XO2RcB6VfY/3gG
        sHOU0Z00l6VNRCwAmZbdkd38uY2eom8sxz4y2HTkUA+a5dIlgf2TTtLYmLdttJbKmFql/degZBm57
        sX5iW7OkThRUZbZAB3au20ULdcWh6E14uASpRfPhDngor58KlCLrtkeraA4jcFR+41stcwmwMe0NO
        hAa0qKnCDTiPkGivUYqcbzIb92TPK0IvXQvbUm5IXN9Xvf1ZWipHhp0PZ9pV0YABp6+nNnHXcWCQt
        JPh4D8UMFSDxLXYrSX1ITAWf+8ac1Qa0cWpcfC169jYiIo3pvYlmB8Gv/fi/Kyzu/N7G/Ld68iHU+
        E4/GQmoA==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q3Gxe-008Xe1-D4; Sun, 28 May 2023 15:01:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [PATCH nft v5 5/8] evaluate: preserve existing binop properties
Date:   Sun, 28 May 2023 15:00:55 +0100
Message-Id: <20230528140058.1218669-6-jeremy@azazel.net>
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

In certain cases, such as evaluating payload statement arguments, we
allocate new binop expressions and set properties such as length,
data-type and byte-order.  When the new expressions are themselves
evaluated, these properties are overridden.  Since the length of
expression is set in all cases, check for this and preserve the length,
data-type and byte-order for bitwise op's and the length for shifts.

Remove a couple of superfluous assignments for a left-shift which were
being correctly overridden.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 77781f0ec6de..136b4539e828 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1301,7 +1301,9 @@ static int expr_evaluate_shift(struct eval_ctx *ctx, struct expr **expr)
 	unsigned int shift = mpz_get_uint32(right->value);
 	unsigned int max_shift_len;
 
-	if (ctx->stmt_len > left->len)
+	if (op->len)
+		max_shift_len = op->len;
+	else if (ctx->stmt_len > left->len)
 		max_shift_len = ctx->stmt_len;
 	else
 		max_shift_len = left->len;
@@ -1335,7 +1337,16 @@ static int expr_evaluate_bitwise(struct eval_ctx *ctx, struct expr **expr)
 	unsigned int max_len;
 	int byteorder;
 
-	if (ctx->stmt_len > left->len) {
+	if (op->len) {
+		max_len = op->len;
+		byteorder = op->byteorder;
+		dtype = op->dtype;
+
+		if (byteorder_conversion(ctx, &op->left, byteorder) < 0)
+			return -1;
+
+		left = op->left;
+	} else if (ctx->stmt_len > left->len) {
 		max_len = ctx->stmt_len;
 		byteorder = BYTEORDER_HOST_ENDIAN;
 		dtype = &integer_type;
@@ -2962,8 +2973,6 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 
 		lshift = binop_expr_alloc(&payload->location, OP_LSHIFT,
 					  stmt->payload.val, off);
-		lshift->dtype     = payload->dtype;
-		lshift->byteorder = payload->byteorder;
 
 		stmt->payload.val = lshift;
 	}
-- 
2.39.2

