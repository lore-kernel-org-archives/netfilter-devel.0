From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 5/7] evaluate: transfer right shifts to range side
Date: Sat,  5 Dec 2015 20:04:24 +0100
Message-ID: <1449342266-2756-5-git-send-email-pablo@netfilter.org>
References: <1449342266-2756-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51089 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbbLETEl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Dec 2015 14:04:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 396B2DA879
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2BF91DA808
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5361ADA801
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:38 +0100 (CET)
In-Reply-To: <1449342266-2756-1-git-send-email-pablo@netfilter.org>
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
index d62870a..0fcdb73 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1073,6 +1073,18 @@ static int binop_transfer(struct eval_ctx *ctx, struct expr **expr)
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

