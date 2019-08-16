Return-Path: <SRS0=Eqja=WM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16BBC3A59C
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 14:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0FCE206C1
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 14:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfHPOoz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Aug 2019 10:44:55 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46172 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727245AbfHPOoz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Aug 2019 10:44:55 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hydTJ-0002nl-MP; Fri, 16 Aug 2019 16:44:53 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 2/8] src: libnftnl: split nft_ctx_new/free
Date:   Fri, 16 Aug 2019 16:42:35 +0200
Message-Id: <20190816144241.11469-3-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190816144241.11469-1-fw@strlen.de>
References: <20190816144241.11469-1-fw@strlen.de>
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
 src/libnftables.c  | 32 ++++++++++++++++++++++----------
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index ef737c839b2e..b7fbcf5726d4 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -201,6 +201,9 @@ int nft_print(struct output_ctx *octx, const char *fmt, ...)
 int nft_gmp_print(struct output_ctx *octx, const char *fmt, ...)
 	__attribute__((format(printf, 2, 0)));
 
+struct nft_ctx *__nft_ctx_new(void);
+void __nft_ctx_free(struct nft_ctx *ctx);
+
 #define __NFT_OUTPUT_NOTSUPP	UINT_MAX
 
 #endif /* NFTABLES_NFTABLES_H */
diff --git a/src/libnftables.c b/src/libnftables.c
index b169dd2f2afe..a1e2fd662a7a 100644
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
@@ -149,18 +148,26 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 	}
 
 	ctx = xzalloc(sizeof(struct nft_ctx));
-	nft_init(ctx);
 
 	ctx->state = xzalloc(sizeof(struct parser_state));
 	nft_ctx_add_include_path(ctx, DEFAULT_INCLUDE_PATH);
-	ctx->parser_max_errors	= 10;
 	init_list_head(&ctx->cache.list);
-	ctx->flags = flags;
 	ctx->output.output_fp = stdout;
 	ctx->output.error_fp = stderr;
 
-	if (flags == NFT_CTX_DEFAULT)
-		nft_ctx_netlink_init(ctx);
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
+	ctx->parser_max_errors	= 10;
+	ctx->flags = flags;
+	nft_ctx_netlink_init(ctx);
 
 	return ctx;
 }
@@ -281,20 +288,25 @@ const char *nft_ctx_get_error_buffer(struct nft_ctx *ctx)
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
 	xfree(ctx->state);
 	xfree(ctx);
+}
+
+EXPORT_SYMBOL(nft_ctx_free);
+void nft_ctx_free(struct nft_ctx *ctx)
+{
 	nft_exit(ctx);
+	__nft_ctx_free(ctx);
+	iface_cache_release();
 }
 
 EXPORT_SYMBOL(nft_ctx_set_output);
-- 
2.21.0

