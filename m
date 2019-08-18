Return-Path: <SRS0=n9X8=WO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA660C3A589
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Aug 2019 18:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D9772146E
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Aug 2019 18:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfHRSU1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Aug 2019 14:20:27 -0400
Received: from vxsys-smtpclusterma-01.srv.cat ([46.16.61.57]:39853 "EHLO
        vxsys-smtpclusterma-01.srv.cat" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbfHRSU1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Aug 2019 14:20:27 -0400
Received: from localhost.localdomain (static-79-171-230-77.ipcom.comunitel.net [77.230.171.79])
        by vxsys-smtpclusterma-01.srv.cat (Postfix) with ESMTPA id A281E2426B
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Aug 2019 20:20:21 +0200 (CEST)
From:   Ander Juaristi <a@juaristi.eus>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft v7 1/2] evaluate: New internal helper __expr_evaluate_range
Date:   Sun, 18 Aug 2019 20:20:12 +0200
Message-Id: <20190818182013.6765-1-a@juaristi.eus>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Ander Juaristi <a@juaristi.eus>
---
 src/evaluate.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 831eb7c..a707f5e 100755
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -941,16 +941,28 @@ static int expr_evaluate_range_expr(struct eval_ctx *ctx,
 	return 0;
 }
 
-static int expr_evaluate_range(struct eval_ctx *ctx, struct expr **expr)
+static int __expr_evaluate_range(struct eval_ctx *ctx, struct expr **expr)
 {
-	struct expr *range = *expr, *left, *right;
+	struct expr *range = *expr;
 
 	if (expr_evaluate_range_expr(ctx, range, &range->left) < 0)
 		return -1;
-	left = range->left;
-
 	if (expr_evaluate_range_expr(ctx, range, &range->right) < 0)
 		return -1;
+
+	return 0;
+}
+
+static int expr_evaluate_range(struct eval_ctx *ctx, struct expr **expr)
+{
+	struct expr *range = *expr, *left, *right;
+	int rc;
+
+	rc = __expr_evaluate_range(ctx, expr);
+	if (rc)
+		return rc;
+
+	left = range->left;
 	right = range->right;
 
 	if (mpz_cmp(left->value, right->value) >= 0)
-- 
2.17.1

