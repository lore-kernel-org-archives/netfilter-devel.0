From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft 1/2] parser: fix typo
Date: Wed, 23 Aug 2017 22:42:55 +0200
Message-ID: <20170823204256.31634-1-pablombg@gmail.com>
Cc: pablo@netfilter.org, "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36313 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbdHWUnK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2017 16:43:10 -0400
Received: by mail-wr0-f194.google.com with SMTP id u17so375344wrf.3
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2017 13:43:09 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Separator was misspelled as "seperator" in a symbol name.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 src/parser_bison.y | 74 +++++++++++++++++++++++++++---------------------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 18be53e..ca86df5 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -699,7 +699,7 @@ input			:	/* empty */
 			}
 			;
 
-stmt_seperator		:	NEWLINE
+stmt_separator		:	NEWLINE
 			|	SEMICOLON
 			;
 
@@ -707,7 +707,7 @@ opt_newline		:	NEWLINE
 		 	|	/* empty */
 			;
 
-common_block		:	INCLUDE		QUOTED_STRING	stmt_seperator
+common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
 			{
 				if (scanner_include_file(scanner, $2, &@$) < 0) {
 					xfree($2);
@@ -715,7 +715,7 @@ common_block		:	INCLUDE		QUOTED_STRING	stmt_seperator
 				}
 				xfree($2);
 			}
-			|	DEFINE		identifier	'='	initializer_expr	stmt_seperator
+			|	DEFINE		identifier	'='	initializer_expr	stmt_separator
 			{
 				struct scope *scope = current_scope(state);
 
@@ -728,7 +728,7 @@ common_block		:	INCLUDE		QUOTED_STRING	stmt_seperator
 				symbol_bind(scope, $2, $4);
 				xfree($2);
 			}
-			|	error		stmt_seperator
+			|	error		stmt_separator
 			{
 				if (++state->nerrs == max_errors)
 					YYABORT;
@@ -737,8 +737,8 @@ common_block		:	INCLUDE		QUOTED_STRING	stmt_seperator
 			;
 
 line			:	common_block			{ $$ = NULL; }
-			|	stmt_seperator			{ $$ = NULL; }
-			|	base_cmd	stmt_seperator	{ $$ = $1; }
+			|	stmt_separator			{ $$ = NULL; }
+			|	base_cmd	stmt_separator	{ $$ = $1; }
 			|	base_cmd	TOKEN_EOF
 			{
 				/*
@@ -851,7 +851,7 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
-			|	CT	STRING	obj_spec	ct_obj_alloc	'{' ct_block '}'	stmt_seperator
+			|	CT	STRING	obj_spec	ct_obj_alloc	'{' ct_block '}'	stmt_separator
 			{
 				struct error_record *erec;
 				int type;
@@ -930,7 +930,7 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
-			|	CT	STRING	obj_spec	ct_obj_alloc	'{' ct_block '}'	stmt_seperator
+			|	CT	STRING	obj_spec	ct_obj_alloc	'{' ct_block '}'	stmt_separator
 			{
 				struct error_record *erec;
 				int type;
@@ -1238,11 +1238,11 @@ table_options		:	FLAGS		STRING
 
 table_block		:	/* empty */	{ $$ = $<table>-1; }
 			|	table_block	common_block
-			|	table_block	stmt_seperator
-			|	table_block	table_options	stmt_seperator
+			|	table_block	stmt_separator
+			|	table_block	table_options	stmt_separator
 			|	table_block	CHAIN		chain_identifier
 					chain_block_alloc	'{' 	chain_block	'}'
-					stmt_seperator
+					stmt_separator
 			{
 				$4->location = @3;
 				handle_merge(&$4->handle, &$3);
@@ -1253,7 +1253,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 			}
 			|	table_block	SET		set_identifier
 					set_block_alloc		'{'	set_block	'}'
-					stmt_seperator
+					stmt_separator
 			{
 				$4->location = @3;
 				handle_merge(&$4->handle, &$3);
@@ -1263,7 +1263,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 			}
 			|	table_block	MAP		set_identifier
 					map_block_alloc		'{'	map_block	'}'
-					stmt_seperator
+					stmt_separator
 			{
 				$4->location = @3;
 				handle_merge(&$4->handle, &$3);
@@ -1273,7 +1273,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 			}
 			|	table_block	COUNTER		obj_identifier
 					obj_block_alloc	'{'	counter_block	'}'
-					stmt_seperator
+					stmt_separator
 			{
 				$4->location = @3;
 				$4->type = NFT_OBJECT_COUNTER;
@@ -1284,7 +1284,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 			}
 			|	table_block	QUOTA		obj_identifier
 					obj_block_alloc	'{'	quota_block	'}'
-					stmt_seperator
+					stmt_separator
 			{
 				$4->location = @3;
 				$4->type = NFT_OBJECT_QUOTA;
@@ -1293,7 +1293,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$4->list, &$1->objs);
 				$$ = $1;
 			}
-			|	table_block	CT	ct_obj_kind	obj_identifier  obj_block_alloc '{'     ct_block     '}' stmt_seperator
+			|	table_block	CT	ct_obj_kind	obj_identifier  obj_block_alloc '{'     ct_block     '}' stmt_separator
 			{
 				struct error_record *erec;
 				int type;
@@ -1322,10 +1322,10 @@ chain_block_alloc	:	/* empty */
 
 chain_block		:	/* empty */	{ $$ = $<chain>-1; }
 			|	chain_block	common_block
-	     		|	chain_block	stmt_seperator
-			|	chain_block	hook_spec	stmt_seperator
-			|	chain_block	policy_spec	stmt_seperator
-			|	chain_block	rule		stmt_seperator
+			|	chain_block	stmt_separator
+			|	chain_block	hook_spec	stmt_separator
+			|	chain_block	policy_spec	stmt_separator
+			|	chain_block	rule		stmt_separator
 			{
 				list_add_tail(&$2->list, &$1->rules);
 				$$ = $1;
@@ -1340,23 +1340,23 @@ set_block_alloc		:	/* empty */
 
 set_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	set_block	common_block
-			|	set_block	stmt_seperator
-			|	set_block	TYPE		data_type	stmt_seperator
+			|	set_block	stmt_separator
+			|	set_block	TYPE		data_type	stmt_separator
 			{
 				$1->keytype = $3;
 				$$ = $1;
 			}
-			|	set_block	FLAGS		set_flag_list	stmt_seperator
+			|	set_block	FLAGS		set_flag_list	stmt_separator
 			{
 				$1->flags = $3;
 				$$ = $1;
 			}
-			|	set_block	TIMEOUT		time_spec	stmt_seperator
+			|	set_block	TIMEOUT		time_spec	stmt_separator
 			{
 				$1->timeout = $3 * 1000;
 				$$ = $1;
 			}
-			|	set_block	GC_INTERVAL	time_spec	stmt_seperator
+			|	set_block	GC_INTERVAL	time_spec	stmt_separator
 			{
 				$1->gc_int = $3 * 1000;
 				$$ = $1;
@@ -1366,7 +1366,7 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->init = $4;
 				$$ = $1;
 			}
-			|	set_block	set_mechanism	stmt_seperator
+			|	set_block	set_mechanism	stmt_separator
 			;
 
 set_block_expr		:	set_expr
@@ -1393,10 +1393,10 @@ map_block_alloc		:	/* empty */
 
 map_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	map_block	common_block
-			|	map_block	stmt_seperator
+			|	map_block	stmt_separator
 			|	map_block	TYPE
 						data_type	COLON	data_type
-						stmt_seperator
+						stmt_separator
 			{
 				$1->keytype  = $3;
 				$1->datatype = $5;
@@ -1405,7 +1405,7 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			}
 			|	map_block	TYPE
 						data_type	COLON	COUNTER
-						stmt_seperator
+						stmt_separator
 			{
 				$1->keytype = $3;
 				$1->objtype = NFT_OBJECT_COUNTER;
@@ -1414,14 +1414,14 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			}
 			|	map_block	TYPE
 						data_type	COLON	QUOTA
-						stmt_seperator
+						stmt_separator
 			{
 				$1->keytype = $3;
 				$1->objtype = NFT_OBJECT_QUOTA;
 				$1->flags  |= NFT_SET_OBJECT;
 				$$ = $1;
 			}
-			|	map_block	FLAGS		set_flag_list	stmt_seperator
+			|	map_block	FLAGS		set_flag_list	stmt_separator
 			{
 				$1->flags |= $3;
 				$$ = $1;
@@ -1431,7 +1431,7 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->init = $4;
 				$$ = $1;
 			}
-			|	map_block	set_mechanism	stmt_seperator
+			|	map_block	set_mechanism	stmt_separator
 			;
 
 set_mechanism		:	POLICY		set_policy_spec
@@ -1489,7 +1489,7 @@ obj_block_alloc		:       /* empty */
 
 counter_block		:	/* empty */	{ $$ = $<obj>-1; }
 			|       counter_block     common_block
-			|       counter_block     stmt_seperator
+			|       counter_block     stmt_separator
 			|       counter_block     counter_config
 			{
 				$1->counter = *$2;
@@ -1499,7 +1499,7 @@ counter_block		:	/* empty */	{ $$ = $<obj>-1; }
 
 quota_block		:	/* empty */	{ $$ = $<obj>-1; }
 			|       quota_block     common_block
-			|       quota_block     stmt_seperator
+			|       quota_block     stmt_separator
 			|       quota_block     quota_config
 			{
 				$1->quota = *$2;
@@ -1509,7 +1509,7 @@ quota_block		:	/* empty */	{ $$ = $<obj>-1; }
 
 ct_block		:	/* empty */	{ $$ = $<obj>-1; }
 			|       ct_block     common_block
-			|       ct_block     stmt_seperator
+			|       ct_block     stmt_separator
 			|       ct_block     ct_config
 			{
 				$$ = $1;
@@ -2717,7 +2717,7 @@ ct_l4protoname		:	TCP	{ $$ = IPPROTO_TCP; }
 			|	UDP	{ $$ = IPPROTO_UDP; }
 			;
 
-ct_config		:	TYPE	QUOTED_STRING	PROTOCOL	ct_l4protoname	stmt_seperator
+ct_config		:	TYPE	QUOTED_STRING	PROTOCOL	ct_l4protoname	stmt_separator
 			{
 				struct ct_helper *ct;
 				int ret;
@@ -2732,7 +2732,7 @@ ct_config		:	TYPE	QUOTED_STRING	PROTOCOL	ct_l4protoname	stmt_seperator
 
 				ct->l4proto = $4;
 			}
-			|	L3PROTOCOL	family_spec_explicit	stmt_seperator
+			|	L3PROTOCOL	family_spec_explicit	stmt_separator
 			{
 				$<obj>0->ct_helper.l3proto = $2;
 			}
-- 
2.14.1

