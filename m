From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft 1/3] src: add log flags syntax support
Date: Sun, 25 Sep 2016 17:06:59 +0800
Message-ID: <1474794421-5365-2-git-send-email-zlpnobody@163.com>
References: <1474794421-5365-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:43126 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752990AbcIYJHs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 05:07:48 -0400
In-Reply-To: <1474794421-5365-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Now NF_LOG_XXX is exposed to the userspace, we can set it explicitly.
Like iptables LOG target, we can log TCP sequence numbers, TCP options,
IP options, UID owning local socket and decode MAC header. Note the
log flags are mutually exclusive with group.

Some examples are listed below:
  # nft add rule filter output log uid
  # nft add rule filter output log tcpopt,ipopt,uid
  # nft add rule filter output log level debug tcpseq,uid,macdecode
  # nft add rule filter output log group 0 uid
  <cmdline>:1:24-26: Error: flags and group are mutually exclusive
  add rule filter OUTPUT log group 0 uid
                         ^^^

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 include/linux/netfilter/nf_log.h | 12 ++++++++++++
 include/statement.h              |  1 +
 src/evaluate.c                   | 12 +++++++++---
 src/netlink_delinearize.c        |  4 ++++
 src/netlink_linearize.c          |  3 +++
 src/parser_bison.y               | 26 +++++++++++++++++++++++++-
 src/scanner.l                    |  5 +++++
 src/statement.c                  | 24 ++++++++++++++++++++++++
 8 files changed, 83 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/netfilter/nf_log.h

diff --git a/include/linux/netfilter/nf_log.h b/include/linux/netfilter/nf_log.h
new file mode 100644
index 0000000..8be21e0
--- /dev/null
+++ b/include/linux/netfilter/nf_log.h
@@ -0,0 +1,12 @@
+#ifndef _NETFILTER_NF_LOG_H
+#define _NETFILTER_NF_LOG_H
+
+#define NF_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
+#define NF_LOG_TCPOPT		0x02	/* Log TCP options */
+#define NF_LOG_IPOPT		0x04	/* Log IP options */
+#define NF_LOG_UID		0x08	/* Log UID owning local socket */
+#define NF_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
+#define NF_LOG_MACDECODE	0x20	/* Decode MAC header */
+#define NF_LOG_MASK		0x2f
+
+#endif /* _NETFILTER_NF_LOG_H */
diff --git a/include/statement.h b/include/statement.h
index e278b70..ffbe9e2 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -50,6 +50,7 @@ struct log_stmt {
 	uint16_t		group;
 	uint16_t		qthreshold;
 	uint32_t		level;
+	uint32_t		logflags;
 	uint32_t		flags;
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 45af329..429628b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2395,12 +2395,18 @@ static int stmt_evaluate_queue(struct eval_ctx *ctx, struct stmt *stmt)
 static int stmt_evaluate_log(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	if (stmt->log.flags & STMT_LOG_LEVEL &&
-	    (stmt->log.flags & STMT_LOG_GROUP	||
-	     stmt->log.flags & STMT_LOG_SNAPLEN	||
-	     stmt->log.flags & STMT_LOG_QTHRESHOLD)) {
+	    stmt->log.flags & (STMT_LOG_GROUP | STMT_LOG_SNAPLEN |
+			       STMT_LOG_QTHRESHOLD)) {
 		return stmt_error(ctx, stmt,
 				  "level and group are mutually exclusive");
 	}
+
+	if (stmt->log.logflags &&
+	    stmt->log.flags & (STMT_LOG_GROUP | STMT_LOG_SNAPLEN |
+			       STMT_LOG_QTHRESHOLD)) {
+		return stmt_error(ctx, stmt,
+				  "flags and group are mutually exclusive");
+	}
 	return 0;
 }
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 6bb27b6..f47ccfb 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -657,6 +657,10 @@ static void netlink_parse_log(struct netlink_parse_ctx *ctx,
 			nftnl_expr_get_u32(nle, NFTNL_EXPR_LOG_LEVEL);
 		stmt->log.flags |= STMT_LOG_LEVEL;
 	}
+	if (nftnl_expr_is_set(nle, NFTNL_EXPR_LOG_FLAGS)) {
+		stmt->log.logflags =
+			nftnl_expr_get_u32(nle, NFTNL_EXPR_LOG_FLAGS);
+	}
 
 	ctx->stmt = stmt;
 }
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 558deb2..f14ecfe 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -805,6 +805,9 @@ static void netlink_gen_log_stmt(struct netlink_linearize_ctx *ctx,
 		if (stmt->log.flags & STMT_LOG_LEVEL)
 			nftnl_expr_set_u32(nle, NFTNL_EXPR_LOG_LEVEL,
 					   stmt->log.level);
+		if (stmt->log.logflags)
+			nftnl_expr_set_u32(nle, NFTNL_EXPR_LOG_FLAGS,
+					   stmt->log.logflags);
 	}
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
diff --git a/src/parser_bison.y b/src/parser_bison.y
index aac10dc..515349f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -20,6 +20,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 #include <linux/netfilter/nf_nat.h>
+#include <linux/netfilter/nf_log.h>
 #include <netinet/ip_icmp.h>
 #include <netinet/icmp6.h>
 #include <libnftnl/common.h>
@@ -369,6 +370,11 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token LEVEL_NOTICE		"notice"
 %token LEVEL_INFO		"info"
 %token LEVEL_DEBUG		"debug"
+%token TCPSEQ			"tcpseq"
+%token TCPOPT			"tcpopt"
+%token IPOPT			"ipopt"
+%token UID			"uid"
+%token MACDECODE		"macdecode"
 
 %token LIMIT			"limit"
 %token RATE			"rate"
@@ -474,7 +480,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { stmt_free($$); }	meta_stmt
 %type <stmt>			log_stmt log_stmt_alloc
 %destructor { stmt_free($$); }	log_stmt log_stmt_alloc
-%type <val>			level_type
+%type <val>			level_type log_stmt_flags log_stmt_flag
 %type <stmt>			limit_stmt quota_stmt
 %destructor { stmt_free($$); }	limit_stmt quota_stmt
 %type <val>			limit_burst limit_mode time_unit quota_mode
@@ -1515,6 +1521,10 @@ log_arg			:	PREFIX			string
 				$<stmt>0->log.level	= $2;
 				$<stmt>0->log.flags 	|= STMT_LOG_LEVEL;
 			}
+			|	log_stmt_flags
+			{
+				$<stmt>0->log.logflags	|= $1;
+			}
 			;
 
 level_type		:	LEVEL_EMERG	{ $$ = LOG_EMERG; }
@@ -1527,6 +1537,20 @@ level_type		:	LEVEL_EMERG	{ $$ = LOG_EMERG; }
 			|	LEVEL_DEBUG	{ $$ = LOG_DEBUG; }
 			;
 
+log_stmt_flags		:	log_stmt_flag
+			|	log_stmt_flags	COMMA	log_stmt_flag
+			{
+				$$ = $1 | $3;
+			}
+			;
+
+log_stmt_flag		:	TCPSEQ		{ $$ = NF_LOG_TCPSEQ; }
+			|	TCPOPT		{ $$ = NF_LOG_TCPOPT; }
+			|	IPOPT		{ $$ = NF_LOG_IPOPT; }
+			|	UID		{ $$ = NF_LOG_UID; }
+			|	MACDECODE	{ $$ = NF_LOG_MACDECODE; }
+			;
+
 limit_stmt		:	LIMIT	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst
 	    		{
 				$$ = limit_stmt_alloc(&@$);
diff --git a/src/scanner.l b/src/scanner.l
index 8b5a383..17b987a 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -307,6 +307,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "notice"		{ return LEVEL_NOTICE; }
 "info"			{ return LEVEL_INFO; }
 "debug"			{ return LEVEL_DEBUG; }
+"tcpseq"		{ return TCPSEQ; }
+"tcpopt"		{ return TCPOPT; }
+"ipopt"			{ return IPOPT; }
+"uid"			{ return UID; }
+"macdecode"		{ return MACDECODE; }
 
 "queue"			{ return QUEUE;}
 "num"			{ return QUEUENUM;}
diff --git a/src/statement.c b/src/statement.c
index 8ccd489..f5a659f 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -27,6 +27,7 @@
 
 #include <netinet/in.h>
 #include <linux/netfilter/nf_nat.h>
+#include <linux/netfilter/nf_log.h>
 
 struct stmt *stmt_alloc(const struct location *loc,
 			const struct stmt_ops *ops)
@@ -181,6 +182,8 @@ static const char *log_level(uint32_t level)
 
 static void log_stmt_print(const struct stmt *stmt)
 {
+	const char *delim = " ";
+
 	printf("log");
 	if (stmt->log.flags & STMT_LOG_PREFIX)
 		printf(" prefix \"%s\"", stmt->log.prefix);
@@ -193,6 +196,27 @@ static void log_stmt_print(const struct stmt *stmt)
 	if ((stmt->log.flags & STMT_LOG_LEVEL) &&
 	    stmt->log.level != LOG_WARNING)
 		printf(" level %s", log_level(stmt->log.level));
+
+	if (stmt->log.logflags) {
+		if (stmt->log.logflags & NF_LOG_TCPSEQ) {
+			printf("%stcpseq", delim);
+			delim = ",";
+		}
+		if (stmt->log.logflags & NF_LOG_TCPOPT) {
+			printf("%stcpopt", delim);
+			delim = ",";
+		}
+		if (stmt->log.logflags & NF_LOG_IPOPT) {
+			printf("%sipopt", delim);
+			delim = ",";
+		}
+		if (stmt->log.logflags & NF_LOG_UID) {
+			printf("%suid", delim);
+			delim = ",";
+		}
+		if (stmt->log.logflags & NF_LOG_MACDECODE)
+			printf("%smacdecode", delim);
+	}
 }
 
 static void log_stmt_destroy(struct stmt *stmt)
-- 
2.5.5


