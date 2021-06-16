Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE1CC48BE5
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 21:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AB76613DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 21:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbhFPVTx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Jun 2021 17:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbhFPVTx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Jun 2021 17:19:53 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8604AC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Jun 2021 14:17:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ltcuv-0002Ub-0F; Wed, 16 Jun 2021 23:17:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     jake.owen@superloop.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 6/8] src: queue: allow use of arbitrary queue expressions
Date:   Wed, 16 Jun 2021 23:16:50 +0200
Message-Id: <20210616211652.11765-7-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210616211652.11765-1-fw@strlen.de>
References: <20210616211652.11765-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

back in 2016 Liping Zhang added support to kernel and libnftnl to
specify a source register containing the queue number to use.

This was never added to nft itself, so allow this.
On linearization side, check if attached expression is a range.
If its not, allocate a new register and set NFTNL_EXPR_QUEUE_SREG_QNUM
attribute after generating the lowlevel expressions for the kernel.

On delinarization we need to check for presence of
NFTNL_EXPR_QUEUE_SREG_QNUM and decode the expression(s) when present.

Also need to do postprocessing for STMT_QUEUE so that the protocol
context is set correctly, without this only raw payload expressions
will be shown (@nh,32,...) instead of 'ip ...'.

Next patch adds test cases.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/statements.txt        |  4 ++++
 src/evaluate.c            | 13 ++++++-----
 src/netlink_delinearize.c | 48 +++++++++++++++++++++++++++++++--------
 src/netlink_linearize.c   | 28 +++++++++++++++++++----
 src/parser_bison.y        | 16 +++++++++++--
 src/statement.c           |  9 ++++++--
 6 files changed, 93 insertions(+), 25 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 602a5b2011a7..c2a616594fce 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -591,11 +591,15 @@ for details.
 ____
 *queue* [*flags* 'QUEUE_FLAGS'] [*num* 'queue_number']
 *queue* [*flags* 'QUEUE_FLAGS'] [*num* 'queue_number_from' - 'queue_number_to']
+*queue* [*flags* 'QUEUE_FLAGS'] [*to* 'QUEUE_EXPRESSION' ]
 
 'QUEUE_FLAGS' := 'QUEUE_FLAG' [*,* 'QUEUE_FLAGS']
 'QUEUE_FLAG'  := *bypass* | *fanout*
+'QUEUE_EXPRESSION' := *numgen* | *hash* | *symhash*
 ____
 
+QUEUE_EXPRESSION can be used to compute a queue number
+at run-time with the hash or numgen expressions.
 
 .queue statement values
 [options="header"]
diff --git a/src/evaluate.c b/src/evaluate.c
index bebdb3f827e9..4a7ec95cd961 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1019,7 +1019,6 @@ static int expr_evaluate_range(struct eval_ctx *ctx, struct expr **expr)
 	if (mpz_cmp(left->value, right->value) >= 0)
 		return expr_error(ctx->msgs, range,
 				  "Range has zero or negative size");
-
 	datatype_set(range, left->dtype);
 	range->flags |= EXPR_F_CONSTANT;
 	return 0;
@@ -3428,14 +3427,16 @@ static int stmt_evaluate_queue(struct eval_ctx *ctx, struct stmt *stmt)
 				      BYTEORDER_HOST_ENDIAN,
 				      &stmt->queue.queue) < 0)
 			return -1;
-		if (!expr_is_constant(stmt->queue.queue))
-			return expr_error(ctx->msgs, stmt->queue.queue,
-					  "queue number is not constant");
-		if (stmt->queue.queue->etype != EXPR_RANGE &&
-		    (stmt->queue.flags & NFT_QUEUE_FLAG_CPU_FANOUT))
+
+		if ((stmt->queue.flags & NFT_QUEUE_FLAG_CPU_FANOUT) &&
+		    stmt->queue.queue->etype != EXPR_RANGE)
 			return expr_error(ctx->msgs, stmt->queue.queue,
 					  "fanout requires a range to be "
 					  "specified");
+
+		if (ctx->ectx.maxval > USHRT_MAX)
+			return expr_error(ctx->msgs, stmt->queue.queue,
+					  "queue expression max value exceeds %u", USHRT_MAX);
 	}
 	stmt->flags |= STMT_F_TERMINAL;
 	return 0;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 7ea31e6a2639..07a6d06876e2 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1467,19 +1467,32 @@ static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
 			      const struct location *loc,
 			      const struct nftnl_expr *nle)
 {
-	uint16_t num, total, flags;
-	struct expr *expr, *high;
+	struct expr *expr;
+	uint16_t flags;
 
-	num   = nftnl_expr_get_u16(nle, NFTNL_EXPR_QUEUE_NUM);
-	total = nftnl_expr_get_u16(nle, NFTNL_EXPR_QUEUE_TOTAL);
+	if (nftnl_expr_is_set(nle, NFTNL_EXPR_QUEUE_SREG_QNUM)) {
+		enum nft_registers reg = netlink_parse_register(nle, NFTNL_EXPR_QUEUE_SREG_QNUM);
 
-	expr = constant_expr_alloc(loc, &integer_type,
-				   BYTEORDER_HOST_ENDIAN, 16, &num);
-	if (total > 1) {
-		total += num - 1;
-		high = constant_expr_alloc(loc, &integer_type,
+		expr = netlink_get_register(ctx, loc, reg);
+		if (!expr) {
+			netlink_error(ctx, loc, "queue statement has no sreg expression");
+			return;
+		}
+	} else {
+		uint16_t total = nftnl_expr_get_u16(nle, NFTNL_EXPR_QUEUE_TOTAL);
+		uint16_t num = nftnl_expr_get_u16(nle, NFTNL_EXPR_QUEUE_NUM);
+
+		expr = constant_expr_alloc(loc, &integer_type,
+					   BYTEORDER_HOST_ENDIAN, 16, &num);
+
+		if (total > 1) {
+			struct expr *high;
+
+			total += num - 1;
+			high = constant_expr_alloc(loc, &integer_type,
 					   BYTEORDER_HOST_ENDIAN, 16, &total);
-		expr = range_expr_alloc(loc, expr, high);
+			expr = range_expr_alloc(loc, expr, high);
+		}
 	}
 
 	flags = nftnl_expr_get_u16(nle, NFTNL_EXPR_QUEUE_FLAGS);
@@ -2788,6 +2801,18 @@ static void stmt_payload_postprocess(struct rule_pp_ctx *ctx)
 	expr_postprocess(ctx, &stmt->payload.val);
 }
 
+static void stmt_queue_postprocess(struct rule_pp_ctx *ctx)
+{
+	struct stmt *stmt = ctx->stmt;
+	struct expr *e = stmt->queue.queue;
+
+	if (e == NULL || e->etype == EXPR_VALUE ||
+	    e->etype == EXPR_RANGE)
+		return;
+
+	expr_postprocess(ctx, &stmt->queue.queue);
+}
+
 /*
  * We can only remove payload dependencies if they occur without
  * a statement with side effects in between.
@@ -2889,6 +2914,9 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 		case STMT_OBJREF:
 			expr_postprocess(&rctx, &stmt->objref.expr);
 			break;
+		case STMT_QUEUE:
+			stmt_queue_postprocess(&rctx);
+			break;
 		default:
 			break;
 		}
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 7b35aae1f913..b1f3feeeb4b7 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1334,21 +1334,39 @@ static void netlink_gen_fwd_stmt(struct netlink_linearize_ctx *ctx,
 static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
+	enum nft_registers sreg = 0;
 	struct nftnl_expr *nle;
 	uint16_t total_queues;
+	struct expr *expr;
 	mpz_t low, high;
 
 	mpz_init2(low, 16);
 	mpz_init2(high, 16);
-	if (stmt->queue.queue != NULL) {
-		range_expr_value_low(low, stmt->queue.queue);
-		range_expr_value_high(high, stmt->queue.queue);
+
+	expr = stmt->queue.queue;
+
+	if (expr) {
+		if (expr->etype == EXPR_RANGE || expr->etype == EXPR_VALUE) {
+			range_expr_value_low(low, stmt->queue.queue);
+			range_expr_value_high(high, stmt->queue.queue);
+		} else {
+			sreg = get_register(ctx, expr);
+			netlink_gen_expr(ctx, expr, sreg);
+			release_register(ctx, expr);
+		}
 	}
+
 	total_queues = mpz_get_uint16(high) - mpz_get_uint16(low) + 1;
 
 	nle = alloc_nft_expr("queue");
-	nftnl_expr_set_u16(nle, NFTNL_EXPR_QUEUE_NUM, mpz_get_uint16(low));
-	nftnl_expr_set_u16(nle, NFTNL_EXPR_QUEUE_TOTAL, total_queues);
+
+	if (sreg) {
+		netlink_put_register(nle, NFTNL_EXPR_QUEUE_SREG_QNUM, sreg);
+	} else {
+		nftnl_expr_set_u16(nle, NFTNL_EXPR_QUEUE_NUM, mpz_get_uint16(low));
+		nftnl_expr_set_u16(nle, NFTNL_EXPR_QUEUE_TOTAL, total_queues);
+	}
+
 	if (stmt->queue.flags)
 		nftnl_expr_set_u16(nle, NFTNL_EXPR_QUEUE_FLAGS,
 				   stmt->queue.flags);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index cf90d5ce5672..d75960715a90 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -705,8 +705,8 @@ int nft_lex(void *, void *, void *);
 
 %type <stmt>			queue_stmt queue_stmt_alloc	queue_stmt_compat
 %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc	queue_stmt_compat
-%type <expr>			queue_stmt_expr_simple
-%destructor { expr_free($$); }	queue_stmt_expr_simple
+%type <expr>			queue_stmt_expr_simple queue_stmt_expr
+%destructor { expr_free($$); }	queue_stmt_expr_simple queue_stmt_expr
 %type <val>			queue_stmt_flags queue_stmt_flag
 %type <stmt>			dup_stmt
 %destructor { stmt_free($$); }	dup_stmt
@@ -3739,6 +3739,14 @@ nf_nat_flag		:	RANDOM		{ $$ = NF_NAT_RANGE_PROTO_RANDOM; }
 			;
 
 queue_stmt		:	queue_stmt_compat	close_scope_queue
+			|	QUEUE TO queue_stmt_expr	close_scope_queue
+			{
+				$$ = queue_stmt_alloc(&@$, $3, 0);
+			}
+			|	QUEUE FLAGS	queue_stmt_flags TO queue_stmt_expr close_scope_queue
+			{
+				$$ = queue_stmt_alloc(&@$, $5, $3);
+			}
 			|	QUEUE	FLAGS	queue_stmt_flags QUEUENUM queue_stmt_expr_simple close_scope_queue
 			{
 				$$ = queue_stmt_alloc(&@$, $5, $3);
@@ -3777,6 +3785,10 @@ queue_stmt_expr_simple	:	integer_expr
 			|	range_rhs_expr
 			;
 
+queue_stmt_expr		:	numgen_expr
+			|	hash_expr
+			;
+
 queue_stmt_flags	:	queue_stmt_flag
 			|	queue_stmt_flags	COMMA	queue_stmt_flag
 			{
diff --git a/src/statement.c b/src/statement.c
index 9eb49339555b..dfd275104c59 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -507,8 +507,13 @@ static void queue_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 		nft_print(octx, "%sfanout", delim);
 
 	if (e) {
-		nft_print(octx, " num ");
-		expr_print(stmt->queue.queue, octx);
+		if (e->etype == EXPR_VALUE || e->etype == EXPR_RANGE) {
+			nft_print(octx, " num ");
+			expr_print(stmt->queue.queue, octx);
+		} else {
+			nft_print(octx, " to ");
+			expr_print(stmt->queue.queue, octx);
+		}
 	} else {
 		nft_print(octx, " num 0");
 	}
-- 
2.31.1

