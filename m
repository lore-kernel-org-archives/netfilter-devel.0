From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 2/4] libnftables: Introduce nft_ctx_flush_cache()
Date: Mon, 23 Oct 2017 17:33:17 +0200
Message-ID: <20171023153319.13415-3-phil@nwl.cc>
References: <20171023153319.13415-1-phil@nwl.cc>
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:60862 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932102AbdJWPdv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2017 11:33:51 -0400
In-Reply-To: <20171023153319.13415-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows an application to explicitly flush caches associated with a
given nft context, as seen in cli_complete().

Note that this is a bit inconsistent in that it releases the global
interface cache, but nft_ctx_free() does the same so at least it's not a
regression.

Note that there is no need for explicit cache update routine since cache
is populated during command execution depending on whether it is needed
or not.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/nftables/nftables.h | 1 +
 src/cli.c                   | 3 +--
 src/libnftables.c           | 9 +++++++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index 44d3e95d399e6..1207f10cd2457 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -51,6 +51,7 @@ enum nftables_exit_codes {
 struct nft_ctx *nft_ctx_new(uint32_t flags);
 void nft_ctx_free(struct nft_ctx *ctx);
 FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp);
+void nft_ctx_flush_cache(struct nft_ctx *ctx);
 
 int nft_run_cmd_from_buffer(struct nft_ctx *nft, char *buf, size_t buflen);
 int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename);
diff --git a/src/cli.c b/src/cli.c
index cadc3af6e8034..3174cfed05a7d 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -140,8 +140,7 @@ static void cli_complete(char *line)
 	nft_run(cli_nft, cli_nf_sock, scanner, state, &msgs);
 	erec_print_list(&cli_nft->output, &msgs, cli_nft->debug_mask);
 	xfree(line);
-	cache_release(&cli_nft->cache);
-	iface_cache_release();
+	nft_ctx_flush_cache(cli_nft);
 }
 
 static char **cli_completion(const char *text, int start, int end)
diff --git a/src/libnftables.c b/src/libnftables.c
index 9bc51dd894d09..d34e52759e947 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -147,13 +147,18 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
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

