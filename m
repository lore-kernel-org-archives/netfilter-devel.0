From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser: support reject unreach|reset
Date: Mon,  3 Mar 2014 22:12:26 +0100
Message-ID: <1393881146-12967-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53225 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755348AbaCCVQh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Mar 2014 16:16:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

reject did not allow to use tcp reset instead of icmp unreach.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 After this patch its possibe to do something like

 rule filter output reject reset

 Which makes kernel generate bogus tcp resets in repsonse
 to non-tcp packets.

 In iptables this is avoided by making checkentry fail if -p tcp is not
 specified when tcp-reset is requested.

 How should this be handled in nft?

 src/netlink_delinearize.c |  1 +
 src/parser.y              | 22 +++++++++++++++++++---
 src/scanner.l             |  2 ++
 src/statement.c           |  8 +++++++-
 4 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 5eec6cf..9503da7 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -428,6 +428,7 @@ static void netlink_parse_reject(struct netlink_parse_ctx *ctx,
 	struct stmt *stmt;
 
 	stmt = reject_stmt_alloc(loc);
+	stmt->reject.type = nft_rule_expr_get_u32(expr, NFT_EXPR_REJECT_TYPE);
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
diff --git a/src/parser.y b/src/parser.y
index b3acc74..e748c58 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -339,6 +339,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token WEEK			"week"
 
 %token _REJECT			"reject"
+%token REJECT_RESET		"reset"
+%token REJECT_UNREACH		"unreach"
 
 %token SNAT			"snat"
 %token DNAT			"dnat"
@@ -398,8 +400,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <stmt>			limit_stmt
 %destructor { stmt_free($$); }	limit_stmt
 %type <val>			time_unit
-%type <stmt>			reject_stmt
-%destructor { stmt_free($$); }	reject_stmt
+%type <stmt>			reject_stmt reject_stmt_alloc
+%destructor { stmt_free($$); }	reject_stmt reject_stmt_alloc
 %type <stmt>			nat_stmt nat_stmt_alloc
 %destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc
 %type <stmt>			queue_stmt queue_stmt_alloc
@@ -1142,12 +1144,26 @@ time_unit		:	SECOND		{ $$ = 1ULL; }
 			|	WEEK		{ $$ = 1ULL * 60 * 60 * 24 * 7; }
 			;
 
-reject_stmt		:	_REJECT
+reject_stmt		:	reject_stmt_alloc
+			| 	reject_stmt_alloc reject_args
+			;
+
+reject_stmt_alloc	:	_REJECT
 			{
 				$$ = reject_stmt_alloc(&@$);
 			}
 			;
 
+reject_args		:	REJECT_RESET
+			{
+				$<stmt>0->reject.type = NFT_REJECT_TCP_RST;
+			}
+			|	REJECT_UNREACH
+			{
+				$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
+			}
+			;
+
 nat_stmt		:	nat_stmt_alloc	nat_stmt_args
 			;
 
diff --git a/src/scanner.l b/src/scanner.l
index 45c6476..dcaee13 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -293,6 +293,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "week"			{ return WEEK; }
 
 "reject"		{ return _REJECT; }
+"unreach"		{ return REJECT_UNREACH; }
+"reset"			{ return REJECT_RESET; }
 
 "snat"			{ return SNAT; }
 "dnat"			{ return DNAT; }
diff --git a/src/statement.c b/src/statement.c
index 3fdd9e2..611ce5e 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -205,7 +205,13 @@ struct stmt *queue_stmt_alloc(const struct location *loc)
 
 static void reject_stmt_print(const struct stmt *stmt)
 {
-	printf("reject");
+	printf("reject ");
+	switch (stmt->reject.type) {
+	case NFT_REJECT_ICMP_UNREACH: printf("unreach"); break;
+	case NFT_REJECT_TCP_RST: printf("reset"); break;
+	default:
+		printf("[ unknown type %d ]", stmt->reject.type);
+	}
 }
 
 static const struct stmt_ops reject_stmt_ops = {
-- 
1.8.1.5

