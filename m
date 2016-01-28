From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 03/11] evaluate: check if we have to resolve a conflict in first place
Date: Thu, 28 Jan 2016 22:24:52 +0100
Message-ID: <1454016300-29969-4-git-send-email-pablo@netfilter.org>
References: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43795 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbcA1VZS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jan 2016 16:25:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1AF4B347
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F26AADA804
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2BCFEDA804
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:13 +0100 (CET)
In-Reply-To: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So we enter resolve_protocol_conflict() only when we really have a
conflict that we want to try to resolve.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 93f408d..a294070 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -387,23 +387,19 @@ static int supersede_dep(struct eval_ctx *ctx, const struct proto_desc *have,
 	return 0;
 }
 
-static int resolve_protocol_conflict(struct eval_ctx *ctx, struct expr *payload)
+static int resolve_protocol_conflict(struct eval_ctx *ctx,
+				     const struct proto_desc *desc,
+				     struct expr *payload)
 {
-	const struct hook_proto_desc *h = &hook_proto_desc[ctx->pctx.family];
 	enum proto_bases base = payload->payload.base;
-	const struct proto_desc *desc;
 	struct stmt *nstmt = NULL;
 	int link, err;
 
-	desc = ctx->pctx.protocol[base].desc;
 	if (desc == payload->payload.desc) {
 		payload->payload.offset += ctx->pctx.protocol[base].offset;
 		return 0;
 	}
 
-	if (payload->payload.base != h->base)
-		return 1;
-
 	err = supersede_dep(ctx, desc, payload);
 	if (err <= 0)
 		return err;
@@ -442,17 +438,24 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 {
 	struct expr *payload = expr;
 	enum proto_bases base = payload->payload.base;
+	const struct proto_desc *desc;
 	struct stmt *nstmt;
 	int err;
 
-	if (ctx->pctx.protocol[base].desc == NULL) {
+	desc = ctx->pctx.protocol[base].desc;
+	if (desc == NULL) {
 		if (payload_gen_dependency(ctx, payload, &nstmt) < 0)
 			return -1;
 		list_add_tail(&nstmt->list, &ctx->stmt->list);
 	} else {
-		err = resolve_protocol_conflict(ctx, payload);
-		if (err <= 0)
-			return err;
+		/* If we already have context and this payload is on the same
+		 * base, try to resolve the protocol conflict.
+		 */
+		if (payload->payload.base == desc->base) {
+			err = resolve_protocol_conflict(ctx, desc, payload);
+			if (err <= 0)
+				return err;
+		}
 		return expr_error(ctx->msgs, payload,
 				  "conflicting protocols specified: %s vs. %s",
 				  ctx->pctx.protocol[base].desc->name,
-- 
2.1.4

