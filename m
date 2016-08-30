From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 3/4] stmt_evaluate_reset: Have a generic fix for missing network context
Date: Tue, 30 Aug 2016 19:39:51 +0200
Message-ID: <1472578792-2991-4-git-send-email-phil@nwl.cc>
References: <1472578792-2991-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:51853 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932463AbcH3RkL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 13:40:11 -0400
In-Reply-To: <1472578792-2991-1-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit 17b495957b29e ("evaluate: reject: fix crash if we have transport
protocol conflict from inet") took care of a crash when using inet or
bridge families, but since then netdev family has been added which also
does not implicitly define the network context. Therefore the crash can
be reproduced again using the following example:

nft add rule netdev filter e1000-ingress \
		meta l4proto udp reject with tcp reset

In order to fix this in a more generic way, have stmt_evaluate_reset()
fall back to the generic proto_inet_service irrespective of the actual
proto context.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Found the real cause for the problem after some more code and git
  history research, so rewrote the patch from scratch.
---
 src/evaluate.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index fb9b82534d520..194a03495b5fd 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2167,9 +2167,7 @@ static int stmt_evaluate_reset(struct eval_ctx *ctx, struct stmt *stmt)
 		return 0;
 
 	base = pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
-	if (base == NULL &&
-	    (ctx->pctx.family == NFPROTO_INET ||
-	     ctx->pctx.family == NFPROTO_BRIDGE))
+	if (base == NULL)
 		base = &proto_inet_service;
 
 	protonum = proto_find_num(base, desc);
-- 
2.8.2

