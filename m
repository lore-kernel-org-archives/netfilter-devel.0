From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [RFC PATCH nft V5 1/2] src: Add import command for low level json
Date: Sun, 15 Oct 2017 19:45:18 +0530
Message-ID: <1508076919-25873-1-git-send-email-mayhs11saini@gmail.com>
Cc: Shyam Saini <mayhs11saini@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:44025 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751386AbdJOOPl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Oct 2017 10:15:41 -0400
Received: by mail-pg0-f67.google.com with SMTP id s75so3942312pgs.0
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Oct 2017 07:15:40 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new operation allows to import low level virtual machine ruleset in
json to make incremental changes using the parse functions of libnftnl.

A basic way to test this new functionality is:

 % cat file.json | nft import vm json

where the file.json is a ruleset exported in low level json format.

To export json rules in low level virtual machine format
we need to use speify "vm" token before json. See below
	$ nft export vm json

and
	$ nft export/import json

will do no operations.
Same goes with  "$nft monitor"

Highly based on work from  Alvaro Neira <alvaroneay@gmail.com>
and Arturo Borrero <arturo@netfilter.org>

Acked-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
V5:
  Adopt new "vm" symbol in the grammer which will be used to specify
  json format in low level virtual machine format.
  The defaut format will be high level json format which will
  come into exitence with upcoming high level library.
  With this patch "export/import json" does no operation
---
 include/netlink.h  |   9 ++
 include/rule.h     |  14 +--
 src/evaluate.c     |   2 +
 src/netlink.c      | 285 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/parser_bison.y |  44 ++++++---
 src/rule.c         |  45 +++++++--
 src/scanner.l      |   2 +
 7 files changed, 373 insertions(+), 28 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 2ca6f345b6ac..68bb94a53cda 100644
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
index c59bcea75210..d138629cfa56 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -326,6 +326,7 @@ uint32_t obj_type_to_cmd(uint32_t type);
  * @CMD_RESET:		reset container
  * @CMD_FLUSH:		flush container
  * @CMD_RENAME:		rename object
+ * @CMD_IMPORT:		import a ruleset in a given format
  * @CMD_EXPORT:		export the ruleset in a given format
  * @CMD_MONITOR:	event listener
  * @CMD_DESCRIBE:	describe an expression
@@ -341,6 +342,7 @@ enum cmd_ops {
 	CMD_RESET,
 	CMD_FLUSH,
 	CMD_RENAME,
+	CMD_IMPORT,
 	CMD_EXPORT,
 	CMD_MONITOR,
 	CMD_DESCRIBE,
@@ -360,7 +362,7 @@ enum cmd_ops {
  * @CMD_OBJ_RULESET:	ruleset
  * @CMD_OBJ_EXPR:	expression
  * @CMD_OBJ_MONITOR:	monitor
- * @CMD_OBJ_EXPORT:	export
+ * @CMD_OBJ_MARKUP:	import/export
  * @CMD_OBJ_COUNTER:	counter
  * @CMD_OBJ_COUNTERS:	multiple counters
  * @CMD_OBJ_QUOTA:	quota
@@ -380,7 +382,7 @@ enum cmd_obj {
 	CMD_OBJ_RULESET,
 	CMD_OBJ_EXPR,
 	CMD_OBJ_MONITOR,
-	CMD_OBJ_EXPORT,
+	CMD_OBJ_MARKUP,
 	CMD_OBJ_FLOWTABLE,
 	CMD_OBJ_FLOWTABLES,
 	CMD_OBJ_MAP,
@@ -395,12 +397,12 @@ enum cmd_obj {
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
@@ -452,7 +454,7 @@ struct cmd {
 		struct chain	*chain;
 		struct table	*table;
 		struct monitor	*monitor;
-		struct export	*export;
+		struct markup	*markup;
 		struct obj	*object;
 	};
 	const void		*arg;
diff --git a/src/evaluate.c b/src/evaluate.c
index 618e1889863c..f4c675d139e6 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3481,6 +3481,8 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 		return 0;
 	case CMD_MONITOR:
 		return cmd_evaluate_monitor(ctx, cmd);
+	case CMD_IMPORT:
+		return 0;
 	default:
 		BUG("invalid command operation %u\n", cmd->op);
 	};
diff --git a/src/netlink.c b/src/netlink.c
index d5d410a84762..39f7beacf786 100644
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
@@ -3036,6 +3037,290 @@ int netlink_monitor(struct netlink_mon_handler *monhandler,
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
+		ret = mnl_nft_setelem_batch_add(set, rp->nl_ctx->batch,
+						0, rp->nl_ctx->seqnum);
+		break;
+	case NFTNL_CMD_DELETE:
+		ret = mnl_nft_setelem_batch_del(set, rp->nl_ctx->batch,
+						0, rp->nl_ctx->seqnum);
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
+					    rp->nl_ctx->seqnum);
+		break;
+	case NFTNL_CMD_DELETE:
+		ret = mnl_nft_set_batch_del(set, rp->nl_ctx->batch,
+					    0, rp->nl_ctx->seqnum);
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
+				      uint32_t cmd, struct nftnl_rule *rule)
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
+					     rp->nl_ctx->seqnum);
+		break;
+	case NFTNL_CMD_DELETE:
+		ret = mnl_nft_rule_batch_del(rule, rp->nl_ctx->batch,
+					     0, rp->nl_ctx->seqnum);
+		break;
+	case NFTNL_CMD_REPLACE:
+		nl_flags = NLM_F_REPLACE;
+		ret = mnl_nft_rule_batch_add(rule, rp->nl_ctx->batch, nl_flags,
+					     rp->nl_ctx->seqnum);
+		break;
+	case NFTNL_CMD_INSERT:
+		nl_flags = NLM_F_CREATE;
+		nftnl_rule_unset(rule, NFTNL_RULE_HANDLE);
+		ret = mnl_nft_rule_batch_add(rule, rp->nl_ctx->batch, nl_flags,
+					     rp->nl_ctx->seqnum);
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
+	const char  *table_get_name, *table_get_family;
+	const char *chain_get_table, *chain_get_name, *chain_get_family;
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
+		table_get_name = nftnl_table_get(table, NFTNL_TABLE_NAME);
+		table_get_family = nftnl_table_get(table, NFTNL_TABLE_FAMILY);
+
+		nftnl_rule_set(rule, NFTNL_RULE_TABLE, table_get_name);
+		nftnl_rule_set(rule, NFTNL_RULE_FAMILY, table_get_family);
+		break;
+	case NFTNL_RULESET_CHAIN:
+		chain = nftnl_ruleset_ctx_get(ctx, NFTNL_RULESET_CTX_CHAIN);
+		chain_get_table = nftnl_chain_get(chain, NFTNL_CHAIN_TABLE);
+		chain_get_name = nftnl_chain_get(chain, NFTNL_CHAIN_NAME);
+		chain_get_family = nftnl_chain_get(chain, NFTNL_TABLE_FAMILY);
+
+		nftnl_rule_set(rule, NFTNL_RULE_TABLE, chain_get_table);
+		nftnl_rule_set(rule, NFTNL_RULE_CHAIN, chain_get_name);
+		nftnl_rule_set(rule, NFTNL_RULE_FAMILY, chain_get_family);
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
+		ret = mnl_nft_chain_batch_add(chain, rp->nl_ctx->batch,
+					      0, rp->nl_ctx->seqnum);
+		break;
+	case NFTNL_CMD_DELETE:
+		ret = mnl_nft_chain_batch_del(chain, rp->nl_ctx->batch,
+					      0, rp->nl_ctx->seqnum);
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
+				       uint32_t cmd, struct nftnl_table *table)
+{
+	struct ruleset_parse *rp;
+	int ret = -1;
+
+	rp = nftnl_ruleset_ctx_get(ctx, NFTNL_RULESET_CTX_DATA);
+
+	switch (cmd) {
+	case NFTNL_CMD_ADD:
+		ret = mnl_nft_table_batch_add(table, rp->nl_ctx->batch,
+					      0, rp->nl_ctx->seqnum);
+		break;
+	case NFTNL_CMD_DELETE:
+		ret = mnl_nft_table_batch_del(table, rp->nl_ctx->batch,
+					      0, rp->nl_ctx->seqnum);
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
+				 "Could not import: %s", strerror(errno));
+
+	return 0;
+}
+
 bool netlink_batch_supported(struct mnl_socket *nf_sock, uint32_t *seqnum)
 {
 	return mnl_batch_supported(nf_sock, seqnum);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 7016f5b24887..884f7496f347 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -214,6 +214,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token FLUSH			"flush"
 %token RENAME			"rename"
 %token DESCRIBE			"describe"
+%token IMPORT			"import"
 %token EXPORT			"export"
 %token MONITOR			"monitor"
 
@@ -467,6 +468,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %token XML			"xml"
 %token JSON			"json"
+%token VM			"vm"
 
 %token NOTRACK			"notrack"
 
@@ -486,8 +488,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
 
-%type <cmd>			base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
-%destructor { cmd_free($$); }	base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
+%type <cmd>			base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd import_cmd
+%destructor { cmd_free($$); }	base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd import_cmd
 
 %type <handle>			table_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
 %destructor { handle_free(&$$); } table_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
@@ -675,7 +677,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	fib_expr
 %type <val>			fib_tuple	fib_result	fib_flag
 
-%type <val>			export_format
+%type <val>			markup_format
 %type <string>			monitor_event
 %destructor { xfree($$); }	monitor_event
 %type <val>			monitor_object	monitor_format
@@ -806,6 +808,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	RESET		reset_cmd	{ $$ = $2; }
 			|	FLUSH		flush_cmd	{ $$ = $2; }
 			|	RENAME		rename_cmd	{ $$ = $2; }
+			|       IMPORT          import_cmd      { $$ = $2; }
 			|	EXPORT		export_cmd	{ $$ = $2; }
 			|	MONITOR		monitor_cmd	{ $$ = $2; }
 			|	DESCRIBE	describe_cmd	{ $$ = $2; }
@@ -1163,18 +1166,34 @@ rename_cmd		:	CHAIN		chain_spec	identifier
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
 			}
+			|	JSON		{ $$ = NULL; }
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
+			}
+			|	JSON		{ $$ = NULL; }
 			;
 
 monitor_cmd		:	monitor_event	monitor_object	monitor_format
@@ -1201,11 +1220,12 @@ monitor_object		:	/* empty */	{ $$ = CMD_MONITOR_OBJ_ANY; }
 			;
 
 monitor_format		:	/* empty */	{ $$ = NFTNL_OUTPUT_DEFAULT; }
-			|	export_format
+			|	markup_format
+			|	JSON		{ $$ = NULL; }
 			;
 
-export_format		: 	XML 		{ $$ = NFTNL_OUTPUT_XML; }
-			|	JSON		{ $$ = NFTNL_OUTPUT_JSON; }
+markup_format		: 	XML 		{ $$ = NFTNL_OUTPUT_XML; }
+			|	VM JSON		{ $$ = NFTNL_OUTPUT_JSON; }
 			;
 
 describe_cmd		:	primary_expr
diff --git a/src/rule.c b/src/rule.c
index d744cf611100..a38e37afc1a2 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -898,19 +898,19 @@ void nft_cmd_expand(struct cmd *cmd)
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
@@ -958,8 +958,8 @@ void cmd_free(struct cmd *cmd)
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
@@ -1158,13 +1158,36 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 			return -1;
 	} while (rs == NULL);
 
-	nftnl_ruleset_fprintf(stdout, rs, cmd->export->format, 0);
+	nftnl_ruleset_fprintf(stdout, rs, cmd->markup->format,
+						NFTNL_OF_EVENT_NEW);
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
@@ -1790,6 +1813,8 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_command_flush(ctx, cmd);
 	case CMD_RENAME:
 		return do_command_rename(ctx, cmd);
+	case CMD_IMPORT:
+		return do_command_import(ctx, cmd);
 	case CMD_EXPORT:
 		return do_command_export(ctx, cmd);
 	case CMD_MONITOR:
diff --git a/src/scanner.l b/src/scanner.l
index 594073660c6b..277394a34a75 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -274,6 +274,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "reset"			{ return RESET; }
 "flush"			{ return FLUSH; }
 "rename"		{ return RENAME; }
+"import"                { return IMPORT; }
 "export"		{ return EXPORT; }
 "monitor"		{ return MONITOR; }
 
@@ -516,6 +517,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "xml"			{ return XML; }
 "json"			{ return JSON; }
+"vm"                    { return VM; }
 
 "exists"		{ return EXISTS; }
 "missing"		{ return MISSING; }
-- 
1.9.1

