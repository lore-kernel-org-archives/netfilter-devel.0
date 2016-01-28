From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 08/11] evaluate: generate ether type payload after meta iiftype
Date: Thu, 28 Jan 2016 22:24:57 +0100
Message-ID: <1454016300-29969-9-git-send-email-pablo@netfilter.org>
References: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43808 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbcA1VZU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jan 2016 16:25:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B124EA7E28
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9D363DA85C
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BE86ADA85D
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:17 +0100 (CET)
In-Reply-To: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Once the meta iiftype is generated, we shouldn't return from
resolve_protocol_conflict() since we also need to generate the ether
type payload implicit match after it.

This gets rid of the manual proto-ctx update from
meta_iiftype_gen_dependency() that we don't need since stmt_evaluate()
already handles this for us.

Moreover, skip error reporting once we verify that the protocol conflict
has been resolved.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index e53627a..ed78896 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -360,10 +360,8 @@ conflict_resolution_gen_dependency(struct eval_ctx *ctx, int protocol,
  * ether saddr adds another dependeny on ethernet frames.
  */
 static int meta_iiftype_gen_dependency(struct eval_ctx *ctx,
-				       const struct proto_desc *have,
-				       struct expr *payload)
+				       struct expr *payload, struct stmt **res)
 {
-	enum proto_bases base = payload->payload.base;
 	struct stmt *nstmt;
 	uint16_t type;
 
@@ -377,8 +375,7 @@ static int meta_iiftype_gen_dependency(struct eval_ctx *ctx,
 		return expr_error(ctx->msgs, payload,
 				  "dependency statement is invalid");
 
-	list_add_tail(&nstmt->list, &ctx->stmt->list);
-	ctx->pctx.protocol[base].desc = payload->payload.desc;
+	*res = nstmt;
 	return 0;
 }
 
@@ -409,9 +406,11 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
 
 	if (payload->payload.base == PROTO_BASE_LL_HDR &&
 	    proto_is_dummy(desc)) {
-		err = meta_iiftype_gen_dependency(ctx, desc, payload);
-		if (err <= 0)
+		err = meta_iiftype_gen_dependency(ctx, payload, &nstmt);
+		if (err < 0)
 			return err;
+
+		list_add_tail(&nstmt->list, &ctx->stmt->list);
 	}
 
 	assert(base < PROTO_BASE_MAX);
@@ -474,6 +473,10 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 			err = resolve_protocol_conflict(ctx, desc, payload);
 			if (err <= 0)
 				return err;
+
+			desc = ctx->pctx.protocol[base].desc;
+			if (desc == payload->payload.desc)
+				return 0;
 		}
 		return expr_error(ctx->msgs, payload,
 				  "conflicting protocols specified: %s vs. %s",
-- 
2.1.4

