Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D5BC433E6
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 17:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EE4B6522D
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 17:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhCHRTi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 12:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbhCHRTL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 12:19:11 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3503C06174A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Mar 2021 09:19:10 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lJJXB-0000MD-BX; Mon, 08 Mar 2021 18:19:09 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 6/6] scanner: socket: move to own scope
Date:   Mon,  8 Mar 2021 18:18:37 +0100
Message-Id: <20210308171837.8542-7-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210308171837.8542-1-fw@strlen.de>
References: <20210308171837.8542-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   |  1 +
 src/parser_bison.y |  3 ++-
 src/scanner.l      | 10 ++++++----
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 2cdccaf5fb3d..fd5006d35c0d 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -33,6 +33,7 @@ enum startcond_type {
 	PARSER_SC_EXPR_NUMGEN,
 	PARSER_SC_EXPR_QUEUE,
 	PARSER_SC_EXPR_RT,
+	PARSER_SC_EXPR_SOCKET,
 };
 
 struct mnl_socket;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 0f4d51ad30bc..2a8ac215a284 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -866,6 +866,7 @@ close_scope_ipsec	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_IPSEC)
 close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
 close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
 close_scope_rt		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_RT); };
+close_scope_socket	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_SOCKET); }
 
 common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
 			{
@@ -4798,7 +4799,7 @@ meta_stmt		:	META	meta_key	SET	stmt_expr
 			}
 			;
 
-socket_expr		:	SOCKET	socket_key
+socket_expr		:	SOCKET	socket_key	close_scope_socket
 			{
 				$$ = socket_expr_alloc(&@$, $2);
 			}
diff --git a/src/scanner.l b/src/scanner.l
index faf180ca4701..6a909e928bf4 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -201,6 +201,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_EXPR_NUMGEN
 %s SCANSTATE_EXPR_QUEUE
 %s SCANSTATE_EXPR_RT
+%s SCANSTATE_EXPR_SOCKET
 
 %%
 
@@ -274,10 +275,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "ruleset"		{ return RULESET; }
 "trace"			{ return TRACE; }
 
-"socket"		{ return SOCKET; }
-"transparent"		{ return TRANSPARENT; }
-"wildcard"		{ return WILDCARD; }
-
+"socket"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_SOCKET); return SOCKET; }
+<SCANSTATE_EXPR_SOCKET>{
+	"transparent"		{ return TRANSPARENT; }
+	"wildcard"		{ return WILDCARD; }
+}
 "tproxy"		{ return TPROXY; }
 
 "accept"		{ return ACCEPT; }
-- 
2.26.2

