Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 860B6C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 15:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 663A86117A
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 15:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbhKSPcP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Nov 2021 10:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbhKSPcO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Nov 2021 10:32:14 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CBEC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Nov 2021 07:29:13 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mo5p9-0005RS-ND; Fri, 19 Nov 2021 16:29:11 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/8] tcpopt: add md5sig, fastopen and mptcp options
Date:   Fri, 19 Nov 2021 16:28:43 +0100
Message-Id: <20211119152847.18118-5-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211119152847.18118-1-fw@strlen.de>
References: <20211119152847.18118-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow to use "fastopen", "md5sig" and "mptcp" mnemonics rather than the
raw option numbers.

These new keywords are only recognized while scanner is in tcp state.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/tcpopt.h   |  8 ++++++++
 src/parser_bison.y | 10 ++++++++--
 src/scanner.l      |  3 +++
 src/tcpopt.c       | 30 ++++++++++++++++++++++++++++++
 4 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/include/tcpopt.h b/include/tcpopt.h
index 667c8a7725d8..22df69dc5b93 100644
--- a/include/tcpopt.h
+++ b/include/tcpopt.h
@@ -25,6 +25,9 @@ enum tcpopt_kind {
 	TCPOPT_KIND_SACK = 5,
 	TCPOPT_KIND_TIMESTAMP = 8,
 	TCPOPT_KIND_ECHO = 8,
+	TCPOPT_KIND_MD5SIG = 19,
+	TCPOPT_KIND_MPTCP = 30,
+	TCPOPT_KIND_FASTOPEN = 34,
 	__TCPOPT_KIND_MAX,
 
 	/* extra oob info, internal to nft */
@@ -71,6 +74,11 @@ enum tcpopt_hdr_field_sack {
 	TCPOPT_SACK_RIGHT3,
 };
 
+enum tcpopt_hdr_mptcp_common {
+	TCPOPT_MPTCP_KIND,
+	TCPOPT_MPTCP_LENGTH,
+};
+
 extern const struct exthdr_desc *tcpopt_protocols[__TCPOPT_KIND_MAX];
 
 #endif /* NFTABLES_TCPOPT_H */
diff --git a/src/parser_bison.y b/src/parser_bison.y
index fca791326094..a6a591b7e00d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -408,6 +408,7 @@ int nft_lex(void *, void *, void *);
 %token OPTION			"option"
 %token ECHO			"echo"
 %token EOL			"eol"
+%token MPTCP			"mptcp"
 %token NOP			"nop"
 %token SACK			"sack"
 %token SACK0			"sack0"
@@ -415,6 +416,8 @@ int nft_lex(void *, void *, void *);
 %token SACK2			"sack2"
 %token SACK3			"sack3"
 %token SACK_PERM		"sack-permitted"
+%token FASTOPEN			"fastopen"
+%token MD5SIG			"md5sig"
 %token TIMESTAMP		"timestamp"
 %token COUNT			"count"
 %token LEFT			"left"
@@ -5548,11 +5551,14 @@ tcp_hdr_option_sack	:	SACK		{ $$ = TCPOPT_KIND_SACK; }
 
 tcp_hdr_option_type	:	ECHO			{ $$ = TCPOPT_KIND_ECHO; }
 			|	EOL			{ $$ = TCPOPT_KIND_EOL; }
+			|	FASTOPEN		{ $$ = TCPOPT_KIND_FASTOPEN; }
+			|	MD5SIG			{ $$ = TCPOPT_KIND_MD5SIG; }
+			|	MPTCP			{ $$ = TCPOPT_KIND_MPTCP; }
 			|	MSS			{ $$ = TCPOPT_KIND_MAXSEG; }
 			|	NOP			{ $$ = TCPOPT_KIND_NOP; }
 			|	SACK_PERM		{ $$ = TCPOPT_KIND_SACK_PERMITTED; }
-			|	TIMESTAMP		{ $$ = TCPOPT_KIND_TIMESTAMP; }
-			|	WINDOW			{ $$ = TCPOPT_KIND_WINDOW; }
+			|       TIMESTAMP               { $$ = TCPOPT_KIND_TIMESTAMP; }
+			|       WINDOW                  { $$ = TCPOPT_KIND_WINDOW; }
 			|	tcp_hdr_option_sack	{ $$ = $1; }
 			|	NUM			{
 				if ($1 > 255) {
diff --git a/src/scanner.l b/src/scanner.l
index 09fcbd094aa6..c65d57846c59 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -469,6 +469,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <SCANSTATE_TCP>{
 "echo"			{ return ECHO; }
 "eol"			{ return EOL; }
+"fastopen"		{ return FASTOPEN; }
+"mptcp"			{ return MPTCP; }
+"md5sig"		{ return MD5SIG; }
 "nop"			{ return NOP; }
 "noop"			{ return NOP; }
 "sack"			{ return SACK; }
diff --git a/src/tcpopt.c b/src/tcpopt.c
index 53fe9bc860a8..5913cd065d03 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -91,6 +91,33 @@ static const struct exthdr_desc tcpopt_timestamp = {
 	},
 };
 
+static const struct exthdr_desc tcpopt_fastopen = {
+	.name		= "fastopen",
+	.type		= TCPOPT_KIND_FASTOPEN,
+	.templates	= {
+		[TCPOPT_COMMON_KIND]	= PHT("kind",   0, 8),
+		[TCPOPT_COMMON_LENGTH]	= PHT("length", 8, 8),
+	},
+};
+
+static const struct exthdr_desc tcpopt_md5sig = {
+	.name		= "md5sig",
+	.type		= TCPOPT_KIND_MD5SIG,
+	.templates	= {
+		[TCPOPT_COMMON_KIND]	= PHT("kind",   0, 8),
+		[TCPOPT_COMMON_LENGTH]	= PHT("length", 8, 8),
+	},
+};
+
+
+static const struct exthdr_desc tcpopt_mptcp = {
+	.name		= "mptcp",
+	.type		= TCPOPT_KIND_MPTCP,
+	.templates	= {
+		[TCPOPT_MPTCP_KIND]	= PHT("kind",   0,   8),
+		[TCPOPT_MPTCP_LENGTH]	= PHT("length", 8,  8),
+	},
+};
 #undef PHT
 
 const struct exthdr_desc *tcpopt_protocols[] = {
@@ -101,6 +128,9 @@ const struct exthdr_desc *tcpopt_protocols[] = {
 	[TCPOPT_KIND_SACK_PERMITTED]	= &tcpopt_sack_permitted,
 	[TCPOPT_KIND_SACK]		= &tcpopt_sack,
 	[TCPOPT_KIND_TIMESTAMP]		= &tcpopt_timestamp,
+	[TCPOPT_KIND_MD5SIG]		= &tcpopt_md5sig,
+	[TCPOPT_KIND_MPTCP]		= &tcpopt_mptcp,
+	[TCPOPT_KIND_FASTOPEN]		= &tcpopt_fastopen,
 };
 
 /**
-- 
2.32.0

