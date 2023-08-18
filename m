Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CD4C7113C
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 09:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351492AbjHRJpD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 05:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359335AbjHRJoh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 05:44:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE3626A5
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 02:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692351829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ppzULhQC2on3TXFOxnruUCikom/1YhxtBu2SspVpHzM=;
        b=JOey8v8XqoK9NhH7lMY+tV0Gp2ah0CSZ4pzqxbop9Wp/qhYSeqNBOng/Wd9cIn2YoAKnat
        mIOL/kP7Rz6BC6rBLqdu17sQjaFH/8eSXTyuhvjHcL2uIZH4XwlC47fiwxnWs1pTw4umYn
        47on7Kh7ra03X/lp33d6AmcSlqWKTaU=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-678-xJ-kmK32NsGjhggWj-enXg-1; Fri, 18 Aug 2023 05:43:47 -0400
X-MC-Unique: xJ-kmK32NsGjhggWj-enXg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B12729ABA11;
        Fri, 18 Aug 2023 09:43:47 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DED3440C6F4E;
        Fri, 18 Aug 2023 09:43:46 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>, Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v5 2/6] src: add input flag NFT_CTX_INPUT_NO_DNS to avoid blocking
Date:   Fri, 18 Aug 2023 11:40:37 +0200
Message-ID: <20230818094335.535872-3-thaller@redhat.com>
In-Reply-To: <20230818094335.535872-1-thaller@redhat.com>
References: <20230818094335.535872-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

getaddrinfo() blocks while trying to resolve the name. Blocking the
caller of the library is in many cases undesirable. Also, while
reconfiguring the firewall, it's not clear that resolving names via
the network will work or makes sense.

Add a new input flag NFT_CTX_INPUT_NO_DNS to opt-out from getaddrinfo()
and only accept plain IP addresses.

We could also use AI_NUMERICHOST with getaddrinfo() instead of
inet_pton(). By parsing via inet_pton(), we are better aware of
what we expect and can generate a better error message in case of
failure.

Signed-off-by: Thomas Haller <thaller@redhat.com>
Reviewed-by: Phil Sutter <phil@nwl.cc>
---
 doc/libnftables.adoc           | 10 ++++-
 include/datatype.h             |  1 +
 include/nftables.h             |  5 +++
 include/nftables/libnftables.h |  4 ++
 src/datatype.c                 | 68 ++++++++++++++++++++--------------
 src/evaluate.c                 | 10 ++++-
 6 files changed, 67 insertions(+), 31 deletions(-)

diff --git a/doc/libnftables.adoc b/doc/libnftables.adoc
index a0d3521e5e7a..62de75f3fa22 100644
--- a/doc/libnftables.adoc
+++ b/doc/libnftables.adoc
@@ -84,7 +84,15 @@ The *nft_ctx_set_dry_run*() function sets the dry-run setting in 'ctx' to the va
 === nft_ctx_input_get_flags() and nft_ctx_input_set_flags()
 The flags setting controls the input format.
 
-Currently no flags are implemented.
+----
+enum {
+        NFT_CTX_INPUT_NO_DNS = (1 << 0),
+};
+----
+
+NFT_CTX_INPUT_NO_DNS::
+	Avoid resolving IP addresses with blocking getaddrinfo(). In that case,
+	only plain IP addresses are accepted.
 
 The *nft_ctx_input_get_flags*() function returns the input flags setting's value in 'ctx'.
 
diff --git a/include/datatype.h b/include/datatype.h
index 4b59790b67f9..be5c6d1b4011 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -182,6 +182,7 @@ struct datatype *dtype_clone(const struct datatype *orig_dtype);
 
 struct parse_ctx {
 	struct symbol_tables	*tbl;
+	const struct input_ctx	*input;
 };
 
 extern struct error_record *symbol_parse(struct parse_ctx *ctx,
diff --git a/include/nftables.h b/include/nftables.h
index 7d35a95a89de..666a17ae4dab 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -27,6 +27,11 @@ struct input_ctx {
 	unsigned int flags;
 };
 
+static inline bool nft_input_no_dns(const struct input_ctx *ictx)
+{
+	return ictx->flags & NFT_CTX_INPUT_NO_DNS;
+}
+
 struct output_ctx {
 	unsigned int flags;
 	union {
diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
index 9a05d3c4b90d..e109805f32a1 100644
--- a/include/nftables/libnftables.h
+++ b/include/nftables/libnftables.h
@@ -48,6 +48,10 @@ enum nft_optimize_flags {
 uint32_t nft_ctx_get_optimize(struct nft_ctx *ctx);
 void nft_ctx_set_optimize(struct nft_ctx *ctx, uint32_t flags);
 
+enum {
+	NFT_CTX_INPUT_NO_DNS		= (1 << 0),
+};
+
 unsigned int nft_ctx_input_get_flags(struct nft_ctx *ctx);
 unsigned int nft_ctx_input_set_flags(struct nft_ctx *ctx, unsigned int flags);
 
diff --git a/src/datatype.c b/src/datatype.c
index da802a18bccd..de4fbd776df5 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -599,27 +599,33 @@ static struct error_record *ipaddr_type_parse(struct parse_ctx *ctx,
 					      const struct expr *sym,
 					      struct expr **res)
 {
-	struct addrinfo *ai, hints = { .ai_family = AF_INET,
-				       .ai_socktype = SOCK_DGRAM};
-	struct in_addr *addr;
-	int err;
+	struct in_addr addr;
 
-	err = getaddrinfo(sym->identifier, NULL, &hints, &ai);
-	if (err != 0)
-		return error(&sym->location, "Could not resolve hostname: %s",
-			     gai_strerror(err));
+	if (nft_input_no_dns(ctx->input)) {
+		if (inet_pton(AF_INET, sym->identifier, &addr) != 1)
+			return error(&sym->location, "Invalid IPv4 address");
+	} else {
+		struct addrinfo *ai, hints = { .ai_family = AF_INET,
+					       .ai_socktype = SOCK_DGRAM};
+		int err;
 
-	if (ai->ai_next != NULL) {
+		err = getaddrinfo(sym->identifier, NULL, &hints, &ai);
+		if (err != 0)
+			return error(&sym->location, "Could not resolve hostname: %s",
+				     gai_strerror(err));
+
+		if (ai->ai_next != NULL) {
+			freeaddrinfo(ai);
+			return error(&sym->location,
+				     "Hostname resolves to multiple addresses");
+		}
+		addr = ((struct sockaddr_in *)ai->ai_addr)->sin_addr;
 		freeaddrinfo(ai);
-		return error(&sym->location,
-			     "Hostname resolves to multiple addresses");
 	}
 
-	addr = &((struct sockaddr_in *)ai->ai_addr)->sin_addr;
 	*res = constant_expr_alloc(&sym->location, &ipaddr_type,
 				   BYTEORDER_BIG_ENDIAN,
-				   sizeof(*addr) * BITS_PER_BYTE, addr);
-	freeaddrinfo(ai);
+				   sizeof(addr) * BITS_PER_BYTE, &addr);
 	return NULL;
 }
 
@@ -658,27 +664,33 @@ static struct error_record *ip6addr_type_parse(struct parse_ctx *ctx,
 					       const struct expr *sym,
 					       struct expr **res)
 {
-	struct addrinfo *ai, hints = { .ai_family = AF_INET6,
-				       .ai_socktype = SOCK_DGRAM};
-	struct in6_addr *addr;
-	int err;
+	struct in6_addr addr;
 
-	err = getaddrinfo(sym->identifier, NULL, &hints, &ai);
-	if (err != 0)
-		return error(&sym->location, "Could not resolve hostname: %s",
-			     gai_strerror(err));
+	if (nft_input_no_dns(ctx->input)) {
+		if (inet_pton(AF_INET6, sym->identifier, &addr) != 1)
+			return error(&sym->location, "Invalid IPv6 address");
+	} else {
+		struct addrinfo *ai, hints = { .ai_family = AF_INET6,
+					       .ai_socktype = SOCK_DGRAM};
+		int err;
 
-	if (ai->ai_next != NULL) {
+		err = getaddrinfo(sym->identifier, NULL, &hints, &ai);
+		if (err != 0)
+			return error(&sym->location, "Could not resolve hostname: %s",
+				     gai_strerror(err));
+
+		if (ai->ai_next != NULL) {
+			freeaddrinfo(ai);
+			return error(&sym->location,
+				     "Hostname resolves to multiple addresses");
+		}
+		addr = ((struct sockaddr_in6 *)ai->ai_addr)->sin6_addr;
 		freeaddrinfo(ai);
-		return error(&sym->location,
-			     "Hostname resolves to multiple addresses");
 	}
 
-	addr = &((struct sockaddr_in6 *)ai->ai_addr)->sin6_addr;
 	*res = constant_expr_alloc(&sym->location, &ip6addr_type,
 				   BYTEORDER_BIG_ENDIAN,
-				   sizeof(*addr) * BITS_PER_BYTE, addr);
-	freeaddrinfo(ai);
+				   sizeof(addr) * BITS_PER_BYTE, &addr);
 	return NULL;
 }
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 8fc1ca7e4b4f..e87177729cc3 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -277,7 +277,10 @@ static int flowtable_not_found(struct eval_ctx *ctx, const struct location *loc,
  */
 static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 {
-	struct parse_ctx parse_ctx = { .tbl = &ctx->nft->output.tbl, };
+	struct parse_ctx parse_ctx = {
+		.tbl	= &ctx->nft->output.tbl,
+		.input	= &ctx->nft->input,
+	};
 	struct error_record *erec;
 	struct table *table;
 	struct set *set;
@@ -3432,7 +3435,10 @@ static int stmt_evaluate_reject_default(struct eval_ctx *ctx,
 
 static int stmt_evaluate_reject_icmp(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	struct parse_ctx parse_ctx = { .tbl = &ctx->nft->output.tbl, };
+	struct parse_ctx parse_ctx = {
+		.tbl	= &ctx->nft->output.tbl,
+		.input	= &ctx->nft->input,
+	};
 	struct error_record *erec;
 	struct expr *code;
 
-- 
2.41.0

