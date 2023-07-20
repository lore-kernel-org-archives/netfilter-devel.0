Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234FEEB64DC
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jul 2023 14:32:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjGTOcq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jul 2023 10:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjGTOcp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jul 2023 10:32:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285D826A9
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jul 2023 07:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689863519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EgW9mN0afcyZCUinOWWyzTZODZmT0cg/c/a8NvkwCS4=;
        b=JUSI5fqvjGfqBqe3xZAmfoVzeQXW6iSD9sqlThGKjSe4uHG/C44gOHQ0JMNGUqT7B6Fe/n
        K+mD6AcgDQcjHxftjlAv2icklNW7KsHEp0/lBJkry4+DHL+W47xy8OfdpKNx5gwlt1PTyG
        hOD/ajiFkiPuBJmd8Y2WuJdLzRGdbHg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-Dl25A66SOEq9bKyN2KWoHQ-1; Thu, 20 Jul 2023 10:31:57 -0400
X-MC-Unique: Dl25A66SOEq9bKyN2KWoHQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A424856506;
        Thu, 20 Jul 2023 14:31:57 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.210])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A5EE40C206F;
        Thu, 20 Jul 2023 14:31:56 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>
Subject: [nft v3 PATCH 1/4] src: add input flags for nft_ctx
Date:   Thu, 20 Jul 2023 16:27:00 +0200
Message-ID: <20230720143147.669250-2-thaller@redhat.com>
In-Reply-To: <20230720143147.669250-1-thaller@redhat.com>
References: <20230720143147.669250-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Similar to the existing output flags, add input flags. No flags are yet
implemented, that will follow.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 doc/libnftables.adoc           | 12 ++++++++++++
 include/nftables.h             |  5 +++++
 include/nftables/libnftables.h |  3 +++
 src/libnftables.c              | 12 ++++++++++++
 src/libnftables.map            |  5 +++++
 5 files changed, 37 insertions(+)

diff --git a/doc/libnftables.adoc b/doc/libnftables.adoc
index 7ea0d56e9b1d..96a580469ee0 100644
--- a/doc/libnftables.adoc
+++ b/doc/libnftables.adoc
@@ -18,6 +18,9 @@ void nft_ctx_free(struct nft_ctx* '\*ctx'*);
 bool nft_ctx_get_dry_run(struct nft_ctx* '\*ctx'*);
 void nft_ctx_set_dry_run(struct nft_ctx* '\*ctx'*, bool* 'dry'*);
 
+unsigned int nft_ctx_input_get_flags(struct nft_ctx* '\*ctx'*);
+void nft_ctx_input_set_flags(struct nft_ctx* '\*ctx'*, unsigned int* 'flags'*);
+
 unsigned int nft_ctx_output_get_flags(struct nft_ctx* '\*ctx'*);
 void nft_ctx_output_set_flags(struct nft_ctx* '\*ctx'*, unsigned int* 'flags'*);
 
@@ -78,6 +81,15 @@ The *nft_ctx_get_dry_run*() function returns the dry-run setting's value contain
 
 The *nft_ctx_set_dry_run*() function sets the dry-run setting in 'ctx' to the value of 'dry'.
 
+=== nft_ctx_input_get_flags() and nft_ctx_input_set_flags()
+The flags setting controls the input format.
+
+Currently not flags are implemented.
+
+The *nft_ctx_input_get_flags*() function returns the input flags setting's value in 'ctx'.
+
+The *nft_ctx_input_set_flags*() function sets the input flags setting in 'ctx' to the value of 'val'.
+
 === nft_ctx_output_get_flags() and nft_ctx_output_set_flags()
 The flags setting controls the output format.
 
diff --git a/include/nftables.h b/include/nftables.h
index d49eb579dc04..7d35a95a89de 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -23,6 +23,10 @@ struct symbol_tables {
 	const struct symbol_table	*realm;
 };
 
+struct input_ctx {
+	unsigned int flags;
+};
+
 struct output_ctx {
 	unsigned int flags;
 	union {
@@ -119,6 +123,7 @@ struct nft_ctx {
 	unsigned int		num_vars;
 	unsigned int		parser_max_errors;
 	unsigned int		debug_mask;
+	struct input_ctx	input;
 	struct output_ctx	output;
 	bool			check;
 	struct nft_cache	cache;
diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
index 85e08c9bc98b..7fb621be1f12 100644
--- a/include/nftables/libnftables.h
+++ b/include/nftables/libnftables.h
@@ -48,6 +48,9 @@ enum nft_optimize_flags {
 uint32_t nft_ctx_get_optimize(struct nft_ctx *ctx);
 void nft_ctx_set_optimize(struct nft_ctx *ctx, uint32_t flags);
 
+unsigned int nft_ctx_input_get_flags(struct nft_ctx *ctx);
+void nft_ctx_input_set_flags(struct nft_ctx *ctx, unsigned int flags);
+
 enum {
 	NFT_CTX_OUTPUT_REVERSEDNS	= (1 << 0),
 	NFT_CTX_OUTPUT_SERVICE		= (1 << 1),
diff --git a/src/libnftables.c b/src/libnftables.c
index 6fc4f7db6760..6832f0486d6d 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -401,6 +401,18 @@ void nft_ctx_set_optimize(struct nft_ctx *ctx, uint32_t flags)
 	ctx->optimize_flags = flags;
 }
 
+EXPORT_SYMBOL(nft_ctx_input_get_flags);
+unsigned int nft_ctx_input_get_flags(struct nft_ctx *ctx)
+{
+	return ctx->input.flags;
+}
+
+EXPORT_SYMBOL(nft_ctx_input_set_flags);
+void nft_ctx_input_set_flags(struct nft_ctx *ctx, unsigned int flags)
+{
+	ctx->input.flags = flags;
+}
+
 EXPORT_SYMBOL(nft_ctx_output_get_flags);
 unsigned int nft_ctx_output_get_flags(struct nft_ctx *ctx)
 {
diff --git a/src/libnftables.map b/src/libnftables.map
index a46a3ad53ff6..9369f44f3536 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -33,3 +33,8 @@ LIBNFTABLES_3 {
   nft_ctx_set_optimize;
   nft_ctx_get_optimize;
 } LIBNFTABLES_2;
+
+LIBNFTABLES_4 {
+  nft_ctx_input_get_flags;
+  nft_ctx_input_set_flags;
+} LIBNFTABLES_3;
-- 
2.41.0

