Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF96C433DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FCA964E68
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbhCKNYd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 08:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbhCKNYC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 08:24:02 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9712C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 05:24:01 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lKLIG-0003hc-IB; Thu, 11 Mar 2021 14:24:00 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 10/12] scanner: quota: move to own scope
Date:   Thu, 11 Mar 2021 14:23:11 +0100
Message-Id: <20210311132313.24403-11-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311132313.24403-1-fw@strlen.de>
References: <20210311132313.24403-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

... and move "used" keyword to it.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   |  1 +
 src/parser_bison.y | 21 +++++++++++----------
 src/scanner.l      |  5 +++--
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index a5ea208ecfc8..cc9790f62dc1 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -34,6 +34,7 @@ enum startcond_type {
 	PARSER_SC_IP,
 	PARSER_SC_IP6,
 	PARSER_SC_LIMIT,
+	PARSER_SC_QUOTA,
 	PARSER_SC_VLAN,
 	PARSER_SC_EXPR_FIB,
 	PARSER_SC_EXPR_HASH,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 67afc32a547f..239838c2cbc2 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -872,6 +872,7 @@ close_scope_vlan	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_VLAN); };
 close_scope_ipsec	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_IPSEC); };
 close_scope_limit	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_LIMIT); };
 close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
+close_scope_quota	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_QUOTA); };
 close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
 close_scope_rt		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_RT); };
 close_scope_socket	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_SOCKET); }
@@ -1038,11 +1039,11 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_COUNTER, &$2, &@$, $3);
 			}
-			|	QUOTA		obj_spec	quota_obj	quota_config
+			|	QUOTA		obj_spec	quota_obj	quota_config	close_scope_quota
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
-			|	QUOTA		obj_spec	quota_obj	'{' quota_block	'}'
+			|	QUOTA		obj_spec	quota_obj	'{' quota_block	'}'	close_scope_quota
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
@@ -1151,7 +1152,7 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_COUNTER, &$2, &@$, $3);
 			}
-			|	QUOTA		obj_spec	quota_obj	quota_config
+			|	QUOTA		obj_spec	quota_obj	quota_config	close_scope_quota
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
@@ -1246,7 +1247,7 @@ delete_cmd		:	TABLE		table_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_COUNTER, &$2, &@$, NULL);
 			}
-			|	QUOTA		obj_or_id_spec
+			|	QUOTA		obj_or_id_spec	close_scope_quota
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_QUOTA, &$2, &@$, NULL);
 			}
@@ -1322,7 +1323,7 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_QUOTAS, &$3, &@$, NULL);
 			}
-			|	QUOTA		obj_spec
+			|	QUOTA		obj_spec	close_scope_quota
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_QUOTA, &$2, &@$, NULL);
 			}
@@ -1428,7 +1429,7 @@ reset_cmd		:	COUNTERS	ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTAS, &$3, &@$, NULL);
 			}
-			|       QUOTA           obj_spec
+			|       QUOTA           obj_spec	close_scope_quota
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTA, &$2, &@$, NULL);
 			}
@@ -1630,7 +1631,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 			}
 			|	table_block	QUOTA		obj_identifier
 					obj_block_alloc	'{'	quota_block	'}'
-					stmt_separator
+					stmt_separator	close_scope_quota
 			{
 				$4->location = @3;
 				$4->type = NFT_OBJECT_QUOTA;
@@ -1880,7 +1881,7 @@ map_block_alloc		:	/* empty */
 			;
 
 map_block_obj_type	:	COUNTER	{ $$ = NFT_OBJECT_COUNTER; }
-			|	QUOTA { $$ = NFT_OBJECT_QUOTA; }
+			|	QUOTA	close_scope_quota { $$ = NFT_OBJECT_QUOTA; }
 			|	LIMIT	close_scope_limit { $$ = NFT_OBJECT_LIMIT; }
 			|	SECMARK { $$ = NFT_OBJECT_SECMARK; }
 			;
@@ -3118,7 +3119,7 @@ quota_used		:	/* empty */	{ $$ = 0; }
 			}
 			;
 
-quota_stmt		:	QUOTA	quota_mode NUM quota_unit quota_used
+quota_stmt		:	QUOTA	quota_mode NUM quota_unit quota_used	close_scope_quota
 			{
 				struct error_record *erec;
 				uint64_t rate;
@@ -3134,7 +3135,7 @@ quota_stmt		:	QUOTA	quota_mode NUM quota_unit quota_used
 				$$->quota.used = $5;
 				$$->quota.flags	= $2;
 			}
-			|	QUOTA	NAME	stmt_expr
+			|	QUOTA	NAME	stmt_expr	close_scope_quota
 			{
 				$$ = objref_stmt_alloc(&@$);
 				$$->objref.type = NFT_OBJECT_QUOTA;
diff --git a/src/scanner.l b/src/scanner.l
index 2c5aae846d4f..e373ff848ba9 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -202,6 +202,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_IP
 %s SCANSTATE_IP6
 %s SCANSTATE_LIMIT
+%s SCANSTATE_QUOTA
 %s SCANSTATE_VLAN
 %s SCANSTATE_EXPR_FIB
 %s SCANSTATE_EXPR_HASH
@@ -372,8 +373,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "until"			{ return UNTIL; }
 "over"			{ return OVER; }
 
-"quota"			{ return QUOTA; }
-"used"			{ return USED; }
+"quota"			{ scanner_push_start_cond(yyscanner, SCANSTATE_QUOTA); return QUOTA; }
+<SCANSTATE_QUOTA>"used"	{ return USED; }
 
 "second"		{ return SECOND; }
 "minute"		{ return MINUTE; }
-- 
2.26.2

