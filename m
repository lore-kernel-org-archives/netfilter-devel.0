From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] parser: allow ct eventmask set new,related
Date: Wed,  7 Jun 2017 12:24:09 +0200
Message-ID: <20170607102410.21024-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44856 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751207AbdFGKXw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jun 2017 06:23:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In case of bitmask types (tcp flags, ct eventmask) nft
allows to use comma operator to test multiple values, i.e.
tcp flags syn,ack   ct event new,destroy etc.

But currently nft fails to use this when used in a statement, i.e.
   ... ct eventmask set new,destroy
gives:
syntax error, unexpected comma

This allows makes this work, it is the same as
   ct eventmask set new|destroy

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6be94a9b873f..a8448e14ef1f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -635,8 +635,11 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	rt_expr
 %type <val>			rt_key
 
-%type <expr>			ct_expr
-%destructor { expr_free($$); }	ct_expr
+%type <expr>			list_stmt_expr
+%destructor { expr_free($$); }	list_stmt_expr
+
+%type <expr>			ct_expr		ct_stmt_expr
+%destructor { expr_free($$); }	ct_expr		ct_stmt_expr
 %type <val>			ct_key		ct_key_dir	ct_key_dir_optional
 
 %type <expr>			fib_expr
@@ -3174,11 +3177,29 @@ ct_key_dir_optional	:	BYTES		{ $$ = NFT_CT_BYTES; }
 			|	ZONE		{ $$ = NFT_CT_ZONE; }
 			;
 
+list_stmt_expr		:	symbol_expr	COMMA	symbol_expr
+			{
+				$$ = list_expr_alloc(&@$);
+				compound_expr_add($$, $1);
+				compound_expr_add($$, $3);
+			}
+			|	list_stmt_expr	COMMA		symbol_expr
+			{
+				$1->location = @$;
+				compound_expr_add($1, $3);
+				$$ = $1;
+			}
+			;
+
+ct_stmt_expr		:	expr
+			|	list_stmt_expr
+			;
+
 ct_stmt			:	CT	ct_key		SET	expr
 			{
 				$$ = ct_stmt_alloc(&@$, $2, -1, $4);
 			}
-			|	CT	STRING		SET	expr
+			|	CT	STRING		SET	ct_stmt_expr
 			{
 				struct error_record *erec;
 				unsigned int key;
-- 
2.13.0

