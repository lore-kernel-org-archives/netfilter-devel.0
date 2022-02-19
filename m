Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5DA2C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240202AbiBSN3K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:29:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234934AbiBSN3K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:29:10 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D8F1011
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6jhmb5EqNyq6Pa2KpQhuqW1+3PXj+A6swXwn01kqolA=; b=VHQ+7RI6ic/Qv9xBWQ1vIC2rsw
        dnQK4mNrZ0MSIaQqLlbrlJcRpxxNRidatAkRiFFLEcYVwngzzzsAcDcE2/igIr9oAVjKCOn5s2pzi
        VUWoZ3hdneKirJK+gM3CTrz3VkreCpKmj2d4GYTxc3mAxYQ1Af5zfiWV7U1hqGLzzaxM5ArxpewNa
        vzFsdqjYNOycTNx9GeH99wP07opZbid3COYBK4jxwDYL6gbLyDhIW6z4sQMDBgSWycnClD0DS2meN
        /zyoU53MEDtWcZLMlncdggb+PTpIbtbQjZkylrRbbupyp34bNsLIJhCs57GT9nFmz7/ppjfKOXEdp
        4sivu77w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPn7-0002X1-I8; Sat, 19 Feb 2022 14:28:49 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 21/26] scanner: flags: move to own scope
Date:   Sat, 19 Feb 2022 14:28:09 +0100
Message-Id: <20220219132814.30823-22-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This isolates at least 'constant', 'dynamic' and 'all' keywords.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   |  1 +
 src/parser_bison.y | 29 +++++++++++++++--------------
 src/scanner.l      | 16 ++++++++++------
 3 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 08bdeaca250b2..57f1fcc56bd54 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -34,6 +34,7 @@ enum startcond_type {
 	PARSER_SC_CT,
 	PARSER_SC_COUNTER,
 	PARSER_SC_ETH,
+	PARSER_SC_FLAGS,
 	PARSER_SC_ICMP,
 	PARSER_SC_IGMP,
 	PARSER_SC_IP,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 1cdf4cc88376f..af31f72fd6c99 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -937,6 +937,7 @@ close_scope_esp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_ESP); }
 close_scope_eth		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ETH); };
 close_scope_export	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_EXPORT); };
 close_scope_fib		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_FIB); };
+close_scope_flags	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_FLAGS); };
 close_scope_frag	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_FRAG); };
 close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH); };
 close_scope_hbh		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HBH); };
@@ -1668,7 +1669,7 @@ table_block_alloc	:	/* empty */
 			}
 			;
 
-table_options		:	FLAGS		STRING
+table_options		:	FLAGS		STRING	close_scope_flags
 			{
 				if (strcmp($2, "dormant") == 0) {
 					$<table>0->flags |= TABLE_F_DORMANT;
@@ -1935,7 +1936,7 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 				datatype_set($1->key, $3->dtype);
 				$$ = $1;
 			}
-			|	set_block	FLAGS		set_flag_list	stmt_separator
+			|	set_block	FLAGS		set_flag_list	stmt_separator	close_scope_flags
 			{
 				$1->flags = $3;
 				$$ = $1;
@@ -2069,7 +2070,7 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->flags  |= NFT_SET_OBJECT;
 				$$ = $1;
 			}
-			|	map_block	FLAGS		set_flag_list	stmt_separator
+			|	map_block	FLAGS		set_flag_list	stmt_separator	close_scope_flags
 			{
 				$1->flags |= $3;
 				$$ = $1;
@@ -2142,7 +2143,7 @@ flowtable_block		:	/* empty */	{ $$ = $<flowtable>-1; }
 			{
 				$$->flags |= NFT_FLOWTABLE_COUNTER;
 			}
-			|	flowtable_block	FLAGS	OFFLOAD	stmt_separator
+			|	flowtable_block	FLAGS	OFFLOAD	stmt_separator	close_scope_flags
 			{
 				$$->flags |= FLOWTABLE_F_HW_OFFLOAD;
 			}
@@ -2509,7 +2510,7 @@ dev_spec		:	DEVICE	string
 			|	/* empty */		{ $$ = NULL; }
 			;
 
-flags_spec		:	FLAGS		OFFLOAD
+flags_spec		:	FLAGS		OFFLOAD	close_scope_flags
 			{
 				$<chain>0->flags |= CHAIN_F_HW_OFFLOAD;
 			}
@@ -3114,7 +3115,7 @@ log_arg			:	PREFIX			string
 				$<stmt>0->log.level	= $2;
 				$<stmt>0->log.flags 	|= STMT_LOG_LEVEL;
 			}
-			|	FLAGS			log_flags
+			|	FLAGS			log_flags	close_scope_flags
 			{
 				$<stmt>0->log.logflags	|= $2;
 			}
@@ -3816,13 +3817,13 @@ queue_stmt		:	queue_stmt_compat	close_scope_queue
 			{
 				$$ = queue_stmt_alloc(&@$, $3, 0);
 			}
-			|	QUEUE FLAGS	queue_stmt_flags TO queue_stmt_expr close_scope_queue
+			|	QUEUE FLAGS	queue_stmt_flags close_scope_flags TO queue_stmt_expr close_scope_queue
 			{
-				$$ = queue_stmt_alloc(&@$, $5, $3);
+				$$ = queue_stmt_alloc(&@$, $6, $3);
 			}
-			|	QUEUE	FLAGS	queue_stmt_flags QUEUENUM queue_stmt_expr_simple close_scope_queue
+			|	QUEUE	FLAGS	queue_stmt_flags close_scope_flags QUEUENUM queue_stmt_expr_simple close_scope_queue
 			{
-				$$ = queue_stmt_alloc(&@$, $5, $3);
+				$$ = queue_stmt_alloc(&@$, $6, $3);
 			}
 			;
 
@@ -5489,7 +5490,7 @@ comp_hdr_expr		:	COMP	comp_hdr_field	close_scope_comp
 			;
 
 comp_hdr_field		:	NEXTHDR		{ $$ = COMPHDR_NEXTHDR; }
-			|	FLAGS		{ $$ = COMPHDR_FLAGS; }
+			|	FLAGS	close_scope_flags	{ $$ = COMPHDR_FLAGS; }
 			|	CPI		{ $$ = COMPHDR_CPI; }
 			;
 
@@ -5543,7 +5544,7 @@ tcp_hdr_field		:	SPORT		{ $$ = TCPHDR_SPORT; }
 			|	ACKSEQ		{ $$ = TCPHDR_ACKSEQ; }
 			|	DOFF		{ $$ = TCPHDR_DOFF; }
 			|	RESERVED	{ $$ = TCPHDR_RESERVED; }
-			|	FLAGS		{ $$ = TCPHDR_FLAGS; }
+			|	FLAGS	close_scope_flags	{ $$ = TCPHDR_FLAGS; }
 			|	WINDOW		{ $$ = TCPHDR_WINDOW; }
 			|	CHECKSUM	{ $$ = TCPHDR_CHECKSUM; }
 			|	URGPTR		{ $$ = TCPHDR_URGPTR; }
@@ -5657,7 +5658,7 @@ sctp_chunk_type		:	DATA		{ $$ = SCTP_CHUNK_TYPE_DATA; }
 			;
 
 sctp_chunk_common_field	:	TYPE	close_scope_type	{ $$ = SCTP_CHUNK_COMMON_TYPE; }
-			|	FLAGS	{ $$ = SCTP_CHUNK_COMMON_FLAGS; }
+			|	FLAGS	close_scope_flags	{ $$ = SCTP_CHUNK_COMMON_FLAGS; }
 			|	LENGTH	{ $$ = SCTP_CHUNK_COMMON_LENGTH; }
 			;
 
@@ -5825,7 +5826,7 @@ rt4_hdr_expr		:	RT4	rt4_hdr_field	close_scope_rt
 			;
 
 rt4_hdr_field		:	LAST_ENT	{ $$ = RT4HDR_LASTENT; }
-			|	FLAGS		{ $$ = RT4HDR_FLAGS; }
+			|	FLAGS	close_scope_flags	{ $$ = RT4HDR_FLAGS; }
 			|	TAG		{ $$ = RT4HDR_TAG; }
 			|	SID		'['	NUM	']'
 			{
diff --git a/src/scanner.l b/src/scanner.l
index 6ef20512f6b35..608471b39898d 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -200,6 +200,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_CT
 %s SCANSTATE_COUNTER
 %s SCANSTATE_ETH
+%s SCANSTATE_FLAGS
 %s SCANSTATE_ICMP
 %s SCANSTATE_IGMP
 %s SCANSTATE_IP
@@ -355,9 +356,14 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "index"			{ return INDEX; }
 "comment"		{ return COMMENT; }
 
-"constant"		{ return CONSTANT; }
+<SCANSTATE_FLAGS>{
+	"constant"		{ return CONSTANT; }
+	"dynamic"		{ return DYNAMIC; }
+
+	/* log flags */
+	"all"			{ return ALL; }
+}
 "interval"		{ return INTERVAL; }
-"dynamic"		{ return DYNAMIC; }
 "auto-merge"		{ return AUTOMERGE; }
 "timeout"		{ return TIMEOUT; }
 "gc-interval"		{ return GC_INTERVAL; }
@@ -403,7 +409,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 }
 
 "queue"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_QUEUE); return QUEUE;}
-<SCANSTATE_EXPR_QUEUE>{
+<SCANSTATE_FLAGS,SCANSTATE_EXPR_QUEUE>{
 	"num"		{ return QUEUENUM;}
 	"bypass"	{ return BYPASS;}
 	"fanout"	{ return FANOUT;}
@@ -592,7 +598,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <SCANSTATE_EXPR_COMP>{
 	"cpi"			{ return CPI; }
 }
-"flags"			{ return FLAGS; }
+"flags"			{ scanner_push_start_cond(yyscanner, SCANSTATE_FLAGS); return FLAGS; }
 
 "udp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_UDP); return UDP; }
 "udplite"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_UDPLITE); return UDPLITE; }
@@ -762,8 +768,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "notrack"		{ return NOTRACK; }
 
-"all"			{ return ALL; }
-
 <SCANSTATE_CMD_EXPORT,SCANSTATE_CMD_IMPORT,SCANSTATE_CMD_MONITOR>{
 	"xml"			{ return XML; }
 	"json"			{ return JSON; }
-- 
2.34.1

