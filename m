Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB7B9C04FF3
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 May 2021 20:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86CCA61406
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 May 2021 20:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbhEXUKT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 May 2021 16:10:19 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58908 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbhEXUKT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 May 2021 16:10:19 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id DB0DF641DE
        for <netfilter-devel@vger.kernel.org>; Mon, 24 May 2021 22:07:49 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables] evaluate: allow == and != in the new shortcut syntax to match for flags
Date:   Mon, 24 May 2021 22:08:44 +0200
Message-Id: <20210524200845.27732-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The flags / mask syntax only allows for ==, !=  and the implicit
operation (which is == in this case).

 # nft add rule x y tcp flags ! syn / syn,ack
 Error: either == or != is allowed
 add rule x y tcp flags ! syn / syn,ack
              ^^^^^^^^^^^^^^^^^^^^^^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 006b04affbd7..384e2fa786e0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2139,6 +2139,10 @@ static int expr_evaluate_flagcmp(struct eval_ctx *ctx, struct expr **exprp)
 {
 	struct expr *expr = *exprp, *binop, *rel;
 
+	if (expr->op != OP_EQ &&
+	    expr->op != OP_NEQ)
+		return expr_error(ctx->msgs, expr, "either == or != is allowed");
+
 	binop = binop_expr_alloc(&expr->location, OP_AND,
 				 expr_get(expr->flagcmp.expr),
 				 expr_get(expr->flagcmp.mask));
-- 
2.20.1

