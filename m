Return-Path: <SRS0=H+Om=WU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 160AFC3A59E
	for <netfilter-devel@archiver.kernel.org>; Sat, 24 Aug 2019 14:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E59CD2082F
	for <netfilter-devel@archiver.kernel.org>; Sat, 24 Aug 2019 14:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbfHXOFb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 24 Aug 2019 10:05:31 -0400
Received: from vxsys-smtpclusterma-03.srv.cat ([46.16.60.199]:33839 "EHLO
        vxsys-smtpclusterma-03.srv.cat" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727546AbfHXOFb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 24 Aug 2019 10:05:31 -0400
Received: from localhost.localdomain (static-79-171-230-77.ipcom.comunitel.net [77.230.171.79])
        by vxsys-smtpclusterma-03.srv.cat (Postfix) with ESMTPA id 6FCCE2422D
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Aug 2019 16:05:27 +0200 (CEST)
From:   Ander Juaristi <a@juaristi.eus>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft v9 1/2] evaluate: New internal helper __expr_evaluate_range
Date:   Sat, 24 Aug 2019 16:04:59 +0200
Message-Id: <20190824140500.9077-1-a@juaristi.eus>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is used by the followup patch to evaluate a range without emitting
an error when the left value is larger than the right one.

This is done to handle time-matching such as
23:00-01:00 -- expr_evaluate_range() will reject this, but
we want to be able to evaluate and then handle this as a request
to match from 23:00 to 1am.

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

