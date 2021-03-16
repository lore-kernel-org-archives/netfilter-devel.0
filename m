Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 009E6C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Mar 2021 23:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE26C64EFD
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Mar 2021 23:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhCPXlQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Mar 2021 19:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhCPXlA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Mar 2021 19:41:00 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34266C06174A
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Mar 2021 16:41:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lMJJ3-000586-VG; Wed, 17 Mar 2021 00:40:58 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/6] scanner: log: move to own scope
Date:   Wed, 17 Mar 2021 00:40:36 +0100
Message-Id: <20210316234039.15677-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210316234039.15677-1-fw@strlen.de>
References: <20210316234039.15677-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

GROUP and PREFIX are used by igmp and nat, so they can't be moved out of
INITIAL scope yet.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   |  2 ++
 src/parser_bison.y |  4 +++-
 src/scanner.l      | 12 ++++++++----
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 59eff16eac20..d890ab223c52 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -47,6 +47,8 @@ enum startcond_type {
 	PARSER_SC_EXPR_QUEUE,
 	PARSER_SC_EXPR_RT,
 	PARSER_SC_EXPR_SOCKET,
+
+	PARSER_SC_STMT_LOG,
 };
 
 struct mnl_socket;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 805a38ab22ed..98fe4431c4f4 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -879,6 +879,8 @@ close_scope_rt		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_RT); };
 close_scope_secmark	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_SECMARK); };
 close_scope_socket	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_SOCKET); }
 
+close_scope_log		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_LOG); }
+
 common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
 			{
 				if (scanner_include_file(nft, scanner, $2, &@$) < 0) {
@@ -2695,7 +2697,7 @@ stmt			:	verdict_stmt
 			|	payload_stmt
 			|	stateful_stmt
 			|	meta_stmt
-			|	log_stmt
+			|	log_stmt	close_scope_log
 			|	reject_stmt
 			|	nat_stmt
 			|	tproxy_stmt
diff --git a/src/scanner.l b/src/scanner.l
index 783436504326..0082b3eeca29 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -214,6 +214,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_EXPR_RT
 %s SCANSTATE_EXPR_SOCKET
 
+%s SCANSTATE_STMT_LOG
+
 %%
 
 "=="			{ return EQ; }
@@ -354,12 +356,14 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "limits"		{ return LIMITS; }
 "synproxys"		{ return SYNPROXYS; }
 
-"log"			{ return LOG; }
+"log"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_LOG); return LOG; }
 "prefix"		{ return PREFIX; }
 "group"			{ return GROUP; }
-"snaplen"		{ return SNAPLEN; }
-"queue-threshold"	{ return QUEUE_THRESHOLD; }
-"level"			{ return LEVEL; }
+<SCANSTATE_STMT_LOG>{
+	"snaplen"		{ return SNAPLEN; }
+	"queue-threshold"	{ return QUEUE_THRESHOLD; }
+	"level"			{ return LEVEL; }
+}
 
 "queue"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_QUEUE); return QUEUE;}
 <SCANSTATE_EXPR_QUEUE>{
-- 
2.26.2

