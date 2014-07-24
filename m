From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: add level option to the log statement
Date: Fri, 25 Jul 2014 01:01:01 +0200
Message-ID: <1406242861-11855-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57430 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbaGXXA6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:00:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch is required if you use upcoming Linux kernels >= 3.17
which comes with a complete logging support for nf_tables.

If you use 'log' without options, the kernel logging buffer is used:

nft> add rule filter input log

You can also specify the logging prefix string:

nft> add rule filter input log prefix "input: "

You may want to specify the log level:

nft> add rule filter input log prefix "input: " level notice

By default, if not specified, the default level is 'warn' (just like
in iptables).

If you specify the group, then nft uses the nfnetlink_log instead:

nft> add rule filter input log prefix "input: " group 10

You can also specify the snaplen and qthreshold for the nfnetlink_log.
But you cannot mix level and group at the same time, they are mutually
exclusive.

Default values for both snaplen and qthreshold are 0 (just like in
iptables).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/statement.h       |   10 ++++++++++
 src/evaluate.c            |   15 ++++++++++++++-
 src/netlink_delinearize.c |   28 +++++++++++++++++++++++-----
 src/netlink_linearize.c   |   18 +++++++++---------
 src/parser.y              |   32 ++++++++++++++++++++++++++++++++
 src/scanner.l             |    1 +
 src/statement.c           |   31 +++++++++++++++++++++++++++----
 7 files changed, 116 insertions(+), 19 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 480b719..12336bc 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -28,11 +28,21 @@ extern struct stmt *meta_stmt_alloc(const struct location *loc,
 				    enum nft_meta_keys key,
 				    struct expr *expr);
 
+enum {
+	STMT_LOG_PREFIX		= (1 << 0),
+	STMT_LOG_SNAPLEN	= (1 << 1),
+	STMT_LOG_GROUP		= (1 << 2),
+	STMT_LOG_QTHRESHOLD	= (1 << 3),
+	STMT_LOG_LEVEL		= (1 << 4),
+};
+
 struct log_stmt {
 	const char		*prefix;
 	unsigned int		snaplen;
 	uint16_t		group;
 	uint16_t		qthreshold;
+	uint32_t		level;
+	uint32_t		flags;
 };
 
 extern struct stmt *log_stmt_alloc(const struct location *loc);
diff --git a/src/evaluate.c b/src/evaluate.c
index e05473a..f66a8ea 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1180,6 +1180,18 @@ static int stmt_evaluate_ct(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int stmt_evaluate_log(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	if (stmt->log.flags & STMT_LOG_LEVEL &&
+	    (stmt->log.flags & STMT_LOG_GROUP	||
+	     stmt->log.flags & STMT_LOG_SNAPLEN	||
+	     stmt->log.flags & STMT_LOG_QTHRESHOLD)) {
+		return stmt_error(ctx, stmt,
+				  "level and group are mutually exclusive");
+	}
+	return 0;
+}
+
 static int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 {
 #ifdef DEBUG
@@ -1193,7 +1205,6 @@ static int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 	switch (stmt->ops->type) {
 	case STMT_COUNTER:
 	case STMT_LIMIT:
-	case STMT_LOG:
 		return 0;
 	case STMT_EXPRESSION:
 		return stmt_evaluate_expr(ctx, stmt);
@@ -1201,6 +1212,8 @@ static int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_verdict(ctx, stmt);
 	case STMT_META:
 		return stmt_evaluate_meta(ctx, stmt);
+	case STMT_LOG:
+		return stmt_evaluate_log(ctx, stmt);
 	case STMT_REJECT:
 		return stmt_evaluate_reject(ctx, stmt);
 	case STMT_NAT:
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 5c6ca80..195d432 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -428,12 +428,30 @@ static void netlink_parse_log(struct netlink_parse_ctx *ctx,
 
 	stmt = log_stmt_alloc(loc);
 	prefix = nft_rule_expr_get_str(nle, NFT_EXPR_LOG_PREFIX);
-	if (prefix != NULL)
+	if (nft_rule_expr_is_set(nle, NFT_EXPR_LOG_PREFIX)) {
 		stmt->log.prefix = xstrdup(prefix);
-	stmt->log.group = nft_rule_expr_get_u16(nle, NFT_EXPR_LOG_GROUP);
-	stmt->log.snaplen = nft_rule_expr_get_u32(nle, NFT_EXPR_LOG_SNAPLEN);
-	stmt->log.qthreshold =
-		nft_rule_expr_get_u16(nle, NFT_EXPR_LOG_QTHRESHOLD);
+		stmt->log.flags |= STMT_LOG_PREFIX;
+	}
+	if (nft_rule_expr_is_set(nle, NFT_EXPR_LOG_GROUP)) {
+		stmt->log.group =
+			nft_rule_expr_get_u16(nle, NFT_EXPR_LOG_GROUP);
+		stmt->log.flags |= STMT_LOG_GROUP;
+	}
+	if (nft_rule_expr_is_set(nle, NFT_EXPR_LOG_SNAPLEN)) {
+		stmt->log.snaplen =
+			nft_rule_expr_get_u32(nle, NFT_EXPR_LOG_SNAPLEN);
+		stmt->log.flags |= STMT_LOG_SNAPLEN;
+	}
+	if (nft_rule_expr_is_set(nle, NFT_EXPR_LOG_QTHRESHOLD)) {
+		stmt->log.qthreshold =
+			nft_rule_expr_get_u16(nle, NFT_EXPR_LOG_QTHRESHOLD);
+		stmt->log.flags |= STMT_LOG_QTHRESHOLD;
+	}
+	if (nft_rule_expr_is_set(nle, NFT_EXPR_LOG_LEVEL)) {
+		stmt->log.level =
+			nft_rule_expr_get_u32(nle, NFT_EXPR_LOG_LEVEL);
+		stmt->log.flags |= STMT_LOG_LEVEL;
+	}
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 5c1b46d..075e243 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -576,17 +576,17 @@ static void netlink_gen_log_stmt(struct netlink_linearize_ctx *ctx,
 		nft_rule_expr_set_str(nle, NFT_EXPR_LOG_PREFIX,
 				      stmt->log.prefix);
 	}
-	if (stmt->log.group) {
+	if (stmt->log.flags & STMT_LOG_GROUP) {
 		nft_rule_expr_set_u16(nle, NFT_EXPR_LOG_GROUP,
 				      stmt->log.group);
-	}
-	if (stmt->log.snaplen) {
-		nft_rule_expr_set_u32(nle, NFT_EXPR_LOG_SNAPLEN,
-				      stmt->log.snaplen);
-	}
-	if (stmt->log.qthreshold) {
-		nft_rule_expr_set_u16(nle, NFT_EXPR_LOG_QTHRESHOLD,
-				      stmt->log.qthreshold);
+		if (stmt->log.flags & STMT_LOG_SNAPLEN)
+			nft_rule_expr_set_u32(nle, NFT_EXPR_LOG_SNAPLEN,
+					      stmt->log.snaplen);
+		if (stmt->log.flags & STMT_LOG_QTHRESHOLD)
+			nft_rule_expr_set_u16(nle, NFT_EXPR_LOG_QTHRESHOLD,
+					      stmt->log.qthreshold);
+	} else {
+		nft_rule_expr_set_u32(nle, NFT_EXPR_LOG_LEVEL, stmt->log.level);
 	}
 	nft_rule_add_expr(ctx->nlr, nle);
 }
diff --git a/src/parser.y b/src/parser.y
index 3e08e21..50c35ae 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -13,6 +13,7 @@
 #include <stddef.h>
 #include <stdio.h>
 #include <inttypes.h>
+#include <syslog.h>
 #include <netinet/ip.h>
 #include <netinet/if_ether.h>
 #include <linux/netfilter.h>
@@ -345,6 +346,7 @@ static int monitor_lookup_event(const char *event)
 %token GROUP			"group"
 %token SNAPLEN			"snaplen"
 %token QUEUE_THRESHOLD		"queue-threshold"
+%token LEVEL			"level"
 
 %token LIMIT			"limit"
 %token RATE			"rate"
@@ -1366,18 +1368,48 @@ log_args		:	log_arg
 log_arg			:	PREFIX			string
 			{
 				$<stmt>0->log.prefix	 = $2;
+				$<stmt>0->log.flags |= STMT_LOG_PREFIX;
 			}
 			|	GROUP			NUM
 			{
 				$<stmt>0->log.group	 = $2;
+				$<stmt>0->log.flags |= STMT_LOG_GROUP;
 			}
 			|	SNAPLEN			NUM
 			{
 				$<stmt>0->log.snaplen	 = $2;
+				$<stmt>0->log.flags |= STMT_LOG_SNAPLEN;
 			}
 			|	QUEUE_THRESHOLD		NUM
 			{
 				$<stmt>0->log.qthreshold = $2;
+				$<stmt>0->log.flags |= STMT_LOG_QTHRESHOLD;
+			}
+			|	LEVEL		STRING
+			{
+				if (strcmp($2, "emerg") == 0) {
+					$<stmt>0->log.level = LOG_EMERG;
+				} else if (strcmp($2, "alert") == 0) {
+					$<stmt>0->log.level = LOG_ALERT;
+				} else if (strcmp($2, "crit") == 0) {
+					$<stmt>0->log.level = LOG_CRIT;
+				} else if (strcmp($2, "err") == 0) {
+					$<stmt>0->log.level = LOG_ERR;
+				} else if (strcmp($2, "warn") == 0) {
+					$<stmt>0->log.level = LOG_WARNING;
+				} else if (strcmp($2, "notice") == 0) {
+					$<stmt>0->log.level = LOG_NOTICE;
+				} else if (strcmp($2, "info") == 0) {
+					$<stmt>0->log.level = LOG_INFO;
+				} else if (strcmp($2, "debug") == 0) {
+					$<stmt>0->log.level = LOG_DEBUG;
+				} else {
+					erec_queue(error(&@2,
+							 "invalid syslog level %s",
+							 $2), state->msgs);
+					YYERROR;
+				}
+				$<stmt>0->log.flags |= STMT_LOG_LEVEL;
 			}
 			;
 
diff --git a/src/scanner.l b/src/scanner.l
index 73a1a3f..b0eecd3 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -276,6 +276,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "group"			{ return GROUP; }
 "snaplen"		{ return SNAPLEN; }
 "queue-threshold"	{ return QUEUE_THRESHOLD; }
+"level"			{ return LEVEL; }
 
 "queue"			{ return QUEUE;}
 "num"			{ return QUEUENUM;}
diff --git a/src/statement.c b/src/statement.c
index 2dd3f18..4be6625 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -14,6 +14,7 @@
 #include <stdint.h>
 #include <inttypes.h>
 #include <string.h>
+#include <syslog.h>
 
 #include <statement.h>
 #include <utils.h>
@@ -112,17 +113,39 @@ struct stmt *counter_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &counter_stmt_ops);
 }
 
+static const char *syslog_level[LOG_DEBUG + 1] = {
+	[LOG_EMERG]	= "emerg",
+	[LOG_ALERT]	= "alert",
+	[LOG_CRIT]	= "crit",
+	[LOG_ERR]       = "err",
+	[LOG_WARNING]	= "warn",
+	[LOG_NOTICE]	= "notice",
+	[LOG_INFO]	= "info",
+	[LOG_DEBUG]	= "debug",
+};
+
+static const char *log_level(uint32_t level)
+{
+	if (level > LOG_DEBUG)
+		return "unknown";
+
+	return syslog_level[level];
+}
+
 static void log_stmt_print(const struct stmt *stmt)
 {
 	printf("log");
-	if (stmt->log.prefix != NULL)
+	if (stmt->log.flags & STMT_LOG_PREFIX)
 		printf(" prefix \"%s\"", stmt->log.prefix);
-	if (stmt->log.group)
+	if (stmt->log.flags & STMT_LOG_GROUP)
 		printf(" group %u", stmt->log.group);
-	if (stmt->log.snaplen)
+	if (stmt->log.flags & STMT_LOG_SNAPLEN)
 		printf(" snaplen %u", stmt->log.snaplen);
-	if (stmt->log.qthreshold)
+	if (stmt->log.flags & STMT_LOG_QTHRESHOLD)
 		printf(" queue-threshold %u", stmt->log.qthreshold);
+	if ((stmt->log.flags & STMT_LOG_LEVEL) &&
+	    stmt->log.level != LOG_WARNING)
+		printf(" level %s", log_level(stmt->log.level));
 }
 
 static void log_stmt_destroy(struct stmt *stmt)
-- 
1.7.10.4

