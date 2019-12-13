Return-Path: <SRS0=a9hH=2D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00808C341D4
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F9FC246B1
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbfLMQD5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 11:03:57 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40334 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728142AbfLMQD4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 11:03:56 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ifnQ3-0004Cy-Ah; Fri, 13 Dec 2019 17:03:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2 02/11] libnftnl: split nft_ctx_new/free
Date:   Fri, 13 Dec 2019 17:03:36 +0100
Message-Id: <20191213160345.30057-3-fw@strlen.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213160345.30057-1-fw@strlen.de>
References: <20191213160345.30057-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

a followup patch doesn't need e.g. symbol files to be loaded,
so split those functions to create a helper that can be used
internally by nft to create a more minimal nft context.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/nftables.h |  3 +++
 src/libnftables.c  | 33 ++++++++++++++++++++++++---------
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 90d331960ef2..503adf0ca1cc 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -213,6 +213,9 @@ int nft_print(struct output_ctx *octx, const char *fmt, ...)
 int nft_gmp_print(struct output_ctx *octx, const char *fmt, ...)
 	__attribute__((format(printf, 2, 0)));
 
+struct nft_ctx *__nft_ctx_new(void);
+void __nft_ctx_free(struct nft_ctx *ctx);
+
 #define __NFT_OUTPUT_NOTSUPP	UINT_MAX
 
 #endif /* NFTABLES_NFTABLES_H */
diff --git a/src/libnftables.c b/src/libnftables.c
index cd2fcf2fd522..3c0d3a18ffe5 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -134,8 +134,7 @@ static void nft_ctx_netlink_init(struct nft_ctx *ctx)
 	ctx->nf_sock = nft_mnl_socket_open();
 }
 
-EXPORT_SYMBOL(nft_ctx_new);
-struct nft_ctx *nft_ctx_new(uint32_t flags)
+struct nft_ctx *__nft_ctx_new(void)
 {
 	static bool init_once;
 	struct nft_ctx *ctx;
@@ -149,17 +148,27 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 	}
 
 	ctx = xzalloc(sizeof(struct nft_ctx));
-	nft_init(ctx);
 
 	ctx->state = xzalloc(sizeof(struct parser_state));
 	nft_ctx_add_include_path(ctx, DEFAULT_INCLUDE_PATH);
-	ctx->parser_max_errors	= 10;
 	init_list_head(&ctx->cache.list);
 	ctx->top_scope = scope_alloc();
-	ctx->flags = flags;
 	ctx->output.output_fp = stdout;
 	ctx->output.error_fp = stderr;
 
+	return ctx;
+}
+
+EXPORT_SYMBOL(nft_ctx_new);
+struct nft_ctx *nft_ctx_new(uint32_t flags)
+{
+	struct nft_ctx *ctx = __nft_ctx_new();
+
+	nft_init(ctx);
+
+	ctx->parser_max_errors = 10;
+	ctx->flags = flags;
+
 	if (flags == NFT_CTX_DEFAULT)
 		nft_ctx_netlink_init(ctx);
 
@@ -282,23 +291,29 @@ const char *nft_ctx_get_error_buffer(struct nft_ctx *ctx)
 	return get_cookie_buffer(&ctx->output.error_cookie);
 }
 
-EXPORT_SYMBOL(nft_ctx_free);
-void nft_ctx_free(struct nft_ctx *ctx)
+void __nft_ctx_free(struct nft_ctx *ctx)
 {
 	if (ctx->nf_sock)
 		mnl_socket_close(ctx->nf_sock);
 
 	exit_cookie(&ctx->output.output_cookie);
 	exit_cookie(&ctx->output.error_cookie);
-	iface_cache_release();
 	cache_release(&ctx->cache);
 	nft_ctx_clear_include_paths(ctx);
 	scope_free(ctx->top_scope);
 	xfree(ctx->state);
-	nft_exit(ctx);
+
 	xfree(ctx);
 }
 
+EXPORT_SYMBOL(nft_ctx_free);
+void nft_ctx_free(struct nft_ctx *ctx)
+{
+	nft_exit(ctx);
+	__nft_ctx_free(ctx);
+	iface_cache_release();
+}
+
 EXPORT_SYMBOL(nft_ctx_set_output);
 FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp)
 {
-- 
2.23.0

