Return-Path: <SRS0=y7H9=ZE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C789BC17440
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 18:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0016214E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 18:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfKLS7i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 13:59:38 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:48500 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbfKLS7h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 13:59:37 -0500
Received: from localhost ([::1]:33358 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iUbO4-0006Zn-Mr; Tue, 12 Nov 2019 19:59:36 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] meta: Rewrite hour_type_print()
Date:   Tue, 12 Nov 2019 19:59:31 +0100
Message-Id: <20191112185931.8455-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There was no point in this recursively called __hour_type_print_r() at
all, it takes only four lines of code to split the number of seconds
into hours, minutes and seconds.

While being at it, inverse the conditional to reduce indenting for the
largest part of the function's body. Also introduce SECONDS_PER_DAY
macro to avoid magic numbers.

Fixes: f8f32deda31df ("meta: Introduce new conditions 'time', 'day' and 'hour'")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/meta.c | 49 +++++++++++++++++++------------------------------
 1 file changed, 19 insertions(+), 30 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index f54b818e4e911..69a897a926869 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -490,46 +490,35 @@ static void day_type_print(const struct expr *expr, struct output_ctx *octx)
 	return symbolic_constant_print(&day_type_tbl, expr, true, octx);
 }
 
-static void __hour_type_print_r(int hours, int minutes, int seconds, char *out, size_t buflen)
-{
-	if (minutes == 60)
-		return __hour_type_print_r(++hours, 0, seconds, out, buflen);
-	else if (minutes > 60)
-		return __hour_type_print_r((int) (minutes / 60), minutes % 60, seconds, out, buflen);
-
-	if (seconds == 60)
-		return __hour_type_print_r(hours, ++minutes, 0, out, buflen);
-	else if (seconds > 60)
-		return __hour_type_print_r(hours, (int) (seconds / 60), seconds % 60, out, buflen);
-
-	if (seconds == 0)
-		snprintf(out, buflen, "%02d:%02d", hours, minutes);
-	else
-		snprintf(out, buflen, "%02d:%02d:%02d", hours, minutes, seconds);
-}
+#define SECONDS_PER_DAY	(60 * 60 * 24)
 
 static void hour_type_print(const struct expr *expr, struct output_ctx *octx)
 {
-	uint32_t seconds = mpz_get_uint32(expr->value);
+	uint32_t seconds = mpz_get_uint32(expr->value), minutes, hours;
 	struct tm *cur_tm;
-	char out[32];
 	time_t ts;
 
-	if (!nft_output_seconds(octx)) {
-		/* Obtain current tm, so that we can add tm_gmtoff */
-		ts = time(NULL);
-		cur_tm = localtime(&ts);
+	if (nft_output_seconds(octx)) {
+		expr_basetype(expr)->print(expr, octx);
+		return;
+	}
 
-		if (cur_tm)
-			seconds = (seconds + cur_tm->tm_gmtoff) % 86400;
+	/* Obtain current tm, so that we can add tm_gmtoff */
+	ts = time(NULL);
+	cur_tm = localtime(&ts);
 
-		__hour_type_print_r(0, 0, seconds, out, sizeof(out));
-		nft_print(octx, "\"%s\"", out);
+	if (cur_tm)
+		seconds = (seconds + cur_tm->tm_gmtoff) % SECONDS_PER_DAY;
 
-		return;
-	}
+	minutes = seconds / 60;
+	seconds %= 60;
+	hours = minutes / 60;
+	minutes %= 60;
 
-	expr_basetype(expr)->print(expr, octx);
+	nft_print(octx, "\"%02d:%02d", hours, minutes);
+	if (seconds)
+		nft_print(octx, ":%02d", seconds);
+	nft_print(octx, "\"");
 }
 
 static struct error_record *hour_type_parse(struct parse_ctx *ctx,
-- 
2.24.0

