Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ADC1C48BE6
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 21:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F04D613DE
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 21:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbhFPVTo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Jun 2021 17:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbhFPVTo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Jun 2021 17:19:44 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CE0C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Jun 2021 14:17:38 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ltcum-0002U5-N4; Wed, 16 Jun 2021 23:17:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     jake.owen@superloop.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/8] parser: add queue_stmt_compat
Date:   Wed, 16 Jun 2021 23:16:48 +0200
Message-Id: <20210616211652.11765-5-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210616211652.11765-1-fw@strlen.de>
References: <20210616211652.11765-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Rename existing rules to _compat to make sure old rules using 'queue'
statement will work.

Next patch adds distinct input format where flags are explicitly
provided:

 queue flags name,<nextflag> num 1

Without this, extension of queue expression to handle arbitrary
expression instead of queue number or range results in parser errors.

Example:
   queue num jhash ip saddr mod 4 and 1 bypass

will fail because scanner is still in 'ip' state, not 'queue', when
"bypass" is read.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 96676aed2e38..9e45a5da1716 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -703,10 +703,10 @@ int nft_lex(void *, void *, void *);
 %destructor { stmt_free($$); }	chain_stmt
 %type <val>			chain_stmt_type
 
-%type <stmt>			queue_stmt queue_stmt_alloc
-%destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
-%type <expr>			queue_stmt_expr
-%destructor { expr_free($$); }	queue_stmt_expr
+%type <stmt>			queue_stmt queue_stmt_alloc	queue_stmt_compat
+%destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc	queue_stmt_compat
+%type <expr>			queue_stmt_expr_simple
+%destructor { expr_free($$); }	queue_stmt_expr_simple
 %type <val>			queue_stmt_flags queue_stmt_flag
 %type <stmt>			dup_stmt
 %destructor { stmt_free($$); }	dup_stmt
@@ -3738,8 +3738,11 @@ nf_nat_flag		:	RANDOM		{ $$ = NF_NAT_RANGE_PROTO_RANDOM; }
 			|	PERSISTENT 	{ $$ = NF_NAT_RANGE_PERSISTENT; }
 			;
 
-queue_stmt		:	queue_stmt_alloc	close_scope_queue
-			|	queue_stmt_alloc	queue_stmt_args	close_scope_queue
+queue_stmt		:	queue_stmt_compat	close_scope_queue
+			;
+
+queue_stmt_compat	:	queue_stmt_alloc
+			|	queue_stmt_alloc	queue_stmt_args
 			;
 
 queue_stmt_alloc	:	QUEUE
@@ -3755,7 +3758,7 @@ queue_stmt_args		:	queue_stmt_arg
 			|	queue_stmt_args	queue_stmt_arg
 			;
 
-queue_stmt_arg		:	QUEUENUM	queue_stmt_expr
+queue_stmt_arg		:	QUEUENUM	queue_stmt_expr_simple
 			{
 				$<stmt>0->queue.queue = $2;
 				$<stmt>0->queue.queue->location = @$;
@@ -3766,7 +3769,7 @@ queue_stmt_arg		:	QUEUENUM	queue_stmt_expr
 			}
 			;
 
-queue_stmt_expr		:	integer_expr
+queue_stmt_expr_simple	:	integer_expr
 			|	range_rhs_expr
 			;
 
-- 
2.31.1

