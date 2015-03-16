From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 3/3 v5] src: add import command
Date: Mon, 16 Mar 2015 16:06:11 +0100
Message-ID: <1426518371-11717-3-git-send-email-alvaroneay@gmail.com>
References: <1426518371-11717-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37065 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933062AbbCPPGC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2015 11:06:02 -0400
Received: by wixw10 with SMTP id w10so46076623wix.0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2015 08:06:01 -0700 (PDT)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id s19sm15725928wik.18.2015.03.16.08.05.59
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Mar 2015 08:06:00 -0700 (PDT)
In-Reply-To: <1426518371-11717-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A basic way to test this new functionality is:
 % cat file.json | nft import json

where the file.json is a ruleset exported in json format.

This new operation allows to import ruleset in json and xml and to make
incremental changes using the new parse functions of libnftnl.

Based on a patch from Arturo Borrero.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[Changes in v5]
 * Renamed the funcions to make the netlink message
 * Consolidate the code to show the errors in the functions to make
   the netlink message

 include/netlink.h  |    9 ++
 include/rule.h     |   14 +--
 src/evaluate.c     |    1 +
 src/netlink.c      |  279 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/parser_bison.y |   28 ++++--
 src/rule.c         |   42 ++++++--
 src/scanner.l      |    1 +
 7 files changed, 350 insertions(+), 24 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 4f79470..8dc541b 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -165,4 +165,13 @@ struct netlink_mon_handler {
 extern int netlink_monitor(struct netlink_mon_handler *monhandler);
 bool netlink_batch_supported(void);
 
+struct ruleset_parse {
+	struct netlink_ctx	*nl_ctx;
+	struct cmd		*cmd;
+};
+
+struct nft_parse_ctx;
+
+int netlink_markup_parse_cb(const struct nft_parse_ctx *ctx);
+
 #endif /* NFTABLES_NETLINK_H */
diff --git a/include/rule.h b/include/rule.h
index 491411e..41b902a 100644
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
@@ -252,7 +254,7 @@ enum cmd_ops {
  * @CMD_OBJ_RULESET:	ruleset
  * @CMD_OBJ_EXPR:	expression
  * @CMD_OBJ_MONITOR:	monitor
- * @CMD_OBJ_EXPORT:	export
+ * @CMD_OBJ_MARKUP:	import/export
  */
 enum cmd_obj {
 	CMD_OBJ_INVALID,
@@ -265,15 +267,15 @@ enum cmd_obj {
 	CMD_OBJ_RULESET,
 	CMD_OBJ_EXPR,
 	CMD_OBJ_MONITOR,
-	CMD_OBJ_EXPORT,
+	CMD_OBJ_MARKUP,
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
@@ -324,7 +326,7 @@ struct cmd {
 		struct chain	*chain;
 		struct table	*table;
 		struct monitor	*monitor;
-		struct export	*export;
+		struct markup	*markup;
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
diff --git a/src/netlink.c b/src/netlink.c
index 84d9d27..0a6ab22 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -22,6 +22,7 @@
 #include <libnftnl/expr.h>
 #include <libnftnl/set.h>
 #include <libnftnl/common.h>
+#include <libnftnl/ruleset.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter.h>
@@ -2061,6 +2062,284 @@ int netlink_monitor(struct netlink_mon_handler *monhandler)
 				      monhandler);
 }
 
+static int netlink_markup_setelems(const struct nft_parse_ctx *ctx)
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
+	return ret;
+}
+
+static int netlink_markup_set(const struct nft_parse_ctx *ctx)
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
+	if (ret < 0)
+		return ret;
+
+	return netlink_markup_setelems(ctx);
+}
+
+static int netlink_markup_build_rule(const struct nft_parse_ctx *ctx,
+				     uint32_t cmd, struct nft_rule *rule)
+{
+	const struct ruleset_parse *rp;
+	uint32_t nl_flags;
+	int ret = -1;
+
+	rp = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
+
+	switch (cmd) {
+	case NFT_CMD_ADD:
+		nl_flags = NLM_F_APPEND | NLM_F_CREATE;
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
+	return ret;
+}
+
+static int netlink_markup_rule(const struct nft_parse_ctx *ctx)
+{
+	struct nft_rule *rule;
+	uint32_t cmd;
+
+	cmd = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_CMD);
+	rule = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_RULE);
+
+	return netlink_markup_build_rule(ctx, cmd, rule);
+}
+
+static int netlink_markup_build_flush(const struct nft_parse_ctx *ctx)
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
+	ret = netlink_markup_build_rule(ctx, NFT_CMD_DELETE, rule);
+err:
+	nft_rule_free(rule);
+	return ret;
+}
+
+static int netlink_markup_chain(const struct nft_parse_ctx *ctx)
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
+static int netlink_markup_build_table(const struct nft_parse_ctx *ctx,
+				      uint32_t cmd, struct nft_table *table)
+{
+	struct ruleset_parse *rp;
+	int ret = -1;
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
+		ret = netlink_markup_build_flush(ctx);
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
+static int netlink_markup_table(const struct nft_parse_ctx *ctx)
+{
+	struct nft_table *table;
+	uint32_t cmd;
+
+	cmd = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_CMD);
+	table = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_TABLE);
+
+	return netlink_markup_build_table(ctx, cmd, table);
+}
+
+static int netlink_markup_flush(const struct nft_parse_ctx *ctx)
+{
+	struct nft_table *table;
+	int ret;
+
+	table = nft_table_alloc();
+	if (table == NULL)
+		return -1;
+
+	ret = netlink_markup_build_table(ctx, NFT_CMD_DELETE, table);
+	nft_table_free(table);
+
+	return ret;
+}
+
+int netlink_markup_parse_cb(const struct nft_parse_ctx *ctx)
+{
+	struct ruleset_parse *rp;
+	uint32_t type;
+	int ret = -1;
+
+	rp = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
+
+	type = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_TYPE);
+	switch (type) {
+	case NFT_RULESET_TABLE:
+		ret = netlink_markup_table(ctx);
+		break;
+	case NFT_RULESET_CHAIN:
+		ret = netlink_markup_chain(ctx);
+		break;
+	case NFT_RULESET_RULE:
+		ret = netlink_markup_rule(ctx);
+		break;
+	case NFT_RULESET_SET:
+		ret = netlink_markup_set(ctx);
+		break;
+	case NFT_RULESET_SET_ELEMS:
+		ret = netlink_markup_setelems(ctx);
+		break;
+	case NFT_RULESET_RULESET:
+		ret = netlink_markup_flush(ctx);
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		break;
+	}
+	nft_ruleset_ctx_free(ctx);
+
+	if (ret < 0)
+		netlink_io_error(rp->nl_ctx, &rp->cmd->location,
+				 "Could not import: %s", strerror(errno));
+
+	return 0;
+}
+
 bool netlink_batch_supported(void)
 {
 	return mnl_batch_supported(nf_sock);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index fd2407c..15cad93 100644
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
+%type <val>			markup_format
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
@@ -801,11 +803,19 @@ rename_cmd		:	CHAIN		chain_spec	identifier
 			}
 			;
 
-export_cmd		:	export_format
+import_cmd		:	markup_format
 			{
 				struct handle h = { .family = NFPROTO_UNSPEC };
-				struct export *export = export_alloc($1);
-				$$ = cmd_alloc(CMD_EXPORT, CMD_OBJ_EXPORT, &h, &@$, export);
+				struct markup *markup = markup_alloc($1);
+				$$ = cmd_alloc(CMD_IMPORT, CMD_OBJ_MARKUP, &h, &@$, markup);
+			}
+			;
+
+export_cmd		:	markup_format
+			{
+				struct handle h = { .family = NFPROTO_UNSPEC };
+				struct markup *markup = markup_alloc($1);
+				$$ = cmd_alloc(CMD_EXPORT, CMD_OBJ_MARKUP, &h, &@$, markup);
 			}
 			;
 
@@ -831,11 +841,11 @@ monitor_object		:	/* empty */	{ $$ = CMD_MONITOR_OBJ_ANY; }
 			;
 
 monitor_format		:	/* empty */	{ $$ = NFT_OUTPUT_DEFAULT; }
-			|	export_format
+			|	markup_format
 			;
 
-export_format		: 	XML 		{ $$ = NFT_OUTPUT_XML; }
-			|	JSON		{ $$ = NFT_OUTPUT_JSON; }
+markup_format		: 	XML 		{ $$ = NFT_PARSE_XML; }
+			|	JSON		{ $$ = NFT_PARSE_JSON; }
 			;
 
 describe_cmd		:	primary_expr
diff --git a/src/rule.c b/src/rule.c
index b392ead..5be3f12 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -540,17 +540,17 @@ struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 	return cmd;
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
+void markup_free(struct markup *e)
 {
 	xfree(e);
 }
@@ -599,8 +599,8 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_MONITOR:
 			monitor_free(cmd->monitor);
 			break;
-		case CMD_OBJ_EXPORT:
-			export_free(cmd->export);
+		case CMD_OBJ_MARKUP:
+			markup_free(cmd->markup);
 			break;
 		default:
 			BUG("invalid command object type %u\n", cmd->obj);
@@ -754,7 +754,7 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 	if (rs == NULL)
 		return -1;
 
-	nft_ruleset_fprintf(stdout, rs, cmd->export->format, NFT_OF_EVENT_NEW);
+	nft_ruleset_fprintf(stdout, rs, cmd->markup->format, NFT_OF_EVENT_NEW);
 	fprintf(stdout, "\n");
 
 	nft_ruleset_free(rs);
@@ -1006,6 +1006,28 @@ static int do_command_describe(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+static int do_command_import(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	int ret;
+	struct nft_parse_err *err;
+	struct ruleset_parse rp = {
+		.nl_ctx	= ctx,
+		.cmd	= cmd
+	};
+
+	err = nft_parse_err_alloc();
+	if (err == NULL)
+		return -1;
+
+	ret = nft_ruleset_parse_file_cb(cmd->markup->format, stdin, err, &rp,
+					netlink_markup_parse_cb);
+	if (ret < 0)
+		nft_parse_perror("unable to import: parsing failed", err);
+
+	nft_parse_err_free(err);
+	return ret;
+}
+
 int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->op) {
@@ -1023,6 +1045,8 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
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

