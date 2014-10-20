From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 2/4] evaluate: accept a reject reason with incorrect network context
Date: Tue, 21 Oct 2014 01:29:38 +0200
Message-ID: <1413847780-10149-2-git-send-email-alvaroneay@gmail.com>
References: <1413847780-10149-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:50125 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbaJTX3Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:29:25 -0400
Received: by mail-wg0-f49.google.com with SMTP id x12so58263wgg.32
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2014 16:29:24 -0700 (PDT)
In-Reply-To: <1413847780-10149-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft add rule bridge test-bridge input ether type ip \
				reject with icmpv6 type no-route

This rule pass the evaluation step but the network context is incompatible with
the reject reason. In that cases, we have to throw an error like "conflicting
protocols specified: ip vs ip6"

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/evaluate.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 977df86..20235a8 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1248,6 +1248,8 @@ static int stmt_evaluate_reject_bridge(struct eval_ctx *ctx, struct stmt *stmt,
 		case __constant_htons(ETH_P_IP):
 			if (NFPROTO_IPV4 == stmt->reject.family)
 				return 0;
+			return stmt_error(ctx, stmt,
+				  "conflicting protocols specified: ip vs ip6");
 		case __constant_htons(ETH_P_IPV6):
 			if (NFPROTO_IPV6 == stmt->reject.family)
 				return 0;
-- 
1.7.10.4

