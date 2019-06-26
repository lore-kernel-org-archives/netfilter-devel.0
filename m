Return-Path: <SRS0=TDc5=UZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 996FBC48BD6
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 20:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75358208E3
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 20:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfFZUoT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 16:44:19 -0400
Received: from fnsib-smtp07.srv.cat ([46.16.61.68]:51141 "EHLO
        fnsib-smtp07.srv.cat" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfFZUoS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 16:44:18 -0400
Received: from localhost.localdomain (unknown [47.62.206.189])
        by fnsib-smtp07.srv.cat (Postfix) with ESMTPSA id 32D6F8142;
        Wed, 26 Jun 2019 22:44:14 +0200 (CEST)
From:   Ander Juaristi <a@juaristi.eus>
To:     netfilter-devel@vger.kernel.org
Cc:     Ander Juaristi <a@juaristi.eus>
Subject: [PATCH v2 5/7] nftables: meta: Some small style fixes
Date:   Wed, 26 Jun 2019 22:44:00 +0200
Message-Id: <20190626204402.5257-5-a@juaristi.eus>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190626204402.5257-1-a@juaristi.eus>
References: <20190626204402.5257-1-a@juaristi.eus>
Reply-To: a@juaristi.eus
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 - Rename constants: TYPE_TIME_DATE, TYPE_TIME_HOUR, TYPE_TIME_DAY
 - Use array_size()
 - Rewrite __hour_type_print_r to get buffer size from a parameter

Signed-off-by: Ander Juaristi <a@juaristi.eus>
---
 include/datatype.h |  6 +++---
 src/datatype.c     |  6 +++---
 src/meta.c         | 30 +++++++++++++++---------------
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index a102f3f..1f46eb0 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -90,9 +90,9 @@ enum datatypes {
 	TYPE_CT_EVENTBIT,
 	TYPE_IFNAME,
 	TYPE_IGMP_TYPE,
-	TYPE_TIME_TYPE,
-	TYPE_HOUR_TYPE,
-	TYPE_DAY_TYPE,
+	TYPE_TIME_DATE,
+	TYPE_TIME_HOUR,
+	TYPE_TIME_DAY,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
diff --git a/src/datatype.c b/src/datatype.c
index 2ee7a8f..0a00535 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -71,9 +71,9 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_BOOLEAN]		= &boolean_type,
 	[TYPE_IFNAME]		= &ifname_type,
 	[TYPE_IGMP_TYPE]	= &igmp_type_type,
-	[TYPE_TIME_TYPE]	= &date_type,
-	[TYPE_HOUR_TYPE]	= &hour_type,
-	[TYPE_DAY_TYPE]		= &day_type,
+	[TYPE_TIME_DATE]	= &date_type,
+	[TYPE_TIME_HOUR]	= &hour_type,
+	[TYPE_TIME_DAY]		= &day_type,
 };
 
 const struct datatype *datatype_lookup(enum datatypes type)
diff --git a/src/meta.c b/src/meta.c
index bfe8aaa..819e61d 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -475,7 +475,7 @@ static void day_type_print(const struct expr *expr, struct output_ctx *octx)
 		"Saturday"
 	};
 	uint8_t daynum = mpz_get_uint8(expr->value),
-		 numdays = sizeof(days) / (3 * 3);
+		 numdays = array_size(days) - 1;
 
 	if (daynum >= 0 && daynum <= numdays)
 		nft_print(octx, "\"%s\"", days[daynum]);
@@ -505,7 +505,7 @@ static struct error_record *day_type_parse(const struct expr *sym,
 		"Friday",
 		"Saturday"
 	};
-	int daynum = -1, numdays = (sizeof(days) / 7) - 1;
+	int daynum = -1, numdays = array_size(days);
 	int symlen = strlen(sym->identifier), daylen;
 
 	if (symlen < 3) {
@@ -538,22 +538,22 @@ success:
 	return NULL;
 }
 
-static void __hour_type_print_r(int hours, int minutes, int seconds, char *out)
+static void __hour_type_print_r(int hours, int minutes, int seconds, char *out, size_t buflen)
 {
 	if (minutes == 60)
-		return __hour_type_print_r(++hours, 0, seconds, out);
+		return __hour_type_print_r(++hours, 0, seconds, out, buflen);
 	else if (minutes > 60)
-		return __hour_type_print_r((int) (minutes / 60), minutes % 60, seconds, out);
+		return __hour_type_print_r((int) (minutes / 60), minutes % 60, seconds, out, buflen);
 
 	if (seconds == 60)
-		return __hour_type_print_r(hours, ++minutes, 0, out);
+		return __hour_type_print_r(hours, ++minutes, 0, out, buflen);
 	else if (seconds > 60)
-		return __hour_type_print_r(hours, (int) (seconds / 60), seconds % 60, out);
+		return __hour_type_print_r(hours, (int) (seconds / 60), seconds % 60, out, buflen);
 
 	if (seconds == 0)
-		snprintf(out, 6, "%02d:%02d", hours, minutes);
+		snprintf(out, buflen, "%02d:%02d", hours, minutes);
 	else
-		snprintf(out, 9, "%02d:%02d:%02d", hours, minutes, seconds);
+		snprintf(out, buflen, "%02d:%02d:%02d", hours, minutes, seconds);
 }
 
 static void hour_type_print(const struct expr *expr, struct output_ctx *octx)
@@ -571,7 +571,7 @@ static void hour_type_print(const struct expr *expr, struct output_ctx *octx)
 		if (cur_tm)
 			seconds = (seconds + cur_tm->tm_gmtoff) % 86400;
 
-		__hour_type_print_r(0, 0, seconds, out);
+		__hour_type_print_r(0, 0, seconds, out, sizeof(out));
 		nft_print(octx, "\"%s\"", out);
 
 		return;
@@ -636,18 +636,18 @@ success:
 }
 
 const struct datatype date_type = {
-	.type = TYPE_TIME_TYPE,
+	.type = TYPE_TIME_DATE,
 	.name = "time",
 	.desc = "Relative time of packet reception",
 	.byteorder = BYTEORDER_HOST_ENDIAN,
-	.size = 8 * BITS_PER_BYTE,
+	.size = sizeof(uint64_t) * BITS_PER_BYTE,
 	.basetype = &integer_type,
 	.print = date_type_print,
 	.parse = date_type_parse,
 };
 
 const struct datatype day_type = {
-	.type = TYPE_DAY_TYPE,
+	.type = TYPE_TIME_DAY,
 	.name = "day",
 	.desc = "Day of week of packet reception",
 	.byteorder = BYTEORDER_HOST_ENDIAN,
@@ -658,11 +658,11 @@ const struct datatype day_type = {
 };
 
 const struct datatype hour_type = {
-	.type = TYPE_HOUR_TYPE,
+	.type = TYPE_TIME_HOUR,
 	.name = "hour",
 	.desc = "Hour of day of packet reception",
 	.byteorder = BYTEORDER_HOST_ENDIAN,
-	.size = 8 * BITS_PER_BYTE,
+	.size = sizeof(uint64_t) * BITS_PER_BYTE,
 	.basetype = &integer_type,
 	.print = hour_type_print,
 	.parse = hour_type_parse,
-- 
2.17.1

