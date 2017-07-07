From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft v4] include: Remove __init and __exit macro definitions.
Date: Sat, 8 Jul 2017 05:07:23 +0530
Message-ID: <59601b38.05c2620a.1b29f.4776@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35798 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751034AbdGGXhb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jul 2017 19:37:31 -0400
Received: by mail-pg0-f68.google.com with SMTP id d193so5603938pgc.2
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Jul 2017 16:37:30 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add nft_init and nft_exit functions, which calls _init and _exit
functions in main.c file. Remove __init and __exit macro definitions as
libnftables library will be created soon. Rename realm_table_init() and
realm_table_exit() functions to avoid ambiguity as
realm_table_rt_init(), realm_table_meta_init, realm_table_rt_exit() and
realm_table_meta_exit() in rt.c and meta.c files.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
Changes in v1:
- Called all __init functions in nft_init().

Changes in v2:
- Removed unnecessary init functions.

Changes in v3:
- Called __init functions in nft_int().
- Called __exit functions in nft_exit().
- Remove global declaration of struct mnl_socket *nf_sock.
- Modified commit message.
Changes in v4:
- Add struct mnl_socket as parameter to nft_netlink.
- Fix indentation

 include/cli.h      |  6 ++++--
 include/netlink.h  |  7 ++++---
 include/nftables.h | 19 +++++++++++++++++
 include/parser.h   |  5 ++++-
 include/rule.h     |  5 ++++-
 include/utils.h    |  2 --
 src/cli.c          |  9 ++++++--
 src/ct.c           |  4 ++--
 src/datatype.c     |  4 ++--
 src/evaluate.c     | 22 ++++++++++----------
 src/gmputil.c      |  2 +-
 src/main.c         | 43 +++++++++++++++++++++++++++++++-------
 src/meta.c         |  8 ++++----
 src/netlink.c      | 60 ++++++++++++++++++++++++++++--------------------------
 src/parser_bison.y |  4 +++-
 src/rt.c           |  4 ++--
 src/rule.c         | 13 +++++++-----
 src/xt.c           |  2 +-
 18 files changed, 143 insertions(+), 76 deletions(-)

diff --git a/include/cli.h b/include/cli.h
index 6894f9d..21052e3 100644
--- a/include/cli.h
+++ b/include/cli.h
@@ -5,9 +5,11 @@
 
 struct parser_state;
 #ifdef HAVE_LIBREADLINE
-extern int cli_init(struct nft_ctx *nft, struct parser_state *state);
+extern int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
+		    struct parser_state *state);
 #else
-static inline int cli_init(struct nft_ctx *nft, struct parser_state *state)
+static inline int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
+			   struct parser_state *state)
 {
         return -1;
 }
diff --git a/include/netlink.h b/include/netlink.h
index bb25ad4..5b43c5c 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -41,6 +41,7 @@ extern const struct location netlink_location;
  * @octx:	output context
  */
 struct netlink_ctx {
+	struct mnl_socket	*nf_sock;
 	struct list_head	*msgs;
 	struct list_head	list;
 	struct set		*set;
@@ -191,8 +192,8 @@ extern void netlink_dump_obj(struct nftnl_obj *nlo);
 
 extern int netlink_batch_send(struct netlink_ctx *ctx, struct list_head *err_list);
 
-extern void netlink_genid_get(void);
-extern void netlink_restart(void);
+extern void netlink_genid_get(struct mnl_socket *nf_sock);
+extern void netlink_restart(struct mnl_socket *nf_sock);
 #define netlink_abi_error()	\
 	__netlink_abi_error(__FILE__, __LINE__, strerror(errno));
 extern void __noreturn __netlink_abi_error(const char *file, int line, const char *reason);
@@ -218,6 +219,6 @@ struct netlink_mon_handler {
 };
 
 extern int netlink_monitor(struct netlink_mon_handler *monhandler);
-bool netlink_batch_supported(void);
+bool netlink_batch_supported(struct mnl_socket *nf_sock);
 
 #endif /* NFTABLES_NETLINK_H */
diff --git a/include/nftables.h b/include/nftables.h
index 26fd344..c37c470 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -34,6 +34,7 @@ struct output_ctx {
 struct nft_ctx {
 	struct output_ctx	output;
 	bool			check;
+	struct mnl_socket	*nf_sock;
 };
 
 extern unsigned int max_errors;
@@ -118,4 +119,22 @@ struct parser_state;
 int nft_run(struct nft_ctx *nft, void *scanner, struct parser_state *state,
 	    struct list_head *msgs);
 
+void ct_label_table_init(void);
+void mark_table_init(void);
+void gmp_init(void);
+void realm_table_rt_init(void);
+void devgroup_table_init(void);
+struct mnl_socket *netlink_open_sock(void);
+void realm_table_meta_init(void);
+void xt_init(void);
+void nft_init(void);
+
+void ct_label_table_exit(void);
+void mark_table_exit(void);
+void realm_table_meta_exit(void);
+void devgroup_table_exit(void);
+void netlink_close_sock(struct mnl_socket *nf_sock);
+void realm_table_rt_exit(void);
+void nft_exit(void);
+
 #endif /* NFTABLES_NFTABLES_H */
diff --git a/include/parser.h b/include/parser.h
index 92beab2..1815ea1 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -29,7 +29,10 @@ struct parser_state {
 	struct eval_ctx			ectx;
 };
 
-extern void parser_init(struct parser_state *state, struct list_head *msgs);
+struct mnl_socket;
+
+extern void parser_init(struct mnl_socket *nf_sock, struct parser_state *state,
+			struct list_head *msgs);
 extern int nft_parse(void *, struct parser_state *state);
 
 extern void *scanner_init(struct parser_state *state);
diff --git a/include/rule.h b/include/rule.h
index 7424b21..2da93b6 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -457,6 +457,7 @@ extern void cmd_free(struct cmd *cmd);
 /**
  * struct eval_ctx - evaluation context
  *
+ * @nf_sock:	netlink socket (for caching)
  * @msgs:	message queue
  * @cmd:	current command
  * @table:	current table
@@ -467,6 +468,7 @@ extern void cmd_free(struct cmd *cmd);
  * @pctx:	payload context
  */
 struct eval_ctx {
+	struct mnl_socket	*nf_sock;
 	struct list_head	*msgs;
 	struct cmd		*cmd;
 	struct table		*table;
@@ -484,7 +486,8 @@ extern struct error_record *rule_postprocess(struct rule *rule);
 struct netlink_ctx;
 extern int do_command(struct netlink_ctx *ctx, struct cmd *cmd);
 
-extern int cache_update(enum cmd_ops cmd, struct list_head *msgs);
+extern int cache_update(struct mnl_socket *nf_sock, enum cmd_ops cmd,
+			struct list_head *msgs);
 extern void cache_flush(void);
 extern void cache_release(void);
 
diff --git a/include/utils.h b/include/utils.h
index 3199388..0605eee 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -32,8 +32,6 @@
 #define __gmp_fmtstring(x, y)
 #endif
 
-#define __init			__attribute__((constructor))
-#define __exit			__attribute__((destructor))
 #define __must_check		__attribute__((warn_unused_result))
 #define __noreturn		__attribute__((__noreturn__))
 
diff --git a/src/cli.c b/src/cli.c
index 7cd2f45..0dbc5ed 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -31,6 +31,8 @@
 #include <iface.h>
 #include <cli.h>
 
+#include <libmnl/libmnl.h>
+
 #define CMDLINE_HISTFILE	".nft.history"
 
 static const struct input_descriptor indesc_cli = {
@@ -40,6 +42,7 @@ static const struct input_descriptor indesc_cli = {
 
 static struct parser_state *state;
 static struct nft_ctx cli_nft;
+static struct mnl_socket *cli_nf_sock;
 static void *scanner;
 
 static char histfile[PATH_MAX];
@@ -128,7 +131,7 @@ static void cli_complete(char *line)
 	xfree(line);
 	line = s;
 
-	parser_init(state, &msgs);
+	parser_init(cli_nf_sock, state, &msgs);
 	scanner_push_buffer(scanner, &indesc_cli, line);
 	nft_run(&cli_nft, scanner, state, &msgs);
 	erec_print_list(stdout, &msgs);
@@ -168,10 +171,12 @@ void __fmtstring(1, 0) cli_display(const char *fmt, va_list ap)
 	rl_forced_update_display();
 }
 
-int cli_init(struct nft_ctx *nft, struct parser_state *_state)
+int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
+	     struct parser_state *_state)
 {
 	const char *home;
 
+	cli_nf_sock = nf_sock;
 	cli_nft = *nft;
 	rl_readline_name = "nft";
 	rl_instream  = stdin;
diff --git a/src/ct.c b/src/ct.c
index 9b7140b..d64f467 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -205,12 +205,12 @@ static const struct datatype ct_label_type = {
 	.parse		= ct_label_type_parse,
 };
 
-static void __init ct_label_table_init(void)
+void ct_label_table_init(void)
 {
 	ct_label_tbl = rt_symbol_table_init(CONNLABEL_CONF);
 }
 
-static void __exit ct_label_table_exit(void)
+void ct_label_table_exit(void)
 {
 	rt_symbol_table_free(ct_label_tbl);
 }
diff --git a/src/datatype.c b/src/datatype.c
index 287ca00..5bd0c7b 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -719,12 +719,12 @@ void rt_symbol_table_free(struct symbol_table *tbl)
 }
 
 static struct symbol_table *mark_tbl;
-static void __init mark_table_init(void)
+void mark_table_init(void)
 {
 	mark_tbl = rt_symbol_table_init("/etc/iproute2/rt_marks");
 }
 
-static void __exit mark_table_exit(void)
+void mark_table_exit(void)
 {
 	rt_symbol_table_free(mark_tbl);
 }
diff --git a/src/evaluate.c b/src/evaluate.c
index ca8b63b..74a4097 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -181,7 +181,7 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 		new = expr_clone(sym->expr);
 		break;
 	case SYMBOL_SET:
-		ret = cache_update(ctx->cmd->op, ctx->msgs);
+		ret = cache_update(ctx->nf_sock, ctx->cmd->op, ctx->msgs);
 		if (ret < 0)
 			return ret;
 
@@ -2950,13 +2950,13 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 
 	switch (cmd->obj) {
 	case CMD_OBJ_SETELEM:
-		ret = cache_update(cmd->op, ctx->msgs);
+		ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
 		if (ret < 0)
 			return ret;
 
 		return setelem_evaluate(ctx, &cmd->expr);
 	case CMD_OBJ_SET:
-		ret = cache_update(cmd->op, ctx->msgs);
+		ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
 		if (ret < 0)
 			return ret;
 
@@ -2966,7 +2966,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 		handle_merge(&cmd->rule->handle, &cmd->handle);
 		return rule_evaluate(ctx, cmd->rule);
 	case CMD_OBJ_CHAIN:
-		ret = cache_update(cmd->op, ctx->msgs);
+		ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
 		if (ret < 0)
 			return ret;
 
@@ -2988,7 +2988,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 
 	switch (cmd->obj) {
 	case CMD_OBJ_SETELEM:
-		ret = cache_update(cmd->op, ctx->msgs);
+		ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
 		if (ret < 0)
 			return ret;
 
@@ -3030,7 +3030,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	struct set *set;
 	int ret;
 
-	ret = cache_update(cmd->op, ctx->msgs);
+	ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
 	if (ret < 0)
 		return ret;
 
@@ -3113,7 +3113,7 @@ static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	int ret;
 
-	ret = cache_update(cmd->op, ctx->msgs);
+	ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
 	if (ret < 0)
 		return ret;
 
@@ -3139,7 +3139,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 	struct set *set;
 	int ret;
 
-	ret = cache_update(cmd->op, ctx->msgs);
+	ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
 	if (ret < 0)
 		return ret;
 
@@ -3197,7 +3197,7 @@ static int cmd_evaluate_rename(struct eval_ctx *ctx, struct cmd *cmd)
 
 	switch (cmd->obj) {
 	case CMD_OBJ_CHAIN:
-		ret = cache_update(cmd->op, ctx->msgs);
+		ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
 		if (ret < 0)
 			return ret;
 
@@ -3283,7 +3283,7 @@ static int cmd_evaluate_monitor(struct eval_ctx *ctx, struct cmd *cmd)
 	uint32_t event;
 	int ret;
 
-	ret = cache_update(cmd->op, ctx->msgs);
+	ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
 	if (ret < 0)
 		return ret;
 
@@ -3306,7 +3306,7 @@ static int cmd_evaluate_monitor(struct eval_ctx *ctx, struct cmd *cmd)
 
 static int cmd_evaluate_export(struct eval_ctx *ctx, struct cmd *cmd)
 {
-	return cache_update(cmd->op, ctx->msgs);
+	return cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
 }
 
 #ifdef DEBUG
diff --git a/src/gmputil.c b/src/gmputil.c
index c763792..844ea61 100644
--- a/src/gmputil.c
+++ b/src/gmputil.c
@@ -207,7 +207,7 @@ static void *gmp_xrealloc(void *ptr, size_t old_size, size_t new_size)
 	return xrealloc(ptr, new_size);
 }
 
-static void __init gmp_init(void)
+void gmp_init(void)
 {
 	mp_set_memory_functions(xmalloc, gmp_xrealloc, NULL);
 }
diff --git a/src/main.c b/src/main.c
index 7fbf00a..ed21a67 100644
--- a/src/main.c
+++ b/src/main.c
@@ -182,7 +182,7 @@ static const struct input_descriptor indesc_cmdline = {
 };
 
 static int nft_netlink(struct nft_ctx *nft, struct parser_state *state,
-		       struct list_head *msgs)
+		       struct list_head *msgs, struct mnl_socket *nf_sock)
 {
 	struct nftnl_batch *batch;
 	struct netlink_ctx ctx;
@@ -190,7 +190,7 @@ static int nft_netlink(struct nft_ctx *nft, struct parser_state *state,
 	struct mnl_err *err, *tmp;
 	LIST_HEAD(err_list);
 	uint32_t batch_seqnum;
-	bool batch_supported = netlink_batch_supported();
+	bool batch_supported = netlink_batch_supported(nf_sock);
 	int ret = 0;
 
 	batch = mnl_batch_init();
@@ -203,6 +203,7 @@ static int nft_netlink(struct nft_ctx *nft, struct parser_state *state,
 		ctx.batch = batch;
 		ctx.batch_supported = batch_supported;
 		ctx.octx = &nft->output;
+		ctx.nf_sock = nf_sock;
 		init_list_head(&ctx.list);
 		ret = do_command(&ctx, cmd);
 		if (ret < 0)
@@ -252,7 +253,7 @@ int nft_run(struct nft_ctx *nft, void *scanner, struct parser_state *state,
 	list_for_each_entry(cmd, &state->cmds, list)
 		nft_cmd_expand(cmd);
 
-	ret = nft_netlink(nft, state, msgs);
+	ret = nft_netlink(nft, state, msgs, nft->nf_sock);
 err1:
 	list_for_each_entry_safe(cmd, next, &state->cmds, list) {
 		list_del(&cmd->list);
@@ -262,6 +263,28 @@ err1:
 	return ret;
 }
 
+void nft_init(void)
+{
+	mark_table_init();
+	realm_table_rt_init();
+	devgroup_table_init();
+	realm_table_meta_init();
+	ct_label_table_init();
+	gmp_init();
+#ifdef HAVE_LIBXTABLES
+	xt_init();
+#endif
+}
+
+void nft_exit(void)
+{
+	ct_label_table_exit();
+	realm_table_rt_exit();
+	devgroup_table_exit();
+	realm_table_meta_exit();
+	mark_table_exit();
+}
+
 int main(int argc, char * const *argv)
 {
 	struct parser_state state;
@@ -271,7 +294,11 @@ int main(int argc, char * const *argv)
 	unsigned int len;
 	bool interactive = false;
 	int i, val, rc = NFT_EXIT_SUCCESS;
+	struct mnl_socket *nf_sock;
 
+	nft_init();
+	nf_sock = netlink_open_sock();
+	nft.nf_sock = nf_sock;
 	while (1) {
 		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
 		if (val == -1)
@@ -365,20 +392,20 @@ int main(int argc, char * const *argv)
 				strcat(buf, " ");
 		}
 		strcat(buf, "\n");
-		parser_init(&state, &msgs);
+		parser_init(nf_sock, &state, &msgs);
 		scanner = scanner_init(&state);
 		scanner_push_buffer(scanner, &indesc_cmdline, buf);
 	} else if (filename != NULL) {
-		rc = cache_update(CMD_INVALID, &msgs);
+		rc = cache_update(nf_sock, CMD_INVALID, &msgs);
 		if (rc < 0)
 			return rc;
 
-		parser_init(&state, &msgs);
+		parser_init(nf_sock, &state, &msgs);
 		scanner = scanner_init(&state);
 		if (scanner_read_file(scanner, filename, &internal_location) < 0)
 			goto out;
 	} else if (interactive) {
-		if (cli_init(&nft, &state) < 0) {
+		if (cli_init(&nft, nf_sock, &state) < 0) {
 			fprintf(stderr, "%s: interactive CLI not supported in this build\n",
 				argv[0]);
 			exit(NFT_EXIT_FAILURE);
@@ -397,6 +424,8 @@ out:
 	xfree(buf);
 	cache_release();
 	iface_cache_release();
+	netlink_close_sock(nf_sock);
+	nft_exit();
 
 	return rc;
 }
diff --git a/src/meta.c b/src/meta.c
index e9334b8..9c80893 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -37,12 +37,12 @@
 #include <iface.h>
 
 static struct symbol_table *realm_tbl;
-static void __init realm_table_init(void)
+void realm_table_meta_init(void)
 {
 	realm_tbl = rt_symbol_table_init("/etc/iproute2/rt_realms");
 }
 
-static void __exit realm_table_exit(void)
+void realm_table_meta_exit(void)
 {
 	rt_symbol_table_free(realm_tbl);
 }
@@ -333,12 +333,12 @@ const struct datatype pkttype_type = {
 };
 
 static struct symbol_table *devgroup_tbl;
-static void __init devgroup_table_init(void)
+void devgroup_table_init(void)
 {
 	devgroup_tbl = rt_symbol_table_init("/etc/iproute2/group");
 }
 
-static void __exit devgroup_table_exit(void)
+void devgroup_table_exit(void)
 {
 	rt_symbol_table_free(devgroup_tbl);
 }
diff --git a/src/netlink.c b/src/netlink.c
index 880502c..026919a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -39,7 +39,6 @@
 #include <erec.h>
 #include <iface.h>
 
-static struct mnl_socket *nf_sock;
 static struct mnl_socket *nf_mon_sock;
 
 const struct input_descriptor indesc_netlink = {
@@ -61,13 +60,16 @@ static struct mnl_socket *nfsock_open(void)
 	return s;
 }
 
-static void __init netlink_open_sock(void)
+struct mnl_socket *netlink_open_sock(void)
 {
+	struct mnl_socket *nf_sock;
+
 	nf_sock = nfsock_open();
 	fcntl(mnl_socket_get_fd(nf_sock), F_SETFL, O_NONBLOCK);
+	return nf_sock;
 }
 
-static void __exit netlink_close_sock(void)
+void netlink_close_sock(struct mnl_socket *nf_sock)
 {
 	if (nf_sock)
 		mnl_socket_close(nf_sock);
@@ -75,13 +77,13 @@ static void __exit netlink_close_sock(void)
 		mnl_socket_close(nf_mon_sock);
 }
 
-void netlink_restart(void)
+void netlink_restart(struct mnl_socket *nf_sock)
 {
-	netlink_close_sock();
-	netlink_open_sock();
+	netlink_close_sock(nf_sock);
+	nf_sock = netlink_open_sock();
 }
 
-void netlink_genid_get(void)
+void netlink_genid_get(struct mnl_socket *nf_sock)
 {
 	mnl_genid_get(nf_sock);
 }
@@ -559,7 +561,7 @@ static int netlink_list_rules(struct netlink_ctx *ctx, const struct handle *h,
 {
 	struct nftnl_rule_list *rule_cache;
 
-	rule_cache = mnl_nft_rule_dump(nf_sock, h->family);
+	rule_cache = mnl_nft_rule_dump(ctx->nf_sock, h->family);
 	if (rule_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
@@ -616,7 +618,7 @@ static int netlink_add_chain_compat(struct netlink_ctx *ctx,
 	}
 
 	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_add(nf_sock, nlc, excl ? NLM_F_EXCL : 0);
+	err = mnl_nft_chain_add(ctx->nf_sock, nlc, excl ? NLM_F_EXCL : 0);
 	nftnl_chain_free(nlc);
 
 	if (err < 0)
@@ -683,7 +685,7 @@ static int netlink_rename_chain_compat(struct netlink_ctx *ctx,
 	nlc = alloc_nftnl_chain(h);
 	nftnl_chain_set_str(nlc, NFTNL_CHAIN_NAME, name);
 	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_add(nf_sock, nlc, 0);
+	err = mnl_nft_chain_add(ctx->nf_sock, nlc, 0);
 	nftnl_chain_free(nlc);
 
 	if (err < 0)
@@ -730,7 +732,7 @@ static int netlink_del_chain_compat(struct netlink_ctx *ctx,
 
 	nlc = alloc_nftnl_chain(h);
 	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_delete(nf_sock, nlc, 0);
+	err = mnl_nft_chain_delete(ctx->nf_sock, nlc, 0);
 	nftnl_chain_free(nlc);
 
 	if (err < 0)
@@ -833,7 +835,7 @@ int netlink_list_chains(struct netlink_ctx *ctx, const struct handle *h,
 	struct nftnl_chain_list *chain_cache;
 	struct chain *chain;
 
-	chain_cache = mnl_nft_chain_dump(nf_sock, h->family);
+	chain_cache = mnl_nft_chain_dump(ctx->nf_sock, h->family);
 	if (chain_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
@@ -869,7 +871,7 @@ int netlink_get_chain(struct netlink_ctx *ctx, const struct handle *h,
 	int err;
 
 	nlc = alloc_nftnl_chain(h);
-	err = mnl_nft_chain_get(nf_sock, nlc, 0);
+	err = mnl_nft_chain_get(ctx->nf_sock, nlc, 0);
 	if (err < 0) {
 		netlink_io_error(ctx, loc,
 				 "Could not receive chain from kernel: %s",
@@ -905,7 +907,7 @@ static int netlink_add_table_compat(struct netlink_ctx *ctx,
 	int err;
 
 	nlt = alloc_nftnl_table(h);
-	err = mnl_nft_table_add(nf_sock, nlt, excl ? NLM_F_EXCL : 0);
+	err = mnl_nft_table_add(ctx->nf_sock, nlt, excl ? NLM_F_EXCL : 0);
 	nftnl_table_free(nlt);
 
 	if (err < 0)
@@ -956,7 +958,7 @@ static int netlink_del_table_compat(struct netlink_ctx *ctx,
 	int err;
 
 	nlt = alloc_nftnl_table(h);
-	err = mnl_nft_table_delete(nf_sock, nlt, 0);
+	err = mnl_nft_table_delete(ctx->nf_sock, nlt, 0);
 	nftnl_table_free(nlt);
 
 	if (err < 0)
@@ -1033,7 +1035,7 @@ int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h,
 {
 	struct nftnl_table_list *table_cache;
 
-	table_cache = mnl_nft_table_dump(nf_sock, h->family);
+	table_cache = mnl_nft_table_dump(ctx->nf_sock, h->family);
 	if (table_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
@@ -1054,7 +1056,7 @@ int netlink_get_table(struct netlink_ctx *ctx, const struct handle *h,
 	int err;
 
 	nlt = alloc_nftnl_table(h);
-	err = mnl_nft_table_get(nf_sock, nlt, 0);
+	err = mnl_nft_table_get(ctx->nf_sock, nlt, 0);
 	if (err < 0) {
 		netlink_io_error(ctx, loc,
 				 "Could not receive table from kernel: %s",
@@ -1246,7 +1248,7 @@ static int netlink_add_set_compat(struct netlink_ctx *ctx,
 	}
 	netlink_dump_set(nls);
 
-	err = mnl_nft_set_add(nf_sock, nls, NLM_F_ECHO | flags);
+	err = mnl_nft_set_add(ctx->nf_sock, nls, NLM_F_ECHO | flags);
 	if (err < 0)
 		netlink_io_error(ctx, &set->location, "Could not add set: %s",
 				 strerror(errno));
@@ -1343,7 +1345,7 @@ static int netlink_del_set_compat(struct netlink_ctx *ctx,
 	int err;
 
 	nls = alloc_nftnl_set(h);
-	err = mnl_nft_set_delete(nf_sock, nls, 0);
+	err = mnl_nft_set_delete(ctx->nf_sock, nls, 0);
 	nftnl_set_free(nls);
 
 	if (err < 0)
@@ -1396,7 +1398,7 @@ int netlink_list_sets(struct netlink_ctx *ctx, const struct handle *h,
 	struct nftnl_set_list *set_cache;
 	int err;
 
-	set_cache = mnl_nft_set_dump(nf_sock, h->family, h->table);
+	set_cache = mnl_nft_set_dump(ctx->nf_sock, h->family, h->table);
 	if (set_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
@@ -1417,7 +1419,7 @@ int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
 	int err;
 
 	nls = alloc_nftnl_set(h);
-	err = mnl_nft_set_get(nf_sock, nls);
+	err = mnl_nft_set_get(ctx->nf_sock, nls);
 	if (err < 0) {
 		nftnl_set_free(nls);
 		return netlink_io_error(ctx, loc,
@@ -1477,7 +1479,7 @@ static int netlink_add_setelems_compat(struct netlink_ctx *ctx,
 	alloc_setelem_cache(expr, nls);
 	netlink_dump_set(nls);
 
-	err = mnl_nft_setelem_add(nf_sock, nls, excl ? NLM_F_EXCL : 0);
+	err = mnl_nft_setelem_add(ctx->nf_sock, nls, excl ? NLM_F_EXCL : 0);
 	nftnl_set_free(nls);
 	if (err < 0)
 		netlink_io_error(ctx, &expr->location,
@@ -1527,7 +1529,7 @@ static int netlink_del_setelems_compat(struct netlink_ctx *ctx,
 	alloc_setelem_cache(expr, nls);
 	netlink_dump_set(nls);
 
-	err = mnl_nft_setelem_delete(nf_sock, nls, 0);
+	err = mnl_nft_setelem_delete(ctx->nf_sock, nls, 0);
 	nftnl_set_free(nls);
 	if (err < 0)
 		netlink_io_error(ctx, &expr->location,
@@ -1722,7 +1724,7 @@ int netlink_get_setelems(struct netlink_ctx *ctx, const struct handle *h,
 
 	nls = alloc_nftnl_set(h);
 
-	err = mnl_nft_setelem_get(nf_sock, nls);
+	err = mnl_nft_setelem_get(ctx->nf_sock, nls);
 	if (err < 0) {
 		nftnl_set_free(nls);
 		if (errno == EINTR)
@@ -1861,7 +1863,7 @@ int netlink_list_objs(struct netlink_ctx *ctx, const struct handle *h,
 	struct nftnl_obj_list *obj_cache;
 	int err;
 
-	obj_cache = mnl_nft_obj_dump(nf_sock, h->family, h->table, NULL,
+	obj_cache = mnl_nft_obj_dump(ctx->nf_sock, h->family, h->table, NULL,
 				     0, true, false);
 	if (obj_cache == NULL) {
 		if (errno == EINTR)
@@ -1881,7 +1883,7 @@ int netlink_reset_objs(struct netlink_ctx *ctx, const struct handle *h,
 	struct nftnl_obj_list *obj_cache;
 	int err;
 
-	obj_cache = mnl_nft_obj_dump(nf_sock, h->family, h->table, h->obj,
+	obj_cache = mnl_nft_obj_dump(ctx->nf_sock, h->family, h->table, h->obj,
 				     type, dump, true);
 	if (obj_cache == NULL) {
 		if (errno == EINTR)
@@ -1899,7 +1901,7 @@ int netlink_reset_objs(struct netlink_ctx *ctx, const struct handle *h,
 
 int netlink_batch_send(struct netlink_ctx *ctx, struct list_head *err_list)
 {
-	return mnl_batch_talk(nf_sock, ctx->batch, err_list);
+	return mnl_batch_talk(ctx->nf_sock, ctx->batch, err_list);
 }
 
 int netlink_flush_ruleset(struct netlink_ctx *ctx, const struct handle *h,
@@ -1927,7 +1929,7 @@ struct nftnl_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
 {
 	struct nftnl_ruleset *rs;
 
-	rs = mnl_nft_ruleset_dump(nf_sock, h->family);
+	rs = mnl_nft_ruleset_dump(ctx->nf_sock, h->family);
 	if (rs == NULL) {
 		if (errno == EINTR)
 			return NULL;
@@ -2937,7 +2939,7 @@ int netlink_monitor(struct netlink_mon_handler *monhandler)
 				      monhandler);
 }
 
-bool netlink_batch_supported(void)
+bool netlink_batch_supported(struct mnl_socket *nf_sock)
 {
 	return mnl_batch_supported(nf_sock);
 }
diff --git a/src/parser_bison.y b/src/parser_bison.y
index a8448e1..dd5848c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -35,7 +35,8 @@
 
 #include "parser_bison.h"
 
-void parser_init(struct parser_state *state, struct list_head *msgs)
+void parser_init(struct mnl_socket *nf_sock, struct parser_state *state,
+		 struct list_head *msgs)
 {
 	memset(state, 0, sizeof(*state));
 	init_list_head(&state->cmds);
@@ -43,6 +44,7 @@ void parser_init(struct parser_state *state, struct list_head *msgs)
 	state->msgs = msgs;
 	state->scopes[0] = scope_init(&state->top_scope, NULL);
 	state->ectx.msgs = msgs;
+	state->ectx.nf_sock = nf_sock;
 }
 
 static void yyerror(struct location *loc, void *scanner,
diff --git a/src/rt.c b/src/rt.c
index 530ebe6..cd2d5a4 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -24,12 +24,12 @@
 #include <rule.h>
 
 static struct symbol_table *realm_tbl;
-static void __init realm_table_init(void)
+void realm_table_rt_init(void)
 {
 	realm_tbl = rt_symbol_table_init("/etc/iproute2/rt_realms");
 }
 
-static void __exit realm_table_exit(void)
+void realm_table_rt_exit(void)
 {
 	rt_symbol_table_free(realm_tbl);
 }
diff --git a/src/rule.c b/src/rule.c
index f65674c..d178ecb 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -122,7 +122,8 @@ static int cache_init_objects(struct netlink_ctx *ctx, enum cmd_ops cmd)
 	return 0;
 }
 
-static int cache_init(enum cmd_ops cmd, struct list_head *msgs)
+static int cache_init(struct mnl_socket *nf_sock, enum cmd_ops cmd,
+		      struct list_head *msgs)
 {
 	struct handle handle = {
 		.family = NFPROTO_UNSPEC,
@@ -132,6 +133,7 @@ static int cache_init(enum cmd_ops cmd, struct list_head *msgs)
 
 	memset(&ctx, 0, sizeof(ctx));
 	init_list_head(&ctx.list);
+	ctx.nf_sock = nf_sock;
 	ctx.msgs = msgs;
 
 	ret = cache_init_tables(&ctx, &handle);
@@ -146,19 +148,20 @@ static int cache_init(enum cmd_ops cmd, struct list_head *msgs)
 
 static bool cache_initialized;
 
-int cache_update(enum cmd_ops cmd, struct list_head *msgs)
+int cache_update(struct mnl_socket *nf_sock, enum cmd_ops cmd,
+		 struct list_head *msgs)
 {
 	int ret;
 
 	if (cache_initialized)
 		return 0;
 replay:
-	netlink_genid_get();
-	ret = cache_init(cmd, msgs);
+	netlink_genid_get(nf_sock);
+	ret = cache_init(nf_sock, cmd, msgs);
 	if (ret < 0) {
 		cache_release();
 		if (errno == EINTR) {
-			netlink_restart();
+			netlink_restart(nf_sock);
 			goto replay;
 		}
 		return -1;
diff --git a/src/xt.c b/src/xt.c
index e24b0af..9680f8e 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -351,7 +351,7 @@ static struct xtables_globals xt_nft_globals = {
 	.compat_rev		= nft_xt_compatible_revision,
 };
 
-static void __init xt_init(void)
+void xt_init(void)
 {
 	/* Default to IPv4, but this changes in runtime */
 	xtables_init_all(&xt_nft_globals, NFPROTO_IPV4);
-- 
2.9.4

