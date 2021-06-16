Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ACFCC48BE6
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 21:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D28A8613DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 21:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhFPVTl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Jun 2021 17:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbhFPVTk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Jun 2021 17:19:40 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0658CC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Jun 2021 14:17:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ltcui-0002Tp-HY; Wed, 16 Jun 2021 23:17:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     jake.owen@superloop.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/8] src: add queue expr and flags to queue_stmt_alloc
Date:   Wed, 16 Jun 2021 23:16:47 +0200
Message-Id: <20210616211652.11765-4-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210616211652.11765-1-fw@strlen.de>
References: <20210616211652.11765-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Preparation patch to avoid too much $<stmt>$ references in the parser.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/statement.h       |  3 ++-
 src/netlink_delinearize.c | 10 +++-------
 src/parser_bison.y        |  2 +-
 src/parser_json.c         | 22 +++++++++++-----------
 src/statement.c           | 10 ++++++++--
 5 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 7637a82e4e00..06221040fa0c 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -159,7 +159,8 @@ struct queue_stmt {
 	uint16_t		flags;
 };
 
-extern struct stmt *queue_stmt_alloc(const struct location *loc);
+extern struct stmt *queue_stmt_alloc(const struct location *loc,
+				     struct expr *e, uint16_t flags);
 
 struct quota_stmt {
 	uint64_t		bytes;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 5c80397db26c..7ea31e6a2639 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1467,9 +1467,8 @@ static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
 			      const struct location *loc,
 			      const struct nftnl_expr *nle)
 {
+	uint16_t num, total, flags;
 	struct expr *expr, *high;
-	struct stmt *stmt;
-	uint16_t num, total;
 
 	num   = nftnl_expr_get_u16(nle, NFTNL_EXPR_QUEUE_NUM);
 	total = nftnl_expr_get_u16(nle, NFTNL_EXPR_QUEUE_TOTAL);
@@ -1483,11 +1482,8 @@ static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
 		expr = range_expr_alloc(loc, expr, high);
 	}
 
-	stmt = queue_stmt_alloc(loc);
-	stmt->queue.queue = expr;
-	stmt->queue.flags = nftnl_expr_get_u16(nle, NFTNL_EXPR_QUEUE_FLAGS);
-
-	ctx->stmt = stmt;
+	flags = nftnl_expr_get_u16(nle, NFTNL_EXPR_QUEUE_FLAGS);
+	ctx->stmt = queue_stmt_alloc(loc, expr, flags);
 }
 
 struct dynset_parse_ctx {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 2ab47ed55166..96676aed2e38 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3744,7 +3744,7 @@ queue_stmt		:	queue_stmt_alloc	close_scope_queue
 
 queue_stmt_alloc	:	QUEUE
 			{
-				$$ = queue_stmt_alloc(&@$);
+				$$ = queue_stmt_alloc(&@$, NULL, 0);
 			}
 			;
 
diff --git a/src/parser_json.c b/src/parser_json.c
index bb0e4169b477..e03b51697cb7 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2559,14 +2559,14 @@ static int queue_flag_parse(const char *name, uint16_t *flags)
 static struct stmt *json_parse_queue_stmt(struct json_ctx *ctx,
 					  const char *key, json_t *value)
 {
-	struct stmt *stmt = queue_stmt_alloc(int_loc);
+	struct expr *qexpr = NULL;
+	uint16_t flags = 0;
 	json_t *tmp;
 
 	if (!json_unpack(value, "{s:o}", "num", &tmp)) {
-		stmt->queue.queue = json_parse_stmt_expr(ctx, tmp);
-		if (!stmt->queue.queue) {
+		qexpr = json_parse_stmt_expr(ctx, tmp);
+		if (!qexpr) {
 			json_error(ctx, "Invalid queue num.");
-			stmt_free(stmt);
 			return NULL;
 		}
 	}
@@ -2578,15 +2578,15 @@ static struct stmt *json_parse_queue_stmt(struct json_ctx *ctx,
 		if (json_is_string(tmp)) {
 			flag = json_string_value(tmp);
 
-			if (queue_flag_parse(flag, &stmt->queue.flags)) {
+			if (queue_flag_parse(flag, &flags)) {
 				json_error(ctx, "Invalid queue flag '%s'.",
 					   flag);
-				stmt_free(stmt);
+				expr_free(qexpr);
 				return NULL;
 			}
 		} else if (!json_is_array(tmp)) {
 			json_error(ctx, "Unexpected object type in queue flags.");
-			stmt_free(stmt);
+			expr_free(qexpr);
 			return NULL;
 		}
 
@@ -2594,20 +2594,20 @@ static struct stmt *json_parse_queue_stmt(struct json_ctx *ctx,
 			if (!json_is_string(val)) {
 				json_error(ctx, "Invalid object in queue flag array at index %zu.",
 					   index);
-				stmt_free(stmt);
+				expr_free(qexpr);
 				return NULL;
 			}
 			flag = json_string_value(val);
 
-			if (queue_flag_parse(flag, &stmt->queue.flags)) {
+			if (queue_flag_parse(flag, &flags)) {
 				json_error(ctx, "Invalid queue flag '%s'.",
 					   flag);
-				stmt_free(stmt);
+				expr_free(qexpr);
 				return NULL;
 			}
 		}
 	}
-	return stmt;
+	return queue_stmt_alloc(int_loc, qexpr, flags);
 }
 
 static struct stmt *json_parse_connlimit_stmt(struct json_ctx *ctx,
diff --git a/src/statement.c b/src/statement.c
index 7537c07f495c..a713952c0af7 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -522,9 +522,15 @@ static const struct stmt_ops queue_stmt_ops = {
 	.destroy	= queue_stmt_destroy,
 };
 
-struct stmt *queue_stmt_alloc(const struct location *loc)
+struct stmt *queue_stmt_alloc(const struct location *loc, struct expr *e, uint16_t flags)
 {
-	return stmt_alloc(loc, &queue_stmt_ops);
+	struct stmt *stmt;
+
+	stmt = stmt_alloc(loc, &queue_stmt_ops);
+	stmt->queue.queue = e;
+	stmt->queue.flags = flags;
+
+	return stmt;
 }
 
 static void quota_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
-- 
2.31.1

