Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B80E1C1550E
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 17:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E09F6524F
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 17:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhCHRTI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 12:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhCHRTC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 12:19:02 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7E7C06174A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Mar 2021 09:19:02 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lJJX2-0000Lp-V2; Mon, 08 Mar 2021 18:19:01 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/6] scanner: ipsec: move to own scope
Date:   Mon,  8 Mar 2021 18:18:35 +0100
Message-Id: <20210308171837.8542-5-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210308171837.8542-1-fw@strlen.de>
References: <20210308171837.8542-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

... and hide the ipsec specific tokens from the INITITAL scope.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   |  1 +
 src/parser_bison.y |  9 +++++----
 src/scanner.l      | 13 ++++++++-----
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index c3a85a4cf4c2..001698db259b 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -29,6 +29,7 @@ struct parser_state {
 enum startcond_type {
 	PARSER_SC_BEGIN,
 	PARSER_SC_EXPR_HASH,
+	PARSER_SC_EXPR_IPSEC,
 	PARSER_SC_EXPR_NUMGEN,
 	PARSER_SC_EXPR_QUEUE,
 };
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 423dddfc2c6d..83d78a23b2ac 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -862,6 +862,7 @@ opt_newline		:	NEWLINE
 			;
 
 close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH); };
+close_scope_ipsec	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_IPSEC); };
 close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
 close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
 
@@ -4738,7 +4739,7 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
 			|       IIFGROUP	{ $$ = NFT_META_IIFGROUP; }
 			|       OIFGROUP	{ $$ = NFT_META_OIFGROUP; }
 			|       CGROUP		{ $$ = NFT_META_CGROUP; }
-			|       IPSEC		{ $$ = NFT_META_SECPATH; }
+			|       IPSEC	close_scope_ipsec { $$ = NFT_META_SECPATH; }
 			|       TIME		{ $$ = NFT_META_TIME_NS; }
 			|       DAY		{ $$ = NFT_META_TIME_DAY; }
 			|       HOUR		{ $$ = NFT_META_TIME_HOUR; }
@@ -4837,7 +4838,7 @@ xfrm_state_proto_key	:	DADDR		{ $$ = NFT_XFRM_KEY_DADDR_IP4; }
 			|	SADDR		{ $$ = NFT_XFRM_KEY_SADDR_IP4; }
 			;
 
-xfrm_expr		:	IPSEC	xfrm_dir	xfrm_spnum	xfrm_state_key
+xfrm_expr		:	IPSEC	xfrm_dir	xfrm_spnum	xfrm_state_key	close_scope_ipsec
 			{
 				if ($3 > 255) {
 					erec_queue(error(&@3, "value too large"), state->msgs);
@@ -4845,7 +4846,7 @@ xfrm_expr		:	IPSEC	xfrm_dir	xfrm_spnum	xfrm_state_key
 				}
 				$$ = xfrm_expr_alloc(&@$, $2, $3, $4);
 			}
-			|	IPSEC	xfrm_dir	xfrm_spnum	nf_key_proto	xfrm_state_proto_key
+			|	IPSEC	xfrm_dir	xfrm_spnum	nf_key_proto	xfrm_state_proto_key	close_scope_ipsec
 			{
 				enum nft_xfrm_keys xfrmk = $5;
 
@@ -4919,7 +4920,7 @@ rt_expr			:	RT	rt_key
 rt_key			:	CLASSID		{ $$ = NFT_RT_CLASSID; }
 			|	NEXTHOP		{ $$ = NFT_RT_NEXTHOP4; }
 			|	MTU		{ $$ = NFT_RT_TCPMSS; }
-			|	IPSEC		{ $$ = NFT_RT_XFRM; }
+			|	IPSEC	close_scope_ipsec { $$ = NFT_RT_XFRM; }
 			;
 
 ct_expr			: 	CT	ct_key
diff --git a/src/scanner.l b/src/scanner.l
index 893364b7b9e7..cf3d7d52b4c5 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -197,6 +197,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %option warn
 %option stack
 %s SCANSTATE_EXPR_HASH
+%s SCANSTATE_EXPR_IPSEC
 %s SCANSTATE_EXPR_NUMGEN
 %s SCANSTATE_EXPR_QUEUE
 
@@ -594,12 +595,14 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "exthdr"		{ return EXTHDR; }
 
-"ipsec"			{ return IPSEC; }
-"reqid"			{ return REQID; }
-"spnum"			{ return SPNUM; }
+"ipsec"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_IPSEC); return IPSEC; }
+<SCANSTATE_EXPR_IPSEC>{
+	"reqid"			{ return REQID; }
+	"spnum"			{ return SPNUM; }
 
-"in"			{ return IN; }
-"out"			{ return OUT; }
+	"in"			{ return IN; }
+	"out"			{ return OUT; }
+}
 
 "secmark"		{ return SECMARK; }
 "secmarks"		{ return SECMARKS; }
-- 
2.26.2

