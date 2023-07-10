Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18705EB64D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jul 2023 17:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbjGJRrx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 13:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbjGJRrv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 13:47:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C6C120
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 10:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689011225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2/QAtCp0PgKbkckwThhEfXAHdRv75XFgujRluHJpFMg=;
        b=iwXZqGnFrbelOslikXxEDUD8mFpt3vRHCjhOSV+FdgC9dKBjXdl9n2AqJEfpiaUI3C5hq6
        fYLtW9+zCz+5IhmU/w6iDP8OFfaKC/zyrLfzrzHZFEdiHfwFSNgoIRcU99EaU7t0vbAY+G
        IA66I0FGFDM6fLFPVTwrQNjypYGsbyw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-X1jmiETaNwyu3fozOKE7lg-1; Mon, 10 Jul 2023 13:47:04 -0400
X-MC-Unique: X1jmiETaNwyu3fozOKE7lg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C248C800CAF
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 17:47:03 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 29185F5CFA;
        Mon, 10 Jul 2023 17:47:03 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH] nftables: add flag for nft context to avoid blocking getaddrinfo()
Date:   Mon, 10 Jul 2023 19:46:30 +0200
Message-ID: <20230710174652.221651-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

getaddrinfo() blocks while trying to resolve the name. Blocking the
caller of the library is bad in some cases. Especially, while
reconfiguring the firewall, it's not clear that we can access the
network to resolve names.

Add a way to opt out from getaddrinfo() and only accept plain IP addresses.

The opt-out is per nft_ctx instance and cannot be changed after the
context is created. I think that is sufficient.

We could also use AI_NUMERICHOST and getaddrinfo() instead of
inet_pton(). But it seems we can do a better job of generating an error
message, when we try to parse via inet_pton(). Then our error message
can clearly indicate that the string is not a valid IP address.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/datatype.h             |  1 +
 include/nftables/libnftables.h |  1 +
 py/nftables.py                 | 12 +++++-
 src/datatype.c                 | 68 ++++++++++++++++++++--------------
 src/evaluate.c                 | 16 +++++++-
 5 files changed, 66 insertions(+), 32 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 4b59790b67f9..108bf03ad0ed 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -182,6 +182,7 @@ struct datatype *dtype_clone(const struct datatype *orig_dtype);
 
 struct parse_ctx {
 	struct symbol_tables	*tbl;
+	bool			no_block;
 };
 
 extern struct error_record *symbol_parse(struct parse_ctx *ctx,
diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
index 85e08c9bc98b..d75aff05dec8 100644
--- a/include/nftables/libnftables.h
+++ b/include/nftables/libnftables.h
@@ -34,6 +34,7 @@ enum nft_debug_level {
  * Possible flags to pass to nft_ctx_new()
  */
 #define NFT_CTX_DEFAULT		0
+#define NFT_CTX_NO_BLOCK	1
 
 struct nft_ctx *nft_ctx_new(uint32_t flags);
 void nft_ctx_free(struct nft_ctx *ctx);
diff --git a/py/nftables.py b/py/nftables.py
index 6daeafc231f4..59798b1ecf0c 100644
--- a/py/nftables.py
+++ b/py/nftables.py
@@ -62,9 +62,13 @@ class Nftables:
         "terse":          (1 << 11),
     }
 
+    # Allow to easily indicate to the caller, whether Nftables() supports
+    # the recently added "no_block" argument.
+    _supports_no_block = True
+
     validator = None
 
-    def __init__(self, sofile="libnftables.so.1"):
+    def __init__(self, sofile="libnftables.so.1", no_block=False):
         """Instantiate a new Nftables class object.
 
         Accepts a shared object file to open, by default standard search path
@@ -144,8 +148,12 @@ class Nftables:
         self.nft_ctx_free = lib.nft_ctx_free
         lib.nft_ctx_free.argtypes = [c_void_p]
 
+        ctx_flags = 0  # NFT_CTX_DEFAULT
+        if no_block:
+            ctx_flags |= 1  # NFT_CTX_NO_BLOCK
+
         # initialize libnftables context
-        self.__ctx = self.nft_ctx_new(0)
+        self.__ctx = self.nft_ctx_new(ctx_flags)
         self.nft_ctx_buffer_output(self.__ctx)
         self.nft_ctx_buffer_error(self.__ctx)
 
diff --git a/src/datatype.c b/src/datatype.c
index da802a18bccd..4ceae14f4bd4 100644
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
+	if (ctx->no_block) {
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
+	if (ctx->no_block) {
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
index 678ad9b8907d..9249e89bec58 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -46,6 +46,14 @@ struct proto_ctx *eval_proto_ctx(struct eval_ctx *ctx)
 	return &ctx->_pctx[idx];
 }
 
+static void parse_ctx_init(struct parse_ctx *parse_ctx, const struct eval_ctx *ctx)
+{
+	*parse_ctx = (struct parse_ctx) {
+		.tbl      = &ctx->nft->output.tbl,
+		.no_block = !!(ctx->nft->flags & NFT_CTX_NO_BLOCK),
+	};
+}
+
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr);
 
 static const char * const byteorder_names[] = {
@@ -277,12 +285,14 @@ static int flowtable_not_found(struct eval_ctx *ctx, const struct location *loc,
  */
 static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 {
-	struct parse_ctx parse_ctx = { .tbl = &ctx->nft->output.tbl, };
+	struct parse_ctx parse_ctx;
 	struct error_record *erec;
 	struct table *table;
 	struct set *set;
 	struct expr *new;
 
+	parse_ctx_init(&parse_ctx, ctx);
+
 	switch ((*expr)->symtype) {
 	case SYMBOL_VALUE:
 		datatype_set(*expr, ctx->ectx.dtype);
@@ -3432,10 +3442,12 @@ static int stmt_evaluate_reject_default(struct eval_ctx *ctx,
 
 static int stmt_evaluate_reject_icmp(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	struct parse_ctx parse_ctx = { .tbl = &ctx->nft->output.tbl, };
+	struct parse_ctx parse_ctx;
 	struct error_record *erec;
 	struct expr *code;
 
+	parse_ctx_init(&parse_ctx, ctx);
+
 	erec = symbol_parse(&parse_ctx, stmt->reject.expr, &code);
 	if (erec != NULL) {
 		erec_queue(erec, ctx->msgs);
-- 
2.41.0

