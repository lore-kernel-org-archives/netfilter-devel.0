From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH v3 2/2] src: add import command
Date: Tue, 10 Mar 2015 11:04:18 +0100
Message-ID: <1425981858-10687-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:44576 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbbCJKEA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2015 06:04:00 -0400
Received: by wivr20 with SMTP id r20so1476752wiv.3
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2015 03:03:59 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A basic way to test this new functionality is:
 % cat file.json | nft import json

where the file.json is a ruleset exported in json format.

This new operation allows to import ruleset in json and xml and to make
incremental changes using the new parse functions of libnftnl.

Based in a patch of Arturo Borrero.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v3]
 * Defined the import enums before to export enums.
 * Removed unnecessary NULL checks
 * Renamed some functions name and refactored the code to make it more clear

 include/rule.h     |   12 ++
 src/evaluate.c     |    1 +
 src/parser_bison.y |   20 +++-
 src/rule.c         |  337 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/scanner.l      |    1 +
 5 files changed, 368 insertions(+), 3 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 491411e..c12d65b 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -221,6 +221,7 @@ extern void set_print_plain(const struct set *s);
  * @CMD_LIST:		list container
  * @CMD_FLUSH:		flush container
  * @CMD_RENAME:		rename object
+ * @CMD_IMPORT:		import a ruleset in a given format
  * @CMD_EXPORT:		export the ruleset in a given format
  * @CMD_MONITOR:	event listener
  * @CMD_DESCRIBE:	describe an expression
@@ -234,6 +235,7 @@ enum cmd_ops {
 	CMD_LIST,
 	CMD_FLUSH,
 	CMD_RENAME,
+	CMD_IMPORT,
 	CMD_EXPORT,
 	CMD_MONITOR,
 	CMD_DESCRIBE,
@@ -252,6 +254,7 @@ enum cmd_ops {
  * @CMD_OBJ_RULESET:	ruleset
  * @CMD_OBJ_EXPR:	expression
  * @CMD_OBJ_MONITOR:	monitor
+ * @CMD_OBJ_IMPORT:	import
  * @CMD_OBJ_EXPORT:	export
  */
 enum cmd_obj {
@@ -265,6 +268,7 @@ enum cmd_obj {
 	CMD_OBJ_RULESET,
 	CMD_OBJ_EXPR,
 	CMD_OBJ_MONITOR,
+	CMD_OBJ_IMPORT,
 	CMD_OBJ_EXPORT,
 };
 
@@ -275,6 +279,13 @@ struct export {
 struct export *export_alloc(uint32_t format);
 void export_free(struct export *e);
 
+struct import {
+	uint32_t	format;
+};
+
+struct import *import_alloc(uint32_t format);
+void import_free(struct import *i);
+
 enum {
 	CMD_MONITOR_OBJ_ANY,
 	CMD_MONITOR_OBJ_TABLES,
@@ -325,6 +336,7 @@ struct cmd {
 		struct table	*table;
 		struct monitor	*monitor;
 		struct export	*export;
+		struct import	*import;
 	};
 	const void		*arg;
 };
diff --git a/src/evaluate.c b/src/evaluate.c
index a3484c6..451ba20 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1966,6 +1966,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_LIST:
 	case CMD_FLUSH:
 	case CMD_RENAME:
+	case CMD_IMPORT:
 	case CMD_EXPORT:
 	case CMD_DESCRIBE:
 		return 0;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index fd2407c..9e4de02 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -188,6 +188,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token FLUSH			"flush"
 %token RENAME			"rename"
 %token DESCRIBE			"describe"
+%token IMPORT			"import"
 %token EXPORT			"export"
 %token MONITOR			"monitor"
 
@@ -402,8 +403,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
 
-%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
-%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
+%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd import_cmd
+%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd import_cmd
 
 %type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec
 %destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec
@@ -535,7 +536,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	ct_expr
 %type <val>			ct_key
 
-%type <val>			export_format
+%type <val>			export_format	import_format
 %type <string>			monitor_event
 %destructor { xfree($$); }	monitor_event
 %type <val>			monitor_object	monitor_format
@@ -637,6 +638,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	LIST		list_cmd	{ $$ = $2; }
 			|	FLUSH		flush_cmd	{ $$ = $2; }
 			|	RENAME		rename_cmd	{ $$ = $2; }
+			|	IMPORT		import_cmd	{ $$ = $2; }
 			|	EXPORT		export_cmd	{ $$ = $2; }
 			|	MONITOR		monitor_cmd	{ $$ = $2; }
 			|	DESCRIBE	describe_cmd	{ $$ = $2; }
@@ -801,6 +803,14 @@ rename_cmd		:	CHAIN		chain_spec	identifier
 			}
 			;
 
+import_cmd		:	import_format
+			{
+				struct handle h = { .family = NFPROTO_UNSPEC };
+				struct import *import = import_alloc($1);
+				$$ = cmd_alloc(CMD_IMPORT, CMD_OBJ_IMPORT, &h, &@$, import);
+			}
+			;
+
 export_cmd		:	export_format
 			{
 				struct handle h = { .family = NFPROTO_UNSPEC };
@@ -834,6 +844,10 @@ monitor_format		:	/* empty */	{ $$ = NFT_OUTPUT_DEFAULT; }
 			|	export_format
 			;
 
+import_format		: 	XML 		{ $$ = NFT_PARSE_XML; }
+			|	JSON		{ $$ = NFT_PARSE_JSON; }
+			;
+
 export_format		: 	XML 		{ $$ = NFT_OUTPUT_XML; }
 			|	JSON		{ $$ = NFT_OUTPUT_JSON; }
 			;
diff --git a/src/rule.c b/src/rule.c
index 8d76fd0..8c58a2b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -20,6 +20,7 @@
 #include <rule.h>
 #include <utils.h>
 #include <netlink.h>
+#include <mnl.h>
 
 #include <libnftnl/common.h>
 #include <libnftnl/ruleset.h>
@@ -555,6 +556,21 @@ void export_free(struct export *e)
 	xfree(e);
 }
 
+struct import *import_alloc(uint32_t format)
+{
+	struct import *import;
+
+	import = xmalloc(sizeof(struct import));
+	import->format = format;
+
+	return import;
+}
+
+void import_free(struct import *i)
+{
+	xfree(i);
+}
+
 struct monitor *monitor_alloc(uint32_t format, uint32_t type, const char *event)
 {
 	struct monitor *mon;
@@ -599,6 +615,9 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_MONITOR:
 			monitor_free(cmd->monitor);
 			break;
+		case CMD_OBJ_IMPORT:
+			import_free(cmd->import);
+			break;
 		case CMD_OBJ_EXPORT:
 			export_free(cmd->export);
 			break;
@@ -1006,6 +1025,322 @@ static int do_command_describe(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+struct ruleset_parse {
+	struct netlink_ctx *nl_ctx;
+	struct cmd *cmd;
+};
+
+static int ruleset_parse_setelems(const struct nft_parse_ctx *ctx)
+{
+	const struct ruleset_parse *rp;
+	struct nft_set *set;
+	uint32_t cmd;
+	int ret = -1;
+
+	set = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_SET);
+	rp = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
+
+	cmd = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_CMD);
+	switch (cmd) {
+	case NFT_CMD_ADD:
+		ret = mnl_nft_setelem_batch_add(set, 0, rp->nl_ctx->seqnum);
+		break;
+	case NFT_CMD_DELETE:
+		ret = mnl_nft_setelem_batch_del(set, 0, rp->nl_ctx->seqnum);
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		break;
+	}
+
+	if (ret < 0)
+		netlink_io_error(rp->nl_ctx, &rp->cmd->location,
+				 "Could not import set_elems: %s",
+				 strerror(errno));
+
+	return ret;
+}
+
+static int ruleset_parse_set(const struct nft_parse_ctx *ctx)
+{
+	const struct ruleset_parse *rp;
+	struct nft_set *set;
+	uint32_t cmd;
+	int ret = -1;
+
+	set = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_SET);
+	rp = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
+
+	cmd = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_CMD);
+	switch (cmd) {
+	case NFT_CMD_ADD:
+		ret = mnl_nft_set_batch_add(set, NLM_F_EXCL,
+					    rp->nl_ctx->seqnum);
+		break;
+	case NFT_CMD_DELETE:
+		ret = mnl_nft_set_batch_del(set, 0, rp->nl_ctx->seqnum);
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		break;
+	}
+
+	if (ret < 0) {
+		netlink_io_error(rp->nl_ctx, &rp->cmd->location,
+				 "Could not import set: %s", strerror(errno));
+		return ret;
+	}
+
+	return ruleset_parse_setelems(ctx);
+}
+
+static int ruleset_parse_build_rule_nlmsg(const struct nft_parse_ctx *ctx,
+					  uint32_t cmd, struct nft_rule *rule)
+{
+	const struct ruleset_parse *rp;
+	uint32_t nl_flags;
+	int ret = -1;
+
+	rp = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
+
+	switch (cmd) {
+	case NFT_CMD_ADD:
+		nl_flags = NLM_F_APPEND|NLM_F_CREATE;
+		nft_rule_attr_unset(rule, NFT_RULE_ATTR_HANDLE);
+		ret = mnl_nft_rule_batch_add(rule, nl_flags,
+					     rp->nl_ctx->seqnum);
+		break;
+	case NFT_CMD_DELETE:
+		ret = mnl_nft_rule_batch_del(rule, 0, rp->nl_ctx->seqnum);
+		break;
+	case NFT_CMD_REPLACE:
+		nl_flags = NLM_F_REPLACE;
+		ret = mnl_nft_rule_batch_add(rule, nl_flags,
+					     rp->nl_ctx->seqnum);
+		break;
+	case NFT_CMD_INSERT:
+		nl_flags = NLM_F_CREATE;
+		nft_rule_attr_unset(rule, NFT_RULE_ATTR_HANDLE);
+		ret = mnl_nft_rule_batch_add(rule, nl_flags,
+					     rp->nl_ctx->seqnum);
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		break;
+	}
+
+	if (ret < 0)
+		netlink_io_error(rp->nl_ctx, &rp->cmd->location,
+				 "Could not import rule: %s", strerror(errno));
+
+	return ret;
+}
+
+static int ruleset_parse_rule(const struct nft_parse_ctx *ctx)
+{
+	struct nft_rule *rule;
+	uint32_t cmd;
+
+	cmd = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_CMD);
+	rule = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_RULE);
+
+	return ruleset_parse_build_rule_nlmsg(ctx, cmd, rule);
+}
+
+static int ruleset_build_flush_rules_nlmsg(const struct nft_parse_ctx *ctx)
+{
+	struct nft_rule *rule;
+	struct nft_table *table;
+	struct nft_chain *chain;
+	uint32_t type;
+	int ret = -1;
+
+	rule = nft_rule_alloc();
+	if (rule == NULL)
+		return -1;
+
+	type = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_TYPE);
+	switch (type) {
+	case NFT_RULESET_TABLE:
+		table = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_TABLE);
+
+		nft_rule_attr_set(rule, NFT_RULE_ATTR_TABLE,
+				  nft_table_attr_get(table,
+						     NFT_TABLE_ATTR_NAME));
+		nft_rule_attr_set(rule, NFT_RULE_ATTR_FAMILY,
+				  nft_table_attr_get(table,
+						     NFT_TABLE_ATTR_FAMILY));
+		break;
+	case NFT_RULESET_CHAIN:
+		chain = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_CHAIN);
+
+		nft_rule_attr_set(rule, NFT_RULE_ATTR_TABLE,
+				  nft_chain_attr_get(chain,
+						     NFT_CHAIN_ATTR_TABLE));
+		nft_rule_attr_set(rule, NFT_RULE_ATTR_CHAIN,
+				  nft_chain_attr_get(chain,
+						     NFT_CHAIN_ATTR_NAME));
+		nft_rule_attr_set(rule, NFT_RULE_ATTR_FAMILY,
+				  nft_chain_attr_get(chain,
+						     NFT_TABLE_ATTR_FAMILY));
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		goto err;
+	}
+
+	ret = ruleset_parse_build_rule_nlmsg(ctx, NFT_CMD_DELETE, rule);
+err:
+	nft_rule_free(rule);
+	return ret;
+}
+
+static int ruleset_parse_chain(const struct nft_parse_ctx *ctx)
+{
+	const struct ruleset_parse *rp;
+	struct nft_chain *chain;
+	uint32_t cmd;
+	int ret = -1;
+
+	chain = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_CHAIN);
+	rp = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
+
+	nft_chain_attr_unset(chain, NFT_CHAIN_ATTR_HANDLE);
+
+	cmd = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_CMD);
+	switch (cmd) {
+	case NFT_CMD_ADD:
+		ret = mnl_nft_chain_batch_add(chain, 0, rp->nl_ctx->seqnum);
+		break;
+	case NFT_CMD_DELETE:
+		ret = mnl_nft_chain_batch_del(chain, 0, rp->nl_ctx->seqnum);
+		break;
+	case NFT_CMD_FLUSH:
+		ret = ruleset_build_flush_rules_nlmsg(ctx);
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		break;
+	}
+
+	if (ret < 0)
+		netlink_io_error(rp->nl_ctx, &rp->cmd->location,
+				 "Could not import chain: %s", strerror(errno));
+
+	return ret;
+}
+
+static int ruleset_parse_build_table_nlmsg(const struct nft_parse_ctx *ctx,
+					   uint32_t cmd, struct nft_table *table)
+{
+	int ret = -1;
+	struct ruleset_parse *rp;
+
+	rp = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
+
+	switch (cmd) {
+	case NFT_CMD_ADD:
+		ret = mnl_nft_table_batch_add(table, 0, rp->nl_ctx->seqnum);
+		break;
+	case NFT_CMD_DELETE:
+		ret = mnl_nft_table_batch_del(table, 0, rp->nl_ctx->seqnum);
+		break;
+	case NFT_CMD_FLUSH:
+		ret = ruleset_build_flush_rules_nlmsg(ctx);
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		break;
+	}
+
+	if (ret < 0)
+		netlink_io_error(rp->nl_ctx, &rp->cmd->location,
+				 "Could not import table: %s", strerror(errno));
+
+	return ret;
+
+}
+
+static int ruleset_parse_table(const struct nft_parse_ctx *ctx)
+{
+	struct nft_table *table;
+	uint32_t cmd;
+
+	cmd = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_CMD);
+	table = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_TABLE);
+
+	return ruleset_parse_build_table_nlmsg(ctx, cmd, table);
+}
+
+static int nft_ruleset_build_flush_nlmsg(const struct nft_parse_ctx *ctx)
+{
+	struct nft_table *table;
+	int ret;
+
+	table = nft_table_alloc();
+	if (table == NULL)
+		return -1;
+
+	ret = ruleset_parse_build_table_nlmsg(ctx, NFT_CMD_DELETE, table);
+	nft_table_free(table);
+
+	return ret;
+}
+
+static int ruleset_parse_cb(const struct nft_parse_ctx *ctx)
+{
+	uint32_t type;
+
+	type = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_TYPE);
+	switch (type) {
+	case NFT_RULESET_TABLE:
+		ruleset_parse_table(ctx);
+		break;
+	case NFT_RULESET_CHAIN:
+		ruleset_parse_chain(ctx);
+		break;
+	case NFT_RULESET_RULE:
+		ruleset_parse_rule(ctx);
+		break;
+	case NFT_RULESET_SET:
+		ruleset_parse_set(ctx);
+		break;
+	case NFT_RULESET_SET_ELEMS:
+		ruleset_parse_setelems(ctx);
+		break;
+	case NFT_RULESET_RULESET:
+		nft_ruleset_build_flush_nlmsg(ctx);
+		break;
+	default:
+		return -1;
+	}
+
+	nft_ruleset_ctx_free((struct nft_parse_ctx *)ctx);
+	return 0;
+}
+
+static int do_command_import(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	int ret;
+	struct nft_parse_err *err;
+	struct ruleset_parse rp = {
+		.nl_ctx = ctx,
+		.cmd = cmd
+	};
+
+	err = nft_parse_err_alloc();
+	if (err == NULL)
+		return -1;
+
+	ret = nft_ruleset_parse_file_cb(cmd->import->format, stdin, err, &rp,
+					ruleset_parse_cb);
+	if (ret < 0)
+		nft_parse_perror("unable to import. Parsing failed", err);
+
+	nft_parse_err_free(err);
+	return ret;
+}
+
 int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->op) {
@@ -1023,6 +1358,8 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_command_flush(ctx, cmd);
 	case CMD_RENAME:
 		return do_command_rename(ctx, cmd);
+	case CMD_IMPORT:
+		return do_command_import(ctx, cmd);
 	case CMD_EXPORT:
 		return do_command_export(ctx, cmd);
 	case CMD_MONITOR:
diff --git a/src/scanner.l b/src/scanner.l
index 73c4f8b..94b41c9 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -261,6 +261,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "list"			{ return LIST; }
 "flush"			{ return FLUSH; }
 "rename"		{ return RENAME; }
+"import"		{ return IMPORT; }
 "export"		{ return EXPORT; }
 "monitor"		{ return MONITOR; }
 
-- 
1.7.10.4

