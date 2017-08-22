From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 6/6] src: add debugging mask to context structure
Date: Tue, 22 Aug 2017 19:05:11 +0200
Message-ID: <1503421511-17814-7-git-send-email-pablo@netfilter.org>
References: <1503421511-17814-1-git-send-email-pablo@netfilter.org>
Cc: phil@nwl.cc, eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41020 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751825AbdHVRFj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2017 13:05:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8BAD7D25FC
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2017 19:05:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6CF9AA7F48
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2017 19:05:22 +0200 (CEST)
In-Reply-To: <1503421511-17814-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So this toggle is not global anymore. Update name that fits better with
the semantics of this variable.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/erec.h            |  6 ++--
 include/expression.h      |  3 +-
 include/mnl.h             |  3 +-
 include/netlink.h         | 18 ++++++++----
 include/nftables.h        |  3 +-
 include/parser.h          |  3 +-
 include/proto.h           |  5 +++-
 include/rule.h            |  4 ++-
 src/cli.c                 |  5 ++--
 src/erec.c                |  9 +++---
 src/evaluate.c            | 43 ++++++++++++++++------------
 src/main.c                | 13 +++++----
 src/mnl.c                 | 12 ++++----
 src/netlink.c             | 72 +++++++++++++++++++++++++----------------------
 src/netlink_delinearize.c |  3 +-
 src/netlink_linearize.c   |  2 +-
 src/parser_bison.y        |  8 ++++--
 src/proto.c               | 14 +++++----
 src/rule.c                | 23 ++++++++-------
 src/segtree.c             | 27 ++++++++++--------
 20 files changed, 161 insertions(+), 115 deletions(-)

diff --git a/include/erec.h b/include/erec.h
index 36e0efa4fc1d..223cb12d826a 100644
--- a/include/erec.h
+++ b/include/erec.h
@@ -58,8 +58,10 @@ static inline void erec_queue(struct error_record *erec,
 	list_add_tail(&erec->list, queue);
 }
 
-extern void erec_print(FILE *f, const struct error_record *erec);
-extern void erec_print_list(FILE *f, struct list_head *list);
+extern void erec_print(FILE *f, const struct error_record *erec,
+		       unsigned int debug_mask);
+extern void erec_print_list(FILE *f, struct list_head *list,
+			    unsigned int debug_mask);
 
 struct eval_ctx;
 
diff --git a/include/expression.h b/include/expression.h
index 828dbaee6338..32d4423a5e06 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -413,7 +413,8 @@ extern struct expr *list_expr_alloc(const struct location *loc);
 extern struct expr *set_expr_alloc(const struct location *loc,
 				   const struct set *set);
 extern int set_to_intervals(struct list_head *msgs, struct set *set,
-			    struct expr *init, bool add);
+			    struct expr *init, bool add,
+			    unsigned int debug_mask);
 extern void interval_map_decompose(struct expr *set);
 
 extern struct expr *mapping_expr_alloc(const struct location *loc,
diff --git a/include/mnl.h b/include/mnl.h
index 72072f7f9a00..3df71467c108 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -8,6 +8,7 @@
 struct mnl_ctx {
 	struct mnl_socket	*nf_sock;
 	unsigned int		seqnum;
+	unsigned int		debug_mask;
 };
 
 struct mnl_socket *netlink_open_sock(void);
@@ -97,7 +98,7 @@ int mnl_nft_obj_batch_del(struct nftnl_obj *nln, struct nftnl_batch *batch,
 
 struct nftnl_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
 					   uint32_t family, uint32_t seqnum);
-int mnl_nft_event_listener(struct mnl_socket *nf_sock,
+int mnl_nft_event_listener(struct mnl_ctx *ctx,
 			   int (*cb)(const struct nlmsghdr *nlh, void *data),
 			   void *cb_data);
 
diff --git a/include/netlink.h b/include/netlink.h
index 4bed0e0b1e94..41b87ff8c2c5 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -19,6 +19,7 @@ struct netlink_parse_ctx {
 	struct rule		*rule;
 	struct stmt		*stmt;
 	struct expr		*registers[1 + NFT_REG32_15 - NFT_REG32_00 + 1];
+	unsigned int		debug_mask;
 };
 
 struct rule_pp_ctx {
@@ -39,6 +40,7 @@ extern const struct location netlink_location;
  * @data:	pointer to pass data to callback
  * @seqnum:	sequence number
  * @octx:	output context
+ * @debug:	display debugging information
  * @cache:	cache context
  */
 struct netlink_ctx {
@@ -50,6 +52,7 @@ struct netlink_ctx {
 	uint32_t		seqnum;
 	struct nftnl_batch	*batch;
 	bool			batch_supported;
+	unsigned int		debug_mask;
 	struct output_ctx	*octx;
 	struct nft_cache	*cache;
 };
@@ -176,11 +179,15 @@ extern int netlink_add_obj(struct netlink_ctx *ctx, const struct handle *h,
 extern int netlink_delete_obj(struct netlink_ctx *ctx, const struct handle *h,
 			      struct location *loc, uint32_t type);
 
-extern void netlink_dump_chain(const struct nftnl_chain *nlc);
-extern void netlink_dump_rule(const struct nftnl_rule *nlr);
-extern void netlink_dump_expr(const struct nftnl_expr *nle);
-extern void netlink_dump_set(const struct nftnl_set *nls);
-extern void netlink_dump_obj(struct nftnl_obj *nlo);
+extern void netlink_dump_chain(const struct nftnl_chain *nlc,
+			       unsigned int debug_mask);
+extern void netlink_dump_rule(const struct nftnl_rule *nlr,
+			      unsigned int debug_mask);
+extern void netlink_dump_expr(const struct nftnl_expr *nle,
+			      unsigned int debug_mask);
+extern void netlink_dump_set(const struct nftnl_set *nls,
+			     unsigned int debug_mask);
+extern void netlink_dump_obj(struct nftnl_obj *nlo, unsigned int debug_mask);
 
 extern int netlink_batch_send(struct netlink_ctx *ctx, struct list_head *err_list);
 
@@ -207,6 +214,7 @@ struct netlink_mon_handler {
 	uint32_t		format;
 	struct netlink_ctx	*ctx;
 	const struct location	*loc;
+	unsigned int		debug_mask;
 	bool			cache_needed;
 	struct nft_cache	*cache;
 };
diff --git a/include/nftables.h b/include/nftables.h
index 8858ad605516..c992d3023567 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -42,13 +42,12 @@ struct nft_ctx {
 	const char		*include_paths[INCLUDE_PATHS_MAX];
 	unsigned int		num_include_paths;
 	unsigned int		parser_max_errors;
+	unsigned int		debug_mask;
 	struct output_ctx	output;
 	bool			check;
 	struct nft_cache	cache;
 };
 
-extern unsigned int debug_level;
-
 enum nftables_exit_codes {
 	NFT_EXIT_SUCCESS	= 0,
 	NFT_EXIT_FAILURE	= 1,
diff --git a/include/parser.h b/include/parser.h
index df6026824584..0e266d60b8a3 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -32,7 +32,8 @@ struct parser_state {
 struct mnl_socket;
 
 extern void parser_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
-			struct parser_state *state, struct list_head *msgs);
+			struct parser_state *state, struct list_head *msgs,
+			unsigned int debug_level);
 extern int nft_parse(struct nft_ctx *ctx, void *, struct parser_state *state);
 
 extern void *scanner_init(struct parser_state *state);
diff --git a/include/proto.h b/include/proto.h
index 39aa4850740c..9a9f9255f047 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -130,6 +130,7 @@ extern const struct proto_desc *proto_dev_desc(uint16_t type);
 /**
  * struct proto_ctx - protocol context
  *
+ * debug_mask:	display debugging information
  * @family:	hook family
  * @location:	location of the relational expression defining the context
  * @desc:	protocol description for this layer
@@ -140,6 +141,7 @@ extern const struct proto_desc *proto_dev_desc(uint16_t type);
  * through a dependency.
  */
 struct proto_ctx {
+	unsigned int			debug_mask;
 	unsigned int			family;
 	struct {
 		struct location			location;
@@ -148,7 +150,8 @@ struct proto_ctx {
 	} protocol[PROTO_BASE_MAX + 1];
 };
 
-extern void proto_ctx_init(struct proto_ctx *ctx, unsigned int family);
+extern void proto_ctx_init(struct proto_ctx *ctx, unsigned int family,
+			   unsigned int debug_mask);
 extern void proto_ctx_update(struct proto_ctx *ctx, enum proto_bases base,
 			     const struct location *loc,
 			     const struct proto_desc *desc);
diff --git a/include/rule.h b/include/rule.h
index 10ac0e26accc..04da000f6c79 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -470,6 +470,7 @@ extern void cmd_free(struct cmd *cmd);
  * @set:	current set
  * @stmt:	current statement
  * @cache:	cache context
+ * @debug_mask: debugging bitmask
  * @ectx:	expression context
  * @pctx:	payload context
  */
@@ -482,6 +483,7 @@ struct eval_ctx {
 	struct set		*set;
 	struct stmt		*stmt;
 	struct nft_cache	*cache;
+	unsigned int		debug_mask;
 	struct expr_ctx		ectx;
 	struct proto_ctx	pctx;
 };
@@ -494,7 +496,7 @@ struct netlink_ctx;
 extern int do_command(struct netlink_ctx *ctx, struct cmd *cmd);
 
 extern int cache_update(struct mnl_socket *nf_sock, struct nft_cache *cache,
-			 enum cmd_ops cmd, struct list_head *msgs);
+			 enum cmd_ops cmd, struct list_head *msgs, bool debug);
 extern void cache_flush(struct list_head *table_list);
 extern void cache_release(struct nft_cache *cache);
 
diff --git a/src/cli.c b/src/cli.c
index 4f05f276542e..d923ff7d3617 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -134,10 +134,11 @@ static void cli_complete(char *line)
 	xfree(line);
 	line = s;
 
-	parser_init(cli_nf_sock, &cli_nft->cache, state, &msgs);
+	parser_init(cli_nf_sock, &cli_nft->cache, state, &msgs,
+		    cli_nft->debug_mask);
 	scanner_push_buffer(scanner, &indesc_cli, line);
 	nft_run(cli_nft, cli_nf_sock, scanner, state, &msgs);
-	erec_print_list(stdout, &msgs);
+	erec_print_list(stdout, &msgs, cli_nft->debug_mask);
 	xfree(line);
 	cache_release(&cli_nft->cache);
 	iface_cache_release();
diff --git a/src/erec.c b/src/erec.c
index 439add97c4e0..b5964465fbf3 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -112,7 +112,8 @@ struct error_record *erec_create(enum error_record_types type,
 	return erec;
 }
 
-void erec_print(FILE *f, const struct error_record *erec)
+void erec_print(FILE *f, const struct error_record *erec,
+		unsigned int debug_mask)
 {
 	const struct location *loc = erec->locations, *iloc;
 	const struct input_descriptor *indesc = loc->indesc, *tmp;
@@ -153,7 +154,7 @@ void erec_print(FILE *f, const struct error_record *erec)
 		fprintf(f, "%s\n", erec->msg);
 		for (l = 0; l < (int)erec->num_locations; l++) {
 			loc = &erec->locations[l];
-			netlink_dump_expr(loc->nle);
+			netlink_dump_expr(loc->nle, debug_mask);
 		}
 		fprintf(f, "\n");
 	} else {
@@ -202,13 +203,13 @@ void erec_print(FILE *f, const struct error_record *erec)
 	fprintf(f, "\n");
 }
 
-void erec_print_list(FILE *f, struct list_head *list)
+void erec_print_list(FILE *f, struct list_head *list, unsigned int debug_mask)
 {
 	struct error_record *erec, *next;
 
 	list_for_each_entry_safe(erec, next, list, list) {
 		list_del(&erec->list);
-		erec_print(f, erec);
+		erec_print(f, erec, debug_mask);
 		erec_destroy(erec);
 	}
 }
diff --git a/src/evaluate.c b/src/evaluate.c
index c1ad05b7ad86..8e844cb541bd 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -182,7 +182,7 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 		break;
 	case SYMBOL_SET:
 		ret = cache_update(ctx->nf_sock, ctx->cache, ctx->cmd->op,
-				   ctx->msgs);
+				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK);
 		if (ret < 0)
 			return ret;
 
@@ -1708,11 +1708,11 @@ static int expr_evaluate_meta(struct eval_ctx *ctx, struct expr **exprp)
 
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 {
-	if (debug_level & DEBUG_EVALUATION) {
+	if (ctx->debug_mask & DEBUG_EVALUATION) {
 		struct error_record *erec;
 		erec = erec_create(EREC_INFORMATIONAL, &(*expr)->location,
 				   "Evaluate %s", (*expr)->ops->name);
-		erec_print(stdout, erec);
+		erec_print(stdout, erec, ctx->debug_mask);
 		expr_print(*expr, &octx_debug_dummy);
 		printf("\n\n");
 	}
@@ -2676,11 +2676,12 @@ static int stmt_evaluate_objref(struct eval_ctx *ctx, struct stmt *stmt)
 
 int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	if (debug_level & DEBUG_EVALUATION) {
+	if (ctx->debug_mask & DEBUG_EVALUATION) {
 		struct error_record *erec;
 		erec = erec_create(EREC_INFORMATIONAL, &stmt->location,
 				   "Evaluate %s", stmt->ops->name);
-		erec_print(stdout, erec); stmt_print(stmt, &octx_debug_dummy);
+		erec_print(stdout, erec, ctx->debug_mask);
+		stmt_print(stmt, &octx_debug_dummy);
 		printf("\n\n");
 	}
 
@@ -2808,7 +2809,7 @@ static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule)
 	struct stmt *stmt, *tstmt = NULL;
 	struct error_record *erec;
 
-	proto_ctx_init(&ctx->pctx, rule->handle.family);
+	proto_ctx_init(&ctx->pctx, rule->handle.family, ctx->debug_mask);
 	memset(&ctx->ectx, 0, sizeof(ctx->ectx));
 
 	ctx->rule = rule;
@@ -2950,14 +2951,14 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	switch (cmd->obj) {
 	case CMD_OBJ_SETELEM:
 		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
-				   ctx->msgs);
+				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK);
 		if (ret < 0)
 			return ret;
 
 		return setelem_evaluate(ctx, &cmd->expr);
 	case CMD_OBJ_SET:
 		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
-				   ctx->msgs);
+				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK);
 		if (ret < 0)
 			return ret;
 
@@ -2968,7 +2969,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 		return rule_evaluate(ctx, cmd->rule);
 	case CMD_OBJ_CHAIN:
 		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
-				   ctx->msgs);
+				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK);
 		if (ret < 0)
 			return ret;
 
@@ -2991,7 +2992,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	switch (cmd->obj) {
 	case CMD_OBJ_SETELEM:
 		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
-				   ctx->msgs);
+				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK);
 		if (ret < 0)
 			return ret;
 
@@ -3033,7 +3034,8 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	struct set *set;
 	int ret;
 
-	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs);
+	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs,
+			   ctx->debug_mask & DEBUG_NETLINK);
 	if (ret < 0)
 		return ret;
 
@@ -3116,7 +3118,8 @@ static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	int ret;
 
-	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs);
+	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs,
+			   ctx->debug_mask & DEBUG_NETLINK);
 	if (ret < 0)
 		return ret;
 
@@ -3142,7 +3145,8 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 	struct set *set;
 	int ret;
 
-	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs);
+	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs,
+			   ctx->debug_mask & DEBUG_NETLINK);
 	if (ret < 0)
 		return ret;
 
@@ -3201,7 +3205,7 @@ static int cmd_evaluate_rename(struct eval_ctx *ctx, struct cmd *cmd)
 	switch (cmd->obj) {
 	case CMD_OBJ_CHAIN:
 		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
-				   ctx->msgs);
+				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK);
 		if (ret < 0)
 			return ret;
 
@@ -3298,7 +3302,8 @@ static int cmd_evaluate_monitor(struct eval_ctx *ctx, struct cmd *cmd)
 	uint32_t event;
 	int ret;
 
-	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs);
+	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs,
+			   ctx->debug_mask & DEBUG_NETLINK);
 	if (ret < 0)
 		return ret;
 
@@ -3319,7 +3324,8 @@ static int cmd_evaluate_monitor(struct eval_ctx *ctx, struct cmd *cmd)
 
 static int cmd_evaluate_export(struct eval_ctx *ctx, struct cmd *cmd)
 {
-	return cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs);
+	return cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs,
+			    ctx->debug_mask & DEBUG_NETLINK);
 }
 
 static const char *cmd_op_name[] = {
@@ -3347,12 +3353,13 @@ static const char *cmd_op_to_name(enum cmd_ops op)
 
 int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 {
-	if (debug_level & DEBUG_EVALUATION) {
+	if (ctx->debug_mask & DEBUG_EVALUATION) {
 		struct error_record *erec;
 
 		erec = erec_create(EREC_INFORMATIONAL, &cmd->location,
 				   "Evaluate %s", cmd_op_to_name(cmd->op));
-		erec_print(stdout, erec); printf("\n\n");
+		erec_print(stdout, erec, ctx->debug_mask);
+		printf("\n\n");
 	}
 
 	ctx->cmd = cmd;
diff --git a/src/main.c b/src/main.c
index 4c74bdce2824..3519377b6e2c 100644
--- a/src/main.c
+++ b/src/main.c
@@ -29,7 +29,6 @@
 #include <cli.h>
 
 static struct nft_ctx nft;
-unsigned int debug_level;
 
 enum opt_vals {
 	OPT_HELP		= 'h',
@@ -200,6 +199,7 @@ static int nft_netlink(struct nft_ctx *nft,
 		ctx.octx = &nft->output;
 		ctx.nf_sock = nf_sock;
 		ctx.cache = &nft->cache;
+		ctx.debug_mask = nft->debug_mask;
 		init_list_head(&ctx.list);
 		ret = do_command(&ctx, cmd);
 		if (ret < 0)
@@ -363,7 +363,7 @@ int main(int argc, char * const *argv)
 				for (i = 0; i < array_size(debug_param); i++) {
 					if (strcmp(debug_param[i].name, optarg))
 						continue;
-					debug_level |= debug_param[i].level;
+					nft.debug_mask |= debug_param[i].level;
 					break;
 				}
 
@@ -400,15 +400,16 @@ int main(int argc, char * const *argv)
 				strcat(buf, " ");
 		}
 		strcat(buf, "\n");
-		parser_init(nf_sock, &nft.cache, &state, &msgs);
+		parser_init(nf_sock, &nft.cache, &state, &msgs, nft.debug_mask);
 		scanner = scanner_init(&state);
 		scanner_push_buffer(scanner, &indesc_cmdline, buf);
 	} else if (filename != NULL) {
-		rc = cache_update(nf_sock, &nft.cache, CMD_INVALID, &msgs);
+		rc = cache_update(nf_sock, &nft.cache, CMD_INVALID, &msgs,
+				  nft.debug_mask);
 		if (rc < 0)
 			return rc;
 
-		parser_init(nf_sock, &nft.cache, &state, &msgs);
+		parser_init(nf_sock, &nft.cache, &state, &msgs, nft.debug_mask);
 		scanner = scanner_init(&state);
 		if (scanner_read_file(scanner, filename, &internal_location) < 0)
 			goto out;
@@ -428,7 +429,7 @@ int main(int argc, char * const *argv)
 		rc = NFT_EXIT_FAILURE;
 out:
 	scanner_destroy(scanner);
-	erec_print_list(stderr, &msgs);
+	erec_print_list(stderr, &msgs, nft.debug_mask);
 	xfree(buf);
 	cache_release(&nft.cache);
 	iface_cache_release();
diff --git a/src/mnl.c b/src/mnl.c
index e51c3294f76d..a770dc567d9f 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -71,7 +71,7 @@ nft_mnl_talk(struct mnl_ctx *ctx, const void *data, unsigned int len,
 {
 	uint32_t portid = mnl_socket_get_portid(ctx->nf_sock);
 
-	if (debug_level & DEBUG_MNL)
+	if (ctx->debug_mask & DEBUG_MNL)
 		mnl_nlmsg_fprintf(stdout, data, len, sizeof(struct nfgenmsg));
 
 	if (mnl_socket_sendto(ctx->nf_sock, data, len) < 0)
@@ -229,7 +229,7 @@ static ssize_t mnl_nft_socket_sendmsg(const struct netlink_ctx *ctx)
 	nftnl_batch_iovec(ctx->batch, iov, iov_len);
 
 	for (i = 0; i < iov_len; i++) {
-		if (debug_level & DEBUG_MNL) {
+		if (ctx->debug_mask & DEBUG_MNL) {
 			mnl_nlmsg_fprintf(stdout,
 					  iov[i].iov_base, iov[i].iov_len,
 					  sizeof(struct nfgenmsg));
@@ -1071,7 +1071,7 @@ err:
  */
 #define NFTABLES_NLEVENT_BUFSIZ	(1 << 24)
 
-int mnl_nft_event_listener(struct mnl_socket *nf_sock,
+int mnl_nft_event_listener(struct mnl_ctx *ctx,
 			   int (*cb)(const struct nlmsghdr *nlh, void *data),
 			   void *cb_data)
 {
@@ -1079,7 +1079,7 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock,
  	 * message loss due to ENOBUFS.
 	 */
 	unsigned int bufsiz = NFTABLES_NLEVENT_BUFSIZ;
-	int fd = mnl_socket_get_fd(nf_sock);
+	int fd = mnl_socket_get_fd(ctx->nf_sock);
 	char buf[NFT_NLMSG_MAXSIZE];
 	fd_set readfds;
 	int ret;
@@ -1105,7 +1105,7 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock,
 			return -1;
 
 		if (FD_ISSET(fd, &readfds)) {
-			ret = mnl_socket_recvfrom(nf_sock, buf, sizeof(buf));
+			ret = mnl_socket_recvfrom(ctx->nf_sock, buf, sizeof(buf));
 			if (ret < 0) {
 				if (errno == ENOBUFS) {
 					printf("# ERROR: We lost some netlink events!\n");
@@ -1116,7 +1116,7 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock,
 			}
 		}
 
-		if (debug_level & DEBUG_MNL) {
+		if (ctx->debug_mask & DEBUG_MNL) {
 			mnl_nlmsg_fprintf(stdout, buf, sizeof(buf),
 					  sizeof(struct nfgenmsg));
 		}
diff --git a/src/netlink.c b/src/netlink.c
index 7730b724d4ac..90f8486581fe 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -468,7 +468,8 @@ int netlink_replace_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
 
 	if (ctx->octx->echo) {
 		err = cache_update(ctx->nf_sock, ctx->cache,
-				   CMD_INVALID, ctx->msgs);
+				   CMD_INVALID, ctx->msgs,
+				   ctx->debug_mask & DEBUG_NETLINK);
 		if (err < 0)
 			return err;
 
@@ -502,22 +503,22 @@ int netlink_del_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
 	return err;
 }
 
-void netlink_dump_rule(const struct nftnl_rule *nlr)
+void netlink_dump_rule(const struct nftnl_rule *nlr, unsigned int debug_mask)
 {
 	char buf[4096];
 
-	if (!(debug_level & DEBUG_NETLINK))
+	if (!(debug_mask & DEBUG_NETLINK))
 		return;
 
 	nftnl_rule_snprintf(buf, sizeof(buf), nlr, 0, 0);
 	fprintf(stdout, "%s\n", buf);
 }
 
-void netlink_dump_expr(const struct nftnl_expr *nle)
+void netlink_dump_expr(const struct nftnl_expr *nle, unsigned int debug_mask)
 {
 	char buf[4096];
 
-	if (!(debug_level & DEBUG_NETLINK))
+	if (!(debug_mask & DEBUG_NETLINK))
 		return;
 
 	nftnl_expr_snprintf(buf, sizeof(buf), nle, 0, 0);
@@ -541,7 +542,7 @@ static int list_rule_cb(struct nftnl_rule *nlr, void *arg)
 	    (h->chain && strcmp(chain, h->chain) != 0))
 		return 0;
 
-	netlink_dump_rule(nlr);
+	netlink_dump_rule(nlr, ctx->debug_mask);
 	rule = netlink_delinearize_rule(ctx, nlr);
 	list_add_tail(&rule->list, &ctx->list);
 
@@ -573,11 +574,11 @@ static int netlink_flush_rules(struct netlink_ctx *ctx, const struct handle *h,
 	return netlink_del_rule_batch(ctx, h, loc);
 }
 
-void netlink_dump_chain(const struct nftnl_chain *nlc)
+void netlink_dump_chain(const struct nftnl_chain *nlc, unsigned int debug_mask)
 {
 	char buf[4096];
 
-	if (!(debug_level & DEBUG_NETLINK))
+	if (!(debug_mask & DEBUG_NETLINK))
 		return;
 
 	nftnl_chain_snprintf(buf, sizeof(buf), nlc, 0, 0);
@@ -607,7 +608,7 @@ static int netlink_add_chain_compat(struct netlink_ctx *ctx,
 					    chain->policy);
 	}
 
-	netlink_dump_chain(nlc);
+	netlink_dump_chain(nlc, ctx->debug_mask);
 	err = mnl_nft_chain_add(ctx->nf_sock, nlc, flags, ctx->seqnum);
 	nftnl_chain_free(nlc);
 
@@ -643,7 +644,7 @@ static int netlink_add_chain_batch(struct netlink_ctx *ctx,
 					    chain->dev);
 	}
 
-	netlink_dump_chain(nlc);
+	netlink_dump_chain(nlc, ctx->debug_mask);
 	err = mnl_nft_chain_batch_add(nlc, ctx->batch, flags, ctx->seqnum);
 	nftnl_chain_free(nlc);
 
@@ -673,7 +674,7 @@ static int netlink_rename_chain_compat(struct netlink_ctx *ctx,
 
 	nlc = alloc_nftnl_chain(h);
 	nftnl_chain_set_str(nlc, NFTNL_CHAIN_NAME, name);
-	netlink_dump_chain(nlc);
+	netlink_dump_chain(nlc, ctx->debug_mask);
 	err = mnl_nft_chain_add(ctx->nf_sock, nlc, 0, ctx->seqnum);
 	nftnl_chain_free(nlc);
 
@@ -693,7 +694,7 @@ static int netlink_rename_chain_batch(struct netlink_ctx *ctx,
 
 	nlc = alloc_nftnl_chain(h);
 	nftnl_chain_set_str(nlc, NFTNL_CHAIN_NAME, name);
-	netlink_dump_chain(nlc);
+	netlink_dump_chain(nlc, ctx->debug_mask);
 	err = mnl_nft_chain_batch_add(nlc, ctx->batch, 0, ctx->seqnum);
 	nftnl_chain_free(nlc);
 
@@ -720,7 +721,7 @@ static int netlink_del_chain_compat(struct netlink_ctx *ctx,
 	int err;
 
 	nlc = alloc_nftnl_chain(h);
-	netlink_dump_chain(nlc);
+	netlink_dump_chain(nlc, ctx->debug_mask);
 	err = mnl_nft_chain_delete(ctx->nf_sock, nlc, 0, ctx->seqnum);
 	nftnl_chain_free(nlc);
 
@@ -738,7 +739,7 @@ static int netlink_del_chain_batch(struct netlink_ctx *ctx,
 	int err;
 
 	nlc = alloc_nftnl_chain(h);
-	netlink_dump_chain(nlc);
+	netlink_dump_chain(nlc, ctx->debug_mask);
 	err = mnl_nft_chain_batch_del(nlc, ctx->batch, 0, ctx->seqnum);
 	nftnl_chain_free(nlc);
 
@@ -1028,11 +1029,11 @@ static const struct datatype *dtype_map_from_kernel(enum nft_data_types type)
 	}
 }
 
-void netlink_dump_set(const struct nftnl_set *nls)
+void netlink_dump_set(const struct nftnl_set *nls, unsigned int debug_mask)
 {
 	char buf[4096];
 
-	if (!(debug_level & DEBUG_NETLINK))
+	if (!(debug_mask & DEBUG_NETLINK))
 		return;
 
 	nftnl_set_snprintf(buf, sizeof(buf), nls, 0, 0);
@@ -1165,7 +1166,7 @@ static int netlink_add_set_compat(struct netlink_ctx *ctx,
 		nftnl_set_set_u32(nls, NFTNL_SET_DATA_LEN,
 				  set->datalen / BITS_PER_BYTE);
 	}
-	netlink_dump_set(nls);
+	netlink_dump_set(nls, ctx->debug_mask);
 
 	err = mnl_nft_set_add(ctx->nf_sock, nls, NLM_F_ECHO | flags,
 			      ctx->seqnum);
@@ -1236,7 +1237,7 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 			   nftnl_udata_buf_len(udbuf));
 	nftnl_udata_buf_free(udbuf);
 
-	netlink_dump_set(nls);
+	netlink_dump_set(nls, ctx->debug_mask);
 
 	err = mnl_nft_set_batch_add(nls, ctx->batch, flags, ctx->seqnum);
 	if (err < 0)
@@ -1351,7 +1352,7 @@ static int netlink_add_setelems_batch(struct netlink_ctx *ctx,
 
 	nls = alloc_nftnl_set(h);
 	alloc_setelem_cache(expr, nls);
-	netlink_dump_set(nls);
+	netlink_dump_set(nls, ctx->debug_mask);
 
 	err = mnl_nft_setelem_batch_add(nls, ctx->batch, flags, ctx->seqnum);
 	nftnl_set_free(nls);
@@ -1371,7 +1372,7 @@ static int netlink_add_setelems_compat(struct netlink_ctx *ctx,
 
 	nls = alloc_nftnl_set(h);
 	alloc_setelem_cache(expr, nls);
-	netlink_dump_set(nls);
+	netlink_dump_set(nls, ctx->debug_mask);
 
 	err = mnl_nft_setelem_add(ctx->nf_sock, nls, flags, ctx->seqnum);
 	nftnl_set_free(nls);
@@ -1401,7 +1402,7 @@ static int netlink_del_setelems_batch(struct netlink_ctx *ctx,
 	nls = alloc_nftnl_set(h);
 	if (expr)
 		alloc_setelem_cache(expr, nls);
-	netlink_dump_set(nls);
+	netlink_dump_set(nls, ctx->debug_mask);
 
 	err = mnl_nft_setelem_batch_del(nls, ctx->batch, 0, ctx->seqnum);
 	nftnl_set_free(nls);
@@ -1421,7 +1422,7 @@ static int netlink_del_setelems_compat(struct netlink_ctx *ctx,
 
 	nls = alloc_nftnl_set(h);
 	alloc_setelem_cache(expr, nls);
-	netlink_dump_set(nls);
+	netlink_dump_set(nls, ctx->debug_mask);
 
 	err = mnl_nft_setelem_delete(ctx->nf_sock, nls, 0, ctx->seqnum);
 	nftnl_set_free(nls);
@@ -1439,7 +1440,7 @@ int netlink_flush_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	int err;
 
 	nls = alloc_nftnl_set(h);
-	netlink_dump_set(nls);
+	netlink_dump_set(nls, ctx->debug_mask);
 
 	err = mnl_nft_setelem_batch_flush(nls, ctx->batch, 0, ctx->seqnum);
 	nftnl_set_free(nls);
@@ -1651,11 +1652,11 @@ out:
 	return err;
 }
 
-void netlink_dump_obj(struct nftnl_obj *nln)
+void netlink_dump_obj(struct nftnl_obj *nln, unsigned int debug_mask)
 {
 	char buf[4096];
 
-	if (!(debug_level & DEBUG_NETLINK))
+	if (!(debug_mask & DEBUG_NETLINK))
 		return;
 
 	nftnl_obj_snprintf(buf, sizeof(buf), nln, 0, 0);
@@ -1669,7 +1670,7 @@ int netlink_add_obj(struct netlink_ctx *ctx, const struct handle *h,
 	int err;
 
 	nlo = alloc_nftnl_obj(h, obj);
-	netlink_dump_obj(nlo);
+	netlink_dump_obj(nlo, ctx->debug_mask);
 
 	err = mnl_nft_obj_batch_add(nlo, ctx->batch, flags, ctx->seqnum);
 	if (err < 0)
@@ -1687,7 +1688,7 @@ int netlink_delete_obj(struct netlink_ctx *ctx, const struct handle *h,
 	int err;
 
 	nlo = __alloc_nftnl_obj(h, type);
-	netlink_dump_obj(nlo);
+	netlink_dump_obj(nlo, ctx->debug_mask);
 
 	err = mnl_nft_obj_batch_del(nlo, ctx->batch, 0, ctx->seqnum);
 	if (err < 0)
@@ -2767,7 +2768,7 @@ static void trace_print_packet(const struct nftnl_trace *nlt,
 				 meta_expr_alloc(&netlink_location,
 						 NFT_META_OIF), octx);
 
-	proto_ctx_init(&ctx, nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY));
+	proto_ctx_init(&ctx, nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY), 0);
 	ll_desc = ctx.protocol[PROTO_BASE_LL_HDR].desc;
 	if ((ll_desc == &proto_inet || ll_desc  == &proto_netdev) &&
 	    nftnl_trace_is_set(nlt, NFTNL_TRACE_NFPROTO)) {
@@ -2870,9 +2871,9 @@ static const char *nftnl_msgtype2str(uint16_t type)
 	return nftnl_msg_types[type];
 }
 
-static void netlink_events_debug(uint16_t type)
+static void netlink_events_debug(uint16_t type, unsigned int debug_mask)
 {
-	if (!(debug_level & DEBUG_NETLINK))
+	if (!(debug_mask & DEBUG_NETLINK))
 		return;
 
 	printf("netlink event: %s\n", nftnl_msgtype2str(type));
@@ -2923,7 +2924,7 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 	uint16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
 	struct netlink_mon_handler *monh = (struct netlink_mon_handler *)data;
 
-	netlink_events_debug(type);
+	netlink_events_debug(type, monh->debug_mask);
 	netlink_events_cache_update(monh, nlh, type);
 
 	if (!(monh->monitor_flags & (1 << type)))
@@ -2976,6 +2977,7 @@ int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
 		.monitor_flags = 0xffffffff,
 		.cache_needed = true,
 		.cache = ctx->cache,
+		.debug_mask = ctx->debug_mask,
 	};
 
 	if (!echo_monh.ctx->octx->echo)
@@ -2985,8 +2987,12 @@ int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
 }
 
 int netlink_monitor(struct netlink_mon_handler *monhandler,
-		     struct mnl_socket *nf_sock)
+		    struct mnl_socket *nf_sock)
 {
+	struct mnl_ctx ctx = {
+		.nf_sock	= nf_sock,
+		.debug_mask	= monhandler->debug_mask,
+	};
 	int group;
 
 	if (monhandler->monitor_flags & (1 << NFT_MSG_TRACE)) {
@@ -3008,7 +3014,7 @@ int netlink_monitor(struct netlink_mon_handler *monhandler,
 						strerror(errno));
 	}
 
-	return mnl_nft_event_listener(nf_sock, netlink_events_cb, monhandler);
+	return mnl_nft_event_listener(&ctx, netlink_events_cb, monhandler);
 }
 
 bool netlink_batch_supported(struct mnl_socket *nf_sock, uint32_t *seqnum)
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 5317a830ac6d..875690ff2a9c 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2184,7 +2184,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 	struct stmt *stmt, *next;
 
 	memset(&rctx, 0, sizeof(rctx));
-	proto_ctx_init(&rctx.pctx, rule->handle.family);
+	proto_ctx_init(&rctx.pctx, rule->handle.family, ctx->debug_mask);
 
 	list_for_each_entry_safe(stmt, next, &rule->stmts, list) {
 		enum stmt_types type = stmt->ops->type;
@@ -2296,6 +2296,7 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 
 	memset(&_ctx, 0, sizeof(_ctx));
 	_ctx.msgs = ctx->msgs;
+	_ctx.debug_mask = ctx->debug_mask;
 
 	memset(&h, 0, sizeof(h));
 	h.family = nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 3d684569cabf..c1fe6b010781 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1308,5 +1308,5 @@ void netlink_linearize_rule(struct netlink_ctx *ctx, struct nftnl_rule *nlr,
 		nftnl_udata_buf_free(udata);
 	}
 
-	netlink_dump_rule(nlr);
+	netlink_dump_rule(nlr, ctx->debug_mask);
 }
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 76a0115d46a2..ab291467e8fe 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -36,7 +36,8 @@
 #include "parser_bison.h"
 
 void parser_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
-		 struct parser_state *state, struct list_head *msgs)
+		 struct parser_state *state, struct list_head *msgs,
+		 unsigned int debug_mask)
 {
 	memset(state, 0, sizeof(*state));
 	init_list_head(&state->cmds);
@@ -46,6 +47,7 @@ void parser_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 	state->ectx.cache = cache;
 	state->ectx.msgs = msgs;
 	state->ectx.nf_sock = nf_sock;
+	state->ectx.debug_mask = debug_mask;
 }
 
 static void yyerror(struct location *loc, struct nft_ctx *nft, void *scanner,
@@ -118,9 +120,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %initial-action {
 	location_init(scanner, state, &yylloc);
-	if (debug_level & DEBUG_SCANNER)
+	if (nft->debug_mask & DEBUG_SCANNER)
 		nft_set_debug(1, scanner);
-	if (debug_level & DEBUG_PARSER)
+	if (nft->debug_mask & DEBUG_PARSER)
 		yydebug = 1;
 }
 
diff --git a/src/proto.c b/src/proto.c
index 045f2d811969..d69e9a30de78 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -138,11 +138,12 @@ const struct hook_proto_desc hook_proto_desc[] = {
 	[NFPROTO_ARP]		= HOOK_PROTO_DESC(PROTO_BASE_NETWORK_HDR, &proto_arp),
 };
 
-static void proto_ctx_debug(const struct proto_ctx *ctx, enum proto_bases base)
+static void proto_ctx_debug(const struct proto_ctx *ctx, enum proto_bases base,
+			    unsigned int debug_mask)
 {
 	unsigned int i;
 
-	if (!(debug_level & DEBUG_PROTO_CTX))
+	if (!(debug_mask & DEBUG_NETLINK))
 		return;
 
 	pr_debug("update %s protocol context:\n", proto_base_names[base]);
@@ -165,16 +166,19 @@ static void proto_ctx_debug(const struct proto_ctx *ctx, enum proto_bases base)
  *
  * @ctx:	protocol context
  * @family:	hook family
+ * @debug:	display debugging information
  */
-void proto_ctx_init(struct proto_ctx *ctx, unsigned int family)
+void proto_ctx_init(struct proto_ctx *ctx, unsigned int family,
+		    unsigned int debug_mask)
 {
 	const struct hook_proto_desc *h = &hook_proto_desc[family];
 
 	memset(ctx, 0, sizeof(*ctx));
 	ctx->family = family;
 	ctx->protocol[h->base].desc = h->desc;
+	ctx->debug_mask = debug_mask;
 
-	proto_ctx_debug(ctx, h->base);
+	proto_ctx_debug(ctx, h->base, debug_mask);
 }
 
 /**
@@ -192,7 +196,7 @@ void proto_ctx_update(struct proto_ctx *ctx, enum proto_bases base,
 	ctx->protocol[base].location	= *loc;
 	ctx->protocol[base].desc	= desc;
 
-	proto_ctx_debug(ctx, base);
+	proto_ctx_debug(ctx, base, ctx->debug_mask);
 }
 
 #define HDR_TEMPLATE(__name, __dtype, __type, __member)			\
diff --git a/src/rule.c b/src/rule.c
index ef12becdea94..140855f51757 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -122,7 +122,8 @@ static int cache_init_objects(struct netlink_ctx *ctx, enum cmd_ops cmd)
 }
 
 static int cache_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
-		      enum cmd_ops cmd, struct list_head *msgs)
+		      enum cmd_ops cmd, struct list_head *msgs,
+		      unsigned int debug_mask)
 {
 	struct handle handle = {
 		.family = NFPROTO_UNSPEC,
@@ -136,6 +137,7 @@ static int cache_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 	ctx.cache = cache;
 	ctx.msgs = msgs;
 	ctx.seqnum = cache->seqnum++;
+	ctx.debug_mask = debug_mask;
 
 	ret = cache_init_tables(&ctx, &handle, cache);
 	if (ret < 0)
@@ -148,7 +150,7 @@ static int cache_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 }
 
 int cache_update(struct mnl_socket *nf_sock, struct nft_cache *cache,
-		 enum cmd_ops cmd, struct list_head *msgs)
+		 enum cmd_ops cmd, struct list_head *msgs, bool debug)
 {
 	int ret;
 
@@ -156,7 +158,7 @@ int cache_update(struct mnl_socket *nf_sock, struct nft_cache *cache,
 		return 0;
 replay:
 	netlink_genid_get(nf_sock, cache->seqnum++);
-	ret = cache_init(nf_sock, cache, cmd, msgs);
+	ret = cache_init(nf_sock, cache, cmd, msgs, debug);
 	if (ret < 0) {
 		cache_release(cache);
 		if (errno == EINTR) {
@@ -991,7 +993,7 @@ static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	set = set_lookup(table, h->set);
 
 	if (set->flags & NFT_SET_INTERVAL &&
-	    set_to_intervals(ctx->msgs, set, init, true) < 0)
+	    set_to_intervals(ctx->msgs, set, init, true, ctx->debug_mask) < 0)
 		return -1;
 
 	return __do_add_setelems(ctx, h, set, init, flags);
@@ -1002,7 +1004,8 @@ static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
 {
 	if (set->init != NULL) {
 		if (set->flags & NFT_SET_INTERVAL &&
-		    set_to_intervals(ctx->msgs, set, set->init, true) < 0)
+		    set_to_intervals(ctx->msgs, set, set->init, true,
+				     ctx->debug_mask) < 0)
 			return -1;
 	}
 	if (netlink_add_set(ctx, h, set, flags) < 0)
@@ -1021,8 +1024,8 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 	if (ctx->octx->echo) {
 		int ret;
 
-		ret = cache_update(ctx->nf_sock, ctx->cache,
-				  cmd->obj, ctx->msgs);
+		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->obj,
+				   ctx->msgs, ctx->debug_mask);
 		if (ret < 0)
 			return ret;
 
@@ -1072,8 +1075,8 @@ static int do_command_insert(struct netlink_ctx *ctx, struct cmd *cmd)
 	if (ctx->octx->echo) {
 		int ret;
 
-		ret = cache_update(ctx->nf_sock, ctx->cache,
-				  cmd->obj, ctx->msgs);
+		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->obj,
+				   ctx->msgs, ctx->debug_mask);
 		if (ret < 0)
 			return ret;
 
@@ -1100,7 +1103,7 @@ static int do_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	set = set_lookup(table, h->set);
 
 	if (set->flags & NFT_SET_INTERVAL &&
-	    set_to_intervals(ctx->msgs, set, expr, false) < 0)
+	    set_to_intervals(ctx->msgs, set, expr, false, ctx->debug_mask) < 0)
 		return -1;
 
 	if (netlink_delete_setelems(ctx, h, expr) < 0)
diff --git a/src/segtree.c b/src/segtree.c
index 8623e862cf77..f81e117421a1 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -25,6 +25,7 @@
  * @type:	the datatype of the dimension
  * @dwidth:	width of the dimension
  * @byteorder:	byteorder of elements
+ * @debug_mask:	display debugging information
  */
 struct seg_tree {
 	struct rb_root			root;
@@ -33,6 +34,7 @@ struct seg_tree {
 	const struct datatype		*datatype;
 	unsigned int			datalen;
 	enum byteorder			byteorder;
+	unsigned int			debug_mask;
 };
 
 enum elementary_interval_flags {
@@ -68,7 +70,7 @@ struct elementary_interval {
 static struct output_ctx debug_octx = {};
 
 static void seg_tree_init(struct seg_tree *tree, const struct set *set,
-			  struct expr *init)
+			  struct expr *init, unsigned int debug_mask)
 {
 	struct expr *first;
 
@@ -79,6 +81,7 @@ static void seg_tree_init(struct seg_tree *tree, const struct set *set,
 	tree->datatype	= set->datatype;
 	tree->datalen	= set->datalen;
 	tree->byteorder	= first->byteorder;
+	tree->debug_mask = debug_mask;
 }
 
 static struct elementary_interval *ei_alloc(const mpz_t left, const mpz_t right,
@@ -161,9 +164,9 @@ static void __ei_insert(struct seg_tree *tree, struct elementary_interval *new)
 	rb_insert_color(&new->rb_node, &tree->root);
 }
 
-static bool segtree_debug(void)
+static bool segtree_debug(unsigned int debug_mask)
 {
-	if (debug_level & DEBUG_SEGTREE)
+	if (debug_mask & DEBUG_SEGTREE)
 		return true;
 
 	return false;
@@ -192,7 +195,7 @@ static void ei_insert(struct seg_tree *tree, struct elementary_interval *new)
 	lei = ei_lookup(tree, new->left);
 	rei = ei_lookup(tree, new->right);
 
-	if (segtree_debug())
+	if (segtree_debug(tree->debug_mask))
 		pr_gmp_debug("insert: [%Zx %Zx]\n", new->left, new->right);
 
 	if (lei != NULL && rei != NULL && lei == rei) {
@@ -202,7 +205,7 @@ static void ei_insert(struct seg_tree *tree, struct elementary_interval *new)
 		 *
 		 * [lei_left, new_left) and (new_right, rei_right]
 		 */
-		if (segtree_debug())
+		if (segtree_debug(tree->debug_mask))
 			pr_gmp_debug("split [%Zx %Zx]\n", lei->left, lei->right);
 
 		ei_remove(tree, lei);
@@ -222,7 +225,7 @@ static void ei_insert(struct seg_tree *tree, struct elementary_interval *new)
 			 *
 			 * [lei_left, new_left)[new_left, new_right]
 			 */
-			if (segtree_debug()) {
+			if (segtree_debug(tree->debug_mask)) {
 				pr_gmp_debug("adjust left [%Zx %Zx]\n",
 					     lei->left, lei->right);
 			}
@@ -240,7 +243,7 @@ static void ei_insert(struct seg_tree *tree, struct elementary_interval *new)
 			 *
 			 * [new_left, new_right](new_right, rei_right]
 			 */
-			if (segtree_debug()) {
+			if (segtree_debug(tree->debug_mask)) {
 				pr_gmp_debug("adjust right [%Zx %Zx]\n",
 					     rei->left, rei->right);
 			}
@@ -461,7 +464,7 @@ static void segtree_linearize(struct list_head *list, const struct set *set,
 	 * Convert the tree of open intervals to half-closed map expressions.
 	 */
 	rb_for_each_entry_safe(ei, node, next, &tree->root, rb_node) {
-		if (segtree_debug())
+		if (segtree_debug(tree->debug_mask))
 			pr_gmp_debug("iter: [%Zx %Zx]\n", ei->left, ei->right);
 
 		if (prev == NULL) {
@@ -547,20 +550,20 @@ static void set_insert_interval(struct expr *set, struct seg_tree *tree,
 }
 
 int set_to_intervals(struct list_head *errs, struct set *set,
-		     struct expr *init, bool add)
+		     struct expr *init, bool add, unsigned int debug_mask)
 {
 	struct elementary_interval *ei, *next;
 	struct seg_tree tree;
 	LIST_HEAD(list);
 
-	seg_tree_init(&tree, set, init);
+	seg_tree_init(&tree, set, init, debug_mask);
 	if (set_to_segtree(errs, set, init, &tree, add) < 0)
 		return -1;
 	segtree_linearize(&list, set, init, &tree, add);
 
 	init->size = 0;
 	list_for_each_entry_safe(ei, next, &list, list) {
-		if (segtree_debug()) {
+		if (segtree_debug(tree.debug_mask)) {
 			pr_gmp_debug("list: [%.*Zx %.*Zx]\n",
 				     2 * tree.keylen / BITS_PER_BYTE, ei->left,
 				     2 * tree.keylen / BITS_PER_BYTE, ei->right);
@@ -569,7 +572,7 @@ int set_to_intervals(struct list_head *errs, struct set *set,
 		ei_destroy(ei);
 	}
 
-	if (segtree_debug()) {
+	if (segtree_debug(tree.debug_mask)) {
 		expr_print(init, &debug_octx);
 		pr_gmp_debug("\n");
 	}
-- 
2.1.4


