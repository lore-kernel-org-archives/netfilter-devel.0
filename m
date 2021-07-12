Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826E3C07E99
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Jul 2021 17:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A280611C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Jul 2021 17:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbhGLRG2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Jul 2021 13:06:28 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35896 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234920AbhGLRG2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jul 2021 13:06:28 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 39E4060693
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jul 2021 19:03:22 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables] netlink_delinearize: stmt and expr error path memleaks
Date:   Mon, 12 Jul 2021 19:03:34 +0200
Message-Id: <20210712170334.10808-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use stmt_free() and expr_free() to release these objects.

Fixes: 671851617c8d ("netlink_delinearize: Fix resource leaks")
Fixes: 3a8640672978 ("src: hash: support of symmetric hash")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 744af3b064d7..2723515df47a 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -637,7 +637,7 @@ static void netlink_parse_exthdr(struct netlink_parse_ctx *ctx,
 		sreg = netlink_parse_register(nle, NFTNL_EXPR_EXTHDR_SREG);
 		val = netlink_get_register(ctx, loc, sreg);
 		if (val == NULL) {
-			xfree(expr);
+			expr_free(expr);
 			return netlink_error(ctx, loc,
 					     "exthdr statement has no expression");
 		}
@@ -679,7 +679,7 @@ static void netlink_parse_hash(struct netlink_parse_ctx *ctx,
 		len = nftnl_expr_get_u32(nle,
 					 NFTNL_EXPR_HASH_LEN) * BITS_PER_BYTE;
 		if (hexpr->len < len) {
-			xfree(hexpr);
+			expr_free(hexpr);
 			hexpr = netlink_parse_concat_expr(ctx, loc, sreg, len);
 			if (hexpr == NULL)
 				goto out_err;
@@ -691,7 +691,7 @@ static void netlink_parse_hash(struct netlink_parse_ctx *ctx,
 	netlink_set_register(ctx, dreg, expr);
 	return;
 out_err:
-	xfree(expr);
+	expr_free(expr);
 }
 
 static void netlink_parse_fib(struct netlink_parse_ctx *ctx,
@@ -1196,7 +1196,7 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 	ctx->stmt = stmt;
 	return;
 out_err:
-	xfree(stmt);
+	stmt_free(stmt);
 }
 
 static void netlink_parse_synproxy(struct netlink_parse_ctx *ctx,
@@ -1260,7 +1260,7 @@ static void netlink_parse_tproxy(struct netlink_parse_ctx *ctx,
 	ctx->stmt = stmt;
 	return;
 err:
-	xfree(stmt);
+	stmt_free(stmt);
 }
 
 static void netlink_parse_masq(struct netlink_parse_ctx *ctx,
@@ -1307,7 +1307,7 @@ static void netlink_parse_masq(struct netlink_parse_ctx *ctx,
 	ctx->stmt = stmt;
 	return;
 out_err:
-	xfree(stmt);
+	stmt_free(stmt);
 }
 
 static void netlink_parse_redir(struct netlink_parse_ctx *ctx,
@@ -1358,7 +1358,7 @@ static void netlink_parse_redir(struct netlink_parse_ctx *ctx,
 	ctx->stmt = stmt;
 	return;
 out_err:
-	xfree(stmt);
+	stmt_free(stmt);
 }
 
 static void netlink_parse_dup(struct netlink_parse_ctx *ctx,
@@ -1411,7 +1411,7 @@ static void netlink_parse_dup(struct netlink_parse_ctx *ctx,
 	ctx->stmt = stmt;
 	return;
 out_err:
-	xfree(stmt);
+	stmt_free(stmt);
 }
 
 static void netlink_parse_fwd(struct netlink_parse_ctx *ctx,
@@ -1473,7 +1473,7 @@ static void netlink_parse_fwd(struct netlink_parse_ctx *ctx,
 	ctx->stmt = stmt;
 	return;
 out_err:
-	xfree(stmt);
+	stmt_free(stmt);
 }
 
 static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
@@ -1636,7 +1636,7 @@ out_err:
 	list_for_each_entry_safe(dstmt, next, &dynset_parse_ctx.stmt_list, list)
 		stmt_free(dstmt);
 
-	xfree(expr);
+	expr_free(expr);
 }
 
 static void netlink_parse_objref(struct netlink_parse_ctx *ctx,
-- 
2.20.1

