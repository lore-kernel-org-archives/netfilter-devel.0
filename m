Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D81AFC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 13:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242281AbiDIOA6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 10:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbiDIOA4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 10:00:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9EBDF2B
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 06:58:47 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ndBby-0008KM-3S; Sat, 09 Apr 2022 15:58:46 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 2/9] evaluate: keep prefix expression length
Date:   Sat,  9 Apr 2022 15:58:25 +0200
Message-Id: <20220409135832.17401-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220409135832.17401-1-fw@strlen.de>
References: <20220409135832.17401-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Else, range_expr_value_high() will see a 0 length when doing:

mpz_init_bitmask(tmp, expr->len - expr->prefix_len);

This wasn't a problem so far because prefix expressions generated
from "string*" were never passed down to the prefix->range conversion
functions.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c   | 1 +
 src/expression.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index d5ae071add1f..a20cc396b33f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -347,6 +347,7 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 	datatype_set(prefix, ctx->ectx.dtype);
 	prefix->flags |= EXPR_F_CONSTANT;
 	prefix->byteorder = BYTEORDER_HOST_ENDIAN;
+	prefix->len = expr->len;
 
 	expr_free(expr);
 	*exprp = prefix;
diff --git a/src/expression.c b/src/expression.c
index 9c9a7ced9121..deb649e1847b 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1465,6 +1465,7 @@ void range_expr_value_high(mpz_t rop, const struct expr *expr)
 		return mpz_set(rop, expr->value);
 	case EXPR_PREFIX:
 		range_expr_value_low(rop, expr->prefix);
+		assert(expr->len >= expr->prefix_len);
 		mpz_init_bitmask(tmp, expr->len - expr->prefix_len);
 		mpz_add(rop, rop, tmp);
 		mpz_clear(tmp);
-- 
2.35.1

