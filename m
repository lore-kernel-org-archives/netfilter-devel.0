From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC nft PATCH] syntax: replace '=>' with '=:'
Date: Sun, 12 Jan 2014 20:41:33 +0100
Message-ID: <20140112194132.7369.3907.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:46156 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751192AbaALTlp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jan 2014 14:41:45 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Almost all shell uses the '>' character as a key for redirecting
stdout/stderr to a file.
So, using it in the syntax means that the administrator is forced to scape the
character, or look for other workaround.

With this patch, '=>' is replaced with '=:', thus avoiding such situation.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expression.c |    2 +-
 src/parser.y     |    7 ++++---
 src/rule.c       |    2 +-
 src/scanner.l    |    1 +
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index 71154cc..b9df9ac 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -642,7 +642,7 @@ struct expr *set_expr_alloc(const struct location *loc)
 static void mapping_expr_print(const struct expr *expr)
 {
 	expr_print(expr->left);
-	printf(" => ");
+	printf(" =: ");
 	expr_print(expr->right);
 }
 
diff --git a/src/parser.y b/src/parser.y
index 26e71e3..577aba1 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -150,6 +150,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token DASH			"-"
 %token AT			"@"
 %token ARROW			"=>"
+%token MAP_SIGN			"=:"
 %token VMAP			"vmap"
 
 %token INCLUDE			"include"
@@ -751,7 +752,7 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	map_block	common_block
 			|	map_block	stmt_seperator
 			|	map_block	TYPE
-						identifier	ARROW	identifier
+						identifier	MAP_SIGN	identifier
 						stmt_seperator
 			{
 				$1->keytype = datatype_lookup_byname($3);
@@ -1243,11 +1244,11 @@ set_list_member_expr	:	opt_newline	expr	opt_newline
 			{
 				$$ = $2;
 			}
-			|	opt_newline	map_lhs_expr	ARROW	concat_expr	opt_newline
+			|	opt_newline	map_lhs_expr	MAP_SIGN	concat_expr	opt_newline
 			{
 				$$ = mapping_expr_alloc(&@$, $2, $4);
 			}
-			|	opt_newline	map_lhs_expr	ARROW	verdict_expr	opt_newline
+			|	opt_newline	map_lhs_expr	MAP_SIGN	verdict_expr	opt_newline
 			{
 				$$ = mapping_expr_alloc(&@$, $2, $4);
 			}
diff --git a/src/rule.c b/src/rule.c
index ec8b6a4..b593624 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -96,7 +96,7 @@ void set_print(const struct set *set)
 
 	printf("\t\ttype %s", set->keytype->name);
 	if (set->flags & SET_F_MAP)
-		printf(" => %s", set->datatype->name);
+		printf(" =: %s", set->datatype->name);
 	printf("\n");
 
 	if (set->flags & SET_F_ANONYMOUS)
diff --git a/src/scanner.l b/src/scanner.l
index cee6aa6..14470cf 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -210,6 +210,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "$"			{ return '$'; }
 "="			{ return '='; }
 "=>"			{ return ARROW; }
+"=:"			{ return MAP_SIGN; }
 "vmap"			{ return VMAP; }
 
 "include"		{ return INCLUDE; }

