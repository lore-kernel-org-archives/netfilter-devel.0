Return-Path: <SRS0=YpW3=ZI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12322C432C3
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Nov 2019 20:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6F2C206F4
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Nov 2019 20:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfKPUCR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Nov 2019 15:02:17 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:58106 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727420AbfKPUCR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Nov 2019 15:02:17 -0500
Received: from localhost ([::1]:42964 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iW4Gt-000545-C7; Sat, 16 Nov 2019 21:02:15 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] parser_bison: Avoid set references in odd places
Date:   Sat, 16 Nov 2019 21:02:07 +0100
Message-Id: <20191116200207.6501-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With set references being recognized by symbol_expr and that being part
of primary_expr as well as primary_rhs_expr, they could basically occur
anywhere while in fact they are allowed only in quite a few spots.

Untangle things a bit by introducing set_ref_expr and adding that only
in places where it is needed to pass testsuites.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_bison.y | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3f2832564036e..220ffafef135b 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -645,6 +645,8 @@ int nft_lex(void *, void *, void *);
 %destructor { expr_free($$); }	exclusive_or_expr inclusive_or_expr
 %type <expr>			basic_expr
 %destructor { expr_free($$); }	basic_expr
+%type <expr>			set_ref_expr
+%destructor { expr_free($$); }	set_ref_expr
 
 %type <expr>			multiton_rhs_expr
 %destructor { expr_free($$); }	multiton_rhs_expr
@@ -2439,13 +2441,7 @@ verdict_map_expr	:	'{'	verdict_map_list_expr	'}'
 				$2->location = @$;
 				$$ = $2;
 			}
-			|	AT	identifier
-			{
-				$$ = symbol_expr_alloc(&@$, SYMBOL_SET,
-						       current_scope(state),
-						       $2);
-				xfree($2);
-			}
+			|	set_ref_expr
 			;
 
 verdict_map_list_expr	:	verdict_map_list_member_expr
@@ -3014,7 +3010,7 @@ concat_stmt_expr	:	basic_stmt_expr
 			;
 
 map_stmt_expr_set	:	set_expr
-			|	symbol_expr
+			|	set_ref_expr
 			;
 
 map_stmt_expr		:	concat_stmt_expr	MAP	map_stmt_expr_set
@@ -3241,21 +3237,21 @@ set_elem_expr_stmt_alloc:	concat_expr
 			}
 			;
 
-set_stmt		:	SET	set_stmt_op	set_elem_expr_stmt	symbol_expr
+set_stmt		:	SET	set_stmt_op	set_elem_expr_stmt	set_ref_expr
 			{
 				$$ = set_stmt_alloc(&@$);
 				$$->set.op  = $2;
 				$$->set.key = $3;
 				$$->set.set = $4;
 			}
-			|	set_stmt_op	symbol_expr	'{' set_elem_expr_stmt	'}'
+			|	set_stmt_op	set_ref_expr	'{' set_elem_expr_stmt	'}'
 			{
 				$$ = set_stmt_alloc(&@$);
 				$$->set.op  = $1;
 				$$->set.key = $4;
 				$$->set.set = $2;
 			}
-			|	set_stmt_op	symbol_expr '{'	set_elem_expr_stmt	stateful_stmt	'}'
+			|	set_stmt_op	set_ref_expr '{' set_elem_expr_stmt	stateful_stmt	'}'
 			{
 				$$ = set_stmt_alloc(&@$);
 				$$->set.op  = $1;
@@ -3270,7 +3266,7 @@ set_stmt_op		:	ADD	{ $$ = NFT_DYNSET_OP_ADD; }
 			|	DELETE  { $$ = NFT_DYNSET_OP_DELETE; }
 			;
 
-map_stmt		:	set_stmt_op	symbol_expr '{'	set_elem_expr_stmt	COLON	set_elem_expr_stmt	'}'
+map_stmt		:	set_stmt_op	set_ref_expr '{' set_elem_expr_stmt	COLON	set_elem_expr_stmt	'}'
 			{
 				$$ = map_stmt_alloc(&@$);
 				$$->map.op  = $1;
@@ -3278,7 +3274,7 @@ map_stmt		:	set_stmt_op	symbol_expr '{'	set_elem_expr_stmt	COLON	set_elem_expr_s
 				$$->map.data = $6;
 				$$->map.set = $2;
 			}
-			|	set_stmt_op	symbol_expr '{'	set_elem_expr_stmt	stateful_stmt COLON	set_elem_expr_stmt	'}'
+			|	set_stmt_op	set_ref_expr '{' set_elem_expr_stmt	stateful_stmt COLON	set_elem_expr_stmt	'}'
 			{
 				$$ = map_stmt_alloc(&@$);
 				$$->map.op  = $1;
@@ -3378,7 +3374,9 @@ symbol_expr		:	variable_expr
 						       $1);
 				xfree($1);
 			}
-			|	AT	identifier
+			;
+
+set_ref_expr		:	AT	identifier
 			{
 				$$ = symbol_expr_alloc(&@$, SYMBOL_SET,
 						       current_scope(state),
@@ -3903,6 +3901,7 @@ list_rhs_expr		:	basic_rhs_expr		COMMA		basic_rhs_expr
 rhs_expr		:	concat_rhs_expr		{ $$ = $1; }
 			|	multiton_rhs_expr	{ $$ = $1; }
 			|	set_expr		{ $$ = $1; }
+			|	set_ref_expr		{ $$ = $1; }
 			;
 
 shift_rhs_expr		:	primary_rhs_expr
-- 
2.24.0

