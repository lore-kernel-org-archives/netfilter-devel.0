From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nftables PATCH] queue: More compact syntax for nft queue
Date: Tue, 10 Jun 2014 13:28:23 +0200
Message-ID: <1402399703-11177-1-git-send-email-alvaroneay@gmail.com>
Cc: eric@regit.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34534 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaFJL34 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:29:56 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so1442662wib.3
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Jun 2014 04:29:54 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows to use a new syntax more compact and break
the last syntax. This new syntax is more similar than the nftables
syntax that we use usually. We can use range like we have used in
other case in nftables. Here, we have some examples:

Before, If we want to declare a queue, we have used a syntax like this:

nft add rule test input queue num 1 total 3 options bypass,fanout

If we want to use the queue number 1 and the two next (total 3),
we use a range in the new syntax, for example:

nft add rule test input queue num 1-3 bypass fanout

Also if we want to use only one queue, the new rules are like:

nft add rule test input queue num 1	//queue 1
or
nft add rule test input queue	//queue 0

And if we want to add a specific flags we only need to put
what flags we want to use:

nft add rule test input queue bypass

we don't need to use options and the comma for stablishing the
flags.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 include/statement.h       |    4 ++--
 src/netlink_delinearize.c |    9 ++++++---
 src/netlink_linearize.c   |   13 ++++++++++---
 src/parser.y              |   40 ++++++++++++++++++++++++----------------
 src/scanner.l             |    2 --
 src/statement.c           |   23 ++++++++---------------
 6 files changed, 50 insertions(+), 41 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 896b972..480b719 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -60,8 +60,8 @@ struct nat_stmt {
 extern struct stmt *nat_stmt_alloc(const struct location *loc);
 
 struct queue_stmt {
-	uint16_t		queuenum;
-	uint16_t		queues_total;
+	uint16_t		from;
+	uint16_t		to;
 	uint16_t		flags;
 };
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index ea33308..aa47d5f 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -541,11 +541,14 @@ static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
 			      const struct nft_rule_expr *nle)
 {
 	struct stmt *stmt;
+	uint16_t range_to;
 
 	stmt = queue_stmt_alloc(loc);
-	stmt->queue.queuenum = nft_rule_expr_get_u16(nle, NFT_EXPR_QUEUE_NUM);
-	stmt->queue.queues_total =
-		nft_rule_expr_get_u16(nle, NFT_EXPR_QUEUE_TOTAL);
+	stmt->queue.from = nft_rule_expr_get_u16(nle, NFT_EXPR_QUEUE_NUM);
+	range_to = nft_rule_expr_get_u16(nle, NFT_EXPR_QUEUE_TOTAL);
+	range_to += stmt->queue.from - 1;
+
+	stmt->queue.to = range_to;
 	stmt->queue.flags = nft_rule_expr_get_u16(nle, NFT_EXPR_QUEUE_FLAGS);
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 19153fd..9b6eed6 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -683,15 +683,22 @@ static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
 	struct nft_rule_expr *nle;
+	uint16_t total_queues;
 
 	nle = alloc_nft_expr("queue");
 
 	nft_rule_expr_set_u16(nle, NFT_EXPR_QUEUE_NUM,
-			      stmt->queue.queuenum);
-	if (stmt->queue.queues_total) {
+			      stmt->queue.from);
+
+	if (stmt->queue.to >= stmt->queue.from) {
+		total_queues = stmt->queue.to - stmt->queue.from;
 		nft_rule_expr_set_u16(nle, NFT_EXPR_QUEUE_TOTAL,
-				      stmt->queue.queues_total);
+				      total_queues + 1);
+	} else {
+		BUG("invalid queue interval %u-%u\n", stmt->queue.from,
+		    stmt->queue.to);
 	}
+
 	if (stmt->queue.flags) {
 		nft_rule_expr_set_u16(nle, NFT_EXPR_QUEUE_FLAGS,
 				      stmt->queue.flags);
diff --git a/src/parser.y b/src/parser.y
index 38b655d..a748861 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -365,10 +365,8 @@ static int monitor_lookup_event(const char *event)
 
 %token QUEUE			"queue"
 %token QUEUENUM			"num"
-%token QUEUETOTAL		"total"
 %token QUEUEBYPASS		"bypass"
 %token QUEUECPUFANOUT		"fanout"
-%token OPTIONS			"options"
 
 %token POSITION			"position"
 %token COMMENT			"comment"
@@ -425,7 +423,7 @@ static int monitor_lookup_event(const char *event)
 %destructor { stmt_free($$); }	reject_stmt
 %type <stmt>			nat_stmt nat_stmt_alloc
 %destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc
-%type <stmt>			queue_stmt queue_stmt_alloc
+%type <stmt>			queue_stmt queue_stmt_alloc queue_range
 %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
 %type <val>			queue_flags queue_flag
 
@@ -1444,24 +1442,34 @@ queue_stmt_alloc		:	QUEUE
 			}
 			;
 
-queue_args		:	queue_arg
+queue_args		:	QUEUENUM	queue_range	queue_flags
 			{
-				$<stmt>$	= $<stmt>0;
+				$<stmt>0->queue.from  = $2->queue.from;
+				$<stmt>0->queue.to = $2->queue.to;
+				$<stmt>0->queue.flags = $3;
 			}
-			|	queue_args	queue_arg
-			;
-
-queue_arg		:	QUEUENUM		NUM
+			|	QUEUENUM	queue_range
 			{
-				$<stmt>0->queue.queuenum	 = $2;
+				$<stmt>0->queue.from  = $2->queue.from;
+				$<stmt>0->queue.to = $2->queue.to;
 			}
-			|	QUEUETOTAL		NUM
+			|	queue_flags
+			{
+				$<stmt>0->queue.flags		= $1;
+			}
+			;
+
+queue_range		:	NUM
 			{
-				$<stmt>0->queue.queues_total	 = $2;
+				$<stmt>0->queue.from		= $1;
+				$<stmt>0->queue.to		= $1;
+				$$ = $<stmt>0;
 			}
-			|	OPTIONS		queue_flags
+			|	NUM	DASH	NUM
 			{
-				$<stmt>0->queue.flags		 = $2;
+				$<stmt>0->queue.from		= $1;
+				$<stmt>0->queue.to		= $3;
+				$$ = $<stmt>0;
 			}
 			;
 
@@ -1469,9 +1477,9 @@ queue_flags		:	queue_flag
 			{
 				$$ = $1;
 			}
-			|	queue_flags	COMMA	queue_flag
+			|	queue_flags	queue_flag
 			{
-				$$ |= $1 | $3;
+				$$ |= $1 | $2;
 			}
 			;
 
diff --git a/src/scanner.l b/src/scanner.l
index d8d70ed..73a1a3f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -279,10 +279,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "queue"			{ return QUEUE;}
 "num"			{ return QUEUENUM;}
-"total"			{ return QUEUETOTAL;}
 "bypass"		{ return QUEUEBYPASS;}
 "fanout"		{ return QUEUECPUFANOUT;}
-"options"		{ return OPTIONS;}
 
 "limit"			{ return LIMIT; }
 "rate"			{ return RATE; }
diff --git a/src/statement.c b/src/statement.c
index 3fdd9e2..2dd3f18 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -174,21 +174,14 @@ struct stmt *limit_stmt_alloc(const struct location *loc)
 
 static void queue_stmt_print(const struct stmt *stmt)
 {
-	int one = 0;
-
-	printf("queue num %u total %u",
-		stmt->queue.queuenum, stmt->queue.queues_total);
-	if (stmt->queue.flags)
-		printf(" options ");
-	if (stmt->queue.flags & NFT_QUEUE_FLAG_BYPASS) {
-		printf("bypass");
-		one = 1;
-	}
-	if (stmt->queue.flags & NFT_QUEUE_FLAG_CPU_FANOUT) {
-		if (one)
-			printf (",");
-		printf("fanout");
-	}
+	printf("queue num %u",
+		stmt->queue.from);
+	if (stmt->queue.to && stmt->queue.to != stmt->queue.from)
+		printf("-%u", stmt->queue.to);
+	if (stmt->queue.flags & NFT_QUEUE_FLAG_BYPASS)
+		printf(" bypass");
+	if (stmt->queue.flags & NFT_QUEUE_FLAG_CPU_FANOUT)
+		printf(" fanout");
 
 }
 
-- 
1.7.10.4

