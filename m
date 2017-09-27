From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] src: parser_bison: rename ct_block to ct_helper_block
Date: Wed, 27 Sep 2017 19:38:06 +0200
Message-ID: <20170927173807.29882-3-fw@strlen.de>
References: <20170927173807.29882-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37600 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750852AbdI0RiA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 13:38:00 -0400
In-Reply-To: <20170927173807.29882-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index b9eb2b9d4c01..ce6a77a89847 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -514,7 +514,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <set>			map_block_alloc map_block
 %destructor { set_free($$); }	map_block_alloc
 
-%type <obj>			obj_block_alloc counter_block quota_block ct_block limit_block
+%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block limit_block
 %destructor { obj_free($$); }	obj_block_alloc
 
 %type <list>			stmt_list
@@ -876,7 +876,7 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
-			|	CT	HELPER	obj_spec	ct_obj_alloc	'{' ct_block '}'	stmt_separator
+			|	CT	HELPER	obj_spec	ct_obj_alloc	'{' ct_helper_block '}'	stmt_separator
 			{
 
 				$$ = cmd_alloc_obj_ct(CMD_ADD, NFT_OBJECT_CT_HELPER, &$3, &@$, $4);
@@ -951,7 +951,7 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
-			|	CT	HELPER	obj_spec	ct_obj_alloc	'{' ct_block '}'	stmt_separator
+			|	CT	HELPER	obj_spec	ct_obj_alloc	'{' ct_helper_block '}'	stmt_separator
 			{
 				$$ = cmd_alloc_obj_ct(CMD_CREATE, NFT_OBJECT_CT_HELPER, &$3, &@$, $4);
 			}
@@ -1293,7 +1293,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$4->list, &$1->objs);
 				$$ = $1;
 			}
-			|	table_block	CT	HELPER	obj_identifier  obj_block_alloc '{'     ct_block     '}' stmt_separator
+			|	table_block	CT	HELPER	obj_identifier  obj_block_alloc '{'     ct_helper_block     '}' stmt_separator
 			{
 				$5->location = @4;
 				$5->type = NFT_OBJECT_CT_HELPER;
@@ -1512,10 +1512,10 @@ quota_block		:	/* empty */	{ $$ = $<obj>-1; }
 			}
 			;
 
-ct_block		:	/* empty */	{ $$ = $<obj>-1; }
-			|       ct_block     common_block
-			|       ct_block     stmt_separator
-			|       ct_block     ct_helper_config
+ct_helper_block		:	/* empty */	{ $$ = $<obj>-1; }
+			|       ct_helper_block     common_block
+			|       ct_helper_block     stmt_separator
+			|       ct_helper_block     ct_helper_config
 			{
 				$$ = $1;
 			}
-- 
2.13.5

