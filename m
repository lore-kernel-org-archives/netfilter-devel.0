From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 2/2] evaluate: reject: enhance the error support throwing messages with more details
Date: Thu, 23 Oct 2014 18:21:44 +0200
Message-ID: <1414081304-6593-2-git-send-email-alvaroneay@gmail.com>
References: <1414081304-6593-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:55833 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159AbaJWQVh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:21:37 -0400
Received: by mail-wi0-f175.google.com with SMTP id d1so4619920wiv.2
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2014 09:21:36 -0700 (PDT)
In-Reply-To: <1414081304-6593-1-git-send-email-alvaroneay@gmail.com>
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
 src/evaluate.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 2dd49fa..e43a8b9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1213,7 +1213,8 @@ static int stmt_evaluate_reject_inet_family(struct eval_ctx *ctx,
 	case NFT_REJECT_TCP_RST:
 		break;
 	case NFT_REJECT_ICMPX_UNREACH:
-		return stmt_error(ctx, stmt,
+		return stmt_binary_error(ctx, stmt->reject.expr,
+				    &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
 				  "conflicting network protocol specified");
 	case NFT_REJECT_ICMP_UNREACH:
 		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
@@ -1222,12 +1223,14 @@ static int stmt_evaluate_reject_inet_family(struct eval_ctx *ctx,
 		case NFPROTO_IPV4:
 			if (stmt->reject.family == NFPROTO_IPV4)
 				break;
-			return stmt_error(ctx, stmt,
+			return stmt_binary_error(ctx, stmt->reject.expr,
+				    &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
 				  "conflicting protocols specified: ip vs ip6");
 		case NFPROTO_IPV6:
 			if (stmt->reject.family == NFPROTO_IPV6)
 				break;
-			return stmt_error(ctx, stmt,
+			return stmt_binary_error(ctx, stmt->reject.expr,
+				    &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
 				  "conflicting protocols specified: ip vs ip6");
 		default:
 			BUG("unsupported family");
@@ -1263,7 +1266,8 @@ static int stmt_evaluate_reject_bridge_family(struct eval_ctx *ctx,
 
 	switch (stmt->reject.type) {
 	case NFT_REJECT_ICMPX_UNREACH:
-		return stmt_error(ctx, stmt,
+		return stmt_binary_error(ctx, stmt->reject.expr,
+				    &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
 				  "conflicting network protocol specified");
 	case NFT_REJECT_TCP_RST:
 		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
@@ -1273,7 +1277,8 @@ static int stmt_evaluate_reject_bridge_family(struct eval_ctx *ctx,
 		case __constant_htons(ETH_P_IPV6):
 			break;
 		default:
-			return stmt_error(ctx, stmt,
+			return stmt_binary_error(ctx, stmt->reject.expr,
+				    &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
 					  "cannot reject this ether type");
 		}
 		break;
@@ -1284,15 +1289,18 @@ static int stmt_evaluate_reject_bridge_family(struct eval_ctx *ctx,
 		case __constant_htons(ETH_P_IP):
 			if (NFPROTO_IPV4 == stmt->reject.family)
 				break;
-			return stmt_error(ctx, stmt,
+			return stmt_binary_error(ctx, stmt->reject.expr,
+				    &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
 				  "conflicting protocols specified: ip vs ip6");
 		case __constant_htons(ETH_P_IPV6):
 			if (NFPROTO_IPV6 == stmt->reject.family)
 				break;
-			return stmt_error(ctx, stmt,
+			return stmt_binary_error(ctx, stmt->reject.expr,
+				    &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
 				  "conflicting protocols specified: ip vs ip6");
 		default:
-			return stmt_error(ctx, stmt,
+			return stmt_binary_error(ctx, stmt,
+				    &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
 					  "cannot reject this ether type");
 		}
 		break;
@@ -1331,11 +1339,12 @@ static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
 				return -1;
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
-			return stmt_error(ctx, stmt,
+			return stmt_binary_error(ctx, stmt->reject.expr, stmt,
 				   "abstracted ICMP unreachable not supported");
 		case NFT_REJECT_ICMP_UNREACH:
 			if (stmt->reject.family != ctx->pctx.family)
-				return stmt_error(ctx, stmt,
+				return stmt_binary_error(ctx, stmt->reject.expr,
+							 stmt,
 				  "conflicting protocols specified: ip vs ip6");
 			break;
 		}
@@ -1452,7 +1461,8 @@ static int stmt_evaluate_reset(struct eval_ctx *ctx, struct stmt *stmt)
 		break;
 	default:
 		if (stmt->reject.type == NFT_REJECT_TCP_RST) {
-			return stmt_error(ctx, stmt,
+			return stmt_binary_error(ctx, stmt,
+				  &ctx->pctx.protocol[PROTO_BASE_TRANSPORT_HDR],
 				 "you cannot use tcp reset with this protocol");
 		}
 		break;
-- 
1.7.10.4

