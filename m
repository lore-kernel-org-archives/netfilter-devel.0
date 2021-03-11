Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F35FC433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A57E664ED5
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233556AbhCKNYe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 08:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233539AbhCKNYK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 08:24:10 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BFAC061574
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 05:24:10 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lKLIO-0003i6-UB; Thu, 11 Mar 2021 14:24:08 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 12/12] scanner: secmark: move to own scope
Date:   Thu, 11 Mar 2021 14:23:13 +0100
Message-Id: <20210311132313.24403-13-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311132313.24403-1-fw@strlen.de>
References: <20210311132313.24403-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   |  1 +
 src/parser_bison.y | 19 ++++++++++---------
 src/scanner.l      |  3 ++-
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index cc9790f62dc1..9fdebcd11dd2 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -35,6 +35,7 @@ enum startcond_type {
 	PARSER_SC_IP6,
 	PARSER_SC_LIMIT,
 	PARSER_SC_QUOTA,
+	PARSER_SC_SECMARK,
 	PARSER_SC_VLAN,
 	PARSER_SC_EXPR_FIB,
 	PARSER_SC_EXPR_HASH,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 239838c2cbc2..08a2599e5374 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -875,6 +875,7 @@ close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGE
 close_scope_quota	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_QUOTA); };
 close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
 close_scope_rt		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_RT); };
+close_scope_secmark	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_SECMARK); };
 close_scope_socket	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_SOCKET); }
 
 common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
@@ -1067,11 +1068,11 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_LIMIT, &$2, &@$, $3);
 			}
-			|	SECMARK		obj_spec	secmark_obj	secmark_config
+			|	SECMARK		obj_spec	secmark_obj	secmark_config	close_scope_secmark
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SECMARK, &$2, &@$, $3);
 			}
-			|	SECMARK		obj_spec	secmark_obj	'{' secmark_block '}'
+			|	SECMARK		obj_spec	secmark_obj	'{' secmark_block '}'	close_scope_secmark
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SECMARK, &$2, &@$, $3);
 			}
@@ -1172,7 +1173,7 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_LIMIT, &$2, &@$, $3);
 			}
-			|	SECMARK		obj_spec	secmark_obj	secmark_config
+			|	SECMARK		obj_spec	secmark_obj	secmark_config	close_scope_secmark
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_SECMARK, &$2, &@$, $3);
 			}
@@ -1259,7 +1260,7 @@ delete_cmd		:	TABLE		table_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_LIMIT, &$2, &@$, NULL);
 			}
-			|	SECMARK		obj_or_id_spec
+			|	SECMARK		obj_or_id_spec	close_scope_secmark
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SECMARK, &$2, &@$, NULL);
 			}
@@ -1347,7 +1348,7 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SECMARKS, &$3, &@$, NULL);
 			}
-			|	SECMARK		obj_spec
+			|	SECMARK		obj_spec	close_scope_secmark
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SECMARK, &$2, &@$, NULL);
 			}
@@ -1680,7 +1681,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 			}
 			|	table_block	SECMARK		obj_identifier
 					obj_block_alloc	'{'	secmark_block	'}'
-					stmt_separator
+					stmt_separator	close_scope_secmark
 			{
 				$4->location = @3;
 				$4->type = NFT_OBJECT_SECMARK;
@@ -1883,7 +1884,7 @@ map_block_alloc		:	/* empty */
 map_block_obj_type	:	COUNTER	{ $$ = NFT_OBJECT_COUNTER; }
 			|	QUOTA	close_scope_quota { $$ = NFT_OBJECT_QUOTA; }
 			|	LIMIT	close_scope_limit { $$ = NFT_OBJECT_LIMIT; }
-			|	SECMARK { $$ = NFT_OBJECT_SECMARK; }
+			|	SECMARK close_scope_secmark { $$ = NFT_OBJECT_SECMARK; }
 			;
 
 map_block		:	/* empty */	{ $$ = $<set>-1; }
@@ -4727,7 +4728,7 @@ meta_key_qualified	:	LENGTH		{ $$ = NFT_META_LEN; }
 			|	PROTOCOL	{ $$ = NFT_META_PROTOCOL; }
 			|	PRIORITY	{ $$ = NFT_META_PRIORITY; }
 			|	RANDOM		{ $$ = NFT_META_PRANDOM; }
-			|	SECMARK		{ $$ = NFT_META_SECMARK; }
+			|	SECMARK	close_scope_secmark { $$ = NFT_META_SECMARK; }
 			;
 
 meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
@@ -4966,7 +4967,7 @@ ct_key			:	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
 			|	PROTO_DST	{ $$ = NFT_CT_PROTO_DST; }
 			|	LABEL		{ $$ = NFT_CT_LABELS; }
 			|	EVENT		{ $$ = NFT_CT_EVENTMASK; }
-			|	SECMARK		{ $$ = NFT_CT_SECMARK; }
+			|	SECMARK	close_scope_secmark { $$ = NFT_CT_SECMARK; }
 			|	ID	 	{ $$ = NFT_CT_ID; }
 			|	ct_key_dir_optional
 			;
diff --git a/src/scanner.l b/src/scanner.l
index d09189ae4492..a73ce1b819d8 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -203,6 +203,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_IP6
 %s SCANSTATE_LIMIT
 %s SCANSTATE_QUOTA
+%s SCANSTATE_SECMARK
 %s SCANSTATE_VLAN
 %s SCANSTATE_EXPR_FIB
 %s SCANSTATE_EXPR_HASH
@@ -634,7 +635,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"out"			{ return OUT; }
 }
 
-"secmark"		{ return SECMARK; }
+"secmark"		{ scanner_push_start_cond(yyscanner, SCANSTATE_SECMARK); return SECMARK; }
 "secmarks"		{ return SECMARKS; }
 
 {addrstring}		{
-- 
2.26.2

