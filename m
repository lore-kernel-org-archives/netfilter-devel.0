From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 2/2 v2] evaluate: reject: enhance the error support throwing message with more details
Date: Thu, 23 Oct 2014 19:36:57 +0200
Message-ID: <1414085817-9059-2-git-send-email-alvaroneay@gmail.com>
References: <1414085817-9059-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:52960 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbaJWRgt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:36:49 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so1671413wgh.7
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2014 10:36:47 -0700 (PDT)
In-Reply-To: <1414085817-9059-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we add a rule like:

nft add rule bridge filter input ether type ip reject with icmpv6 type no-route

We throw an error like:

<cmdline>:1:44-49: Error: conflicting protocols specified: ip vs ip6
add rule bridge filter input ether type ip reject with icmpv6 type no-route

Now, we are going to show in which part of the rule, we have the conflict:

<cmdline>:1:51-75: Error: conflicting protocols specified: ip vs ip6
add rule bridge filter input ether type ip reject with icmpv6 type no-route
                             ~~~~~~~~~~~~~        ^^^^^^^^^^^^^^^^^^^^^^^^^

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v2]
 * Fixed some cosmetics errors.

 src/evaluate.c |   43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 2dd49fa..b722567 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1213,8 +1213,9 @@ static int stmt_evaluate_reject_inet_family(struct eval_ctx *ctx,
 	case NFT_REJECT_TCP_RST:
 		break;
 	case NFT_REJECT_ICMPX_UNREACH:
-		return stmt_error(ctx, stmt,
-				  "conflicting network protocol specified");
+		return stmt_binary_error(ctx, stmt->reject.expr,
+				    &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
+				    "conflicting network protocol specified");
 	case NFT_REJECT_ICMP_UNREACH:
 		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
 		protocol = proto_find_num(base, desc);
@@ -1222,12 +1223,14 @@ static int stmt_evaluate_reject_inet_family(struct eval_ctx *ctx,
 		case NFPROTO_IPV4:
 			if (stmt->reject.family == NFPROTO_IPV4)
 				break;
-			return stmt_error(ctx, stmt,
+			return stmt_binary_error(ctx, stmt->reject.expr,
+				  &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
 				  "conflicting protocols specified: ip vs ip6");
 		case NFPROTO_IPV6:
 			if (stmt->reject.family == NFPROTO_IPV6)
 				break;
-			return stmt_error(ctx, stmt,
+			return stmt_binary_error(ctx, stmt->reject.expr,
+				  &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
 				  "conflicting protocols specified: ip vs ip6");
 		default:
 			BUG("unsupported family");
@@ -1263,8 +1266,9 @@ static int stmt_evaluate_reject_bridge_family(struct eval_ctx *ctx,
 
 	switch (stmt->reject.type) {
 	case NFT_REJECT_ICMPX_UNREACH:
-		return stmt_error(ctx, stmt,
-				  "conflicting network protocol specified");
+		return stmt_binary_error(ctx, stmt->reject.expr,
+				    &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
+				    "conflicting network protocol specified");
 	case NFT_REJECT_TCP_RST:
 		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
 		protocol = proto_find_num(base, desc);
@@ -1273,8 +1277,9 @@ static int stmt_evaluate_reject_bridge_family(struct eval_ctx *ctx,
 		case __constant_htons(ETH_P_IPV6):
 			break;
 		default:
-			return stmt_error(ctx, stmt,
-					  "cannot reject this ether type");
+			return stmt_binary_error(ctx, stmt->reject.expr,
+				    &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
+				    "cannot reject this ether type");
 		}
 		break;
 	case NFT_REJECT_ICMP_UNREACH:
@@ -1284,16 +1289,19 @@ static int stmt_evaluate_reject_bridge_family(struct eval_ctx *ctx,
 		case __constant_htons(ETH_P_IP):
 			if (NFPROTO_IPV4 == stmt->reject.family)
 				break;
-			return stmt_error(ctx, stmt,
+			return stmt_binary_error(ctx, stmt->reject.expr,
+				  &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
 				  "conflicting protocols specified: ip vs ip6");
 		case __constant_htons(ETH_P_IPV6):
 			if (NFPROTO_IPV6 == stmt->reject.family)
 				break;
-			return stmt_error(ctx, stmt,
+			return stmt_binary_error(ctx, stmt->reject.expr,
+				  &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
 				  "conflicting protocols specified: ip vs ip6");
 		default:
-			return stmt_error(ctx, stmt,
-					  "cannot reject this ether type");
+			return stmt_binary_error(ctx, stmt,
+				    &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
+				    "cannot reject this ether type");
 		}
 		break;
 	}
@@ -1331,13 +1339,13 @@ static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
 				return -1;
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
-			return stmt_error(ctx, stmt,
+			return stmt_binary_error(ctx, stmt->reject.expr, stmt,
 				   "abstracted ICMP unreachable not supported");
 		case NFT_REJECT_ICMP_UNREACH:
-			if (stmt->reject.family != ctx->pctx.family)
-				return stmt_error(ctx, stmt,
+			if (stmt->reject.family == ctx->pctx.family)
+				break;
+			return stmt_binary_error(ctx, stmt->reject.expr, stmt,
 				  "conflicting protocols specified: ip vs ip6");
-			break;
 		}
 		break;
 	case NFPROTO_BRIDGE:
@@ -1452,7 +1460,8 @@ static int stmt_evaluate_reset(struct eval_ctx *ctx, struct stmt *stmt)
 		break;
 	default:
 		if (stmt->reject.type == NFT_REJECT_TCP_RST) {
-			return stmt_error(ctx, stmt,
+			return stmt_binary_error(ctx, stmt,
+				 &ctx->pctx.protocol[PROTO_BASE_TRANSPORT_HDR],
 				 "you cannot use tcp reset with this protocol");
 		}
 		break;
-- 
1.7.10.4

