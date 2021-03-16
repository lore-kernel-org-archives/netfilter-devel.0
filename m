Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B1DC433E6
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Mar 2021 23:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2DCD64F90
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Mar 2021 23:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCPXlQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Mar 2021 19:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbhCPXk4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Mar 2021 19:40:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA129C06174A
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Mar 2021 16:40:55 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lMJIz-00057z-7F; Wed, 17 Mar 2021 00:40:53 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/6] scanner: counter: move to own scope
Date:   Wed, 17 Mar 2021 00:40:35 +0100
Message-Id: <20210316234039.15677-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210316234039.15677-1-fw@strlen.de>
References: <20210316234039.15677-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

move bytes/packets away from initial state.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   |  1 +
 src/parser_bison.y | 31 ++++++++++++++++---------------
 src/scanner.l      |  7 ++++---
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 0c229963d3be..59eff16eac20 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -32,6 +32,7 @@ enum startcond_type {
 	PARSER_SC_BEGIN,
 	PARSER_SC_ARP,
 	PARSER_SC_CT,
+	PARSER_SC_COUNTER,
 	PARSER_SC_ETH,
 	PARSER_SC_IP,
 	PARSER_SC_IP6,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 08a2599e5374..805a38ab22ed 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -863,6 +863,7 @@ opt_newline		:	NEWLINE
 
 close_scope_arp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ARP); };
 close_scope_ct		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CT); };
+close_scope_counter	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_COUNTER); };
 close_scope_eth		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ETH); };
 close_scope_fib		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_FIB); };
 close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH); };
@@ -1023,7 +1024,7 @@ add_cmd			:	TABLE		table_spec
 				handle_merge(&$3->handle, &$2);
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_FLOWTABLE, &$2, &@$, $5);
 			}
-			|	COUNTER		obj_spec
+			|	COUNTER		obj_spec	close_scope_counter
 			{
 				struct obj *obj;
 
@@ -1032,11 +1033,11 @@ add_cmd			:	TABLE		table_spec
 				handle_merge(&obj->handle, &$2);
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_COUNTER, &$2, &@$, obj);
 			}
-			|	COUNTER		obj_spec	counter_obj	counter_config
+			|	COUNTER		obj_spec	counter_obj	counter_config	close_scope_counter
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_COUNTER, &$2, &@$, $3);
 			}
-			|	COUNTER		obj_spec	counter_obj	'{' counter_block '}'
+			|	COUNTER		obj_spec	counter_obj	'{' counter_block '}'	close_scope_counter
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_COUNTER, &$2, &@$, $3);
 			}
@@ -1140,7 +1141,7 @@ create_cmd		:	TABLE		table_spec
 				handle_merge(&$3->handle, &$2);
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_FLOWTABLE, &$2, &@$, $5);
 			}
-			|	COUNTER		obj_spec
+			|	COUNTER		obj_spec	close_scope_counter
 			{
 				struct obj *obj;
 
@@ -1149,7 +1150,7 @@ create_cmd		:	TABLE		table_spec
 				handle_merge(&obj->handle, &$2);
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_COUNTER, &$2, &@$, obj);
 			}
-			|	COUNTER		obj_spec	counter_obj	counter_config
+			|	COUNTER		obj_spec	counter_obj	counter_config	close_scope_counter
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_COUNTER, &$2, &@$, $3);
 			}
@@ -1244,7 +1245,7 @@ delete_cmd		:	TABLE		table_or_id_spec
 				handle_merge(&$3->handle, &$2);
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_FLOWTABLE, &$2, &@$, $5);
 			}
-			|	COUNTER		obj_or_id_spec
+			|	COUNTER		obj_or_id_spec	close_scope_counter
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_COUNTER, &$2, &@$, NULL);
 			}
@@ -1312,7 +1313,7 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_COUNTERS, &$3, &@$, NULL);
 			}
-			|	COUNTER		obj_spec
+			|	COUNTER		obj_spec	close_scope_counter
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_COUNTER, &$2, &@$, NULL);
 			}
@@ -1418,7 +1419,7 @@ reset_cmd		:	COUNTERS	ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_COUNTERS, &$3, &@$, NULL);
 			}
-			|       COUNTER         obj_spec
+			|       COUNTER         obj_spec	close_scope_counter
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_COUNTER, &$2,&@$, NULL);
 			}
@@ -1621,7 +1622,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 			}
 			|	table_block	COUNTER		obj_identifier
 					obj_block_alloc	'{'	counter_block	'}'
-					stmt_separator
+					stmt_separator	close_scope_counter
 			{
 				$4->location = @3;
 				$4->type = NFT_OBJECT_COUNTER;
@@ -1881,7 +1882,7 @@ map_block_alloc		:	/* empty */
 			}
 			;
 
-map_block_obj_type	:	COUNTER	{ $$ = NFT_OBJECT_COUNTER; }
+map_block_obj_type	:	COUNTER	close_scope_counter { $$ = NFT_OBJECT_COUNTER; }
 			|	QUOTA	close_scope_quota { $$ = NFT_OBJECT_QUOTA; }
 			|	LIMIT	close_scope_limit { $$ = NFT_OBJECT_LIMIT; }
 			|	SECMARK close_scope_secmark { $$ = NFT_OBJECT_SECMARK; }
@@ -2011,7 +2012,7 @@ flowtable_block		:	/* empty */	{ $$ = $<flowtable>-1; }
 			{
 				$$->dev_expr = $4;
 			}
-			|	flowtable_block COUNTER
+			|	flowtable_block COUNTER	close_scope_counter
 			{
 				$$->flags |= NFT_FLOWTABLE_COUNTER;
 			}
@@ -2782,11 +2783,11 @@ connlimit_stmt		:	CT	COUNT	NUM	close_scope_ct
 counter_stmt		:	counter_stmt_alloc
 			|	counter_stmt_alloc	counter_args
 
-counter_stmt_alloc	:	COUNTER
+counter_stmt_alloc	:	COUNTER	close_scope_counter
 			{
 				$$ = counter_stmt_alloc(&@$);
 			}
-			|	COUNTER		NAME	stmt_expr
+			|	COUNTER		NAME	stmt_expr	close_scope_counter
 			{
 				$$ = objref_stmt_alloc(&@$);
 				$$->objref.type = NFT_OBJECT_COUNTER;
@@ -4133,11 +4134,11 @@ set_elem_stmt_list	:	set_elem_stmt
 			}
 			;
 
-set_elem_stmt		:	COUNTER
+set_elem_stmt		:	COUNTER	close_scope_counter
 			{
 				$$ = counter_stmt_alloc(&@$);
 			}
-			|	COUNTER	PACKETS	NUM	BYTES	NUM
+			|	COUNTER	PACKETS	NUM	BYTES	NUM	close_scope_counter
 			{
 				$$ = counter_stmt_alloc(&@$);
 				$$->counter.packets = $3;
diff --git a/src/scanner.l b/src/scanner.l
index 01e1dca52fdd..783436504326 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -198,6 +198,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %option stack
 %s SCANSTATE_ARP
 %s SCANSTATE_CT
+%s SCANSTATE_COUNTER
 %s SCANSTATE_ETH
 %s SCANSTATE_IP
 %s SCANSTATE_IP6
@@ -343,10 +344,10 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "flowtables"		{ return FLOWTABLES; }
 
-"counter"		{ return COUNTER; }
+"counter"		{ scanner_push_start_cond(yyscanner, SCANSTATE_COUNTER); return COUNTER; }
 "name"			{ return NAME; }
-"packets"		{ return PACKETS; }
-"bytes"			{ return BYTES; }
+<SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT>"packets"		{ return PACKETS; }
+<SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT,SCANSTATE_QUOTA>"bytes"	{ return BYTES; }
 
 "counters"		{ return COUNTERS; }
 "quotas"		{ return QUOTAS; }
-- 
2.26.2

