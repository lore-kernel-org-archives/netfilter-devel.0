Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF0E1C71150
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 14:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377653AbjHROMb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 10:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377630AbjHROMZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 10:12:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD53E359D
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 07:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692367900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cTJL6GHB8mjJkjEvSFynSx7zBj4Lv2luQlNbQExs4iU=;
        b=Gz+em1qeVzxF0AYra+hb0mL/bGLADgFhwiG39DyuhJK4mOTshaz7MG8qYrrOLLkLmwKAxs
        6KBYIZ+Zdtg85wXRVlZNbgVVjTU42d+SpAIKunLQfOEXoEmRH4Bv6B+IZv1V8epOL8TPwM
        TPX+JOWta2poSB5FibAIF/iVt+B5zzU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-9XvKCvx9Nmq87w9W81MYIg-1; Fri, 18 Aug 2023 10:11:38 -0400
X-MC-Unique: 9XvKCvx9Nmq87w9W81MYIg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DC5C8007A4
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 14:11:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF35840C6F4E;
        Fri, 18 Aug 2023 14:11:37 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH v3 3/3] src: use wrappers for getprotoby{name,number}_r(), getservbyport_r()
Date:   Fri, 18 Aug 2023 16:08:21 +0200
Message-ID: <20230818141124.859037-4-thaller@redhat.com>
In-Reply-To: <20230818141124.859037-1-thaller@redhat.com>
References: <20230818141124.859037-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These wrappers are thread-safe, if libc provides the reentrant versions.
Use them.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/datatype.c | 33 +++++++++++++++++----------------
 src/json.c     | 22 +++++++++++-----------
 src/rule.c     |  7 ++++---
 3 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index da802a18bccd..381320eaf842 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -29,6 +29,7 @@
 #include <netlink.h>
 #include <json.h>
 #include <misspell.h>
+#include "nftutils.h"
 
 #include <netinet/ip_icmp.h>
 
@@ -697,12 +698,11 @@ const struct datatype ip6addr_type = {
 static void inet_protocol_type_print(const struct expr *expr,
 				      struct output_ctx *octx)
 {
-	struct protoent *p;
-
 	if (!nft_output_numeric_proto(octx)) {
-		p = getprotobynumber(mpz_get_uint8(expr->value));
-		if (p != NULL) {
-			nft_print(octx, "%s", p->p_name);
+		char name[NFT_PROTONAME_MAXSIZE];
+
+		if (nft_getprotobynumber(mpz_get_uint8(expr->value), name, sizeof(name))) {
+			nft_print(octx, "%s", name);
 			return;
 		}
 	}
@@ -711,15 +711,15 @@ static void inet_protocol_type_print(const struct expr *expr,
 
 static void inet_protocol_type_describe(struct output_ctx *octx)
 {
-	struct protoent *p;
 	uint8_t protonum;
 
 	for (protonum = 0; protonum < UINT8_MAX; protonum++) {
-		p = getprotobynumber(protonum);
-		if (!p)
+		char name[NFT_PROTONAME_MAXSIZE];
+
+		if (!nft_getprotobynumber(protonum, name, sizeof(name)))
 			continue;
 
-		nft_print(octx, "\t%-30s\t%u\n", p->p_name, protonum);
+		nft_print(octx, "\t%-30s\t%u\n", name, protonum);
 	}
 }
 
@@ -727,7 +727,6 @@ static struct error_record *inet_protocol_type_parse(struct parse_ctx *ctx,
 						     const struct expr *sym,
 						     struct expr **res)
 {
-	struct protoent *p;
 	uint8_t proto;
 	uintmax_t i;
 	char *end;
@@ -740,11 +739,13 @@ static struct error_record *inet_protocol_type_parse(struct parse_ctx *ctx,
 
 		proto = i;
 	} else {
-		p = getprotobyname(sym->identifier);
-		if (p == NULL)
+		int r;
+
+		r = nft_getprotobyname(sym->identifier);
+		if (r < 0)
 			return error(&sym->location, "Could not resolve protocol name");
 
-		proto = p->p_proto;
+		proto = r;
 	}
 
 	*res = constant_expr_alloc(&sym->location, &inet_protocol_type,
@@ -768,12 +769,12 @@ const struct datatype inet_protocol_type = {
 static void inet_service_print(const struct expr *expr, struct output_ctx *octx)
 {
 	uint16_t port = mpz_get_be16(expr->value);
-	const struct servent *s = getservbyport(port, NULL);
+	char name[NFT_SERVNAME_MAXSIZE];
 
-	if (s == NULL)
+	if (!nft_getservbyport(port, NULL, name, sizeof(name)))
 		nft_print(octx, "%hu", ntohs(port));
 	else
-		nft_print(octx, "\"%s\"", s->s_name);
+		nft_print(octx, "\"%s\"", name);
 }
 
 void inet_service_type_print(const struct expr *expr, struct output_ctx *octx)
diff --git a/src/json.c b/src/json.c
index a119dfc4f1eb..57a597bce467 100644
--- a/src/json.c
+++ b/src/json.c
@@ -15,6 +15,7 @@
 #include <netlink.h>
 #include <rule.h>
 #include <rt.h>
+#include "nftutils.h"
 
 #include <netdb.h>
 #include <netinet/icmp6.h>
@@ -297,10 +298,10 @@ static json_t *chain_print_json(const struct chain *chain)
 
 static json_t *proto_name_json(uint8_t proto)
 {
-	const struct protoent *p = getprotobynumber(proto);
+	char name[NFT_PROTONAME_MAXSIZE];
 
-	if (p)
-		return json_string(p->p_name);
+	if (nft_getprotobynumber(proto, name, sizeof(name)))
+		return json_string(name);
 	return json_integer(proto);
 }
 
@@ -1093,12 +1094,11 @@ json_t *boolean_type_json(const struct expr *expr, struct output_ctx *octx)
 json_t *inet_protocol_type_json(const struct expr *expr,
 				struct output_ctx *octx)
 {
-	struct protoent *p;
-
 	if (!nft_output_numeric_proto(octx)) {
-		p = getprotobynumber(mpz_get_uint8(expr->value));
-		if (p != NULL)
-			return json_string(p->p_name);
+		char name[NFT_PROTONAME_MAXSIZE];
+
+		if (nft_getprotobynumber(mpz_get_uint8(expr->value), name, sizeof(name)))
+			return json_string(name);
 	}
 	return integer_type_json(expr, octx);
 }
@@ -1106,13 +1106,13 @@ json_t *inet_protocol_type_json(const struct expr *expr,
 json_t *inet_service_type_json(const struct expr *expr, struct output_ctx *octx)
 {
 	uint16_t port = mpz_get_be16(expr->value);
-	const struct servent *s = NULL;
+	char name[NFT_SERVNAME_MAXSIZE];
 
 	if (!nft_output_service(octx) ||
-	    (s = getservbyport(port, NULL)) == NULL)
+	    !nft_getservbyport(port, NULL, name, sizeof(name)))
 		return json_integer(ntohs(port));
 
-	return json_string(s->s_name);
+	return json_string(name);
 }
 
 json_t *mark_type_json(const struct expr *expr, struct output_ctx *octx)
diff --git a/src/rule.c b/src/rule.c
index 99c4f0bb8b00..b59fcd3a9fa8 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -27,6 +27,7 @@
 #include <cache.h>
 #include <owner.h>
 #include <intervals.h>
+#include "nftutils.h"
 
 #include <libnftnl/common.h>
 #include <libnftnl/ruleset.h>
@@ -1666,10 +1667,10 @@ struct obj *obj_lookup_fuzzy(const char *obj_name,
 
 static void print_proto_name_proto(uint8_t l4, struct output_ctx *octx)
 {
-	const struct protoent *p = getprotobynumber(l4);
+	char name[NFT_PROTONAME_MAXSIZE];
 
-	if (p)
-		nft_print(octx, "%s", p->p_name);
+	if (nft_getprotobynumber(l4, name, sizeof(name)))
+		nft_print(octx, "%s", name);
 	else
 		nft_print(octx, "%d", l4);
 }
-- 
2.41.0

