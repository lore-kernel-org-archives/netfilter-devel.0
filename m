Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA083EE49A3
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 13:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245120AbjHYNbQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Aug 2023 09:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245123AbjHYNao (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2023 09:30:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86ACE1FF6
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 06:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692970195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fUy8wbGjbDCvWCgHHM8h/nJIHrJRjdw+UPs0RJEb0ao=;
        b=MHg4CJQ/JXz5ank1K+HmRrrur5L2ACAqdOYspH5IzVOZvLdsbdaRyUOXOtmEGB9Cy6UIPO
        VQZSDrrWL8BDMs0VumU09eA2agT9Q1QPkOkreUGwi2QU14Lqk6GyYlwRTdGBZ0SCZ4eWyq
        h9Gnh9UIN8TKO9dA+usbjZvgrmY+1HQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-8IInivqmOQygfqRv-ZD-xg-1; Fri, 25 Aug 2023 09:29:54 -0400
X-MC-Unique: 8IInivqmOQygfqRv-ZD-xg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E516185A793
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 13:29:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A08AB2166B26;
        Fri, 25 Aug 2023 13:29:53 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/4] src: add ops_cache struct for caching information during parsing
Date:   Fri, 25 Aug 2023 15:24:18 +0200
Message-ID: <20230825132942.2733840-3-thaller@redhat.com>
In-Reply-To: <20230825132942.2733840-1-thaller@redhat.com>
References: <20230825132942.2733840-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The "ops_cache" will be used for caching the current timestamp
(time(NULL)) for the duration of one operation. It will ensure that all
decisions regarding the time, are based on the same timestamp.

Add the struct for that. The content will be added next.

There is already "struct nft_cache", but that seems to have a
different purpose. Hence, instead of extending "struct nft_cache",
add a new "struct ops_cache".

The difficulty is invalidating the cache and find the right places
to call nft_ctx_reset_ops_cache().

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/datatype.h |  8 ++++++++
 include/nftables.h |  3 +++
 src/evaluate.c     |  5 +++--
 src/libnftables.c  | 17 +++++++++++++++++
 4 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 9ce7359cd340..79d996edd348 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -120,6 +120,13 @@ enum byteorder {
 
 struct expr;
 
+struct ops_cache {
+};
+
+#define CTX_CACHE_INIT() \
+	{ \
+	}
+
 /**
  * enum datatype_flags
  *
@@ -182,6 +189,7 @@ struct datatype *dtype_clone(const struct datatype *orig_dtype);
 struct parse_ctx {
 	struct symbol_tables	*tbl;
 	const struct input_ctx	*input;
+	struct ops_cache	*ops_cache;
 };
 
 extern struct error_record *symbol_parse(struct parse_ctx *ctx,
diff --git a/include/nftables.h b/include/nftables.h
index 219a10100206..b0a7f2f874ca 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -6,6 +6,7 @@
 #include <utils.h>
 #include <cache.h>
 #include <nftables/libnftables.h>
+#include <datatype.h>
 
 struct cookie {
 	FILE *fp;
@@ -47,6 +48,7 @@ struct output_ctx {
 		struct cookie error_cookie;
 	};
 	struct symbol_tables tbl;
+	struct ops_cache *ops_cache;
 };
 
 static inline bool nft_output_reversedns(const struct output_ctx *octx)
@@ -136,6 +138,7 @@ struct nft_ctx {
 	struct output_ctx	output;
 	bool			check;
 	struct nft_cache	cache;
+	struct ops_cache	ops_cache;
 	uint32_t		flags;
 	uint32_t		optimize_flags;
 	struct parser_state	*state;
diff --git a/src/evaluate.c b/src/evaluate.c
index fdd2433b4780..ea910786f3e4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -43,8 +43,9 @@
 static struct parse_ctx *parse_ctx_init(struct parse_ctx *parse_ctx, const struct eval_ctx *ctx)
 {
 	struct parse_ctx tmp = {
-		.tbl	= &ctx->nft->output.tbl,
-		.input	= &ctx->nft->input,
+		.tbl		= &ctx->nft->output.tbl,
+		.input		= &ctx->nft->input,
+		.ops_cache	= &ctx->nft->ops_cache,
 	};
 
 	/* "tmp" only exists, so we can search for "/struct parse_ctx .*=/" and find the location
diff --git a/src/libnftables.c b/src/libnftables.c
index 9c802ec95f27..e520bac76dfa 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -19,6 +19,15 @@
 #include <stdlib.h>
 #include <string.h>
 
+static void nft_ctx_reset_ops_cache(struct nft_ctx *ctx)
+{
+	ctx->ops_cache = (struct ops_cache) CTX_CACHE_INIT();
+
+	/* The cache is also referenced by the output context. Set
+	 * up the pointer. */
+	ctx->output.ops_cache = &ctx->ops_cache;
+}
+
 static int nft_netlink(struct nft_ctx *nft,
 		       struct list_head *cmds, struct list_head *msgs)
 {
@@ -37,6 +46,8 @@ static int nft_netlink(struct nft_ctx *nft,
 	if (list_empty(cmds))
 		goto out;
 
+	nft_ctx_reset_ops_cache(nft);
+
 	batch_seqnum = mnl_batch_begin(ctx.batch, mnl_seqnum_alloc(&seqnum));
 	list_for_each_entry(cmd, cmds, list) {
 		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
@@ -522,6 +533,8 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 	unsigned int flags;
 	int err = 0;
 
+	nft_ctx_reset_ops_cache(nft);
+
 	filter = nft_cache_filter_init();
 	if (nft_cache_evaluate(nft, cmds, msgs, filter, &flags) < 0) {
 		nft_cache_filter_fini(filter);
@@ -630,6 +643,8 @@ err:
 	if (rc || nft->check)
 		nft_cache_release(&nft->cache);
 
+	nft_ctx_reset_ops_cache(nft);
+
 	return rc;
 }
 
@@ -740,6 +755,8 @@ err:
 
 	scope_release(nft->state->scopes[0]);
 
+	nft_ctx_reset_ops_cache(nft);
+
 	return rc;
 }
 
-- 
2.41.0

