Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C86C00528
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Aug 2023 19:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjHCTmQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 15:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjHCTmP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 15:42:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0643C3B
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2023 12:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691091687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aJgkYWcB3ciFlrEu0Txzt4sIew60LR1ujOAlWE8mJpo=;
        b=GcE4SoxVpv/lwBkX4hWNEhGU/gORfNCNF99I0ssp2M8SbX5UG4IYPYU8Q6hddxsxyolJCf
        01P5D4j2FyaUMxISewwnD56WGtJIqWJHAdE0aNZehj/dOUCOgyGDqhFIloRUvMd5IxjZkE
        1kgsxKKpRhKtoQ9jL9XnPqQJHs36+lo=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-dFWCNEJDOeKraD0If7XR2Q-1; Thu, 03 Aug 2023 15:41:24 -0400
X-MC-Unique: dFWCNEJDOeKraD0If7XR2Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B6473C13938;
        Thu,  3 Aug 2023 19:41:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.144])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B3FA24021520;
        Thu,  3 Aug 2023 19:41:22 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Phil Sutter <phil@nwl.cc>, Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH v4 3/6] src: add input flag NFT_CTX_INPUT_JSON to enable JSON parsing
Date:   Thu,  3 Aug 2023 21:35:18 +0200
Message-ID: <20230803193940.1105287-7-thaller@redhat.com>
In-Reply-To: <20230803193940.1105287-1-thaller@redhat.com>
References: <20230803193940.1105287-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

By default, the input is parsed using the nftables grammar. When setting
NFT_CTX_OUTPUT_JSON flag, nftables will first try to parse the input as
JSON before falling back to the nftables grammar.

But NFT_CTX_OUTPUT_JSON flag also turns on JSON for the output. Add a
flag NFT_CTX_INPUT_JSON which allows to treat only the input as JSON,
but keep the output mode unchanged.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 doc/libnftables.adoc           | 9 ++++++++-
 include/nftables.h             | 5 +++++
 include/nftables/libnftables.h | 1 +
 src/libnftables.c              | 4 ++--
 4 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/doc/libnftables.adoc b/doc/libnftables.adoc
index 62de75f3fa22..2cf78d7ae536 100644
--- a/doc/libnftables.adoc
+++ b/doc/libnftables.adoc
@@ -87,6 +87,7 @@ The flags setting controls the input format.
 ----
 enum {
         NFT_CTX_INPUT_NO_DNS = (1 << 0),
+        NFT_CTX_INPUT_JSON   = (1 << 1),
 };
 ----
 
@@ -94,6 +95,11 @@ NFT_CTX_INPUT_NO_DNS::
 	Avoid resolving IP addresses with blocking getaddrinfo(). In that case,
 	only plain IP addresses are accepted.
 
+NFT_CTX_INPUT_JSON:
+	When parsing the input, first try to interpret the input as JSON before
+	falling back to the nftables format. This behavior is implied when setting
+	the NFT_CTX_OUTPUT_JSON flag.
+
 The *nft_ctx_input_get_flags*() function returns the input flags setting's value in 'ctx'.
 
 The *nft_ctx_input_set_flags*() function sets the input flags setting in 'ctx' to the value of 'val'
@@ -139,7 +145,8 @@ NFT_CTX_OUTPUT_HANDLE::
 NFT_CTX_OUTPUT_JSON::
 	If enabled at compile-time, libnftables accepts input in JSON format and is able to print output in JSON format as well.
 	See *libnftables-json*(5) for a description of the supported schema.
-	This flag controls JSON output format, input is auto-detected.
+	This flag enables JSON output format. If the flag is set, the input will first be tried as JSON format,
+	before falling back to nftables format. This flag implies NFT_CTX_INPUT_JSON.
 NFT_CTX_OUTPUT_ECHO::
 	The echo setting makes libnftables print the changes once they are committed to the kernel, just like a running instance of *nft monitor* would.
 	Amongst other things, this allows one to retrieve an added rule's handle atomically.
diff --git a/include/nftables.h b/include/nftables.h
index 666a17ae4dab..f073fa95a60d 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -32,6 +32,11 @@ static inline bool nft_input_no_dns(const struct input_ctx *ictx)
 	return ictx->flags & NFT_CTX_INPUT_NO_DNS;
 }
 
+static inline bool nft_input_json(const struct input_ctx *ictx)
+{
+	return ictx->flags & NFT_CTX_INPUT_JSON;
+}
+
 struct output_ctx {
 	unsigned int flags;
 	union {
diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
index e109805f32a1..cc05969215bc 100644
--- a/include/nftables/libnftables.h
+++ b/include/nftables/libnftables.h
@@ -50,6 +50,7 @@ void nft_ctx_set_optimize(struct nft_ctx *ctx, uint32_t flags);
 
 enum {
 	NFT_CTX_INPUT_NO_DNS		= (1 << 0),
+	NFT_CTX_INPUT_JSON		= (1 << 1),
 };
 
 unsigned int nft_ctx_input_get_flags(struct nft_ctx *ctx);
diff --git a/src/libnftables.c b/src/libnftables.c
index 17438b5330cb..69ea9d4135b7 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -582,7 +582,7 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 	nlbuf = xzalloc(strlen(buf) + 2);
 	sprintf(nlbuf, "%s\n", buf);
 
-	if (nft_output_json(&nft->output))
+	if (nft_output_json(&nft->output) || nft_input_json(&nft->input))
 		rc = nft_parse_json_buffer(nft, nlbuf, &msgs, &cmds);
 	if (rc == -EINVAL)
 		rc = nft_parse_bison_buffer(nft, nlbuf, &msgs, &cmds,
@@ -683,7 +683,7 @@ static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename
 		goto err;
 
 	rc = -EINVAL;
-	if (nft_output_json(&nft->output))
+	if (nft_output_json(&nft->output) || nft_input_json(&nft->input))
 		rc = nft_parse_json_filename(nft, filename, &msgs, &cmds);
 	if (rc == -EINVAL)
 		rc = nft_parse_bison_filename(nft, filename, &msgs, &cmds);
-- 
2.41.0

