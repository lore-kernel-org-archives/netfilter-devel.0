From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] parser: properly fix handling of large integer values
Date: Mon, 12 Jan 2015 00:07:01 +0000
Message-ID: <1421021221-29899-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63316 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbbALAHJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jan 2015 19:07:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Introduction of the ERROR symbol is an ugly hack. There's no reason
to special case large integer values, the NUM token only exists for
small values that are needed immediately, everything else is passed
as EXPR_SYMBOL to evaluation anyways.

Additionally the error reporting is different from what we'd usually
report, the token is easy to confuse with the bison internal error
token and it even has a name, messing up bison internal diagnostics.

Simply return values to large to be handled by strtoull as STRING.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/parser_bison.y | 15 +--------------
 src/scanner.l      |  4 ++--
 2 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6c46d09..fd2407c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -211,8 +211,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token <val> NUM		"number"
 %token <string> STRING		"string"
 %token <string> QUOTED_STRING
-%token <string> ERROR		"error"
-%destructor { xfree($$); }	STRING QUOTED_STRING ERROR
+%destructor { xfree($$); }	STRING QUOTED_STRING
 
 %token LL_HDR			"ll"
 %token NETWORK_HDR		"nh"
@@ -471,8 +470,6 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	list_expr
 %type <expr>			concat_expr map_lhs_expr
 %destructor { expr_free($$); }	concat_expr map_lhs_expr
-%type <expr>			error_expr
-%destructor { expr_free($$); }	error_expr
 
 %type <expr>			map_expr
 %destructor { expr_free($$); }	map_expr
@@ -1690,16 +1687,6 @@ expr			:	concat_expr
 			|	set_expr
 			|       map_expr
 			|	multiton_expr
-			|	error_expr
-			;
-
-error_expr		:	ERROR
-			{
-				$$ = NULL;
-				erec_queue(error(&@1, "bad value '%s'", $1),
-					   state->msgs);
-				YYERROR;
-			}
 			;
 
 set_expr		:	'{'	set_list_expr		'}'
diff --git a/src/scanner.l b/src/scanner.l
index 52b0078..73c4f8b 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -462,7 +462,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				yylval->val = strtoull(yytext, NULL, 0);
 				if (errno != 0) {
 					yylval->string = xstrdup(yytext);
-					return ERROR;
+					return STRING;
 				}
 				return NUM;
 			}
@@ -472,7 +472,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				yylval->val = strtoull(yytext, NULL, 0);
 				if (errno != 0) {
 					yylval->string = xstrdup(yytext);
-					return ERROR;
+					return STRING;
 				}
 				return NUM;
 			}
-- 
2.1.0

