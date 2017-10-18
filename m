From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] rule: fix netlink debug flag when listing table/rules
Date: Thu, 19 Oct 2017 01:06:07 +0200
Message-ID: <20171018230607.22375-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54186 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750992AbdJRXFt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2017 19:05:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft --debug=netlink list table ...
has no effect anymore.

Callers pass in debug_mask & DEBUG_NETLINK, which gets converted
to 0/1 because the arg is a boolean.

Later on this bool is converted back to an integer, but that
won't have the desired result.

Fixes: be441e1ffdc24 ("src: add debugging mask to context structure")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/rule.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index d744cf611100..d83284e5414f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -123,7 +123,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, enum cmd_ops cmd)
 
 static int cache_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 		      enum cmd_ops cmd, struct list_head *msgs,
-		      unsigned int debug_mask, struct output_ctx *octx)
+		      bool debug, struct output_ctx *octx)
 {
 	struct handle handle = {
 		.family = NFPROTO_UNSPEC,
@@ -134,7 +134,7 @@ static int cache_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 		.cache		= cache,
 		.msgs		= msgs,
 		.seqnum		= cache->seqnum++,
-		.debug_mask	= debug_mask,
+		.debug_mask	= debug ? DEBUG_NETLINK : 0,
 		.octx		= octx,
 	};
 	int ret;
-- 
2.13.6

