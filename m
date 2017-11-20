From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] libnftables: Ensure output_fp is never NULL
Date: Mon, 20 Nov 2017 16:54:04 +0100
Message-ID: <20171120155404.10894-1-phil@nwl.cc>
References: <20171120124716.GA17684@salvia>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:42768 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751301AbdKTPyP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Nov 2017 10:54:15 -0500
In-Reply-To: <20171120124716.GA17684@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Initialize output_fp to 'stdout' upon context creation and check output
stream validity in nft_ctx_set_output(). This allows to drop checks in
nft_{gmp_,}print() and do_command_export(). While doing so for the
latter, simplify it a bit by using nft_print() which takes care of
flushing the output stream.

If applications desire to drop all output, they are supposed to open
/dev/null and assign that.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/libnftables.c | 10 ++++------
 src/main.c        |  1 -
 src/rule.c        |  6 +-----
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index e8fa6742f7d17..c86d89477e778 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -167,6 +167,7 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 	ctx->parser_max_errors	= 10;
 	init_list_head(&ctx->cache.list);
 	ctx->flags = flags;
+	ctx->output.output_fp = stdout;
 
 	if (flags == NFT_CTX_DEFAULT)
 		nft_ctx_netlink_init(ctx);
@@ -190,6 +191,9 @@ FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp)
 {
 	FILE *old = ctx->output.output_fp;
 
+	if (!fp || ferror(fp))
+		return NULL;
+
 	ctx->output.output_fp = fp;
 
 	return old;
@@ -333,9 +337,6 @@ int nft_print(struct output_ctx *octx, const char *fmt, ...)
 	int ret;
 	va_list arg;
 
-	if (!octx->output_fp)
-		return -1;
-
 	va_start(arg, fmt);
 	ret = vfprintf(octx->output_fp, fmt, arg);
 	va_end(arg);
@@ -349,9 +350,6 @@ int nft_gmp_print(struct output_ctx *octx, const char *fmt, ...)
 	int ret;
 	va_list arg;
 
-	if (!octx->output_fp)
-		return -1;
-
 	va_start(arg, fmt);
 	ret = gmp_vfprintf(octx->output_fp, fmt, arg);
 	va_end(arg);
diff --git a/src/main.c b/src/main.c
index ff7878c94ccb3..353b87bc66631 100644
--- a/src/main.c
+++ b/src/main.c
@@ -173,7 +173,6 @@ int main(int argc, char * const *argv)
 	int i, val, rc;
 
 	nft = nft_ctx_new(NFT_CTX_DEFAULT);
-	nft_ctx_set_output(nft, stdout);
 
 	while (1) {
 		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
diff --git a/src/rule.c b/src/rule.c
index eb91be4636e21..37d99c2200471 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1153,9 +1153,6 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct nftnl_ruleset *rs;
 	FILE *fp = ctx->octx->output_fp;
 
-	if (!fp)
-		return 0;
-
 	do {
 		rs = netlink_dump_ruleset(ctx, &cmd->handle, &cmd->location);
 		if (rs == NULL && errno != EINTR)
@@ -1163,8 +1160,7 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 	} while (rs == NULL);
 
 	nftnl_ruleset_fprintf(fp, rs, cmd->export->format, 0);
-	fprintf(fp, "\n");
-	fflush(fp);
+	nft_print(ctx->octx, "\n");
 
 	nftnl_ruleset_free(rs);
 	return 0;
-- 
2.13.1

