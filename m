From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 04/11] evaluate: don't adjust offset from resolve_protocol_conflict()
Date: Thu, 28 Jan 2016 22:24:53 +0100
Message-ID: <1454016300-29969-5-git-send-email-pablo@netfilter.org>
References: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43796 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbcA1VZS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jan 2016 16:25:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 620108E4CD
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 53859DA795
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 16CB4DA86E
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:14 +0100 (CET)
In-Reply-To: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is not itself a conflict, move this check out of this function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index a294070..5ef035b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -395,11 +395,6 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
 	struct stmt *nstmt = NULL;
 	int link, err;
 
-	if (desc == payload->payload.desc) {
-		payload->payload.offset += ctx->pctx.protocol[base].offset;
-		return 0;
-	}
-
 	err = supersede_dep(ctx, desc, payload);
 	if (err <= 0)
 		return err;
@@ -448,6 +443,14 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 			return -1;
 		list_add_tail(&nstmt->list, &ctx->stmt->list);
 	} else {
+		/* No conflict: Same payload protocol as context, adjust offset
+		 * if needed.
+		 */
+		if (desc == payload->payload.desc) {
+			payload->payload.offset +=
+				ctx->pctx.protocol[base].offset;
+			return 0;
+		}
 		/* If we already have context and this payload is on the same
 		 * base, try to resolve the protocol conflict.
 		 */
-- 
2.1.4

