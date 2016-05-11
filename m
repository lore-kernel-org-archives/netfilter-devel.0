From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 02/12] evaluate: transfer right shifts to range side
Date: Wed, 11 May 2016 23:05:06 +0200
Message-ID: <1463000716-11885-2-git-send-email-pablo@netfilter.org>
References: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40449 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbcEKVF1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2016 17:05:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CCCB51BD5B4
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B9FDDFF6F8
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3EA2CFAB57
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:22 +0200 (CEST)
In-Reply-To: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This provides a generic way to transfer shifts from the left hand side
to the right hand range side of a relational expression when performing
transformations from the evaluation step.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index f862cd0..60bbce1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1146,6 +1146,18 @@ static int binop_transfer(struct eval_ctx *ctx, struct expr **expr)
 		if (binop_transfer_one(ctx, left, &(*expr)->right) < 0)
 			return -1;
 		break;
+	case EXPR_RANGE:
+		err = binop_can_transfer(ctx, left, (*expr)->right->left);
+		if (err <= 0)
+			return err;
+		err = binop_can_transfer(ctx, left, (*expr)->right->right);
+		if (err <= 0)
+			return err;
+		if (binop_transfer_one(ctx, left, &(*expr)->right->left) < 0)
+			return -1;
+		if (binop_transfer_one(ctx, left, &(*expr)->right->right) < 0)
+			return -1;
+		break;
 	case EXPR_SET:
 		list_for_each_entry(i, &(*expr)->right->expressions, list) {
 			err = binop_can_transfer(ctx, left, i);
-- 
2.1.4

