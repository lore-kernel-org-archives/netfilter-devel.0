Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE1FC77B6C
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Mar 2023 16:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbjCWQ7L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Mar 2023 12:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbjCWQ7I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Mar 2023 12:59:08 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E35ED2D62
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Mar 2023 09:59:07 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     jeremy@azazel.net, fw@strlen.de
Subject: [PATCH nft,v3 06/12] evaluate: honor statement length in integer evaluation
Date:   Thu, 23 Mar 2023 17:58:49 +0100
Message-Id: <20230323165855.559837-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230323165855.559837-1-pablo@netfilter.org>
References: <20230323165855.559837-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Otherwise, bogus error is reported:

 # nft --debug=netlink add rule ip x y 'ct mark set ip dscp & 0x0f << 1 | 0xff000000'
 Error: Value 4278190080 exceeds valid range 0-63
 add rule ip x y ct mark set ip dscp & 0x0f << 1 | 0xff000000
                                                   ^^^^^^^^^^

Use the statement length as the maximum value in the mark statement
expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 1ee9bdc5aa47..7c3b5b4ddddb 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -389,6 +389,7 @@ static int expr_evaluate_integer(struct eval_ctx *ctx, struct expr **exprp)
 {
 	struct expr *expr = *exprp;
 	char *valstr, *rangestr;
+	uint32_t masklen;
 	mpz_t mask;
 
 	if (ctx->ectx.maxval > 0 &&
@@ -401,7 +402,12 @@ static int expr_evaluate_integer(struct eval_ctx *ctx, struct expr **exprp)
 		return -1;
 	}
 
-	mpz_init_bitmask(mask, ctx->ectx.len);
+	if (ctx->stmt_len > ctx->ectx.len)
+		masklen = ctx->stmt_len;
+	else
+		masklen = ctx->ectx.len;
+
+	mpz_init_bitmask(mask, masklen);
 	if (mpz_cmp(expr->value, mask) > 0) {
 		valstr = mpz_get_str(NULL, 10, expr->value);
 		rangestr = mpz_get_str(NULL, 10, mask);
@@ -414,7 +420,7 @@ static int expr_evaluate_integer(struct eval_ctx *ctx, struct expr **exprp)
 		return -1;
 	}
 	expr->byteorder = ctx->ectx.byteorder;
-	expr->len = ctx->ectx.len;
+	expr->len = masklen;
 	mpz_clear(mask);
 	return 0;
 }
-- 
2.30.2

