From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: add nft_ prefix to everything exposed through include/nftables/nftables.h
Date: Tue, 24 Oct 2017 17:21:02 +0200
Message-ID: <20171024152102.31990-1-pablo@netfilter.org>
Cc: phil@nwl.cc
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38140 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932343AbdJXPVK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2017 11:21:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7F6C9E8E84
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 17:21:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A648DA80B
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 17:21:08 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Prepend nft_ prefix before these are exposed, reduce chances we hit
symbol namespace pollution problems when mixing libnftables with other
existing libraries.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/nftables/nftables.h | 30 +++++++++++++++---------------
 src/datatype.c              |  6 +++---
 src/evaluate.c              | 28 ++++++++++++++--------------
 src/expression.c            |  4 ++--
 src/libnftables.c           |  5 +++--
 src/main.c                  | 26 +++++++++++++-------------
 src/meta.c                  |  4 ++--
 src/mnl.c                   |  6 +++---
 src/netlink.c               | 14 +++++++-------
 src/parser_bison.y          |  4 ++--
 src/proto.c                 |  2 +-
 src/rule.c                  |  2 +-
 src/segtree.c               |  2 +-
 13 files changed, 67 insertions(+), 66 deletions(-)

diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index 2dff281183b3..449f9e4ee879 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -16,21 +16,21 @@
 
 struct nft_ctx;
 
-enum debug_level {
-	DEBUG_SCANNER		= 0x1,
-	DEBUG_PARSER		= 0x2,
-	DEBUG_EVALUATION	= 0x4,
-	DEBUG_NETLINK		= 0x8,
-	DEBUG_MNL		= 0x10,
-	DEBUG_PROTO_CTX		= 0x20,
-	DEBUG_SEGTREE		= 0x40,
+enum nft_debug_level {
+	NFT_DEBUG_SCANNER		= 0x1,
+	NFT_DEBUG_PARSER		= 0x2,
+	NFT_DEBUG_EVALUATION		= 0x4,
+	NFT_DEBUG_NETLINK		= 0x8,
+	NFT_DEBUG_MNL			= 0x10,
+	NFT_DEBUG_PROTO_CTX		= 0x20,
+	NFT_DEBUG_SEGTREE		= 0x40,
 };
 
-enum numeric_level {
-	NUMERIC_NONE,
-	NUMERIC_ADDR,
-	NUMERIC_PORT,
-	NUMERIC_ALL,
+enum nft_numeric_level {
+	NFT_NUMERIC_NONE,
+	NFT_NUMERIC_ADDR,
+	NFT_NUMERIC_PORT,
+	NFT_NUMERIC_ALL,
 };
 
 /**
@@ -53,8 +53,8 @@ void nft_ctx_free(struct nft_ctx *ctx);
 
 bool nft_ctx_get_dry_run(struct nft_ctx *ctx);
 void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry);
-enum numeric_level nft_ctx_output_get_numeric(struct nft_ctx *ctx);
-void nft_ctx_output_set_numeric(struct nft_ctx *ctx, enum numeric_level level);
+enum nft_numeric_level nft_ctx_output_get_numeric(struct nft_ctx *ctx);
+void nft_ctx_output_set_numeric(struct nft_ctx *ctx, enum nft_numeric_level level);
 bool nft_ctx_output_get_stateless(struct nft_ctx *ctx);
 void nft_ctx_output_set_stateless(struct nft_ctx *ctx, bool val);
 bool nft_ctx_output_get_ip2name(struct nft_ctx *ctx);
diff --git a/src/datatype.c b/src/datatype.c
index 94b1224c66e6..93726cafc98a 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -194,7 +194,7 @@ void symbolic_constant_print(const struct symbol_table *tbl,
 	if (quotes)
 		nft_print(octx, "\"");
 
-	if (octx->numeric > NUMERIC_ALL)
+	if (octx->numeric > NFT_NUMERIC_ALL)
 		nft_print(octx, "%" PRIu64 "", val);
 	else
 		nft_print(octx, "%s", s->identifier);
@@ -556,7 +556,7 @@ static void inet_protocol_type_print(const struct expr *expr,
 {
 	struct protoent *p;
 
-	if (octx->numeric < NUMERIC_ALL) {
+	if (octx->numeric < NFT_NUMERIC_ALL) {
 		p = getprotobynumber(mpz_get_uint8(expr->value));
 		if (p != NULL) {
 			nft_print(octx, "%s", p->p_name);
@@ -608,7 +608,7 @@ const struct datatype inet_protocol_type = {
 static void inet_service_type_print(const struct expr *expr,
 				     struct output_ctx *octx)
 {
-	if (octx->numeric >= NUMERIC_PORT) {
+	if (octx->numeric >= NFT_NUMERIC_PORT) {
 		integer_type_print(expr, octx);
 		return;
 	}
diff --git a/src/evaluate.c b/src/evaluate.c
index 618e1889863c..fd61e7530d2e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -192,7 +192,7 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 		break;
 	case SYMBOL_SET:
 		ret = cache_update(ctx->nf_sock, ctx->cache, ctx->cmd->op,
-				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
+				   ctx->msgs, ctx->debug_mask & NFT_DEBUG_NETLINK, ctx->octx);
 		if (ret < 0)
 			return ret;
 
@@ -1772,7 +1772,7 @@ static int expr_evaluate_meta(struct eval_ctx *ctx, struct expr **exprp)
 
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 {
-	if (ctx->debug_mask & DEBUG_EVALUATION) {
+	if (ctx->debug_mask & NFT_DEBUG_EVALUATION) {
 		struct error_record *erec;
 		erec = erec_create(EREC_INFORMATIONAL, &(*expr)->location,
 				   "Evaluate %s", (*expr)->ops->name);
@@ -2758,7 +2758,7 @@ static int stmt_evaluate_objref(struct eval_ctx *ctx, struct stmt *stmt)
 
 int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	if (ctx->debug_mask & DEBUG_EVALUATION) {
+	if (ctx->debug_mask & NFT_DEBUG_EVALUATION) {
 		struct error_record *erec;
 		erec = erec_create(EREC_INFORMATIONAL, &stmt->location,
 				   "Evaluate %s", stmt->ops->name);
@@ -3041,14 +3041,14 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	switch (cmd->obj) {
 	case CMD_OBJ_SETELEM:
 		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
-				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
+				   ctx->msgs, ctx->debug_mask & NFT_DEBUG_NETLINK, ctx->octx);
 		if (ret < 0)
 			return ret;
 
 		return setelem_evaluate(ctx, &cmd->expr);
 	case CMD_OBJ_SET:
 		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
-				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
+				   ctx->msgs, ctx->debug_mask & NFT_DEBUG_NETLINK, ctx->octx);
 		if (ret < 0)
 			return ret;
 
@@ -3059,7 +3059,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 		return rule_evaluate(ctx, cmd->rule);
 	case CMD_OBJ_CHAIN:
 		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
-				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
+				   ctx->msgs, ctx->debug_mask & NFT_DEBUG_NETLINK, ctx->octx);
 		if (ret < 0)
 			return ret;
 
@@ -3083,7 +3083,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	switch (cmd->obj) {
 	case CMD_OBJ_SETELEM:
 		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
-				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
+				   ctx->msgs, ctx->debug_mask & NFT_DEBUG_NETLINK, ctx->octx);
 		if (ret < 0)
 			return ret;
 
@@ -3127,7 +3127,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	int ret;
 
 	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs,
-			   ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
+			   ctx->debug_mask & NFT_DEBUG_NETLINK, ctx->octx);
 	if (ret < 0)
 		return ret;
 
@@ -3214,7 +3214,7 @@ static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
 	int ret;
 
 	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs,
-			   ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
+			   ctx->debug_mask & NFT_DEBUG_NETLINK, ctx->octx);
 	if (ret < 0)
 		return ret;
 
@@ -3241,7 +3241,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 	int ret;
 
 	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs,
-			   ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
+			   ctx->debug_mask & NFT_DEBUG_NETLINK, ctx->octx);
 	if (ret < 0)
 		return ret;
 
@@ -3300,7 +3300,7 @@ static int cmd_evaluate_rename(struct eval_ctx *ctx, struct cmd *cmd)
 	switch (cmd->obj) {
 	case CMD_OBJ_CHAIN:
 		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
-				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
+				   ctx->msgs, ctx->debug_mask & NFT_DEBUG_NETLINK, ctx->octx);
 		if (ret < 0)
 			return ret;
 
@@ -3398,7 +3398,7 @@ static int cmd_evaluate_monitor(struct eval_ctx *ctx, struct cmd *cmd)
 	int ret;
 
 	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs,
-			   ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
+			   ctx->debug_mask & NFT_DEBUG_NETLINK, ctx->octx);
 	if (ret < 0)
 		return ret;
 
@@ -3420,7 +3420,7 @@ static int cmd_evaluate_monitor(struct eval_ctx *ctx, struct cmd *cmd)
 static int cmd_evaluate_export(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	return cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs,
-			    ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
+			    ctx->debug_mask & NFT_DEBUG_NETLINK, ctx->octx);
 }
 
 static const char * const cmd_op_name[] = {
@@ -3448,7 +3448,7 @@ static const char *cmd_op_to_name(enum cmd_ops op)
 
 int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 {
-	if (ctx->debug_mask & DEBUG_EVALUATION) {
+	if (ctx->debug_mask & NFT_DEBUG_EVALUATION) {
 		struct error_record *erec;
 
 		erec = erec_create(EREC_INFORMATIONAL, &cmd->location,
diff --git a/src/expression.c b/src/expression.c
index fc1097a1cffd..64ac724a2ae5 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -602,11 +602,11 @@ struct expr *relational_expr_alloc(const struct location *loc, enum ops op,
 
 static void range_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	octx->numeric += NUMERIC_ALL + 1;
+	octx->numeric += NFT_NUMERIC_ALL + 1;
 	expr_print(expr->left, octx);
 	nft_print(octx, "-");
 	expr_print(expr->right, octx);
-	octx->numeric -= NUMERIC_ALL + 1;
+	octx->numeric -= NFT_NUMERIC_ALL + 1;
 }
 
 static void range_expr_clone(struct expr *new, const struct expr *expr)
diff --git a/src/libnftables.c b/src/libnftables.c
index 5e70c197846c..5ef5532c7f07 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -210,12 +210,13 @@ void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry)
 	ctx->check = dry;
 }
 
-enum numeric_level nft_ctx_output_get_numeric(struct nft_ctx *ctx)
+enum nft_numeric_level nft_ctx_output_get_numeric(struct nft_ctx *ctx)
 {
 	return ctx->output.numeric;
 }
 
-void nft_ctx_output_set_numeric(struct nft_ctx *ctx, enum numeric_level level)
+void nft_ctx_output_set_numeric(struct nft_ctx *ctx,
+				enum nft_numeric_level level)
 {
 	ctx->output.numeric = level;
 }
diff --git a/src/main.c b/src/main.c
index 59c39d4570b0..529bedffc2e3 100644
--- a/src/main.c
+++ b/src/main.c
@@ -127,35 +127,35 @@ static void show_help(const char *name)
 
 static const struct {
 	const char		*name;
-	enum debug_level	level;
+	enum nft_debug_level	level;
 } debug_param[] = {
 	{
 		.name		= "scanner",
-		.level		= DEBUG_SCANNER,
+		.level		= NFT_DEBUG_SCANNER,
 	},
 	{
 		.name		= "parser",
-		.level		= DEBUG_PARSER,
+		.level		= NFT_DEBUG_PARSER,
 	},
 	{
 		.name		= "eval",
-		.level		= DEBUG_EVALUATION,
+		.level		= NFT_DEBUG_EVALUATION,
 	},
 	{
 		.name		= "netlink",
-		.level		= DEBUG_NETLINK,
+		.level		= NFT_DEBUG_NETLINK,
 	},
 	{
 		.name		= "mnl",
-		.level		= DEBUG_MNL,
+		.level		= NFT_DEBUG_MNL,
 	},
 	{
 		.name		= "proto-ctx",
-		.level		= DEBUG_PROTO_CTX,
+		.level		= NFT_DEBUG_PROTO_CTX,
 	},
 	{
 		.name		= "segtree",
-		.level		= DEBUG_SEGTREE,
+		.level		= NFT_DEBUG_SEGTREE,
 	},
 	{
 		.name		= "all",
@@ -166,11 +166,11 @@ static const struct {
 int main(int argc, char * const *argv)
 {
 	char *buf = NULL, *filename = NULL;
-	unsigned int len;
+	enum nft_numeric_level numeric;
 	bool interactive = false;
-	int i, val, rc;
-	enum numeric_level numeric;
 	unsigned int debug_mask;
+	unsigned int len;
+	int i, val, rc;
 
 	nft = nft_ctx_new(NFT_CTX_DEFAULT);
 	nft_ctx_set_output(nft, stdout);
@@ -207,10 +207,10 @@ int main(int argc, char * const *argv)
 			break;
 		case OPT_NUMERIC:
 			numeric = nft_ctx_output_get_numeric(nft);
-			if (numeric == NUMERIC_ALL) {
+			if (numeric == NFT_NUMERIC_ALL) {
 				fprintf(stderr, "Too many numeric options "
 						"used, max. %u\n",
-					NUMERIC_ALL);
+					NFT_NUMERIC_ALL);
 				exit(NFT_EXIT_FAILURE);
 			}
 			nft_ctx_output_set_numeric(nft, numeric + 1);
diff --git a/src/meta.c b/src/meta.c
index 56b9e2969974..28aebe396f17 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -206,7 +206,7 @@ static void uid_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	struct passwd *pw;
 
-	if (octx->numeric < NUMERIC_ALL) {
+	if (octx->numeric < NFT_NUMERIC_ALL) {
 		uint32_t uid = mpz_get_uint32(expr->value);
 
 		pw = getpwuid(uid);
@@ -258,7 +258,7 @@ static void gid_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	struct group *gr;
 
-	if (octx->numeric < NUMERIC_ALL) {
+	if (octx->numeric < NFT_NUMERIC_ALL) {
 		uint32_t gid = mpz_get_uint32(expr->value);
 
 		gr = getgrgid(gid);
diff --git a/src/mnl.c b/src/mnl.c
index 808c34bf066b..8db2a1847ec5 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -71,7 +71,7 @@ nft_mnl_talk(struct mnl_ctx *ctx, const void *data, unsigned int len,
 {
 	uint32_t portid = mnl_socket_get_portid(ctx->nf_sock);
 
-	if (ctx->debug_mask & DEBUG_MNL)
+	if (ctx->debug_mask & NFT_DEBUG_MNL)
 		mnl_nlmsg_fprintf(stdout, data, len, sizeof(struct nfgenmsg));
 
 	if (mnl_socket_sendto(ctx->nf_sock, data, len) < 0)
@@ -229,7 +229,7 @@ static ssize_t mnl_nft_socket_sendmsg(const struct netlink_ctx *ctx)
 	nftnl_batch_iovec(ctx->batch, iov, iov_len);
 
 	for (i = 0; i < iov_len; i++) {
-		if (ctx->debug_mask & DEBUG_MNL) {
+		if (ctx->debug_mask & NFT_DEBUG_MNL) {
 			mnl_nlmsg_fprintf(stdout,
 					  iov[i].iov_base, iov[i].iov_len,
 					  sizeof(struct nfgenmsg));
@@ -1122,7 +1122,7 @@ int mnl_nft_event_listener(struct mnl_ctx *ctx,
 			}
 		}
 
-		if (ctx->debug_mask & DEBUG_MNL) {
+		if (ctx->debug_mask & NFT_DEBUG_MNL) {
 			mnl_nlmsg_fprintf(stdout, buf, sizeof(buf),
 					  sizeof(struct nfgenmsg));
 		}
diff --git a/src/netlink.c b/src/netlink.c
index 921788932fc2..abc22504f877 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -472,7 +472,7 @@ int netlink_replace_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
 	if (ctx->octx->echo) {
 		err = cache_update(ctx->nf_sock, ctx->cache,
 				   CMD_INVALID, ctx->msgs,
-				   ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
+				   ctx->debug_mask & NFT_DEBUG_NETLINK, ctx->octx);
 		if (err < 0)
 			return err;
 
@@ -510,7 +510,7 @@ void netlink_dump_rule(const struct nftnl_rule *nlr, struct netlink_ctx *ctx)
 {
 	FILE *fp = ctx->octx->output_fp;
 
-	if (!(ctx->debug_mask & DEBUG_NETLINK) || !fp)
+	if (!(ctx->debug_mask & NFT_DEBUG_NETLINK) || !fp)
 		return;
 
 	nftnl_rule_fprintf(fp, nlr, 0, 0);
@@ -520,7 +520,7 @@ void netlink_dump_rule(const struct nftnl_rule *nlr, struct netlink_ctx *ctx)
 void netlink_dump_expr(const struct nftnl_expr *nle,
 		       FILE *fp, unsigned int debug_mask)
 {
-	if (!(debug_mask & DEBUG_NETLINK))
+	if (!(debug_mask & NFT_DEBUG_NETLINK))
 		return;
 
 	nftnl_expr_fprintf(fp, nle, 0, 0);
@@ -580,7 +580,7 @@ void netlink_dump_chain(const struct nftnl_chain *nlc, struct netlink_ctx *ctx)
 {
 	FILE *fp = ctx->octx->output_fp;
 
-	if (!(ctx->debug_mask & DEBUG_NETLINK) || !fp)
+	if (!(ctx->debug_mask & NFT_DEBUG_NETLINK) || !fp)
 		return;
 
 	nftnl_chain_fprintf(fp, nlc, 0, 0);
@@ -1035,7 +1035,7 @@ void netlink_dump_set(const struct nftnl_set *nls, struct netlink_ctx *ctx)
 {
 	FILE *fp = ctx->octx->output_fp;
 
-	if (!(ctx->debug_mask & DEBUG_NETLINK) || !fp)
+	if (!(ctx->debug_mask & NFT_DEBUG_NETLINK) || !fp)
 		return;
 
 	nftnl_set_fprintf(fp, nls, 0, 0);
@@ -1666,7 +1666,7 @@ void netlink_dump_obj(struct nftnl_obj *nln, struct netlink_ctx *ctx)
 {
 	FILE *fp = ctx->octx->output_fp;
 
-	if (!(ctx->debug_mask & DEBUG_NETLINK) || !fp)
+	if (!(ctx->debug_mask & NFT_DEBUG_NETLINK) || !fp)
 		return;
 
 	nftnl_obj_fprintf(fp, nln, 0, 0);
@@ -2895,7 +2895,7 @@ static const char *nftnl_msgtype2str(uint16_t type)
 
 static void netlink_events_debug(uint16_t type, unsigned int debug_mask)
 {
-	if (!(debug_mask & DEBUG_NETLINK))
+	if (!(debug_mask & NFT_DEBUG_NETLINK))
 		return;
 
 	printf("netlink event: %s\n", nftnl_msgtype2str(type));
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 7016f5b24887..ebcdba5c6624 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -121,9 +121,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %initial-action {
 	location_init(scanner, state, &yylloc);
-	if (nft->debug_mask & DEBUG_SCANNER)
+	if (nft->debug_mask & NFT_DEBUG_SCANNER)
 		nft_set_debug(1, scanner);
-	if (nft->debug_mask & DEBUG_PARSER)
+	if (nft->debug_mask & NFT_DEBUG_PARSER)
 		yydebug = 1;
 }
 
diff --git a/src/proto.c b/src/proto.c
index a72c10c3a168..a54090a3b7bf 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -143,7 +143,7 @@ static void proto_ctx_debug(const struct proto_ctx *ctx, enum proto_bases base,
 {
 	unsigned int i;
 
-	if (!(debug_mask & DEBUG_PROTO_CTX))
+	if (!(debug_mask & NFT_DEBUG_PROTO_CTX))
 		return;
 
 	pr_debug("update %s protocol context:\n", proto_base_names[base]);
diff --git a/src/rule.c b/src/rule.c
index d83284e5414f..948478c96bda 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -134,7 +134,7 @@ static int cache_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 		.cache		= cache,
 		.msgs		= msgs,
 		.seqnum		= cache->seqnum++,
-		.debug_mask	= debug ? DEBUG_NETLINK : 0,
+		.debug_mask	= debug ? NFT_DEBUG_NETLINK : 0,
 		.octx		= octx,
 	};
 	int ret;
diff --git a/src/segtree.c b/src/segtree.c
index f0efd155f0be..8d36cc9b0d65 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -166,7 +166,7 @@ static void __ei_insert(struct seg_tree *tree, struct elementary_interval *new)
 
 static bool segtree_debug(unsigned int debug_mask)
 {
-	if (debug_mask & DEBUG_SEGTREE)
+	if (debug_mask & NFT_DEBUG_SEGTREE)
 		return true;
 
 	return false;
-- 
2.11.0

