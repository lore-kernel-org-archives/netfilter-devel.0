Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82EDC4332E
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B00F64ECD
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbhCKNYF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 08:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbhCKNX6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 08:23:58 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED4AC061574
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 05:23:57 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lKLIC-0003hT-Cg; Thu, 11 Mar 2021 14:23:56 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 09/12] scanner: limit: move to own scope
Date:   Thu, 11 Mar 2021 14:23:10 +0100
Message-Id: <20210311132313.24403-10-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311132313.24403-1-fw@strlen.de>
References: <20210311132313.24403-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Moves rate and burst out of INITIAL.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   |  1 +
 src/parser_bison.y | 25 +++++++++++++------------
 src/scanner.l      |  9 ++++++---
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 889f9418a864..a5ea208ecfc8 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -33,6 +33,7 @@ enum startcond_type {
 	PARSER_SC_ETH,
 	PARSER_SC_IP,
 	PARSER_SC_IP6,
+	PARSER_SC_LIMIT,
 	PARSER_SC_VLAN,
 	PARSER_SC_EXPR_FIB,
 	PARSER_SC_EXPR_HASH,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index a6ce506bf5b5..67afc32a547f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -870,6 +870,7 @@ close_scope_ip		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP); };
 close_scope_ip6		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP6); };
 close_scope_vlan	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_VLAN); };
 close_scope_ipsec	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_IPSEC); };
+close_scope_limit	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_LIMIT); };
 close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
 close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
 close_scope_rt		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_RT); };
@@ -1057,11 +1058,11 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc_obj_ct(CMD_ADD, NFT_OBJECT_CT_EXPECT, &$3, &@$, $4);
 			}
-			|	LIMIT		obj_spec	limit_obj	limit_config
+			|	LIMIT		obj_spec	limit_obj	limit_config	close_scope_limit
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_LIMIT, &$2, &@$, $3);
 			}
-			|	LIMIT		obj_spec	limit_obj	'{' limit_block '}'
+			|	LIMIT		obj_spec	limit_obj	'{' limit_block '}'	close_scope_limit
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_LIMIT, &$2, &@$, $3);
 			}
@@ -1166,7 +1167,7 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc_obj_ct(CMD_CREATE, NFT_OBJECT_CT_EXPECT, &$3, &@$, $4);
 			}
-			|	LIMIT		obj_spec	limit_obj	limit_config
+			|	LIMIT		obj_spec	limit_obj	limit_config	close_scope_limit
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_LIMIT, &$2, &@$, $3);
 			}
@@ -1253,7 +1254,7 @@ delete_cmd		:	TABLE		table_or_id_spec
 			{
 				$$ = cmd_alloc_obj_ct(CMD_DELETE, $2, &$3, &@$, $4);
 			}
-			|	LIMIT		obj_or_id_spec
+			|	LIMIT		obj_or_id_spec	close_scope_limit
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_LIMIT, &$2, &@$, NULL);
 			}
@@ -1333,7 +1334,7 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_LIMITS, &$3, &@$, NULL);
 			}
-			|	LIMIT		obj_spec
+			|	LIMIT		obj_spec	close_scope_limit
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_LIMIT, &$2, &@$, NULL);
 			}
@@ -1667,7 +1668,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 			}
 			|	table_block	LIMIT		obj_identifier
 					obj_block_alloc	'{'	limit_block	'}'
-					stmt_separator
+					stmt_separator	close_scope_limit
 			{
 				$4->location = @3;
 				$4->type = NFT_OBJECT_LIMIT;
@@ -1880,7 +1881,7 @@ map_block_alloc		:	/* empty */
 
 map_block_obj_type	:	COUNTER	{ $$ = NFT_OBJECT_COUNTER; }
 			|	QUOTA { $$ = NFT_OBJECT_QUOTA; }
-			|	LIMIT { $$ = NFT_OBJECT_LIMIT; }
+			|	LIMIT	close_scope_limit { $$ = NFT_OBJECT_LIMIT; }
 			|	SECMARK { $$ = NFT_OBJECT_SECMARK; }
 			;
 
@@ -3045,7 +3046,7 @@ log_flag_tcp		:	SEQUENCE
 			}
 			;
 
-limit_stmt		:	LIMIT	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst_pkts
+limit_stmt		:	LIMIT	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst_pkts	close_scope_limit
 	    		{
 				if ($7 == 0) {
 					erec_queue(error(&@7, "limit burst must be > 0"),
@@ -3059,7 +3060,7 @@ limit_stmt		:	LIMIT	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst_pkts
 				$$->limit.type	= NFT_LIMIT_PKTS;
 				$$->limit.flags = $3;
 			}
-			|	LIMIT	RATE	limit_mode	NUM	STRING	limit_burst_bytes
+			|	LIMIT	RATE	limit_mode	NUM	STRING	limit_burst_bytes	close_scope_limit
 			{
 				struct error_record *erec;
 				uint64_t rate, unit;
@@ -3084,7 +3085,7 @@ limit_stmt		:	LIMIT	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst_pkts
 				$$->limit.type	= NFT_LIMIT_PKT_BYTES;
 				$$->limit.flags = $3;
 			}
-			|	LIMIT	NAME	stmt_expr
+			|	LIMIT	NAME	stmt_expr	close_scope_limit
 			{
 				$$ = objref_stmt_alloc(&@$);
 				$$->objref.type = NFT_OBJECT_LIMIT;
@@ -4140,7 +4141,7 @@ set_elem_stmt		:	COUNTER
 				$$->counter.packets = $3;
 				$$->counter.bytes = $5;
 			}
-			|	LIMIT   RATE    limit_mode      NUM     SLASH   time_unit       limit_burst_pkts
+			|	LIMIT   RATE    limit_mode      NUM     SLASH   time_unit       limit_burst_pkts	close_scope_limit
 			{
 				if ($7 == 0) {
 					erec_queue(error(&@7, "limit burst must be > 0"),
@@ -4154,7 +4155,7 @@ set_elem_stmt		:	COUNTER
 				$$->limit.type  = NFT_LIMIT_PKTS;
 				$$->limit.flags = $3;
 			}
-			|       LIMIT   RATE    limit_mode      NUM     STRING  limit_burst_bytes
+			|       LIMIT   RATE    limit_mode      NUM     STRING  limit_burst_bytes	close_scope_limit
 			{
 				struct error_record *erec;
 				uint64_t rate, unit;
diff --git a/src/scanner.l b/src/scanner.l
index b664a794184f..2c5aae846d4f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -201,6 +201,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_ETH
 %s SCANSTATE_IP
 %s SCANSTATE_IP6
+%s SCANSTATE_LIMIT
 %s SCANSTATE_VLAN
 %s SCANSTATE_EXPR_FIB
 %s SCANSTATE_EXPR_HASH
@@ -363,9 +364,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"bypass"	{ return BYPASS;}
 	"fanout"	{ return FANOUT;}
 }
-"limit"			{ return LIMIT; }
-"rate"			{ return RATE; }
-"burst"			{ return BURST; }
+"limit"			{ scanner_push_start_cond(yyscanner, SCANSTATE_LIMIT); return LIMIT; }
+<SCANSTATE_LIMIT>{
+	"rate"			{ return RATE; }
+	"burst"			{ return BURST; }
+}
 "until"			{ return UNTIL; }
 "over"			{ return OVER; }
 
-- 
2.26.2

