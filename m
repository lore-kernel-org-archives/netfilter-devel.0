From: Markus Koetter <koetter@rrzn.uni-hannover.de>
Subject: [PATCH 1/5] parser: add trace command
Date: Wed, 17 Jun 2015 22:07:33 +0200
Message-ID: <1434571657-20047-2-git-send-email-koetter@rrzn.uni-hannover.de>
References: <1434571657-20047-1-git-send-email-koetter@rrzn.uni-hannover.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.uni-hannover.de ([130.75.2.114]:38455 "EHLO
	mailout2.uni-hannover.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbbFQUO2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jun 2015 16:14:28 -0400
Received: from localhost (localhost [127.0.0.1])
	by mailout2.uni-hannover.de (Postfix) with ESMTP id 48C8C609E
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2015 22:04:01 +0200 (CEST)
Received: from mailout2.uni-hannover.de ([127.0.0.1])
	by localhost (mailout2.uni-hannover.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dHxANJhVRMPr for <netfilter-devel@vger.kernel.org>;
	Wed, 17 Jun 2015 22:04:01 +0200 (CEST)
Received: from hass1404.example.prv (p4FDA71FA.dip0.t-ipconnect.de [79.218.113.250])
	(Authenticated sender: koetter@rrzn.uni-hannover.de)
	by mailout2.uni-hannover.de (Postfix) with ESMTPSA id 16A86609A
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2015 22:04:01 +0200 (CEST)
In-Reply-To: <1434571657-20047-1-git-send-email-koetter@rrzn.uni-hannover.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 include/rule.h     | 14 ++++++++++++++
 src/evaluate.c     |  2 ++
 src/parser_bison.y | 16 ++++++++++++++--
 src/rule.c         | 31 +++++++++++++++++++++++++++++++
 src/scanner.l      |  1 +
 5 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 491411e..fbd327b 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -224,6 +224,7 @@ extern void set_print_plain(const struct set *s);
  * @CMD_EXPORT:		export the ruleset in a given format
  * @CMD_MONITOR:	event listener
  * @CMD_DESCRIBE:	describe an expression
+ * @CMD_TRACE:		print the packets trace
  */
 enum cmd_ops {
 	CMD_INVALID,
@@ -237,6 +238,7 @@ enum cmd_ops {
 	CMD_EXPORT,
 	CMD_MONITOR,
 	CMD_DESCRIBE,
+	CMD_TRACE,
 };
 
 /**
@@ -253,6 +255,7 @@ enum cmd_ops {
  * @CMD_OBJ_EXPR:	expression
  * @CMD_OBJ_MONITOR:	monitor
  * @CMD_OBJ_EXPORT:	export
+ * @CMD_OBJ_TRACE:	trace
  */
 enum cmd_obj {
 	CMD_OBJ_INVALID,
@@ -266,6 +269,7 @@ enum cmd_obj {
 	CMD_OBJ_EXPR,
 	CMD_OBJ_MONITOR,
 	CMD_OBJ_EXPORT,
+	CMD_OBJ_TRACE,
 };
 
 struct export {
@@ -296,6 +300,15 @@ struct monitor {
 struct monitor *monitor_alloc(uint32_t format, uint32_t type, const char *event);
 void monitor_free(struct monitor *m);
 
+struct trace {
+	struct location	location;
+	int family;
+};
+
+struct trace *trace_alloc(int family);
+void trace_free(struct trace *m);
+
+
 /**
  * struct cmd - command statement
  *
@@ -325,6 +338,7 @@ struct cmd {
 		struct table	*table;
 		struct monitor	*monitor;
 		struct export	*export;
+		struct trace	*trace;
 	};
 	const void		*arg;
 };
diff --git a/src/evaluate.c b/src/evaluate.c
index a3484c6..cfbafcd 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1971,6 +1971,8 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 		return 0;
 	case CMD_MONITOR:
 		return cmd_evaluate_monitor(ctx, cmd);
+	case CMD_TRACE:
+		return 0;
 	default:
 		BUG("invalid command operation %u\n", cmd->op);
 	};
diff --git a/src/parser_bison.y b/src/parser_bison.y
index fd2407c..6178502 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -190,6 +190,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token DESCRIBE			"describe"
 %token EXPORT			"export"
 %token MONITOR			"monitor"
+%token TRACE			"trace"
 
 %token ACCEPT			"accept"
 %token DROP			"drop"
@@ -402,8 +403,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
 
-%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
-%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
+%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd trace_cmd
+%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd trace_cmd
 
 %type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec
 %destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec
@@ -640,6 +641,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	EXPORT		export_cmd	{ $$ = $2; }
 			|	MONITOR		monitor_cmd	{ $$ = $2; }
 			|	DESCRIBE	describe_cmd	{ $$ = $2; }
+			|	TRACE		trace_cmd	{ $$ = $2; }
 			;
 
 add_cmd			:	TABLE		table_spec
@@ -809,6 +811,16 @@ export_cmd		:	export_format
 			}
 			;
 
+trace_cmd	: family_spec
+			{
+				struct handle h = { .family = NFPROTO_UNSPEC };
+				struct trace *t = trace_alloc($1);
+				t->location = @-1;
+				$$ = cmd_alloc(CMD_TRACE, CMD_OBJ_TRACE, &h, &@$, t);
+			}
+			;
+
+
 monitor_cmd		:	monitor_event	monitor_object	monitor_format
 			{
 				struct handle h = { .family = NFPROTO_UNSPEC };
diff --git a/src/rule.c b/src/rule.c
index 8d76fd0..97c436e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -573,6 +573,20 @@ void monitor_free(struct monitor *m)
 	xfree(m);
 }
 
+struct trace *trace_alloc(int family)
+{
+	struct trace *tr;
+
+	tr = xmalloc(sizeof(struct trace));
+	tr->family = family;
+	return tr;
+}
+
+void trace_free(struct trace *tr)
+{
+	xfree(tr);
+}
+
 void cmd_free(struct cmd *cmd)
 {
 	handle_free(&cmd->handle);
@@ -602,6 +616,9 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_EXPORT:
 			export_free(cmd->export);
 			break;
+		case CMD_OBJ_TRACE:
+			trace_free(cmd->trace);
+			break;
 		default:
 			BUG("invalid command object type %u\n", cmd->obj);
 		}
@@ -953,6 +970,10 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 	LIST_HEAD(msgs);
 	struct handle set_handle;
 	struct netlink_mon_handler monhandler;
+}
+
+}
+
 
 	/* cache only needed if monitoring:
 	 *  - new rules in default format
@@ -1000,6 +1021,14 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 	return netlink_monitor(&monhandler);
 }
 
+static int do_command_trace(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	struct handle h = { .family = NFPROTO_UNSPEC };
+	create_cache(ctx, &h, &cmd->location);
+
+	return nft_trace(0, cmd->trace->family);
+}
+
 static int do_command_describe(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	expr_describe(cmd->expr);
@@ -1029,6 +1058,8 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_command_monitor(ctx, cmd);
 	case CMD_DESCRIBE:
 		return do_command_describe(ctx, cmd);
+	case CMD_TRACE:
+		return do_command_trace(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/scanner.l b/src/scanner.l
index 73c4f8b..4f8ace4 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -263,6 +263,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "rename"		{ return RENAME; }
 "export"		{ return EXPORT; }
 "monitor"		{ return MONITOR; }
+"trace"			{ return TRACE; }
 
 "position"		{ return POSITION; }
 "comment"		{ return COMMENT; }
-- 
1.9.1

