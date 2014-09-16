From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: fix 'describe' command when passing wrong expressions
Date: Tue, 16 Sep 2014 11:03:57 +0200
Message-ID: <1410858237-6841-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, kevin@scrye.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53106 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbaIPJDM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:03:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Before this patch:

 # nft describe tcp foo
 value expression, datatype inet_proto (Internet protocol) (basetype integer), 8 bits
 Segmentation fault

After this patch:

 # nft describe tcp foo
 <cmdline>:1:14-16: Error: syntax error, unexpected string, expecting end of file or newline or semicolon
 describe tcp foo
              ^^^

Reported-by: Kevin Fenzi <kevin@scrye.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |    4 ++++
 src/evaluate.c |    1 +
 src/parser.y   |   19 +++++++++++--------
 src/rule.c     |   11 +++++++++++
 4 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index db91406..88aefc6 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -218,6 +218,7 @@ extern void set_print_plain(const struct set *s);
  * @CMD_RENAME:		rename object
  * @CMD_EXPORT:		export the ruleset in a given format
  * @CMD_MONITOR:	event listener
+ * @CMD_DESCRIBE:	describe an expression
  */
 enum cmd_ops {
 	CMD_INVALID,
@@ -230,6 +231,7 @@ enum cmd_ops {
 	CMD_RENAME,
 	CMD_EXPORT,
 	CMD_MONITOR,
+	CMD_DESCRIBE,
 };
 
 /**
@@ -243,6 +245,7 @@ enum cmd_ops {
  * @CMD_OBJ_CHAIN:	chain
  * @CMD_OBJ_TABLE:	table
  * @CMD_OBJ_RULESET:	ruleset
+ * @CMD_OBJ_EXPR:	expression
  */
 enum cmd_obj {
 	CMD_OBJ_INVALID,
@@ -253,6 +256,7 @@ enum cmd_obj {
 	CMD_OBJ_CHAIN,
 	CMD_OBJ_TABLE,
 	CMD_OBJ_RULESET,
+	CMD_OBJ_EXPR,
 };
 
 /**
diff --git a/src/evaluate.c b/src/evaluate.c
index f66a8ea..34558fc 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1443,6 +1443,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_RENAME:
 	case CMD_EXPORT:
 	case CMD_MONITOR:
+	case CMD_DESCRIBE:
 		return 0;
 	default:
 		BUG("invalid command operation %u\n", cmd->op);
diff --git a/src/parser.y b/src/parser.y
index 6737aad..5e3c960 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -395,8 +395,8 @@ static int monitor_lookup_event(const char *event)
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
 
-%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd
-%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd
+%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
+%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
 
 %type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec
 %destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec
@@ -626,12 +626,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	RENAME		rename_cmd	{ $$ = $2; }
 			|	EXPORT		export_cmd	{ $$ = $2; }
 			|	MONITOR		monitor_cmd	{ $$ = $2; }
-			|	DESCRIBE	primary_expr
-			{
-				expr_describe($2);
-				expr_free($2);
-				$$ = NULL;
-			}
+			|	DESCRIBE	describe_cmd	{ $$ = $2; }
 			;
 
 add_cmd			:	TABLE		table_spec
@@ -974,6 +969,14 @@ monitor_flags		:	/* empty */
 			}
 			;
 
+describe_cmd		:	primary_expr
+			{
+				struct handle h = { .family = NFPROTO_UNSPEC };
+				$$ = cmd_alloc(CMD_DESCRIBE, CMD_OBJ_EXPR, &h, &@$, NULL);
+				$$->expr = $1;
+			}
+			;
+
 output_format		:	/* empty */
 			{
 				$$ = NFT_OUTPUT_DEFAULT;
diff --git a/src/rule.c b/src/rule.c
index cb2a228..80deb1b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -548,6 +548,9 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_TABLE:
 			table_free(cmd->table);
 			break;
+		case CMD_OBJ_EXPR:
+			expr_free(cmd->expr);
+			break;
 		default:
 			BUG("invalid command object type %u\n", cmd->obj);
 		}
@@ -909,6 +912,12 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 	return netlink_monitor(&monhandler);
 }
 
+static int do_command_describe(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	expr_describe(cmd->expr);
+	return 0;
+}
+
 int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->op) {
@@ -930,6 +939,8 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_command_export(ctx, cmd);
 	case CMD_MONITOR:
 		return do_command_monitor(ctx, cmd);
+	case CMD_DESCRIBE:
+		return do_command_describe(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-- 
1.7.10.4

