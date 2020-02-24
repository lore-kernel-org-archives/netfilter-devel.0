Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E741C35670
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 00:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D5C92071C
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 00:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgBXAEA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 19:04:00 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46016 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726534AbgBXAD7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 19:03:59 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j61E4-0004lm-Js; Mon, 24 Feb 2020 01:03:56 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     nevola@gmail.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/6] evaluate: add two new helpers
Date:   Mon, 24 Feb 2020 01:03:22 +0100
Message-Id: <20200224000324.9333-5-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200224000324.9333-1-fw@strlen.de>
References: <20200224000324.9333-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In order to support 'dnat to ip saddr map @foo', where @foo returns
both an address and a inet_service, we will need to peek into the map
and process the concatenations sub-expressions.

Add two helpers for this, will be used in followup patches.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 61 ++++++++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 7a70eff95998..ce1e65f48995 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2102,14 +2102,10 @@ static int stmt_prefix_conversion(struct eval_ctx *ctx, struct expr **expr,
 	return 0;
 }
 
-static int stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
-			     const struct datatype *dtype, unsigned int len,
-			     enum byteorder byteorder, struct expr **expr)
+static int __stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
+			       const struct datatype *dtype, unsigned int len,
+			       enum byteorder byteorder, struct expr **expr)
 {
-	__expr_set_context(&ctx->ectx, dtype, byteorder, len, 0);
-	if (expr_evaluate(ctx, expr) < 0)
-		return -1;
-
 	if ((*expr)->etype == EXPR_PAYLOAD &&
 	    (*expr)->dtype->type == TYPE_INTEGER &&
 	    ((*expr)->dtype->type != datatype_basetype(dtype)->type ||
@@ -2147,6 +2143,17 @@ static int stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
 	return 0;
 }
 
+static int stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
+			     const struct datatype *dtype, unsigned int len,
+			     enum byteorder byteorder, struct expr **expr)
+{
+	__expr_set_context(&ctx->ectx, dtype, byteorder, len, 0);
+	if (expr_evaluate(ctx, expr) < 0)
+		return -1;
+
+	return __stmt_evaluate_arg(ctx, stmt, dtype, len, byteorder, expr);
+}
+
 static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	if (stmt_evaluate_arg(ctx, stmt, &verdict_type, 0, 0, &stmt->expr) < 0)
@@ -2762,22 +2769,28 @@ static int nat_evaluate_family(struct eval_ctx *ctx, struct stmt *stmt)
 	}
 }
 
+static const struct datatype *get_addr_dtype(uint8_t family)
+{
+	switch (family) {
+	case NFPROTO_IPV4:
+		return &ipaddr_type;
+	case NFPROTO_IPV6:
+		return &ip6addr_type;
+	}
+
+	return &invalid_type;
+}
+
 static int evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
 			     struct expr **expr)
 {
 	struct proto_ctx *pctx = &ctx->pctx;
 	const struct datatype *dtype;
-	unsigned int len;
 
-	if (pctx->family == NFPROTO_IPV4) {
-		dtype = &ipaddr_type;
-		len   = 4 * BITS_PER_BYTE;
-	} else {
-		dtype = &ip6addr_type;
-		len   = 16 * BITS_PER_BYTE;
-	}
+	dtype = get_addr_dtype(pctx->family);
 
-	return stmt_evaluate_arg(ctx, stmt, dtype, len, BYTEORDER_BIG_ENDIAN,
+	return stmt_evaluate_arg(ctx, stmt, dtype, dtype->size,
+				 BYTEORDER_BIG_ENDIAN,
 				 expr);
 }
 
@@ -2819,25 +2832,15 @@ static int stmt_evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
 			      struct expr **addr)
 {
 	const struct datatype *dtype;
-	unsigned int len;
 	int err;
 
 	if (ctx->pctx.family == NFPROTO_INET) {
-		switch (family) {
-		case NFPROTO_IPV4:
-			dtype = &ipaddr_type;
-			len   = 4 * BITS_PER_BYTE;
-			break;
-		case NFPROTO_IPV6:
-			dtype = &ip6addr_type;
-			len   = 16 * BITS_PER_BYTE;
-			break;
-		default:
+		dtype = get_addr_dtype(family);
+		if (dtype->size == 0)
 			return stmt_error(ctx, stmt,
 					  "ip or ip6 must be specified with address for inet tables.");
-		}
 
-		err = stmt_evaluate_arg(ctx, stmt, dtype, len,
+		err = stmt_evaluate_arg(ctx, stmt, dtype, dtype->size,
 					BYTEORDER_BIG_ENDIAN, addr);
 	} else {
 		err = evaluate_addr(ctx, stmt, addr);
-- 
2.24.1

