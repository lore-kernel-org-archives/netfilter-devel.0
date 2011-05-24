From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/10] libxt_time: --utc and --localtz are mutually exclusive
Date: Tue, 24 May 2011 03:21:33 +0200
Message-ID: <1306200102-12148-3-git-send-email-jengelh@medozas.de>
References: <1306200102-12148-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41728 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031047Ab1EXBVr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 21:21:47 -0400
In-Reply-To: <1306200102-12148-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_time.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index 32f0bf3..a666433 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -26,6 +26,8 @@ enum {
 	O_WEEKDAYS,
 	O_LOCAL_TZ,
 	O_UTC,
+	F_LOCAL_TZ  = 1 << O_LOCAL_TZ,
+	F_UTC       = 1 << O_UTC,
 };
 
 static const char *const week_days[] = {
@@ -41,8 +43,10 @@ static const struct xt_option_entry time_opts[] = {
 	 .flags = XTOPT_INVERT},
 	{.name = "monthdays", .id = O_MONTHDAYS, .type = XTTYPE_STRING,
 	 .flags = XTOPT_INVERT},
-	{.name = "localtz", .id = O_LOCAL_TZ, .type = XTTYPE_NONE},
-	{.name = "utc", .id = O_UTC, .type = XTTYPE_NONE},
+	{.name = "localtz", .id = O_LOCAL_TZ, .type = XTTYPE_NONE,
+	 .excl = F_UTC},
+	{.name = "utc", .id = O_UTC, .type = XTTYPE_NONE,
+	 .excl = F_LOCAL_TZ},
 	XTOPT_TABLEEND,
 };
 
-- 
1.7.3.4

