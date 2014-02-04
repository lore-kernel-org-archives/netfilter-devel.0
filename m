From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] parser: prohibit redefinitions of symbols and verify existance on use
Date: Tue,  4 Feb 2014 11:26:40 +0000
Message-ID: <1391513200-31872-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45305 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaBDL0u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Feb 2014 06:26:50 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes some incorrect behaviour of symbolic variables:

- prohibit redefining an existing symbol
- verify existance of a symbolic variable during parsing instead of evaluation

The second point makes sure we don't allow recursive definitions (var = $var),
which lead to a crash due to stack exhaustion.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/parser.y            | 21 ++++++++++++++++++---
 tests/symbolic-define.1 |  7 +++++++
 tests/symbolic-define.2 |  7 +++++++
 tests/symbolic-define.3 |  6 ++++++
 4 files changed, 38 insertions(+), 3 deletions(-)
 create mode 100644 tests/symbolic-define.1
 create mode 100644 tests/symbolic-define.2
 create mode 100644 tests/symbolic-define.3

diff --git a/src/parser.y b/src/parser.y
index cc0aed6..f6c9488 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -520,7 +520,15 @@ common_block		:	INCLUDE		QUOTED_STRING	stmt_seperator
 			}
 			|	DEFINE		identifier	'='	initializer_expr	stmt_seperator
 			{
-				symbol_bind(current_scope(state), $2, $4);
+				struct scope *scope = current_scope(state);
+
+				if (symbol_lookup(scope, $2) != NULL) {
+					erec_queue(error(&@2, "redfinition of symbol '%s'", $2),
+						   state->msgs);
+					YYERROR;
+				}
+
+				symbol_bind(scope, $2, $4);
 				xfree($2);
 			}
 			|	error		stmt_seperator
@@ -1228,9 +1236,16 @@ symbol_expr		:	string
 			}
 			|	'$'	identifier
 			{
+				struct scope *scope = current_scope(state);
+
+				if (symbol_lookup(scope, $2) == NULL) {
+					erec_queue(error(&@2, "unknown identifier '%s'", $2),
+						   state->msgs);
+					YYERROR;
+				}
+
 				$$ = symbol_expr_alloc(&@$, SYMBOL_DEFINE,
-						       current_scope(state),
-						       $2);
+						       scope, $2);
 				xfree($2);
 			}
 			|	AT	identifier
diff --git a/tests/symbolic-define.1 b/tests/symbolic-define.1
new file mode 100644
index 0000000..712ef71
--- /dev/null
+++ b/tests/symbolic-define.1
@@ -0,0 +1,7 @@
+#! nft -f
+
+# error: variable use before definition
+define var2 = $var1
+define var1 = eth0
+
+filter input iif $var2
diff --git a/tests/symbolic-define.2 b/tests/symbolic-define.2
new file mode 100644
index 0000000..cd3c23c
--- /dev/null
+++ b/tests/symbolic-define.2
@@ -0,0 +1,7 @@
+#! nft -f
+
+# error: redefinition of an existing variable
+define var1 = eth0
+define var1 = eth0
+
+filter input iif $var1
diff --git a/tests/symbolic-define.3 b/tests/symbolic-define.3
new file mode 100644
index 0000000..ba224df
--- /dev/null
+++ b/tests/symbolic-define.3
@@ -0,0 +1,6 @@
+#! nft -f
+
+# error: recursive definition of a variable
+define var1 = $var1
+
+filter input iif $var1
-- 
1.8.5.3

