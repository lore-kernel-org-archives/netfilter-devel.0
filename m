From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/3 v4 nft] Simplify parser rule_spec tree
Date: Tue, 16 Aug 2016 12:21:25 +0200
Message-ID: <20160816102126.28662-2-carlosfg@riseup.net>
References: <20160816102126.28662-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:56244 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbcHPKVl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Aug 2016 06:21:41 -0400
In-Reply-To: <20160816102126.28662-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch separates the rule identification from the rule localization, so
the logic moves from the evaluator to the parser. This allows to revert the
patch "evaluate: improve rule managment checks"
(4176c7d30c2ff1b3f52468fc9c08b8df83f979a8) and saves a lot of code.

An specific error message is shown when user commits a syntax error, as
before this patch:

	$ nft add rule t c handle 3 ...
	<cmdline>:1:14-19: Error: Expected `position' or nothing
	add rule t c handle 3 ...
	             ^^^^^^

	$ nft delete rule t c position 3 ...
	<cmdline>:1:17-24: Error: syntax error, unexpected position, expecting handle
	delete rule t c position 3 ...
	                ^^^^^^^^

Also new boolean field is added to the structure 'parser_state' in order to
avoid print the error twice.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 include/parser.h   |  2 ++
 src/evaluate.c     | 68 +-----------------------------------------------------
 src/parser_bison.y | 61 ++++++++++++++++++++++++++++--------------------
 3 files changed, 39 insertions(+), 92 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 92beab2..41e5340 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -27,6 +27,8 @@ struct parser_state {
 
 	struct list_head		cmds;
 	struct eval_ctx			ectx;
+
+	bool				err_recovering;
 };
 
 extern void parser_init(struct parser_state *state, struct list_head *msgs);
diff --git a/src/evaluate.c b/src/evaluate.c
index 87f5a6d..2f94ac6 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -44,12 +44,6 @@ static const char *byteorder_names[] = {
 	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
 #define cmd_error(ctx, fmt, args...) \
 	__stmt_binary_error(ctx, &(ctx->cmd)->location, NULL, fmt, ## args)
-#define handle_error(ctx, fmt, args...) \
-	__stmt_binary_error(ctx, &ctx->cmd->handle.handle.location, NULL, fmt, ## args)
-#define position_error(ctx, fmt, args...) \
-	__stmt_binary_error(ctx, &ctx->cmd->handle.position.location, NULL, fmt, ## args)
-#define handle_position_error(ctx, fmt, args...) \
-	__stmt_binary_error(ctx, &ctx->cmd->handle.handle.location, &ctx->cmd->handle.position.location, fmt, ## args)
 
 static int __fmtstring(3, 4) set_error(struct eval_ctx *ctx,
 				       const struct set *set,
@@ -2481,68 +2475,11 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	return 0;
 }
 
-static int rule_evaluate_cmd(struct eval_ctx *ctx)
-{
-	struct handle *handle = &ctx->cmd->handle;
-
-	/* allowed:
-	 * - insert [position] (no handle)
-	 * - add [position] (no handle)
-	 * - replace <handle> (no position)
-	 * - delete <handle> (no position)
-	 */
-
-	switch (ctx->cmd->op) {
-	case CMD_INSERT:
-		if (handle->handle.id && handle->position.id)
-			return handle_position_error(ctx, "use only `position'"
-						     " instead");
-
-		if (handle->handle.id)
-			return handle_error(ctx, "use `position' instead");
-		break;
-	case CMD_ADD:
-		if (handle->handle.id && handle->position.id)
-			return handle_position_error(ctx, "use only `position'"
-						     " instead");
-
-		if (handle->handle.id)
-			return handle_error(ctx, "use `position' instead");
-
-		break;
-	case CMD_REPLACE:
-		if (handle->handle.id && handle->position.id)
-			return handle_position_error(ctx, "use only `handle' "
-						     "instead");
-		if (handle->position.id)
-			return position_error(ctx, "use `handle' instead");
-		if (!handle->handle.id)
-			return cmd_error(ctx, "missing `handle'");
-		break;
-	case CMD_DELETE:
-		if (handle->handle.id && handle->position.id)
-			return handle_position_error(ctx, "use only `handle' "
-						     "instead");
-		if (handle->position.id)
-			return position_error(ctx, "use `handle' instead");
-		if (!handle->handle.id)
-			return cmd_error(ctx, "missing `handle'");
-		break;
-	default:
-		BUG("unkown command type %u\n", ctx->cmd->op);
-	}
-
-	return 0;
-}
-
 static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule)
 {
 	struct stmt *stmt, *tstmt = NULL;
 	struct error_record *erec;
 
-	if (rule_evaluate_cmd(ctx) < 0)
-		return -1;
-
 	proto_ctx_init(&ctx->pctx, rule->handle.family);
 	memset(&ctx->ectx, 0, sizeof(ctx->ectx));
 
@@ -2723,11 +2660,8 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 			return ret;
 
 		return setelem_evaluate(ctx, &cmd->expr);
-	case CMD_OBJ_RULE:
-		if (rule_evaluate_cmd(ctx) < 0)
-			return -1;
-		/* fall through */
 	case CMD_OBJ_SET:
+	case CMD_OBJ_RULE:
 	case CMD_OBJ_CHAIN:
 	case CMD_OBJ_TABLE:
 		return 0;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index e16b8a3..93c283f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -42,12 +42,14 @@ void parser_init(struct parser_state *state, struct list_head *msgs)
 	state->msgs = msgs;
 	state->scopes[0] = scope_init(&state->top_scope, NULL);
 	state->ectx.msgs = msgs;
+	state->err_recovering = false;
 }
 
 static void yyerror(struct location *loc, void *scanner,
 		    struct parser_state *state, const char *s)
 {
-	erec_queue(error(loc, "%s", s), state->msgs);
+	if (!state->err_recovering)
+		erec_queue(error(loc, "%s", s), state->msgs);
 }
 
 static struct scope *current_scope(const struct parser_state *state)
@@ -425,15 +427,12 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <cmd>			base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
 %destructor { cmd_free($$); }	base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
 
-%type <handle>			table_spec chain_spec chain_identifier ruleid_spec ruleset_spec
-%destructor { handle_free(&$$); } table_spec chain_spec chain_identifier ruleid_spec ruleset_spec
+%type <handle>			table_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
+%destructor { handle_free(&$$); } table_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
 %type <handle>			set_spec set_identifier
 %destructor { handle_free(&$$); } set_spec set_identifier
 %type <val>			family_spec family_spec_explicit chain_policy prio_spec
 
-%type <handle_spec>		handle_spec
-%type <position_spec>		position_spec
-
 %type <string>			dev_spec
 %destructor { xfree($$); }	dev_spec
 
@@ -720,11 +719,11 @@ add_cmd			:	TABLE		table_spec
 				close_scope(state);
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_CHAIN, &$2, &@$, $5);
 			}
-			|	RULE		ruleid_spec	rule
+			|	RULE		rule_position	rule
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &$2, &@$, $3);
 			}
-			|	/* empty */	ruleid_spec	rule
+			|	/* empty */	rule_position	rule
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &$1, &@$, $2);
 			}
@@ -779,7 +778,7 @@ create_cmd		:	TABLE		table_spec
 			}
 			;
 
-insert_cmd		:	RULE		ruleid_spec	rule
+insert_cmd		:	RULE		rule_position	rule
 			{
 				$$ = cmd_alloc(CMD_INSERT, CMD_OBJ_RULE, &$2, &@$, $3);
 			}
@@ -1252,38 +1251,50 @@ set_identifier		:	identifier
 			}
 			;
 
-handle_spec		:	/* empty */
+handle_spec		:	HANDLE		NUM
 			{
-				memset(&$$, 0, sizeof($$));
+				$$.handle.location	= @$;
+				$$.handle.id		= $2;
 			}
-			|	HANDLE		NUM
+			;
+
+position_spec		:	POSITION	NUM
 			{
-				memset(&$$, 0, sizeof($$));
-				$$.location	= @$;
-				$$.id		= $2;
+				$$.position.location	= @$;
+				$$.position.id		= $2;
 			}
 			;
 
-position_spec		:	/* empty */
+rule_position		:	chain_spec
 			{
-				memset(&$$, 0, sizeof($$));
+				$$ = $1;
 			}
-			|	POSITION	NUM
+			|	chain_spec position_spec
 			{
-				memset(&$$, 0, sizeof($$));
-				$$.location	= @$;
-				$$.id		= $2;
+				$$ = $1;
+				handle_merge(&$$, &$2);
+			}
+			|	chain_spec HANDLE err_recovering error
+			{
+				erec_queue(error(&@2, "Expected `position' or nothing"),
+					   state->msgs);
+				state->err_recovering = false;
+				$$ = $1;
 			}
 			;
 
-ruleid_spec		:	chain_spec	handle_spec	position_spec
+ruleid_spec		:	chain_spec handle_spec
 			{
-				$$		= $1;
-				$$.handle	= $2;
-				$$.position	= $3;
+				$$ = $1;
+				handle_merge(&$$, &$2);
 			}
 			;
 
+err_recovering	:	/* empty */
+			{
+				state->err_recovering = true;
+			};
+
 comment_spec		:	COMMENT		string
 			{
 				if (strlen($2) > UDATA_COMMENT_MAXLEN) {
-- 
2.8.3

