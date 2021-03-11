Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC43C4332E
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:24:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7DB764FF6
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbhCKNXa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 08:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233525AbhCKNXY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 08:23:24 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3F9C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 05:23:23 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lKLHe-0003gS-Hm; Thu, 11 Mar 2021 14:23:22 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 01/12] scanner: ct: move to own scope
Date:   Thu, 11 Mar 2021 14:23:02 +0100
Message-Id: <20210311132313.24403-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311132313.24403-1-fw@strlen.de>
References: <20210311132313.24403-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows moving multiple ct specific keywords out of INITIAL scope.
Next few patches follow same pattern:
 1. add a scope_close_XXX rule
 2. add a SCANSTATE_XXX & make flex switch to it when
    encountering XXX keyword
 3. make bison leave SCANSTATE_XXXX when it has seen the complete
    expression.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   |  1 +
 src/parser_bison.y | 43 ++++++++++++++++++++++---------------------
 src/scanner.l      | 37 ++++++++++++++++++++-----------------
 3 files changed, 43 insertions(+), 38 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index fd5006d35c0d..be29f400c023 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -28,6 +28,7 @@ struct parser_state {
 
 enum startcond_type {
 	PARSER_SC_BEGIN,
+	PARSER_SC_CT,
 	PARSER_SC_EXPR_HASH,
 	PARSER_SC_EXPR_IPSEC,
 	PARSER_SC_EXPR_NUMGEN,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 2a8ac215a284..2d2563c823ea 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -861,6 +861,7 @@ opt_newline		:	NEWLINE
 		 	|	/* empty */
 			;
 
+close_scope_ct		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CT); };
 close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH); };
 close_scope_ipsec	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_IPSEC); };
 close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
@@ -1038,15 +1039,15 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
-			|	CT	HELPER	obj_spec	ct_obj_alloc	'{' ct_helper_block '}'
+			|	CT	HELPER	obj_spec	ct_obj_alloc	'{' ct_helper_block '}'	close_scope_ct
 			{
 				$$ = cmd_alloc_obj_ct(CMD_ADD, NFT_OBJECT_CT_HELPER, &$3, &@$, $4);
 			}
-			|	CT	TIMEOUT obj_spec	ct_obj_alloc	'{' ct_timeout_block '}'
+			|	CT	TIMEOUT obj_spec	ct_obj_alloc	'{' ct_timeout_block '}'	close_scope_ct
 			{
 				$$ = cmd_alloc_obj_ct(CMD_ADD, NFT_OBJECT_CT_TIMEOUT, &$3, &@$, $4);
 			}
-			|	CT	EXPECTATION	obj_spec	ct_obj_alloc	'{' ct_expect_block '}'
+			|	CT	EXPECTATION	obj_spec	ct_obj_alloc	'{' ct_expect_block '}'	close_scope_ct
 			{
 				$$ = cmd_alloc_obj_ct(CMD_ADD, NFT_OBJECT_CT_EXPECT, &$3, &@$, $4);
 			}
@@ -1147,15 +1148,15 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
-			|	CT	HELPER	obj_spec	ct_obj_alloc	'{' ct_helper_block '}'
+			|	CT	HELPER	obj_spec	ct_obj_alloc	'{' ct_helper_block '}'	close_scope_ct
 			{
 				$$ = cmd_alloc_obj_ct(CMD_CREATE, NFT_OBJECT_CT_HELPER, &$3, &@$, $4);
 			}
-			|	CT	TIMEOUT obj_spec	ct_obj_alloc	'{' ct_timeout_block '}'
+			|	CT	TIMEOUT obj_spec	ct_obj_alloc	'{' ct_timeout_block '}'	close_scope_ct
 			{
 				$$ = cmd_alloc_obj_ct(CMD_CREATE, NFT_OBJECT_CT_TIMEOUT, &$3, &@$, $4);
 			}
-			|	CT	EXPECTATION obj_spec	ct_obj_alloc	'{' ct_expect_block '}'
+			|	CT	EXPECTATION obj_spec	ct_obj_alloc	'{' ct_expect_block '}'	close_scope_ct
 			{
 				$$ = cmd_alloc_obj_ct(CMD_CREATE, NFT_OBJECT_CT_EXPECT, &$3, &@$, $4);
 			}
@@ -1242,7 +1243,7 @@ delete_cmd		:	TABLE		table_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_QUOTA, &$2, &@$, NULL);
 			}
-			|	CT	ct_obj_type	obj_spec	ct_obj_alloc
+			|	CT	ct_obj_type	obj_spec	ct_obj_alloc	close_scope_ct
 			{
 				$$ = cmd_alloc_obj_ct(CMD_DELETE, $2, &$3, &@$, $4);
 			}
@@ -1390,11 +1391,11 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_MAP, &$2, &@$, NULL);
 			}
-			|	CT		ct_obj_type	obj_spec
+			|	CT		ct_obj_type	obj_spec	close_scope_ct
 			{
 				$$ = cmd_alloc_obj_ct(CMD_LIST, $2, &$3, &@$, NULL);
 			}
-			|       CT		ct_cmd_type 	TABLE   table_spec
+			|       CT		ct_cmd_type	TABLE   table_spec	close_scope_ct
 			{
 				$$ = cmd_alloc(CMD_LIST, $2, &$4, &@$, NULL);
 			}
@@ -1631,7 +1632,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$4->list, &$1->objs);
 				$$ = $1;
 			}
-			|	table_block	CT	HELPER	obj_identifier  obj_block_alloc '{'     ct_helper_block     '}' stmt_separator
+			|	table_block	CT	HELPER	obj_identifier  obj_block_alloc '{'     ct_helper_block     '}' close_scope_ct stmt_separator
 			{
 				$5->location = @4;
 				$5->type = NFT_OBJECT_CT_HELPER;
@@ -1640,7 +1641,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$5->list, &$1->objs);
 				$$ = $1;
 			}
-			|	table_block	CT	TIMEOUT obj_identifier obj_block_alloc '{'	ct_timeout_block	'}' stmt_separator
+			|	table_block	CT	TIMEOUT obj_identifier obj_block_alloc '{'	ct_timeout_block	'}' close_scope_ct stmt_separator
 			{
 				$5->location = @4;
 				$5->type = NFT_OBJECT_CT_TIMEOUT;
@@ -1649,7 +1650,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$5->list, &$1->objs);
 				$$ = $1;
 			}
-			|	table_block	CT	EXPECTATION obj_identifier obj_block_alloc '{'	ct_expect_block	'}' stmt_separator
+			|	table_block	CT	EXPECTATION obj_identifier obj_block_alloc '{'	ct_expect_block	'}' close_scope_ct stmt_separator
 			{
 				$5->location = @4;
 				$5->type = NFT_OBJECT_CT_EXPECT;
@@ -2756,12 +2757,12 @@ verdict_map_list_member_expr:	opt_newline	set_elem_expr	COLON	verdict_expr	opt_n
 			}
 			;
 
-connlimit_stmt		:	CT	COUNT	NUM
+connlimit_stmt		:	CT	COUNT	NUM	close_scope_ct
 			{
 				$$ = connlimit_stmt_alloc(&@$);
 				$$->connlimit.count	= $3;
 			}
-			|	CT	COUNT	OVER	NUM
+			|	CT	COUNT	OVER	NUM	close_scope_ct
 			{
 				$$ = connlimit_stmt_alloc(&@$);
 				$$->connlimit.count = $4;
@@ -4925,15 +4926,15 @@ rt_key			:	CLASSID		{ $$ = NFT_RT_CLASSID; }
 			|	IPSEC	close_scope_ipsec { $$ = NFT_RT_XFRM; }
 			;
 
-ct_expr			: 	CT	ct_key
+ct_expr			: 	CT	ct_key	close_scope_ct
 			{
 				$$ = ct_expr_alloc(&@$, $2, -1);
 			}
-			|	CT	ct_dir	ct_key_dir
+			|	CT	ct_dir	ct_key_dir	close_scope_ct
 			{
 				$$ = ct_expr_alloc(&@$, $3, $2);
 			}
-			|	CT	ct_dir	ct_key_proto_field
+			|	CT	ct_dir	ct_key_proto_field	close_scope_ct
 			{
 				$$ = ct_expr_alloc(&@$, $3, $2);
 			}
@@ -5001,7 +5002,7 @@ list_stmt_expr		:	symbol_stmt_expr	COMMA	symbol_stmt_expr
 			}
 			;
 
-ct_stmt			:	CT	ct_key		SET	stmt_expr
+ct_stmt			:	CT	ct_key		SET	stmt_expr	close_scope_ct
 			{
 				switch ($2) {
 				case NFT_CT_HELPER:
@@ -5014,20 +5015,20 @@ ct_stmt			:	CT	ct_key		SET	stmt_expr
 					break;
 				}
 			}
-			|	CT	TIMEOUT		SET	stmt_expr
+			|	CT	TIMEOUT		SET	stmt_expr	close_scope_ct
 			{
 				$$ = objref_stmt_alloc(&@$);
 				$$->objref.type = NFT_OBJECT_CT_TIMEOUT;
 				$$->objref.expr = $4;
 
 			}
-			|	CT	EXPECTATION	SET	stmt_expr
+			|	CT	EXPECTATION	SET	stmt_expr	close_scope_ct
 			{
 				$$ = objref_stmt_alloc(&@$);
 				$$->objref.type = NFT_OBJECT_CT_EXPECT;
 				$$->objref.expr = $4;
 			}
-			|	CT	ct_dir	ct_key_dir_optional SET	stmt_expr
+			|	CT	ct_dir	ct_key_dir_optional SET	stmt_expr	close_scope_ct
 			{
 				$$ = ct_stmt_alloc(&@$, $3, $2, $5);
 			}
diff --git a/src/scanner.l b/src/scanner.l
index 6a909e928bf4..1358f9d01d6a 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -196,6 +196,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %option nodefault
 %option warn
 %option stack
+%s SCANSTATE_CT
 %s SCANSTATE_EXPR_HASH
 %s SCANSTATE_EXPR_IPSEC
 %s SCANSTATE_EXPR_NUMGEN
@@ -337,7 +338,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "name"			{ return NAME; }
 "packets"		{ return PACKETS; }
 "bytes"			{ return BYTES; }
-"avgpkt"		{ return AVGPKT; }
 
 "counters"		{ return COUNTERS; }
 "quotas"		{ return QUOTAS; }
@@ -544,22 +544,25 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"nexthop"		{ return NEXTHOP; }
 }
 
-"ct"			{ return CT; }
-"l3proto"		{ return L3PROTOCOL; }
-"proto-src"		{ return PROTO_SRC; }
-"proto-dst"		{ return PROTO_DST; }
-"zone"			{ return ZONE; }
-"original"		{ return ORIGINAL; }
-"reply"			{ return REPLY; }
-"direction"		{ return DIRECTION; }
-"event"			{ return EVENT; }
-"expectation"		{ return EXPECTATION; }
-"expiration"		{ return EXPIRATION; }
-"helper"		{ return HELPER; }
-"helpers"		{ return HELPERS; }
-"label"			{ return LABEL; }
-"state"			{ return STATE; }
-"status"		{ return STATUS; }
+"ct"			{ scanner_push_start_cond(yyscanner, SCANSTATE_CT); return CT; }
+<SCANSTATE_CT>{
+	"avgpkt"		{ return AVGPKT; }
+	"l3proto"		{ return L3PROTOCOL; }
+	"proto-src"		{ return PROTO_SRC; }
+	"proto-dst"		{ return PROTO_DST; }
+	"zone"			{ return ZONE; }
+	"original"		{ return ORIGINAL; }
+	"reply"			{ return REPLY; }
+	"direction"		{ return DIRECTION; }
+	"event"			{ return EVENT; }
+	"expectation"		{ return EXPECTATION; }
+	"expiration"		{ return EXPIRATION; }
+	"helper"		{ return HELPER; }
+	"helpers"		{ return HELPERS; }
+	"label"			{ return LABEL; }
+	"state"			{ return STATE; }
+	"status"		{ return STATUS; }
+}
 
 "numgen"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_NUMGEN); return NUMGEN; }
 <SCANSTATE_EXPR_NUMGEN>{
-- 
2.26.2

