From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 7/8] parser: evaluate commands immediately after parsing
Date: Tue,  4 Feb 2014 08:35:19 +0000
Message-ID: <1391502920-19186-8-git-send-email-kaber@trash.net>
References: <1391502920-19186-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43626 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbaBDIf3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:35:29 -0500
In-Reply-To: <1391502920-19186-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We currently do parsing and evaluation in two seperate stages. This means
that if any error occurs during parsing, we won't evaluate the syntactical
correct commands and detect possible evaluation errors in them.

In order to improve error reporting, change this to evaluate every command
as soon as it is fully parsed.

With this in place, the ruleset can be fully validated and all errors
reported in one step:

tests/error.1:6:23-23: Error: syntax error, unexpected newline
filter input tcp dport
                      ^
tests/error.1:7:24-26: Error: datatype mismatch, expected internet network service, expression has type Internet protocol
filter input tcp dport tcp
             ~~~~~~~~~ ^^^
tests/error.1:8:24-32: Error: Right hand side of relational expression (==) must be constant
filter input tcp dport tcp dport
             ~~~~~~~~~~^^^^^^^^^

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/parser.h |  1 +
 include/rule.h   |  2 +-
 src/evaluate.c   | 13 +------------
 src/main.c       |  8 +-------
 src/parser.y     | 14 ++++++++++++--
 5 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 7a1c2db..92beab2 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -26,6 +26,7 @@ struct parser_state {
 	unsigned int			scope;
 
 	struct list_head		cmds;
+	struct eval_ctx			ectx;
 };
 
 extern void parser_init(struct parser_state *state, struct list_head *msgs);
diff --git a/include/rule.h b/include/rule.h
index 47dd6ab..e06444e 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -303,7 +303,7 @@ struct eval_ctx {
 	struct proto_ctx	pctx;
 };
 
-extern int evaluate(struct eval_ctx *ctx, struct list_head *commands);
+extern int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd);
 
 extern struct error_record *rule_postprocess(struct rule *rule);
 
diff --git a/src/evaluate.c b/src/evaluate.c
index a01d2a5..8e51a63 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1384,7 +1384,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	}
 }
 
-static int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
+int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 {
 #ifdef DEBUG
 	if (debug_level & DEBUG_EVALUATION) {
@@ -1411,14 +1411,3 @@ static int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 		BUG("invalid command operation %u\n", cmd->op);
 	};
 }
-
-int evaluate(struct eval_ctx *ctx, struct list_head *commands)
-{
-	struct cmd *cmd;
-
-	list_for_each_entry(cmd, commands, list) {
-		if (cmd_evaluate(ctx, cmd) < 0)
-			return -1;
-	}
-	return 0;
-}
diff --git a/src/main.c b/src/main.c
index 2320a82..9d50577 100644
--- a/src/main.c
+++ b/src/main.c
@@ -216,18 +216,12 @@ out:
 
 int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs)
 {
-	struct eval_ctx ctx;
-	int ret = 0;
+	int ret;
 
 	ret = nft_parse(scanner, state);
 	if (ret != 0 || state->nerrs > 0)
 		return -1;
 
-	memset(&ctx, 0, sizeof(ctx));
-	ctx.msgs = msgs;
-	if (evaluate(&ctx, &state->cmds) < 0)
-		return -1;
-
 	return nft_netlink(state, msgs);
 }
 
diff --git a/src/parser.y b/src/parser.y
index 0dad036..cc0aed6 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -37,6 +37,7 @@ void parser_init(struct parser_state *state, struct list_head *msgs)
 	init_list_head(&state->top_scope.symbols);
 	state->msgs = msgs;
 	state->scopes[0] = scope_init(&state->top_scope, NULL);
+	state->ectx.msgs = msgs;
 }
 
 static void yyerror(struct location *loc, void *scanner,
@@ -492,7 +493,11 @@ input			:	/* empty */
 			{
 				if ($2 != NULL) {
 					$2->location = @2;
-					list_add_tail(&$2->list, &state->cmds);
+					if (cmd_evaluate(&state->ectx, $2) < 0) {
+						if (++state->nerrs == max_errors)
+							YYABORT;
+					} else
+						list_add_tail(&$2->list, &state->cmds);
 				}
 			}
 			;
@@ -542,7 +547,12 @@ line			:	common_block			{ $$ = NULL; }
 				 */
 				if ($1 != NULL) {
 					$1->location = @1;
-					list_add_tail(&$1->list, &state->cmds);
+
+					if (cmd_evaluate(&state->ectx, $1) < 0) {
+						if (++state->nerrs == max_errors)
+							YYABORT;
+					} else
+						list_add_tail(&$1->list, &state->cmds);
 				}
 				$$ = NULL;
 
-- 
1.8.5.3

