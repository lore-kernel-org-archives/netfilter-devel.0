From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 06/17] bison: permit keywords in list_stmt_expressions
Date: Wed, 28 Jun 2017 12:06:48 +0200
Message-ID: <20170628100659.26976-7-fw@strlen.de>
References: <20170628100659.26976-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33362 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751528AbdF1KHC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 06:07:02 -0400
In-Reply-To: <20170628100659.26976-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

previous patch makes 'ct event set label' work, but we also need
to allow "set new, label".

This changes the definition to also contain keyword symbol expressions.
Unfortunately, the older "|" syntax, "ct event new | label" (not in any release)
doesn't work anymore because it requires primary_expr to work and that
causes ambiguities in the parser (we can only re-use keywords if they're
restricted to RHS expressions).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 66f031d3ca69..577f4bee167e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -587,8 +587,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %type <expr>			rhs_expr concat_rhs_expr basic_rhs_expr
 %destructor { expr_free($$); }	rhs_expr concat_rhs_expr basic_rhs_expr
-%type <expr>			primary_rhs_expr list_rhs_expr shift_rhs_expr
-%destructor { expr_free($$); }	primary_rhs_expr list_rhs_expr shift_rhs_expr
+%type <expr>			primary_rhs_expr list_rhs_expr shift_rhs_expr	symbol_rhs_expr
+%destructor { expr_free($$); }	primary_rhs_expr list_rhs_expr shift_rhs_expr	symbol_rhs_expr
 %type <expr>			and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 %destructor { expr_free($$); }	and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 
@@ -3092,13 +3092,17 @@ ct_key_dir_optional	:	BYTES		{ $$ = NFT_CT_BYTES; }
 			|	ZONE		{ $$ = NFT_CT_ZONE; }
 			;
 
-list_stmt_expr		:	symbol_expr	COMMA	symbol_expr
+symbol_rhs_expr		:	symbol_expr
+			|	keyword_expr
+			;
+
+list_stmt_expr		:	symbol_rhs_expr	COMMA	symbol_rhs_expr
 			{
 				$$ = list_expr_alloc(&@$);
 				compound_expr_add($$, $1);
 				compound_expr_add($$, $3);
 			}
-			|	list_stmt_expr	COMMA		symbol_expr
+			|	list_stmt_expr	COMMA		symbol_rhs_expr
 			{
 				$1->location = @$;
 				compound_expr_add($1, $3);
-- 
2.13.0

