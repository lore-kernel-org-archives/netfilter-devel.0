Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A88C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA54A64ECD
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbhCKNYD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 08:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233536AbhCKNXg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 08:23:36 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25EBC061574
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 05:23:36 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lKLHr-0003gu-Bt; Thu, 11 Mar 2021 14:23:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 04/12] scanner: add fib scope
Date:   Thu, 11 Mar 2021 14:23:05 +0100
Message-Id: <20210311132313.24403-5-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311132313.24403-1-fw@strlen.de>
References: <20210311132313.24403-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

makes no sense as-is because all keywords need to stay
in the INITIAL scope.

This can be changed after all saddr/daddr users have been scoped.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   | 1 +
 src/parser_bison.y | 3 ++-
 src/scanner.l      | 3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 586a984875c4..e338713dad32 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -31,6 +31,7 @@ enum startcond_type {
 	PARSER_SC_CT,
 	PARSER_SC_IP,
 	PARSER_SC_IP6,
+	PARSER_SC_EXPR_FIB,
 	PARSER_SC_EXPR_HASH,
 	PARSER_SC_EXPR_IPSEC,
 	PARSER_SC_EXPR_NUMGEN,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9ef2602e22bd..74ab69dd8820 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -862,6 +862,7 @@ opt_newline		:	NEWLINE
 			;
 
 close_scope_ct		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CT); };
+close_scope_fib		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_FIB); };
 close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH); };
 close_scope_ip		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP); };
 close_scope_ip6		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP6); };
@@ -3873,7 +3874,7 @@ primary_expr		:	symbol_expr			{ $$ = $1; }
 			|	'('	basic_expr	')'	{ $$ = $2; }
 			;
 
-fib_expr		:	FIB	fib_tuple	fib_result
+fib_expr		:	FIB	fib_tuple	fib_result	close_scope_fib
 			{
 				if (($2 & (NFTA_FIB_F_SADDR|NFTA_FIB_F_DADDR)) == 0) {
 					erec_queue(error(&@2, "fib: need either saddr or daddr"), state->msgs);
diff --git a/src/scanner.l b/src/scanner.l
index 15d1beca601d..c78f34b625c2 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -199,6 +199,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_CT
 %s SCANSTATE_IP
 %s SCANSTATE_IP6
+%s SCANSTATE_EXPR_FIB
 %s SCANSTATE_EXPR_HASH
 %s SCANSTATE_EXPR_IPSEC
 %s SCANSTATE_EXPR_NUMGEN
@@ -588,7 +589,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "dup"			{ return DUP; }
 "fwd"			{ return FWD; }
 
-"fib"			{ return FIB; }
+"fib"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_FIB); return FIB; }
 
 "osf"			{ return OSF; }
 
-- 
2.26.2

