From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] evaluate: reject: fix dependency generation from nft -f
Date: Tue,  6 Jan 2015 21:50:15 +0100
Message-ID: <1420577415-4619-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, lantw44@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56050 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbbAFUrf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Jan 2015 15:47:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When nft -f is used, ctx->cmd points to the table object, which
contains the corresponding chain, set and rule lists. The reject
statement evaluator relies on ctx->cmd->rule to add the payload
dependencies, which is doesn't point to the rule in that case.

This patch adds the rule context to the eval_ctx structure to update
the rule list of statements when generating dependencies, as the reject
statement needs.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=993
Reported-by: Ting-Wei Lan <lantw44@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |    2 ++
 src/evaluate.c |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/rule.h b/include/rule.h
index 936177b..0c52315 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -344,6 +344,7 @@ extern void cmd_free(struct cmd *cmd);
  * @msgs:	message queue
  * @cmd:	current command
  * @table:	current table
+ * @rule:	current rule
  * @set:	current set
  * @stmt:	current statement
  * @ectx:	expression context
@@ -353,6 +354,7 @@ struct eval_ctx {
 	struct list_head	*msgs;
 	struct cmd		*cmd;
 	struct table		*table;
+	struct rule		*rule;
 	struct set		*set;
 	struct stmt		*stmt;
 	struct expr_ctx		ectx;
diff --git a/src/evaluate.c b/src/evaluate.c
index 8f0acf7..2c4e811 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1203,7 +1203,7 @@ static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
 	if (payload_gen_dependency(ctx, payload, &nstmt) < 0)
 		return -1;
 
-	list_add(&nstmt->list, &ctx->cmd->rule->stmts);
+	list_add(&nstmt->list, &ctx->rule->stmts);
 	return 0;
 }
 
@@ -1722,6 +1722,7 @@ static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule)
 	proto_ctx_init(&ctx->pctx, rule->handle.family);
 	memset(&ctx->ectx, 0, sizeof(ctx->ectx));
 
+	ctx->rule = rule;
 	list_for_each_entry(stmt, &rule->stmts, list) {
 		if (tstmt != NULL)
 			return stmt_binary_error(ctx, stmt, tstmt,
-- 
1.7.10.4

