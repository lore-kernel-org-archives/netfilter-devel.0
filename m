Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 675EFC001DE
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 09:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359326AbjHRJpE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 05:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359336AbjHRJoj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 05:44:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37EB2705
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 02:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692351830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kepEqimQDGObcMmOOG7VgmG9GCm+s10jW0LR8HeRQLM=;
        b=OByBxNVjXnKZUqfwE5tUTghFGl5PPDBJ3QU0mWHrLEjPBacrpmEyTMoCr/45lkRpN5zbA6
        zhc0RUhNf6fT++lTVVJaWHbu4zUkmkAqD+j8rywqvTUEGjMtVWWqNriYdFhKXASx+G+uVI
        d1NdjFTfhc1aqNPGF38owXwya1YxgMY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-m7a5nFarOi-9lYshpngHaQ-1; Fri, 18 Aug 2023 05:43:48 -0400
X-MC-Unique: m7a5nFarOi-9lYshpngHaQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 755E880006E;
        Fri, 18 Aug 2023 09:43:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C8A1940C6F4E;
        Fri, 18 Aug 2023 09:43:47 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>, Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v5 3/6] src: add input flag NFT_CTX_INPUT_JSON to enable JSON parsing
Date:   Fri, 18 Aug 2023 11:40:38 +0200
Message-ID: <20230818094335.535872-4-thaller@redhat.com>
In-Reply-To: <20230818094335.535872-1-thaller@redhat.com>
References: <20230818094335.535872-1-thaller@redhat.com>
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
Reviewed-by: Phil Sutter <phil@nwl.cc>
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

