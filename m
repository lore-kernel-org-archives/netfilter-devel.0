From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/2] parser: add grammatical distinction for verdict maps
Date: Fri,  7 Mar 2014 11:12:48 +0100
Message-ID: <1394187168-18977-2-git-send-email-kaber@trash.net>
References: <1394187168-18977-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36104 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbaCGKMz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:12:55 -0500
In-Reply-To: <1394187168-18977-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently the parser accepts verdicts in regular maps and non-verdicts
in verdict maps and we have to check matching types during evaluation.
Add grammar rules for verdict maps and seperate them from regular maps.
This has a couple of advantages:

- We recognize verdict maps completely in the parser and any attempt to
  mix verdicts and other expressions will result in a syntax error.
  So far this hasn't actually been checked.

- Using verdicts in non-verdict mappings will also result in a syntax
  error instead of a datatype mismatch.

- There's a grammatical distinction between dictionaries and verdict
  maps, which are actually statements.

This is needed as preparation for a following patch to turn verdicts
into pure statements, which in turn is needed to reinstate support for
using the queue verdict in maps, which was broken by the introduction
of the queue statement.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/parser.y | 52 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/src/parser.y b/src/parser.y
index dd09fb4..0d97ae9 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -428,8 +428,11 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <expr>			map_expr
 %destructor { expr_free($$); }	map_expr
 
-%type <expr>			verdict_map_expr
-%destructor { expr_free($$); }	verdict_map_expr
+%type <expr>			verdict_map_stmt
+%destructor { expr_free($$); }	verdict_map_stmt
+
+%type <expr>			verdict_map_expr verdict_map_list_expr verdict_map_list_member_expr
+%destructor { expr_free($$); }	verdict_map_expr verdict_map_list_expr verdict_map_list_member_expr
 
 %type <expr>			set_expr set_list_expr set_list_member_expr
 %destructor { expr_free($$); }	set_expr set_list_expr set_list_member_expr
@@ -1072,12 +1075,45 @@ verdict_stmt		:	verdict_expr
 			{
 				$$ = verdict_stmt_alloc(&@$, $1);
 			}
-			|	verdict_map_expr
+			|	verdict_map_stmt
 			{
 				$$ = verdict_stmt_alloc(&@$, $1);
 			}
 			;
 
+verdict_map_stmt	:	concat_expr	VMAP	verdict_map_expr
+			{
+				$$ = map_expr_alloc(&@$, $1, $3);
+			}
+			;
+
+verdict_map_expr	:	'{'	verdict_map_list_expr	'}'
+			{
+				$2->location = @$;
+				$$ = $2;
+			}
+			;
+
+verdict_map_list_expr	:	verdict_map_list_member_expr
+			{
+				$$ = set_expr_alloc(&@$);
+				compound_expr_add($$, $1);
+			}
+			|	verdict_map_list_expr	COMMA	verdict_map_list_member_expr
+			{
+				compound_expr_add($1, $3);
+				$$ = $1;
+			}
+			|	verdict_map_list_expr	COMMA	opt_newline
+			;
+
+verdict_map_list_member_expr:	opt_newline	map_lhs_expr	COLON	verdict_expr	opt_newline
+			{
+				$$ = mapping_expr_alloc(&@$, $2, $4);
+			}
+			;
+
+
 counter_stmt		:	counter_stmt_alloc
 			|	counter_stmt_alloc	counter_args
 
@@ -1404,12 +1440,6 @@ map_expr		:	concat_expr	MAP	expr
 			}
 			;
 
-verdict_map_expr	:	concat_expr	VMAP	expr
-			{
-				$$ = map_expr_alloc(&@$, $1, $3);
-			}
-			;
-
 expr			:	concat_expr
 			|	set_expr
 			|       map_expr
@@ -1444,10 +1474,6 @@ set_list_member_expr	:	opt_newline	expr	opt_newline
 			{
 				$$ = mapping_expr_alloc(&@$, $2, $4);
 			}
-			|	opt_newline	map_lhs_expr	COLON	verdict_expr	opt_newline
-			{
-				$$ = mapping_expr_alloc(&@$, $2, $4);
-			}
 			;
 
 initializer_expr	:	expr
-- 
1.8.5.3

