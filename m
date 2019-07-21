Return-Path: <SRS0=p03Y=VS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A6AC76195
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 00:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE4C5206DD
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 00:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfGUASI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Jul 2019 20:18:08 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:48894 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725972AbfGUASI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jul 2019 20:18:08 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hozYE-0001ih-MQ; Sun, 21 Jul 2019 02:18:06 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] src: evaluate: don't rely on global chain ctx for error reporting
Date:   Sun, 21 Jul 2019 02:14:06 +0200
Message-Id: <20190721001406.23785-3-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190721001406.23785-1-fw@strlen.de>
References: <20190721001406.23785-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

table inet filter {
}
table inet filter {
      chain test {
        counter
    }
}

will now report:
crash:7:13-16: Error: No such file or directory
      chain test {
            ^^^^
... which is still bogus, but we won't fallback to the 'internal'
location anymore and at least somehwat hint that there is a problem
with 'test' chain.

The error occurs because we're looking up the chain in the first
'table inet filter' instance, not the second.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 69b853f58722..b56932ccabcc 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -182,17 +182,17 @@ static int table_not_found(struct eval_ctx *ctx)
 			 family2str(table->handle.family));
 }
 
-static int chain_not_found(struct eval_ctx *ctx)
+static int chain_not_found(struct eval_ctx *ctx, struct handle *h)
 {
 	const struct table *table;
 	struct chain *chain;
 
-	chain = chain_lookup_fuzzy(&ctx->cmd->handle, &ctx->nft->cache, &table);
+	chain = chain_lookup_fuzzy(h, &ctx->nft->cache, &table);
 	if (chain == NULL)
-		return cmd_error(ctx, &ctx->cmd->handle.chain.location,
+		return cmd_error(ctx, &h->chain.location,
 				 "%s", strerror(ENOENT));
 
-	return cmd_error(ctx, &ctx->cmd->handle.chain.location,
+	return cmd_error(ctx, &h->chain.location,
 			 "%s; did you mean chain ‘%s’ in table %s ‘%s’?",
 			 strerror(ENOENT), chain->handle.chain.name,
 			 family2str(chain->handle.family),
@@ -3264,7 +3264,7 @@ static int rule_cache_update(struct eval_ctx *ctx, enum cmd_ops op)
 
 	chain = chain_lookup(table, &rule->handle);
 	if (!chain)
-		return chain_not_found(ctx);
+		return chain_not_found(ctx, &rule->handle);
 
 	if (rule->handle.index.id) {
 		ref = rule_lookup_by_index(chain, rule->handle.index.id);
@@ -3710,7 +3710,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return table_not_found(ctx);
 
 		if (chain_lookup(table, &cmd->handle) == NULL)
-			return chain_not_found(ctx);
+			return chain_not_found(ctx, &cmd->handle);
 
 		return 0;
 	case CMD_OBJ_QUOTA:
@@ -3843,7 +3843,7 @@ static int cmd_evaluate_rename(struct eval_ctx *ctx, struct cmd *cmd)
 			return table_not_found(ctx);
 
 		if (chain_lookup(table, &ctx->cmd->handle) == NULL)
-			return chain_not_found(ctx);
+			return chain_not_found(ctx, &ctx->cmd->handle);
 
 		break;
 	default:
-- 
2.21.0

