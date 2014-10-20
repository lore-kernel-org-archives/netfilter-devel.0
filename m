From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 3/4] evaluate: no check the network context in reject with tcp reset reason
Date: Tue, 21 Oct 2014 01:29:39 +0200
Message-ID: <1413847780-10149-3-git-send-email-alvaroneay@gmail.com>
References: <1413847780-10149-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64553 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbaJTX30 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:29:26 -0400
Received: by mail-wi0-f171.google.com with SMTP id em10so8498212wid.16
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2014 16:29:25 -0700 (PDT)
In-Reply-To: <1413847780-10149-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft add rule -nnn bridge test-bridge input \
			ip protocol tcp reject with tcp reset

If we use in reject the type tcp reset. We don't need to check if the network
context is compatible with the reason. This patch fix that.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/evaluate.c |   80 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 33 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 20235a8..8b19baf 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1208,24 +1208,31 @@ static int stmt_evaluate_reject_inet(struct eval_ctx *ctx, struct stmt *stmt,
 	const struct proto_desc *desc, *base;
 	int protocol;
 
-	base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
-	desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
-	if (desc != NULL) {
-		protocol = proto_find_num(base, desc);
-		switch (protocol) {
-		case NFPROTO_IPV4:
-			if (stmt->reject.family == NFPROTO_IPV4)
-				return 0;
-			return stmt_error(ctx, stmt,
-			  "conflicting protocols specified: ip vs ip6");
-		case NFPROTO_IPV6:
-			if (stmt->reject.family == NFPROTO_IPV6)
-				return 0;
-			return stmt_error(ctx, stmt,
-			  "conflicting protocols specified: ip vs ip6");
-		default:
-			BUG("unsupported family");
+	switch (stmt->reject.type) {
+	case NFT_REJECT_TCP_RST:
+		break;
+	case NFT_REJECT_ICMPX_UNREACH:
+	case NFT_REJECT_ICMP_UNREACH:
+		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+		desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+		if (desc != NULL) {
+			protocol = proto_find_num(base, desc);
+			switch (protocol) {
+			case NFPROTO_IPV4:
+				if (stmt->reject.family == NFPROTO_IPV4)
+					return 0;
+				return stmt_error(ctx, stmt,
+				  "conflicting protocols specified: ip vs ip6");
+			case NFPROTO_IPV6:
+				if (stmt->reject.family == NFPROTO_IPV6)
+					return 0;
+				return stmt_error(ctx, stmt,
+				  "conflicting protocols specified: ip vs ip6");
+			default:
+				BUG("unsupported family");
+			}
 		}
+		break;
 	}
 	if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
 		return 0;
@@ -1240,25 +1247,32 @@ static int stmt_evaluate_reject_bridge(struct eval_ctx *ctx, struct stmt *stmt,
 	const struct proto_desc *desc, *base;
 	int protocol;
 
-	base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
-	desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
-	if (desc != NULL) {
-		protocol = proto_find_num(base, desc);
-		switch (protocol) {
-		case __constant_htons(ETH_P_IP):
-			if (NFPROTO_IPV4 == stmt->reject.family)
-				return 0;
-			return stmt_error(ctx, stmt,
+	switch (stmt->reject.type) {
+	case NFT_REJECT_TCP_RST:
+		break;
+	case NFT_REJECT_ICMPX_UNREACH:
+	case NFT_REJECT_ICMP_UNREACH:
+		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+		desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+		if (desc != NULL) {
+			protocol = proto_find_num(base, desc);
+			switch (protocol) {
+			case __constant_htons(ETH_P_IP):
+				if (NFPROTO_IPV4 == stmt->reject.family)
+					return 0;
+				return stmt_error(ctx, stmt,
 				  "conflicting protocols specified: ip vs ip6");
-		case __constant_htons(ETH_P_IPV6):
-			if (NFPROTO_IPV6 == stmt->reject.family)
-				return 0;
-			return stmt_error(ctx, stmt,
+			case __constant_htons(ETH_P_IPV6):
+				if (NFPROTO_IPV6 == stmt->reject.family)
+					return 0;
+				return stmt_error(ctx, stmt,
 				  "conflicting protocols specified: ip vs ip6");
-		default:
-			return stmt_error(ctx, stmt,
-					  "cannot reject this ether type");
+			default:
+				return stmt_error(ctx, stmt,
+					       "cannot reject this ether type");
+			}
 		}
+		break;
 	}
 	if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
 		return 0;
-- 
1.7.10.4

