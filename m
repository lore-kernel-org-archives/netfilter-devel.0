From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH v2] src: add import command
Date: Tue,  3 Mar 2015 00:04:33 +0100
Message-ID: <1425337473-24736-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36178 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbbCBXEV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 18:04:21 -0500
Received: by wghk14 with SMTP id k14so36597567wgh.3
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Mar 2015 15:04:19 -0800 (PST)
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
[changes in v2]
 * Fixed leaks in path errors
 * Refactored the code to make it more clear.

 include/rule.h     |   12 ++
 src/evaluate.c     |    1 +
 src/parser_bison.y |   20 ++-
 src/rule.c         |  383 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/scanner.l      |    1 +
 5 files changed, 414 insertions(+), 3 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 491411e..ff39df0 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -224,6 +224,7 @@ extern void set_print_plain(const struct set *s);
  * @CMD_EXPORT:		export the ruleset in a given format
  * @CMD_MONITOR:	event listener
  * @CMD_DESCRIBE:	describe an expression
+ * @CMD_IMPORT:		import a ruleset in a given format
  */
 enum cmd_ops {
 	CMD_INVALID,
@@ -237,6 +238,7 @@ enum cmd_ops {
 	CMD_EXPORT,
 	CMD_MONITOR,
 	CMD_DESCRIBE,
+	CMD_IMPORT,
 };
 
 /**
@@ -253,6 +255,7 @@ enum cmd_ops {
  * @CMD_OBJ_EXPR:	expression
  * @CMD_OBJ_MONITOR:	monitor
  * @CMD_OBJ_EXPORT:	export
+ * @CMD_OBJ_IMPORT:	import
  */
 enum cmd_obj {
 	CMD_OBJ_INVALID,
@@ -266,6 +269,7 @@ enum cmd_obj {
 	CMD_OBJ_EXPR,
 	CMD_OBJ_MONITOR,
 	CMD_OBJ_EXPORT,
+	CMD_OBJ_IMPORT,
 };
 
 struct export {
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
index a3484c6..998a80d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1968,6 +1968,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_RENAME:
 	case CMD_EXPORT:
 	case CMD_DESCRIBE:
+	case CMD_IMPORT:
 		return 0;
 	case CMD_MONITOR:
 		return cmd_evaluate_monitor(ctx, cmd);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index fd2407c..ccfbd99 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -190,6 +190,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token DESCRIBE			"describe"
 %token EXPORT			"export"
 %token MONITOR			"monitor"
+%token IMPORT			"import"
 
 %token ACCEPT			"accept"
 %token DROP			"drop"
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
@@ -640,6 +641,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	EXPORT		export_cmd	{ $$ = $2; }
 			|	MONITOR		monitor_cmd	{ $$ = $2; }
 			|	DESCRIBE	describe_cmd	{ $$ = $2; }
+			|	IMPORT		import_cmd	{ $$ = $2; }
 			;
 
 add_cmd			:	TABLE		table_spec
@@ -809,6 +811,14 @@ export_cmd		:	export_format
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
 monitor_cmd		:	monitor_event	monitor_object	monitor_format
 			{
 				struct handle h = { .family = NFPROTO_UNSPEC };
@@ -846,6 +856,10 @@ describe_cmd		:	primary_expr
 			}
 			;
 
+import_format		: 	XML 		{ $$ = NFT_PARSE_XML; }
+			|	JSON		{ $$ = NFT_PARSE_JSON; }
+			;
+
 table_block_alloc	:	/* empty */
 			{
 				$$ = table_alloc();
diff --git a/src/rule.c b/src/rule.c
index feafe26..f38d865 100644
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
@@ -602,6 +618,9 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_EXPORT:
 			export_free(cmd->export);
 			break;
+		case CMD_OBJ_IMPORT:
+			import_free(cmd->import);
+			break;
 		default:
 			BUG("invalid command object type %u\n", cmd->obj);
 		}
@@ -1001,6 +1020,368 @@ static int do_command_describe(struct netlink_ctx *ctx, struct cmd *cmd)
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
+	int ret;
+
+	set = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_SET);
+	if (set == NULL)
+		return -1;
+
+	rp = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
+	if (rp == NULL)
+		goto err;
+
+	cmd = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_CMD);
+
+	switch (cmd) {
+	case NFT_CMD_ADD:
+		ret = mnl_nft_setelem_batch_add(set, 0, rp->nl_ctx->seqnum);
+		break;
+	case NFT_CMD_DELETE:
+		ret = mnl_nft_setelem_batch_del(set, 0, rp->nl_ctx->seqnum);
+		break;
+	default:
+		goto err;
+	}
+
+	if (ret < 0)
+		netlink_io_error(rp->nl_ctx, &rp->cmd->location,
+				 "Could not import set_elems: %s",
+				 strerror(errno));
+
+	nft_set_free(set);
+	return ret;
+err:
+	nft_set_free(set);
+	return -1;
+}
+
+static int ruleset_parse_set(const struct nft_parse_ctx *ctx)
+{
+	const struct ruleset_parse *rp;
+	struct nft_set *set;
+	uint32_t cmd;
+	int ret;
+
+	set = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_SET);
+	if (set == NULL)
+		return -1;
+
+	rp = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
+	if (rp == NULL)
+		goto err;
+
+	cmd = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_CMD);
+
+	switch (cmd) {
+	case NFT_CMD_ADD:
+		ret = mnl_nft_set_batch_add(set, NLM_F_EXCL,
+					    rp->nl_ctx->seqnum);
+		break;
+	case NFT_CMD_DELETE:
+		ret = mnl_nft_set_batch_del(set, 0, rp->nl_ctx->seqnum);
+		break;
+	default:
+		goto err;
+	}
+
+	if (ret < 0)
+		netlink_io_error(rp->nl_ctx, &rp->cmd->location,
+				 "Could not import set: %s", strerror(errno));
+
+	ret = ruleset_parse_setelems(ctx);
+	return ret;
+err:
+	nft_set_free(set);
+	return -1;
+}
+
+static int ruleset_parse_build_rule_msg(const struct nft_parse_ctx *ctx,
+					uint32_t cmd, struct nft_rule *rule)
+{
+	const struct ruleset_parse *rp;
+	uint32_t nl_flags;
+	int ret;
+
+	rp = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
+	if (rp == NULL)
+		return -1;
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
+		return -1;
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
+	int ret;
+
+	cmd = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_CMD);
+
+	rule = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_RULE);
+	if (rule == NULL)
+		return -1;
+
+	ret = ruleset_parse_build_rule_msg(ctx, cmd, rule);
+
+	nft_rule_free(rule);
+	return ret;
+}
+
+static int ruleset_flush_rules(const struct nft_parse_ctx *ctx)
+{
+	struct nft_rule *rule;
+	struct nft_table *table;
+	struct nft_chain *chain;
+	uint32_t type;
+	int ret;
+
+	rule = nft_rule_alloc();
+	if (rule == NULL)
+		return -1;
+
+	type = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_TYPE);
+	switch (type) {
+	case NFT_RULESET_TABLE:
+		table = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_TABLE);
+		if (table == NULL)
+			goto err;
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
+		if (chain == NULL)
+			goto err;
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
+		goto err;
+	}
+
+	ret = ruleset_parse_build_rule_msg(ctx, NFT_CMD_DELETE, rule);
+
+	nft_rule_free(rule);
+	return ret;
+err:
+	nft_rule_free(rule);
+	return -1;
+}
+
+static int ruleset_parse_chain(const struct nft_parse_ctx *ctx)
+{
+	const struct ruleset_parse *rp;
+	struct nft_chain *chain;
+	uint32_t cmd;
+	int ret;
+
+	chain = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_CHAIN);
+	if (chain == NULL)
+		return -1;
+
+	rp = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
+	if (rp == NULL)
+		goto err;
+
+	nft_chain_attr_unset(chain, NFT_CHAIN_ATTR_HANDLE);
+
+	cmd = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_CMD);
+
+	switch (cmd) {
+	case NFT_CMD_ADD:
+		ret = mnl_nft_chain_batch_add(chain, 0, rp->nl_ctx->seqnum);
+		break;
+	case NFT_CMD_DELETE:
+		ret = mnl_nft_chain_batch_del(chain, 0, rp->nl_ctx->seqnum);
+		break;
+	case NFT_CMD_FLUSH:
+		ret = ruleset_flush_rules(ctx);
+		break;
+	default:
+		goto err;
+	}
+
+	if (ret < 0)
+		netlink_io_error(rp->nl_ctx, &rp->cmd->location,
+				 "Could not import chain: %s", strerror(errno));
+
+	nft_chain_free(chain);
+	return ret;
+err:
+	nft_chain_free(chain);
+	return -1;
+}
+
+static int ruleset_parse_build_table_msg(const struct nft_parse_ctx *ctx,
+					 uint32_t cmd, struct nft_table *table)
+{
+	int ret;
+	struct ruleset_parse *rp;
+
+	rp = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
+	if (rp == NULL)
+		return -1;
+
+	switch (cmd) {
+	case NFT_CMD_ADD:
+		ret = mnl_nft_table_batch_add(table, 0, rp->nl_ctx->seqnum);
+		break;
+	case NFT_CMD_DELETE:
+		ret = mnl_nft_table_batch_del(table, 0, rp->nl_ctx->seqnum);
+		break;
+	case NFT_CMD_FLUSH:
+		ret = ruleset_flush_rules(ctx);
+		break;
+	default:
+		return -1;
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
+	int ret;
+
+	cmd = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_CMD);
+
+	table = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_TABLE);
+	if (table == NULL)
+		return -1;
+
+	ret = ruleset_parse_build_table_msg(ctx, cmd, table);
+	nft_table_free(table);
+
+	return ret;
+}
+
+static int nft_ruleset_flush_ruleset(const struct nft_parse_ctx *ctx)
+{
+	struct nft_table *table;
+	int ret;
+
+	table = nft_table_alloc();
+	if (table == NULL)
+		return -1;
+
+	ret = ruleset_parse_build_table_msg(ctx, NFT_CMD_DELETE, table);
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
+		nft_ruleset_flush_ruleset(ctx);
+		break;
+	default:
+		return -1;
+	}
+
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
@@ -1024,6 +1405,8 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_command_monitor(ctx, cmd);
 	case CMD_DESCRIBE:
 		return do_command_describe(ctx, cmd);
+	case CMD_IMPORT:
+		return do_command_import(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/scanner.l b/src/scanner.l
index 73c4f8b..bf949f8 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -262,6 +262,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "flush"			{ return FLUSH; }
 "rename"		{ return RENAME; }
 "export"		{ return EXPORT; }
+"import"		{ return IMPORT; }
 "monitor"		{ return MONITOR; }
 
 "position"		{ return POSITION; }
-- 
1.7.10.4

