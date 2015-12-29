From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3 nft] parser: rename multiton_expr to multiton_rhs_expr
Date: Tue, 29 Dec 2015 21:09:14 +0100
Message-ID: <1451419755-29997-2-git-send-email-pablo@netfilter.org>
References: <1451419755-29997-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59835 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbbL2UJ2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Dec 2015 15:09:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id DD7D71022AD
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Dec 2015 21:09:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D169ADA85F
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Dec 2015 21:09:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 00F8FDA803
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Dec 2015 21:09:22 +0100 (CET)
In-Reply-To: <1451419755-29997-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This rule catches occurrences from the constant rhs, rename it for
readability reasons.

Note that this rule is still used from the set lhs definition that is
always constant (as it represents the key to look up for the
corresponding element).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index b49eadb..9f75abe 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -482,10 +482,10 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <expr>			basic_expr
 %destructor { expr_free($$); }	basic_expr
 
-%type <expr>			multiton_expr
-%destructor { expr_free($$); }	multiton_expr
-%type <expr>			prefix_expr range_expr wildcard_expr
-%destructor { expr_free($$); }	prefix_expr range_expr wildcard_expr
+%type <expr>			multiton_rhs_expr
+%destructor { expr_free($$); }	multiton_rhs_expr
+%type <expr>			prefix_rhs_expr range_rhs_expr wildcard_rhs_expr
+%destructor { expr_free($$); }	prefix_rhs_expr range_rhs_expr wildcard_rhs_expr
 
 %type <expr>			stmt_expr concat_stmt_expr map_stmt_expr
 %destructor { expr_free($$); }	stmt_expr concat_stmt_expr map_stmt_expr
@@ -1608,8 +1608,8 @@ map_stmt_expr		:	concat_stmt_expr	MAP	rhs_expr
 			;
 
 stmt_expr		:	map_stmt_expr
-			|	multiton_expr
-			|	primary_expr
+			|	multiton_rhs_expr
+			|	primary_rhs_expr
 			;
 
 nat_stmt_args		:	stmt_expr
@@ -1865,19 +1865,19 @@ list_expr		:	basic_expr		COMMA		basic_expr
 			}
 			;
 
-prefix_expr		:	basic_rhs_expr		SLASH	NUM
+prefix_rhs_expr		:	basic_rhs_expr	SLASH	NUM
 			{
 				$$ = prefix_expr_alloc(&@$, $1, $3);
 			}
 			;
 
-range_expr		:	basic_rhs_expr		DASH	basic_rhs_expr
+range_rhs_expr		:	basic_rhs_expr	DASH	basic_rhs_expr
 			{
 				$$ = range_expr_alloc(&@$, $1, $3);
 			}
 			;
 
-wildcard_expr		:	ASTERISK
+wildcard_rhs_expr	:	ASTERISK
 	       		{
 				struct expr *expr;
 
@@ -1888,9 +1888,9 @@ wildcard_expr		:	ASTERISK
 			}
 			;
 
-multiton_expr		:	prefix_expr
-			|	range_expr
-			|	wildcard_expr
+multiton_rhs_expr	:	prefix_rhs_expr
+			|	range_rhs_expr
+			|	wildcard_rhs_expr
 			;
 
 map_expr		:	concat_expr	MAP	rhs_expr
@@ -1966,7 +1966,7 @@ set_elem_option		:	TIMEOUT			time_spec
 			;
 
 set_lhs_expr		:	concat_rhs_expr
-			|	multiton_expr
+			|	multiton_rhs_expr
 			;
 
 set_rhs_expr		:	concat_rhs_expr
@@ -2006,7 +2006,7 @@ list_rhs_expr		:	basic_rhs_expr		COMMA		basic_rhs_expr
 			;
 
 rhs_expr		:	concat_rhs_expr		{ $$ = $1; }
-			|	multiton_expr		{ $$ = $1; }
+			|	multiton_rhs_expr	{ $$ = $1; }
 			|	set_expr		{ $$ = $1; }
 			;
 
-- 
2.1.4

