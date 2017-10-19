From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 3/7] libnftables: Introduce nft_ctx_flush_cache()
Date: Thu, 19 Oct 2017 10:18:43 +0200
Message-ID: <20171019081847.16171-4-phil@nwl.cc>
References: <20171019081847.16171-1-phil@nwl.cc>
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:49404 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751908AbdJSITF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2017 04:19:05 -0400
In-Reply-To: <20171019081847.16171-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows an application to explicitly flush caches associated with a
given nft context.

Note that this is a bit inconsistent in that it releases the global
interface cache, but nft_ctx_free() does the same so at least it's not a
regression.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/nftables/nftables.h | 1 +
 src/libnftables.c           | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index 052a77bfb5371..fbc6fd4252a97 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -77,6 +77,7 @@ enum nftables_exit_codes {
 struct nft_ctx *nft_ctx_new(uint32_t flags);
 void nft_ctx_free(struct nft_ctx *ctx);
 FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp);
+void nft_ctx_flush_cache(struct nft_ctx *ctx);
 
 int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
 	    void *scanner, struct parser_state *state,
diff --git a/src/libnftables.c b/src/libnftables.c
index 187747c66af21..0de50c854d572 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -146,13 +146,18 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 	return ctx;
 }
 
+void nft_ctx_flush_cache(struct nft_ctx *ctx)
+{
+	iface_cache_release();
+	cache_release(&ctx->cache);
+}
+
 void nft_ctx_free(struct nft_ctx *ctx)
 {
 	if (ctx->nf_sock)
 		netlink_close_sock(ctx->nf_sock);
 
-	iface_cache_release();
-	cache_release(&ctx->cache);
+	nft_ctx_flush_cache(ctx);
 	xfree(ctx);
 	nft_exit();
 }
-- 
2.13.1

