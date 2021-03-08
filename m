Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F25C432C3
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 17:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AAF665239
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 17:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhCHRTH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 12:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbhCHRS6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 12:18:58 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC32C06174A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Mar 2021 09:18:58 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lJJWy-0000Li-No; Mon, 08 Mar 2021 18:18:56 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/6] scanner: queue: move to own scope
Date:   Mon,  8 Mar 2021 18:18:34 +0100
Message-Id: <20210308171837.8542-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210308171837.8542-1-fw@strlen.de>
References: <20210308171837.8542-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

allows to remove 3 queue specific keywords from INITIAL scope.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   |  1 +
 src/parser_bison.y |  5 +++--
 src/scanner.l      | 12 +++++++-----
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index b2ebd7aa226c..c3a85a4cf4c2 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -30,6 +30,7 @@ enum startcond_type {
 	PARSER_SC_BEGIN,
 	PARSER_SC_EXPR_HASH,
 	PARSER_SC_EXPR_NUMGEN,
+	PARSER_SC_EXPR_QUEUE,
 };
 
 struct mnl_socket;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 1ac4dbe43c84..423dddfc2c6d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -863,6 +863,7 @@ opt_newline		:	NEWLINE
 
 close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH); };
 close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
+close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
 
 common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
 			{
@@ -3635,8 +3636,8 @@ nf_nat_flag		:	RANDOM		{ $$ = NF_NAT_RANGE_PROTO_RANDOM; }
 			|	PERSISTENT 	{ $$ = NF_NAT_RANGE_PERSISTENT; }
 			;
 
-queue_stmt		:	queue_stmt_alloc
-			|	queue_stmt_alloc	queue_stmt_args
+queue_stmt		:	queue_stmt_alloc	close_scope_queue
+			|	queue_stmt_alloc	queue_stmt_args	close_scope_queue
 			;
 
 queue_stmt_alloc	:	QUEUE
diff --git a/src/scanner.l b/src/scanner.l
index 94225c296a3b..893364b7b9e7 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -198,6 +198,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %option stack
 %s SCANSTATE_EXPR_HASH
 %s SCANSTATE_EXPR_NUMGEN
+%s SCANSTATE_EXPR_QUEUE
 
 %%
 
@@ -346,11 +347,12 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "queue-threshold"	{ return QUEUE_THRESHOLD; }
 "level"			{ return LEVEL; }
 
-"queue"			{ return QUEUE;}
-"num"			{ return QUEUENUM;}
-"bypass"		{ return BYPASS;}
-"fanout"		{ return FANOUT;}
-
+"queue"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_QUEUE); return QUEUE;}
+<SCANSTATE_EXPR_QUEUE>{
+	"num"		{ return QUEUENUM;}
+	"bypass"	{ return BYPASS;}
+	"fanout"	{ return FANOUT;}
+}
 "limit"			{ return LIMIT; }
 "rate"			{ return RATE; }
 "burst"			{ return BURST; }
-- 
2.26.2

