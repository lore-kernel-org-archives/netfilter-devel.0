Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D9EC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 15:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1DBF61548
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 15:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbhKSPcX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Nov 2021 10:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbhKSPcX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Nov 2021 10:32:23 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D182DC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Nov 2021 07:29:21 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mo5pI-0005SF-E6; Fri, 19 Nov 2021 16:29:20 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 6/8] mptcp: add subtype matching
Date:   Fri, 19 Nov 2021 16:28:45 +0100
Message-Id: <20211119152847.18118-7-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211119152847.18118-1-fw@strlen.de>
References: <20211119152847.18118-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

MPTCP multiplexes the various mptcp signalling data using the
first 4 bits of the mptcp option.

This allows to match on the mptcp subtype via:

   tcp option mptcp subtype 1

This misses delinearization support. mptcp subtype is the first tcp
option field that has a length of less than one byte.

Serialization processing will add a binop for this, but netlink
delinearization can't remove them, yet.

Also misses a new datatype/symbol table to allow to use mnemonics like
'mp_join' instead of raw numbers.

For this reason, no tests are added yet.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/tcpopt.h   |  1 +
 src/parser_bison.y | 11 ++++++++++-
 src/scanner.l      |  1 +
 src/tcpopt.c       |  1 +
 4 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/tcpopt.h b/include/tcpopt.h
index 22df69dc5b93..bb5c1329018e 100644
--- a/include/tcpopt.h
+++ b/include/tcpopt.h
@@ -77,6 +77,7 @@ enum tcpopt_hdr_field_sack {
 enum tcpopt_hdr_mptcp_common {
 	TCPOPT_MPTCP_KIND,
 	TCPOPT_MPTCP_LENGTH,
+	TCPOPT_MPTCP_SUBTYPE,
 };
 
 extern const struct exthdr_desc *tcpopt_protocols[__TCPOPT_KIND_MAX];
diff --git a/src/parser_bison.y b/src/parser_bison.y
index a6a591b7e00d..355758e1befb 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -424,6 +424,7 @@ int nft_lex(void *, void *, void *);
 %token RIGHT			"right"
 %token TSVAL			"tsval"
 %token TSECR			"tsecr"
+%token SUBTYPE			"subtype"
 
 %token DCCP			"dccp"
 
@@ -882,7 +883,7 @@ int nft_lex(void *, void *, void *);
 %type <val>			tcp_hdr_field
 %type <val>			tcp_hdr_option_type
 %type <val>			tcp_hdr_option_sack
-%type <val>			tcpopt_field_maxseg	tcpopt_field_sack	 tcpopt_field_tsopt	tcpopt_field_window
+%type <val>			tcpopt_field_maxseg	tcpopt_field_mptcp	tcpopt_field_sack	 tcpopt_field_tsopt	tcpopt_field_window
 %type <tcp_kind_field>		tcp_hdr_option_kind_and_field
 
 %type <expr>			boolean_expr
@@ -5540,6 +5541,11 @@ tcp_hdr_option_kind_and_field	:	MSS	tcpopt_field_maxseg
 					struct tcp_kind_field kind_field = { .kind = $1, .field = TCPOPT_COMMON_LENGTH };
 					$$ = kind_field;
 				}
+				|	MPTCP	tcpopt_field_mptcp
+				{
+					struct tcp_kind_field kind_field = { .kind = TCPOPT_KIND_MPTCP, .field = $2 };
+					$$ = kind_field;
+				}
 				;
 
 tcp_hdr_option_sack	:	SACK		{ $$ = TCPOPT_KIND_SACK; }
@@ -5583,6 +5589,9 @@ tcpopt_field_tsopt	:	TSVAL           { $$ = TCPOPT_TS_TSVAL; }
 tcpopt_field_maxseg	:	SIZE		{ $$ = TCPOPT_MAXSEG_SIZE; }
 			;
 
+tcpopt_field_mptcp	:	SUBTYPE		{ $$ = TCPOPT_MPTCP_SUBTYPE; }
+			;
+
 dccp_hdr_expr		:	DCCP	dccp_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_dccp, $2);
diff --git a/src/scanner.l b/src/scanner.l
index c65d57846c59..f28bf3153f0b 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -472,6 +472,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "fastopen"		{ return FASTOPEN; }
 "mptcp"			{ return MPTCP; }
 "md5sig"		{ return MD5SIG; }
+"subtype"		{ return SUBTYPE; }
 "nop"			{ return NOP; }
 "noop"			{ return NOP; }
 "sack"			{ return SACK; }
diff --git a/src/tcpopt.c b/src/tcpopt.c
index 5913cd065d03..641daa7359a3 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -116,6 +116,7 @@ static const struct exthdr_desc tcpopt_mptcp = {
 	.templates	= {
 		[TCPOPT_MPTCP_KIND]	= PHT("kind",   0,   8),
 		[TCPOPT_MPTCP_LENGTH]	= PHT("length", 8,  8),
+		[TCPOPT_MPTCP_SUBTYPE]  = PHT("subtype", 16, 4),
 	},
 };
 #undef PHT
-- 
2.32.0

