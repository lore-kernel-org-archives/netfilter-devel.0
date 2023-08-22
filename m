Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B3EEE49A3
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Aug 2023 08:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbjHVIOa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Aug 2023 04:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbjHVIOU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2023 04:14:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB41712C
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2023 01:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692692011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ELY6zasBXl0E701XY9/Cyb/X2iNAGwO5PAZGroGA0HE=;
        b=F/LhXm1uu+eWSMqpYYJX/Hc5O7rpOl9LjaPvoE5CX9bUI217BwzqZjVcbkL6LwFGdYm4X1
        8TlQeRh9qrsHBsKCQLXOj41HPrfuPNuWoRl8uTWU1JlSRNzdUKEGMnrzu57S/knlEO9cn1
        Rmx7fnioB8JUngjT1d0s45Q4EfcVEL0=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-xELCXMe-MeyUjNlLaTdICQ-1; Tue, 22 Aug 2023 04:13:29 -0400
X-MC-Unique: xELCXMe-MeyUjNlLaTdICQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 645D21C068D9
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2023 08:13:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D724340D2843;
        Tue, 22 Aug 2023 08:13:28 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH 1/2] meta: don't assume time_t is 64 bit in date_type_print()
Date:   Tue, 22 Aug 2023 10:13:09 +0200
Message-ID: <20230822081318.1370371-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

time_t on 32bit arch is not uint64_t. Even if it always were, it would
be ugly to make such an assumption (without a static assert). Copy the
value to a time_t variable first.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/meta.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index 822c2fd12b6f..0d4ae0261ff2 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -385,20 +385,23 @@ const struct datatype ifname_type = {
 
 static void date_type_print(const struct expr *expr, struct output_ctx *octx)
 {
-	uint64_t tstamp = mpz_get_uint64(expr->value);
+	uint64_t tstamp64 = mpz_get_uint64(expr->value);
+	time_t tstamp;
 	struct tm *tm, *cur_tm;
 	char timestr[21];
 
 	/* Convert from nanoseconds to seconds */
-	tstamp /= 1000000000L;
+	tstamp64 /= 1000000000L;
 
 	/* Obtain current tm, to add tm_gmtoff to the timestamp */
-	cur_tm = localtime((time_t *) &tstamp);
+	tstamp = tstamp64;
+	cur_tm = localtime(&tstamp);
 
 	if (cur_tm)
-		tstamp += cur_tm->tm_gmtoff;
+		tstamp64 += cur_tm->tm_gmtoff;
 
-	if ((tm = gmtime((time_t *) &tstamp)) != NULL &&
+	tstamp = tstamp64;
+	if ((tm = gmtime(&tstamp)) != NULL &&
 	     strftime(timestr, sizeof(timestr) - 1, "%Y-%m-%d %T", tm))
 		nft_print(octx, "\"%s\"", timestr);
 	else
-- 
2.41.0

