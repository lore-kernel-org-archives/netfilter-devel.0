Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987F0C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 15:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FCA761B5F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 15:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhG0Ph5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 11:37:57 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35402 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhG0Phu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 11:37:50 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id ABFF0642A0;
        Tue, 27 Jul 2021 17:37:19 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     tom.ty89@gmail.com
Subject: [PATCH nft 3/3] evaluate: disallow negation with binary operation
Date:   Tue, 27 Jul 2021 17:37:41 +0200
Message-Id: <20210727153741.14406-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210727153741.14406-1-pablo@netfilter.org>
References: <20210727153741.14406-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The negation was introduced to provide a simple shortcut. Extend
e6c32b2fa0b8 ("src: add negation match on singleton bitmask value") to
disallow negation with binary operations too.

 # nft add rule meh tcp_flags 'tcp flags & (fin | syn | rst | ack) ! syn'
 Error: cannot combine negation with binary expression
 add rule meh tcp_flags tcp flags & (fin | syn | rst | ack) ! syn
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^   ~~~

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c      | 16 ++++++++++------
 tests/py/inet/tcp.t |  1 +
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 4609576b2a61..8b5f51cee01c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2016,12 +2016,16 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		/* fall through */
 	case OP_NEQ:
 	case OP_NEG:
-		if (rel->op == OP_NEG &&
-		    (right->etype != EXPR_VALUE ||
-		     right->dtype->basetype == NULL ||
-		     right->dtype->basetype->type != TYPE_BITMASK))
-			return expr_binary_error(ctx->msgs, left, right,
-						 "negation can only be used with singleton bitmask values");
+		if (rel->op == OP_NEG) {
+			if (left->etype == EXPR_BINOP)
+				return expr_binary_error(ctx->msgs, left, right,
+							 "cannot combine negation with binary expression");
+			if (right->etype != EXPR_VALUE ||
+			    right->dtype->basetype == NULL ||
+			    right->dtype->basetype->type != TYPE_BITMASK)
+				return expr_binary_error(ctx->msgs, left, right,
+							 "negation can only be used with singleton bitmask values");
+		}
 
 		switch (right->etype) {
 		case EXPR_RANGE:
diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index 983564ec5b75..13b84215bd86 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -75,6 +75,7 @@ tcp flags & (fin | syn | rst | psh | ack | urg | ecn | cwr) == fin | syn | rst |
 tcp flags { syn, syn | ack };ok
 tcp flags & (fin | syn | rst | psh | ack | urg) == { fin, ack, psh | ack, fin | psh | ack };ok
 tcp flags ! fin,rst;ok
+tcp flags & (fin | syn | rst | ack) ! syn;fail
 
 tcp window 22222;ok
 tcp window 22;ok
-- 
2.20.1

