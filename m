Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2825C48BE5
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 21:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76BB8613DE
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 21:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhFPVTt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Jun 2021 17:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbhFPVTs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Jun 2021 17:19:48 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53641C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Jun 2021 14:17:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ltcuq-0002UL-R9; Wed, 16 Jun 2021 23:17:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     jake.owen@superloop.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 5/8] parser: new queue flag input format
Date:   Wed, 16 Jun 2021 23:16:49 +0200
Message-Id: <20210616211652.11765-6-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210616211652.11765-1-fw@strlen.de>
References: <20210616211652.11765-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This changes output to first list the queue flags (with prepended
"flags" keyword), then the queue number.

This is to avoid parser problems when a flag is used after the
queue number, e.g.

"queue num 42 bypass".

While this works fine, this does not:

"queue num tcp dport bypass"

... because scanner state has been switched, "bypass" is parsed
as symbol expression.

Input parser is changed to recognize the stricter flag usage.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/statements.txt   |  4 ++--
 src/parser_bison.y   |  4 ++++
 src/statement.c      | 15 ++++++++++-----
 tests/py/any/queue.t |  7 +++----
 4 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 7c7240c82fab..602a5b2011a7 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -589,8 +589,8 @@ for details.
 
 [verse]
 ____
-*queue* [*num* 'queue_number'] [*bypass*]
-*queue* [*num* 'queue_number_from' - 'queue_number_to'] ['QUEUE_FLAGS']
+*queue* [*flags* 'QUEUE_FLAGS'] [*num* 'queue_number']
+*queue* [*flags* 'QUEUE_FLAGS'] [*num* 'queue_number_from' - 'queue_number_to']
 
 'QUEUE_FLAGS' := 'QUEUE_FLAG' [*,* 'QUEUE_FLAGS']
 'QUEUE_FLAG'  := *bypass* | *fanout*
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9e45a5da1716..cf90d5ce5672 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3739,6 +3739,10 @@ nf_nat_flag		:	RANDOM		{ $$ = NF_NAT_RANGE_PROTO_RANDOM; }
 			;
 
 queue_stmt		:	queue_stmt_compat	close_scope_queue
+			|	QUEUE	FLAGS	queue_stmt_flags QUEUENUM queue_stmt_expr_simple close_scope_queue
+			{
+				$$ = queue_stmt_alloc(&@$, $5, $3);
+			}
 			;
 
 queue_stmt_compat	:	queue_stmt_alloc
diff --git a/src/statement.c b/src/statement.c
index a713952c0af7..9eb49339555b 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -493,20 +493,25 @@ struct stmt *limit_stmt_alloc(const struct location *loc)
 
 static void queue_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	const char *delim = " ";
+	struct expr *e = stmt->queue.queue;
+	const char *delim = " flags ";
 
 	nft_print(octx, "queue");
-	if (stmt->queue.queue != NULL) {
-		nft_print(octx, " num ");
-		expr_print(stmt->queue.queue, octx);
-	}
+
 	if (stmt->queue.flags & NFT_QUEUE_FLAG_BYPASS) {
 		nft_print(octx, "%sbypass", delim);
 		delim = ",";
 	}
+
 	if (stmt->queue.flags & NFT_QUEUE_FLAG_CPU_FANOUT)
 		nft_print(octx, "%sfanout", delim);
 
+	if (e) {
+		nft_print(octx, " num ");
+		expr_print(stmt->queue.queue, octx);
+	} else {
+		nft_print(octx, " num 0");
+	}
 }
 
 static void queue_stmt_destroy(struct stmt *stmt)
diff --git a/tests/py/any/queue.t b/tests/py/any/queue.t
index 75c071dde44b..af844aa7c835 100644
--- a/tests/py/any/queue.t
+++ b/tests/py/any/queue.t
@@ -12,7 +12,6 @@ queue num 65535;ok
 queue num 65536;fail
 queue num 2-3;ok
 queue num 1-65535;ok
-- queue num {3, 4, 6};ok
-queue num 4-5 fanout bypass;ok;queue num 4-5 bypass,fanout
-queue num 4-5 fanout;ok
-queue num 4-5 bypass;ok
+queue num 4-5 fanout bypass;ok;queue flags bypass,fanout num 4-5
+queue num 4-5 fanout;ok;queue flags fanout num 4-5
+queue num 4-5 bypass;ok;queue flags bypass num 4-5
-- 
2.31.1

