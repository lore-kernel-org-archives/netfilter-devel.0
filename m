From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH] Add support for queue target
Date: Sat, 30 Nov 2013 11:57:56 +0100
Message-ID: <1385809076-20160-1-git-send-email-eric@regit.org>
References: <1385808722.4321.19.camel@ice-age2.regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:38784 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3K3K6U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Nov 2013 05:58:20 -0500
In-Reply-To: <1385808722.4321.19.camel@ice-age2.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for the queue target. It is now possible
to specify rule sending packet to a given queue and using
load balancing:
  nft add rule filter output queue num 3 total 2 options fanout

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/linux/netfilter/nf_tables.h | 20 ++++++++++++
 include/statement.h                 | 11 +++++++
 src/evaluate.c                      |  2 ++
 src/netlink_delinearize.c           | 15 +++++++++
 src/netlink_linearize.c             | 22 +++++++++++++
 src/parser.y                        | 61 ++++++++++++++++++++++++++++++++++---
 src/scanner.l                       |  8 ++++-
 src/statement.c                     | 31 +++++++++++++++++++
 8 files changed, 164 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index a236cc3..1d5a925 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -587,6 +587,26 @@ enum nft_log_attributes {
 #define NFTA_LOG_MAX		(__NFTA_LOG_MAX - 1)
 
 /**
+ * enum nft_queue_attributes - nf_tables queue expression netlink attributes
+ *
+ * @NFTA_QUEUE_NUM: netlink group to send messages to (NLA_U32)
+ * @NFTA_QUEUE_TOTAL: prefix to prepend to log messages (NLA_STRING)
+ * @NFTA_QUEUE_FLAGS: length of payload to include in netlink message (NLA_U32)
+ */
+enum nft_queue_attributes {
+	NFTA_QUEUE_UNSPEC,
+	NFTA_QUEUE_NUM,
+	NFTA_QUEUE_TOTAL,
+	NFTA_QUEUE_FLAGS,
+	__NFTA_QUEUE_MAX
+};
+#define NFTA_QUEUE_MAX		(__NFTA_QUEUE_MAX - 1)
+
+#define NFT_QUEUE_FLAG_BYPASS		0x01 /* for compatibility with v2 */
+#define NFT_QUEUE_FLAG_CPU_FANOUT	0x02 /* use current CPU (no hashing) */
+#define NFT_QUEUE_FLAG_MASK		0x03
+
+/**
  * enum nft_reject_types - nf_tables reject expression reject types
  *
  * @NFT_REJECT_ICMP_UNREACH: reject using ICMP unreachable
diff --git a/include/statement.h b/include/statement.h
index 6ecbb18..14a66df 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -59,6 +59,14 @@ struct nat_stmt {
 
 extern struct stmt *nat_stmt_alloc(const struct location *loc);
 
+struct queue_stmt {
+	uint16_t		queuenum;
+	uint16_t		queues_total;
+	uint16_t		flags;
+};
+
+extern struct stmt *queue_stmt_alloc(const struct location *loc);
+
 /**
  * enum stmt_types - statement types
  *
@@ -71,6 +79,7 @@ extern struct stmt *nat_stmt_alloc(const struct location *loc);
  * @STMT_LOG:		log statement
  * @STMT_REJECT:	REJECT statement
  * @STMT_NAT:		NAT statement
+ * @STMT_QUEUE:		QUEUE statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -82,6 +91,7 @@ enum stmt_types {
 	STMT_LOG,
 	STMT_REJECT,
 	STMT_NAT,
+	STMT_QUEUE,
 };
 
 /**
@@ -127,6 +137,7 @@ struct stmt {
 		struct limit_stmt	limit;
 		struct reject_stmt	reject;
 		struct nat_stmt		nat;
+		struct queue_stmt	queue;
 	};
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 94fee64..d4f8339 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1174,6 +1174,8 @@ static int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_reject(ctx, stmt);
 	case STMT_NAT:
 		return stmt_evaluate_nat(ctx, stmt);
+	case STMT_QUEUE:
+		return 0;
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 7e4e38c..8ae3a76 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -481,6 +481,20 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
+static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
+			      const struct location *loc,
+			      const struct nft_rule_expr *nle)
+{
+	struct stmt *stmt;
+
+	stmt = queue_stmt_alloc(loc);
+	stmt->queue.queuenum = nft_rule_expr_get_u16(nle, NFT_EXPR_QUEUE_NUM);
+	stmt->queue.queues_total =
+		nft_rule_expr_get_u16(nle, NFT_EXPR_QUEUE_TOTAL);
+	stmt->queue.flags = nft_rule_expr_get_u16(nle, NFT_EXPR_QUEUE_FLAGS);
+	list_add_tail(&stmt->list, &ctx->rule->stmts);
+}
+
 static const struct {
 	const char	*name;
 	void		(*parse)(struct netlink_parse_ctx *ctx,
@@ -501,6 +515,7 @@ static const struct {
 	{ .name = "limit",	.parse = netlink_parse_limit },
 	{ .name = "reject",	.parse = netlink_parse_reject },
 	{ .name = "nat",	.parse = netlink_parse_nat },
+	{ .name = "queue",	.parse = netlink_parse_queue },
 };
 
 static const struct input_descriptor indesc_netlink = {
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index e64e92a..2f1eba8 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -634,6 +634,26 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
+				 const struct stmt *stmt)
+{
+	struct nft_rule_expr *nle;
+
+	nle = alloc_nft_expr("queue");
+
+	nft_rule_expr_set_u16(nle, NFT_EXPR_QUEUE_NUM,
+			      stmt->queue.queuenum);
+	if (stmt->queue.queues_total) {
+		nft_rule_expr_set_u16(nle, NFT_EXPR_QUEUE_TOTAL,
+				      stmt->queue.queues_total);
+	}
+	if (stmt->queue.flags) {
+		nft_rule_expr_set_u16(nle, NFT_EXPR_QUEUE_FLAGS,
+				      stmt->queue.flags);
+	}
+	nft_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 			     const struct stmt *stmt)
 {
@@ -654,6 +674,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_reject_stmt(ctx, stmt);
 	case STMT_NAT:
 		return netlink_gen_nat_stmt(ctx, stmt);
+	case STMT_QUEUE:
+		return netlink_gen_queue_stmt(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/parser.y b/src/parser.y
index a49e5c2..138c523 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -179,7 +179,6 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token JUMP			"jump"
 %token GOTO			"goto"
 %token RETURN			"return"
-%token QUEUE			"queue"
 
 %token <val> NUM		"number"
 %token <string> STRING		"string"
@@ -329,6 +328,13 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token SNAT			"snat"
 %token DNAT			"dnat"
 
+%token QUEUE			"queue"
+%token QUEUENUM			"num"
+%token QUEUETOTAL		"total"
+%token QUEUEBYPASS		"bypass"
+%token QUEUECPUFANOUT		"fanout"
+%token OPTIONS			"options"
+
 %token POSITION			"position"
 
 %type <string>			identifier string
@@ -376,6 +382,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { stmt_free($$); }	reject_stmt
 %type <stmt>			nat_stmt nat_stmt_alloc
 %destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc
+%type <stmt>			queue_stmt queue_stmt_alloc
+%destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
+%type <val>			queue_flag
 
 %type <expr>			symbol_expr verdict_expr integer_expr
 %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr
@@ -922,6 +931,7 @@ stmt			:	verdict_stmt
 			|	limit_stmt
 			|	reject_stmt
 			|	nat_stmt
+			|	queue_stmt
 			;
 
 verdict_stmt		:	verdict_expr
@@ -1046,6 +1056,51 @@ nat_stmt_args		:	expr
 			}
 			;
 
+queue_stmt		:	queue_stmt_alloc
+			|	queue_stmt_alloc		queue_args
+			;
+
+queue_stmt_alloc		:	QUEUE
+			{
+				$$ = queue_stmt_alloc(&@$);
+			}
+			;
+
+queue_args		:	queue_arg
+			{
+				$<stmt>$	= $<stmt>0;
+			}
+			|	queue_args	queue_arg
+			;
+
+queue_arg		:	QUEUENUM		NUM
+			{
+				$<stmt>0->queue.queuenum	 = $2;
+			}
+			|	QUEUETOTAL		NUM
+			{
+				$<stmt>0->queue.queues_total	 = $2;
+			}
+			|	OPTIONS		queue_flag
+			{
+				$<stmt>0->queue.flags		 = $2;
+			}
+			;
+
+queue_flag		:	queue_flag	COMMA	queue_flag
+			{
+				$$ |= $1 | $3;
+			}
+			|	QUEUEBYPASS
+			{
+				$$ = NFT_QUEUE_FLAG_BYPASS;
+			}
+			|	QUEUECPUFANOUT
+			{
+				$$ = NFT_QUEUE_FLAG_CPU_FANOUT;
+			}
+			;
+
 match_stmt		:	relational_expr
 			{
 				$$ = expr_stmt_alloc(&@$, $1);
@@ -1282,10 +1337,6 @@ verdict_expr		:	ACCEPT
 			{
 				$$ = verdict_expr_alloc(&@$, NF_DROP, NULL);
 			}
-			|	QUEUE
-			{
-				$$ = verdict_expr_alloc(&@$, NF_QUEUE, NULL);
-			}
 			|	CONTINUE
 			{
 				$$ = verdict_expr_alloc(&@$, NFT_CONTINUE, NULL);
diff --git a/src/scanner.l b/src/scanner.l
index cee6aa6..8c4f25d 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -234,7 +234,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "jump"			{ return JUMP; }
 "goto"			{ return GOTO; }
 "return"		{ return RETURN; }
-"queue"			{ return QUEUE; }
 
 "add"			{ return ADD; }
 "insert"		{ return INSERT; }
@@ -255,6 +254,13 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "snaplen"		{ return SNAPLEN; }
 "queue-threshold"	{ return QUEUE_THRESHOLD; }
 
+"queue"			{ return QUEUE;}
+"num"			{ return QUEUENUM;}
+"total"			{ return QUEUETOTAL;}
+"bypass"		{ return QUEUEBYPASS;}
+"fanout"		{ return QUEUECPUFANOUT;}
+"options"		{ return OPTIONS;}
+
 "limit"			{ return LIMIT; }
 "rate"			{ return RATE; }
 
diff --git a/src/statement.c b/src/statement.c
index d18e034..3fdd9e2 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -172,6 +172,37 @@ struct stmt *limit_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &limit_stmt_ops);
 }
 
+static void queue_stmt_print(const struct stmt *stmt)
+{
+	int one = 0;
+
+	printf("queue num %u total %u",
+		stmt->queue.queuenum, stmt->queue.queues_total);
+	if (stmt->queue.flags)
+		printf(" options ");
+	if (stmt->queue.flags & NFT_QUEUE_FLAG_BYPASS) {
+		printf("bypass");
+		one = 1;
+	}
+	if (stmt->queue.flags & NFT_QUEUE_FLAG_CPU_FANOUT) {
+		if (one)
+			printf (",");
+		printf("fanout");
+	}
+
+}
+
+static const struct stmt_ops queue_stmt_ops = {
+	.type		= STMT_QUEUE,
+	.name		= "queue",
+	.print		= queue_stmt_print,
+};
+
+struct stmt *queue_stmt_alloc(const struct location *loc)
+{
+	return stmt_alloc(loc, &queue_stmt_ops);
+}
+
 static void reject_stmt_print(const struct stmt *stmt)
 {
 	printf("reject");
-- 
1.8.4.4

