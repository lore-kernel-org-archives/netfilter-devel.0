From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/3] parser_bison: consolidate stmt_expr rule
Date: Tue, 26 Sep 2017 19:09:49 +0200
Message-ID: <1506445791-20482-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51630 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935589AbdIZRJ7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2017 13:09:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F3EED220B5
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2017 19:09:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E569EB502A
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2017 19:09:57 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Extend stmt_expr and use it from all of our statement rules. Add more
rules to describe what we take from statement expressions, instead of
reusing rhs_expr which is allowing way more things that we actually need
here. This is causing us problems when extending the grammar.

After this patch, you will hit this:

	parser_bison.y: warning: 2 shift/reduce conflicts [-Wconflicts-sr]

However, this is fixed by the follow up patches:

	parser_bison: allow helper keyword in ct object kind
	parser_bison: use keywords in ct expression

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 123 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 102 insertions(+), 21 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 31a7e8be2bcd..8bcf64e9903d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -560,6 +560,18 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <expr>			stmt_expr concat_stmt_expr map_stmt_expr
 %destructor { expr_free($$); }	stmt_expr concat_stmt_expr map_stmt_expr
 
+%type <expr>			multiton_stmt_expr
+%destructor { expr_free($$); }	multiton_stmt_expr
+%type <expr>			prefix_stmt_expr range_stmt_expr wildcard_stmt_expr
+%destructor { expr_free($$); }	prefix_stmt_expr range_stmt_expr wildcard_stmt_expr
+
+%type <expr>			primary_stmt_expr basic_stmt_expr
+%destructor { expr_free($$); }	primary_stmt_expr basic_stmt_expr
+%type <expr>			list_stmt_expr shift_stmt_expr
+%destructor { expr_free($$); }	list_stmt_expr shift_stmt_expr
+%type <expr>			and_stmt_expr exclusive_or_stmt_expr inclusive_or_stmt_expr
+%destructor { expr_free($$); }	and_stmt_expr exclusive_or_stmt_expr inclusive_or_stmt_expr
+
 %type <expr>			concat_expr
 %destructor { expr_free($$); }	concat_expr
 
@@ -644,11 +656,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	rt_expr
 %type <val>			rt_key
 
-%type <expr>			list_stmt_expr
-%destructor { expr_free($$); }	list_stmt_expr
-
-%type <expr>			ct_expr		ct_stmt_expr
-%destructor { expr_free($$); }	ct_expr		ct_stmt_expr
+%type <expr>			ct_expr
+%destructor { expr_free($$); }	ct_expr
 %type <val>			ct_key		ct_key_dir	ct_key_dir_optional
 
 %type <expr>			fib_expr
@@ -2206,8 +2215,55 @@ nat_stmt_alloc		:	SNAT
 			}
 			;
 
-concat_stmt_expr	:	primary_expr
-			|	concat_stmt_expr	DOT	primary_expr
+primary_stmt_expr	:	symbol_expr		{ $$ = $1; }
+			|	integer_expr		{ $$ = $1; }
+			|	boolean_expr		{ $$ = $1; }
+			|	meta_expr		{ $$ = $1; }
+			|	rt_expr			{ $$ = $1; }
+			|	ct_expr			{ $$ = $1; }
+			|	numgen_expr             { $$ = $1; }
+			|	hash_expr               { $$ = $1; }
+			|	payload_expr		{ $$ = $1; }
+			|	keyword_rhs_expr	{ $$ = $1; }
+			;
+
+shift_stmt_expr		:	primary_stmt_expr
+			|	shift_stmt_expr		LSHIFT		primary_stmt_expr
+			{
+				$$ = binop_expr_alloc(&@$, OP_LSHIFT, $1, $3);
+			}
+			|	shift_stmt_expr		RSHIFT		primary_rhs_expr
+			{
+				$$ = binop_expr_alloc(&@$, OP_RSHIFT, $1, $3);
+			}
+			;
+
+and_stmt_expr		:	shift_stmt_expr
+			|	and_stmt_expr		AMPERSAND	shift_stmt_expr
+			{
+				$$ = binop_expr_alloc(&@$, OP_AND, $1, $3);
+			}
+			;
+
+exclusive_or_stmt_expr	:	and_stmt_expr
+			|	exclusive_or_stmt_expr	CARET		and_stmt_expr
+			{
+				$$ = binop_expr_alloc(&@$, OP_XOR, $1, $3);
+			}
+			;
+
+inclusive_or_stmt_expr	:	exclusive_or_stmt_expr
+			|	inclusive_or_stmt_expr	'|'		exclusive_or_stmt_expr
+			{
+				$$ = binop_expr_alloc(&@$, OP_OR, $1, $3);
+			}
+			;
+
+basic_stmt_expr		:	inclusive_or_stmt_expr
+			;
+
+concat_stmt_expr	:	basic_stmt_expr
+			|	concat_stmt_expr	DOT	primary_stmt_expr
 			{
 				if ($$->ops->type != EXPR_CONCAT) {
 					$$ = concat_expr_alloc(&@$);
@@ -2226,15 +2282,44 @@ concat_stmt_expr	:	primary_expr
 			}
 			;
 
-map_stmt_expr		:	concat_stmt_expr	MAP	rhs_expr
+map_stmt_expr		:	concat_stmt_expr	MAP	set_expr
 			{
 				$$ = map_expr_alloc(&@$, $1, $3);
 			}
+			|	concat_stmt_expr	{ $$ = $1; }
+			;
+
+prefix_stmt_expr	:	basic_stmt_expr	SLASH	NUM
+			{
+				$$ = prefix_expr_alloc(&@$, $1, $3);
+			}
+			;
+
+range_stmt_expr		:	basic_stmt_expr	DASH	basic_stmt_expr
+			{
+				$$ = range_expr_alloc(&@$, $1, $3);
+			}
+			;
+
+wildcard_stmt_expr	:	ASTERISK
+			{
+				struct expr *expr;
+
+				expr = constant_expr_alloc(&@$, &integer_type,
+							   BYTEORDER_HOST_ENDIAN,
+							   0, NULL);
+				$$ = prefix_expr_alloc(&@$, expr, 0);
+			}
+			;
+
+multiton_stmt_expr	:	prefix_stmt_expr
+			|	range_stmt_expr
+			|	wildcard_stmt_expr
 			;
 
 stmt_expr		:	map_stmt_expr
-			|	multiton_rhs_expr
-			|	primary_rhs_expr
+			|	multiton_stmt_expr
+			|	list_stmt_expr
 			;
 
 nat_stmt_args		:	stmt_expr
@@ -3148,15 +3233,15 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
 			|       CGROUP		{ $$ = NFT_META_CGROUP; }
 			;
 
-meta_stmt		:	META	meta_key	SET	expr
+meta_stmt		:	META	meta_key	SET	stmt_expr
 			{
 				$$ = meta_stmt_alloc(&@$, $2, $4);
 			}
-			|	meta_key_unqualified	SET	expr
+			|	meta_key_unqualified	SET	stmt_expr
 			{
 				$$ = meta_stmt_alloc(&@$, $1, $3);
 			}
-			|	META	STRING	SET	expr
+			|	META	STRING	SET	stmt_expr
 			{
 				struct error_record *erec;
 				unsigned int key;
@@ -3285,15 +3370,11 @@ list_stmt_expr		:	symbol_expr	COMMA	symbol_expr
 			}
 			;
 
-ct_stmt_expr		:	expr
-			|	list_stmt_expr
-			;
-
-ct_stmt			:	CT	ct_key		SET	expr
+ct_stmt			:	CT	ct_key		SET	stmt_expr
 			{
 				$$ = ct_stmt_alloc(&@$, $2, -1, $4);
 			}
-			|	CT	STRING		SET	ct_stmt_expr
+			|	CT	STRING		SET	stmt_expr
 			{
 				struct error_record *erec;
 				unsigned int key;
@@ -3316,7 +3397,7 @@ ct_stmt			:	CT	ct_key		SET	expr
 					break;
 				}
 			}
-			|	CT	STRING	ct_key_dir_optional SET	expr
+			|	CT	STRING	ct_key_dir_optional SET	stmt_expr
 			{
 				struct error_record *erec;
 				int8_t direction;
@@ -3332,7 +3413,7 @@ ct_stmt			:	CT	ct_key		SET	expr
 			}
 			;
 
-payload_stmt		:	payload_expr		SET	expr
+payload_stmt		:	payload_expr		SET	stmt_expr
 			{
 				if ($1->ops->type == EXPR_EXTHDR)
 					$$ = exthdr_stmt_alloc(&@$, $1, $3);
-- 
2.1.4

