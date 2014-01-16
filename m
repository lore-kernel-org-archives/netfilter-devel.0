From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: use ':' instead of '=>' in dictionaries
Date: Thu, 16 Jan 2014 18:37:22 +0100
Message-ID: <1389893842-17821-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54749 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaAPRha (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:37:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Replace => by : to make it easier for most shell users, as
> implies a redirection, let's avoid possible confusion that
may result if you forget to escape it.

This works fine if you don't forget to add space between the
key and the value. If you forget to add the space, depending
on the case, the scanner may recognize it correctly or process
it as a string.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Tested here with many combinations, works fine if you don't
forget the spaces. If you do, the result in unspecified since
depending on the combination it may accept it or spot a
parsing error.

 files/examples/sets_and_maps |    8 ++++----
 include/expression.h         |    2 +-
 src/expression.c             |    2 +-
 src/parser.y                 |    7 +++----
 src/rule.c                   |    2 +-
 src/scanner.l                |    1 -
 tests/dictionary             |   30 +++++++++++++++---------------
 tests/loop-detect.3          |    2 +-
 tests/loop-detect.4          |    2 +-
 tests/verdict-maps           |    6 +++---
 10 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/files/examples/sets_and_maps b/files/examples/sets_and_maps
index adfc688..a05199a 100755
--- a/files/examples/sets_and_maps
+++ b/files/examples/sets_and_maps
@@ -25,13 +25,13 @@ table filter {
 		type ifindex
 	}
 
-	# named map of type ifindex => ipv4_address
+	# named map of type ifindex : ipv4_address
 	map nat_map {
-		type ifindex => ipv4_address
+		type ifindex : ipv4_address
 	}
 
 	map jump_map {
-		type ifindex => verdict
+		type ifindex : verdict
 	}
 
 	chain input_1 { counter; }
@@ -48,6 +48,6 @@ table filter {
 		meta iif @local_ifs counter
 		meta iif vmap @jump_map
 
-		#meta iif vmap { eth0 => jump input1, eth1 => jump input2 }
+		#meta iif vmap { eth0 : jump input1, eth1 : jump input2 }
 	}
 }
diff --git a/include/expression.h b/include/expression.h
index f0eb799..a167cf5 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -27,7 +27,7 @@
  * @EXPR_LIST:		list of expressions
  * @EXPR_SET:		literal set
  * @EXPR_SET_REF:	set reference
- * @EXPR_MAPPING:	a single mapping (key => value)
+ * @EXPR_MAPPING:	a single mapping (key : value)
  * @EXPR_MAP:		map operation (expr map { EXPR_MAPPING, ... })
  * @EXPR_UNARY:		byteorder conversion, generated during evaluation
  * @EXPR_BINOP:		binary operations (bitwise, shifts)
diff --git a/src/expression.c b/src/expression.c
index a12133c..c856622 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -644,7 +644,7 @@ struct expr *set_expr_alloc(const struct location *loc)
 static void mapping_expr_print(const struct expr *expr)
 {
 	expr_print(expr->left);
-	printf(" => ");
+	printf(" : ");
 	expr_print(expr->right);
 }
 
diff --git a/src/parser.y b/src/parser.y
index 23662f7..fce0a33 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -150,7 +150,6 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token ASTERISK			"*"
 %token DASH			"-"
 %token AT			"@"
-%token ARROW			"=>"
 %token VMAP			"vmap"
 
 %token INCLUDE			"include"
@@ -751,7 +750,7 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	map_block	common_block
 			|	map_block	stmt_seperator
 			|	map_block	TYPE
-						identifier	ARROW	identifier
+						identifier	COLON	identifier
 						stmt_seperator
 			{
 				$1->keytype = datatype_lookup_byname($3);
@@ -1243,11 +1242,11 @@ set_list_member_expr	:	opt_newline	expr	opt_newline
 			{
 				$$ = $2;
 			}
-			|	opt_newline	map_lhs_expr	ARROW	concat_expr	opt_newline
+			|	opt_newline	map_lhs_expr	COLON	concat_expr	opt_newline
 			{
 				$$ = mapping_expr_alloc(&@$, $2, $4);
 			}
-			|	opt_newline	map_lhs_expr	ARROW	verdict_expr	opt_newline
+			|	opt_newline	map_lhs_expr	COLON	verdict_expr	opt_newline
 			{
 				$$ = mapping_expr_alloc(&@$, $2, $4);
 			}
diff --git a/src/rule.c b/src/rule.c
index ec8b6a4..04dd6c7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -96,7 +96,7 @@ void set_print(const struct set *set)
 
 	printf("\t\ttype %s", set->keytype->name);
 	if (set->flags & SET_F_MAP)
-		printf(" => %s", set->datatype->name);
+		printf(" : %s", set->datatype->name);
 	printf("\n");
 
 	if (set->flags & SET_F_ANONYMOUS)
diff --git a/src/scanner.l b/src/scanner.l
index 936c035..25fbc61 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -221,7 +221,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "@"			{ return AT; }
 "$"			{ return '$'; }
 "="			{ return '='; }
-"=>"			{ return ARROW; }
 "vmap"			{ return VMAP; }
 
 "include"		{ return INCLUDE; }
diff --git a/tests/dictionary b/tests/dictionary
index 4193529..b4e6c52 100644
--- a/tests/dictionary
+++ b/tests/dictionary
@@ -21,32 +21,32 @@ add rule ip filter OUTPUT tcp dport { \
 	192.168.0.1, \
 }
 
-# must succeed: expr { expr => verdict, ... }
+# must succeed: expr { expr : verdict, ... }
 add rule ip filter OUTPUT tcp dport vmap { \
-	22 => jump chain1, \
-	23 => jump chain2, \
+	22 : jump chain1, \
+	23 : jump chain2, \
 }
 
-# must fail: expr { expr => verdict, expr => expr, ... }
+# must fail: expr { expr : verdict, expr : expr, ... }
 add rule ip filter OUTPUT tcp dport vmap { \
-	22 => jump chain1, \
-	23 => 0x100, \
+	22 : jump chain1, \
+	23 : 0x100, \
 }
 
-# must fail: expr { expr => expr, ...}
+# must fail: expr { expr : expr, ...}
 add rule ip filter OUTPUT tcp dport vmap { \
-	22 => 0x100, \
-	23 => 0x200, \
+	22 : 0x100, \
+	23 : 0x200, \
 }
 
-# must succeed: expr MAP { expr => expr, ... } expr
+# must succeed: expr MAP { expr : expr, ... } expr
 add rule ip filter OUTPUT meta mark set tcp dport map { \
-	22 => 1, \
-	23 => 2, \
+	22 : 1, \
+	23 : 2, \
 }
 
-# must fail: expr MAP { expr => type1, expr => type2, .. } expr
+# must fail: expr MAP { expr : type1, expr : type2, .. } expr
 add rule ip filter OUTPUT meta mark set tcp dport map { \
-	22 => 1, \
-	23 => 192.168.0.1, \
+	22 : 1, \
+	23 : 192.168.0.1, \
 }
diff --git a/tests/loop-detect.3 b/tests/loop-detect.3
index 3b83ef1..80f7fc5 100644
--- a/tests/loop-detect.3
+++ b/tests/loop-detect.3
@@ -4,4 +4,4 @@
 flush table filter
 add filter chain1 jump chain2
 add filter chain2 jump chain3
-add filter chain3 ip daddr vmap { 10.0.0.1 => continue, 192.168.0.1 => jump chain1 }
+add filter chain3 ip daddr vmap { 10.0.0.1 : continue, 192.168.0.1 : jump chain1 }
diff --git a/tests/loop-detect.4 b/tests/loop-detect.4
index f6f4d57..acd9a34 100644
--- a/tests/loop-detect.4
+++ b/tests/loop-detect.4
@@ -3,5 +3,5 @@
 # Circular jump with an intermediate anonymous verdict map: chain1 -> chain2 -> chain3 -> chain1
 flush table filter
 add filter chain1 jump chain2
-add filter chain2 ip daddr vmap { 10.0.0.1 => continue, 192.168.0.1 => jump chain3 }
+add filter chain2 ip daddr vmap { 10.0.0.1 : continue, 192.168.0.1 : jump chain3 }
 add filter chain3 jump chain1
diff --git a/tests/verdict-maps b/tests/verdict-maps
index 72ef98f..c1630ce 100644
--- a/tests/verdict-maps
+++ b/tests/verdict-maps
@@ -14,7 +14,7 @@ add chain ip filter chain3
 add filter chain3 counter
 
 add filter input ip saddr vmap { \
-	10.0.0.0/24 => jump chain1, \
-	10.0.0.0/8  => jump chain2, \
-	8.8.8.8 => jump chain3 \
+	10.0.0.0/24 : jump chain1, \
+	10.0.0.0/8  : jump chain2, \
+	8.8.8.8 : jump chain3 \
 }
-- 
1.7.10.4

