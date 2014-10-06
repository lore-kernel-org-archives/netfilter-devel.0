From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] src: interpret the event type from the evaluation step
Date: Mon,  6 Oct 2014 19:53:33 +0200
Message-ID: <1412618014-3895-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56070 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbaJFRwW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2014 13:52:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Postpone the event type interpretation to the evaluation step.
This patch also fixes the combination of event and object types,
which was broken. The export code needed to be adjusted too.

The new and destroy are not tokens that can be recognized by
the scanner anymore, so this also implicitly restores 'ct state'.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Patrick: After giving a closer look to Arturo's monitor code, it seems
to me that we really need an evaluation phase to support event and object
type combinations. Note this removes the 'new' and 'destroy' tokens from
the scanner, which is causing us problems. This reduces the size of the
monitor code in the parser by ~75 LOC.

 include/rule.h |   36 ++++++++++++++++++++--
 src/evaluate.c |   71 ++++++++++++++++++++++++++++++++++++++++++-
 src/parser.y   |   92 ++++++++++----------------------------------------------
 src/rule.c     |   51 +++++++++++++++++++++++++++----
 src/scanner.l  |    3 --
 5 files changed, 165 insertions(+), 88 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index a1d5890..936177b 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -252,6 +252,8 @@ enum cmd_ops {
  * @CMD_OBJ_TABLE:	table
  * @CMD_OBJ_RULESET:	ruleset
  * @CMD_OBJ_EXPR:	expression
+ * @CMD_OBJ_MONITOR:	monitor
+ * @CMD_OBJ_EXPORT:	export
  */
 enum cmd_obj {
 	CMD_OBJ_INVALID,
@@ -263,8 +265,38 @@ enum cmd_obj {
 	CMD_OBJ_TABLE,
 	CMD_OBJ_RULESET,
 	CMD_OBJ_EXPR,
+	CMD_OBJ_MONITOR,
+	CMD_OBJ_EXPORT,
 };
 
+struct export {
+	uint32_t	format;
+};
+
+struct export *export_alloc(uint32_t format);
+void export_free(struct export *e);
+
+enum {
+	CMD_MONITOR_OBJ_ANY,
+	CMD_MONITOR_OBJ_TABLES,
+	CMD_MONITOR_OBJ_CHAINS,
+	CMD_MONITOR_OBJ_RULES,
+	CMD_MONITOR_OBJ_SETS,
+	CMD_MONITOR_OBJ_ELEMS,
+	CMD_MONITOR_OBJ_MAX
+};
+
+struct monitor {
+	struct location	location;
+	uint32_t	format;
+	uint32_t	flags;
+	uint32_t	type;
+	const char	*event;
+};
+
+struct monitor *monitor_alloc(uint32_t format, uint32_t type, const char *event);
+void monitor_free(struct monitor *m);
+
 /**
  * struct cmd - command statement
  *
@@ -292,10 +324,10 @@ struct cmd {
 		struct rule	*rule;
 		struct chain	*chain;
 		struct table	*table;
+		struct monitor	*monitor;
+		struct export	*export;
 	};
 	const void		*arg;
-	uint32_t		format;
-	uint32_t		monitor_flags;
 };
 
 extern struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
diff --git a/src/evaluate.c b/src/evaluate.c
index 284ee72..0004008 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -58,6 +58,8 @@ static int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
 	__stmt_binary_error(ctx, &(s1)->location, &(s2)->location, fmt, ## args)
 #define chain_error(ctx, s1, fmt, args...) \
 	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
+#define monitor_error(ctx, s1, fmt, args...) \
+	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
 
 static int __fmtstring(3, 4) set_error(struct eval_ctx *ctx,
 				       const struct set *set,
@@ -1433,6 +1435,72 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	}
 }
 
+enum {
+	CMD_MONITOR_EVENT_ANY,
+	CMD_MONITOR_EVENT_NEW,
+	CMD_MONITOR_EVENT_DEL,
+	CMD_MONITOR_EVENT_MAX
+};
+
+static uint32_t monitor_flags[CMD_MONITOR_EVENT_MAX][CMD_MONITOR_OBJ_MAX] = {
+	[CMD_MONITOR_EVENT_ANY] = {
+		[CMD_MONITOR_OBJ_ANY]		= 0xffffffff,
+		[CMD_MONITOR_OBJ_TABLES]	= (1 << NFT_MSG_NEWTABLE) |
+						  (1 << NFT_MSG_DELTABLE),
+		[CMD_MONITOR_OBJ_CHAINS]	= (1 << NFT_MSG_NEWCHAIN) |
+						  (1 << NFT_MSG_DELCHAIN),
+		[CMD_MONITOR_OBJ_RULES]		= (1 << NFT_MSG_NEWRULE) |
+						  (1 << NFT_MSG_DELRULE),
+		[CMD_MONITOR_OBJ_SETS]		= (1 << NFT_MSG_NEWSET) |
+						  (1 << NFT_MSG_DELSET),
+		[CMD_MONITOR_OBJ_ELEMS]		= (1 << NFT_MSG_NEWSETELEM) |
+						  (1 << NFT_MSG_DELSETELEM),
+	},
+	[CMD_MONITOR_EVENT_NEW] = {
+		[CMD_MONITOR_OBJ_ANY]		= (1 << NFT_MSG_NEWTABLE) |
+						  (1 << NFT_MSG_NEWCHAIN) |
+						  (1 << NFT_MSG_NEWRULE)  |
+						  (1 << NFT_MSG_NEWSET)   |
+						  (1 << NFT_MSG_NEWSETELEM),
+		[CMD_MONITOR_OBJ_TABLES]	= (1 << NFT_MSG_NEWTABLE),
+		[CMD_MONITOR_OBJ_CHAINS]	= (1 << NFT_MSG_NEWCHAIN),
+		[CMD_MONITOR_OBJ_RULES]		= (1 << NFT_MSG_NEWRULE),
+		[CMD_MONITOR_OBJ_SETS]		= (1 << NFT_MSG_NEWSET),
+		[CMD_MONITOR_OBJ_ELEMS]		= (1 << NFT_MSG_NEWSETELEM),
+	},
+	[CMD_MONITOR_EVENT_DEL] = {
+		[CMD_MONITOR_OBJ_ANY]		= (1 << NFT_MSG_DELTABLE) |
+						  (1 << NFT_MSG_DELCHAIN) |
+						  (1 << NFT_MSG_DELRULE)  |
+						  (1 << NFT_MSG_DELSET)   |
+						  (1 << NFT_MSG_DELSETELEM),
+		[CMD_MONITOR_OBJ_TABLES]	= (1 << NFT_MSG_DELTABLE),
+		[CMD_MONITOR_OBJ_CHAINS]	= (1 << NFT_MSG_DELCHAIN),
+		[CMD_MONITOR_OBJ_RULES]		= (1 << NFT_MSG_DELRULE),
+		[CMD_MONITOR_OBJ_SETS]		= (1 << NFT_MSG_DELSET),
+		[CMD_MONITOR_OBJ_ELEMS]		= (1 << NFT_MSG_DELSETELEM),
+	},
+};
+
+static int cmd_evaluate_monitor(struct eval_ctx *ctx, struct cmd *cmd)
+{
+	uint32_t event;
+
+	if (cmd->monitor->event == NULL)
+		event = CMD_MONITOR_EVENT_ANY;
+	else if (strcmp(cmd->monitor->event, "new") == 0)
+		event = CMD_MONITOR_EVENT_NEW;
+	else if (strcmp(cmd->monitor->event, "destroy") == 0)
+		event = CMD_MONITOR_EVENT_DEL;
+	else {
+		return monitor_error(ctx, cmd->monitor, "invalid event %s",
+				     cmd->monitor->event);
+	}
+
+	cmd->monitor->flags = monitor_flags[event][cmd->monitor->type];
+	return 0;
+}
+
 int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 {
 #ifdef DEBUG
@@ -1455,9 +1523,10 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_FLUSH:
 	case CMD_RENAME:
 	case CMD_EXPORT:
-	case CMD_MONITOR:
 	case CMD_DESCRIBE:
 		return 0;
+	case CMD_MONITOR:
+		return cmd_evaluate_monitor(ctx, cmd);
 	default:
 		BUG("invalid command operation %u\n", cmd->op);
 	};
diff --git a/src/parser.y b/src/parser.y
index 4a8df7b..d3e1bc0 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -195,9 +195,6 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token GOTO			"goto"
 %token RETURN			"return"
 
-%token NEW			"new"
-%token DESTROY			"destroy"
-
 %token CONSTANT			"constant"
 %token INTERVAL			"interval"
 %token ELEMENTS			"elements"
@@ -522,7 +519,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <val>			ct_key
 
 %type <val>			export_format
-%type <val>			monitor_event	monitor_object		monitor_format
+%type <string>			monitor_event
+%destructor { xfree($$); }	monitor_event
+%type <val>			monitor_object	monitor_format
 
 %%
 
@@ -788,89 +787,30 @@ rename_cmd		:	CHAIN		chain_spec	identifier
 export_cmd		:	export_format
 			{
 				struct handle h = { .family = NFPROTO_UNSPEC };
-				$$ = cmd_alloc(CMD_EXPORT, CMD_OBJ_RULESET, &h, &@$, NULL);
-				$$->format = $1;
+				struct export *export = export_alloc($1);
+				$$ = cmd_alloc(CMD_EXPORT, CMD_OBJ_EXPORT, &h, &@$, export);
 			}
 			;
 
 monitor_cmd		:	monitor_event	monitor_object	monitor_format
 			{
 				struct handle h = { .family = NFPROTO_UNSPEC };
-				$$ = cmd_alloc(CMD_MONITOR, CMD_OBJ_RULESET, &h, &@$, NULL);
-				$$->monitor_flags = $1 & $2;
-				$$->format = $3;
+				struct monitor *m = monitor_alloc($3, $2, $1);
+				m->location = @1;
+				$$ = cmd_alloc(CMD_MONITOR, CMD_OBJ_MONITOR, &h, &@$, m);
 			}
 			;
 
-monitor_event		:	/* empty */
-			{
-				$$ = (1 << NFT_MSG_NEWRULE)	|
-				     (1 << NFT_MSG_DELRULE)	|
-				     (1 << NFT_MSG_NEWSET)	|
-				     (1 << NFT_MSG_DELSET)	|
-				     (1 << NFT_MSG_NEWSETELEM)	|
-				     (1 << NFT_MSG_DELSETELEM)	|
-				     (1 << NFT_MSG_NEWCHAIN)	|
-				     (1 << NFT_MSG_DELCHAIN)	|
-				     (1 << NFT_MSG_NEWTABLE)	|
-				     (1 << NFT_MSG_DELTABLE);
-			}
-			|	NEW
-			{
-				$$ = (1 << NFT_MSG_NEWTABLE)	|
-				     (1 << NFT_MSG_NEWCHAIN)	|
-				     (1 << NFT_MSG_NEWRULE)	|
-				     (1 << NFT_MSG_NEWSET)	|
-				     (1 << NFT_MSG_NEWSETELEM);
-			}
-			|	DESTROY
-			{
-				$$ = (1 << NFT_MSG_DELTABLE)	|
-				     (1 << NFT_MSG_DELCHAIN)	|
-				     (1 << NFT_MSG_DELRULE)	|
-				     (1 << NFT_MSG_DELSET)	|
-				     (1 << NFT_MSG_DELSETELEM);
-			}
+monitor_event		:	/* empty */	{ $$ = NULL; }
+			|       STRING		{ $$ = $1; }
 			;
 
-monitor_object		:	/* empty */
-			{
-				$$ = (1 << NFT_MSG_NEWRULE)	|
-				     (1 << NFT_MSG_DELRULE)	|
-				     (1 << NFT_MSG_NEWSET)	|
-				     (1 << NFT_MSG_DELSET)	|
-				     (1 << NFT_MSG_NEWSETELEM)	|
-				     (1 << NFT_MSG_DELSETELEM)	|
-				     (1 << NFT_MSG_NEWCHAIN)	|
-				     (1 << NFT_MSG_DELCHAIN)	|
-				     (1 << NFT_MSG_NEWTABLE)	|
-				     (1 << NFT_MSG_DELTABLE);
-			}
-			|	TABLES
-			{
-				$$ = (1 << NFT_MSG_NEWTABLE) |
-				     (1 << NFT_MSG_DELTABLE);
-			}
-			|	CHAINS
-			{
-				$$ = (1 << NFT_MSG_NEWCHAIN) |
-				     (1 << NFT_MSG_DELCHAIN);
-			}
-			|	SETS
-			{
-				$$ = (1 << NFT_MSG_NEWSET) |
-				     (1 << NFT_MSG_DELSET);
-			}
-			|	RULES
-			{
-				$$ = (1 << NFT_MSG_NEWRULE) |
-				     (1 << NFT_MSG_DELRULE);
-			}
-			|	ELEMENTS
-			{
-				$$ = (1 << NFT_MSG_NEWSETELEM) |
-				     (1 << NFT_MSG_DELSETELEM);
-			}
+monitor_object		:	/* empty */	{ $$ = CMD_MONITOR_OBJ_ANY; }
+			| 	TABLES		{ $$ = CMD_MONITOR_OBJ_TABLES; }
+			| 	CHAINS		{ $$ = CMD_MONITOR_OBJ_CHAINS; }
+			| 	SETS		{ $$ = CMD_MONITOR_OBJ_SETS; }
+			|	RULES		{ $$ = CMD_MONITOR_OBJ_RULES; }
+			|	ELEMENTS	{ $$ = CMD_MONITOR_OBJ_ELEMS; }
 			;
 
 monitor_format		:	/* empty */	{ $$ = NFT_OUTPUT_DEFAULT; }
diff --git a/src/rule.c b/src/rule.c
index 43355ee..a79a420 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -556,6 +556,39 @@ struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 	return cmd;
 }
 
+struct export *export_alloc(uint32_t format)
+{
+	struct export *export;
+
+	export = xmalloc(sizeof(struct export));
+	export->format = format;
+
+	return export;
+}
+
+void export_free(struct export *e)
+{
+	xfree(e);
+}
+
+struct monitor *monitor_alloc(uint32_t format, uint32_t type, const char *event)
+{
+	struct monitor *mon;
+
+	mon = xmalloc(sizeof(struct monitor));
+	mon->format = format;
+	mon->type = type;
+	mon->event = event;
+	mon->flags = 0;
+
+	return mon;
+}
+
+void monitor_free(struct monitor *m)
+{
+	xfree(m);
+}
+
 void cmd_free(struct cmd *cmd)
 {
 	handle_free(&cmd->handle);
@@ -579,6 +612,12 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_EXPR:
 			expr_free(cmd->expr);
 			break;
+		case CMD_OBJ_MONITOR:
+			monitor_free(cmd->monitor);
+			break;
+		case CMD_OBJ_EXPORT:
+			export_free(cmd->export);
+			break;
 		default:
 			BUG("invalid command object type %u\n", cmd->obj);
 		}
@@ -726,7 +765,7 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 	if (rs == NULL)
 		return -1;
 
-	nft_ruleset_fprintf(stdout, rs, cmd->format, 0);
+	nft_ruleset_fprintf(stdout, rs, cmd->export->format, 0);
 	fprintf(stdout, "\n");
 
 	nft_ruleset_free(rs);
@@ -929,9 +968,9 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 	 *  - new rules in default format
 	 *  - new elements
 	 */
-	if (((cmd->monitor_flags & (1 << NFT_MSG_NEWRULE)) &&
-	    (cmd->format == NFT_OUTPUT_DEFAULT)) ||
-	    (cmd->monitor_flags & (1 << NFT_MSG_NEWSETELEM)))
+	if (((cmd->monitor->flags & (1 << NFT_MSG_NEWRULE)) &&
+	    (cmd->monitor->format == NFT_OUTPUT_DEFAULT)) ||
+	    (cmd->monitor->flags & (1 << NFT_MSG_NEWSETELEM)))
 		monhandler.cache_needed = true;
 	else
 		monhandler.cache_needed = false;
@@ -963,8 +1002,8 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 		}
 	}
 
-	monhandler.monitor_flags = cmd->monitor_flags;
-	monhandler.format = cmd->format;
+	monhandler.monitor_flags = cmd->monitor->flags;
+	monhandler.format = cmd->monitor->format;
 	monhandler.ctx = ctx;
 	monhandler.loc = &cmd->location;
 
diff --git a/src/scanner.l b/src/scanner.l
index 35c9446..a00c1ca 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -261,9 +261,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "export"		{ return EXPORT; }
 "monitor"		{ return MONITOR; }
 
-"new"			{ return NEW; }
-"destroy"		{ return DESTROY; }
-
 "position"		{ return POSITION; }
 "comment"		{ return COMMENT; }
 
-- 
1.7.10.4

