From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] cli: complete basic functionality of the interactive mode
Date: Tue, 14 May 2013 23:54:04 +0200
Message-ID: <1368568444-9854-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51231 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758091Ab3ENVyQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 17:54:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds missing code to get basic interactive mode
operative via `nft -i', including parsing, evaluation,
command execution via netlink and error reporting.

Autocomplete is not yet implemented.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/nftables.h |    4 ++-
 src/cli.c          |   13 ++++++----
 src/main.c         |   71 +++++++++++++++++++++++++++++-----------------------
 src/rule.c         |   25 +++++++++++++-----
 4 files changed, 70 insertions(+), 43 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 66bfab3..0eab1e5 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -25,7 +25,7 @@ extern unsigned int debug_level;
 extern const char *include_paths[INCLUDE_PATHS_MAX];
 
 struct parser_state;
-extern int cli_init(void *scanner, struct parser_state *state);
+extern int cli_init(struct parser_state *state);
 extern void cli_exit(void);
 extern void cli_display(const char *fmt, va_list ap) __fmtstring(1, 0);
 
@@ -101,4 +101,6 @@ struct input_descriptor {
 	off_t				line_offset;
 };
 
+int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs);
+
 #endif /* NFTABLES_NFTABLES_H */
diff --git a/src/cli.c b/src/cli.c
index e302dfa..fce34e1 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -27,11 +27,13 @@
 #include <parser.h>
 #include <erec.h>
 #include <utils.h>
+#include <netlink.h>
 
 #define CMDLINE_HISTFILE	".nft.history"
 
 static const struct input_descriptor indesc_cli = {
 	.type	= INDESC_CLI,
+	.name   = "<cli>",
 };
 
 static struct parser_state *state;
@@ -86,6 +88,7 @@ static void cli_complete(char *line)
 {
 	const HIST_ENTRY *hist;
 	const char *c;
+	LIST_HEAD(msgs);
 
 	line = cli_append_multiline(line);
 	if (line == NULL)
@@ -102,10 +105,10 @@ static void cli_complete(char *line)
 	if (hist == NULL || strcmp(hist->line, line))
 		add_history(line);
 
+	parser_init(state, &msgs);
 	scanner_push_buffer(scanner, &indesc_cli, line);
-	nft_parse(scanner, state);
-
-	erec_print_list(stdout, state->msgs);
+	nft_run(scanner, state, &msgs);
+	erec_print_list(stdout, &msgs);
 	xfree(line);
 }
 
@@ -140,7 +143,7 @@ void __fmtstring(1, 0) cli_display(const char *fmt, va_list ap)
 	rl_forced_update_display();
 }
 
-int cli_init(void *_scanner, struct parser_state *_state)
+int cli_init(struct parser_state *_state)
 {
 	const char *home;
 
@@ -159,8 +162,8 @@ int cli_init(void *_scanner, struct parser_state *_state)
 	read_history(histfile);
 	history_set_pos(history_length);
 
-	scanner = _scanner;
 	state	= _state;
+	scanner = scanner_init(state);
 
 	while (!eof)
 		rl_callback_read_char();
diff --git a/src/main.c b/src/main.c
index ab2ceab..283ec28 100644
--- a/src/main.c
+++ b/src/main.c
@@ -141,17 +141,48 @@ static const struct input_descriptor indesc_cmdline = {
 	.name	= "<cmdline>",
 };
 
+int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs)
+{
+	struct eval_ctx ctx;
+	int ret;
+
+	ret = nft_parse(scanner, state);
+	if (ret != 0)
+		return -1;
+
+	memset(&ctx, 0, sizeof(ctx));
+	ctx.msgs = msgs;
+	if (evaluate(&ctx, &state->cmds) < 0)
+		return -1;
+
+	{
+		struct netlink_ctx ctx;
+		struct cmd *cmd, *next;
+
+		list_for_each_entry_safe(cmd, next, &state->cmds, list) {
+			memset(&ctx, 0, sizeof(ctx));
+			ctx.msgs = msgs;
+			init_list_head(&ctx.list);
+			ret = do_command(&ctx, cmd);
+			list_del(&cmd->list);
+			cmd_free(cmd);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
 int main(int argc, char * const *argv)
 {
 	struct parser_state state;
-	struct eval_ctx ctx;
 	void *scanner;
 	LIST_HEAD(msgs);
 	char *buf = NULL, *filename = NULL;
 	unsigned int len;
 	bool interactive = false;
 	int i, val;
-	int ret;
 
 	while (1) {
 		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
@@ -218,9 +249,6 @@ int main(int argc, char * const *argv)
 		}
 	}
 
-	parser_init(&state, &msgs);
-	scanner = scanner_init(&state);
-
 	if (optind != argc) {
 		for (len = 0, i = optind; i < argc; i++)
 			len += strlen(argv[i]) + strlen(" ");
@@ -231,44 +259,25 @@ int main(int argc, char * const *argv)
 			if (i + 1 < argc)
 				strcat(buf, " ");
 		}
-
+		parser_init(&state, &msgs);
+		scanner = scanner_init(&state);
 		scanner_push_buffer(scanner, &indesc_cmdline, buf);
 	} else if (filename != NULL) {
+		parser_init(&state, &msgs);
+		scanner = scanner_init(&state);
 		if (scanner_read_file(scanner, filename, &internal_location) < 0)
 			goto out;
 	} else if (interactive) {
-		cli_init(scanner, &state);
+		cli_init(&state);
+		return 0;
 	} else {
 		fprintf(stderr, "%s: no command specified\n", argv[0]);
 		exit(NFT_EXIT_FAILURE);
 	}
 
-	ret = nft_parse(scanner, &state);
-	if (ret != 0)
-		goto out;
-
-	memset(&ctx, 0, sizeof(ctx));
-	ctx.msgs = &msgs;
-	if (evaluate(&ctx, &state.cmds) < 0)
-		goto out;
-
-	{
-		struct netlink_ctx ctx;
-		struct cmd *cmd, *next;
-
-		list_for_each_entry_safe(cmd, next, &state.cmds, list) {
-			memset(&ctx, 0, sizeof(ctx));
-			ctx.msgs = &msgs;
-			init_list_head(&ctx.list);
-			if (do_command(&ctx, cmd) < 0)
-				goto out;
-			list_del(&cmd->list);
-			cmd_free(cmd);
-		}
-	}
+	nft_run(scanner, &state, &msgs);
 out:
 	scanner_destroy(scanner);
-	scope_release(&state.top_scope);
 	erec_print_list(stdout, &msgs);
 
 	xfree(buf);
diff --git a/src/rule.c b/src/rule.c
index 89c3607..9d9eaee 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -142,7 +142,6 @@ void rule_print(const struct rule *rule)
 struct scope *scope_init(struct scope *scope, const struct scope *parent)
 {
 	scope->parent = parent;
-	init_list_head(&scope->symbols);
 	return scope;
 }
 
@@ -189,6 +188,7 @@ struct chain *chain_alloc(const char *name)
 
 	chain = xzalloc(sizeof(*chain));
 	init_list_head(&chain->rules);
+	init_list_head(&chain->scope.symbols);
 	if (name != NULL)
 		chain->handle.chain = xstrdup(name);
 	return chain;
@@ -240,6 +240,7 @@ struct table *table_alloc(void)
 	table = xzalloc(sizeof(*table));
 	init_list_head(&table->chains);
 	init_list_head(&table->sets);
+	init_list_head(&table->scope.symbols);
 	return table;
 }
 
@@ -472,14 +473,20 @@ static int do_list_sets(struct netlink_ctx *ctx, const struct location *loc,
 
 static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 {
-	struct table *table;
-	struct chain *chain;
+	struct table *table = NULL;
+	struct chain *chain, *nchain;
 	struct rule *rule, *nrule;
 	struct set *set, *nset;
 
-	table = table_alloc();
-	handle_merge(&table->handle, &cmd->handle);
-	table_add_hash(table);
+	/* No need to allocate the table object when listing all tables */
+	if (cmd->handle.table != NULL) {
+		table = table_lookup(&cmd->handle);
+		if (table == NULL) {
+			table = table_alloc();
+			handle_merge(&table->handle, &cmd->handle);
+			table_add_hash(table);
+		}
+	}
 
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
@@ -546,6 +553,12 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	}
 
 	table_print(table);
+
+	list_for_each_entry_safe(chain, nchain, &table->chains, list) {
+		list_del(&chain->list);
+		chain_free(chain);
+	}
+
 	return 0;
 }
 
-- 
1.7.10.4

