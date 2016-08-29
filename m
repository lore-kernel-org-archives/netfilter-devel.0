From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 8/8] parser_bison: allow variable references in set elements definition
Date: Mon, 29 Aug 2016 20:21:19 +0200
Message-ID: <1472494879-16442-8-git-send-email-pablo@netfilter.org>
References: <1472494879-16442-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48874 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752993AbcH2SVf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Aug 2016 14:21:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 90E411324E5
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7DD21100A66
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6E8C3100A66
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:32 +0200 (CEST)
In-Reply-To: <1472494879-16442-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Andreas reports that he cannot use variables in set definitions:

	define s-ext-2-int = 10.10.10.10 . 25, 10.10.10.10 . 143

        set s-ext-2-int {
                type ipv4_addr . inet_service
                elements =  { $s-ext-2-int }
        }

This syntax is not correct though, since the curly braces should be
placed in the variable definition itself, so we have context to handle
this variable as a list of set elements.

The correct syntax that works after this patch is:

	define s-ext-2-int = { 10.10.10.10 . 25, 10.10.10.10 . 143 }

	table inet forward {
        	set s-ext-2-int {
	                type ipv4_addr . inet_service
	                elements = $s-ext-2-int
	        }
	}

Reported-by: Andreas Hainke <andreas.hainke@foteviken.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y                         | 12 ++++++++----
 tests/shell/testcases/nft-f/0009variable_0 | 23 +++++++++++++++++++++++
 2 files changed, 31 insertions(+), 4 deletions(-)
 create mode 100755 tests/shell/testcases/nft-f/0009variable_0

diff --git a/src/parser_bison.y b/src/parser_bison.y
index a87468e..aac10dc 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -525,8 +525,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <expr>			verdict_map_expr verdict_map_list_expr verdict_map_list_member_expr
 %destructor { expr_free($$); }	verdict_map_expr verdict_map_list_expr verdict_map_list_member_expr
 
-%type <expr>			set_expr set_list_expr set_list_member_expr
-%destructor { expr_free($$); }	set_expr set_list_expr set_list_member_expr
+%type <expr>			set_expr set_block_expr set_list_expr set_list_member_expr
+%destructor { expr_free($$); }	set_expr set_block_expr set_list_expr set_list_member_expr
 %type <expr>			set_elem_expr set_elem_expr_alloc set_lhs_expr set_rhs_expr
 %destructor { expr_free($$); }	set_elem_expr set_elem_expr_alloc set_lhs_expr set_rhs_expr
 %type <expr>			set_elem_expr_stmt set_elem_expr_stmt_alloc
@@ -1061,7 +1061,7 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->gc_int = $3 * 1000;
 				$$ = $1;
 			}
-			|	set_block	ELEMENTS	'='		set_expr
+			|	set_block	ELEMENTS	'='		set_block_expr
 			{
 				$1->init = $4;
 				$$ = $1;
@@ -1069,6 +1069,10 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	set_block	set_mechanism	stmt_seperator
 			;
 
+set_block_expr		:	set_expr
+			|	variable_expr
+			;
+
 set_flag_list		:	set_flag_list	COMMA		set_flag
 			{
 				$$ = $1 | $3;
@@ -1104,7 +1108,7 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->flags |= $3;
 				$$ = $1;
 			}
-			|	map_block	ELEMENTS	'='		set_expr
+			|	map_block	ELEMENTS	'='		set_block_expr
 			{
 				$1->init = $4;
 				$$ = $1;
diff --git a/tests/shell/testcases/nft-f/0009variable_0 b/tests/shell/testcases/nft-f/0009variable_0
new file mode 100755
index 0000000..4d38707
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0009variable_0
@@ -0,0 +1,23 @@
+#!/bin/bash
+
+set -e
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="define concat-set-variable = { 10.10.10.10 . 25, 10.10.10.10 . 143 }
+
+table inet forward {
+	set concat-set-variable {
+		type ipv4_addr . inet_service
+		elements = \$concat-set-variable
+	}
+}"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
-- 
2.1.4

