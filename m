From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [RFC PATCH nft V2] src: Add import command for json
Date: Sun, 10 Sep 2017 18:01:02 +0530
Message-ID: <1505046662-21629-1-git-send-email-mayhs11saini@gmail.com>
Cc: Shyam Saini <mayhs11saini@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36001 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751469AbdIJMbT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Sep 2017 08:31:19 -0400
Received: by mail-pf0-f194.google.com with SMTP id f84so3739332pfj.3
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Sep 2017 05:31:19 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new operation allows to import ruleset in json to make
incremental changes using the parse functions of libnftnl.

A basic way to test this new functionality is:

 % cat file.json | nft import json

where the file.json is a ruleset exported in json format.

Highly based on work from  Alvaro Neira <alvaroneay@gmail.com>
and Arturo Borrero <arturo@netfilter.org>.

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
V2:
  Build Patch over updated repository.
---
 include/netlink.h  |   9 ++
 include/rule.h     |  14 +--
 src/evaluate.c     |   2 +
 src/netlink.c      | 280 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/parser_bison.y |  38 +++++---
 src/rule.c         |  44 +++++++--
 src/scanner.l      |   1 +
 7 files changed, 361 insertions(+), 27 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index b395cf1cd9ad..30cf3cd997ef 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -225,4 +225,13 @@ bool netlink_batch_supported(struct mnl_socket *nf_sock, uint32_t *seqnum);
 
 int netlink_echo_callback(const struct nlmsghdr *nlh, void *data);
 
+struct ruleset_parse {
+	struct netlink_ctx      *nl_ctx;
+	struct cmd              *cmd;
+};
+
+struct nftnl_parse_ctx;
+
+int netlink_markup_parse_cb(const struct nftnl_parse_ctx *ctx);
+
 #endif /* NFTABLES_NETLINK_H */
diff --git a/include/rule.h b/include/rule.h
index 631a1bcdf84e..56dee9766b2b 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -327,6 +327,7 @@ uint32_t obj_type_to_cmd(uint32_t type);
  * @CMD_RESET:		reset container
  * @CMD_FLUSH:		flush container
  * @CMD_RENAME:		rename object
+ * @CMD_IMPORT:		import a ruleset in a given format
  * @CMD_EXPORT:		export the ruleset in a given format
  * @CMD_MONITOR:	event listener
  * @CMD_DESCRIBE:	describe an expression
@@ -342,6 +343,7 @@ enum cmd_ops {
 	CMD_RESET,
 	CMD_FLUSH,
 	CMD_RENAME,
+	CMD_IMPORT,
 	CMD_EXPORT,
 	CMD_MONITOR,
 	CMD_DESCRIBE,
@@ -361,7 +363,7 @@ enum cmd_ops {
  * @CMD_OBJ_RULESET:	ruleset
  * @CMD_OBJ_EXPR:	expression
  * @CMD_OBJ_MONITOR:	monitor
- * @CMD_OBJ_EXPORT:	export
+ * @CMD_OBJ_MARKUP:	import/export
  * @CMD_OBJ_COUNTER:	counter
  * @CMD_OBJ_COUNTERS:	multiple counters
  * @CMD_OBJ_QUOTA:	quota
@@ -381,7 +383,7 @@ enum cmd_obj {
 	CMD_OBJ_RULESET,
 	CMD_OBJ_EXPR,
 	CMD_OBJ_MONITOR,
-	CMD_OBJ_EXPORT,
+	CMD_OBJ_MARKUP,
 	CMD_OBJ_FLOWTABLE,
 	CMD_OBJ_FLOWTABLES,
 	CMD_OBJ_MAP,
@@ -396,12 +398,12 @@ enum cmd_obj {
 	CMD_OBJ_LIMITS,
 };
 
-struct export {
+struct markup {
 	uint32_t	format;
 };
 
-struct export *export_alloc(uint32_t format);
-void export_free(struct export *e);
+struct markup *markup_alloc(uint32_t format);
+void markup_free(struct markup *m);
 
 enum {
 	CMD_MONITOR_OBJ_ANY,
@@ -454,7 +456,7 @@ struct cmd {
 		struct chain	*chain;
 		struct table	*table;
 		struct monitor	*monitor;
-		struct export	*export;
+		struct markup	*markup;
 		struct obj	*object;
 	};
 	const void		*arg;
diff --git a/src/evaluate.c b/src/evaluate.c
index e767542a868e..2275a3026255 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3407,6 +3407,8 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 		return 0;
 	case CMD_MONITOR:
 		return cmd_evaluate_monitor(ctx, cmd);
+	case CMD_IMPORT:
+		return 0;
 	default:
 		BUG("invalid command operation %u\n", cmd->op);
 	};
diff --git a/src/netlink.c b/src/netlink.c
index 291bbdeeaa68..7a2519477ae8 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -24,6 +24,7 @@
 #include <libnftnl/object.h>
 #include <libnftnl/set.h>
 #include <libnftnl/udata.h>
+#include <libnftnl/ruleset.h>
 #include <libnftnl/common.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
@@ -3030,6 +3031,285 @@ int netlink_monitor(struct netlink_mon_handler *monhandler,
 	return mnl_nft_event_listener(&ctx, netlink_events_cb, monhandler);
 }
 
+static int netlink_markup_setelems(const struct nftnl_parse_ctx *ctx)
+{
+	const struct ruleset_parse *rp;
+	struct nftnl_set *set;
+	uint32_t cmd;
+	int ret = -1;
+
+	set = nftnl_ruleset_ctx_get(ctx, NFTNL_RULESET_CTX_SET);
+	rp = nftnl_ruleset_ctx_get(ctx, NFTNL_RULESET_CTX_DATA);
+
+	cmd = nftnl_ruleset_ctx_get_u32(ctx, NFTNL_RULESET_CTX_CMD);
+	switch (cmd) {
+	case NFTNL_CMD_ADD:
+		ret = mnl_nft_setelem_batch_add(set, rp->nl_ctx->batch, 0, rp->nl_ctx->seqnum);
+		break;
+	case NFTNL_CMD_DELETE:
+		ret = mnl_nft_setelem_batch_del(set, rp->nl_ctx->batch, 0, rp->nl_ctx->seqnum);
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
+static int netlink_markup_set(const struct nftnl_parse_ctx *ctx)
+{
+	const struct ruleset_parse *rp;
+	struct nftnl_set *set;
+	uint32_t cmd;
+	int ret = -1;
+
+	set = nftnl_ruleset_ctx_get(ctx, NFTNL_RULESET_CTX_SET);
+	rp = nftnl_ruleset_ctx_get(ctx, NFTNL_RULESET_CTX_DATA);
+
+	cmd = nftnl_ruleset_ctx_get_u32(ctx, NFTNL_RULESET_CTX_CMD);
+	switch (cmd) {
+	case NFTNL_CMD_ADD:
+		ret = mnl_nft_set_batch_add(set, rp->nl_ctx->batch, NLM_F_EXCL,
+						rp->nl_ctx->seqnum);
+		break;
+	case NFTNL_CMD_DELETE:
+		ret = mnl_nft_set_batch_del(set, rp->nl_ctx->batch, 0, rp->nl_ctx->seqnum);
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		break;
+	}
+
+	if (ret < 0)
+		return ret;
+
+	return netlink_markup_setelems(ctx);
+}
+
+static int netlink_markup_build_rule(const struct nftnl_parse_ctx *ctx,
+							uint32_t cmd, struct nftnl_rule *rule)
+{
+	const struct ruleset_parse *rp;
+	uint32_t nl_flags;
+	int ret = -1;
+
+	rp = nftnl_ruleset_ctx_get(ctx, NFTNL_RULESET_CTX_DATA);
+
+	switch (cmd) {
+	case NFTNL_CMD_ADD:
+		nl_flags = NLM_F_APPEND | NLM_F_CREATE;
+		nftnl_rule_unset(rule, NFTNL_RULE_HANDLE);
+		ret = mnl_nft_rule_batch_add(rule, rp->nl_ctx->batch, nl_flags,
+						rp->nl_ctx->seqnum);
+		break;
+	case NFTNL_CMD_DELETE:
+		ret = mnl_nft_rule_batch_del(rule, rp->nl_ctx->batch, 0, rp->nl_ctx->seqnum);
+		break;
+	case NFTNL_CMD_REPLACE:
+		nl_flags = NLM_F_REPLACE;
+		ret = mnl_nft_rule_batch_add(rule, rp->nl_ctx->batch, nl_flags,
+						rp->nl_ctx->seqnum);
+		break;
+	case NFTNL_CMD_INSERT:
+		nl_flags = NLM_F_CREATE;
+		nftnl_rule_unset(rule, NFTNL_RULE_HANDLE);
+		ret = mnl_nft_rule_batch_add(rule, rp->nl_ctx->batch, nl_flags,
+						rp->nl_ctx->seqnum);
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+
+}
+
+static int netlink_markup_rule(const struct nftnl_parse_ctx *ctx)
+{
+	struct nftnl_rule *rule;
+	uint32_t cmd;
+
+	cmd = nftnl_ruleset_ctx_get_u32(ctx, NFTNL_RULESET_CTX_CMD);
+	rule = nftnl_ruleset_ctx_get(ctx, NFTNL_RULESET_CTX_RULE);
+
+	return netlink_markup_build_rule(ctx, cmd, rule);
+}
+
+static int netlink_markup_build_flush(const struct nftnl_parse_ctx *ctx)
+{
+	struct nftnl_rule *rule;
+	struct nftnl_table *table;
+	struct nftnl_chain *chain;
+	uint32_t type;
+	int ret = -1;
+
+	rule = nftnl_rule_alloc();
+	if (rule == NULL)
+		return -1;
+
+	type = nftnl_ruleset_ctx_get_u32(ctx, NFTNL_RULESET_CTX_TYPE);
+	switch (type) {
+	case NFTNL_RULESET_TABLE:
+		table = nftnl_ruleset_ctx_get(ctx, NFTNL_RULESET_CTX_TABLE);
+
+		nftnl_rule_set(rule, NFTNL_RULE_TABLE,
+					nftnl_table_get(table,
+							NFTNL_TABLE_NAME));
+		nftnl_rule_set(rule, NFTNL_RULE_FAMILY,
+					nftnl_table_get(table,
+							NFTNL_TABLE_FAMILY));
+		break;
+	case NFTNL_RULESET_CHAIN:
+		chain = nftnl_ruleset_ctx_get(ctx, NFTNL_RULESET_CTX_CHAIN);
+
+		nftnl_rule_set(rule, NFTNL_RULE_TABLE,
+					nftnl_chain_get(chain,
+							NFTNL_CHAIN_TABLE));
+		nftnl_rule_set(rule, NFTNL_RULE_CHAIN,
+					nftnl_chain_get(chain,
+							NFTNL_CHAIN_NAME));
+		nftnl_rule_set(rule, NFTNL_RULE_FAMILY,
+					nftnl_chain_get(chain,
+							NFTNL_TABLE_FAMILY));
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		goto err;
+	}
+
+	ret = netlink_markup_build_rule(ctx, NFTNL_CMD_DELETE, rule);
+err:
+	nftnl_rule_free(rule);
+	return ret;
+}
+
+static int netlink_markup_chain(const struct nftnl_parse_ctx *ctx)
+{
+	const struct ruleset_parse *rp;
+	struct nftnl_chain *chain;
+	uint32_t cmd;
+	int ret = -1;
+
+	chain = nftnl_ruleset_ctx_get(ctx, NFTNL_RULESET_CTX_CHAIN);
+	rp = nftnl_ruleset_ctx_get(ctx, NFTNL_RULESET_CTX_DATA);
+
+	nftnl_chain_unset(chain, NFTNL_CHAIN_HANDLE);
+
+	cmd = nftnl_ruleset_ctx_get_u32(ctx, NFTNL_RULESET_CTX_CMD);
+	switch (cmd) {
+	case NFTNL_CMD_ADD:
+		ret = mnl_nft_chain_batch_add(chain, rp->nl_ctx->batch, 0, rp->nl_ctx->seqnum);
+		break;
+	case NFTNL_CMD_DELETE:
+		ret = mnl_nft_chain_batch_del(chain, rp->nl_ctx->batch, 0, rp->nl_ctx->seqnum);
+		break;
+	case NFTNL_CMD_FLUSH:
+		ret = netlink_markup_build_flush(ctx);
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
+
+static int netlink_markup_build_table(const struct nftnl_parse_ctx *ctx,
+		uint32_t cmd, struct nftnl_table *table)
+{
+	struct ruleset_parse *rp;
+	int ret = -1;
+
+	rp = nftnl_ruleset_ctx_get(ctx, NFTNL_RULESET_CTX_DATA);
+
+	switch (cmd) {
+	case NFTNL_CMD_ADD:
+		ret = mnl_nft_table_batch_add(table, rp->nl_ctx->batch, 0, rp->nl_ctx->seqnum);
+		break;
+	case NFTNL_CMD_DELETE:
+		ret = mnl_nft_table_batch_del(table, rp->nl_ctx->batch, 0, rp->nl_ctx->seqnum);
+		break;
+	case NFTNL_CMD_FLUSH:
+		ret = netlink_markup_build_flush(ctx);
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
+static int netlink_markup_table(const struct nftnl_parse_ctx *ctx)
+{
+	struct nftnl_table *table;
+	uint32_t cmd;
+
+	cmd = nftnl_ruleset_ctx_get_u32(ctx, NFTNL_RULESET_CTX_CMD);
+	table = nftnl_ruleset_ctx_get(ctx, NFTNL_RULESET_CTX_TABLE);
+
+	return netlink_markup_build_table(ctx, cmd, table);
+}
+
+static int netlink_markup_flush(const struct nftnl_parse_ctx *ctx)
+{
+	struct nftnl_table *table;
+	int ret;
+
+	table = nftnl_table_alloc();
+	if (table == NULL)
+		return -1;
+
+	ret = netlink_markup_build_table(ctx, NFTNL_CMD_DELETE, table);
+	nftnl_table_free(table);
+
+	return ret;
+}
+
+int netlink_markup_parse_cb(const struct nftnl_parse_ctx *ctx)
+{
+	struct ruleset_parse *rp;
+	uint32_t type;
+	int ret = -1;
+
+	rp = nftnl_ruleset_ctx_get(ctx, NFTNL_RULESET_CTX_DATA);
+
+	type = nftnl_ruleset_ctx_get_u32(ctx, NFTNL_RULESET_CTX_TYPE);
+	switch (type) {
+	case NFTNL_RULESET_TABLE:
+		ret = netlink_markup_table(ctx);
+		break;
+	case NFTNL_RULESET_CHAIN:
+		ret = netlink_markup_chain(ctx);
+		break;
+	case NFTNL_RULESET_RULE:
+		ret = netlink_markup_rule(ctx);
+		break;
+	case NFTNL_RULESET_SET:
+		ret = netlink_markup_set(ctx);
+		break;
+	case NFTNL_RULESET_SET_ELEMS:
+		ret = netlink_markup_setelems(ctx);
+		break;
+	case NFTNL_RULESET_RULESET:
+		ret = netlink_markup_flush(ctx);
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		break;
+	}
+
+	nftnl_ruleset_ctx_free(ctx);
+	if (ret < 0)
+		netlink_io_error(rp->nl_ctx, &rp->cmd->location,
+				"Could not import: %s", strerror(errno));
+
+	return 0;
+}
+
 bool netlink_batch_supported(struct mnl_socket *nf_sock, uint32_t *seqnum)
 {
 	return mnl_batch_supported(nf_sock, seqnum);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 31a7e8be2bcd..e17653e4e28f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -213,6 +213,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token FLUSH			"flush"
 %token RENAME			"rename"
 %token DESCRIBE			"describe"
+%token IMPORT			"import"
 %token EXPORT			"export"
 %token MONITOR			"monitor"
 
@@ -475,8 +476,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
 
-%type <cmd>			base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
-%destructor { cmd_free($$); }	base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
+%type <cmd>			base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd import_cmd
+%destructor { cmd_free($$); }	base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd import_cmd
 
 %type <handle>			table_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
 %destructor { handle_free(&$$); } table_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
@@ -655,7 +656,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	fib_expr
 %type <val>			fib_tuple	fib_result	fib_flag
 
-%type <val>			export_format
+%type <val>			markup_format
 %type <string>			monitor_event
 %destructor { xfree($$); }	monitor_event
 %type <val>			monitor_object	monitor_format
@@ -788,6 +789,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	RESET		reset_cmd	{ $$ = $2; }
 			|	FLUSH		flush_cmd	{ $$ = $2; }
 			|	RENAME		rename_cmd	{ $$ = $2; }
+			|       IMPORT          import_cmd      { $$ = $2; }
 			|	EXPORT		export_cmd	{ $$ = $2; }
 			|	MONITOR		monitor_cmd	{ $$ = $2; }
 			|	DESCRIBE	describe_cmd	{ $$ = $2; }
@@ -1196,17 +1198,31 @@ rename_cmd		:	CHAIN		chain_spec	identifier
 			}
 			;
 
-export_cmd		:	RULESET		export_format
+import_cmd			:       RULESET         markup_format
 			{
 				struct handle h = { .family = NFPROTO_UNSPEC };
-				struct export *export = export_alloc($2);
-				$$ = cmd_alloc(CMD_EXPORT, CMD_OBJ_EXPORT, &h, &@$, export);
+				struct markup *markup = markup_alloc($2);
+				$$ = cmd_alloc(CMD_IMPORT, CMD_OBJ_MARKUP, &h, &@$, markup);
 			}
-			|	export_format
+			|	markup_format
 			{
 				struct handle h = { .family = NFPROTO_UNSPEC };
-				struct export *export = export_alloc($1);
-				$$ = cmd_alloc(CMD_EXPORT, CMD_OBJ_EXPORT, &h, &@$, export);
+				struct markup *markup = markup_alloc($1);
+				$$ = cmd_alloc(CMD_IMPORT, CMD_OBJ_MARKUP, &h, &@$, markup);
+			}
+			;
+
+export_cmd		:	RULESET		markup_format
+			{
+				struct handle h = { .family = NFPROTO_UNSPEC };
+				struct markup *markup = markup_alloc($2);
+				$$ = cmd_alloc(CMD_EXPORT, CMD_OBJ_MARKUP, &h, &@$, markup);
+			}
+			|	markup_format
+			{
+				struct handle h = { .family = NFPROTO_UNSPEC };
+				struct markup *markup = markup_alloc($1);
+				$$ = cmd_alloc(CMD_EXPORT, CMD_OBJ_MARKUP, &h, &@$, markup);
 			}
 			;
 
@@ -1234,10 +1250,10 @@ monitor_object		:	/* empty */	{ $$ = CMD_MONITOR_OBJ_ANY; }
 			;
 
 monitor_format		:	/* empty */	{ $$ = NFTNL_OUTPUT_DEFAULT; }
-			|	export_format
+			|	markup_format
 			;
 
-export_format		: 	XML 		{ $$ = NFTNL_OUTPUT_XML; }
+markup_format		: 	XML 		{ $$ = NFTNL_OUTPUT_XML; }
 			|	JSON		{ $$ = NFTNL_OUTPUT_JSON; }
 			;
 
diff --git a/src/rule.c b/src/rule.c
index 1bb7b4756171..932a85dfeacf 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -896,19 +896,19 @@ void nft_cmd_expand(struct cmd *cmd)
 	}
 }
 
-struct export *export_alloc(uint32_t format)
+struct markup *markup_alloc(uint32_t format)
 {
-	struct export *export;
+	struct markup *markup;
 
-	export = xmalloc(sizeof(struct export));
-	export->format = format;
+	markup = xmalloc(sizeof(struct markup));
+	markup->format = format;
 
-	return export;
+	return markup;
 }
 
-void export_free(struct export *e)
+void markup_free(struct markup *m)
 {
-	xfree(e);
+	xfree(m);
 }
 
 struct monitor *monitor_alloc(uint32_t format, uint32_t type, const char *event)
@@ -956,8 +956,8 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_MONITOR:
 			monitor_free(cmd->monitor);
 			break;
-		case CMD_OBJ_EXPORT:
-			export_free(cmd->export);
+		case CMD_OBJ_MARKUP:
+			markup_free(cmd->markup);
 			break;
 		case CMD_OBJ_COUNTER:
 		case CMD_OBJ_QUOTA:
@@ -1156,13 +1156,35 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 			return -1;
 	} while (rs == NULL);
 
-	nftnl_ruleset_fprintf(stdout, rs, cmd->export->format, 0);
+	nftnl_ruleset_fprintf(stdout, rs, cmd->markup->format, NFTNL_OF_EVENT_NEW);
 	fprintf(stdout, "\n");
 
 	nftnl_ruleset_free(rs);
 	return 0;
 }
 
+static int do_command_import(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	int ret;
+	struct nftnl_parse_err *err;
+	struct ruleset_parse rp = {
+		.nl_ctx = ctx,
+		.cmd    = cmd
+	};
+
+	err = nftnl_parse_err_alloc();
+	if (err == NULL)
+		return -1;
+
+	ret = nftnl_ruleset_parse_file_cb(cmd->markup->format, stdin, err, &rp,
+					  netlink_markup_parse_cb);
+	if (ret < 0)
+		nftnl_parse_perror("unable to import: parsing failed", err);
+
+	nftnl_parse_err_free(err);
+	return ret;
+}
+
 static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
 			 struct table *table)
 {
@@ -1777,6 +1799,8 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_command_flush(ctx, cmd);
 	case CMD_RENAME:
 		return do_command_rename(ctx, cmd);
+	case CMD_IMPORT:
+		return do_command_import(ctx, cmd);
 	case CMD_EXPORT:
 		return do_command_export(ctx, cmd);
 	case CMD_MONITOR:
diff --git a/src/scanner.l b/src/scanner.l
index 0cfb6c50e418..f6d7e1e39d5b 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -273,6 +273,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "reset"			{ return RESET; }
 "flush"			{ return FLUSH; }
 "rename"		{ return RENAME; }
+"import"                { return IMPORT; }
 "export"		{ return EXPORT; }
 "monitor"		{ return MONITOR; }
 
-- 
1.9.1

