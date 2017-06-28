From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 02/17] src: prepare for future ct timeout policy support
Date: Wed, 28 Jun 2017 12:06:44 +0200
Message-ID: <20170628100659.26976-3-fw@strlen.de>
References: <20170628100659.26976-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33346 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751469AbdF1KGs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 06:06:48 -0400
In-Reply-To: <20170628100659.26976-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Change all places that expect ct helper tokens (ct helper configuration)
to CT 	HELPER.  Also rename ct_block to ct_helper_block; we want to
add a ct_timeout_pol_block (or similar), notg extend ct_block.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/rule.h     |   2 +-
 src/ct.c           |  10 -----
 src/parser_bison.y | 109 +++++++++++++++--------------------------------------
 src/rule.c         |   7 +++-
 src/scanner.l      |   1 +
 5 files changed, 38 insertions(+), 91 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 24c73d85f83b..b96d1bba0311 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -448,7 +448,7 @@ extern struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 extern void nft_cmd_expand(struct cmd *cmd);
 extern struct cmd *cmd_alloc_obj_ct(enum cmd_ops op, int type,
 				    const struct handle *h,
-				    const struct location *loc, void *data);
+				    const struct location *loc, struct obj *obj);
 extern void cmd_free(struct cmd *cmd);
 
 #include <payload.h>
diff --git a/src/ct.c b/src/ct.c
index c705750db4f7..87fe08bc62f8 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -384,16 +384,6 @@ struct error_record *ct_key_parse(const struct location *loc, const char *str,
 	return error(loc, "syntax error, unexpected %s, known keys are %s", str, buf);
 }
 
-struct error_record *ct_objtype_parse(const struct location *loc, const char *str, int *type)
-{
-	if (strcmp(str, "helper") == 0) {
-		*type = NFT_OBJECT_CT_HELPER;
-		return NULL;
-	}
-
-	return error(loc, "unknown ct class '%s', want 'helper'", str);
-}
-
 struct expr *ct_expr_alloc(const struct location *loc, enum nft_ct_keys key,
 			   int8_t direction)
 {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9a9ff6f5ce44..79918399368e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -374,6 +374,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token NEXTHOP			"nexthop"
 
 %token CT			"ct"
+%token HELPER			"helper"
 %token L3PROTOCOL		"l3proto"
 %token PROTO_SRC		"proto-src"
 %token PROTO_DST		"proto-dst"
@@ -495,7 +496,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <set>			map_block_alloc map_block
 %destructor { set_free($$); }	map_block_alloc
 
-%type <obj>			obj_block_alloc counter_block quota_block ct_block
+%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block
 %destructor { obj_free($$); }	obj_block_alloc
 
 %type <list>			stmt_list
@@ -669,9 +670,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	exthdr_exists_expr
 %type <val>			exthdr_key
 
-%type <val>			ct_l4protoname
-%type <string>			ct_obj_kind
-%destructor { xfree($$); }     	ct_obj_kind
+%type <val>			ct_l4protoname ct_obj_type
 
 %%
 
@@ -843,18 +842,9 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
-			|	CT	STRING	obj_spec	ct_obj_alloc	'{' ct_block '}'	stmt_seperator
+			|	CT	HELPER	obj_spec	ct_obj_alloc	'{' ct_helper_block '}'	stmt_seperator
 			{
-				struct error_record *erec;
-				int type;
-
-				erec = ct_objtype_parse(&@$, $2, &type);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-
-				$$ = cmd_alloc_obj_ct(CMD_ADD, type, &$3, &@$, $4);
+				$$ = cmd_alloc_obj_ct(CMD_ADD, NFT_OBJECT_CT_HELPER, &$3, &@$, $4);
 			}
 			;
 
@@ -922,18 +912,9 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
-			|	CT	STRING	obj_spec	ct_obj_alloc	'{' ct_block '}'	stmt_seperator
+			|	CT	HELPER	obj_spec	ct_obj_alloc	'{' ct_helper_block '}'	stmt_seperator
 			{
-				struct error_record *erec;
-				int type;
-
-				erec = ct_objtype_parse(&@$, $2, &type);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-
-				$$ = cmd_alloc_obj_ct(CMD_CREATE, type, &$3, &@$, $4);
+				$$ = cmd_alloc_obj_ct(CMD_CREATE, NFT_OBJECT_CT_HELPER, &$3, &@$, $4);
 			}
 			;
 
@@ -975,18 +956,9 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_QUOTA, &$2, &@$, NULL);
 			}
-			|	CT	STRING	obj_spec	ct_obj_alloc
+			|	CT	ct_obj_type	obj_spec	ct_obj_alloc
 			{
-				struct error_record *erec;
-				int type;
-
-				erec = ct_objtype_parse(&@$, $2, &type);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-
-				$$ = cmd_alloc_obj_ct(CMD_DELETE, type, &$3, &@$, $4);
+				$$ = cmd_alloc_obj_ct(CMD_DELETE, $2, &$3, &@$, $4);
 			}
 			;
 
@@ -1062,18 +1034,9 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_MAP, &$2, &@$, NULL);
 			}
-			|	CT		STRING	obj_spec
+			|	CT		ct_obj_type	obj_spec
 			{
-				struct error_record *erec;
-				int type;
-
-				erec = ct_objtype_parse(&@$, $2, &type);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-
-				$$ = cmd_alloc_obj_ct(CMD_LIST, type, &$3, &@$, NULL);
+				$$ = cmd_alloc_obj_ct(CMD_LIST, $2, &$3, &@$, NULL);
 			}
 			|       CT              STRING  TABLE   table_spec
 			{
@@ -1282,19 +1245,10 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$4->list, &$1->objs);
 				$$ = $1;
 			}
-			|	table_block	CT	ct_obj_kind	obj_identifier  obj_block_alloc '{'     ct_block     '}' stmt_seperator
+			|	table_block	CT	HELPER	obj_identifier  obj_block_alloc '{'     ct_helper_block     '}' stmt_seperator
 			{
-				struct error_record *erec;
-				int type;
-
-				erec = ct_objtype_parse(&@$, $3, &type);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-
 				$5->location = @4;
-				$5->type = type;
+				$5->type = NFT_OBJECT_CT_HELPER;
 				handle_merge(&$5->handle, &$4);
 				handle_free(&$4);
 				list_add_tail(&$5->list, &$1->objs);
@@ -1494,10 +1448,10 @@ quota_block		:	/* empty */	{ $$ = $<obj>-1; }
 			}
 			;
 
-ct_block		:	/* empty */	{ $$ = $<obj>-1; }
-			|       ct_block     common_block
-			|       ct_block     stmt_seperator
-			|       ct_block     ct_config
+ct_helper_block		:	/* empty */	{ $$ = $<obj>-1; }
+			|       ct_helper_block     common_block
+			|       ct_helper_block     stmt_seperator
+			|       ct_helper_block     ct_helper_config
 			{
 				$$ = $1;
 			}
@@ -2697,14 +2651,14 @@ quota_obj		:	quota_config
 			}
 			;
 
-ct_obj_kind		:	STRING		{ $$ = $1; }
+ct_obj_type		:	HELPER		{ $$ = NFT_OBJECT_CT_HELPER; }
 			;
 
 ct_l4protoname		:	TCP	{ $$ = IPPROTO_TCP; }
 			|	UDP	{ $$ = IPPROTO_UDP; }
 			;
 
-ct_config		:	TYPE	QUOTED_STRING	PROTOCOL	ct_l4protoname	stmt_seperator
+ct_helper_config		:	TYPE	QUOTED_STRING	PROTOCOL	ct_l4protoname	stmt_seperator
 			{
 				struct ct_helper *ct;
 				int ret;
@@ -2728,7 +2682,6 @@ ct_config		:	TYPE	QUOTED_STRING	PROTOCOL	ct_l4protoname	stmt_seperator
 ct_obj_alloc		:
 			{
 				$$ = obj_alloc(&@$);
-				$$->type = NFT_OBJECT_CT_HELPER;
 			}
 			;
 
@@ -3160,6 +3113,7 @@ ct_expr			: 	CT	ct_key
 ct_key			:	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
 			|	PROTOCOL	{ $$ = NFT_CT_PROTOCOL; }
 			|	MARK		{ $$ = NFT_CT_MARK; }
+			|	HELPER		{ $$ = NFT_CT_HELPER; }
 			|	ct_key_dir_optional
 			;
 ct_key_dir		:	SADDR		{ $$ = NFT_CT_SRC; }
@@ -3197,7 +3151,16 @@ ct_stmt_expr		:	expr
 
 ct_stmt			:	CT	ct_key		SET	expr
 			{
-				$$ = ct_stmt_alloc(&@$, $2, -1, $4);
+				switch ($2) {
+				case NFT_CT_HELPER:
+					$$ = objref_stmt_alloc(&@$);
+					$$->objref.type = NFT_OBJECT_CT_HELPER;
+					$$->objref.expr = $4;
+					break;
+				default:
+					$$ = ct_stmt_alloc(&@$, $2, -1, $4);
+					break;
+				}
 			}
 			|	CT	STRING		SET	ct_stmt_expr
 			{
@@ -3209,17 +3172,7 @@ ct_stmt			:	CT	ct_key		SET	expr
 					erec_queue(erec, state->msgs);
 					YYERROR;
 				}
-
-				switch (key) {
-				case NFT_CT_HELPER:
-					$$ = objref_stmt_alloc(&@$);
-					$$->objref.type = NFT_OBJECT_CT_HELPER;
-					$$->objref.expr = $4;
-					break;
-				default:
-					$$ = ct_stmt_alloc(&@$, key, -1, $4);
-					break;
-				}
+				$$ = ct_stmt_alloc(&@$, key, -1, $4);
 			}
 			|	CT	STRING	ct_key_dir_optional SET	expr
 			{
diff --git a/src/rule.c b/src/rule.c
index ee510fe0123b..ed6654b1f821 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1664,10 +1664,13 @@ static int do_command_describe(struct netlink_ctx *ctx, struct cmd *cmd)
 }
 
 struct cmd *cmd_alloc_obj_ct(enum cmd_ops op, int type, const struct handle *h,
-			     const struct location *loc, void *data)
+			     const struct location *loc, struct obj *obj)
 {
 	enum cmd_obj cmd_obj;
 
+	if (obj)
+		obj->type = type;
+
 	switch (type) {
 	case NFT_OBJECT_CT_HELPER:
 		cmd_obj = CMD_OBJ_CT_HELPER;
@@ -1676,7 +1679,7 @@ struct cmd *cmd_alloc_obj_ct(enum cmd_ops op, int type, const struct handle *h,
 		BUG("missing type mapping");
 	}
 
-	return cmd_alloc(op, cmd_obj, h, loc, data);
+	return cmd_alloc(op, cmd_obj, h, loc, obj);
 }
 
 int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
diff --git a/src/scanner.l b/src/scanner.l
index 86a03f3b3bdb..c0c48a0dea29 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -478,6 +478,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "nexthop"		{ return NEXTHOP; }
 
 "ct"			{ return CT; }
+"helper"		{ return HELPER; }
 "l3proto"		{ return L3PROTOCOL; }
 "proto-src"		{ return PROTO_SRC; }
 "proto-dst"		{ return PROTO_DST; }
-- 
2.13.0

