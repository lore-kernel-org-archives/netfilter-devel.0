Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2633CC433ED
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Apr 2021 13:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A49F611AC
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Apr 2021 13:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhDONOT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 09:14:19 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57884 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbhDONOC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 09:14:02 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id E7BB463E83
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Apr 2021 15:13:11 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 10/10] evaluate: remove table_lookup_global()
Date:   Thu, 15 Apr 2021 15:13:30 +0200
Message-Id: <20210415131330.6692-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210415131330.6692-1-pablo@netfilter.org>
References: <20210415131330.6692-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need to check for ctx->table, use the existing table in the cache.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index c33e7268d655..ca13ad9e25e1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -166,20 +166,6 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 	return 0;
 }
 
-static struct table *table_lookup_global(struct eval_ctx *ctx)
-{
-	struct table *table;
-
-	if (ctx->table != NULL)
-		return ctx->table;
-
-	table = table_cache_find(&ctx->cmd->handle, &ctx->nft->cache);
-	if (table == NULL)
-		return NULL;
-
-	return table;
-}
-
 static int table_not_found(struct eval_ctx *ctx)
 {
 	struct table *table;
@@ -269,7 +255,7 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 		}
 		break;
 	case SYMBOL_SET:
-		table = table_lookup_global(ctx);
+		table = table_cache_find(&ctx->cmd->handle, &ctx->nft->cache);
 		if (table == NULL)
 			return table_not_found(ctx);
 
@@ -3673,7 +3659,7 @@ static int setelem_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	struct table *table;
 	struct set *set;
 
-	table = table_lookup_global(ctx);
+	table = table_cache_find(&ctx->cmd->handle, &ctx->nft->cache);
 	if (table == NULL)
 		return table_not_found(ctx);
 
@@ -3714,7 +3700,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	struct stmt *stmt;
 	const char *type;
 
-	table = table_lookup_global(ctx);
+	table = table_cache_find(&ctx->cmd->handle, &ctx->nft->cache);
 	if (table == NULL)
 		return table_not_found(ctx);
 
@@ -3921,7 +3907,7 @@ static int flowtable_evaluate(struct eval_ctx *ctx, struct flowtable *ft)
 {
 	struct table *table;
 
-	table = table_lookup_global(ctx);
+	table = table_cache_find(&ctx->cmd->handle, &ctx->nft->cache);
 	if (table == NULL)
 		return table_not_found(ctx);
 
@@ -4111,7 +4097,7 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 	struct table *table;
 	struct rule *rule;
 
-	table = table_lookup_global(ctx);
+	table = table_cache_find(&ctx->cmd->handle, &ctx->nft->cache);
 	if (table == NULL)
 		return table_not_found(ctx);
 
@@ -4212,7 +4198,7 @@ static int obj_evaluate(struct eval_ctx *ctx, struct obj *obj)
 {
 	struct table *table;
 
-	table = table_lookup_global(ctx);
+	table = table_cache_find(&ctx->cmd->handle, &ctx->nft->cache);
 	if (table == NULL)
 		return table_not_found(ctx);
 
-- 
2.20.1

