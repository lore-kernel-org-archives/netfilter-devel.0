From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3 nft] parser: restore bitwise operations from the rhs of relational expressions
Date: Tue, 29 Dec 2015 21:09:15 +0100
Message-ID: <1451419755-29997-3-git-send-email-pablo@netfilter.org>
References: <1451419755-29997-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59836 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885AbbL2UJ2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Dec 2015 15:09:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E07E01022B0
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Dec 2015 21:09:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CF01ADA807
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Dec 2015 21:09:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EEC9EDA795
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Dec 2015 21:09:22 +0100 (CET)
In-Reply-To: <1451419755-29997-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Reintroduce bitwise operation on constants that was removed in ("parser:
restrict relational rhs expression recursion") since we support this
since the beginning.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 47 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 6 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9f75abe..af51e4d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -514,8 +514,11 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %type <expr>			rhs_expr concat_rhs_expr basic_rhs_expr
 %destructor { expr_free($$); }	rhs_expr concat_rhs_expr basic_rhs_expr
-%type <expr>			primary_rhs_expr list_rhs_expr
-%destructor { expr_free($$); }	primary_rhs_expr list_rhs_expr
+%type <expr>			primary_rhs_expr list_rhs_expr shift_rhs_expr
+%destructor { expr_free($$); }	primary_rhs_expr list_rhs_expr shift_rhs_expr
+%type <expr>			and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
+%destructor { expr_free($$); }	and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
+
 
 %type <expr>			relational_expr
 %destructor { expr_free($$); }	relational_expr
@@ -2010,7 +2013,42 @@ rhs_expr		:	concat_rhs_expr		{ $$ = $1; }
 			|	set_expr		{ $$ = $1; }
 			;
 
-concat_rhs_expr		:	basic_rhs_expr		{ $$ = $1; }
+shift_rhs_expr		:	primary_rhs_expr
+			|	shift_rhs_expr		LSHIFT		primary_rhs_expr
+			{
+				$$ = binop_expr_alloc(&@$, OP_LSHIFT, $1, $3);
+			}
+			|	shift_rhs_expr		RSHIFT		primary_rhs_expr
+			{
+				$$ = binop_expr_alloc(&@$, OP_RSHIFT, $1, $3);
+			}
+			;
+
+and_rhs_expr		:	shift_rhs_expr
+			|	and_rhs_expr		AMPERSAND	shift_rhs_expr
+			{
+				$$ = binop_expr_alloc(&@$, OP_AND, $1, $3);
+			}
+			;
+
+exclusive_or_rhs_expr	:	and_rhs_expr
+			|	exclusive_or_rhs_expr	CARET		and_rhs_expr
+			{
+				$$ = binop_expr_alloc(&@$, OP_XOR, $1, $3);
+			}
+			;
+
+inclusive_or_rhs_expr	:	exclusive_or_rhs_expr
+			|	inclusive_or_rhs_expr	'|'		exclusive_or_rhs_expr
+			{
+				$$ = binop_expr_alloc(&@$, OP_OR, $1, $3);
+			}
+			;
+
+basic_rhs_expr		:	inclusive_or_rhs_expr
+			;
+
+concat_rhs_expr		:	basic_rhs_expr
 			|	concat_rhs_expr	DOT	basic_rhs_expr
 			{
 				if ($$->ops->type != EXPR_CONCAT) {
@@ -2030,9 +2068,6 @@ concat_rhs_expr		:	basic_rhs_expr		{ $$ = $1; }
 			}
 			;
 
-basic_rhs_expr		:	primary_rhs_expr	{ $$ = $1; }
-			;
-
 primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 			|	integer_expr		{ $$ = $1; }
 			|	ETHER
-- 
2.1.4

