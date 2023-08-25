Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC49EE49A6
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 13:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245134AbjHYNbQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Aug 2023 09:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245124AbjHYNap (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2023 09:30:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10132108
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 06:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692970197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ikY1CE30lRQx6DpZzLARN/28kmQCUvcfD0Sn5tQ5gcI=;
        b=MvxQ++5I6s8XT1fgYE5OAfCw08BMVeiXJPqUJn2M37tymkQo/MMTal9UH0iTtFHldYD92T
        NhMO5QdXdWWiLD0O9Y5YrsUOPTrsrC9QdNDjbyi/jhrO47V3fcenTWxqo+slf5pRL5EBv3
        88/EAYb127qQ4H51uyLuKObDORZCNLI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-02xf_eHhNs-o13NI-jIMzw-1; Fri, 25 Aug 2023 09:29:55 -0400
X-MC-Unique: 02xf_eHhNs-o13NI-jIMzw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC58F101A528
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 13:29:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B2952166B26;
        Fri, 25 Aug 2023 13:29:54 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 3/4] src: cache result of time() during parsing/output
Date:   Fri, 25 Aug 2023 15:24:19 +0200
Message-ID: <20230825132942.2733840-4-thaller@redhat.com>
In-Reply-To: <20230825132942.2733840-1-thaller@redhat.com>
References: <20230825132942.2733840-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When we parse/output a larger set of data, we should only call time()
once. With every call of time(), the value keeps ticking (and is subject
to time reset). Previously, one parse/output operation will make
decisions on potentially different timestamps.

Add a cache to the parse/output context, and only fetch time() once
per operation.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/datatype.h |  6 ++++++
 src/datatype.c     | 16 ++++++++++++++++
 src/meta.c         |  4 ++--
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 79d996edd348..abd093765703 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -2,6 +2,7 @@
 #define NFTABLES_DATATYPE_H
 
 #include <json.h>
+#include <time.h>
 
 /**
  * enum datatypes
@@ -121,12 +122,17 @@ enum byteorder {
 struct expr;
 
 struct ops_cache {
+	time_t		time;
+	bool		has_time;
 };
 
 #define CTX_CACHE_INIT() \
 	{ \
+		.has_time = false, \
 	}
 
+extern time_t ops_cache_get_time(struct ops_cache *cache);
+
 /**
  * enum datatype_flags
  *
diff --git a/src/datatype.c b/src/datatype.c
index dd6a5fbf5df8..933d832c4f4d 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -35,6 +35,22 @@
 
 #include <netinet/ip_icmp.h>
 
+time_t ops_cache_get_time(struct ops_cache *cache)
+{
+	time_t t;
+
+	if (!cache || !cache->has_time) {
+		t = time(NULL);
+		if (cache) {
+			cache->has_time = true;
+			cache->time = time(NULL);
+		}
+	} else
+		t = cache->time;
+
+	return t;
+}
+
 static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_INVALID]		= &invalid_type,
 	[TYPE_VERDICT]		= &verdict_type,
diff --git a/src/meta.c b/src/meta.c
index 4f383269d032..1d853b219fe6 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -496,7 +496,7 @@ static void hour_type_print(const struct expr *expr, struct output_ctx *octx)
 	time_t ts;
 
 	/* Obtain current tm, so that we can add tm_gmtoff */
-	ts = time(NULL);
+	ts = ops_cache_get_time(octx->ops_cache);
 	if (ts != ((time_t) -1) && localtime_r(&ts, &cur_tm))
 		seconds = (seconds + cur_tm.tm_gmtoff) % SECONDS_PER_DAY;
 
@@ -534,7 +534,7 @@ static struct error_record *hour_type_parse(struct parse_ctx *ctx,
 	result = 0;
 
 	/* Obtain current tm, so that we can substract tm_gmtoff */
-	ts = time(NULL);
+	ts = ops_cache_get_time(ctx->ops_cache);
 	if (ts != ((time_t) -1) && localtime_r(&ts, &cur_tm_data))
 		cur_tm = &cur_tm_data;
 	else
-- 
2.41.0

