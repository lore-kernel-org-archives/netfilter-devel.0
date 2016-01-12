From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] parser_bison: initializer_expr must use rhs_expr
Date: Tue, 12 Jan 2016 13:48:33 +0100
Message-ID: <1452602913-18352-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36294 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934592AbcALMsm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jan 2016 07:48:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6170B130FC2
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2016 13:48:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5330BDA863
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2016 13:48:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 48097DA801
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2016 13:48:37 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use rhs_expr and list_rhs_expr as possible occurrences of
initializer_expr since we may only find constant expressions on the
right hand side of the assignment.

Fixes: 2a5d44d8b3c (parser: get rid of multiton_expr from lhs relational expression)
Reported-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index fcd4813..fcf84b9 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -490,8 +490,6 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <expr>			stmt_expr concat_stmt_expr map_stmt_expr
 %destructor { expr_free($$); }	stmt_expr concat_stmt_expr map_stmt_expr
 
-%type <expr>			list_expr
-%destructor { expr_free($$); }	list_expr
 %type <expr>			concat_expr
 %destructor { expr_free($$); }	concat_expr
 
@@ -1854,20 +1852,6 @@ concat_expr		:	basic_expr
 			}
 			;
 
-list_expr		:	basic_expr		COMMA		basic_expr
-			{
-				$$ = list_expr_alloc(&@$);
-				compound_expr_add($$, $1);
-				compound_expr_add($$, $3);
-			}
-			|	list_expr		COMMA		basic_expr
-			{
-				$1->location = @$;
-				compound_expr_add($1, $3);
-				$$ = $1;
-			}
-			;
-
 prefix_rhs_expr		:	basic_rhs_expr	SLASH	NUM
 			{
 				$$ = prefix_expr_alloc(&@$, $1, $3);
@@ -1976,8 +1960,8 @@ set_rhs_expr		:	concat_rhs_expr
 			|	verdict_expr
 			;
 
-initializer_expr	:	expr
-			|	list_expr
+initializer_expr	:	rhs_expr
+			|	list_rhs_expr
 			;
 
 relational_expr		:	expr	/* implicit */	rhs_expr
-- 
2.1.4

