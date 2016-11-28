From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] parser_bison: Allow parens on RHS of relational_expr
Date: Mon, 28 Nov 2016 18:51:43 +0100
Message-ID: <20161128175143.25201-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:51162 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752225AbcK1Rvy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 12:51:54 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is useful to allow a construct such as:

| tcp flags & (syn|fin) == (syn|fin)

Before, only the parentheses on the left side were allowed, but via a
quite funny path through the parser:

* expr might be a concat_expr
* concat_expr might be a basic_expr
* basic_expr is an inclusive_or_expr
* inclusive_or_expr might be an exclusive_or_expr
* exclusive_or_expr might be an and_expr
* and_expr might be 'and_expr AMPERSAND shift_expr'
  -> here we eliminate 'flags &' in above statement
* shift_expr might be a primary_expr
* primary_expr might be '( basic_expr )'

Commit a3e60492a684b ("parser: restrict relational rhs expression
recursion") introduced rhs_expr to disallow recursion on RHS, so just
reverting that change for relational_expr is a no go. Allowing rhs_expr
to be '( rhs_expr )' though seems way too intrusive to me since it's
being used in all kinds of places, so this patch is the safest way to
allow the above I could come up with.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_bison.y | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 91955c187f3f0..73a0eda9a5d87 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2254,6 +2254,10 @@ relational_expr		:	expr	/* implicit */	rhs_expr
 			{
 				$$ = relational_expr_alloc(&@2, $2, $1, $3);
 			}
+			|	expr	relational_op	'(' rhs_expr ')'
+			{
+				$$ = relational_expr_alloc(&@2, $2, $1, $4);
+			}
 			;
 
 list_rhs_expr		:	basic_rhs_expr		COMMA		basic_rhs_expr
-- 
2.10.0

