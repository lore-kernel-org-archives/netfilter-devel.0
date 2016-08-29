From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 7/8] parser_bison: add variable_expr rule
Date: Mon, 29 Aug 2016 20:21:18 +0200
Message-ID: <1472494879-16442-7-git-send-email-pablo@netfilter.org>
References: <1472494879-16442-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48880 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754599AbcH2SVf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Aug 2016 14:21:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DD0451324E4
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CBA34100A76
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B344D100A57
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:31 +0200 (CEST)
In-Reply-To: <1472494879-16442-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a rule for variable expression so we can reuse it in a
follow up patch to allow set element initialization from variable.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index dc79465..a87468e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -496,8 +496,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <stmt>			flow_stmt flow_stmt_alloc
 %destructor { stmt_free($$); }	flow_stmt flow_stmt_alloc
 
-%type <expr>			symbol_expr verdict_expr integer_expr
-%destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr
+%type <expr>			symbol_expr verdict_expr integer_expr variable_expr
+%destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr
 %type <expr>			primary_expr shift_expr and_expr
 %destructor { expr_free($$); }	primary_expr shift_expr and_expr
 %type <expr>			exclusive_or_expr inclusive_or_expr
@@ -1927,14 +1927,7 @@ match_stmt		:	relational_expr
 			}
 			;
 
-symbol_expr		:	string
-			{
-				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
-						       current_scope(state),
-						       $1);
-				xfree($1);
-			}
-			|	'$'	identifier
+variable_expr		:	'$'	identifier
 			{
 				struct scope *scope = current_scope(state);
 
@@ -1948,6 +1941,16 @@ symbol_expr		:	string
 						       scope, $2);
 				xfree($2);
 			}
+			;
+
+symbol_expr		:	variable_expr
+			|	string
+			{
+				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
+						       current_scope(state),
+						       $1);
+				xfree($1);
+			}
 			|	AT	identifier
 			{
 				$$ = symbol_expr_alloc(&@$, SYMBOL_SET,
-- 
2.1.4

