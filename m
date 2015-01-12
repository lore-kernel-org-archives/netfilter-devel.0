From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/4] evaluate: check that map expressions' datatype matches mappings
Date: Mon, 12 Jan 2015 13:30:05 +0000
Message-ID: <1421069406-10276-3-git-send-email-kaber@trash.net>
References: <1421069406-10276-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35356 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbbALNaN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:30:13 -0500
In-Reply-To: <1421069406-10276-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Catch type errors in map expressions using named maps:

# nft add map filter test { type ipv4_addr : inet_service; }
# nft filter output mark set tcp dport map @test
<cmdline>:1:38-42: Error: datatype mismatch, map expects IPv4 address, mapping expression has type internet network service
filter output mark set tcp dport map @test
                       ~~~~~~~~~     ^^^^^

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/evaluate.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 2067a01..90c87d0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -748,6 +748,13 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		    map->mappings->ops->name);
 	}
 
+	if (!datatype_equal(map->map->dtype, map->mappings->set->keytype))
+		return expr_binary_error(ctx->msgs, map->mappings, map->map,
+					 "datatype mismatch, map expects %s, "
+					 "mapping expression has type %s",
+					 map->mappings->set->keytype->desc,
+					 map->map->dtype->desc);
+
 	map->dtype = map->mappings->set->datatype;
 	map->flags |= EXPR_F_CONSTANT;
 
-- 
2.1.0

