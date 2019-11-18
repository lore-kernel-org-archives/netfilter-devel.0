Return-Path: <SRS0=asLr=ZK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0576C432C3
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 14:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7BEA20722
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 14:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfKROHa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 09:07:30 -0500
Received: from correo.us.es ([193.147.175.20]:34458 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbfKROHa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 09:07:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 97B348C3C58
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2019 15:07:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B506B8001
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2019 15:07:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 80E3CB7FFE; Mon, 18 Nov 2019 15:07:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 318ABB7FF2;
        Mon, 18 Nov 2019 15:07:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 15:07:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0CADA42EE38F;
        Mon, 18 Nov 2019 15:07:20 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft,v2] parser_bison: Avoid set references in odd places
Date:   Mon, 18 Nov 2019 15:07:18 +0100
Message-Id: <20191118140718.91492-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

With set references being recognized by symbol_expr and that being part
of primary_expr as well as primary_rhs_expr, they could basically occur
anywhere while in fact they are allowed only in quite a few spots.

Untangle things a bit by introducing set_ref_expr and adding that only
in places where it is needed to pass testsuites.

Make sure we still allow to define variables as set references, eg.

	define xyz = @setref

And allow to use them from set expressions and statements.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Extend Phil's original patch to support for set reference from
    variable definitions. We have no test to cover this, I will follow
    up with a patch for this.

 src/parser_bison.y | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3f2832564036..631b7d684555 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -645,6 +645,8 @@ int nft_lex(void *, void *, void *);
 %destructor { expr_free($$); }	exclusive_or_expr inclusive_or_expr
 %type <expr>			basic_expr
 %destructor { expr_free($$); }	basic_expr
+%type <expr>			set_ref_expr set_ref_symbol_expr
+%destructor { expr_free($$); }	set_ref_expr set_ref_symbol_expr
 
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
@@ -3378,7 +3374,13 @@ symbol_expr		:	variable_expr
 						       $1);
 				xfree($1);
 			}
-			|	AT	identifier
+			;
+
+set_ref_expr		:	set_ref_symbol_expr
+			|	variable_expr
+			;
+
+set_ref_symbol_expr	:	AT	identifier
 			{
 				$$ = symbol_expr_alloc(&@$, SYMBOL_SET,
 						       current_scope(state),
@@ -3903,6 +3905,7 @@ list_rhs_expr		:	basic_rhs_expr		COMMA		basic_rhs_expr
 rhs_expr		:	concat_rhs_expr		{ $$ = $1; }
 			|	multiton_rhs_expr	{ $$ = $1; }
 			|	set_expr		{ $$ = $1; }
+			|	set_ref_symbol_expr	{ $$ = $1; }
 			;
 
 shift_rhs_expr		:	primary_rhs_expr
-- 
2.11.0

