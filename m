From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] parser_bison: allow variable references in set elements definition
Date: Mon, 29 Aug 2016 17:55:56 +0200
Message-ID: <1472486156-21937-1-git-send-email-pablo@netfilter.org>
Cc: andreas.hainke@foteviken.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49114 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932166AbcH2P4J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Aug 2016 11:56:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 61E8B11E5A5
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 17:56:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 53D18100A65
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 17:56:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0CB99100A66
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 17:56:03 +0200 (CEST)
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
 src/parser_bison.y | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

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
-- 
2.1.4

