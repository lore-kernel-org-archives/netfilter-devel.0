From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH RFC] libnftables: Make output_fp default to /dev/null
Date: Thu, 16 Nov 2017 20:14:15 +0100
Message-ID: <20171116191415.19404-1-phil@nwl.cc>
References: <20171116143224.GA17329@salvia>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:32778 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934801AbdKPTO1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2017 14:14:27 -0500
In-Reply-To: <20171116143224.GA17329@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ensure output_fp is never NULL which allows to drop all respective
checks.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Hi Pablo,

This is how I understood your suggestion to use /dev/null. While
implementing it though, I had an idea for a much simpler solution,
namely just rejecting NULL in nft_set_output() and therefore forcing the
application to deal with opening /dev/null if no output is desired. What
do you think about that?

Cheers, Phil
---
 src/libnftables.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index 9df9658930c39..64b63da7631ff 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -103,6 +103,37 @@ err1:
 	return ret;
 }
 
+static FILE *devnull_fp;
+
+static void devnull_fp_init(void)
+{
+	int fd;
+
+	devnull_fp = fopen("/dev/null", "w");
+	if (devnull_fp)
+		return;
+
+	fprintf(stderr, "Warning: Opening /dev/null failed");
+
+	fd = fileno(stdout);
+	if (fd >= 0)
+		devnull_fp = fdopen(fd, "w");
+
+	if (devnull_fp) {
+		fprintf(stderr, ", falling back to stdout.\n");
+		return;
+	}
+
+	fprintf(stderr, " as well as reopening stdout. Expect problems.\n");
+	devnull_fp = stdout;
+}
+
+static void devnull_fp_exit(void)
+{
+	if (devnull_fp != stdout)
+		fclose(devnull_fp);
+}
+
 static int nft_refcnt;
 static pthread_mutex_t nft_refcnt_mutex = PTHREAD_MUTEX_INITIALIZER;
 
@@ -122,6 +153,7 @@ static void nft_init(void)
 #ifdef HAVE_LIBXTABLES
 	xt_init();
 #endif
+	devnull_fp_init();
 
 unlock:
 	pthread_mutex_unlock(&nft_refcnt_mutex);
@@ -134,6 +166,7 @@ static void nft_exit(void)
 	if (--nft_refcnt)
 		goto unlock;
 
+	devnull_fp_exit();
 	ct_label_table_exit();
 	realm_table_rt_exit();
 	devgroup_table_exit();
@@ -187,6 +220,7 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 	ctx->parser_max_errors	= 10;
 	init_list_head(&ctx->cache.list);
 	ctx->flags = flags;
+	ctx->octx.output_fp = devnull_fp;
 
 	if (flags == NFT_CTX_DEFAULT)
 		nft_ctx_netlink_init(ctx);
@@ -210,9 +244,9 @@ FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp)
 {
 	FILE *old = ctx->output.output_fp;
 
-	ctx->output.output_fp = fp;
+	ctx->output.output_fp = fp ?: devnull_fp;
 
-	return old;
+	return old == devnull_fp ? NULL : old;
 }
 
 bool nft_ctx_get_dry_run(struct nft_ctx *ctx)
-- 
2.13.1

