Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF77EC48BE5
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 21:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D546D613DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 21:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbhFPVTg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Jun 2021 17:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbhFPVTg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Jun 2021 17:19:36 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2065C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Jun 2021 14:17:29 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ltcue-0002TR-Bt; Wed, 16 Jun 2021 23:17:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     jake.owen@superloop.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/8] parser: restrict queue num expressiveness
Date:   Wed, 16 Jun 2021 23:16:46 +0200
Message-Id: <20210616211652.11765-3-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210616211652.11765-1-fw@strlen.de>
References: <20210616211652.11765-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Else we run into trouble once we allow
queue num symhash mod 4 and 1

and so on.  Example problem:

queue num jhash ip saddr mod 4 and 1 bypass

This will fail to parse because the scanner is in the wrong state
(ip, not queue), so 'bypass' is parsed as a string.

Currently, while nft will eat the above just fine (minus 'bypass'),
nft rejects this from the evaluation phase with
   Error: queue number is not constant

So seems we are lucky and can restrict the supported expressions
to integer and range.

Furthermore, the line looks wrong because this statement:

   queue num jhash ip saddr mod 4 and 1 bypass

doesn't specifiy a number, "queue num 4" does, or "queue num 1-2" do.

For arbitrary expr support it seems sensible to enforce stricter
ordering to avoid any problems with the flags, for example:

queue bypass,futurekeyword to jhash ip saddr mod 42

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index bd2232a3de27..2ab47ed55166 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -705,6 +705,8 @@ int nft_lex(void *, void *, void *);
 
 %type <stmt>			queue_stmt queue_stmt_alloc
 %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
+%type <expr>			queue_stmt_expr
+%destructor { expr_free($$); }	queue_stmt_expr
 %type <val>			queue_stmt_flags queue_stmt_flag
 %type <stmt>			dup_stmt
 %destructor { stmt_free($$); }	dup_stmt
@@ -3753,7 +3755,7 @@ queue_stmt_args		:	queue_stmt_arg
 			|	queue_stmt_args	queue_stmt_arg
 			;
 
-queue_stmt_arg		:	QUEUENUM	stmt_expr
+queue_stmt_arg		:	QUEUENUM	queue_stmt_expr
 			{
 				$<stmt>0->queue.queue = $2;
 				$<stmt>0->queue.queue->location = @$;
@@ -3764,6 +3766,10 @@ queue_stmt_arg		:	QUEUENUM	stmt_expr
 			}
 			;
 
+queue_stmt_expr		:	integer_expr
+			|	range_rhs_expr
+			;
+
 queue_stmt_flags	:	queue_stmt_flag
 			|	queue_stmt_flags	COMMA	queue_stmt_flag
 			{
-- 
2.31.1

