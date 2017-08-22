From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/6] src: remove ifdef DEBUG pollution
Date: Tue, 22 Aug 2017 19:05:08 +0200
Message-ID: <1503421511-17814-4-git-send-email-pablo@netfilter.org>
References: <1503421511-17814-1-git-send-email-pablo@netfilter.org>
Cc: phil@nwl.cc, eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40962 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751839AbdHVRFb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2017 13:05:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 21904D25E8
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2017 19:05:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C408A7F3A
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2017 19:05:15 +0200 (CEST)
In-Reply-To: <1503421511-17814-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Get rid of lots of ifdef DEBUG pollution in the code.

The --debug= option is useful to get feedback from users, so it should
be always there. And we really save nothing from keeping this code away
from the control plane with a compile time option. Just running
tests/shell/ before and after this patch, time shows almost no
difference.

So this patch leaves --enable-debug around to add debugging symbols in
your builds, this is left set on by default.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac       |  4 ++--
 include/utils.h    | 12 ------------
 src/evaluate.c     |  8 --------
 src/main.c         | 10 ----------
 src/mnl.c          |  8 --------
 src/netlink.c      | 14 --------------
 src/parser_bison.y |  2 --
 src/proto.c        |  2 --
 src/segtree.c      |  3 +--
 9 files changed, 3 insertions(+), 60 deletions(-)

diff --git a/configure.ac b/configure.ac
index bef6c0b631df..2570b03a91ef 100644
--- a/configure.ac
+++ b/configure.ac
@@ -23,7 +23,7 @@ AC_DEFINE([_GNU_SOURCE], [], [Enable various GNU extensions])
 AC_DEFINE([_STDC_FORMAT_MACROS], [], [printf-style format macros])
 
 AC_ARG_ENABLE([debug],
-	      AS_HELP_STRING([--enable-debug], [Disable debugging]),
+	      AS_HELP_STRING([--enable-debug], [Disable debugging symbols]),
 	      AS_IF([test "x$enable_debug" = "xno"], [with_debug=no], [with_debug=yes]),
 	      [with_debug=yes])
 AC_SUBST(with_debug)
@@ -155,7 +155,7 @@ AC_OUTPUT
 echo "
 nft configuration:
   cli support:			${with_cli}
-  enable debugging:		${with_debug}
+  enable debugging symbols:	${with_debug}
   use mini-gmp:			${with_mini_gmp}
   enable pdf documentation:	${enable_pdf_doc}
   libxtables support:		${with_libxtables}"
diff --git a/include/utils.h b/include/utils.h
index 0605eeed3b06..369195240e24 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -13,17 +13,9 @@
 
 #define BITS_PER_BYTE	8
 
-#if defined(DEBUG)
 #define pr_debug(fmt, arg...) printf(fmt, ##arg)
-#else
-#define pr_debug(fmt, arg...) ({ if (false) {}; 0; })
-#endif
 
-#if defined(DEBUG) && defined(HAVE_LIBGMP)
 #define pr_gmp_debug(fmt, arg...) gmp_printf(fmt, ##arg)
-#else
-#define pr_gmp_debug(fmt, arg...) ({ if (false) {}; 0; })
-#endif
 
 #define __fmtstring(x, y)	__attribute__((format(printf, x, y)))
 #if 0
@@ -35,11 +27,7 @@
 #define __must_check		__attribute__((warn_unused_result))
 #define __noreturn		__attribute__((__noreturn__))
 
-#ifdef DEBUG
 #define BUG(fmt, arg...)	({ fprintf(stderr, "BUG: " fmt, ##arg); assert(0); })
-#else
-#define BUG(fmt, arg...)	assert(0)
-#endif
 
 #define BUILD_BUG_ON(condition)	((void)sizeof(char[1 - 2*!!(condition)]))
 #define BUILD_BUG_ON_ZERO(e)	(sizeof(char[1 - 2 * !!(e)]) - 1)
diff --git a/src/evaluate.c b/src/evaluate.c
index f52a0843a0c0..c1ad05b7ad86 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1708,7 +1708,6 @@ static int expr_evaluate_meta(struct eval_ctx *ctx, struct expr **exprp)
 
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 {
-#ifdef DEBUG
 	if (debug_level & DEBUG_EVALUATION) {
 		struct error_record *erec;
 		erec = erec_create(EREC_INFORMATIONAL, &(*expr)->location,
@@ -1717,7 +1716,6 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		expr_print(*expr, &octx_debug_dummy);
 		printf("\n\n");
 	}
-#endif
 
 	switch ((*expr)->ops->type) {
 	case EXPR_SYMBOL:
@@ -2678,7 +2676,6 @@ static int stmt_evaluate_objref(struct eval_ctx *ctx, struct stmt *stmt)
 
 int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 {
-#ifdef DEBUG
 	if (debug_level & DEBUG_EVALUATION) {
 		struct error_record *erec;
 		erec = erec_create(EREC_INFORMATIONAL, &stmt->location,
@@ -2686,7 +2683,6 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		erec_print(stdout, erec); stmt_print(stmt, &octx_debug_dummy);
 		printf("\n\n");
 	}
-#endif
 
 	switch (stmt->ops->type) {
 	case STMT_COUNTER:
@@ -3326,7 +3322,6 @@ static int cmd_evaluate_export(struct eval_ctx *ctx, struct cmd *cmd)
 	return cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs);
 }
 
-#ifdef DEBUG
 static const char *cmd_op_name[] = {
 	[CMD_INVALID]	= "invalid",
 	[CMD_ADD]	= "add",
@@ -3349,11 +3344,9 @@ static const char *cmd_op_to_name(enum cmd_ops op)
 
 	return cmd_op_name[op];
 }
-#endif
 
 int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 {
-#ifdef DEBUG
 	if (debug_level & DEBUG_EVALUATION) {
 		struct error_record *erec;
 
@@ -3361,7 +3354,6 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 				   "Evaluate %s", cmd_op_to_name(cmd->op));
 		erec_print(stdout, erec); printf("\n\n");
 	}
-#endif
 
 	ctx->cmd = cmd;
 	switch (cmd->op) {
diff --git a/src/main.c b/src/main.c
index fc44b186d5f0..4c74bdce2824 100644
--- a/src/main.c
+++ b/src/main.c
@@ -29,9 +29,7 @@
 #include <cli.h>
 
 static struct nft_ctx nft;
-#ifdef DEBUG
 unsigned int debug_level;
-#endif
 
 enum opt_vals {
 	OPT_HELP		= 'h',
@@ -90,13 +88,11 @@ static const struct option options[] = {
 		.val		= OPT_INCLUDEPATH,
 		.has_arg	= 1,
 	},
-#ifdef DEBUG
 	{
 		.name		= "debug",
 		.val		= OPT_DEBUG,
 		.has_arg	= 1,
 	},
-#endif
 	{
 		.name		= "handle",
 		.val		= OPT_HANDLE_OUTPUT,
@@ -131,14 +127,11 @@ static void show_help(const char *name)
 "  -a, --handle			Output rule handle.\n"
 "  -e, --echo			Echo what has been added, inserted or replaced.\n"
 "  -I, --includepath <directory>	Add <directory> to the paths searched for include files. Default is: %s\n"
-#ifdef DEBUG
 "  --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)\n"
-#endif
 "\n",
 	name, DEFAULT_INCLUDE_PATH);
 }
 
-#ifdef DEBUG
 static const struct {
 	const char		*name;
 	enum debug_level	level;
@@ -176,7 +169,6 @@ static const struct {
 		.level		= ~0,
 	},
 };
-#endif
 
 static const struct input_descriptor indesc_cmdline = {
 	.type	= INDESC_BUFFER,
@@ -359,7 +351,6 @@ int main(int argc, char * const *argv)
 		case OPT_IP2NAME:
 			nft.output.ip2name++;
 			break;
-#ifdef DEBUG
 		case OPT_DEBUG:
 			for (;;) {
 				unsigned int i;
@@ -387,7 +378,6 @@ int main(int argc, char * const *argv)
 				optarg = end + 1;
 			}
 			break;
-#endif
 		case OPT_HANDLE_OUTPUT:
 			nft.output.handle++;
 			break;
diff --git a/src/mnl.c b/src/mnl.c
index f5859c989f3c..f57982da1bc5 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -72,10 +72,8 @@ nft_mnl_talk(struct mnl_socket *nf_sock, const void *data,
 {
 	uint32_t portid = mnl_socket_get_portid(nf_sock);
 
-#ifdef DEBUG
 	if (debug_level & DEBUG_MNL)
 		mnl_nlmsg_fprintf(stdout, data, len, sizeof(struct nfgenmsg));
-#endif
 
 	if (mnl_socket_sendto(nf_sock, data, len) < 0)
 		return -1;
@@ -223,14 +221,11 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl,
 		.msg_iov	= iov,
 		.msg_iovlen	= iov_len,
 	};
-#ifdef DEBUG
 	uint32_t i;
-#endif
 
 	mnl_set_sndbuffer(nl, batch);
 	nftnl_batch_iovec(batch, iov, iov_len);
 
-#ifdef DEBUG
 	for (i = 0; i < iov_len; i++) {
 		if (debug_level & DEBUG_MNL) {
 			mnl_nlmsg_fprintf(stdout,
@@ -238,7 +233,6 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl,
 					  sizeof(struct nfgenmsg));
 		}
 	}
-#endif
 
 	return sendmsg(mnl_socket_get_fd(nl), &msg, 0);
 }
@@ -1072,12 +1066,10 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock,
 			}
 		}
 
-#ifdef DEBUG
 		if (debug_level & DEBUG_MNL) {
 			mnl_nlmsg_fprintf(stdout, buf, sizeof(buf),
 					  sizeof(struct nfgenmsg));
 		}
-#endif /* DEBUG */
 		ret = mnl_cb_run(buf, ret, 0, 0, cb, cb_data);
 		if (ret <= 0)
 			break;
diff --git a/src/netlink.c b/src/netlink.c
index f6eb08fd8d41..7730b724d4ac 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -504,7 +504,6 @@ int netlink_del_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
 
 void netlink_dump_rule(const struct nftnl_rule *nlr)
 {
-#ifdef DEBUG
 	char buf[4096];
 
 	if (!(debug_level & DEBUG_NETLINK))
@@ -512,12 +511,10 @@ void netlink_dump_rule(const struct nftnl_rule *nlr)
 
 	nftnl_rule_snprintf(buf, sizeof(buf), nlr, 0, 0);
 	fprintf(stdout, "%s\n", buf);
-#endif
 }
 
 void netlink_dump_expr(const struct nftnl_expr *nle)
 {
-#ifdef DEBUG
 	char buf[4096];
 
 	if (!(debug_level & DEBUG_NETLINK))
@@ -525,7 +522,6 @@ void netlink_dump_expr(const struct nftnl_expr *nle)
 
 	nftnl_expr_snprintf(buf, sizeof(buf), nle, 0, 0);
 	fprintf(stdout, "%s\n", buf);
-#endif
 }
 
 static int list_rule_cb(struct nftnl_rule *nlr, void *arg)
@@ -579,7 +575,6 @@ static int netlink_flush_rules(struct netlink_ctx *ctx, const struct handle *h,
 
 void netlink_dump_chain(const struct nftnl_chain *nlc)
 {
-#ifdef DEBUG
 	char buf[4096];
 
 	if (!(debug_level & DEBUG_NETLINK))
@@ -587,7 +582,6 @@ void netlink_dump_chain(const struct nftnl_chain *nlc)
 
 	nftnl_chain_snprintf(buf, sizeof(buf), nlc, 0, 0);
 	fprintf(stdout, "%s\n", buf);
-#endif
 }
 
 static int netlink_add_chain_compat(struct netlink_ctx *ctx,
@@ -1036,7 +1030,6 @@ static const struct datatype *dtype_map_from_kernel(enum nft_data_types type)
 
 void netlink_dump_set(const struct nftnl_set *nls)
 {
-#ifdef DEBUG
 	char buf[4096];
 
 	if (!(debug_level & DEBUG_NETLINK))
@@ -1044,7 +1037,6 @@ void netlink_dump_set(const struct nftnl_set *nls)
 
 	nftnl_set_snprintf(buf, sizeof(buf), nls, 0, 0);
 	fprintf(stdout, "%s\n", buf);
-#endif
 }
 
 static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
@@ -1661,7 +1653,6 @@ out:
 
 void netlink_dump_obj(struct nftnl_obj *nln)
 {
-#ifdef DEBUG
 	char buf[4096];
 
 	if (!(debug_level & DEBUG_NETLINK))
@@ -1669,7 +1660,6 @@ void netlink_dump_obj(struct nftnl_obj *nln)
 
 	nftnl_obj_snprintf(buf, sizeof(buf), nln, 0, 0);
 	fprintf(stdout, "%s\n", buf);
-#endif
 }
 
 int netlink_add_obj(struct netlink_ctx *ctx, const struct handle *h,
@@ -2854,7 +2844,6 @@ static int netlink_events_trace_cb(const struct nlmsghdr *nlh, int type,
 	return MNL_CB_OK;
 }
 
-#ifdef DEBUG
 /* only those which could be useful listening to events */
 static const char *const nftnl_msg_types[NFT_MSG_MAX] = {
 	[NFT_MSG_NEWTABLE]	= "NFT_MSG_NEWTABLE",
@@ -2880,16 +2869,13 @@ static const char *nftnl_msgtype2str(uint16_t type)
 
 	return nftnl_msg_types[type];
 }
-#endif /* DEBUG */
 
 static void netlink_events_debug(uint16_t type)
 {
-#ifdef DEBUG
 	if (!(debug_level & DEBUG_NETLINK))
 		return;
 
 	printf("netlink event: %s\n", nftnl_msgtype2str(type));
-#endif /* DEBUG */
 }
 
 static int netlink_events_newgen_cb(const struct nlmsghdr *nlh, int type,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 7c00f4f099f7..76a0115d46a2 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -118,12 +118,10 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %initial-action {
 	location_init(scanner, state, &yylloc);
-#ifdef DEBUG
 	if (debug_level & DEBUG_SCANNER)
 		nft_set_debug(1, scanner);
 	if (debug_level & DEBUG_PARSER)
 		yydebug = 1;
-#endif
 }
 
 %union {
diff --git a/src/proto.c b/src/proto.c
index 7ac0ee03191a..045f2d811969 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -140,7 +140,6 @@ const struct hook_proto_desc hook_proto_desc[] = {
 
 static void proto_ctx_debug(const struct proto_ctx *ctx, enum proto_bases base)
 {
-#ifdef DEBUG
 	unsigned int i;
 
 	if (!(debug_level & DEBUG_PROTO_CTX))
@@ -159,7 +158,6 @@ static void proto_ctx_debug(const struct proto_ctx *ctx, enum proto_bases base)
 		pr_debug("\n");
 	}
 	pr_debug("\n");
-#endif
 }
 
 /**
diff --git a/src/segtree.c b/src/segtree.c
index 34a001613eab..8623e862cf77 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -163,10 +163,9 @@ static void __ei_insert(struct seg_tree *tree, struct elementary_interval *new)
 
 static bool segtree_debug(void)
 {
-#ifdef DEBUG
 	if (debug_level & DEBUG_SEGTREE)
 		return true;
-#endif
+
 	return false;
 }
 
-- 
2.1.4


