From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/3] queue: clean up queue statement
Date: Wed, 24 Sep 2014 14:20:31 +0200
Message-ID: <1411561232-20204-3-git-send-email-kaber@trash.net>
References: <1411561232-20204-1-git-send-email-kaber@trash.net>
Cc: eric@regit.org, arturo.borrero.glez@gmail.com,
	netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56694 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaIXMUh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:20:37 -0400
In-Reply-To: <1411561232-20204-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

- Rename keyword tokens to their actual keyword
- Change the grammar to follow the standard schema for statements and arguments
- Use actual expression for the queue numbers to support using normal range
  expressions, symbolic expression and so on.
- restore comma seperation of flag keywords

The result is that its possible to use standard ranges, prefix expressions,
symbolic expressions etc for the queue number. We get checks for overflow,
negative ranges and so on automatically.

The comma seperation of flags is more similar to what we have for other
flag values. It is still possible to use spaces, however this could be
removed since we never had a release supporting that.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/statement.h       |  3 +--
 src/evaluate.c            | 15 ++++++++++-
 src/netlink_delinearize.c | 21 +++++++++++-----
 src/netlink_linearize.c   | 22 +++++++++++------
 src/parser.y              | 63 +++++++++++++----------------------------------
 src/scanner.l             |  4 +--
 src/statement.c           | 19 ++++++++------
 7 files changed, 75 insertions(+), 72 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 12336bc..e2f02b8 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -70,8 +70,7 @@ struct nat_stmt {
 extern struct stmt *nat_stmt_alloc(const struct location *loc);
 
 struct queue_stmt {
-	uint16_t		from;
-	uint16_t		to;
+	struct expr		*queue;
 	uint16_t		flags;
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 34558fc..284ee72 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1180,6 +1180,19 @@ static int stmt_evaluate_ct(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int stmt_evaluate_queue(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	if (stmt->queue.queue != NULL) {
+		expr_set_context(&ctx->ectx, &integer_type, 16);
+		if (expr_evaluate(ctx, &stmt->queue.queue) < 0)
+			return -1;
+		if (!expr_is_constant(stmt->queue.queue))
+			return expr_error(ctx->msgs, stmt->queue.queue,
+					  "queue number is not constant");
+	}
+	return 0;
+}
+
 static int stmt_evaluate_log(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	if (stmt->log.flags & STMT_LOG_LEVEL &&
@@ -1219,7 +1232,7 @@ static int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 	case STMT_NAT:
 		return stmt_evaluate_nat(ctx, stmt);
 	case STMT_QUEUE:
-		return 0;
+		return stmt_evaluate_queue(ctx, stmt);
 	case STMT_CT:
 		return stmt_evaluate_ct(ctx, stmt);
 	default:
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 195d432..796b632 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -558,15 +558,24 @@ static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
 			      const struct location *loc,
 			      const struct nft_rule_expr *nle)
 {
+	struct expr *expr, *high;
 	struct stmt *stmt;
-	uint16_t range_to;
+	uint16_t num, total;
+
+	num   = nft_rule_expr_get_u16(nle, NFT_EXPR_QUEUE_NUM);
+	total = nft_rule_expr_get_u16(nle, NFT_EXPR_QUEUE_TOTAL);
+
+	expr = constant_expr_alloc(loc, &integer_type,
+				   BYTEORDER_HOST_ENDIAN, 16, &num);
+	if (total > 1) {
+		total += num - 1;
+		high = constant_expr_alloc(loc, &integer_type,
+					   BYTEORDER_HOST_ENDIAN, 16, &total);
+		expr = range_expr_alloc(loc, expr, high);
+	}
 
 	stmt = queue_stmt_alloc(loc);
-	stmt->queue.from = nft_rule_expr_get_u16(nle, NFT_EXPR_QUEUE_NUM);
-	range_to = nft_rule_expr_get_u16(nle, NFT_EXPR_QUEUE_TOTAL);
-	range_to += stmt->queue.from - 1;
-	stmt->queue.to = range_to;
-
+	stmt->queue.queue = expr;
 	stmt->queue.flags = nft_rule_expr_get_u16(nle, NFT_EXPR_QUEUE_FLAGS);
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 17375a5..c46b6d4 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -687,21 +687,27 @@ static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
 {
 	struct nft_rule_expr *nle;
 	uint16_t total_queues;
+	mpz_t low, high;
 
-	nle = alloc_nft_expr("queue");
-
-	nft_rule_expr_set_u16(nle, NFT_EXPR_QUEUE_NUM,
-			      stmt->queue.from);
-
-	total_queues = stmt->queue.to - stmt->queue.from;
-	nft_rule_expr_set_u16(nle, NFT_EXPR_QUEUE_TOTAL,
-			      total_queues + 1);
+	mpz_init2(low, 16);
+	mpz_init2(high, 16);
+	if (stmt->queue.queue != NULL) {
+		range_expr_value_low(low, stmt->queue.queue);
+		range_expr_value_high(high, stmt->queue.queue);
+	}
+	total_queues = mpz_get_uint16(high) - mpz_get_uint16(low) + 1;
 
+	nle = alloc_nft_expr("queue");
+	nft_rule_expr_set_u16(nle, NFT_EXPR_QUEUE_NUM, mpz_get_uint16(low));
+	nft_rule_expr_set_u16(nle, NFT_EXPR_QUEUE_TOTAL, total_queues);
 	if (stmt->queue.flags) {
 		nft_rule_expr_set_u16(nle, NFT_EXPR_QUEUE_FLAGS,
 				      stmt->queue.flags);
 	}
 	nft_rule_add_expr(ctx->nlr, nle);
+
+	mpz_clear(low);
+	mpz_clear(high);
 }
 
 static void netlink_gen_ct_stmt(struct netlink_linearize_ctx *ctx,
diff --git a/src/parser.y b/src/parser.y
index c9b22f0..cf1f42b 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -368,8 +368,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %token QUEUE			"queue"
 %token QUEUENUM			"num"
-%token QUEUEBYPASS		"bypass"
-%token QUEUECPUFANOUT		"fanout"
+%token BYPASS			"bypass"
+%token FANOUT			"fanout"
 
 %token POSITION			"position"
 %token COMMENT			"comment"
@@ -427,9 +427,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { stmt_free($$); }	reject_stmt
 %type <stmt>			nat_stmt nat_stmt_alloc
 %destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc
-%type <stmt>			queue_stmt queue_stmt_alloc queue_range
+%type <stmt>			queue_stmt queue_stmt_alloc
 %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
-%type <val>			queue_flags queue_flag
+%type <val>			queue_stmt_flags queue_stmt_flag
 
 %type <expr>			symbol_expr verdict_expr integer_expr
 %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr
@@ -1381,7 +1381,7 @@ nat_stmt_args		:	expr
 			;
 
 queue_stmt		:	queue_stmt_alloc
-			|	queue_stmt_alloc		queue_args
+			|	queue_stmt_alloc	queue_stmt_args
 			;
 
 queue_stmt_alloc	:	QUEUE
@@ -1390,61 +1390,32 @@ queue_stmt_alloc	:	QUEUE
 			}
 			;
 
-queue_args		:	QUEUENUM	queue_range	queue_flags
+queue_stmt_args		:	queue_stmt_arg
 			{
-				$<stmt>0->queue.from = $2->queue.from;
-				$<stmt>0->queue.to = $2->queue.to;
-				$<stmt>0->queue.flags = $3;
-			}
-			|	QUEUENUM	queue_range
-			{
-				$<stmt>0->queue.from = $2->queue.from;
-				$<stmt>0->queue.to = $2->queue.to;
-			}
-			|	queue_flags
-			{
-				$<stmt>0->queue.flags = $1;
+				$<stmt>$	= $<stmt>0;
 			}
+			|	queue_stmt_args	queue_stmt_arg
 			;
 
-queue_range		:	NUM
+queue_stmt_arg		:	QUEUENUM	expr
 			{
-				$<stmt>0->queue.from = $1;
-				$<stmt>0->queue.to = $1;
-				$$ = $<stmt>0;
+				$<stmt>0->queue.queue = $2;
 			}
-			|	NUM	DASH	NUM
+			|	queue_stmt_flags
 			{
-				if ($3 < $1) {
-					erec_queue(error(&@1,
-							 "invalid range %d-%d",
-							 $1, $3), state->msgs);
-					YYERROR;
-				}
-				$<stmt>0->queue.from = $1;
-				$<stmt>0->queue.to = $3;
-				$$ = $<stmt>0;
+				$<stmt>0->queue.flags |= $1;
 			}
 			;
 
-queue_flags		:	queue_flag
+queue_stmt_flags	:	queue_stmt_flag
+			|	queue_stmt_flags	COMMA	queue_stmt_flag
 			{
-				$$ = $1;
-			}
-			|	queue_flags	queue_flag
-			{
-				$$ |= $1 | $2;
+				$$ = $1 | $3;
 			}
 			;
 
-queue_flag		:	QUEUEBYPASS
-			{
-				$$ = NFT_QUEUE_FLAG_BYPASS;
-			}
-			|	QUEUECPUFANOUT
-			{
-				$$ = NFT_QUEUE_FLAG_CPU_FANOUT;
-			}
+queue_stmt_flag		:	BYPASS	{ $$ = NFT_QUEUE_FLAG_BYPASS; }
+			|	FANOUT	{ $$ = NFT_QUEUE_FLAG_CPU_FANOUT; }
 			;
 
 match_stmt		:	relational_expr
diff --git a/src/scanner.l b/src/scanner.l
index 8aab38f..772f658 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -292,8 +292,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "queue"			{ return QUEUE;}
 "num"			{ return QUEUENUM;}
-"bypass"		{ return QUEUEBYPASS;}
-"fanout"		{ return QUEUECPUFANOUT;}
+"bypass"		{ return BYPASS;}
+"fanout"		{ return FANOUT;}
 
 "limit"			{ return LIMIT; }
 "rate"			{ return RATE; }
diff --git a/src/statement.c b/src/statement.c
index 4be6625..8e4b49e 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -197,14 +197,19 @@ struct stmt *limit_stmt_alloc(const struct location *loc)
 
 static void queue_stmt_print(const struct stmt *stmt)
 {
-	printf("queue num %u",
-		stmt->queue.from);
-	if (stmt->queue.to && stmt->queue.to != stmt->queue.from)
-		printf("-%u", stmt->queue.to);
-	if (stmt->queue.flags & NFT_QUEUE_FLAG_BYPASS)
-		printf(" bypass");
+	const char *delim = " ";
+
+	printf("queue");
+	if (stmt->queue.queue != NULL) {
+		printf(" num ");
+		expr_print(stmt->queue.queue);
+	}
+	if (stmt->queue.flags & NFT_QUEUE_FLAG_BYPASS) {
+		printf("%sbypass", delim);
+		delim = ",";
+	}
 	if (stmt->queue.flags & NFT_QUEUE_FLAG_CPU_FANOUT)
-		printf(" fanout");
+		printf("%sfanout", delim);
 
 }
 
-- 
1.9.3

