From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: support limit rate over value
Date: Wed, 13 Jan 2016 13:44:28 +0100
Message-ID: <1452689068-17186-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59572 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbcAMMoj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2016 07:44:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3FDBEDB010C
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 13:44:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2F260DA80B
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 13:44:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C6ED4DA80B
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 13:44:35 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So far it was only possible to match packet under a rate limit, this
patch allows you to explicitly indicate if you want to match packets
that goes over or until the rate limit, eg.

... limit rate over 3/second counter log prefix "OVERLIMIT: " drop
... limit rate over 3 mbytes/second counter log prefix "OVERLIMIT: " drop
... ct state invalid limit rate until 1/second counter log prefix "INVALID: "

When listing rate limit until, this shows:

... ct state invalid limit rate 1/second counter log prefix "INVALID: "

thus, the existing syntax is still valid (i.e. default to rate limit until).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h |  6 +++
 include/statement.h                 |  1 +
 src/netlink_delinearize.c           |  1 +
 src/netlink_linearize.c             |  1 +
 src/parser_bison.y                  | 27 +++++++----
 src/scanner.l                       |  2 +
 src/statement.c                     | 11 +++--
 tests/py/any/limit.t                | 19 ++++++++
 tests/py/any/limit.t.payload        | 96 ++++++++++++++++++++++++++++++-------
 9 files changed, 135 insertions(+), 29 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 70a9619..f1e4335 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -769,6 +769,10 @@ enum nft_limit_type {
 	NFT_LIMIT_PKT_BYTES
 };
 
+enum nft_limit_flags {
+	NFT_LIMIT_F_INV = (1 << 0),
+};
+
 /**
  * enum nft_limit_attributes - nf_tables limit expression netlink attributes
  *
@@ -776,6 +780,7 @@ enum nft_limit_type {
  * @NFTA_LIMIT_UNIT: refill unit (NLA_U64)
  * @NFTA_LIMIT_BURST: burst (NLA_U32)
  * @NFTA_LIMIT_TYPE: type of limit (NLA_U32: enum nft_limit_type)
+ * @NFTA_LIMIT_FLAGS: flags (NLA_U32: enum nft_limit_flags)
  */
 enum nft_limit_attributes {
 	NFTA_LIMIT_UNSPEC,
@@ -783,6 +788,7 @@ enum nft_limit_attributes {
 	NFTA_LIMIT_UNIT,
 	NFTA_LIMIT_BURST,
 	NFTA_LIMIT_TYPE,
+	NFTA_LIMIT_FLAGS,
 	__NFTA_LIMIT_MAX
 };
 #define NFTA_LIMIT_MAX		(__NFTA_LIMIT_MAX - 1)
diff --git a/include/statement.h b/include/statement.h
index 53620ae..6be3a24 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -61,6 +61,7 @@ struct limit_stmt {
 	uint64_t		unit;
 	enum nft_limit_type	type;
 	uint32_t		burst;
+	uint32_t		flags;
 };
 
 extern struct stmt *limit_stmt_alloc(const struct location *loc);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 841be60..3f01781 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -621,6 +621,7 @@ static void netlink_parse_limit(struct netlink_parse_ctx *ctx,
 	stmt->limit.unit = nftnl_expr_get_u64(nle, NFTNL_EXPR_LIMIT_UNIT);
 	stmt->limit.type = nftnl_expr_get_u32(nle, NFTNL_EXPR_LIMIT_TYPE);
 	stmt->limit.burst = nftnl_expr_get_u32(nle, NFTNL_EXPR_LIMIT_BURST);
+	stmt->limit.flags = nftnl_expr_get_u32(nle, NFTNL_EXPR_LIMIT_FLAGS);
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 48f5f02..56a959c 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -785,6 +785,7 @@ static void netlink_gen_limit_stmt(struct netlink_linearize_ctx *ctx,
 	if (stmt->limit.burst > 0)
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_LIMIT_BURST,
 				   stmt->limit.burst);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_LIMIT_FLAGS, stmt->limit.flags);
 
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
diff --git a/src/parser_bison.y b/src/parser_bison.y
index fcf84b9..35439ce 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -367,6 +367,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token LIMIT			"limit"
 %token RATE			"rate"
 %token BURST			"burst"
+%token OVER			"over"
+%token UNTIL			"until"
 
 %token NANOSECOND		"nanosecond"
 %token MICROSECOND		"microsecond"
@@ -458,7 +460,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <val>			level_type
 %type <stmt>			limit_stmt
 %destructor { stmt_free($$); }	limit_stmt
-%type <val>			limit_burst time_unit
+%type <val>			limit_burst limit_mode time_unit
 %type <stmt>			reject_stmt reject_stmt_alloc
 %destructor { stmt_free($$); }	reject_stmt reject_stmt_alloc
 %type <stmt>			nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
@@ -1467,33 +1469,40 @@ level_type		:	LEVEL_EMERG	{ $$ = LOG_EMERG; }
 			|	LEVEL_DEBUG	{ $$ = LOG_DEBUG; }
 			;
 
-limit_stmt		:	LIMIT	RATE	NUM	SLASH	time_unit	limit_burst
+limit_stmt		:	LIMIT	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst
 	    		{
 				$$ = limit_stmt_alloc(&@$);
-				$$->limit.rate	= $3;
-				$$->limit.unit	= $5;
-				$$->limit.burst	= $6;
+				$$->limit.rate	= $4;
+				$$->limit.unit	= $6;
+				$$->limit.burst	= $7;
 				$$->limit.type	= NFT_LIMIT_PKTS;
+				$$->limit.flags = $3;
 			}
-			|	LIMIT RATE	NUM	STRING	limit_burst
+			|	LIMIT	RATE	limit_mode	NUM	STRING	limit_burst
 			{
 				struct error_record *erec;
 				uint64_t rate, unit;
 
-				erec = rate_parse(&@$, $4, &rate, &unit);
+				erec = rate_parse(&@$, $5, &rate, &unit);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
 				}
 
 				$$ = limit_stmt_alloc(&@$);
-				$$->limit.rate	= rate * $3;
+				$$->limit.rate	= rate * $4;
 				$$->limit.unit	= unit;
-				$$->limit.burst	= $5;
+				$$->limit.burst	= $6;
 				$$->limit.type	= NFT_LIMIT_PKT_BYTES;
+				$$->limit.flags = $3;
 			}
 			;
 
+limit_mode		:	OVER				{ $$ = NFT_LIMIT_F_INV; }
+			|	UNTIL				{ $$ = 0; }
+			|	/* empty */			{ $$ = 0; }
+			;
+
 limit_burst		:	/* empty */			{ $$ = 0; }
 			|	BURST	NUM	PACKETS		{ $$ = $2; }
 			|	BURST	NUM	BYTES		{ $$ = $2; }
diff --git a/src/scanner.l b/src/scanner.l
index a98e7b6..e5ac8aa 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -312,6 +312,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "limit"			{ return LIMIT; }
 "rate"			{ return RATE; }
 "burst"			{ return BURST; }
+"until"			{ return UNTIL; }
+"over"			{ return OVER; }
 
 "nanosecond"		{ return NANOSECOND; }
 "microsecond"		{ return MICROSECOND; }
diff --git a/src/statement.c b/src/statement.c
index 2d1a3e6..153e93b 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -213,21 +213,24 @@ static const char *get_rate(uint64_t byte_rate, uint64_t *rate)
 
 static void limit_stmt_print(const struct stmt *stmt)
 {
+	bool inv = stmt->limit.flags & NFT_LIMIT_F_INV;
 	const char *data_unit;
 	uint64_t rate;
 
 	switch (stmt->limit.type) {
 	case NFT_LIMIT_PKTS:
-		printf("limit rate %" PRIu64 "/%s",
-		       stmt->limit.rate, get_unit(stmt->limit.unit));
+		printf("limit rate %s%" PRIu64 "/%s",
+		       inv ? "over " : "", stmt->limit.rate,
+		       get_unit(stmt->limit.unit));
 		if (stmt->limit.burst > 0)
 			printf(" burst %u packets", stmt->limit.burst);
 		break;
 	case NFT_LIMIT_PKT_BYTES:
 		data_unit = get_rate(stmt->limit.rate, &rate);
 
-		printf("limit rate %" PRIu64 " %s/%s",
-		       rate, data_unit, get_unit(stmt->limit.unit));
+		printf("limit rate %s%" PRIu64 " %s/%s",
+		       inv ? "over " : "", rate, data_unit,
+		       get_unit(stmt->limit.unit));
 		if (stmt->limit.burst > 0) {
 			uint64_t burst;
 
diff --git a/tests/py/any/limit.t b/tests/py/any/limit.t
index 358b5ab..8180bea 100644
--- a/tests/py/any/limit.t
+++ b/tests/py/any/limit.t
@@ -26,3 +26,22 @@ limit rate 1025 bytes/second burst 512 bytes;ok
 limit rate 1025 kbytes/second burst 1023 kbytes;ok
 limit rate 1025 mbytes/second burst 1025 kbytes;ok
 limit rate 1025000 mbytes/second burst 1023 mbytes;ok
+
+limit rate over 400/minute;ok
+limit rate over 20/second;ok
+limit rate over 400/hour;ok
+limit rate over 40/day;ok
+limit rate over 400/week;ok
+limit rate over 1023/second burst 10 packets;ok
+
+limit rate over 1 kbytes/second;ok
+limit rate over 2 kbytes/second;ok
+limit rate over 1025 kbytes/second;ok
+limit rate over 1023 mbytes/second;ok
+limit rate over 10230 mbytes/second;ok
+limit rate over 1023000 mbytes/second;ok
+
+limit rate over 1025 bytes/second burst 512 bytes;ok
+limit rate over 1025 kbytes/second burst 1023 kbytes;ok
+limit rate over 1025 mbytes/second burst 1025 kbytes;ok
+limit rate over 1025000 mbytes/second burst 1023 mbytes;ok
diff --git a/tests/py/any/limit.t.payload b/tests/py/any/limit.t.payload
index a3c87d8..b0cc84b 100644
--- a/tests/py/any/limit.t.payload
+++ b/tests/py/any/limit.t.payload
@@ -1,64 +1,128 @@
 # limit rate 400/minute
 ip test-ip4 output
-  [ limit rate 400/minute burst 0 type packets ]
+  [ limit rate 400/minute burst 0 type packets flags 0x0 ]
 
 # limit rate 20/second
 ip test-ip4 output
-  [ limit rate 20/second burst 0 type packets ]
+  [ limit rate 20/second burst 0 type packets flags 0x0 ]
 
 # limit rate 400/hour
 ip test-ip4 output
-  [ limit rate 400/hour burst 0 type packets ]
+  [ limit rate 400/hour burst 0 type packets flags 0x0 ]
 
 # limit rate 400/week
 ip test-ip4 output
-  [ limit rate 400/week burst 0 type packets ]
+  [ limit rate 400/week burst 0 type packets flags 0x0 ]
 
 # limit rate 40/day
 ip test-ip4 output
-  [ limit rate 40/day burst 0 type packets ]
+  [ limit rate 40/day burst 0 type packets flags 0x0 ]
 
 # limit rate 1023/second burst 10 packets
 ip test-ip4 output
-  [ limit rate 1023/second burst 10 type packets ]
+  [ limit rate 1023/second burst 10 type packets flags 0x0 ]
 
 # limit rate 1 kbytes/second
 ip test-ip4 output
-  [ limit rate 1024/second burst 0 type bytes ]
+  [ limit rate 1024/second burst 0 type bytes flags 0x0 ]
 
 # limit rate 2 kbytes/second
 ip test-ip4 output
-  [ limit rate 2048/second burst 0 type bytes ]
+  [ limit rate 2048/second burst 0 type bytes flags 0x0 ]
 
 # limit rate 1025 kbytes/second
 ip test-ip4 output
-  [ limit rate 1049600/second burst 0 type bytes ]
+  [ limit rate 1049600/second burst 0 type bytes flags 0x0 ]
 
 # limit rate 1023 mbytes/second
 ip test-ip4 output
-  [ limit rate 1072693248/second burst 0 type bytes ]
+  [ limit rate 1072693248/second burst 0 type bytes flags 0x0 ]
 
 # limit rate 10230 mbytes/second
 ip test-ip4 output
-  [ limit rate 10726932480/second burst 0 type bytes ]
+  [ limit rate 10726932480/second burst 0 type bytes flags 0x0 ]
 
 # limit rate 1023000 mbytes/second
 ip test-ip4 output
-  [ limit rate 1072693248000/second burst 0 type bytes ]
+  [ limit rate 1072693248000/second burst 0 type bytes flags 0x0 ]
 
 # limit rate 1025 bytes/second burst 512 bytes
 ip test-ip4 output
-  [ limit rate 1025/second burst 512 type bytes ]
+  [ limit rate 1025/second burst 512 type bytes flags 0x0 ]
 
 # limit rate 1025 kbytes/second burst 1023 kbytes
 ip test-ip4 output
-  [ limit rate 1049600/second burst 1047552 type bytes ]
+  [ limit rate 1049600/second burst 1047552 type bytes flags 0x0 ]
 
 # limit rate 1025 mbytes/second burst 1025 kbytes
 ip test-ip4 output
-  [ limit rate 1074790400/second burst 1049600 type bytes ]
+  [ limit rate 1074790400/second burst 1049600 type bytes flags 0x0 ]
 
 # limit rate 1025000 mbytes/second burst 1023 mbytes
 ip test-ip4 output
-  [ limit rate 1074790400000/second burst 1072693248 type bytes ]
+  [ limit rate 1074790400000/second burst 1072693248 type bytes flags 0x0 ]
+
+# limit rate over 400/minute
+ip test-ip4 output
+  [ limit rate 400/minute burst 0 type packets flags 0x1 ]
+
+# limit rate over 20/second
+ip test-ip4 output
+  [ limit rate 20/second burst 0 type packets flags 0x1 ]
+
+# limit rate over 400/hour
+ip test-ip4 output
+  [ limit rate 400/hour burst 0 type packets flags 0x1 ]
+
+# limit rate over 400/week
+ip test-ip4 output
+  [ limit rate 400/week burst 0 type packets flags 0x1 ]
+
+# limit rate over 40/day
+ip test-ip4 output
+  [ limit rate 40/day burst 0 type packets flags 0x1 ]
+
+# limit rate over 1023/second burst 10 packets
+ip test-ip4 output
+  [ limit rate 1023/second burst 10 type packets flags 0x1 ]
+
+# limit rate over 1 kbytes/second
+ip test-ip4 output
+  [ limit rate 1024/second burst 0 type bytes flags 0x1 ]
+
+# limit rate over 2 kbytes/second
+ip test-ip4 output
+  [ limit rate 2048/second burst 0 type bytes flags 0x1 ]
+
+# limit rate over 1025 kbytes/second
+ip test-ip4 output
+  [ limit rate 1049600/second burst 0 type bytes flags 0x1 ]
+
+# limit rate over 1023 mbytes/second
+ip test-ip4 output
+  [ limit rate 1072693248/second burst 0 type bytes flags 0x1 ]
+
+# limit rate over 10230 mbytes/second
+ip test-ip4 output
+  [ limit rate 10726932480/second burst 0 type bytes flags 0x1 ]
+
+# limit rate over 1023000 mbytes/second
+ip test-ip4 output
+  [ limit rate 1072693248000/second burst 0 type bytes flags 0x1 ]
+
+# limit rate over 1025 bytes/second burst 512 bytes
+ip test-ip4 output
+  [ limit rate 1025/second burst 512 type bytes flags 0x1 ]
+
+# limit rate over 1025 kbytes/second burst 1023 kbytes
+ip test-ip4 output
+  [ limit rate 1049600/second burst 1047552 type bytes flags 0x1 ]
+
+# limit rate over 1025 mbytes/second burst 1025 kbytes
+ip test-ip4 output
+  [ limit rate 1074790400/second burst 1049600 type bytes flags 0x1 ]
+
+# limit rate over 1025000 mbytes/second burst 1023 mbytes
+ip test-ip4 output
+  [ limit rate 1074790400000/second burst 1072693248 type bytes flags 0x1 ]
 
-- 
2.1.4

