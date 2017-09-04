From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH v2 1/2] src: add flags fo nft_ctx_new
Date: Mon,  4 Sep 2017 09:55:57 +0200
Message-ID: <20170904075558.10129-2-eric@regit.org>
References: <20170903223441.GB12383@salvia>
 <20170904075558.10129-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:45422 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751949AbdIDH4R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2017 03:56:17 -0400
In-Reply-To: <20170904075558.10129-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

By adding flags to nft_ctx_new, we will have a minimum capabilities
of changing the way the nft_ctx is created.

For now, this patch uses a simple value that allow the user to specify
that he will handle netlink by himself.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/nftables.h |  3 +++
 src/main.c         | 20 +++++++++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 5035567..3429e4c 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -49,8 +49,11 @@ struct nft_ctx {
 	struct output_ctx	output;
 	bool			check;
 	struct nft_cache	cache;
+	uint32_t		flags;
 };
 
+#define NFT_CTX_DEFAULT		0
+
 enum nftables_exit_codes {
 	NFT_EXIT_SUCCESS	= 0,
 	NFT_EXIT_FAILURE	= 1,
diff --git a/src/main.c b/src/main.c
index fce9bfe..702ef30 100644
--- a/src/main.c
+++ b/src/main.c
@@ -281,7 +281,12 @@ static void nft_exit(void)
 	mark_table_exit();
 }
 
-static struct nft_ctx *nft_ctx_new(void)
+static void nft_ctx_netlink_init(struct nft_ctx *ctx)
+{
+	ctx->nf_sock = netlink_open_sock();
+}
+
+static struct nft_ctx *nft_ctx_new(uint32_t flags)
 {
 	struct nft_ctx *ctx;
 
@@ -292,6 +297,10 @@ static struct nft_ctx *nft_ctx_new(void)
 	ctx->num_include_paths	= 1;
 	ctx->parser_max_errors	= 10;
 	init_list_head(&ctx->cache.list);
+	ctx->flags = flags;
+
+	if (flags == NFT_CTX_DEFAULT)
+		nft_ctx_netlink_init(ctx);
 
 	return ctx;
 }
@@ -307,11 +316,6 @@ static void nft_ctx_free(const struct nft_ctx *ctx)
 	nft_exit();
 }
 
-static void nft_ctx_netlink_init(struct nft_ctx *ctx)
-{
-	ctx->nf_sock = netlink_open_sock();
-}
-
 static int nft_run_cmd_from_buffer(struct nft_ctx *nft,
 				   char *buf, size_t buflen)
 {
@@ -367,9 +371,7 @@ int main(int argc, char * const *argv)
 	struct parser_state state;
 	int i, val, rc;
 
-	nft = nft_ctx_new();
-
-	nft_ctx_netlink_init(nft);
+	nft = nft_ctx_new(NFT_CTX_DEFAULT);
 
 	while (1) {
 		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
-- 
2.14.1

