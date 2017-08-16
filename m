From: Eric Leblond <eric@regit.org>
Subject: [nft PATH 11/16] libnftables: add nft_context_set_print
Date: Wed, 16 Aug 2017 22:43:05 +0200
Message-ID: <20170816204310.3371-12-eric@regit.org>
References: <20170816204310.3371-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:40710 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752678AbdHPVZi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2017 17:25:38 -0400
In-Reply-To: <20170816204310.3371-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This function allows user to set his own printing function. It is
still dependant of the format used by nft but at least it can be
redirected easily.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/nftables/nftables.h | 3 +++
 src/libnftables.c           | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index b902cbd..935d0db 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -26,6 +26,9 @@ void nft_global_deinit(void);
 
 struct nft_ctx *nft_context_new(void);
 void nft_context_free(struct nft_ctx *nft);
+void nft_context_set_print_func(struct nft_ctx *nft,
+				int (*print)(void *ctx, const char *fmt, ...),
+				void *ctx);
 
 int nft_run_command_from_buffer(struct nft_ctx *nft,
 				char *buf, size_t buflen);
diff --git a/src/libnftables.c b/src/libnftables.c
index 356e9c4..494ff57 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -86,6 +86,15 @@ struct nft_ctx *nft_context_new(void)
 	return ctx;
 }
 
+void nft_context_set_print_func(struct nft_ctx *nft,
+				int (*print)(void *ctx, const char *fmt, ...),
+				void *ctx)
+{
+	if (nft) {
+		nft->output.print = print;
+		nft->output.ctx = ctx;
+	}
+}
 
 void nft_context_free(struct nft_ctx *nft)
 {
-- 
2.14.1

