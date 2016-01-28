From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 07/11] evaluate: wrap protocol context debunk into function
Date: Thu, 28 Jan 2016 22:24:56 +0100
Message-ID: <1454016300-29969-8-git-send-email-pablo@netfilter.org>
References: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43806 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967060AbcA1VZT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jan 2016 16:25:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C3BD0A7E25
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B47ACDA7FF
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D6CEADA809
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:16 +0100 (CET)
In-Reply-To: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ether type vlan sets the network layer protocol context to vlan. This
function debunks the existing link layer protocol context by setting it
to vlan.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index b70ff07..e53627a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -382,6 +382,17 @@ static int meta_iiftype_gen_dependency(struct eval_ctx *ctx,
 	return 0;
 }
 
+static void proto_ctx_debunk(struct eval_ctx *ctx,
+			     const struct proto_desc *desc,
+			     const struct proto_desc *next,
+			     struct expr *payload, enum proto_bases base)
+{
+	ctx->pctx.protocol[base + 1].desc = NULL;
+	ctx->pctx.protocol[base].desc = next;
+	ctx->pctx.protocol[base].offset += desc->length;
+	payload->payload.offset += desc->length;
+}
+
 static bool proto_is_dummy(const struct proto_desc *desc)
 {
 	return desc == &proto_inet || desc == &proto_netdev;
@@ -406,16 +417,18 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
 	assert(base < PROTO_BASE_MAX);
 	next = ctx->pctx.protocol[base + 1].desc;
 
+	/* ether type vlan sets vlan as network protocol, debunk ethernet if it
+	 * is already there.
+	 */
 	if (payload->payload.desc == next) {
-		ctx->pctx.protocol[base + 1].desc = NULL;
-		ctx->pctx.protocol[base].desc = next;
-		ctx->pctx.protocol[base].offset += desc->length;
-		payload->payload.offset += desc->length;
+		proto_ctx_debunk(ctx, desc, next, payload, base);
 		return 0;
-	} else if (next) {
-		return 1;
 	}
 
+	/* This payload and the existing context don't match, conflict. */
+	if (next != NULL)
+		return 1;
+
 	link = proto_find_num(desc, payload->payload.desc);
 	if (link < 0 || conflict_resolution_gen_dependency(ctx, link, payload, &nstmt) < 0)
 		return 1;
-- 
2.1.4

