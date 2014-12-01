From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 5/5] scanner: don't bug on too large values
Date: Mon,  1 Dec 2014 12:45:54 +0100
Message-ID: <1417434354-5782-6-git-send-email-pablo@netfilter.org>
References: <1417434354-5782-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41637 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbaLALns (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:43:48 -0500
In-Reply-To: <1417434354-5782-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a new ERROR symbol to handle scanning of too large values.

 <cmdline>:1:36-99: Error: bad value '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
 add rule ip test-ip4 input ct mark 0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
instead of:

 BUG: nft: scanner.l:470: nft_lex: Assertion `0' failed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y |   15 ++++++++++++++-
 src/scanner.l      |   12 ++++++++----
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index ad2951a..6c7a036 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -209,7 +209,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token <val> NUM		"number"
 %token <string> STRING		"string"
 %token <string> QUOTED_STRING
-%destructor { xfree($$); }	STRING QUOTED_STRING
+%token <string> ERROR		"error"
+%destructor { xfree($$); }	STRING QUOTED_STRING ERROR
 
 %token LL_HDR			"ll"
 %token NETWORK_HDR		"nh"
@@ -465,6 +466,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	list_expr
 %type <expr>			concat_expr map_lhs_expr
 %destructor { expr_free($$); }	concat_expr map_lhs_expr
+%type <expr>			error_expr
+%destructor { expr_free($$); }	error_expr
 
 %type <expr>			map_expr
 %destructor { expr_free($$); }	map_expr
@@ -1668,6 +1671,16 @@ expr			:	concat_expr
 			|	set_expr
 			|       map_expr
 			|	multiton_expr
+			|	error_expr
+			;
+
+error_expr		:	ERROR
+			{
+				$$ = NULL;
+				erec_queue(error(&@1, "bad value '%s'", $1),
+					   state->msgs);
+				YYERROR;
+			}
 			;
 
 set_expr		:	'{'	set_list_expr		'}'
diff --git a/src/scanner.l b/src/scanner.l
index f0ed8d4..8f14b0e 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -458,16 +458,20 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 {decstring}		{
 				errno = 0;
 				yylval->val = strtoull(yytext, NULL, 0);
-				if (errno != 0)
-					BUG();
+				if (errno != 0) {
+					yylval->string = xstrdup(yytext);
+					return ERROR;
+				}
 				return NUM;
 			}
 
 {hexstring}		{
 				errno = 0;
 				yylval->val = strtoull(yytext, NULL, 0);
-				if (errno != 0)
-					BUG();
+				if (errno != 0) {
+					yylval->string = xstrdup(yytext);
+					return ERROR;
+				}
 				return NUM;
 			}
 
-- 
1.7.10.4

