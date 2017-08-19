From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 5/7] src: implement shortcut for tcp mss size mangling
Date: Sun, 20 Aug 2017 01:14:11 +0200
Message-ID: <20170819231413.15164-6-fw@strlen.de>
References: <20170819231413.15164-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39306 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752322AbdHSXOM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 19:14:12 -0400
In-Reply-To: <20170819231413.15164-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

short-hand version of tcp option maxseg size 1:
tcp option mss set 1

Reverse also prints the more compact representation.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/exthdr.c       |  1 +
 src/parser_bison.y |  7 +++++++
 src/scanner.l      |  1 +
 src/tcpopt.c       | 11 +++++++++--
 4 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/src/exthdr.c b/src/exthdr.c
index 7d13c83c9943..a4d4fa5b0864 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -20,6 +20,7 @@
 
 #include <utils.h>
 #include <headers.h>
+#include <tcpopt.h>
 #include <expression.h>
 #include <statement.h>
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 7898ea3fe7bc..533347264729 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -334,6 +334,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token RIGHT			"right"
 %token TSVAL			"tsval"
 %token TSECR			"tsecr"
+%token MSS			"mss"
 
 %token DCCP			"dccp"
 
@@ -3214,6 +3215,12 @@ payload_stmt		:	payload_expr		SET	expr
 				else
 					$$ = payload_stmt_alloc(&@$, $1, $3);
 			}
+			|	TCP	OPTION	MSS	SET	expr
+			{
+				$$ = exthdr_stmt_alloc(&@$,
+							tcpopt_expr_alloc(&@$, TCPOPTHDR_MAXSEG, TCPOPTHDR_FIELD_SIZE),
+							$5);
+			}
 			;
 
 payload_expr		:	payload_raw_expr
diff --git a/src/scanner.l b/src/scanner.l
index b6ba32d88f4a..ede6ed73e5df 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -433,6 +433,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "window"		{ return WINDOW; }
 "urgptr"		{ return URGPTR; }
 "option"		{ return OPTION; }
+"mss"			{ return MSS; }
 
 "dccp"			{ return DCCP; }
 
diff --git a/src/tcpopt.c b/src/tcpopt.c
index 63f0c236c9cf..c0540b7a31b2 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -249,8 +249,15 @@ void tcpopt_expr_print(const struct expr *expr, struct output_ctx *octx)
 
 void tcpopt_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	tcpopt_expr_print(stmt->exthdr.expr, octx);
-	printf(" set ");
+	if (stmt->exthdr.expr->exthdr.desc->type == TCPOPT_MAXSEG &&
+	    stmt->exthdr.expr->exthdr.tmpl ==
+	    &stmt->exthdr.expr->exthdr.desc->templates[TCPOPTHDR_FIELD_SIZE]) {
+		printf("tcp option mss set ");
+	} else {
+		tcpopt_expr_print(stmt->exthdr.expr, octx);
+		printf(" set ");
+	}
+
 	expr_print(stmt->exthdr.val, octx);
 }
 
-- 
2.13.0

