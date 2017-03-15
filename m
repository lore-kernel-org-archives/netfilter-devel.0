From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nftables 4/7] src: implement add/create/delete for ct helper objects
Date: Wed, 15 Mar 2017 16:01:08 +0100
Message-ID: <20170315150111.18477-5-fw@strlen.de>
References: <20170315150111.18477-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46448 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753022AbdCOPBI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 11:01:08 -0400
In-Reply-To: <20170315150111.18477-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 no changes since v1.
 include/rule.h     |  4 ++++
 src/evaluate.c     |  4 ++++
 src/parser_bison.y | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 src/rule.c         | 22 +++++++++++++++++++
 4 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index b791cc0a497c..fb4606406a94 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -370,6 +370,7 @@ enum cmd_obj {
 	CMD_OBJ_COUNTERS,
 	CMD_OBJ_QUOTA,
 	CMD_OBJ_QUOTAS,
+	CMD_OBJ_CT_HELPER,
 	CMD_OBJ_CT_HELPERS,
 };
 
@@ -438,6 +439,9 @@ struct cmd {
 extern struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 			     const struct handle *h, const struct location *loc,
 			     void *data);
+extern struct cmd *cmd_alloc_obj_ct(enum cmd_ops op, int type,
+				    const struct handle *h,
+				    const struct location *loc, void *data);
 extern void cmd_free(struct cmd *cmd);
 
 #include <payload.h>
diff --git a/src/evaluate.c b/src/evaluate.c
index 20f67ee784dd..8fb716c06244 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2911,6 +2911,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 		return table_evaluate(ctx, cmd->table);
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_QUOTA:
+	case CMD_OBJ_CT_HELPER:
 		return 0;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
@@ -2934,6 +2935,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_TABLE:
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_QUOTA:
+	case CMD_OBJ_CT_HELPER:
 		return 0;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
@@ -3021,6 +3023,8 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_QUOTA);
 	case CMD_OBJ_COUNTER:
 		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_COUNTER);
+	case CMD_OBJ_CT_HELPER:
+		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_CT_HELPER);
 	case CMD_OBJ_COUNTERS:
 	case CMD_OBJ_QUOTAS:
 	case CMD_OBJ_CT_HELPERS:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 1bcbff598ad7..5d3d10694823 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -583,8 +583,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <expr>			and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 %destructor { expr_free($$); }	and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 
-%type <obj>			counter_obj quota_obj
-%destructor { obj_free($$); }	counter_obj quota_obj
+%type <obj>			counter_obj quota_obj ct_obj_alloc
+%destructor { obj_free($$); }	counter_obj quota_obj ct_obj_alloc
 
 %type <expr>			relational_expr
 %destructor { expr_free($$); }	relational_expr
@@ -840,6 +840,19 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
+			|	CT	STRING	obj_spec	ct_obj_alloc	'{' ct_block '}'	stmt_seperator
+			{
+				struct error_record *erec;
+				int type;
+
+				erec = ct_objtype_parse(&@$, $2, &type);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+
+				$$ = cmd_alloc_obj_ct(CMD_ADD, type, &$3, &@$, $4);
+			}
 			;
 
 replace_cmd		:	RULE		ruleid_spec	rule
@@ -906,6 +919,19 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
+			|	CT	STRING	obj_spec	ct_obj_alloc	'{' ct_block '}'	stmt_seperator
+			{
+				struct error_record *erec;
+				int type;
+
+				erec = ct_objtype_parse(&@$, $2, &type);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+
+				$$ = cmd_alloc_obj_ct(CMD_CREATE, type, &$3, &@$, $4);
+			}
 			;
 
 insert_cmd		:	RULE		rule_position	rule
@@ -946,6 +972,19 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_QUOTA, &$2, &@$, NULL);
 			}
+			|	CT	STRING	obj_spec	ct_obj_alloc
+			{
+				struct error_record *erec;
+				int type;
+
+				erec = ct_objtype_parse(&@$, $2, &type);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+
+				$$ = cmd_alloc_obj_ct(CMD_DELETE, type, &$3, &@$, $4);
+			}
 			;
 
 list_cmd		:	TABLE		table_spec
@@ -1016,6 +1055,19 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_MAP, &$2, &@$, NULL);
 			}
+			|	CT		STRING	obj_spec
+			{
+				struct error_record *erec;
+				int type;
+
+				erec = ct_objtype_parse(&@$, $2, &type);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+
+				$$ = cmd_alloc_obj_ct(CMD_LIST, type, &$3, &@$, NULL);
+			}
 			|       CT              STRING  TABLE   table_spec
 			{
 				int cmd;
@@ -2658,6 +2710,13 @@ ct_config		:	TYPE	QUOTED_STRING	PROTOCOL	ct_l4protoname	stmt_seperator
 			}
 			;
 
+ct_obj_alloc		:
+			{
+				$$ = obj_alloc(&@$);
+				$$->type = NFT_OBJECT_CT_HELPER;
+			}
+			;
+
 relational_expr		:	expr	/* implicit */	rhs_expr
 			{
 				$$ = relational_expr_alloc(&@$, OP_IMPLICIT, $1, $2);
diff --git a/src/rule.c b/src/rule.c
index 453aa2f2cc9c..997a6243eb49 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -885,6 +885,7 @@ void cmd_free(struct cmd *cmd)
 			break;
 		case CMD_OBJ_COUNTER:
 		case CMD_OBJ_QUOTA:
+		case CMD_OBJ_CT_HELPER:
 			obj_free(cmd->object);
 			break;
 		default:
@@ -1001,6 +1002,7 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 		return do_add_setelems(ctx, &cmd->handle, cmd->expr, excl);
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_QUOTA:
+	case CMD_OBJ_CT_HELPER:
 		return netlink_add_obj(ctx, &cmd->handle, cmd->object, excl);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
@@ -1071,6 +1073,9 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_QUOTA:
 		return netlink_delete_obj(ctx, &cmd->handle, &cmd->location,
 					  NFT_OBJECT_QUOTA);
+	case CMD_OBJ_CT_HELPER:
+		return netlink_delete_obj(ctx, &cmd->handle, &cmd->location,
+					  NFT_OBJECT_CT_HELPER);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
@@ -1455,6 +1460,7 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_QUOTAS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_QUOTA);
+	case CMD_OBJ_CT_HELPER:
 	case CMD_OBJ_CT_HELPERS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_CT_HELPER);
 	default:
@@ -1603,6 +1609,22 @@ static int do_command_describe(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+struct cmd *cmd_alloc_obj_ct(enum cmd_ops op, int type, const struct handle *h,
+			     const struct location *loc, void *data)
+{
+	enum cmd_obj cmd_obj;
+
+	switch (type) {
+	case NFT_OBJECT_CT_HELPER:
+		cmd_obj = CMD_OBJ_CT_HELPER;
+		break;
+	default:
+		BUG("missing type mapping");
+	}
+
+	return cmd_alloc(op, cmd_obj, h, loc, data);
+}
+
 int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->op) {
-- 
2.10.2

