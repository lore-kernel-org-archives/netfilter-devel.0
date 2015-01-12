From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/4] evaluate: verify named map is actually a map
Date: Mon, 12 Jan 2015 13:30:03 +0000
Message-ID: <1421069406-10276-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35350 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbbALNaM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:30:12 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

# nft add set filter test { type ipv4_addr; }
# nft filter input ip daddr vmap @test

Before:

<cmdline>:0:0-32: Error: Could not process rule: Invalid argument
filter input ip daddr vmap @test
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After:

<cmdline>:1:28-32: Error: Expression is not a map
filter input ip daddr vmap @test
                           ^^^^^

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/evaluate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index d24d4cc..651465a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -738,7 +738,8 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	case EXPR_SYMBOL:
 		if (expr_evaluate(ctx, &map->mappings) < 0)
 			return -1;
-		if (map->mappings->ops->type != EXPR_SET_REF)
+		if (map->mappings->ops->type != EXPR_SET_REF ||
+		    !(map->mappings->set->flags & NFT_SET_MAP))
 			return expr_error(ctx->msgs, map->mappings,
 					  "Expression is not a map");
 		break;
-- 
2.1.0

