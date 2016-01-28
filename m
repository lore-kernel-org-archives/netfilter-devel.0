From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 01/11] evaluate: resolve_protocol_conflict() should return int
Date: Thu, 28 Jan 2016 22:24:50 +0100
Message-ID: <1454016300-29969-2-git-send-email-pablo@netfilter.org>
References: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43792 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845AbcA1VZS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jan 2016 16:25:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3A68D61EB2
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 202BADA795
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 657E6DA807
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:11 +0100 (CET)
In-Reply-To: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of bool, expr_error() returns -1 if we fail to create
dependencies. We need to propagate this error value.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 5e9783d..7898ed4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -371,8 +371,7 @@ static bool supersede_dep(const struct proto_desc *have,
 	return true;
 }
 
-static bool resolve_protocol_conflict(struct eval_ctx *ctx,
-				      struct expr *payload)
+static int resolve_protocol_conflict(struct eval_ctx *ctx, struct expr *payload)
 {
 	const struct hook_proto_desc *h = &hook_proto_desc[ctx->pctx.family];
 	enum proto_bases base = payload->payload.base;
@@ -381,14 +380,13 @@ static bool resolve_protocol_conflict(struct eval_ctx *ctx,
 	int link;
 
 	desc = ctx->pctx.protocol[base].desc;
-
 	if (desc == payload->payload.desc) {
 		payload->payload.offset += ctx->pctx.protocol[base].offset;
-		return true;
+		return 0;
 	}
 
 	if (payload->payload.base != h->base)
-		return false;
+		return 1;
 
 	if (supersede_dep(desc, payload)) {
 		uint16_t type;
@@ -405,7 +403,7 @@ static bool resolve_protocol_conflict(struct eval_ctx *ctx,
 
 		list_add_tail(&nstmt->list, &ctx->stmt->list);
 		ctx->pctx.protocol[base].desc = payload->payload.desc;
-		return true;
+		return 0;
 	}
 
 	if (base < PROTO_BASE_MAX) {
@@ -416,21 +414,21 @@ static bool resolve_protocol_conflict(struct eval_ctx *ctx,
 			ctx->pctx.protocol[base].desc = next;
 			ctx->pctx.protocol[base].offset += desc->length;
 			payload->payload.offset += desc->length;
-			return true;
+			return 0;
 		} else if (next) {
-			return false;
+			return 1;
 		}
 	}
 
 	link = proto_find_num(desc, payload->payload.desc);
 	if (link < 0 || conflict_resolution_gen_dependency(ctx, link, payload, &nstmt) < 0)
-		return false;
+		return 1;
 
 	payload->payload.offset += ctx->pctx.protocol[base].offset;
 	list_add_tail(&nstmt->list, &ctx->stmt->list);
 	ctx->pctx.protocol[base + 1].desc = NULL;
 
-	return true;
+	return 0;
 }
 
 /*
@@ -443,17 +441,21 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 	struct expr *payload = expr;
 	enum proto_bases base = payload->payload.base;
 	struct stmt *nstmt;
+	int err;
 
 	if (ctx->pctx.protocol[base].desc == NULL) {
 		if (payload_gen_dependency(ctx, payload, &nstmt) < 0)
 			return -1;
 		list_add_tail(&nstmt->list, &ctx->stmt->list);
-	} else if (!resolve_protocol_conflict(ctx, payload))
+	} else {
+		err = resolve_protocol_conflict(ctx, payload);
+		if (err <= 0)
+			return err;
 		return expr_error(ctx->msgs, payload,
 				  "conflicting protocols specified: %s vs. %s",
 				  ctx->pctx.protocol[base].desc->name,
 				  payload->payload.desc->name);
-
+	}
 	return 0;
 }
 
-- 
2.1.4

