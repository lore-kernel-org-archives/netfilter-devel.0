Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DEFFC48BE5
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 23:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67D49610A1
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 23:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbhFPXnz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Jun 2021 19:43:55 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47216 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234476AbhFPXny (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Jun 2021 19:43:54 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 26A6D6422B
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Jun 2021 01:40:28 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: memleak in binary operation transfer to RHS
Date:   Thu, 17 Jun 2021 01:41:44 +0200
Message-Id: <20210616234144.1277-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove reference counter on expression that results in the memleak of
the RHS constant expression.

Direct leak of 136 byte(s) in 1 object(s) allocated from:
    #0 0x7f4cd54af330 in __interceptor_malloc (/usr/lib/x86_64-linux-gnu/libasan.so.5+0xe9330)
    #1 0x7f4cd4d9e489 in xmalloc /home/pablo/devel/scm/git-netfilter/nftables/src/utils.c:36
    #2 0x7f4cd4d9e648 in xzalloc /home/pablo/devel/scm/git-netfilter/nftables/src/utils.c:75
    #3 0x7f4cd4caf8c6 in expr_alloc /home/pablo/devel/scm/git-netfilter/nftables/src/expression.c:45
    #4 0x7f4cd4cb36e9 in constant_expr_alloc /home/pablo/devel/scm/git-netfilter/nftables/src/expression.c:419
    #5 0x7f4cd4ca714c in integer_type_parse /home/pablo/devel/scm/git-netfilter/nftables/src/datatype.c:397
    #6 0x7f4cd4ca4bee in symbolic_constant_parse /home/pablo/devel/scm/git-netfilter/nftables/src/datatype.c:165
    #7 0x7f4cd4ca4572 in symbol_parse /home/pablo/devel/scm/git-netfilter/nftables/src/datatype.c:135
    #8 0x7f4cd4cc333f in expr_evaluate_symbol /home/pablo/devel/scm/git-netfilter/nftables/src/evaluate.c:251
[...]
Indirect leak of 8 byte(s) in 1 object(s) allocated from:
    #0 0x7f4cd54af330 in __interceptor_malloc (/usr/lib/x86_64-linux-gnu/libasan.so.5+0xe9330)
    #1 0x7f4cd4d9e489 in xmalloc /home/pablo/devel/scm/git-netfilter/nftables/src/utils.c:36
    #2 0x7f4cd46185c5 in __gmpz_init2 (/usr/lib/x86_64-linux-gnu/libgmp.so.10+0x1c5c5)

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 77fb24594735..35ef8a376170 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1770,8 +1770,6 @@ static int binop_transfer_one(struct eval_ctx *ctx,
 		return 0;
 	}
 
-	expr_get(*right);
-
 	switch (left->op) {
 	case OP_LSHIFT:
 		(*right) = binop_expr_alloc(&(*right)->location, OP_RSHIFT,
-- 
2.20.1

