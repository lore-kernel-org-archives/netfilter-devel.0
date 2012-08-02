From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH 2/4] evaluate: Remove useless variable in expr_evaluate_bitwise()
Date: Thu,  2 Aug 2012 13:31:33 +0300
Message-ID: <1343903495-14486-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1343903495-14486-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51950 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab2HBKbl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:31:41 -0400
In-Reply-To: <1343903495-14486-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 src/evaluate.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 507aab0..a371c24 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -493,11 +493,10 @@ static int expr_evaluate_shift(struct eval_ctx *ctx, struct expr **expr)
 
 static int expr_evaluate_bitwise(struct eval_ctx *ctx, struct expr **expr)
 {
-	struct expr *op = *expr, *left = op->left, *right = op->right;
+	struct expr *op = *expr, *left = op->left;
 
 	if (byteorder_conversion(ctx, &op->right, left->byteorder) < 0)
 		return -1;
-	right = op->right;
 
 	op->dtype     = left->dtype;
 	op->byteorder = left->byteorder;
-- 
1.7.8.6

