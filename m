From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/10] libxt_time: always ignore libc timezone
Date: Tue, 24 May 2011 03:21:32 +0200
Message-ID: <1306200102-12148-2-git-send-email-jengelh@medozas.de>
References: <1306200102-12148-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41727 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031047Ab1EXBVp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 21:21:45 -0400
In-Reply-To: <1306200102-12148-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since xt_time is meant to work across many months, libc doing
automatic conversion from local time to UTC (during parse) is
unwanted, especially when --utc is specified. The same goes for
dumping.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_time.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index b538476..32f0bf3 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -87,7 +87,7 @@ static time_t time_parse_date(const char *s, bool end)
 	const char *os = s;
 	struct tm tm;
 	time_t ret;
-	char *e;
+	char *e, *saved[2];
 
 	year = strtoul(s, &e, 10);
 	if ((*e != '-' && *e != '\0') || year < 1970 || year > 2038)
@@ -136,7 +136,15 @@ static time_t time_parse_date(const char *s, bool end)
 	tm.tm_min  = minute;
 	tm.tm_sec  = second;
 	tm.tm_isdst = 0;
+	/*
+	 * Offsetting, if any, is done by xt_time.ko,
+	 * so we have to disable it here in userspace.
+	 */
+	tzset();
+	memcpy(saved, tzname, sizeof(saved));
+	tzname[0] = tzname[1] = "UTC";
 	ret = mktime(&tm);
+	memcpy(tzname, saved, sizeof(saved));
 	if (ret >= 0)
 		return ret;
 	perror("mktime");
@@ -289,7 +297,7 @@ static void time_print_date(time_t date, const char *command)
 	if (date == 0 || date == LONG_MAX)
 		return;
 
-	t = localtime(&date);
+	t = gmtime(&date);
 	if (command != NULL)
 		/*
 		 * Need a contiguous string (no whitespaces), hence using
-- 
1.7.3.4

