From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 1/7] nft_ctx_free: Fix for wrong argument passed to cache_release
Date: Thu, 19 Oct 2017 10:18:41 +0200
Message-ID: <20171019081847.16171-2-phil@nwl.cc>
References: <20171019081847.16171-1-phil@nwl.cc>
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:49454 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752301AbdJSITd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2017 04:19:33 -0400
In-Reply-To: <20171019081847.16171-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft_ctx_free() should not refer to the global 'nft' variable, this will
break as soon as the function is moved away from main.c. In order to use
the cache reference from passed argument, the latter must not be const.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/main.c b/src/main.c
index b59c932ad4299..1b26838058a4a 100644
--- a/src/main.c
+++ b/src/main.c
@@ -305,13 +305,13 @@ static struct nft_ctx *nft_ctx_new(uint32_t flags)
 	return ctx;
 }
 
-static void nft_ctx_free(const struct nft_ctx *ctx)
+static void nft_ctx_free(struct nft_ctx *ctx)
 {
 	if (ctx->nf_sock)
 		netlink_close_sock(ctx->nf_sock);
 
 	iface_cache_release();
-	cache_release(&nft->cache);
+	cache_release(&ctx->cache);
 	xfree(ctx);
 	nft_exit();
 }
-- 
2.13.1

