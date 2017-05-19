From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/7] payload: split ll proto dependency into helper
Date: Fri, 19 May 2017 22:11:05 +0200
Message-ID: <20170519201111.7402-2-fw@strlen.de>
References: <20170519201111.7402-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34032 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751513AbdESUK4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 16:10:56 -0400
In-Reply-To: <20170519201111.7402-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

will be re-used in folloup patch for icmp/icmpv6 depenency
handling.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 patch was not part of earlier series.

 src/payload.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/src/payload.c b/src/payload.c
index 55128fee1498..31e5a0244837 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -224,21 +224,28 @@ static int payload_add_dependency(struct eval_ctx *ctx,
 }
 
 static const struct proto_desc *
+payload_get_get_ll_hdr(const struct eval_ctx *ctx)
+{
+	switch (ctx->pctx.family) {
+	case NFPROTO_INET:
+		return &proto_inet;
+	case NFPROTO_BRIDGE:
+		return &proto_eth;
+	case NFPROTO_NETDEV:
+		return &proto_netdev;
+	default:
+		break;
+	}
+
+	return NULL;
+}
+
+static const struct proto_desc *
 payload_gen_special_dependency(struct eval_ctx *ctx, const struct expr *expr)
 {
 	switch (expr->payload.base) {
 	case PROTO_BASE_LL_HDR:
-		switch (ctx->pctx.family) {
-		case NFPROTO_INET:
-			return &proto_inet;
-		case NFPROTO_BRIDGE:
-			return &proto_eth;
-		case NFPROTO_NETDEV:
-			return &proto_netdev;
-		default:
-			break;
-		}
-		break;
+		return payload_get_get_ll_hdr(ctx);
 	case PROTO_BASE_TRANSPORT_HDR:
 		if (expr->payload.desc == &proto_icmp)
 			return &proto_ip;
-- 
2.13.0

