Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 005DCEB64DA
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jul 2023 08:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235458AbjGNIur (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Jul 2023 04:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235439AbjGNIup (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Jul 2023 04:50:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9776F2683
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jul 2023 01:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689324597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=idTF4MRPZQbfHMjwZygrJuLD0oISKUhQSrsHPW/Cfb0=;
        b=NDjyN44jcRFmlPfKs6bxXR1XKikhjDqroUVG6yR+UwNh9vj9WbnZxo+WIusK+Em+GTv95T
        N1dC9CGX7+ngC303aRpvu6LKt1IA52ceZn1LdnFeZ+a9xEYC6MQMHAhPtT7AYlQLL/unNh
        auuOYxkUKpCgCaKLDapC8juM+pkDgYg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-vAnvu1zmN8-b5c5dzE8CAA-1; Fri, 14 Jul 2023 04:49:55 -0400
X-MC-Unique: vAnvu1zmN8-b5c5dzE8CAA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 934CC8D1692;
        Fri, 14 Jul 2023 08:49:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.135])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B8D7E492B01;
        Fri, 14 Jul 2023 08:49:54 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Thomas Haller <thaller@redhat.com>
Subject: [nft v2 PATCH 1/3] nftables: add input flags for nft_ctx
Date:   Fri, 14 Jul 2023 10:48:51 +0200
Message-ID: <20230714084943.1080757-1-thaller@redhat.com>
In-Reply-To: <ZKxG23yJzlRRPpsO@calendula>
References: <ZKxG23yJzlRRPpsO@calendula>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
 py/nftables.py                 |  7 +++++++
 src/libnftables.c              | 12 ++++++++++++
 src/libnftables.map            |  5 +++++
 6 files changed, 44 insertions(+)

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
diff --git a/py/nftables.py b/py/nftables.py
index 6daeafc231f4..b9fa63bb8789 100644
--- a/py/nftables.py
+++ b/py/nftables.py
@@ -82,6 +82,13 @@ class Nftables:
         self.nft_ctx_new.restype = c_void_p
         self.nft_ctx_new.argtypes = [c_int]
 
+        self.nft_ctx_input_get_flags = lib.nft_ctx_input_get_flags
+        self.nft_ctx_input_get_flags.restype = c_uint
+        self.nft_ctx_input_get_flags.argtypes = [c_void_p]
+
+        self.nft_ctx_input_set_flags = lib.nft_ctx_input_set_flags
+        self.nft_ctx_input_set_flags.argtypes = [c_void_p, c_uint]
+
         self.nft_ctx_output_get_flags = lib.nft_ctx_output_get_flags
         self.nft_ctx_output_get_flags.restype = c_uint
         self.nft_ctx_output_get_flags.argtypes = [c_void_p]
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

