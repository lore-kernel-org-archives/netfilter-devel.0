Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D308EEB64DC
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jul 2023 14:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbjGTOcw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jul 2023 10:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjGTOcv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jul 2023 10:32:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A72426AC
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jul 2023 07:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689863523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=051AwssLUwkUR9Cvm44K2UV2wpr4fI6ITILlA5ifiyg=;
        b=YpOVAgMNqv4xHYnzkI3rLjUap46UErS6DBEeRwVoyG7hB9m5KQiooAOnNpvBfdmddBwQpS
        jycEiTDSSVyd9hmEzAP9Dfiglz1g5/rkbMy41Fl0LNLZ3jIn9576rUSNL0fy/IYsRGlIj7
        2gYYqWnwXGXP3WJgHSvyHn+d7CPGlSw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-309HrZm5MM6wBmBvo9dWRQ-1; Thu, 20 Jul 2023 10:31:59 -0400
X-MC-Unique: 309HrZm5MM6wBmBvo9dWRQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C932104458D;
        Thu, 20 Jul 2023 14:31:59 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.210])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C34840C2070;
        Thu, 20 Jul 2023 14:31:58 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>
Subject: [nft v3 PATCH 3/4] src: add input flag NFT_CTX_INPUT_JSON to enable JSON parsing
Date:   Thu, 20 Jul 2023 16:27:02 +0200
Message-ID: <20230720143147.669250-4-thaller@redhat.com>
In-Reply-To: <20230720143147.669250-1-thaller@redhat.com>
References: <20230720143147.669250-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

By default, the input is parsed using the nftables grammar. When setting
NFT_CTX_OUTPUT_JSON flag, nftables will first try to parse the input as
JSON before falling back to the nftables grammar.

But NFT_CTX_OUTPUT_JSON flag also turns on JSON for the output. Add a
flag NFT_CTX_INPUT_JSON which allows to treat only the input in JSON
format, but keep the output mode unchanged.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 doc/libnftables.adoc           | 6 ++++++
 include/nftables/libnftables.h | 1 +
 src/libnftables.c              | 6 ++++--
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/doc/libnftables.adoc b/doc/libnftables.adoc
index 77f3a0fd5659..27e230281edb 100644
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
 
 The *nft_ctx_input_set_flags*() function sets the input flags setting in 'ctx' to the value of 'val'.
diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
index 2f5f079efff0..152c7a5b75da 100644
--- a/include/nftables/libnftables.h
+++ b/include/nftables/libnftables.h
@@ -50,6 +50,7 @@ void nft_ctx_set_optimize(struct nft_ctx *ctx, uint32_t flags);
 
 enum {
 	NFT_CTX_INPUT_NO_DNS		= (1 << 0),
+	NFT_CTX_INPUT_JSON		= (1 << 1),
 };
 
 unsigned int nft_ctx_input_get_flags(struct nft_ctx *ctx);
diff --git a/src/libnftables.c b/src/libnftables.c
index 6832f0486d6d..a2e0ae6b5843 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -578,7 +578,8 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 	nlbuf = xzalloc(strlen(buf) + 2);
 	sprintf(nlbuf, "%s\n", buf);
 
-	if (nft_output_json(&nft->output))
+	if (nft_output_json(&nft->output) ||
+	    (nft_ctx_input_get_flags(nft) & NFT_CTX_INPUT_JSON))
 		rc = nft_parse_json_buffer(nft, nlbuf, &msgs, &cmds);
 	if (rc == -EINVAL)
 		rc = nft_parse_bison_buffer(nft, nlbuf, &msgs, &cmds,
@@ -677,7 +678,8 @@ static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename
 		goto err;
 
 	rc = -EINVAL;
-	if (nft_output_json(&nft->output))
+	if (nft_output_json(&nft->output) ||
+	    (nft_ctx_input_get_flags(nft) & NFT_CTX_INPUT_JSON))
 		rc = nft_parse_json_filename(nft, filename, &msgs, &cmds);
 	if (rc == -EINVAL)
 		rc = nft_parse_bison_filename(nft, filename, &msgs, &cmds);
-- 
2.41.0

