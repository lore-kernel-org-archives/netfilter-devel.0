Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818D0C433DB
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 17:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 490D8650E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 17:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhCHRTh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 12:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbhCHRTG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 12:19:06 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BC3C06174A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Mar 2021 09:19:06 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lJJX7-0000Ly-55; Mon, 08 Mar 2021 18:19:05 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 5/6] scanner: rt: move to own scope
Date:   Mon,  8 Mar 2021 18:18:36 +0100
Message-Id: <20210308171837.8542-6-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210308171837.8542-1-fw@strlen.de>
References: <20210308171837.8542-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

classid and nexthop can be moved out of INIT scope.
Rest are still needed because tehy are used by other expressions as
well.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   | 1 +
 src/parser_bison.y | 7 ++++---
 src/scanner.l      | 9 ++++++---
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 001698db259b..2cdccaf5fb3d 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -32,6 +32,7 @@ enum startcond_type {
 	PARSER_SC_EXPR_IPSEC,
 	PARSER_SC_EXPR_NUMGEN,
 	PARSER_SC_EXPR_QUEUE,
+	PARSER_SC_EXPR_RT,
 };
 
 struct mnl_socket;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 83d78a23b2ac..0f4d51ad30bc 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -865,6 +865,7 @@ close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH);
 close_scope_ipsec	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_IPSEC); };
 close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
 close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
+close_scope_rt		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_RT); };
 
 common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
 			{
@@ -4893,11 +4894,11 @@ nf_key_proto		:	IP		{ $$ = NFPROTO_IPV4; }
 			|	IP6		{ $$ = NFPROTO_IPV6; }
 			;
 
-rt_expr			:	RT	rt_key
+rt_expr			:	RT	rt_key	close_scope_rt
 			{
 				$$ = rt_expr_alloc(&@$, $2, true);
 			}
-			|	RT	nf_key_proto	rt_key
+			|	RT	nf_key_proto	rt_key	close_scope_rt
 			{
 				enum nft_rt_keys rtk = $3;
 
@@ -5391,7 +5392,7 @@ hbh_hdr_field		:	NEXTHDR		{ $$ = HBHHDR_NEXTHDR; }
 			|	HDRLENGTH	{ $$ = HBHHDR_HDRLENGTH; }
 			;
 
-rt_hdr_expr		:	RT	rt_hdr_field
+rt_hdr_expr		:	RT	rt_hdr_field	close_scope_rt
 			{
 				$$ = exthdr_expr_alloc(&@$, &exthdr_rt, $2);
 			}
diff --git a/src/scanner.l b/src/scanner.l
index cf3d7d52b4c5..faf180ca4701 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -200,6 +200,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_EXPR_IPSEC
 %s SCANSTATE_EXPR_NUMGEN
 %s SCANSTATE_EXPR_QUEUE
+%s SCANSTATE_EXPR_RT
 
 %%
 
@@ -494,7 +495,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "sctp"			{ return SCTP; }
 "vtag"			{ return VTAG; }
 
-"rt"			{ return RT; }
+"rt"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT; }
 "rt0"			{ return RT0; }
 "rt2"			{ return RT2; }
 "srh"			{ return RT4; }
@@ -536,8 +537,10 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "oifgroup"		{ return OIFGROUP; }
 "cgroup"		{ return CGROUP; }
 
-"classid"		{ return CLASSID; }
-"nexthop"		{ return NEXTHOP; }
+<SCANSTATE_EXPR_RT>{
+	"classid"		{ return CLASSID; }
+	"nexthop"		{ return NEXTHOP; }
+}
 
 "ct"			{ return CT; }
 "l3proto"		{ return L3PROTOCOL; }
-- 
2.26.2

