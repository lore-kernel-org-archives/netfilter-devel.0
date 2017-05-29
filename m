From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] meta: permit meta nfproto ip in ip family
Date: Mon, 29 May 2017 19:25:37 +0200
Message-ID: <20170529172538.27878-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33228 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750864AbdE2RZU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 13:25:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

works:
add rule ip filter input ct original saddr 1.2.3.4
(family ctx init initialises network base to proto_ip).

fails to parse 1.2.3.4 address:
add rule ip filter input meta nfproto ipv4 ct original saddr 1.2.3.4

... because meta_expr_pctx_update() won't find a dependency
from "ip" to "ip" and then overwrites the correct base with proto_unknown.

"meta nfproto ip" is useless in the ip family, as it will always match,
i.e.  a better (but more compliated) fix would be to remove the statement
during evaluation.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/meta.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index cb7c1368e087..dd09d49560cd 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -497,6 +497,7 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
 	const struct hook_proto_desc *h = &hook_proto_desc[ctx->family];
 	const struct expr *left = expr->left, *right = expr->right;
 	const struct proto_desc *desc;
+	uint8_t protonum;
 
 	assert(expr->op == OP_EQ);
 
@@ -514,10 +515,16 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
 		proto_ctx_update(ctx, PROTO_BASE_LL_HDR, &expr->location, desc);
 		break;
 	case NFT_META_NFPROTO:
-		desc = proto_find_upper(h->desc, mpz_get_uint8(right->value));
-		if (desc == NULL)
+		protonum = mpz_get_uint8(right->value);
+		desc = proto_find_upper(h->desc, protonum);
+		if (desc == NULL) {
 			desc = &proto_unknown;
 
+			if (protonum == ctx->family &&
+			    h->base == PROTO_BASE_NETWORK_HDR)
+				desc = h->desc;
+		}
+
 		proto_ctx_update(ctx, PROTO_BASE_NETWORK_HDR, &expr->location, desc);
 		break;
 	case NFT_META_L4PROTO:
-- 
2.13.0

