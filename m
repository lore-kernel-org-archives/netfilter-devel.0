From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 02/11] evaluate: move inet/netdev protocol context supersede logic to supersede_dep()
Date: Thu, 28 Jan 2016 22:24:51 +0100
Message-ID: <1454016300-29969-3-git-send-email-pablo@netfilter.org>
References: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43794 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473AbcA1VZS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jan 2016 16:25:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C45D561EBF
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A4D76DA80B
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 57F91DA843
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:12 +0100 (CET)
In-Reply-To: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a cleanup to untangle this logic a bit.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 48 +++++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 7898ed4..93f408d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -359,16 +359,32 @@ conflict_resolution_gen_dependency(struct eval_ctx *ctx, int protocol,
  * ip saddr adds meta dependency on ipv4 packets
  * ether saddr adds another dependeny on ethernet frames.
  */
-static bool supersede_dep(const struct proto_desc *have,
-			  struct expr *payload)
+static int supersede_dep(struct eval_ctx *ctx, const struct proto_desc *have,
+			 struct expr *payload)
 {
+	enum proto_bases base = payload->payload.base;
+	struct stmt *nstmt;
+	uint16_t type;
+
 	if (payload->payload.base != PROTO_BASE_LL_HDR || have->length)
-		return false;
+		return 1;
 
 	if (have != &proto_inet && have != &proto_netdev)
-		return false;
+		return 1;
 
-	return true;
+	if (proto_dev_type(payload->payload.desc, &type) < 0)
+		return expr_error(ctx->msgs, payload,
+				  "protocol specification is invalid "
+				  "for this family");
+
+	nstmt = meta_stmt_meta_iiftype(&payload->location, type);
+	if (stmt_evaluate(ctx, nstmt) < 0)
+		return expr_error(ctx->msgs, payload,
+				  "dependency statement is invalid");
+
+	list_add_tail(&nstmt->list, &ctx->stmt->list);
+	ctx->pctx.protocol[base].desc = payload->payload.desc;
+	return 0;
 }
 
 static int resolve_protocol_conflict(struct eval_ctx *ctx, struct expr *payload)
@@ -377,7 +393,7 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx, struct expr *payload)
 	enum proto_bases base = payload->payload.base;
 	const struct proto_desc *desc;
 	struct stmt *nstmt = NULL;
-	int link;
+	int link, err;
 
 	desc = ctx->pctx.protocol[base].desc;
 	if (desc == payload->payload.desc) {
@@ -388,23 +404,9 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx, struct expr *payload)
 	if (payload->payload.base != h->base)
 		return 1;
 
-	if (supersede_dep(desc, payload)) {
-		uint16_t type;
-
-		if (proto_dev_type(payload->payload.desc, &type) < 0)
-			return expr_error(ctx->msgs, payload,
-					  "protocol specification is invalid "
-					  "for this family");
-
-		nstmt = meta_stmt_meta_iiftype(&payload->location, type);
-		if (stmt_evaluate(ctx, nstmt) < 0)
-			return expr_error(ctx->msgs, payload,
-					  "dependency statement is invalid");
-
-		list_add_tail(&nstmt->list, &ctx->stmt->list);
-		ctx->pctx.protocol[base].desc = payload->payload.desc;
-		return 0;
-	}
+	err = supersede_dep(ctx, desc, payload);
+	if (err <= 0)
+		return err;
 
 	if (base < PROTO_BASE_MAX) {
 		const struct proto_desc *next = ctx->pctx.protocol[base + 1].desc;
-- 
2.1.4

