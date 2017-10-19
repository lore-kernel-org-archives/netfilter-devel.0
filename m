From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 5/7] libnftables: Introduce nft_ctx_set_dry_run()
Date: Thu, 19 Oct 2017 10:18:45 +0200
Message-ID: <20171019081847.16171-6-phil@nwl.cc>
References: <20171019081847.16171-1-phil@nwl.cc>
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:49434 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752181AbdJSITV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2017 04:19:21 -0400
In-Reply-To: <20171019081847.16171-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Provide a convenient interface to configure dry run mode.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/nftables/nftables.h | 3 +++
 src/libnftables.c           | 5 +++++
 src/main.c                  | 2 +-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index b91219d423df9..f0c9bbf3ba3fe 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -75,7 +75,10 @@ enum nftables_exit_codes {
 
 struct nft_ctx *nft_ctx_new(uint32_t flags);
 void nft_ctx_free(struct nft_ctx *ctx);
+
 FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp);
+void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry);
+
 void nft_ctx_flush_cache(struct nft_ctx *ctx);
 
 int nft_run_cmd_from_buffer(struct nft_ctx *nft, char *buf, size_t buflen);
diff --git a/src/libnftables.c b/src/libnftables.c
index d88c299c3647e..817f537e32618 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -171,6 +171,11 @@ FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp)
 	return old;
 }
 
+void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry)
+{
+	ctx->check = dry;
+}
+
 static const struct input_descriptor indesc_cmdline = {
 	.type	= INDESC_BUFFER,
 	.name	= "<cmdline>",
diff --git a/src/main.c b/src/main.c
index 3c107181305c7..8359367b78654 100644
--- a/src/main.c
+++ b/src/main.c
@@ -187,7 +187,7 @@ int main(int argc, char * const *argv)
 			       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME);
 			exit(NFT_EXIT_SUCCESS);
 		case OPT_CHECK:
-			nft->check = true;
+			nft_ctx_set_dry_run(nft, true);
 			break;
 		case OPT_FILE:
 			filename = optarg;
-- 
2.13.1

