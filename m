From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 05/11] evaluate: only try to replace dummy protocol from link-layer context
Date: Thu, 28 Jan 2016 22:24:54 +0100
Message-ID: <1454016300-29969-6-git-send-email-pablo@netfilter.org>
References: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43803 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964770AbcA1VZT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jan 2016 16:25:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2506A8E4D0
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 163B3DA843
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 41D7ADA801
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:15 +0100 (CET)
In-Reply-To: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add proto_is_dummy() that returns true for netdev and inet family, the
only two using a dummy link-layer protocol base definition.

Rename supersede_dep() to meta_iiftype_gen_dependency() since this is
generating the implicit meta iiftype check for netdev and inet.

This patch also gets rid of the have->length check. The tests pass fine
without this so I suspect this is superfluos.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 5ef035b..eb442d5 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -359,19 +359,14 @@ conflict_resolution_gen_dependency(struct eval_ctx *ctx, int protocol,
  * ip saddr adds meta dependency on ipv4 packets
  * ether saddr adds another dependeny on ethernet frames.
  */
-static int supersede_dep(struct eval_ctx *ctx, const struct proto_desc *have,
-			 struct expr *payload)
+static int meta_iiftype_gen_dependency(struct eval_ctx *ctx,
+				       const struct proto_desc *have,
+				       struct expr *payload)
 {
 	enum proto_bases base = payload->payload.base;
 	struct stmt *nstmt;
 	uint16_t type;
 
-	if (payload->payload.base != PROTO_BASE_LL_HDR || have->length)
-		return 1;
-
-	if (have != &proto_inet && have != &proto_netdev)
-		return 1;
-
 	if (proto_dev_type(payload->payload.desc, &type) < 0)
 		return expr_error(ctx->msgs, payload,
 				  "protocol specification is invalid "
@@ -387,6 +382,11 @@ static int supersede_dep(struct eval_ctx *ctx, const struct proto_desc *have,
 	return 0;
 }
 
+static bool proto_is_dummy(const struct proto_desc *desc)
+{
+	return desc == &proto_inet || desc == &proto_netdev;
+}
+
 static int resolve_protocol_conflict(struct eval_ctx *ctx,
 				     const struct proto_desc *desc,
 				     struct expr *payload)
@@ -395,9 +395,12 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
 	struct stmt *nstmt = NULL;
 	int link, err;
 
-	err = supersede_dep(ctx, desc, payload);
-	if (err <= 0)
-		return err;
+	if (payload->payload.base == PROTO_BASE_LL_HDR &&
+	    proto_is_dummy(desc)) {
+		err = meta_iiftype_gen_dependency(ctx, desc, payload);
+		if (err <= 0)
+			return err;
+	}
 
 	if (base < PROTO_BASE_MAX) {
 		const struct proto_desc *next = ctx->pctx.protocol[base + 1].desc;
-- 
2.1.4

