From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] nft: Add support for inverted bitwise value list
Date: Wed, 22 Jun 2016 17:49:48 +0200
Message-ID: <20160622154945.GA12610@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34161 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbcFVPvd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 11:51:33 -0400
Received: by mail-wm0-f66.google.com with SMTP id 187so2489588wmz.1
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 08:49:57 -0700 (PDT)
Received: from sonyv (cli-5b7e49a2.wholesale.adamo.es. [91.126.73.162])
        by smtp.gmail.com with ESMTPSA id t1sm19121wjy.3.2016.06.22.08.49.50
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 22 Jun 2016 08:49:50 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for inverted state and status bitwise value list required in the
ct match.

Before this patch, nft didn't support the rule:

$ nft add rule ip filter INPUT ct state != new,related counter accept
<cmdline>:1:41-41: Error: syntax error, unexpected comma, expecting end of file or newline or semicolon
add rule ip filter INPUT ct state != new,related counter accept
                                        ^

This patch includes in the parser the ability to understand a list of
bitwise values.

nft --debug=netlink add rule ip filter INPUT ct state != new,related,established,untracked counter accept
ip filter INPUT
  [ ct load state => reg 1 ]
  [ cmp neq reg 1 0x0000004e ]
  [ counter pkts 0 bytes 0 ]
  [ immediate reg 0 accept ]

In addition, this patch prints the correct rule syntax.

table ip filter {
	chain INPUT {
		ct state != established,related,new,untracked counter packets 0 bytes 0 accept
	}
}

And some tests included:

ct state != new,related;ok
ct status != expected,seen-reply;ok

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 src/expression.c   | 12 +++++++++++-
 src/parser_bison.y |  1 +
 tests/py/any/ct.t  |  2 ++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/src/expression.c b/src/expression.c
index a10af5d..2ba4d83 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -524,13 +524,23 @@ static bool must_print_eq_op(const struct expr *expr)
 	return expr->left->ops->type == EXPR_BINOP;
 }
 
+static void binop_expr_print_symbol(const struct expr *expr)
+{
+	if (expr->op == OP_OR &&
+	    (expr->right->dtype->type == TYPE_CT_STATE ||
+	    expr->right->dtype->type == TYPE_CT_STATUS))
+		printf(",");
+	else
+		printf(" %s ", expr_op_symbols[expr->op]);
+}
+
 static void binop_expr_print(const struct expr *expr)
 {
 	binop_arg_print(expr, expr->left);
 
 	if (expr_op_symbols[expr->op] &&
 	    (expr->op != OP_EQ || must_print_eq_op(expr)))
-		printf(" %s ", expr_op_symbols[expr->op]);
+		binop_expr_print_symbol(expr);
 	else
 		printf(" ");
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index d7cba23..02d23b9 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2097,6 +2097,7 @@ list_rhs_expr		:	basic_rhs_expr		COMMA		basic_rhs_expr
 rhs_expr		:	concat_rhs_expr		{ $$ = $1; }
 			|	multiton_rhs_expr	{ $$ = $1; }
 			|	set_expr		{ $$ = $1; }
+			|       list_rhs_expr           { $$ = $1; }
 			;
 
 shift_rhs_expr		:	primary_rhs_expr
diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index 4d13213..4d0273f 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -6,6 +6,7 @@
 
 ct state new,established, related, untracked;ok;ct state established,related,new,untracked
 ct state != related;ok
+ct state != new,related;ok
 ct state {new,established, related, untracked};ok
 - ct state != {new,established, related, untracked};ok
 ct state invalid drop;ok
@@ -25,6 +26,7 @@ ct status expected;ok
 ct status != expected;ok
 ct status seen-reply;ok
 ct status != seen-reply;ok
+ct status != expected,seen-reply;ok
 ct status {expected, seen-reply, assured, confirmed, dying};ok
 ct status expected,seen-reply,assured,confirmed,snat,dnat,dying;ok
 ct status snat;ok
-- 
2.7.0

