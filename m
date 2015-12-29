From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3 nft] parser: get rid of multiton_expr from lhs relational expression
Date: Tue, 29 Dec 2015 21:09:13 +0100
Message-ID: <1451419755-29997-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59834 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775AbbL2UJ2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Dec 2015 15:09:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C48691022AC
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Dec 2015 21:09:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C48B9DA801
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Dec 2015 21:09:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B5380DA7FF
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Dec 2015 21:09:20 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The multiton_expr rule matches range, prefix and wildcard expressions
which don't make sense from the non-constant lhs. This rule is there to
handle the nat statement case, whose expression may be composed of
address and port ranges (hence range expressions).

To resolve this, this patch adds the stmt_expr rule to handle the
possible occurrences of map, multiton and primary expressions from
statements.

This results in more rules but it narrows down what we can find from
expressions that are part of action statements.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 54 ++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 10 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index d42bd2f..b49eadb 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -486,6 +486,10 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	multiton_expr
 %type <expr>			prefix_expr range_expr wildcard_expr
 %destructor { expr_free($$); }	prefix_expr range_expr wildcard_expr
+
+%type <expr>			stmt_expr concat_stmt_expr map_stmt_expr
+%destructor { expr_free($$); }	stmt_expr concat_stmt_expr map_stmt_expr
+
 %type <expr>			list_expr
 %destructor { expr_free($$); }	list_expr
 %type <expr>			concat_expr
@@ -1577,20 +1581,51 @@ nat_stmt_alloc		:	SNAT
 			}
 			;
 
-nat_stmt_args		:	expr
+concat_stmt_expr	:	primary_expr
+			|	concat_stmt_expr	DOT	primary_expr
+			{
+				if ($$->ops->type != EXPR_CONCAT) {
+					$$ = concat_expr_alloc(&@$);
+					compound_expr_add($$, $1);
+				} else {
+					struct location rhs[] = {
+						[1]	= @2,
+						[2]	= @3,
+					};
+					location_update(&$3->location, rhs, 2);
+
+					$$ = $1;
+					$$->location = @$;
+				}
+				compound_expr_add($$, $3);
+			}
+			;
+
+map_stmt_expr		:	concat_stmt_expr	MAP	rhs_expr
+			{
+				$$ = map_expr_alloc(&@$, $1, $3);
+			}
+			;
+
+stmt_expr		:	map_stmt_expr
+			|	multiton_expr
+			|	primary_expr
+			;
+
+nat_stmt_args		:	stmt_expr
 			{
 				$<stmt>0->nat.addr = $1;
 			}
-			|	expr	COLON	expr
+			|	stmt_expr	COLON	stmt_expr
 			{
 				$<stmt>0->nat.addr = $1;
 				$<stmt>0->nat.proto = $3;
 			}
-			|	COLON	expr
+			|	COLON		stmt_expr
 			{
 				$<stmt>0->nat.proto = $2;
 			}
-			|	nat_stmt_args	nf_nat_flags
+			|       nat_stmt_args   nf_nat_flags
 			{
 				$<stmt>0->nat.flags = $2;
 			}
@@ -1614,7 +1649,7 @@ redir_stmt		:	redir_stmt_alloc	redir_stmt_arg
 redir_stmt_alloc	:	REDIRECT	{ $$ = redir_stmt_alloc(&@$); }
 			;
 
-redir_stmt_arg		:	TO	expr
+redir_stmt_arg		:	TO	stmt_expr
 			{
 				$<stmt>0->redir.proto = $2;
 			}
@@ -1622,19 +1657,19 @@ redir_stmt_arg		:	TO	expr
 			{
 				$<stmt>0->redir.flags = $1;
 			}
-			|	TO	expr	nf_nat_flags
+			|	TO	stmt_expr	nf_nat_flags
 			{
 				$<stmt>0->redir.proto = $2;
 				$<stmt>0->redir.flags = $3;
 			}
 			;
 
-dup_stmt		:	DUP	TO	expr
+dup_stmt		:	DUP	TO	stmt_expr
 			{
 				$$ = dup_stmt_alloc(&@$);
 				$$->dup.to = $3;
 			}
-			|	DUP	TO	expr 	DEVICE	expr
+			|	DUP	TO	stmt_expr 	DEVICE	stmt_expr
 			{
 				$$ = dup_stmt_alloc(&@$);
 				$$->dup.to = $3;
@@ -1671,7 +1706,7 @@ queue_stmt_args		:	queue_stmt_arg
 			|	queue_stmt_args	queue_stmt_arg
 			;
 
-queue_stmt_arg		:	QUEUENUM	expr
+queue_stmt_arg		:	QUEUENUM	stmt_expr
 			{
 				$<stmt>0->queue.queue = $2;
 			}
@@ -1865,7 +1900,6 @@ map_expr		:	concat_expr	MAP	rhs_expr
 			;
 
 expr			:	concat_expr
-			|	multiton_expr
 			|	set_expr
 			|       map_expr
 			;
-- 
2.1.4

