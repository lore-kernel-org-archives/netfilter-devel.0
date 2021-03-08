Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE1AC433E6
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 17:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFCA365215
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 17:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhCHRTG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 12:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbhCHRSt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 12:18:49 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BBDC06174A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Mar 2021 09:18:49 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lJJWq-0000LS-9v; Mon, 08 Mar 2021 18:18:48 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/6] scanner: remove unused tokens
Date:   Mon,  8 Mar 2021 18:18:32 +0100
Message-Id: <20210308171837.8542-2-fw@strlen.de>
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
 src/parser_bison.y | 6 ------
 src/scanner.l      | 6 ------
 2 files changed, 12 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index bfb181747ca1..abfcccc4a021 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -511,9 +511,6 @@ int nft_lex(void *, void *, void *);
 %token SECMARK			"secmark"
 %token SECMARKS			"secmarks"
 
-%token NANOSECOND		"nanosecond"
-%token MICROSECOND		"microsecond"
-%token MILLISECOND		"millisecond"
 %token SECOND			"second"
 %token MINUTE			"minute"
 %token HOUR			"hour"
@@ -565,11 +562,8 @@ int nft_lex(void *, void *, void *);
 %token EXTHDR			"exthdr"
 
 %token IPSEC		"ipsec"
-%token MODE			"mode"
 %token REQID		"reqid"
 %token SPNUM		"spnum"
-%token TRANSPORT	"transport"
-%token TUNNEL		"tunnel"
 
 %token IN			"in"
 %token OUT			"out"
diff --git a/src/scanner.l b/src/scanner.l
index 8bde1fbe912d..1da3b5e0628c 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -355,9 +355,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "quota"			{ return QUOTA; }
 "used"			{ return USED; }
 
-"nanosecond"		{ return NANOSECOND; }
-"microsecond"		{ return MICROSECOND; }
-"millisecond"		{ return MILLISECOND; }
 "second"		{ return SECOND; }
 "minute"		{ return MINUTE; }
 "hour"			{ return HOUR; }
@@ -585,11 +582,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "exthdr"		{ return EXTHDR; }
 
 "ipsec"			{ return IPSEC; }
-"mode"			{ return MODE; }
 "reqid"			{ return REQID; }
 "spnum"			{ return SPNUM; }
-"transport"		{ return TRANSPORT; }
-"tunnel"		{ return TUNNEL; }
 
 "in"			{ return IN; }
 "out"			{ return OUT; }
-- 
2.26.2

