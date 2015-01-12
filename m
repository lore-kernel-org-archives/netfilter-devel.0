From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/4] evaluate: properly set datatype of map expression
Date: Mon, 12 Jan 2015 13:30:04 +0000
Message-ID: <1421069406-10276-2-git-send-email-kaber@trash.net>
References: <1421069406-10276-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35354 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbbALNaN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:30:13 -0500
In-Reply-To: <1421069406-10276-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The datatype of the map expression is the datatype of the mappings.

# nft add map filter test { type ipv4_addr : inet_service; }
# nft filter output mark set ip daddr map @test

Before:

<cmdline>:1:24-41: Error: datatype mismatch: expected packet mark, expression has type IPv4 address
filter output mark set ip daddr map @test
              ~~~~~~~~~^^^^^^^^^^^^^^^^^^

After:

<cmdline>:1:24-41: Error: datatype mismatch: expected packet mark, expression has type internet network service
filter output mark set ip daddr map @test
              ~~~~~~~~~^^^^^^^^^^^^^^^^^^

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/evaluate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 651465a..2067a01 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -748,7 +748,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		    map->mappings->ops->name);
 	}
 
-	map->dtype = ctx->ectx.dtype;
+	map->dtype = map->mappings->set->datatype;
 	map->flags |= EXPR_F_CONSTANT;
 
 	/* Data for range lookups needs to be in big endian order */
-- 
2.1.0

