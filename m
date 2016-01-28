From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 06/11] evaluate: assert on invalid base in resolve_protocol_conflict()
Date: Thu, 28 Jan 2016 22:24:55 +0100
Message-ID: <1454016300-29969-7-git-send-email-pablo@netfilter.org>
References: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43802 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966732AbcA1VZT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jan 2016 16:25:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id F02F633D
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DCB75DA863
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1188ADA7E0
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:16 +0100 (CET)
In-Reply-To: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We already have similar code in the tree, we shouldn't see bases over
transport yet.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index eb442d5..b70ff07 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -392,6 +392,7 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
 				     struct expr *payload)
 {
 	enum proto_bases base = payload->payload.base;
+	const struct proto_desc *next;
 	struct stmt *nstmt = NULL;
 	int link, err;
 
@@ -402,18 +403,17 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
 			return err;
 	}
 
-	if (base < PROTO_BASE_MAX) {
-		const struct proto_desc *next = ctx->pctx.protocol[base + 1].desc;
+	assert(base < PROTO_BASE_MAX);
+	next = ctx->pctx.protocol[base + 1].desc;
 
-		if (payload->payload.desc == next) {
-			ctx->pctx.protocol[base + 1].desc = NULL;
-			ctx->pctx.protocol[base].desc = next;
-			ctx->pctx.protocol[base].offset += desc->length;
-			payload->payload.offset += desc->length;
-			return 0;
-		} else if (next) {
-			return 1;
-		}
+	if (payload->payload.desc == next) {
+		ctx->pctx.protocol[base + 1].desc = NULL;
+		ctx->pctx.protocol[base].desc = next;
+		ctx->pctx.protocol[base].offset += desc->length;
+		payload->payload.offset += desc->length;
+		return 0;
+	} else if (next) {
+		return 1;
 	}
 
 	link = proto_find_num(desc, payload->payload.desc);
-- 
2.1.4

