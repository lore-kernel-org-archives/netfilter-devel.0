From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 05/10] parser: fix inconsistencies in set expression rules
Date: Sun, 12 Apr 2015 13:16:13 +0100
Message-ID: <1428840978-27226-6-git-send-email-kaber@trash.net>
References: <1428840978-27226-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58913 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbbDLMQZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Apr 2015 08:16:25 -0400
In-Reply-To: <1428840978-27226-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Set keys are currently defined as a regular expr for pure sets and
map_lhs_expr for maps. map_lhs_expr is what can actually be used for
a single member, namely a concat_expr or a multiton_expr. The reason
why pure sets use expr for the key is to allow recursive set specifications,
which doesn't make sense for maps since every element needs a mapping.

However, the rule is too wide and also allows map expressions as a key,
which obviously doesn't make sense.

Rearrange the rules so we have:

set_lhs_expr:	concat or multiton
set_rhs_expr:	concat or verdict

and special case the recursive set specifications, as they deserve.

Besides making it a lot easier to understand what is actually supported,
this will be used by the following patch to support timeouts and comments
for keys in a uniform way.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/parser_bison.y | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index cd4e096..c934533 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -470,8 +470,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	prefix_expr range_expr wildcard_expr
 %type <expr>			list_expr
 %destructor { expr_free($$); }	list_expr
-%type <expr>			concat_expr map_lhs_expr
-%destructor { expr_free($$); }	concat_expr map_lhs_expr
+%type <expr>			concat_expr
+%destructor { expr_free($$); }	concat_expr
 
 %type <expr>			map_expr
 %destructor { expr_free($$); }	map_expr
@@ -484,6 +484,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %type <expr>			set_expr set_list_expr set_list_member_expr
 %destructor { expr_free($$); }	set_expr set_list_expr set_list_member_expr
+%type <expr>			set_lhs_expr set_rhs_expr
+%destructor { expr_free($$); }	set_lhs_expr set_rhs_expr
 
 %type <expr>			expr initializer_expr
 %destructor { expr_free($$); }	expr initializer_expr
@@ -1297,13 +1299,12 @@ verdict_map_list_expr	:	verdict_map_list_member_expr
 			|	verdict_map_list_expr	COMMA	opt_newline
 			;
 
-verdict_map_list_member_expr:	opt_newline	map_lhs_expr	COLON	verdict_expr	opt_newline
+verdict_map_list_member_expr:	opt_newline	set_lhs_expr	COLON	verdict_expr	opt_newline
 			{
 				$$ = mapping_expr_alloc(&@$, $2, $4);
 			}
 			;
 
-
 counter_stmt		:	counter_stmt_alloc
 			|	counter_stmt_alloc	counter_args
 
@@ -1718,10 +1719,6 @@ multiton_expr		:	prefix_expr
 			|	wildcard_expr
 			;
 
-map_lhs_expr		:	multiton_expr
-			|	concat_expr
-			;
-
 map_expr		:	concat_expr	MAP	expr
 			{
 				$$ = map_expr_alloc(&@$, $1, $3);
@@ -1729,9 +1726,9 @@ map_expr		:	concat_expr	MAP	expr
 			;
 
 expr			:	concat_expr
+			|	multiton_expr
 			|	set_expr
 			|       map_expr
-			|	multiton_expr
 			;
 
 set_expr		:	'{'	set_list_expr		'}'
@@ -1754,20 +1751,28 @@ set_list_expr		:	set_list_member_expr
 			|	set_list_expr		COMMA	opt_newline
 			;
 
-set_list_member_expr	:	opt_newline	expr	opt_newline
+set_list_member_expr	:	opt_newline	set_expr	opt_newline
 			{
 				$$ = $2;
 			}
-			|	opt_newline	map_lhs_expr	COLON	concat_expr	opt_newline
+			|	opt_newline	set_lhs_expr	opt_newline
 			{
-				$$ = mapping_expr_alloc(&@$, $2, $4);
+				$$ = $2;
 			}
-			|	opt_newline	map_lhs_expr	COLON	verdict_expr	opt_newline
+			|	opt_newline	set_lhs_expr	COLON	set_rhs_expr	opt_newline
 			{
 				$$ = mapping_expr_alloc(&@$, $2, $4);
 			}
 			;
 
+set_lhs_expr		:	concat_expr
+			|	multiton_expr
+			;
+
+set_rhs_expr		:	concat_expr
+			|	verdict_expr
+			;
+
 initializer_expr	:	expr
 			|	list_expr
 			;
-- 
2.1.0

