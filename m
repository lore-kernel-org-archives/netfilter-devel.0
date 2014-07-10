From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] evaluate: fix concat expressions as map arguments
Date: Thu, 10 Jul 2014 15:57:21 +0200
Message-ID: <1405000641-14297-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44999 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaGJN5Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:57:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The type in the evaluation context needs to be reset to avoid treating
the concatenation as a right hand side relational expression.

# nft filter output mark set ip daddr . tcp dport map { 192.168.0.1 . 22 : 1 }
<cmdline>:1:24-43: Error: datatype mismatch, expected packet mark, expression has type concatenation of (IPv4 address, internet network service)
filter output mark set ip daddr . tcp dport map { 192.168.0.1 . 22 : 1 }
                       ^^^^^^^^^^^^^^^^^^^^

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/evaluate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 2330bbb..e05473a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -703,6 +703,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	struct expr_ctx ectx = ctx->ectx;
 	struct expr *map = *expr, *mappings;
 
+	expr_set_context(&ctx->ectx, NULL, 0);
 	if (expr_evaluate(ctx, &map->map) < 0)
 		return -1;
 	if (expr_is_constant(map->map))
-- 
1.9.3

