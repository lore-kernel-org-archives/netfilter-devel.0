From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] payload: assert when accessing inner transport header
Date: Mon,  5 Jan 2015 13:04:24 +0100
Message-ID: <1420459464-21821-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33948 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbbAEMBn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:01:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of segfaulting due to out of bound access access to protocol
context array ctx->protocol[base].location from proto_ctx_update().

 # nft add rule filter input ah nexthdr tcp
 nft: payload.c:88: payload_expr_pctx_update: Assertion `left->payload.base + 1 <= (__PROTO_BASE_MAX - 1)' failed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
So we avoid a crash. I think we have to add PROTO_BASE_INNER_HDR to proto_bases
and add some extra offsets for the inner header for this case. At least, I'd
like to put this in the tree so we have this in our radar.

 src/payload.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/src/payload.c b/src/payload.c
index 83742fb..08578fd 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -85,6 +85,7 @@ static void payload_expr_pctx_update(struct proto_ctx *ctx,
 	base = ctx->protocol[left->payload.base].desc;
 	desc = proto_find_upper(base, proto);
 
+	assert(left->payload.base + 1 <= PROTO_BASE_MAX);
 	proto_ctx_update(ctx, left->payload.base + 1, &expr->location, desc);
 }
 
-- 
1.7.10.4

