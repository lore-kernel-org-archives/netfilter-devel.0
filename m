From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH] evaluate: reject: fix a crash to use tcp reset with network context in bridge
Date: Mon, 24 Nov 2014 20:20:57 +0100
Message-ID: <1416856857-15768-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47024 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaKXTUl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:20:41 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so13303878wgh.34
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Nov 2014 11:20:40 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we use tcp reset with a network protocol that it's not supported, we send an
error message. In that case reject.expr is NULL and we have a crash. Therefore
we have to use the stmt to indicate that the error comes from the reject.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/evaluate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 3eeb614..00e55b7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1277,7 +1277,7 @@ static int stmt_evaluate_reject_bridge_family(struct eval_ctx *ctx,
 		case __constant_htons(ETH_P_IPV6):
 			break;
 		default:
-			return stmt_binary_error(ctx, stmt->reject.expr,
+			return stmt_binary_error(ctx, stmt,
 				    &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
 				    "cannot reject this ether type");
 		}
-- 
1.7.10.4

