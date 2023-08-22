Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43BF4EE49A8
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Aug 2023 08:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbjHVIRS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Aug 2023 04:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbjHVIRA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2023 04:17:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF852CF0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2023 01:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692692166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vxOe6G56e+9D7lPkJd3Sr0bjho8cThEWcDYiXJaLx/I=;
        b=VdOvs5ZENzPA6LbCTpHlJ5D+ALGpK4S9EoZHhdpIBteRGsUBEQvYjUNX8bihs2lIV7Zq5F
        9MIA78WYpmdyLu0PkiaSSa12MUHKu5ZEX4Qfu9UrptpcIGwPi0/xvHHFgs9K6lt+duu3Gc
        5tBXmLkN22AaE4v/aLasa7euYaJ5DfQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-4jTKXV0GOT6_lqQKOESYbw-1; Tue, 22 Aug 2023 04:16:04 -0400
X-MC-Unique: 4jTKXV0GOT6_lqQKOESYbw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B28E9101A528
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2023 08:16:03 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9114940D2843;
        Tue, 22 Aug 2023 08:16:02 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH 2/2] meta: use reentrant localtime_r()/gmtime_r() functions
Date:   Tue, 22 Aug 2023 10:13:10 +0200
Message-ID: <20230822081318.1370371-2-thaller@redhat.com>
In-Reply-To: <20230822081318.1370371-1-thaller@redhat.com>
References: <20230822081318.1370371-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These functions are POSIX.1-2001. We should have them in all
environments we care about.

Use them as they are thread-safe.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/meta.c | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index 0d4ae0261ff2..d087e56e1b84 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -387,7 +387,7 @@ static void date_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	uint64_t tstamp64 = mpz_get_uint64(expr->value);
 	time_t tstamp;
-	struct tm *tm, *cur_tm;
+	struct tm tm;
 	char timestr[21];
 
 	/* Convert from nanoseconds to seconds */
@@ -395,14 +395,12 @@ static void date_type_print(const struct expr *expr, struct output_ctx *octx)
 
 	/* Obtain current tm, to add tm_gmtoff to the timestamp */
 	tstamp = tstamp64;
-	cur_tm = localtime(&tstamp);
-
-	if (cur_tm)
-		tstamp64 += cur_tm->tm_gmtoff;
+	if (localtime_r(&tstamp, &tm))
+		tstamp64 += tm.tm_gmtoff;
 
 	tstamp = tstamp64;
-	if ((tm = gmtime(&tstamp)) != NULL &&
-	     strftime(timestr, sizeof(timestr) - 1, "%Y-%m-%d %T", tm))
+	if (gmtime_r(&tstamp, &tm) &&
+	     strftime(timestr, sizeof(timestr) - 1, "%Y-%m-%d %T", &tm))
 		nft_print(octx, "\"%s\"", timestr);
 	else
 		nft_print(octx, "Error converting timestamp to printed time");
@@ -410,7 +408,8 @@ static void date_type_print(const struct expr *expr, struct output_ctx *octx)
 
 static bool parse_iso_date(uint64_t *tstamp, const char *sym)
 {
-	struct tm tm, *cur_tm;
+	struct tm cur_tm;
+	struct tm tm;
 	time_t ts;
 
 	memset(&tm, 0, sizeof(struct tm));
@@ -432,14 +431,15 @@ success:
 	 */
 	ts = timegm(&tm);
 
-	/* Obtain current tm as well (at the specified time), so that we can substract tm_gmtoff */
-	cur_tm = localtime(&ts);
+	if (ts == (time_t) -1)
+		return false;
 
-	if (ts == (time_t) -1 || cur_tm == NULL)
+	/* Obtain current tm as well (at the specified time), so that we can substract tm_gmtoff */
+	if (!localtime_r(&ts, &cur_tm))
 		return false;
 
 	/* Substract tm_gmtoff to get the current time */
-	*tstamp = ts - cur_tm->tm_gmtoff;
+	*tstamp = ts - cur_tm.tm_gmtoff;
 
 	return true;
 }
@@ -494,15 +494,13 @@ static void day_type_print(const struct expr *expr, struct output_ctx *octx)
 static void hour_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	uint32_t seconds = mpz_get_uint32(expr->value), minutes, hours;
-	struct tm *cur_tm;
+	struct tm cur_tm;
 	time_t ts;
 
 	/* Obtain current tm, so that we can add tm_gmtoff */
 	ts = time(NULL);
-	cur_tm = localtime(&ts);
-
-	if (cur_tm)
-		seconds = (seconds + cur_tm->tm_gmtoff) % SECONDS_PER_DAY;
+	if (ts != ((time_t) -1) && localtime_r(&ts, &cur_tm))
+		seconds = (seconds + cur_tm.tm_gmtoff) % SECONDS_PER_DAY;
 
 	minutes = seconds / 60;
 	seconds %= 60;
@@ -520,7 +518,9 @@ static struct error_record *hour_type_parse(struct parse_ctx *ctx,
 					    struct expr **res)
 {
 	struct error_record *er;
-	struct tm tm, *cur_tm;
+	struct tm cur_tm_data;
+	struct tm *cur_tm;
+	struct tm tm;
 	uint32_t result;
 	uint64_t tmp;
 	char *endptr;
@@ -537,7 +537,10 @@ static struct error_record *hour_type_parse(struct parse_ctx *ctx,
 
 	/* Obtain current tm, so that we can substract tm_gmtoff */
 	ts = time(NULL);
-	cur_tm = localtime(&ts);
+	if (ts != ((time_t) -1) && localtime_r(&ts, &cur_tm_data))
+		cur_tm = &cur_tm_data;
+	else
+		cur_tm = NULL;
 
 	endptr = strptime(sym->identifier, "%T", &tm);
 	if (endptr && *endptr == '\0')
-- 
2.41.0

