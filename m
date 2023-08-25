Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B978C3DA6F
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 13:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245126AbjHYNbQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Aug 2023 09:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245112AbjHYNan (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2023 09:30:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233592109
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 06:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692970197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LtUSbQx14VwBj3+rfg5roAzLAOiFFaiRwBXa+J51YG0=;
        b=g976ZApMgKVduKjYvhy3uvzHcVPzAC0UPcsJ8VlSnTZcVbv5SBF5zul2VpnHP3eVVQgrQ2
        gIK9kO0XzEXQuL5ewGdhGXT9Bj61ArHYDSMmPU5qUKNXTAu0bDZZ38E5KwuiUa4mUFE5h9
        1lzYLuSuwijTzHZXhqDh5OSK9Jb1VNY=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-VjNJwJz9OdyT41XIhfZUgg-1; Fri, 25 Aug 2023 09:29:56 -0400
X-MC-Unique: VjNJwJz9OdyT41XIhfZUgg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B72093C0F68B
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 13:29:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 355E52166B26;
        Fri, 25 Aug 2023 13:29:55 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 4/4] src: cache GMT offset for current time during parsing/output
Date:   Fri, 25 Aug 2023 15:24:20 +0200
Message-ID: <20230825132942.2733840-5-thaller@redhat.com>
In-Reply-To: <20230825132942.2733840-1-thaller@redhat.com>
References: <20230825132942.2733840-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

localtime_r() is allowed to call tzset() every time. If it would, we
might pick up timezone changes in the middle of processing a larger
operation. Instead, we want that all decisions that we make for one
operation, are based on the same timezone.

In practice, current glibc/musl does not call tzset() for localtime_r(),
if the timezone is already initialized.  That brings the opposite
problem. We want to refresh the timezone before the operation starts.

Not long ago, we used localtime() instead of localtime_r(). localtime()
would always implicitly call tzset(), so that nftables may change the
timezone, was already happening before.

Cache the GMT offset in ops_cache and call tzset(). This ensures that
the timezone is refreshed at least once per operation (and possibly also
at most once).

There are still two calls for localtime_r() left, that are used to
determine the GTM offset for an arbitrary timestamp other than
time(NULL). The GTM offset depends on the timestamp, so we cannot cache
it. Still, also call ops_cache_get_time_gmtoff(), which ensures that tzset()
gets called once.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/datatype.h |  8 ++++++++
 src/datatype.c     | 36 ++++++++++++++++++++++++++++++++++++
 src/meta.c         | 43 +++++++++++++++++++++----------------------
 3 files changed, 65 insertions(+), 22 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index abd093765703..00f0a0123326 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -123,15 +123,23 @@ struct expr;
 
 struct ops_cache {
 	time_t		time;
+
+	/* the GMT offset obtained from localtime(time). */
+	long int	gmtoff;
+
 	bool		has_time;
+	bool		has_gmtoff;
+	bool		good_gmtoff;
 };
 
 #define CTX_CACHE_INIT() \
 	{ \
 		.has_time = false, \
+		.has_gmtoff = false, \
 	}
 
 extern time_t ops_cache_get_time(struct ops_cache *cache);
+extern bool ops_cache_get_time_gmtoff(struct ops_cache *cache, long int *out_gmtoff);
 
 /**
  * enum datatype_flags
diff --git a/src/datatype.c b/src/datatype.c
index 933d832c4f4d..07f1e3474b7a 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -51,6 +51,42 @@ time_t ops_cache_get_time(struct ops_cache *cache)
 	return t;
 }
 
+bool ops_cache_get_time_gmtoff(struct ops_cache *cache, long int *out_gmtoff)
+{
+	long int gmtoff = 0;
+	bool good = false;
+
+	if (!cache || !cache->has_gmtoff) {
+		time_t now;
+
+		now = ops_cache_get_time(cache);
+		if (now != (time_t) -1) {
+			struct tm tm;
+
+			/* localtime_r() is not guaranteed to call tzset() (unlike localtime()).
+			 * Call it ourselves, so we possibly have the currently set timezone. */
+			tzset();
+
+			if (localtime_r(&now, &tm)) {
+				gmtoff = tm.tm_gmtoff;
+				good = true;
+			}
+		}
+
+		if (cache) {
+			cache->good_gmtoff = good;
+			cache->gmtoff = gmtoff;
+		}
+	} else {
+		gmtoff = cache->gmtoff;
+		good = cache->good_gmtoff;
+	}
+
+	if (out_gmtoff)
+		*out_gmtoff = gmtoff;
+	return good;
+}
+
 static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_INVALID]		= &invalid_type,
 	[TYPE_VERDICT]		= &verdict_type,
diff --git a/src/meta.c b/src/meta.c
index 1d853b219fe6..881fbc038775 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -391,6 +391,9 @@ static void date_type_print(const struct expr *expr, struct output_ctx *octx)
 	/* Convert from nanoseconds to seconds */
 	tstamp64 /= 1000000000L;
 
+	/* ops_cache_get_time_gmtoff() will call tzset() for us (once). */
+	ops_cache_get_time_gmtoff(octx->ops_cache, NULL);
+
 	/* Obtain current tm, to add tm_gmtoff to the timestamp */
 	tstamp = tstamp64;
 	if (localtime_r(&tstamp, &tm))
@@ -404,7 +407,7 @@ static void date_type_print(const struct expr *expr, struct output_ctx *octx)
 		nft_print(octx, "Error converting timestamp to printed time");
 }
 
-static bool parse_iso_date(uint64_t *tstamp, const char *sym)
+static bool parse_iso_date(struct parse_ctx *ctx, uint64_t *tstamp, const char *sym)
 {
 	struct tm cur_tm;
 	struct tm tm;
@@ -422,6 +425,9 @@ static bool parse_iso_date(uint64_t *tstamp, const char *sym)
 	return false;
 
 success:
+	/* ops_cache_get_time_gmtoff() will call tzset() for us (once). */
+	ops_cache_get_time_gmtoff(ctx->ops_cache, NULL);
+
 	/*
 	 * Overwriting TZ is problematic if we're parsing hour types in this same process,
 	 * hence I'd rather use timegm() which doesn't take into account the TZ env variable,
@@ -449,7 +455,7 @@ static struct error_record *date_type_parse(struct parse_ctx *ctx,
 	const char *endptr = sym->identifier;
 	uint64_t tstamp;
 
-	if (parse_iso_date(&tstamp, sym->identifier))
+	if (parse_iso_date(ctx, &tstamp, sym->identifier))
 		goto success;
 
 	tstamp = strtoul(sym->identifier, (char **) &endptr, 10);
@@ -492,13 +498,11 @@ static void day_type_print(const struct expr *expr, struct output_ctx *octx)
 static void hour_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	uint32_t seconds = mpz_get_uint32(expr->value), minutes, hours;
-	struct tm cur_tm;
-	time_t ts;
+	long int gmtoff;
 
-	/* Obtain current tm, so that we can add tm_gmtoff */
-	ts = ops_cache_get_time(octx->ops_cache);
-	if (ts != ((time_t) -1) && localtime_r(&ts, &cur_tm))
-		seconds = (seconds + cur_tm.tm_gmtoff) % SECONDS_PER_DAY;
+	/* Add current offset of localtime() to GMT. */
+	if (ops_cache_get_time_gmtoff(octx->ops_cache, &gmtoff))
+		seconds = (seconds + gmtoff) % SECONDS_PER_DAY;
 
 	minutes = seconds / 60;
 	seconds %= 60;
@@ -516,13 +520,12 @@ static struct error_record *hour_type_parse(struct parse_ctx *ctx,
 					    struct expr **res)
 {
 	struct error_record *er;
-	struct tm cur_tm_data;
-	struct tm *cur_tm;
+	long int gmtoff;
+	bool has_gmtoff;
 	uint32_t result;
 	uint64_t tmp;
 	char *endptr;
 	struct tm tm;
-	time_t ts;
 
 	memset(&tm, 0, sizeof(struct tm));
 
@@ -533,12 +536,8 @@ static struct error_record *hour_type_parse(struct parse_ctx *ctx,
 
 	result = 0;
 
-	/* Obtain current tm, so that we can substract tm_gmtoff */
-	ts = ops_cache_get_time(ctx->ops_cache);
-	if (ts != ((time_t) -1) && localtime_r(&ts, &cur_tm_data))
-		cur_tm = &cur_tm_data;
-	else
-		cur_tm = NULL;
+	/* Obtain current offset of localtime() from GTM. */
+	has_gmtoff = ops_cache_get_time_gmtoff(ctx->ops_cache, &gmtoff);
 
 	endptr = strptime(sym->identifier, "%T", &tm);
 	if (endptr && *endptr == '\0')
@@ -563,12 +562,12 @@ convert:
 	if (result == 0)
 		result = tm.tm_hour * 3600 + tm.tm_min * 60 + tm.tm_sec;
 
-	/* Substract tm_gmtoff to get the current time */
-	if (cur_tm) {
-		if ((long int) result >= cur_tm->tm_gmtoff)
-			result = (result - cur_tm->tm_gmtoff) % 86400;
+	/* Substract gmtoff to get the current time */
+	if (has_gmtoff) {
+		if ((long int) result >= gmtoff)
+			result = (result - gmtoff) % 86400;
 		else
-			result = 86400 - cur_tm->tm_gmtoff + result;
+			result = 86400 - gmtoff + result;
 	}
 
 success:
-- 
2.41.0

