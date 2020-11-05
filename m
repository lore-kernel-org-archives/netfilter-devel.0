Return-Path: <SRS0=okMr=EL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9AF7C55179
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DF78206DB
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731006AbgKEOL4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 09:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgKEOL4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 09:11:56 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D646C0613CF
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2020 06:11:56 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kafzW-0006GB-Pu; Thu, 05 Nov 2020 15:11:54 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/7] parser: merge sack-perm/sack-permitted and maxseg/mss
Date:   Thu,  5 Nov 2020 15:11:38 +0100
Message-Id: <20201105141144.31430-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201105141144.31430-1-fw@strlen.de>
References: <20201105141144.31430-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

One was added by the tcp option parsing ocde, the other by synproxy.

So we have:
synproxy ... sack-perm
synproxy ... mss

and

tcp option maxseg
tcp option sack-permitted

This kills the extra tokens on the scanner/parser side,
so sack-perm and sack-permitted can both be used.

Likewise, 'synproxy maxseg' and 'tcp option mss size 42' will
work too.  On the output side, the shorter form is now preferred,
i.e. sack-perm and mss.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/payload-expression.txt    |  8 ++++----
 src/parser_bison.y            | 13 ++++++-------
 src/scanner.l                 |  8 ++++----
 src/tcpopt.c                  |  2 +-
 tests/py/any/tcpopt.t         |  4 ++--
 tests/py/any/tcpopt.t.json    |  8 ++++----
 tests/py/any/tcpopt.t.payload | 12 ++++++------
 7 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 93d4d22f59f5..9df20a18ae8a 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -525,13 +525,13 @@ nftables currently supports matching (finding) a given ipv6 extension header, TC
 *dst* {*nexthdr* | *hdrlength*}
 *mh* {*nexthdr* | *hdrlength* | *checksum* | *type*}
 *srh* {*flags* | *tag* | *sid* | *seg-left*}
-*tcp option* {*eol* | *noop* | *maxseg* | *window* | *sack-permitted* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*} 'tcp_option_field'
+*tcp option* {*eol* | *noop* | *maxseg* | *window* | *sack-perm* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*} 'tcp_option_field'
 *ip option* { lsrr | ra | rr | ssrr } 'ip_option_field'
 
 The following syntaxes are valid only in a relational expression with boolean type on right-hand side for checking header existence only:
 [verse]
 *exthdr* {*hbh* | *frag* | *rt* | *dst* | *mh*}
-*tcp option* {*eol* | *noop* | *maxseg* | *window* | *sack-permitted* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*}
+*tcp option* {*eol* | *noop* | *maxseg* | *window* | *sack-perm* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*}
 *ip option* { lsrr | ra | rr | ssrr }
 
 .IPv6 extension headers
@@ -568,7 +568,7 @@ kind, length, size
 |window|
 TCP Window Scaling |
 kind, length, count
-|sack-permitted|
+|sack-perm |
 TCP SACK permitted |
 kind, length
 |sack|
@@ -611,7 +611,7 @@ type, length, ptr, addr
 
 .finding TCP options
 --------------------
-filter input tcp option sack-permitted kind 1 counter
+filter input tcp option sack-perm kind 1 counter
 --------------------
 
 .matching IPv6 exthdr
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9bf4f71f1f66..8c37f895167e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -233,7 +233,6 @@ int nft_lex(void *, void *, void *);
 %token SYNPROXY			"synproxy"
 %token MSS			"mss"
 %token WSCALE			"wscale"
-%token SACKPERM			"sack-perm"
 
 %token TYPEOF			"typeof"
 
@@ -400,14 +399,13 @@ int nft_lex(void *, void *, void *);
 %token OPTION			"option"
 %token ECHO			"echo"
 %token EOL			"eol"
-%token MAXSEG			"maxseg"
 %token NOOP			"noop"
 %token SACK			"sack"
 %token SACK0			"sack0"
 %token SACK1			"sack1"
 %token SACK2			"sack2"
 %token SACK3			"sack3"
-%token SACK_PERMITTED		"sack-permitted"
+%token SACK_PERM		"sack-permitted"
 %token TIMESTAMP		"timestamp"
 %token KIND			"kind"
 %token COUNT			"count"
@@ -3279,7 +3277,7 @@ synproxy_arg		:	MSS	NUM
 			{
 				$<stmt>0->synproxy.flags |= NF_SYNPROXY_OPT_TIMESTAMP;
 			}
-			|	SACKPERM
+			|	SACK_PERM
 			{
 				$<stmt>0->synproxy.flags |= NF_SYNPROXY_OPT_SACK_PERM;
 			}
@@ -3334,7 +3332,7 @@ synproxy_ts		:	/* empty */	{ $$ = 0; }
 			;
 
 synproxy_sack		:	/* empty */	{ $$ = 0; }
-			|	SACKPERM
+			|	SACK_PERM
 			{
 				$$ = NF_SYNPROXY_OPT_SACK_PERM;
 			}
@@ -5216,9 +5214,10 @@ tcp_hdr_field		:	SPORT		{ $$ = TCPHDR_SPORT; }
 
 tcp_hdr_option_type	:	EOL		{ $$ = TCPOPTHDR_EOL; }
 			|	NOOP		{ $$ = TCPOPTHDR_NOOP; }
-			|	MAXSEG		{ $$ = TCPOPTHDR_MAXSEG; }
+			|	MSS  	  	{ $$ = TCPOPTHDR_MAXSEG; }
+			|	SACK_PERM	{ $$ = TCPOPTHDR_SACK_PERMITTED; }
 			|	WINDOW		{ $$ = TCPOPTHDR_WINDOW; }
-			|	SACK_PERMITTED	{ $$ = TCPOPTHDR_SACK_PERMITTED; }
+			|	WSCALE		{ $$ = TCPOPTHDR_WINDOW; }
 			|	SACK		{ $$ = TCPOPTHDR_SACK0; }
 			|	SACK0		{ $$ = TCPOPTHDR_SACK0; }
 			|	SACK1		{ $$ = TCPOPTHDR_SACK1; }
diff --git a/src/scanner.l b/src/scanner.l
index 7afd9bfb8893..516c648f1c1f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -421,14 +421,16 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "echo"			{ return ECHO; }
 "eol"			{ return EOL; }
-"maxseg"		{ return MAXSEG; }
+"maxseg"		{ return MSS; }
+"mss"			{ return MSS; }
 "noop"			{ return NOOP; }
 "sack"			{ return SACK; }
 "sack0"			{ return SACK0; }
 "sack1"			{ return SACK1; }
 "sack2"			{ return SACK2; }
 "sack3"			{ return SACK3; }
-"sack-permitted"	{ return SACK_PERMITTED; }
+"sack-permitted"	{ return SACK_PERM; }
+"sack-perm"		{ return SACK_PERM; }
 "timestamp"		{ return TIMESTAMP; }
 "time"			{ return TIME; }
 
@@ -565,9 +567,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "osf"			{ return OSF; }
 
 "synproxy"		{ return SYNPROXY; }
-"mss"			{ return MSS; }
 "wscale"		{ return WSCALE; }
-"sack-perm"		{ return SACKPERM; }
 
 "notrack"		{ return NOTRACK; }
 
diff --git a/src/tcpopt.c b/src/tcpopt.c
index ec305d9466d5..6dbaa9e6dd17 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -55,7 +55,7 @@ static const struct exthdr_desc tcpopt_window = {
 };
 
 static const struct exthdr_desc tcpopt_sack_permitted = {
-	.name		= "sack-permitted",
+	.name		= "sack-perm",
 	.type		= TCPOPT_SACK_PERMITTED,
 	.templates	= {
 		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0, 8),
diff --git a/tests/py/any/tcpopt.t b/tests/py/any/tcpopt.t
index 08b1dcb3c489..5f21d4989fea 100644
--- a/tests/py/any/tcpopt.t
+++ b/tests/py/any/tcpopt.t
@@ -12,8 +12,8 @@ tcp option maxseg size 1;ok
 tcp option window kind 1;ok
 tcp option window length 1;ok
 tcp option window count 1;ok
-tcp option sack-permitted kind 1;ok
-tcp option sack-permitted length 1;ok
+tcp option sack-perm kind 1;ok
+tcp option sack-perm length 1;ok
 tcp option sack kind 1;ok
 tcp option sack length 1;ok
 tcp option sack left 1;ok
diff --git a/tests/py/any/tcpopt.t.json b/tests/py/any/tcpopt.t.json
index 48eb339cee35..2c6236a1a152 100644
--- a/tests/py/any/tcpopt.t.json
+++ b/tests/py/any/tcpopt.t.json
@@ -126,14 +126,14 @@
     }
 ]
 
-# tcp option sack-permitted kind 1
+# tcp option sack-perm kind 1
 [
     {
         "match": {
             "left": {
                 "tcp option": {
                     "field": "kind",
-                    "name": "sack-permitted"
+                    "name": "sack-perm"
                 }
             },
             "op": "==",
@@ -142,14 +142,14 @@
     }
 ]
 
-# tcp option sack-permitted length 1
+# tcp option sack-perm length 1
 [
     {
         "match": {
             "left": {
                 "tcp option": {
                     "field": "length",
-                    "name": "sack-permitted"
+                    "name": "sack-perm"
                 }
             },
             "op": "==",
diff --git a/tests/py/any/tcpopt.t.payload b/tests/py/any/tcpopt.t.payload
index 63751cf26e75..f63076ae497e 100644
--- a/tests/py/any/tcpopt.t.payload
+++ b/tests/py/any/tcpopt.t.payload
@@ -166,42 +166,42 @@ inet
   [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option sack-permitted kind 1
+# tcp option sack-perm kind 1
 ip 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option sack-permitted kind 1
+# tcp option sack-perm kind 1
 ip6 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option sack-permitted kind 1
+# tcp option sack-perm kind 1
 inet 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option sack-permitted length 1
+# tcp option sack-perm length 1
 ip 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option sack-permitted length 1
+# tcp option sack-perm length 1
 ip6 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option sack-permitted length 1
+# tcp option sack-perm length 1
 inet 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
-- 
2.26.2

