From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] src: prepare for future ct timeout policy support
Date: Wed, 27 Sep 2017 19:38:05 +0200
Message-ID: <20170927173807.29882-2-fw@strlen.de>
References: <20170927173807.29882-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37598 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750852AbdI0Rh4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 13:37:56 -0400
In-Reply-To: <20170927173807.29882-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Change all places that expect ct helper tokens (ct helper configuration)
to CT HELPER.  ct_obj_kind is removed.

When we add ct timeout support, we will add a new ct_timeout_block,
plus extra rules.  We won't extend ct_block, it prevents the parser
from detecting bogus syntax that only makes sense for ct helper but
not for something else for instance.

ct_block should be renamed to ct_helper_block, will be done in
followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/ct.h       |  2 --
 include/rule.h     |  2 +-
 src/ct.c           | 10 ------
 src/parser_bison.y | 98 ++++++++++--------------------------------------------
 src/rule.c         |  7 ++--
 5 files changed, 23 insertions(+), 96 deletions(-)

diff --git a/include/ct.h b/include/ct.h
index 895a6ee3b255..d9a11a3fab81 100644
--- a/include/ct.h
+++ b/include/ct.h
@@ -27,8 +27,6 @@ extern struct expr *ct_expr_alloc(const struct location *loc,
 				  enum nft_ct_keys key, int8_t direction);
 extern void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr);
 
-extern struct error_record *ct_objtype_parse(const struct location *loc, const char *str, int *type);
-
 extern struct stmt *notrack_stmt_alloc(const struct location *loc);
 
 extern const struct datatype ct_dir_type;
diff --git a/include/rule.h b/include/rule.h
index e2a5c87b7002..6f52b17fc08c 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -463,7 +463,7 @@ extern struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 extern void nft_cmd_expand(struct cmd *cmd);
 extern struct cmd *cmd_alloc_obj_ct(enum cmd_ops op, int type,
 				    const struct handle *h,
-				    const struct location *loc, void *data);
+				    const struct location *loc, struct obj *obj);
 extern void cmd_free(struct cmd *cmd);
 
 #include <payload.h>
diff --git a/src/ct.c b/src/ct.c
index 2b0e2a0924a4..0e9b17cd1a22 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -334,16 +334,6 @@ static const struct expr_ops ct_expr_ops = {
 	.pctx_update	= ct_expr_pctx_update,
 };
 
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
index c7ba1495adf3..b9eb2b9d4c01 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -405,6 +405,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token COUNTERS			"counters"
 %token QUOTAS			"quotas"
 %token LIMITS			"limits"
+%token HELPERS			"helpers"
 
 %token LOG			"log"
 %token PREFIX			"prefix"
@@ -698,9 +699,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	exthdr_exists_expr
 %type <val>			exthdr_key
 
-%type <val>			ct_l4protoname
-%type <string>			ct_obj_kind
-%destructor { xfree($$); }     	ct_obj_kind
+%type <val>			ct_l4protoname ct_obj_type
 
 %%
 
@@ -877,19 +876,10 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
-			|	CT	ct_obj_kind	obj_spec	ct_obj_alloc	'{' ct_block '}'	stmt_separator
+			|	CT	HELPER	obj_spec	ct_obj_alloc	'{' ct_block '}'	stmt_separator
 			{
-				struct error_record *erec;
-				int type;
-
-				erec = ct_objtype_parse(&@$, $2, &type);
-				xfree($2);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
 
-				$$ = cmd_alloc_obj_ct(CMD_ADD, type, &$3, &@$, $4);
+				$$ = cmd_alloc_obj_ct(CMD_ADD, NFT_OBJECT_CT_HELPER, &$3, &@$, $4);
 			}
 			|	LIMIT		obj_spec	limit_obj
 			{
@@ -961,19 +951,9 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
-			|	CT	ct_obj_kind	obj_spec	ct_obj_alloc	'{' ct_block '}'	stmt_separator
+			|	CT	HELPER	obj_spec	ct_obj_alloc	'{' ct_block '}'	stmt_separator
 			{
-				struct error_record *erec;
-				int type;
-
-				erec = ct_objtype_parse(&@$, $2, &type);
-				xfree($2);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-
-				$$ = cmd_alloc_obj_ct(CMD_CREATE, type, &$3, &@$, $4);
+				$$ = cmd_alloc_obj_ct(CMD_CREATE, NFT_OBJECT_CT_HELPER, &$3, &@$, $4);
 			}
 			|	LIMIT		obj_spec	limit_obj
 			{
@@ -1019,19 +999,9 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_QUOTA, &$2, &@$, NULL);
 			}
-			|	CT	ct_obj_kind	obj_spec	ct_obj_alloc
+			|	CT	ct_obj_type	obj_spec	ct_obj_alloc
 			{
-				struct error_record *erec;
-				int type;
-
-				erec = ct_objtype_parse(&@$, $2, &type);
-				xfree($2);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-
-				$$ = cmd_alloc_obj_ct(CMD_DELETE, type, &$3, &@$, $4);
+				$$ = cmd_alloc_obj_ct(CMD_DELETE, $2, &$3, &@$, $4);
 			}
 			|	LIMIT		obj_spec
 			{
@@ -1123,35 +1093,13 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_MAP, &$2, &@$, NULL);
 			}
-			|	CT		ct_obj_kind	obj_spec
+			|	CT		ct_obj_type	obj_spec
 			{
-				struct error_record *erec;
-				int type;
-
-				erec = ct_objtype_parse(&@$, $2, &type);
-				xfree($2);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-
-				$$ = cmd_alloc_obj_ct(CMD_LIST, type, &$3, &@$, NULL);
+				$$ = cmd_alloc_obj_ct(CMD_LIST, $2, &$3, &@$, NULL);
 			}
-			|       CT		ct_obj_kind	TABLE   table_spec
+			|       CT		HELPERS		TABLE   table_spec
 			{
-				int cmd;
-
-				if (strcmp($2, "helpers") == 0) {
-					cmd = CMD_OBJ_CT_HELPERS;
-				} else {
-					erec_queue(error(&@$, "unknown ct class '%s', want 'helpers'", $2),
-						   state->msgs);
-					xfree($2);
-					YYERROR;
-				}
-				xfree($2);
-
-				$$ = cmd_alloc(CMD_LIST, cmd, &$4, &@$, NULL);
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_CT_HELPERS, &$4, &@$, NULL);
 			}
 			;
 
@@ -1345,20 +1293,10 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$4->list, &$1->objs);
 				$$ = $1;
 			}
-			|	table_block	CT	ct_obj_kind	obj_identifier  obj_block_alloc '{'     ct_block     '}' stmt_separator
+			|	table_block	CT	HELPER	obj_identifier  obj_block_alloc '{'     ct_block     '}' stmt_separator
 			{
-				struct error_record *erec;
-				int type;
-
-				erec = ct_objtype_parse(&@$, $3, &type);
-				xfree($3);
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
@@ -1577,7 +1515,7 @@ quota_block		:	/* empty */	{ $$ = $<obj>-1; }
 ct_block		:	/* empty */	{ $$ = $<obj>-1; }
 			|       ct_block     common_block
 			|       ct_block     stmt_separator
-			|       ct_block     ct_config
+			|       ct_block     ct_helper_config
 			{
 				$$ = $1;
 			}
@@ -2886,15 +2824,14 @@ quota_obj		:	quota_config
 			}
 			;
 
-ct_obj_kind		:	STRING		{ $$ = $1; }
-			|	HELPER		{ $$ = xstrdup("helper"); }
+ct_obj_type		:	HELPER		{ $$ = NFT_OBJECT_CT_HELPER; }
 			;
 
 ct_l4protoname		:	TCP	{ $$ = IPPROTO_TCP; }
 			|	UDP	{ $$ = IPPROTO_UDP; }
 			;
 
-ct_config		:	TYPE	QUOTED_STRING	PROTOCOL	ct_l4protoname	stmt_separator
+ct_helper_config		:	TYPE	QUOTED_STRING	PROTOCOL	ct_l4protoname	stmt_separator
 			{
 				struct ct_helper *ct;
 				int ret;
@@ -2918,7 +2855,6 @@ ct_config		:	TYPE	QUOTED_STRING	PROTOCOL	ct_l4protoname	stmt_separator
 ct_obj_alloc		:
 			{
 				$$ = obj_alloc(&@$);
-				$$->type = NFT_OBJECT_CT_HELPER;
 			}
 			;
 
diff --git a/src/rule.c b/src/rule.c
index 1e0558eaf075..30d3693afa54 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1742,10 +1742,13 @@ static int do_command_describe(struct netlink_ctx *ctx, struct cmd *cmd)
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
@@ -1754,7 +1757,7 @@ struct cmd *cmd_alloc_obj_ct(enum cmd_ops op, int type, const struct handle *h,
 		BUG("missing type mapping");
 	}
 
-	return cmd_alloc(op, cmd_obj, h, loc, data);
+	return cmd_alloc(op, cmd_obj, h, loc, obj);
 }
 
 int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
-- 
2.13.5

