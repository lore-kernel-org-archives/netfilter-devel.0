From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: add interface wildcard matching
Date: Sun, 18 Oct 2015 20:02:16 +0200
Message-ID: <1445191336-2041-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35746 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbbJRRzT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Oct 2015 13:55:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Contrary to iptables, we use '*' as wildcard as in udev since the '+' can be
used as a valid interface name.

 # nft --debug=netlink add rule test test iifname eth\*
 ip test test
   [ meta load iifname => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00ffffff 0x00000000 0x00000000 0x00000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
   [ cmp eq reg 1 0x2a687465 0x00000000 0x00000000 0x00000000 ]

Wildcard string are not allowed from sets and maps:

 # nft --debug=netlink add rule filter input iifname { "eth*", "eth1" } counter
 <cmdline>:1:33-36: Error: Unexpected wildcard string
 add rule filter input iifname { eth*, eth1 } counter
                                 ^^^^

We don't have to worry about concatenations at this stage since we don't
support concatenations with variable length datatypes (ie. string).

The wildcard string handling occurs from the evaluation step, where we convert
the simple from:

          relational
             /  \
            /    \
         meta   value
       oifname   eth*

to:
          relational
           /    \
          /      \
      binop(&)  value
        / \      eth
       /   \
    meta   value
  ofiname  ffffffff

Another observation: It should be easy to extend this patch to support wildcard
string ct helper matching.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                      | 58 ++++++++++++++++++++++++++++++++++++-
 src/netlink_delinearize.c           | 29 ++++++++++++++++++-
 src/parser_bison.y                  |  4 ++-
 src/scanner.l                       |  6 ++++
 tests/regression/any/meta.t         |  2 ++
 tests/regression/any/meta.t.payload | 12 ++++++++
 6 files changed, 108 insertions(+), 3 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 4f9299e..e9857c9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -20,7 +20,6 @@
 #include <netinet/ip_icmp.h>
 #include <netinet/icmp6.h>
 #include <net/ethernet.h>
-#include <net/if.h>
 
 #include <expression.h>
 #include <statement.h>
@@ -743,6 +742,23 @@ static int expr_evaluate_list(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
+static bool expr_is_string_wildcard(struct expr *expr)
+{
+	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE), datalen;
+	char data[len + 1];
+
+	if (expr_basetype(expr)->type != TYPE_STRING)
+		return false;
+
+	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
+
+	datalen = strlen(data) - 1;
+	if (data[datalen] != '*')
+		return false;
+
+	return true;
+}
+
 static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *elem = *expr;
@@ -750,6 +766,10 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 	if (expr_evaluate(ctx, &elem->key) < 0)
 		return -1;
 
+	if (expr_is_string_wildcard(elem->key))
+		return expr_error(ctx->msgs, elem,
+				  "Unexpected wildcard string");
+
 	elem->dtype = elem->key->dtype;
 	elem->len   = elem->key->len;
 	elem->flags = elem->key->flags;
@@ -963,6 +983,36 @@ static int binop_transfer(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
+static void expr_string_wildcard(struct eval_ctx *ctx, struct expr *rel)
+{
+	struct expr *left = rel->left, *right = rel->right;
+	unsigned int len = div_round_up(right->len, BITS_PER_BYTE), datalen;
+	struct expr *mask, *binop, *value;
+	char data[len + 1];
+
+	mpz_export_data(data, right->value, BYTEORDER_HOST_ENDIAN, len);
+
+	datalen = strlen(data) - 1;
+	if (data[datalen] != '*')
+		return;
+
+	data[datalen] = '\0';
+	mask = constant_expr_alloc(&rel->location, left->dtype, left->byteorder,
+				   len, NULL);
+	mpz_init2(mask->value, right->len);
+	mpz_bitmask(mask->value, datalen * BITS_PER_BYTE);
+
+	value = constant_expr_alloc(&rel->location, right->dtype,
+				    right->byteorder, right->len, data);
+
+	binop = binop_expr_alloc(&rel->location, OP_AND, left, mask);
+	binop->len = right->len;
+	rel->left = binop;
+	rel->right = value;
+
+	expr_free(right);
+}
+
 static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *rel = *expr, *left, *right;
@@ -973,6 +1023,12 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 
 	if (expr_evaluate(ctx, &rel->right) < 0)
 		return -1;
+
+	if (rel->left->ops->type == EXPR_META &&
+	    expr_basetype(rel->right)->type == TYPE_STRING &&
+	    rel->right->ops->type == EXPR_VALUE)
+		expr_string_wildcard(ctx, rel);
+
 	right = rel->right;
 
 	if (rel->op == OP_IMPLICIT) {
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 09f5932..8d59d49 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1088,7 +1088,7 @@ static void meta_match_postprocess(struct rule_pp_ctx *ctx,
 }
 
 /* Convert a bitmask to a prefix length */
-static unsigned int expr_mask_to_prefix(struct expr *expr)
+static unsigned int expr_mask_to_prefix(const struct expr *expr)
 {
 	unsigned long n;
 
@@ -1110,6 +1110,23 @@ static bool expr_mask_is_prefix(const struct expr *expr)
 	return true;
 }
 
+static struct expr *string_wildcard_expr_alloc(struct location *loc,
+					       const struct expr *mask,
+					       const struct expr *value)
+{
+	unsigned int len = div_round_up(value->len, BITS_PER_BYTE);
+	char data[len];
+	int pos;
+
+	mpz_export_data(data, value->value, BYTEORDER_HOST_ENDIAN, len);
+	pos = div_round_up(expr_mask_to_prefix(mask), BITS_PER_BYTE);
+	data[pos] = '*';
+	data[pos + 1] = '\0';
+
+	return constant_expr_alloc(loc, &string_type, BYTEORDER_HOST_ENDIAN,
+				   value->len + BITS_PER_BYTE, data);
+}
+
 /* Convert a series of inclusive OR expressions into a list */
 static struct expr *binop_tree_to_list(struct expr *list, struct expr *expr)
 {
@@ -1157,6 +1174,16 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
 		expr_free(value);
 		expr_free(binop);
 	} else if (binop->op == OP_AND &&
+		   binop->left->ops->type == EXPR_META &&
+		   binop->right->ops->type == EXPR_VALUE &&
+		   expr_mask_is_prefix(binop->right)) {
+
+		expr->left = expr_get(binop->left);
+		expr->right = string_wildcard_expr_alloc(&expr->location,
+							 binop->right, value);
+		expr_free(value);
+		expr_free(binop);
+	} else if (binop->op == OP_AND &&
 		   binop->left->ops->type == EXPR_PAYLOAD &&
 		   binop->right->ops->type == EXPR_VALUE) {
 		struct expr *payload = expr->left->left;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 98480b6..940dd72 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -216,7 +216,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token <val> NUM		"number"
 %token <string> STRING		"string"
 %token <string> QUOTED_STRING
-%destructor { xfree($$); }	STRING QUOTED_STRING
+%token <string> WILDCARD_STRING
+%destructor { xfree($$); }	STRING QUOTED_STRING WILDCARD_STRING
 
 %token LL_HDR			"ll"
 %token NETWORK_HDR		"nh"
@@ -1159,6 +1160,7 @@ identifier		:	STRING
 
 string			:	STRING
 			|	QUOTED_STRING
+			|	WILDCARD_STRING
 			;
 
 time_spec		:	STRING
diff --git a/src/scanner.l b/src/scanner.l
index b827489..2a992d3 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -114,6 +114,7 @@ range		({decstring}?:{decstring}?)
 letter		[a-zA-Z]
 string		({letter})({letter}|{digit}|[/\-_\.])*
 quotedstring	\"[^"]*\"
+wildcardstring	{string}\*
 comment		#.*$
 slash		\/
 
@@ -498,6 +499,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return QUOTED_STRING;
 			}
 
+{wildcardstring}	{
+				yylval->string = xstrdup(yytext);
+				return WILDCARD_STRING;
+			}
+
 {string}		{
 				yylval->string = xstrdup(yytext);
 				return STRING;
diff --git a/tests/regression/any/meta.t b/tests/regression/any/meta.t
index ddb360d..7a5fedc 100644
--- a/tests/regression/any/meta.t
+++ b/tests/regression/any/meta.t
@@ -66,6 +66,7 @@ meta iifname "eth0";ok;iifname "eth0"
 meta iifname != "eth0";ok;iifname != "eth0"
 meta iifname {"eth0", "lo"};ok
 - meta iifname != {"eth0", "lo"};ok
+meta iifname "eth*";ok;iifname "eth*"
 
 meta iiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
 - meta iiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
@@ -83,6 +84,7 @@ meta oifname "eth0";ok;oifname "eth0"
 meta oifname != "eth0";ok;oifname != "eth0"
 meta oifname { "eth0", "lo"};ok
 - meta iifname != {"eth0", "lo"};ok
+meta oifname "eth*";ok;oifname "eth*"
 
 meta oiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
 - meta oiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
diff --git a/tests/regression/any/meta.t.payload b/tests/regression/any/meta.t.payload
index 0243d80..bf5dd59 100644
--- a/tests/regression/any/meta.t.payload
+++ b/tests/regression/any/meta.t.payload
@@ -217,6 +217,12 @@ ip test-ip4 input
   [ meta load iifname => reg 1 ]
   [ lookup reg 1 set set%d ]
 
+# meta iifname "eth*"
+ip test-ip4 input
+  [ meta load iifname => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffffff 0x00000000 0x00000000 0x00000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x00687465 0x00000000 0x00000000 0x00000000 ]
+
 # meta iiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre}
 set%d test-ip4 3
 set%d test-ip4 0
@@ -284,6 +290,12 @@ ip test-ip4 input
   [ meta load oifname => reg 1 ]
   [ lookup reg 1 set set%d ]
 
+# meta oifname "eth*"
+ip test-ip4 input
+  [ meta load oifname => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffffff 0x00000000 0x00000000 0x00000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x00687465 0x00000000 0x00000000 0x00000000 ]
+
 # meta oiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre}
 set%d test-ip4 3
 set%d test-ip4 0
-- 
2.1.4

