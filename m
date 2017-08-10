From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: place object cache in context structure
Date: Thu, 10 Aug 2017 11:12:15 +0200
Message-ID: <1502356335-26343-1-git-send-email-pablo@netfilter.org>
Cc: rvarsha016@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60670 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751361AbdHJJMd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2017 05:12:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 39F09D28D1
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2017 11:12:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1D1661B333E
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2017 11:12:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 92C2A35A3
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2017 11:12:13 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Place object cache in context structure, so this is not global anymore.
Another step towards libnftables.

Joint work with Varsha Rao.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cli.h             |  4 +--
 include/netlink.h         |  3 +++
 include/nftables.h        |  5 ++--
 include/parser.h          |  4 +--
 include/rule.h            | 16 ++++++-----
 src/cli.c                 | 11 ++++----
 src/evaluate.c            | 62 +++++++++++++++++++++++--------------------
 src/main.c                | 26 ++++++++++--------
 src/netlink.c             | 42 +++++++++++++++--------------
 src/netlink_delinearize.c |  5 ++--
 src/parser_bison.y        |  5 ++--
 src/rule.c                | 67 ++++++++++++++++++++++++-----------------------
 12 files changed, 137 insertions(+), 113 deletions(-)

diff --git a/include/cli.h b/include/cli.h
index 21052e32d121..8e376ba00a76 100644
--- a/include/cli.h
+++ b/include/cli.h
@@ -6,10 +6,10 @@
 struct parser_state;
 #ifdef HAVE_LIBREADLINE
 extern int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
-		    struct parser_state *state);
+		    struct list_head *cache, struct parser_state *state);
 #else
 static inline int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
-			   struct parser_state *state)
+			   struct list_head *cache, struct parser_state *state)
 {
         return -1;
 }
diff --git a/include/netlink.h b/include/netlink.h
index 7865186b6276..3d8612f1ac1e 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -50,6 +50,7 @@ struct netlink_ctx {
 	struct nftnl_batch	*batch;
 	bool			batch_supported;
 	struct output_ctx	*octx;
+	struct list_head	*cache;
 };
 
 extern struct nftnl_table *alloc_nftnl_table(const struct handle *h);
@@ -162,6 +163,7 @@ extern int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
 			   const struct location *loc);
 
 extern struct stmt *netlink_parse_set_expr(const struct set *set,
+					   const struct list_head *cache,
 					   const struct nftnl_expr *nle);
 
 extern int netlink_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
@@ -216,6 +218,7 @@ struct netlink_mon_handler {
 	struct netlink_ctx	*ctx;
 	const struct location	*loc;
 	bool			cache_needed;
+	struct list_head	*cache;
 };
 
 extern int netlink_monitor(struct netlink_mon_handler *monhandler,
diff --git a/include/nftables.h b/include/nftables.h
index 640d3c7e715d..a3989780c43b 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -116,8 +116,9 @@ struct input_descriptor {
 struct parser_state;
 struct mnl_socket;
 
-int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock, void *scanner,
-	    struct parser_state *state, struct list_head *msgs);
+int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
+	    struct list_head *cache, void *scanner, struct parser_state *state,
+	    struct list_head *msgs);
 
 void ct_label_table_init(void);
 void mark_table_init(void);
diff --git a/include/parser.h b/include/parser.h
index 1815ea1b3c7d..64dd0b991f3a 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -31,8 +31,8 @@ struct parser_state {
 
 struct mnl_socket;
 
-extern void parser_init(struct mnl_socket *nf_sock, struct parser_state *state,
-			struct list_head *msgs);
+extern void parser_init(struct mnl_socket *nf_sock, struct list_head *cache,
+			struct parser_state *state, struct list_head *msgs);
 extern int nft_parse(void *, struct parser_state *state);
 
 extern void *scanner_init(struct parser_state *state);
diff --git a/include/rule.h b/include/rule.h
index a0edda2fec83..b4b66089ca00 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -116,8 +116,9 @@ struct table {
 extern struct table *table_alloc(void);
 extern struct table *table_get(struct table *table);
 extern void table_free(struct table *table);
-extern void table_add_hash(struct table *table);
-extern struct table *table_lookup(const struct handle *h);
+extern void table_add_hash(struct table *table, struct list_head *cache);
+extern struct table *table_lookup(const struct handle *h,
+				  const struct list_head *cache);
 
 /**
  * enum chain_flags - chain flags
@@ -248,7 +249,7 @@ extern void set_free(struct set *set);
 extern void set_add_hash(struct set *set, struct table *table);
 extern struct set *set_lookup(const struct table *table, const char *name);
 extern struct set *set_lookup_global(uint32_t family, const char *table,
-				     const char *name);
+				     const char *name, struct list_head *cache);
 extern void set_print(const struct set *set, struct output_ctx *octx);
 extern void set_print_plain(const struct set *s, struct output_ctx *octx);
 
@@ -479,6 +480,7 @@ struct eval_ctx {
 	struct rule		*rule;
 	struct set		*set;
 	struct stmt		*stmt;
+	struct list_head	*cache;
 	struct expr_ctx		ectx;
 	struct proto_ctx	pctx;
 };
@@ -490,10 +492,10 @@ extern struct error_record *rule_postprocess(struct rule *rule);
 struct netlink_ctx;
 extern int do_command(struct netlink_ctx *ctx, struct cmd *cmd);
 
-extern int cache_update(struct mnl_socket *nf_sock, enum cmd_ops cmd,
-			struct list_head *msgs);
-extern void cache_flush(void);
-extern void cache_release(void);
+extern int cache_update(struct mnl_socket *nf_sock, struct list_head *cache,
+			 enum cmd_ops cmd, struct list_head *msgs);
+extern void cache_flush(struct list_head *table_list);
+extern void cache_release(struct list_head *table_list);
 
 enum udata_type {
 	UDATA_TYPE_COMMENT,
diff --git a/src/cli.c b/src/cli.c
index abb6bf3c84e9..c456d99af450 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -43,8 +43,8 @@ static const struct input_descriptor indesc_cli = {
 static struct parser_state *state;
 static struct nft_ctx cli_nft;
 static struct mnl_socket *cli_nf_sock;
+static struct list_head *cli_cache;
 static void *scanner;
-
 static char histfile[PATH_MAX];
 static char *multiline;
 static bool eof;
@@ -135,12 +135,12 @@ static void cli_complete(char *line)
 	xfree(line);
 	line = s;
 
-	parser_init(cli_nf_sock, state, &msgs);
+	parser_init(cli_nf_sock, cli_cache, state, &msgs);
 	scanner_push_buffer(scanner, &indesc_cli, line);
-	nft_run(&cli_nft, cli_nf_sock, scanner, state, &msgs);
+	nft_run(&cli_nft, cli_nf_sock, cli_cache, scanner, state, &msgs);
 	erec_print_list(stdout, &msgs);
 	xfree(line);
-	cache_release();
+	cache_release(cli_cache);
 	iface_cache_release();
 }
 
@@ -176,12 +176,13 @@ void __fmtstring(1, 0) cli_display(const char *fmt, va_list ap)
 }
 
 int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
-	     struct parser_state *_state)
+	     struct list_head *cache, struct parser_state *_state)
 {
 	const char *home;
 
 	cli_nf_sock = nf_sock;
 	cli_nft = *nft;
+	cli_cache = cache;
 	rl_readline_name = "nft";
 	rl_instream  = stdin;
 	rl_outstream = stdout;
diff --git a/src/evaluate.c b/src/evaluate.c
index d24526fef295..88127658b008 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -144,7 +144,7 @@ static struct table *table_lookup_global(struct eval_ctx *ctx)
 	if (ctx->table != NULL)
 		return ctx->table;
 
-	table = table_lookup(&ctx->cmd->handle);
+	table = table_lookup(&ctx->cmd->handle, ctx->cache);
 	if (table == NULL)
 		return NULL;
 
@@ -181,7 +181,8 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 		new = expr_clone(sym->expr);
 		break;
 	case SYMBOL_SET:
-		ret = cache_update(ctx->nf_sock, ctx->cmd->op, ctx->msgs);
+		ret = cache_update(ctx->nf_sock, ctx->cache, ctx->cmd->op,
+				   ctx->msgs);
 		if (ret < 0)
 			return ret;
 
@@ -2915,13 +2916,13 @@ static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 	struct chain *chain;
 	struct set *set;
 
-	if (table_lookup(&ctx->cmd->handle) == NULL) {
+	if (table_lookup(&ctx->cmd->handle, ctx->cache) == NULL) {
 		if (table == NULL) {
 			table = table_alloc();
 			handle_merge(&table->handle, &ctx->cmd->handle);
-			table_add_hash(table);
+			table_add_hash(table, ctx->cache);
 		} else {
-			table_add_hash(table_get(table));
+			table_add_hash(table_get(table), ctx->cache);
 		}
 	}
 
@@ -2949,13 +2950,15 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 
 	switch (cmd->obj) {
 	case CMD_OBJ_SETELEM:
-		ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
+		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
+				   ctx->msgs);
 		if (ret < 0)
 			return ret;
 
 		return setelem_evaluate(ctx, &cmd->expr);
 	case CMD_OBJ_SET:
-		ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
+		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
+				   ctx->msgs);
 		if (ret < 0)
 			return ret;
 
@@ -2965,7 +2968,8 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 		handle_merge(&cmd->rule->handle, &cmd->handle);
 		return rule_evaluate(ctx, cmd->rule);
 	case CMD_OBJ_CHAIN:
-		ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
+		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
+				   ctx->msgs);
 		if (ret < 0)
 			return ret;
 
@@ -2987,7 +2991,8 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 
 	switch (cmd->obj) {
 	case CMD_OBJ_SETELEM:
-		ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
+		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
+				   ctx->msgs);
 		if (ret < 0)
 			return ret;
 
@@ -3013,7 +3018,7 @@ static int cmd_evaluate_list_obj(struct eval_ctx *ctx, const struct cmd *cmd,
 	if (obj_type == NFT_OBJECT_UNSPEC)
 		obj_type = NFT_OBJECT_COUNTER;
 
-	table = table_lookup(&cmd->handle);
+	table = table_lookup(&cmd->handle, ctx->cache);
 	if (table == NULL)
 		return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 				 cmd->handle.table);
@@ -3029,7 +3034,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	struct set *set;
 	int ret;
 
-	ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
+	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs);
 	if (ret < 0)
 		return ret;
 
@@ -3038,13 +3043,13 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		if (cmd->handle.table == NULL)
 			return 0;
 
-		table = table_lookup(&cmd->handle);
+		table = table_lookup(&cmd->handle, ctx->cache);
 		if (table == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 					 cmd->handle.table);
 		return 0;
 	case CMD_OBJ_SET:
-		table = table_lookup(&cmd->handle);
+		table = table_lookup(&cmd->handle, ctx->cache);
 		if (table == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 					 cmd->handle.table);
@@ -3054,7 +3059,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 					 cmd->handle.set);
 		return 0;
 	case CMD_OBJ_FLOWTABLE:
-		table = table_lookup(&cmd->handle);
+		table = table_lookup(&cmd->handle, ctx->cache);
 		if (table == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 					 cmd->handle.table);
@@ -3064,7 +3069,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 					 cmd->handle.set);
 		return 0;
 	case CMD_OBJ_MAP:
-		table = table_lookup(&cmd->handle);
+		table = table_lookup(&cmd->handle, ctx->cache);
 		if (table == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 					 cmd->handle.table);
@@ -3074,7 +3079,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 					 cmd->handle.set);
 		return 0;
 	case CMD_OBJ_CHAIN:
-		table = table_lookup(&cmd->handle);
+		table = table_lookup(&cmd->handle, ctx->cache);
 		if (table == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 					 cmd->handle.table);
@@ -3094,7 +3099,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SETS:
 		if (cmd->handle.table == NULL)
 			return 0;
-		if (table_lookup(&cmd->handle) == NULL)
+		if (table_lookup(&cmd->handle, ctx->cache) == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 					 cmd->handle.table);
 		return 0;
@@ -3112,7 +3117,7 @@ static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	int ret;
 
-	ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
+	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs);
 	if (ret < 0)
 		return ret;
 
@@ -3123,7 +3128,7 @@ static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_QUOTAS:
 		if (cmd->handle.table == NULL)
 			return 0;
-		if (table_lookup(&cmd->handle) == NULL)
+		if (table_lookup(&cmd->handle, ctx->cache) == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 					 cmd->handle.table);
 		return 0;
@@ -3138,13 +3143,13 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 	struct set *set;
 	int ret;
 
-	ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
+	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs);
 	if (ret < 0)
 		return ret;
 
 	switch (cmd->obj) {
 	case CMD_OBJ_RULESET:
-		cache_flush();
+		cache_flush(ctx->cache);
 		break;
 	case CMD_OBJ_TABLE:
 		/* Flushing a table does not empty the sets in the table nor remove
@@ -3154,7 +3159,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 		/* Chains don't hold sets */
 		break;
 	case CMD_OBJ_SET:
-		table = table_lookup(&cmd->handle);
+		table = table_lookup(&cmd->handle, ctx->cache);
 		if (table == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 					 cmd->handle.table);
@@ -3164,7 +3169,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 					 cmd->handle.set);
 		return 0;
 	case CMD_OBJ_MAP:
-		table = table_lookup(&cmd->handle);
+		table = table_lookup(&cmd->handle, ctx->cache);
 		if (table == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 					 cmd->handle.table);
@@ -3174,7 +3179,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 					 cmd->handle.set);
 		return 0;
 	case CMD_OBJ_FLOWTABLE:
-		table = table_lookup(&cmd->handle);
+		table = table_lookup(&cmd->handle, ctx->cache);
 		if (table == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 					 cmd->handle.table);
@@ -3196,11 +3201,12 @@ static int cmd_evaluate_rename(struct eval_ctx *ctx, struct cmd *cmd)
 
 	switch (cmd->obj) {
 	case CMD_OBJ_CHAIN:
-		ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
+		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
+				   ctx->msgs);
 		if (ret < 0)
 			return ret;
 
-		table = table_lookup(&ctx->cmd->handle);
+		table = table_lookup(&ctx->cmd->handle, ctx->cache);
 		if (table == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 					 ctx->cmd->handle.table);
@@ -3293,7 +3299,7 @@ static int cmd_evaluate_monitor(struct eval_ctx *ctx, struct cmd *cmd)
 	uint32_t event;
 	int ret;
 
-	ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
+	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs);
 	if (ret < 0)
 		return ret;
 
@@ -3314,7 +3320,7 @@ static int cmd_evaluate_monitor(struct eval_ctx *ctx, struct cmd *cmd)
 
 static int cmd_evaluate_export(struct eval_ctx *ctx, struct cmd *cmd)
 {
-	return cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
+	return cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs);
 }
 
 #ifdef DEBUG
diff --git a/src/main.c b/src/main.c
index 1535153ec815..164e77d4aa96 100644
--- a/src/main.c
+++ b/src/main.c
@@ -181,8 +181,9 @@ static const struct input_descriptor indesc_cmdline = {
 	.name	= "<cmdline>",
 };
 
-static int nft_netlink(struct nft_ctx *nft, struct parser_state *state,
-		       struct list_head *msgs, struct mnl_socket *nf_sock)
+static int nft_netlink(struct nft_ctx *nft, struct list_head *cache,
+		       struct parser_state *state, struct list_head *msgs,
+		       struct mnl_socket *nf_sock)
 {
 	struct nftnl_batch *batch;
 	struct netlink_ctx ctx;
@@ -204,6 +205,7 @@ static int nft_netlink(struct nft_ctx *nft, struct parser_state *state,
 		ctx.batch_supported = batch_supported;
 		ctx.octx = &nft->output;
 		ctx.nf_sock = nf_sock;
+		ctx.cache = cache;
 		init_list_head(&ctx.list);
 		ret = do_command(&ctx, cmd);
 		if (ret < 0)
@@ -238,8 +240,9 @@ out:
 	return ret;
 }
 
-int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock, void *scanner,
-	    struct parser_state *state, struct list_head *msgs)
+int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
+	    struct list_head *cache, void *scanner, struct parser_state *state,
+	    struct list_head *msgs)
 {
 	struct cmd *cmd, *next;
 	int ret;
@@ -253,7 +256,7 @@ int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock, void *scanner,
 	list_for_each_entry(cmd, &state->cmds, list)
 		nft_cmd_expand(cmd);
 
-	ret = nft_netlink(nft, state, msgs, nf_sock);
+	ret = nft_netlink(nft, cache, state, msgs, nf_sock);
 err1:
 	list_for_each_entry_safe(cmd, next, &state->cmds, list) {
 		list_del(&cmd->list);
@@ -289,6 +292,7 @@ int main(int argc, char * const *argv)
 {
 	struct parser_state state;
 	void *scanner;
+	LIST_HEAD(cache);
 	LIST_HEAD(msgs);
 	char *buf = NULL, *filename = NULL;
 	unsigned int len;
@@ -391,20 +395,20 @@ int main(int argc, char * const *argv)
 				strcat(buf, " ");
 		}
 		strcat(buf, "\n");
-		parser_init(nf_sock, &state, &msgs);
+		parser_init(nf_sock, &cache, &state, &msgs);
 		scanner = scanner_init(&state);
 		scanner_push_buffer(scanner, &indesc_cmdline, buf);
 	} else if (filename != NULL) {
-		rc = cache_update(nf_sock, CMD_INVALID, &msgs);
+		rc = cache_update(nf_sock, &cache, CMD_INVALID, &msgs);
 		if (rc < 0)
 			return rc;
 
-		parser_init(nf_sock, &state, &msgs);
+		parser_init(nf_sock, &cache, &state, &msgs);
 		scanner = scanner_init(&state);
 		if (scanner_read_file(scanner, filename, &internal_location) < 0)
 			goto out;
 	} else if (interactive) {
-		if (cli_init(&nft, nf_sock, &state) < 0) {
+		if (cli_init(&nft, nf_sock, &cache, &state) < 0) {
 			fprintf(stderr, "%s: interactive CLI not supported in this build\n",
 				argv[0]);
 			exit(NFT_EXIT_FAILURE);
@@ -415,13 +419,13 @@ int main(int argc, char * const *argv)
 		exit(NFT_EXIT_FAILURE);
 	}
 
-	if (nft_run(&nft, nf_sock, scanner, &state, &msgs) != 0)
+	if (nft_run(&nft, nf_sock, &cache, scanner, &state, &msgs) != 0)
 		rc = NFT_EXIT_FAILURE;
 out:
 	scanner_destroy(scanner);
 	erec_print_list(stderr, &msgs);
 	xfree(buf);
-	cache_release();
+	cache_release(&cache);
 	iface_cache_release();
 	netlink_close_sock(nf_sock);
 	nft_exit();
diff --git a/src/netlink.c b/src/netlink.c
index ffdadfb19a4a..4993deafa630 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1628,7 +1628,8 @@ static void set_elem_parse_udata(struct nftnl_set_elem *nlse,
 }
 
 static int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
-				       const struct set *set)
+				       const struct set *set,
+				       struct list_head *cache)
 {
 	struct nft_data_delinearize nld;
 	struct expr *expr, *key, *data;
@@ -1664,7 +1665,7 @@ static int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 		const struct nftnl_expr *nle;
 
 		nle = nftnl_set_elem_get(nlse, NFTNL_SET_ELEM_EXPR, NULL);
-		expr->stmt = netlink_parse_set_expr(set, nle);
+		expr->stmt = netlink_parse_set_expr(set, cache, nle);
 	}
 	if (flags & NFT_SET_ELEM_INTERVAL_END)
 		expr->flags |= EXPR_F_INTERVAL_END;
@@ -1717,7 +1718,7 @@ int netlink_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
 static int list_setelem_cb(struct nftnl_set_elem *nlse, void *arg)
 {
 	struct netlink_ctx *ctx = arg;
-	return netlink_delinearize_setelem(nlse, ctx->set);
+	return netlink_delinearize_setelem(nlse, ctx->set, ctx->cache);
 }
 
 int netlink_get_setelems(struct netlink_ctx *ctx, const struct handle *h,
@@ -2043,7 +2044,7 @@ static uint32_t netlink_msg2nftnl_of(uint32_t msg)
 
 static void nlr_for_each_set(struct nftnl_rule *nlr,
 			     void (*cb)(struct set *s, void *data),
-			     void *data)
+			     void *data, struct list_head *cache)
 {
 	struct nftnl_expr_iter *nlrei;
 	struct nftnl_expr *nlre;
@@ -2066,7 +2067,7 @@ static void nlr_for_each_set(struct nftnl_rule *nlr,
 			goto next;
 
 		set_name = nftnl_expr_get_str(nlre, NFTNL_EXPR_LOOKUP_SET);
-		s = set_lookup_global(family, table, set_name);
+		s = set_lookup_global(family, table, set_name, cache);
 		if (s == NULL)
 			goto next;
 
@@ -2275,7 +2276,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 	setname = nftnl_set_get_str(nls, NFTNL_SET_NAME);
 	family = nftnl_set_get_u32(nls, NFTNL_SET_FAMILY);
 
-	set = set_lookup_global(family, table, setname);
+	set = set_lookup_global(family, table, setname, monh->cache);
 	if (set == NULL) {
 		fprintf(stderr, "W: Received event for an unknown set.");
 		goto out;
@@ -2307,7 +2308,8 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 				nftnl_set_elems_iter_destroy(nlsei);
 				goto out;
 			}
-			if (netlink_delinearize_setelem(nlse, dummyset) < 0) {
+			if (netlink_delinearize_setelem(nlse, dummyset,
+							monh->cache) < 0) {
 				set_free(dummyset);
 				nftnl_set_elems_iter_destroy(nlsei);
 				goto out;
@@ -2424,7 +2426,8 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 		switch (type) {
 		case NFT_MSG_NEWRULE:
 			r = netlink_delinearize_rule(monh->ctx, nlr);
-			nlr_for_each_set(nlr, rule_map_decompose_cb, NULL);
+			nlr_for_each_set(nlr, rule_map_decompose_cb, NULL,
+					 monh->cache);
 
 			printf("add rule %s %s %s ", family, table, chain);
 			rule_print(r, monh->ctx->octx);
@@ -2460,7 +2463,7 @@ static void netlink_events_cache_addtable(struct netlink_mon_handler *monh,
 	t = netlink_delinearize_table(monh->ctx, nlt);
 	nftnl_table_free(nlt);
 
-	table_add_hash(t);
+	table_add_hash(t, monh->cache);
 }
 
 static void netlink_events_cache_deltable(struct netlink_mon_handler *monh,
@@ -2474,7 +2477,7 @@ static void netlink_events_cache_deltable(struct netlink_mon_handler *monh,
 	h.family = nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY);
 	h.table  = nftnl_table_get_str(nlt, NFTNL_TABLE_NAME);
 
-	t = table_lookup(&h);
+	t = table_lookup(&h, monh->cache);
 	if (t == NULL)
 		goto out;
 
@@ -2504,7 +2507,7 @@ static void netlink_events_cache_addset(struct netlink_mon_handler *monh,
 		goto out;
 	s->init = set_expr_alloc(monh->loc, s);
 
-	t = table_lookup(&s->handle);
+	t = table_lookup(&s->handle, monh->cache);
 	if (t == NULL) {
 		fprintf(stderr, "W: Unable to cache set: table not found.\n");
 		set_free(s);
@@ -2531,7 +2534,7 @@ static void netlink_events_cache_addsetelem(struct netlink_mon_handler *monh,
 	table   = nftnl_set_get_str(nls, NFTNL_SET_TABLE);
 	setname = nftnl_set_get_str(nls, NFTNL_SET_NAME);
 
-	set = set_lookup_global(family, table, setname);
+	set = set_lookup_global(family, table, setname, monh->cache);
 	if (set == NULL) {
 		fprintf(stderr,
 			"W: Unable to cache set_elem. Set not found.\n");
@@ -2544,7 +2547,7 @@ static void netlink_events_cache_addsetelem(struct netlink_mon_handler *monh,
 
 	nlse = nftnl_set_elems_iter_next(nlsei);
 	while (nlse != NULL) {
-		if (netlink_delinearize_setelem(nlse, set) < 0) {
+		if (netlink_delinearize_setelem(nlse, set, monh->cache) < 0) {
 			fprintf(stderr,
 				"W: Unable to cache set_elem. "
 				"Delinearize failed.\n");
@@ -2570,7 +2573,8 @@ static void netlink_events_cache_delsets(struct netlink_mon_handler *monh,
 {
 	struct nftnl_rule *nlr = netlink_rule_alloc(nlh);
 
-	nlr_for_each_set(nlr, netlink_events_cache_delset_cb, NULL);
+	nlr_for_each_set(nlr, netlink_events_cache_delset_cb, NULL,
+			 monh->cache);
 	nftnl_rule_free(nlr);
 }
 
@@ -2593,7 +2597,7 @@ static void netlink_events_cache_addobj(struct netlink_mon_handler *monh,
 	if (obj == NULL)
 		goto out;
 
-	t = table_lookup(&obj->handle);
+	t = table_lookup(&obj->handle, monh->cache);
 	if (t == NULL) {
 		fprintf(stderr, "W: Unable to cache object: table not found.\n");
 		obj_free(obj);
@@ -2622,7 +2626,7 @@ static void netlink_events_cache_delobj(struct netlink_mon_handler *monh,
 	name     = nftnl_obj_get_str(nlo, NFTNL_OBJ_NAME);
 	type	 = nftnl_obj_get_u32(nlo, NFTNL_OBJ_TYPE);
 
-	t = table_lookup(&h);
+	t = table_lookup(&h, monh->cache);
 	if (t == NULL) {
 		fprintf(stderr, "W: Unable to cache object: table not found.\n");
 		goto out;
@@ -2718,7 +2722,7 @@ static void trace_print_verdict(const struct nftnl_trace *nlt,
 }
 
 static void trace_print_rule(const struct nftnl_trace *nlt,
-			      struct output_ctx *octx)
+			      struct output_ctx *octx, struct list_head *cache)
 {
 	const struct table *table;
 	uint64_t rule_handle;
@@ -2733,7 +2737,7 @@ static void trace_print_rule(const struct nftnl_trace *nlt,
 	if (!h.table)
 		return;
 
-	table = table_lookup(&h);
+	table = table_lookup(&h, cache);
 	if (!table)
 		return;
 
@@ -2925,7 +2929,7 @@ static int netlink_events_trace_cb(const struct nlmsghdr *nlh, int type,
 			trace_print_packet(nlt, monh->ctx->octx);
 
 		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_RULE_HANDLE))
-			trace_print_rule(nlt, monh->ctx->octx);
+			trace_print_rule(nlt, monh->ctx->octx, monh->cache);
 		break;
 	case NFT_TRACETYPE_POLICY:
 	case NFT_TRACETYPE_RETURN:
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 3ee07c0a1306..fb02649e740d 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1275,12 +1275,13 @@ static int netlink_parse_rule_expr(struct nftnl_expr *nle, void *arg)
 }
 
 struct stmt *netlink_parse_set_expr(const struct set *set,
+				    const struct list_head *cache,
 				    const struct nftnl_expr *nle)
 {
 	struct netlink_parse_ctx ctx, *pctx = &ctx;
 
 	pctx->rule = rule_alloc(&netlink_location, &set->handle);
-	pctx->table = table_lookup(&set->handle);
+	pctx->table = table_lookup(&set->handle, cache);
 	assert(pctx->table != NULL);
 
 	if (netlink_parse_expr(nle, pctx) < 0)
@@ -2306,7 +2307,7 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 		h.position.id = nftnl_rule_get_u64(nlr, NFTNL_RULE_POSITION);
 
 	pctx->rule = rule_alloc(&netlink_location, &h);
-	pctx->table = table_lookup(&h);
+	pctx->table = table_lookup(&h, ctx->cache);
 	assert(pctx->table != NULL);
 
 	if (nftnl_rule_is_set(nlr, NFTNL_RULE_USERDATA)) {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index e7bb9097929b..18e2ba9d0205 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -35,14 +35,15 @@
 
 #include "parser_bison.h"
 
-void parser_init(struct mnl_socket *nf_sock, struct parser_state *state,
-		 struct list_head *msgs)
+void parser_init(struct mnl_socket *nf_sock, struct list_head *cache,
+		 struct parser_state *state, struct list_head *msgs)
 {
 	memset(state, 0, sizeof(*state));
 	init_list_head(&state->cmds);
 	init_list_head(&state->top_scope.symbols);
 	state->msgs = msgs;
 	state->scopes[0] = scope_init(&state->top_scope, NULL);
+	state->ectx.cache = cache;
 	state->ectx.msgs = msgs;
 	state->ectx.nf_sock = nf_sock;
 }
diff --git a/src/rule.c b/src/rule.c
index 12714ed3ccc7..8108793b2cba 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -53,9 +53,8 @@ void handle_merge(struct handle *dst, const struct handle *src)
 		dst->position = src->position;
 }
 
-static LIST_HEAD(table_list);
-
-static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h)
+static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h,
+			     struct list_head *cache)
 {
 	int ret;
 
@@ -63,7 +62,7 @@ static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h)
 	if (ret < 0)
 		return -1;
 
-	list_splice_tail_init(&ctx->list, &table_list);
+	list_splice_tail_init(&ctx->list, cache);
 	return 0;
 }
 
@@ -75,7 +74,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, enum cmd_ops cmd)
 	struct set *set;
 	int ret;
 
-	list_for_each_entry(table, &table_list, list) {
+	list_for_each_entry(table, ctx->cache, list) {
 		ret = netlink_list_sets(ctx, &table->handle,
 					&internal_location);
 		list_splice_tail_init(&ctx->list, &table->sets);
@@ -122,8 +121,8 @@ static int cache_init_objects(struct netlink_ctx *ctx, enum cmd_ops cmd)
 	return 0;
 }
 
-static int cache_init(struct mnl_socket *nf_sock, enum cmd_ops cmd,
-		      struct list_head *msgs)
+static int cache_init(struct mnl_socket *nf_sock, struct list_head *cache,
+		      enum cmd_ops cmd, struct list_head *msgs)
 {
 	struct handle handle = {
 		.family = NFPROTO_UNSPEC,
@@ -134,9 +133,10 @@ static int cache_init(struct mnl_socket *nf_sock, enum cmd_ops cmd,
 	memset(&ctx, 0, sizeof(ctx));
 	init_list_head(&ctx.list);
 	ctx.nf_sock = nf_sock;
+	ctx.cache = cache;
 	ctx.msgs = msgs;
 
-	ret = cache_init_tables(&ctx, &handle);
+	ret = cache_init_tables(&ctx, &handle, cache);
 	if (ret < 0)
 		return ret;
 	ret = cache_init_objects(&ctx, cmd);
@@ -148,8 +148,8 @@ static int cache_init(struct mnl_socket *nf_sock, enum cmd_ops cmd,
 
 static bool cache_initialized;
 
-int cache_update(struct mnl_socket *nf_sock, enum cmd_ops cmd,
-		 struct list_head *msgs)
+int cache_update(struct mnl_socket *nf_sock, struct list_head *cache,
+		 enum cmd_ops cmd, struct list_head *msgs)
 {
 	int ret;
 
@@ -157,9 +157,9 @@ int cache_update(struct mnl_socket *nf_sock, enum cmd_ops cmd,
 		return 0;
 replay:
 	netlink_genid_get(nf_sock);
-	ret = cache_init(nf_sock, cmd, msgs);
+	ret = cache_init(nf_sock, cache, cmd, msgs);
 	if (ret < 0) {
-		cache_release();
+		cache_release(cache);
 		if (errno == EINTR) {
 			netlink_restart(nf_sock);
 			goto replay;
@@ -170,19 +170,19 @@ replay:
 	return 0;
 }
 
-void cache_flush(void)
+void cache_flush(struct list_head *cache)
 {
 	struct table *table, *next;
 
-	list_for_each_entry_safe(table, next, &table_list, list) {
+	list_for_each_entry_safe(table, next, cache, list) {
 		list_del(&table->list);
 		table_free(table);
 	}
 }
 
-void cache_release(void)
+void cache_release(struct list_head *cache)
 {
-	cache_flush();
+	cache_flush(cache);
 	cache_initialized = false;
 }
 
@@ -236,7 +236,7 @@ struct set *set_lookup(const struct table *table, const char *name)
 }
 
 struct set *set_lookup_global(uint32_t family, const char *table,
-			      const char *name)
+			      const char *name, struct list_head *cache)
 {
 	struct handle h;
 	struct table *t;
@@ -244,7 +244,7 @@ struct set *set_lookup_global(uint32_t family, const char *table,
 	h.family = family;
 	h.table = table;
 
-	t = table_lookup(&h);
+	t = table_lookup(&h, cache);
 	if (t == NULL)
 		return NULL;
 
@@ -745,16 +745,17 @@ struct table *table_get(struct table *table)
 	return table;
 }
 
-void table_add_hash(struct table *table)
+void table_add_hash(struct table *table, struct list_head *cache)
 {
-	list_add_tail(&table->list, &table_list);
+	list_add_tail(&table->list, cache);
 }
 
-struct table *table_lookup(const struct handle *h)
+struct table *table_lookup(const struct handle *h,
+			   const struct list_head *cache)
 {
 	struct table *table;
 
-	list_for_each_entry(table, &table_list, list) {
+	list_for_each_entry(table, cache, list) {
 		if (table->handle.family == h->family &&
 		    !strcmp(table->handle.table, h->table))
 			return table;
@@ -987,7 +988,7 @@ static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	struct table *table;
 	struct set *set;
 
-	table = table_lookup(h);
+	table = table_lookup(h, ctx->cache);
 	set = set_lookup(table, h->set);
 
 	if (set->flags & NFT_SET_INTERVAL &&
@@ -1070,7 +1071,7 @@ static int do_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	struct table *table;
 	struct set *set;
 
-	table = table_lookup(h);
+	table = table_lookup(h, ctx->cache);
 	set = set_lookup(table, h->set);
 
 	if (set->flags & NFT_SET_INTERVAL &&
@@ -1145,7 +1146,7 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct table *table;
 	struct set *set;
 
-	list_for_each_entry(table, &table_list, list) {
+	list_for_each_entry(table, ctx->cache, list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -1348,7 +1349,7 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
 	struct table *table;
 	struct obj *obj;
 
-	list_for_each_entry(table, &table_list, list) {
+	list_for_each_entry(table, ctx->cache, list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -1382,7 +1383,7 @@ static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
 	unsigned int family = cmd->handle.family;
 	struct table *table;
 
-	list_for_each_entry(table, &table_list, list) {
+	list_for_each_entry(table, ctx->cache, list) {
 		if (family != NFPROTO_UNSPEC &&
 		    table->handle.family != family)
 			continue;
@@ -1403,7 +1404,7 @@ static int do_list_tables(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
 
-	list_for_each_entry(table, &table_list, list) {
+	list_for_each_entry(table, ctx->cache, list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -1448,7 +1449,7 @@ static int do_list_chains(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct table *table;
 	struct chain *chain;
 
-	list_for_each_entry(table, &table_list, list) {
+	list_for_each_entry(table, ctx->cache, list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -1486,7 +1487,7 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct table *table = NULL;
 
 	if (cmd->handle.table != NULL)
-		table = table_lookup(&cmd->handle);
+		table = table_lookup(&cmd->handle, ctx->cache);
 
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
@@ -1552,7 +1553,7 @@ static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd)
 
 	ret = netlink_reset_objs(ctx, &cmd->handle, &cmd->location, type, dump);
 	list_for_each_entry_safe(obj, next, &ctx->list, list) {
-		table = table_lookup(&obj->handle);
+		table = table_lookup(&obj->handle, ctx->cache);
 		list_move(&obj->list, &table->objs);
 	}
 	if (ret < 0)
@@ -1583,7 +1584,7 @@ static int do_command_flush(struct netlink_ctx *ctx, struct cmd *cmd)
 
 static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 {
-	struct table *table = table_lookup(&cmd->handle);
+	struct table *table = table_lookup(&cmd->handle, ctx->cache);
 	struct chain *chain;
 
 	switch (cmd->obj) {
@@ -1627,7 +1628,7 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 		struct chain *chain;
 		int ret;
 
-		list_for_each_entry(t, &table_list, list) {
+		list_for_each_entry(t, ctx->cache, list) {
 			list_for_each_entry(s, &t->sets, list)
 				s->init = set_expr_alloc(&cmd->location, s);
 
-- 
2.1.4

