Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6458DC4320A
	for <netfilter-devel@archiver.kernel.org>; Sat, 24 Jul 2021 10:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EF6760E53
	for <netfilter-devel@archiver.kernel.org>; Sat, 24 Jul 2021 10:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbhGXJrx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 24 Jul 2021 05:47:53 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58440 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234924AbhGXJrw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 24 Jul 2021 05:47:52 -0400
Received: from localhost.localdomain (unknown [78.30.39.111])
        by mail.netfilter.org (Postfix) with ESMTPSA id 06EAE642A3
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Jul 2021 12:27:56 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] src: expose nft_ctx_clear_vars as API
Date:   Sat, 24 Jul 2021 12:28:24 +0200
Message-Id: <20210724102824.28011-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210724102824.28011-1-pablo@netfilter.org>
References: <20210724102824.28011-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This function might be useful to recycle the existing nft_ctx to use it
with different external variables definition.

Moreover, reset ctx->num_vars to zero.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/nftables/libnftables.h | 1 +
 src/libnftables.c              | 4 +++-
 src/libnftables.map            | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
index aaf7388e6db2..8e7151a324b0 100644
--- a/include/nftables/libnftables.h
+++ b/include/nftables/libnftables.h
@@ -79,6 +79,7 @@ int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path);
 void nft_ctx_clear_include_paths(struct nft_ctx *ctx);
 
 int nft_ctx_add_var(struct nft_ctx *ctx, const char *var);
+void nft_ctx_clear_vars(struct nft_ctx *ctx);
 
 int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf);
 int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename);
diff --git a/src/libnftables.c b/src/libnftables.c
index de6dc7cdae6c..aa6493aae119 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -145,7 +145,8 @@ int nft_ctx_add_var(struct nft_ctx *ctx, const char *var)
 	return 0;
 }
 
-static void nft_ctx_clear_vars(struct nft_ctx *ctx)
+EXPORT_SYMBOL(nft_ctx_clear_vars);
+void nft_ctx_clear_vars(struct nft_ctx *ctx)
 {
 	unsigned int i;
 
@@ -153,6 +154,7 @@ static void nft_ctx_clear_vars(struct nft_ctx *ctx)
 		xfree(ctx->vars[i].key);
 		xfree(ctx->vars[i].value);
 	}
+	ctx->num_vars = 0;
 	xfree(ctx->vars);
 }
 
diff --git a/src/libnftables.map b/src/libnftables.map
index 46d64a38e6e0..d3a795ce8567 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -26,4 +26,5 @@ local: *;
 
 LIBNFTABLES_2 {
   nft_ctx_add_var;
+  nft_ctx_clear_vars;
 } LIBNFTABLES_1;
-- 
2.20.1

