From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] bison: permit keywords in list_stmt_expressions
Date: Wed, 27 Sep 2017 19:38:07 +0200
Message-ID: <20170927173807.29882-4-fw@strlen.de>
References: <20170927173807.29882-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37602 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751016AbdI0RiD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 13:38:03 -0400
In-Reply-To: <20170927173807.29882-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

'ct event set label' and 'ct event set new or label' work, but
'ct event set new, label' did not:

  nft add rule filter input ct event set new,label
  Error: syntax error, unexpected label

This changes the definition to also contain keyword symbol expressions.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y        | 11 +++++++----
 tests/py/any/ct.t         |  1 +
 tests/py/any/ct.t.payload |  5 +++++
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index ce6a77a89847..87ae4c30712a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -609,8 +609,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %type <expr>			rhs_expr concat_rhs_expr basic_rhs_expr
 %destructor { expr_free($$); }	rhs_expr concat_rhs_expr basic_rhs_expr
-%type <expr>			primary_rhs_expr list_rhs_expr shift_rhs_expr
-%destructor { expr_free($$); }	primary_rhs_expr list_rhs_expr shift_rhs_expr
+%type <expr>			primary_rhs_expr list_rhs_expr shift_rhs_expr symbol_rhs_expr
+%destructor { expr_free($$); }	primary_rhs_expr list_rhs_expr shift_rhs_expr symbol_rhs_expr
 %type <expr>			and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 %destructor { expr_free($$); }	and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 
@@ -3302,14 +3302,17 @@ ct_key_dir_optional	:	BYTES		{ $$ = NFT_CT_BYTES; }
 			|	ZONE		{ $$ = NFT_CT_ZONE; }
 			;
 
+symbol_rhs_expr		:	symbol_expr
+			|	keyword_expr
+			;
 
-list_stmt_expr		:	symbol_expr	COMMA	symbol_expr
+list_stmt_expr		:	symbol_rhs_expr	COMMA	symbol_rhs_expr
 			{
 				$$ = list_expr_alloc(&@$);
 				compound_expr_add($$, $1);
 				compound_expr_add($$, $3);
 			}
-			|	list_stmt_expr	COMMA		symbol_expr
+			|	list_stmt_expr	COMMA	symbol_rhs_expr
 			{
 				$1->location = @$;
 				compound_expr_add($1, $3);
diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index f02bd0420e68..fb3ae098b14a 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -107,6 +107,7 @@ ct mark original;fail
 ct event set new;ok
 ct event set new or related or destroy or foobar;fail
 ct event set 'new | related | destroy | label';ok;ct event set new,related,destroy,label
+ct event set new,related,destroy,label;ok
 ct event set new,destroy;ok
 ct event set 1;ok;ct event set new
 ct event set 0x0;ok
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 20acbb9b63d1..7ebf3f8d327e 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -401,6 +401,11 @@ ip test-ip4 output
   [ immediate reg 1 0x00000407 ]
   [ ct set event with reg 1 ]
 
+# ct event set new,related,destroy,label
+ip test-ip4 output
+  [ immediate reg 1 0x00000407 ]
+  [ ct set event with reg 1 ]
+
 # ct event set new,destroy
 ip test-ip4 output
   [ immediate reg 1 0x00000005 ]
-- 
2.13.5

