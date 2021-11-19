Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6120C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 15:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C875F6108B
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 15:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbhKSPcG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Nov 2021 10:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbhKSPcG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Nov 2021 10:32:06 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D31C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Nov 2021 07:29:04 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mo5p1-0005Qe-09; Fri, 19 Nov 2021 16:29:03 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/8] scanner: add tcp flex scope
Date:   Fri, 19 Nov 2021 16:28:41 +0100
Message-Id: <20211119152847.18118-3-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211119152847.18118-1-fw@strlen.de>
References: <20211119152847.18118-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This moves tcp options not used anywhere else (e.g. in synproxy) to a
distinct scope.  This will also allow to avoid exposing new option
keywords in the ruleset context.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   |  1 +
 src/parser_bison.y | 11 ++++++-----
 src/scanner.l      | 17 +++++++++++------
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index e8635b4c0feb..cb7d12a36edb 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -40,6 +40,7 @@ enum startcond_type {
 	PARSER_SC_QUOTA,
 	PARSER_SC_SCTP,
 	PARSER_SC_SECMARK,
+	PARSER_SC_TCP,
 	PARSER_SC_VLAN,
 	PARSER_SC_CMD_LIST,
 	PARSER_SC_EXPR_FIB,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index bc5ec2e667b8..2606098534e6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -929,6 +929,7 @@ close_scope_list	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_LIST); }
 close_scope_limit	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_LIMIT); };
 close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
 close_scope_quota	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_QUOTA); };
+close_scope_tcp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_TCP); }
 close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
 close_scope_rt		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_RT); };
 close_scope_sctp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_SCTP); };
@@ -3109,7 +3110,7 @@ level_type		:	string
 			}
 			;
 
-log_flags		:	TCP	log_flags_tcp
+log_flags		:	TCP	log_flags_tcp	close_scope_tcp
 			{
 				$$ = $2;
 			}
@@ -3360,7 +3361,7 @@ reject_opts		:       /* empty */
 				$<stmt>0->reject.expr = $3;
 				datatype_set($<stmt>0->reject.expr, &icmpx_code_type);
 			}
-			|	WITH	TCP	RESET
+			|	WITH	TCP	close_scope_tcp RESET
 			{
 				$<stmt>0->reject.type = NFT_REJECT_TCP_RST;
 			}
@@ -4460,7 +4461,7 @@ ct_cmd_type		:	HELPERS		{ $$ = CMD_OBJ_CT_HELPERS; }
 			|	EXPECTATION	{ $$ = CMD_OBJ_CT_EXPECT; }
 			;
 
-ct_l4protoname		:	TCP	{ $$ = IPPROTO_TCP; }
+ct_l4protoname		:	TCP	close_scope_tcp	{ $$ = IPPROTO_TCP; }
 			|	UDP	{ $$ = IPPROTO_UDP; }
 			;
 
@@ -4734,7 +4735,7 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 			|	integer_expr		{ $$ = $1; }
 			|	boolean_expr		{ $$ = $1; }
 			|	keyword_expr		{ $$ = $1; }
-			|	TCP
+			|	TCP	close_scope_tcp
 			{
 				uint8_t data = IPPROTO_TCP;
 				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
@@ -5241,7 +5242,7 @@ payload_expr		:	payload_raw_expr
 			|	comp_hdr_expr
 			|	udp_hdr_expr
 			|	udplite_hdr_expr
-			|	tcp_hdr_expr
+			|	tcp_hdr_expr	close_scope_tcp
 			|	dccp_hdr_expr
 			|	sctp_hdr_expr
 			|	th_hdr_expr
diff --git a/src/scanner.l b/src/scanner.l
index 455ef99fea8f..09fcbd094aa6 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -206,6 +206,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_QUOTA
 %s SCANSTATE_SCTP
 %s SCANSTATE_SECMARK
+%s SCANSTATE_TCP
 %s SCANSTATE_VLAN
 %s SCANSTATE_CMD_LIST
 %s SCANSTATE_EXPR_FIB
@@ -465,10 +466,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"value"			{ return VALUE; }
 }
 
+<SCANSTATE_TCP>{
 "echo"			{ return ECHO; }
 "eol"			{ return EOL; }
-"maxseg"		{ return MSS; }
-"mss"			{ return MSS; }
 "nop"			{ return NOP; }
 "noop"			{ return NOP; }
 "sack"			{ return SACK; }
@@ -476,9 +476,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "sack1"			{ return SACK1; }
 "sack2"			{ return SACK2; }
 "sack3"			{ return SACK3; }
-"sack-permitted"	{ return SACK_PERM; }
-"sack-perm"		{ return SACK_PERM; }
-"timestamp"		{ return TIMESTAMP; }
 "time"			{ return TIME; }
 
 "count"			{ return COUNT; }
@@ -486,6 +483,12 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "right"			{ return RIGHT; }
 "tsval"			{ return TSVAL; }
 "tsecr"			{ return TSECR; }
+}
+"maxseg"		{ return MSS; }
+"mss"			{ return MSS; }
+"sack-permitted"	{ return SACK_PERM; }
+"sack-perm"		{ return SACK_PERM; }
+"timestamp"		{ return TIMESTAMP; }
 
 "icmp"			{ return ICMP; }
 "code"			{ return CODE; }
@@ -524,7 +527,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "dport"			{ return DPORT; }
 "port"			{ return PORT; }
 
-"tcp"			{ return TCP; }
+"tcp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_TCP); return TCP; }
 "ackseq"		{ return ACKSEQ; }
 "doff"			{ return DOFF; }
 "window"		{ return WINDOW; }
@@ -560,6 +563,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"asconf"		{ return ASCONF; }
 
 	"tsn"			{ return TSN; }
+	"sack"			{ return SACK; }
 	"stream"		{ return STREAM; }
 	"ssn"			{ return SSN; }
 	"ppid"			{ return PPID; }
@@ -641,6 +645,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"label"			{ return LABEL; }
 	"state"			{ return STATE; }
 	"status"		{ return STATUS; }
+	"count"			{ return COUNT; }
 }
 
 "numgen"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_NUMGEN); return NUMGEN; }
-- 
2.32.0

