Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D28EC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 08:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CDA360F92
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 08:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240430AbhIFIca (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 04:32:30 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39126 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbhIFIca (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 04:32:30 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id D13DC60011
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Sep 2021 10:30:20 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] meta: skip -T for hour and date format
Date:   Mon,  6 Sep 2021 10:31:19 +0200
Message-Id: <20210906083119.1628-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If -T is used:

- meta hour displays the hours in seconds based on your
- meta time displays the UNIX time since 1970 in nanoseconds.

Better, skip -T for these two datatypes and use the formatted output
instead, ie.

- meta hour "00:00:20"
- meta time "1970-01-01 01:00:01"

Fixes: f8f32deda31d ("meta: Introduce new conditions 'time', 'day' and 'hour'")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/meta.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index fdbeba26291a..bdd10269569d 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -388,27 +388,17 @@ static void date_type_print(const struct expr *expr, struct output_ctx *octx)
 	/* Convert from nanoseconds to seconds */
 	tstamp /= 1000000000L;
 
-	if (!nft_output_seconds(octx)) {
-		/* Obtain current tm, to add tm_gmtoff to the timestamp */
-		cur_tm = localtime((time_t *) &tstamp);
+	/* Obtain current tm, to add tm_gmtoff to the timestamp */
+	cur_tm = localtime((time_t *) &tstamp);
 
-		if (cur_tm)
-			tstamp += cur_tm->tm_gmtoff;
-
-		if ((tm = gmtime((time_t *) &tstamp)) != NULL &&
-			strftime(timestr, sizeof(timestr) - 1, "%F %T", tm))
-			nft_print(octx, "\"%s\"", timestr);
-		else
-			nft_print(octx, "Error converting timestamp to printed time");
-
-		return;
-	}
+	if (cur_tm)
+		tstamp += cur_tm->tm_gmtoff;
 
-	/*
-	 * Do our own printing. The default print function will print in
-	 * nanoseconds, which is ugly.
-	 */
-	nft_print(octx, "%" PRIu64, tstamp);
+	if ((tm = gmtime((time_t *) &tstamp)) != NULL &&
+	     strftime(timestr, sizeof(timestr) - 1, "%F %T", tm))
+		nft_print(octx, "\"%s\"", timestr);
+	else
+		nft_print(octx, "Error converting timestamp to printed time");
 }
 
 static time_t parse_iso_date(const char *sym)
@@ -498,11 +488,6 @@ static void hour_type_print(const struct expr *expr, struct output_ctx *octx)
 	struct tm *cur_tm;
 	time_t ts;
 
-	if (nft_output_seconds(octx)) {
-		expr_basetype(expr)->print(expr, octx);
-		return;
-	}
-
 	/* Obtain current tm, so that we can add tm_gmtoff */
 	ts = time(NULL);
 	cur_tm = localtime(&ts);
-- 
2.20.1

