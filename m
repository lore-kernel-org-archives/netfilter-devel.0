Return-Path: <SRS0=okMr=EL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5440EC55179
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 075A0206DB
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731036AbgKEOMR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 09:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730721AbgKEOMR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 09:12:17 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1A6C0613CF
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2020 06:12:17 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kafzr-0006HB-Tm; Thu, 05 Nov 2020 15:12:15 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 6/7] tcp: add raw tcp option match support
Date:   Thu,  5 Nov 2020 15:11:43 +0100
Message-Id: <20201105141144.31430-7-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201105141144.31430-1-fw@strlen.de>
References: <20201105141144.31430-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

tcp option @42,16,4 (@kind,offset,length).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/payload-expression.txt    |  6 ++++++
 src/exthdr.c                  | 13 +++++++++----
 src/parser_bison.y            |  5 +++++
 src/tcpopt.c                  |  2 ++
 tests/py/any/tcpopt.t         |  2 ++
 tests/py/any/tcpopt.t.payload |  7 +++++++
 6 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 3cfa7791edac..ffd1b671637a 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -591,6 +591,12 @@ TCP Timestamps |
 kind, length, tsval, tsecr
 |============================
 
+TCP option matching also supports raw expression syntax to access arbitrary options:
+[verse]
+*tcp option*
+[verse]
+*tcp option* *@*'number'*,*'offset'*,*'length'
+
 .IP Options
 [options="header"]
 |==================
diff --git a/src/exthdr.c b/src/exthdr.c
index 8995ad1775a0..5eb66529b5d7 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -52,10 +52,15 @@ static void exthdr_expr_print(const struct expr *expr, struct output_ctx *octx)
 		 */
 		unsigned int offset = expr->exthdr.offset / 64;
 
-		if (expr->exthdr.desc == NULL &&
-		    expr->exthdr.offset == 0 &&
-		    expr->exthdr.flags & NFT_EXTHDR_F_PRESENT) {
-			nft_print(octx, "tcp option %d", expr->exthdr.raw_type);
+		if (expr->exthdr.desc == NULL) {
+			if (expr->exthdr.offset == 0 &&
+			    expr->exthdr.flags & NFT_EXTHDR_F_PRESENT) {
+				nft_print(octx, "tcp option %d", expr->exthdr.raw_type);
+				return;
+			}
+
+			nft_print(octx, "tcp option @%u,%u,%u", expr->exthdr.raw_type,
+								expr->exthdr.offset, expr->len);
 			return;
 		}
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 393f66862810..079d8ebe121f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -5198,6 +5198,11 @@ tcp_hdr_expr		:	TCP	tcp_hdr_field
 				$$ = tcpopt_expr_alloc(&@$, $3, TCPOPT_COMMON_KIND);
 				$$->exthdr.flags = NFT_EXTHDR_F_PRESENT;
 			}
+			|	TCP	OPTION	AT tcp_hdr_option_type	COMMA	NUM	COMMA	NUM
+			{
+				$$ = tcpopt_expr_alloc(&@$, $4, 0);
+				tcpopt_init_raw($$, $4, $6, $8, 0);
+			}
 			;
 
 tcp_hdr_field		:	SPORT		{ $$ = TCPHDR_SPORT; }
diff --git a/src/tcpopt.c b/src/tcpopt.c
index 1cf97a563bc2..05b5ee6e3a0b 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -197,6 +197,8 @@ void tcpopt_init_raw(struct expr *expr, uint8_t type, unsigned int off,
 
 	if (flags & NFT_EXTHDR_F_PRESENT)
 		datatype_set(expr, &boolean_type);
+	else
+		datatype_set(expr, &integer_type);
 
 	if (type >= array_size(tcpopt_protocols))
 		return;
diff --git a/tests/py/any/tcpopt.t b/tests/py/any/tcpopt.t
index 7b17014b3003..e759ac6132d9 100644
--- a/tests/py/any/tcpopt.t
+++ b/tests/py/any/tcpopt.t
@@ -31,6 +31,7 @@ tcp option timestamp length 1;ok
 tcp option timestamp tsval 1;ok
 tcp option timestamp tsecr 1;ok
 tcp option 255 missing;ok
+tcp option @255,8,8 255;ok
 
 tcp option foobar;fail
 tcp option foo bar;fail
@@ -40,6 +41,7 @@ tcp option eol left 1;fail
 tcp option sack window;fail
 tcp option sack window 1;fail
 tcp option 256 exists;fail
+tcp option @255,8,8 256;fail
 
 tcp option window exists;ok
 tcp option window missing;ok
diff --git a/tests/py/any/tcpopt.t.payload b/tests/py/any/tcpopt.t.payload
index 34f8e26c4409..cddba613a088 100644
--- a/tests/py/any/tcpopt.t.payload
+++ b/tests/py/any/tcpopt.t.payload
@@ -523,6 +523,13 @@ inet
   [ exthdr load tcpopt 1b @ 255 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
+# tcp option @255,8,8 255
+inet
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 255 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x000000ff ]
+
 # tcp option window exists
 inet 
   [ meta load l4proto => reg 1 ]
-- 
2.26.2

