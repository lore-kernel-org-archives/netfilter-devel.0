From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH v3] evaluate: fix a crash if we specify ether type or meta nfproto in reject
Date: Mon, 20 Oct 2014 15:32:09 +0200
Message-ID: <1413811929-21955-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38564 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbaJTNb5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:31:57 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so5361571wgg.13
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2014 06:31:53 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we use this rule:

nft add rule bridge filter input \
	ether type ip reject with icmp type host-unreachable

or that:

nft add rule inet filter input \
	meta nfproto ipv4 reject with icmp type host-unreachable

we have a segfault because we add a network dependency when we already have
network context.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/evaluate.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index d61d76b..1fec120 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1142,7 +1142,7 @@ static int reject_payload_gen_dependency_tcp(struct eval_ctx *ctx,
 		return 0;
 	*payload = payload_expr_alloc(&stmt->location, &proto_tcp,
 				      TCPHDR_UNSPEC);
-	return 0;
+	return 1;
 }
 
 static int reject_payload_gen_dependency_family(struct eval_ctx *ctx,
@@ -1171,7 +1171,7 @@ static int reject_payload_gen_dependency_family(struct eval_ctx *ctx,
 	default:
 		BUG("unknown reject family");
 	}
-	return 0;
+	return 1;
 }
 
 static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
@@ -1179,21 +1179,21 @@ static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
 {
 	struct expr *payload = NULL;
 	struct stmt *nstmt;
+	int ret;
 
 	switch (stmt->reject.type) {
 	case NFT_REJECT_TCP_RST:
-		if (reject_payload_gen_dependency_tcp(ctx, stmt, &payload) < 0)
-			return -1;
+		ret = reject_payload_gen_dependency_tcp(ctx, stmt, &payload);
 		break;
 	case NFT_REJECT_ICMP_UNREACH:
-		if (reject_payload_gen_dependency_family(ctx, stmt,
-							 &payload) < 0)
-			return -1;
+		ret = reject_payload_gen_dependency_family(ctx, stmt, &payload);
 		break;
 	default:
 		BUG("cannot generate reject dependency for type %d",
 		    stmt->reject.type);
 	}
+	if (ret <= 0)
+		return ret;
 
 	if (payload_gen_dependency(ctx, payload, &nstmt) < 0)
 		return -1;
-- 
1.7.10.4

