From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 1/4] evaluate: refactor function to check the reject family in inet and bridge
Date: Tue, 21 Oct 2014 01:29:37 +0200
Message-ID: <1413847780-10149-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43409 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbaJTX3Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:29:24 -0400
Received: by mail-wi0-f174.google.com with SMTP id r20so595082wiv.13
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2014 16:29:23 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch make a refactorization of the code to check the reject family in inet
and bridge. These changes will be used in follow up patches.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/evaluate.c |  110 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 63 insertions(+), 47 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 1fec120..977df86 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1202,12 +1202,72 @@ static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
 	return 0;
 }
 
-static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
+static int stmt_evaluate_reject_inet(struct eval_ctx *ctx, struct stmt *stmt,
+				       struct expr *expr)
+{
+	const struct proto_desc *desc, *base;
+	int protocol;
+
+	base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+	desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+	if (desc != NULL) {
+		protocol = proto_find_num(base, desc);
+		switch (protocol) {
+		case NFPROTO_IPV4:
+			if (stmt->reject.family == NFPROTO_IPV4)
+				return 0;
+			return stmt_error(ctx, stmt,
+			  "conflicting protocols specified: ip vs ip6");
+		case NFPROTO_IPV6:
+			if (stmt->reject.family == NFPROTO_IPV6)
+				return 0;
+			return stmt_error(ctx, stmt,
+			  "conflicting protocols specified: ip vs ip6");
+		default:
+			BUG("unsupported family");
+		}
+	}
+	if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
+		return 0;
+	if (stmt_reject_gen_dependency(ctx, stmt, expr) < 0)
+		return -1;
+	return 0;
+}
+
+static int stmt_evaluate_reject_bridge(struct eval_ctx *ctx, struct stmt *stmt,
 				       struct expr *expr)
 {
 	const struct proto_desc *desc, *base;
 	int protocol;
 
+	base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+	desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+	if (desc != NULL) {
+		protocol = proto_find_num(base, desc);
+		switch (protocol) {
+		case __constant_htons(ETH_P_IP):
+			if (NFPROTO_IPV4 == stmt->reject.family)
+				return 0;
+		case __constant_htons(ETH_P_IPV6):
+			if (NFPROTO_IPV6 == stmt->reject.family)
+				return 0;
+			return stmt_error(ctx, stmt,
+				  "conflicting protocols specified: ip vs ip6");
+		default:
+			return stmt_error(ctx, stmt,
+					  "cannot reject this ether type");
+		}
+	}
+	if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
+		return 0;
+	if (stmt_reject_gen_dependency(ctx, stmt, expr) < 0)
+		return -1;
+	return 0;
+}
+
+static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
+				       struct expr *expr)
+{
 	switch (ctx->pctx.family) {
 	case NFPROTO_ARP:
 		return stmt_error(ctx, stmt, "cannot use reject with arp");
@@ -1229,55 +1289,11 @@ static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
 		}
 		break;
 	case NFPROTO_BRIDGE:
-		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
-		desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
-		if (desc != NULL) {
-			protocol = proto_find_num(base, desc);
-			switch (protocol) {
-			case __constant_htons(ETH_P_IP):
-				if (NFPROTO_IPV4 == stmt->reject.family)
-					break;
-			case __constant_htons(ETH_P_IPV6):
-				if (NFPROTO_IPV6 == stmt->reject.family)
-					break;
-				return stmt_error(ctx, stmt,
-				  "conflicting protocols specified: ip vs ip6");
-			default:
-				return stmt_error(ctx, stmt,
-						"cannot reject this ether type");
-			}
-			break;
-		}
-		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
-			break;
-		if (stmt_reject_gen_dependency(ctx, stmt, expr) < 0)
+		if (stmt_evaluate_reject_bridge(ctx, stmt, expr) < 0)
 			return -1;
 		break;
 	case NFPROTO_INET:
-		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
-		desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
-		if (desc != NULL) {
-			protocol = proto_find_num(base, desc);
-			switch (protocol) {
-			case NFPROTO_IPV4:
-				if (stmt->reject.family == NFPROTO_IPV4)
-					break;
-				return stmt_error(ctx, stmt,
-				  "conflicting protocols specified: ip vs ip6");
-				break;
-			case NFPROTO_IPV6:
-				if (stmt->reject.family == NFPROTO_IPV6)
-					break;
-				return stmt_error(ctx, stmt,
-				  "conflicting protocols specified: ip vs ip6");
-			default:
-				BUG("unsupported family");
-			}
-			break;
-		}
-		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
-			break;
-		if (stmt_reject_gen_dependency(ctx, stmt, expr) < 0)
+		if (stmt_evaluate_reject_inet(ctx, stmt, expr) < 0)
 			return -1;
 		break;
 	}
-- 
1.7.10.4

