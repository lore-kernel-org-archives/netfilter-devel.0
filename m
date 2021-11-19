Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0642AC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 15:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1A336108B
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 15:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234310AbhKSPcK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Nov 2021 10:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbhKSPcK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Nov 2021 10:32:10 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4282C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Nov 2021 07:29:08 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mo5p5-0005RC-CC; Fri, 19 Nov 2021 16:29:07 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/8] parser: split tcp option rules
Date:   Fri, 19 Nov 2021 16:28:42 +0100
Message-Id: <20211119152847.18118-4-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211119152847.18118-1-fw@strlen.de>
References: <20211119152847.18118-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

At this time the parser will accept nonsensical input like

 tcp option mss left 2

which will be treated as 'tcp option maxseg size 2'.
This is because the enum space overlaps.

Split the rules so that 'tcp option mss' will only
accept field names specific to the mss/maxseg option kind.

Signed-off-by: Florian Westphal <fw@strlen.de>
(cherry picked from commit 46168852c03d73c29b557c93029dc512ca6e233a)
---
 src/parser_bison.y | 80 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 61 insertions(+), 19 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 2606098534e6..fca791326094 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -187,6 +187,10 @@ int nft_lex(void *, void *, void *);
 	struct position_spec	position_spec;
 	struct prio_spec	prio_spec;
 	struct limit_rate	limit_rate;
+	struct tcp_kind_field {
+		uint16_t kind; /* must allow > 255 for SACK1, 2.. hack */
+		uint8_t field;
+	} tcp_kind_field;
 }
 
 %token TOKEN_EOF 0		"end of file"
@@ -873,7 +877,10 @@ int nft_lex(void *, void *, void *);
 %type <expr>			tcp_hdr_expr
 %destructor { expr_free($$); }	tcp_hdr_expr
 %type <val>			tcp_hdr_field
-%type <val>			tcp_hdr_option_type tcp_hdr_option_field
+%type <val>			tcp_hdr_option_type
+%type <val>			tcp_hdr_option_sack
+%type <val>			tcpopt_field_maxseg	tcpopt_field_sack	 tcpopt_field_tsopt	tcpopt_field_window
+%type <tcp_kind_field>		tcp_hdr_option_kind_and_field
 
 %type <expr>			boolean_expr
 %destructor { expr_free($$); }	boolean_expr
@@ -5477,15 +5484,15 @@ tcp_hdr_expr		:	TCP	tcp_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_tcp, $2);
 			}
-			|	TCP	OPTION	tcp_hdr_option_type tcp_hdr_option_field
-			{
-				$$ = tcpopt_expr_alloc(&@$, $3, $4);
-			}
 			|	TCP	OPTION	tcp_hdr_option_type
 			{
 				$$ = tcpopt_expr_alloc(&@$, $3, TCPOPT_COMMON_KIND);
 				$$->exthdr.flags = NFT_EXTHDR_F_PRESENT;
 			}
+			|	TCP	OPTION	tcp_hdr_option_kind_and_field
+			{
+				$$ = tcpopt_expr_alloc(&@$, $3.kind, $3.field);
+			}
 			|	TCP	OPTION	AT tcp_hdr_option_type	COMMA	NUM	COMMA	NUM
 			{
 				$$ = tcpopt_expr_alloc(&@$, $4, 0);
@@ -5505,19 +5512,49 @@ tcp_hdr_field		:	SPORT		{ $$ = TCPHDR_SPORT; }
 			|	URGPTR		{ $$ = TCPHDR_URGPTR; }
 			;
 
-tcp_hdr_option_type	:	EOL		{ $$ = TCPOPT_KIND_EOL; }
-			|	NOP		{ $$ = TCPOPT_KIND_NOP; }
-			|	MSS  	  	{ $$ = TCPOPT_KIND_MAXSEG; }
-			|	WINDOW		{ $$ = TCPOPT_KIND_WINDOW; }
-			|	SACK_PERM	{ $$ = TCPOPT_KIND_SACK_PERMITTED; }
-			|	SACK		{ $$ = TCPOPT_KIND_SACK; }
+tcp_hdr_option_kind_and_field	:	MSS	tcpopt_field_maxseg
+				{
+					struct tcp_kind_field kind_field = { .kind = TCPOPT_KIND_MAXSEG, .field = $2 };
+					$$ = kind_field;
+				}
+				|	tcp_hdr_option_sack	tcpopt_field_sack
+				{
+					struct tcp_kind_field kind_field = { .kind = $1, .field = $2 };
+					$$ = kind_field;
+				}
+				|	WINDOW	tcpopt_field_window
+				{
+					struct tcp_kind_field kind_field = { .kind = TCPOPT_KIND_WINDOW, .field = $2 };
+					$$ = kind_field;
+				}
+				|	TIMESTAMP	tcpopt_field_tsopt
+				{
+					struct tcp_kind_field kind_field = { .kind = TCPOPT_KIND_TIMESTAMP, .field = $2 };
+					$$ = kind_field;
+				}
+				|	tcp_hdr_option_type	LENGTH
+				{
+					struct tcp_kind_field kind_field = { .kind = $1, .field = TCPOPT_COMMON_LENGTH };
+					$$ = kind_field;
+				}
+				;
+
+tcp_hdr_option_sack	:	SACK		{ $$ = TCPOPT_KIND_SACK; }
 			|	SACK0		{ $$ = TCPOPT_KIND_SACK; }
 			|	SACK1		{ $$ = TCPOPT_KIND_SACK1; }
 			|	SACK2		{ $$ = TCPOPT_KIND_SACK2; }
 			|	SACK3		{ $$ = TCPOPT_KIND_SACK3; }
-			|	ECHO		{ $$ = TCPOPT_KIND_ECHO; }
-			|	TIMESTAMP	{ $$ = TCPOPT_KIND_TIMESTAMP; }
-			|	NUM		{
+			;
+
+tcp_hdr_option_type	:	ECHO			{ $$ = TCPOPT_KIND_ECHO; }
+			|	EOL			{ $$ = TCPOPT_KIND_EOL; }
+			|	MSS			{ $$ = TCPOPT_KIND_MAXSEG; }
+			|	NOP			{ $$ = TCPOPT_KIND_NOP; }
+			|	SACK_PERM		{ $$ = TCPOPT_KIND_SACK_PERMITTED; }
+			|	TIMESTAMP		{ $$ = TCPOPT_KIND_TIMESTAMP; }
+			|	WINDOW			{ $$ = TCPOPT_KIND_WINDOW; }
+			|	tcp_hdr_option_sack	{ $$ = $1; }
+			|	NUM			{
 				if ($1 > 255) {
 					erec_queue(error(&@1, "value too large"), state->msgs);
 					YYERROR;
@@ -5526,15 +5563,20 @@ tcp_hdr_option_type	:	EOL		{ $$ = TCPOPT_KIND_EOL; }
 			}
 			;
 
-tcp_hdr_option_field	:	LENGTH		{ $$ = TCPOPT_COMMON_LENGTH; }
-			|	SIZE		{ $$ = TCPOPT_MAXSEG_SIZE; }
-			|	COUNT		{ $$ = TCPOPT_WINDOW_COUNT; }
-			|	LEFT		{ $$ = TCPOPT_SACK_LEFT; }
+tcpopt_field_sack	: 	LEFT		{ $$ = TCPOPT_SACK_LEFT; }
 			|	RIGHT		{ $$ = TCPOPT_SACK_RIGHT; }
-			|	TSVAL		{ $$ = TCPOPT_TS_TSVAL; }
+			;
+
+tcpopt_field_window	:	COUNT           { $$ = TCPOPT_WINDOW_COUNT; }
+			;
+
+tcpopt_field_tsopt	:	TSVAL           { $$ = TCPOPT_TS_TSVAL; }
 			|	TSECR		{ $$ = TCPOPT_TS_TSECR; }
 			;
 
+tcpopt_field_maxseg	:	SIZE		{ $$ = TCPOPT_MAXSEG_SIZE; }
+			;
+
 dccp_hdr_expr		:	DCCP	dccp_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_dccp, $2);
-- 
2.32.0

