From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/3] src: add burst parameter to limit
Date: Tue, 22 Sep 2015 13:02:19 +0200
Message-ID: <1442919740-12888-2-git-send-email-pablo@netfilter.org>
References: <1442919740-12888-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45360 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757839AbbIVKzm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Sep 2015 06:55:42 -0400
In-Reply-To: <1442919740-12888-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

... limit rate 1024 mbytes/second burst 10240 bytes
... limit rate 1/second burst 3 packets

This parameter is optional.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h        |    3 +++
 include/statement.h       |    1 +
 src/datatype.c            |    4 ++--
 src/netlink_delinearize.c |    1 +
 src/netlink_linearize.c   |    4 ++++
 src/parser_bison.y        |   26 +++++++++++++++++++++++---
 src/scanner.l             |    1 +
 src/statement.c           |    8 ++++++++
 8 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index ebafa65..07fedce 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -239,4 +239,7 @@ extern struct error_record *rate_parse(const struct location *loc,
 				       const char *str, uint64_t *rate,
 				       uint64_t *unit);
 
+extern struct error_record *data_unit_parse(const struct location *loc,
+					    const char *str, uint64_t *rate);
+
 #endif /* NFTABLES_DATATYPE_H */
diff --git a/include/statement.h b/include/statement.h
index d2d0852..bead0a6 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -52,6 +52,7 @@ struct limit_stmt {
 	uint64_t		rate;
 	uint64_t		unit;
 	enum nft_limit_type	type;
+	uint32_t		burst;
 };
 
 extern struct stmt *limit_stmt_alloc(const struct location *loc);
diff --git a/src/datatype.c b/src/datatype.c
index e5a486f..f56763b 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -996,8 +996,8 @@ static struct error_record *time_unit_parse(const struct location *loc,
 	return NULL;
 }
 
-static struct error_record *data_unit_parse(const struct location *loc,
-					    const char *str, uint64_t *rate)
+struct error_record *data_unit_parse(const struct location *loc,
+				     const char *str, uint64_t *rate)
 {
 	if (strncmp(str, "bytes", strlen("bytes")) == 0)
 		*rate = 1ULL;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 569763b..ede9302 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -584,6 +584,7 @@ static void netlink_parse_limit(struct netlink_parse_ctx *ctx,
 	stmt->limit.rate = nftnl_expr_get_u64(nle, NFTNL_EXPR_LIMIT_RATE);
 	stmt->limit.unit = nftnl_expr_get_u64(nle, NFTNL_EXPR_LIMIT_UNIT);
 	stmt->limit.type = nftnl_expr_get_u32(nle, NFTNL_EXPR_LIMIT_TYPE);
+	stmt->limit.burst = nftnl_expr_get_u32(nle, NFTNL_EXPR_LIMIT_BURST);
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index cebd2f1..447219f 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -657,6 +657,10 @@ static void netlink_gen_limit_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u64(nle, NFTNL_EXPR_LIMIT_RATE, stmt->limit.rate);
 	nftnl_expr_set_u64(nle, NFTNL_EXPR_LIMIT_UNIT, stmt->limit.unit);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_LIMIT_TYPE, stmt->limit.type);
+	if (stmt->limit.burst > 0)
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_LIMIT_BURST,
+				   stmt->limit.burst);
+
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index ec44a2c..385e214 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -364,6 +364,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %token LIMIT			"limit"
 %token RATE			"rate"
+%token BURST			"burst"
 
 %token NANOSECOND		"nanosecond"
 %token MICROSECOND		"microsecond"
@@ -450,7 +451,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <val>			level_type
 %type <stmt>			limit_stmt
 %destructor { stmt_free($$); }	limit_stmt
-%type <val>			time_unit
+%type <val>			limit_burst time_unit
 %type <stmt>			reject_stmt reject_stmt_alloc
 %destructor { stmt_free($$); }	reject_stmt reject_stmt_alloc
 %type <stmt>			nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
@@ -1441,14 +1442,15 @@ level_type		:	LEVEL_EMERG	{ $$ = LOG_EMERG; }
 			|	LEVEL_DEBUG	{ $$ = LOG_DEBUG; }
 			;
 
-limit_stmt		:	LIMIT	RATE	NUM	SLASH	time_unit
+limit_stmt		:	LIMIT	RATE	NUM	SLASH	time_unit	limit_burst
 	    		{
 				$$ = limit_stmt_alloc(&@$);
 				$$->limit.rate	= $3;
 				$$->limit.unit	= $5;
+				$$->limit.burst	= $6;
 				$$->limit.type	= NFT_LIMIT_PKTS;
 			}
-			|	LIMIT RATE	NUM	STRING
+			|	LIMIT RATE	NUM	STRING	limit_burst
 			{
 				struct error_record *erec;
 				uint64_t rate, unit;
@@ -1462,10 +1464,28 @@ limit_stmt		:	LIMIT	RATE	NUM	SLASH	time_unit
 				$$ = limit_stmt_alloc(&@$);
 				$$->limit.rate	= rate * $3;
 				$$->limit.unit	= unit;
+				$$->limit.burst	= $5;
 				$$->limit.type	= NFT_LIMIT_PKT_BYTES;
 			}
 			;
 
+limit_burst		:	/* empty */			{ $$ = 0; }
+			|	BURST	NUM	PACKETS		{ $$ = $2; }
+			|	BURST	NUM	BYTES		{ $$ = $2; }
+			|	BURST	NUM	STRING
+			{
+				struct error_record *erec;
+				uint64_t rate;
+
+				erec = data_unit_parse(&@$, $3, &rate);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+				$$ = $2 * rate;
+			}
+			;
+
 time_unit		:	SECOND		{ $$ = 1ULL; }
 			|	MINUTE		{ $$ = 1ULL * 60; }
 			|	HOUR		{ $$ = 1ULL * 60 * 60; }
diff --git a/src/scanner.l b/src/scanner.l
index 2d9871d..bd8e572 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -309,6 +309,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "limit"			{ return LIMIT; }
 "rate"			{ return RATE; }
+"burst"			{ return BURST; }
 
 "nanosecond"		{ return NANOSECOND; }
 "microsecond"		{ return MICROSECOND; }
diff --git a/src/statement.c b/src/statement.c
index ba7b8be..d620d1b 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -220,12 +220,20 @@ static void limit_stmt_print(const struct stmt *stmt)
 	case NFT_LIMIT_PKTS:
 		printf("limit rate %" PRIu64 "/%s",
 		       stmt->limit.rate, get_unit(stmt->limit.unit));
+		if (stmt->limit.burst > 0)
+			printf(" burst %u packets", stmt->limit.burst);
 		break;
 	case NFT_LIMIT_PKT_BYTES:
 		data_unit = get_rate(stmt->limit.rate, &rate);
 
 		printf("limit rate %" PRIu64 " %s/%s",
 		       rate, data_unit, get_unit(stmt->limit.unit));
+		if (stmt->limit.burst > 0) {
+			uint64_t burst;
+
+			data_unit = get_rate(stmt->limit.burst, &burst);
+			printf(" burst %"PRIu64" %s", burst, data_unit);
+		}
 		break;
 	}
 }
-- 
1.7.10.4

