From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 22/24] libxt_time: always ignore libc timezone
Date: Wed, 25 May 2011 01:08:23 +0200
Message-ID: <1306278506-11463-23-git-send-email-jengelh@medozas.de>
References: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41000 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757381Ab1EXXIw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 19:08:52 -0400
In-Reply-To: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since xt_time is meant to work across many months, libc doing
automatic conversion from local time to UTC (during parse) is
unwanted, especially when --utc is specified. The same goes for
dumping.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_time.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index b538476..67b7f45 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -136,6 +136,12 @@ static time_t time_parse_date(const char *s, bool end)
 	tm.tm_min  = minute;
 	tm.tm_sec  = second;
 	tm.tm_isdst = 0;
+	/*
+	 * Offsetting, if any, is done by xt_time.ko,
+	 * so we have to disable it here in userspace.
+	 */
+	setenv("TZ", "UTC", true);
+	tzset();
 	ret = mktime(&tm);
 	if (ret >= 0)
 		return ret;
@@ -289,7 +295,7 @@ static void time_print_date(time_t date, const char *command)
 	if (date == 0 || date == LONG_MAX)
 		return;
 
-	t = localtime(&date);
+	t = gmtime(&date);
 	if (command != NULL)
 		/*
 		 * Need a contiguous string (no whitespaces), hence using
-- 
1.7.3.4

