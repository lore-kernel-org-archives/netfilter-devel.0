From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 27/28] libxt_time: use guided option parser
Date: Tue, 12 Apr 2011 16:23:42 +0200
Message-ID: <1302618224-9449-28-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54705 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756438Ab1DLOYQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:24:16 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_time.c |  153 ++++++++++++++++-------------------------------
 1 files changed, 52 insertions(+), 101 deletions(-)

diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index 56fb135..b538476 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -9,45 +9,41 @@
  *
  *	Based on libipt_time.c.
  */
-#include <sys/types.h>
-#include <getopt.h>
-#include <stdbool.h>
-#include <stdint.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
-#include <stddef.h>
 #include <time.h>
-#include <limits.h>
-
 #include <linux/types.h>
 #include <linux/netfilter/xt_time.h>
 #include <xtables.h>
 
-enum { /* getopt "seen" bits */
-	F_DATE_START = 1 << 0,
-	F_DATE_STOP  = 1 << 1,
-	F_TIME_START = 1 << 2,
-	F_TIME_STOP  = 1 << 3,
-	F_MONTHDAYS  = 1 << 4,
-	F_WEEKDAYS   = 1 << 5,
-	F_TIMEZONE   = 1 << 6,
+enum {
+	O_DATE_START = 0,
+	O_DATE_STOP,
+	O_TIME_START,
+	O_TIME_STOP,
+	O_MONTHDAYS,
+	O_WEEKDAYS,
+	O_LOCAL_TZ,
+	O_UTC,
 };
 
 static const char *const week_days[] = {
 	NULL, "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun",
 };
 
-static const struct option time_opts[] = {
-	{.name = "datestart", .has_arg = true,  .val = 'D'},
-	{.name = "datestop",  .has_arg = true,  .val = 'E'},
-	{.name = "timestart", .has_arg = true,  .val = 'X'},
-	{.name = "timestop",  .has_arg = true,  .val = 'Y'},
-	{.name = "weekdays",  .has_arg = true,  .val = 'w'},
-	{.name = "monthdays", .has_arg = true,  .val = 'm'},
-	{.name = "localtz",   .has_arg = false, .val = 'l'},
-	{.name = "utc",       .has_arg = false, .val = 'u'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry time_opts[] = {
+	{.name = "datestart", .id = O_DATE_START, .type = XTTYPE_STRING},
+	{.name = "datestop", .id = O_DATE_STOP, .type = XTTYPE_STRING},
+	{.name = "timestart", .id = O_TIME_START, .type = XTTYPE_STRING},
+	{.name = "timestop", .id = O_TIME_STOP, .type = XTTYPE_STRING},
+	{.name = "weekdays", .id = O_WEEKDAYS, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	{.name = "monthdays", .id = O_MONTHDAYS, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	{.name = "localtz", .id = O_LOCAL_TZ, .type = XTTYPE_NONE},
+	{.name = "utc", .id = O_UTC, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
 
 static void time_help(void)
@@ -248,86 +244,41 @@ static unsigned int time_parse_weekdays(const char *arg)
 	return ret;
 }
 
-static int time_parse(int c, char **argv, int invert, unsigned int *flags,
-                      const void *entry, struct xt_entry_match **match)
+static void time_parse(struct xt_option_call *cb)
 {
-	struct xt_time_info *info = (void *)(*match)->data;
-
-	switch (c) {
-	case 'D': /* --datestart */
-		if (*flags & F_DATE_START)
-			xtables_error(PARAMETER_PROBLEM,
-			           "Cannot specify --datestart twice");
-		if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-			           "Unexpected \"!\" with --datestart");
-		info->date_start = time_parse_date(optarg, false);
-		*flags |= F_DATE_START;
-		return 1;
-	case 'E': /* --datestop */
-		if (*flags & F_DATE_STOP)
-			xtables_error(PARAMETER_PROBLEM,
-			           "Cannot specify --datestop more than once");
-		if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-			           "unexpected \"!\" with --datestop");
-		info->date_stop = time_parse_date(optarg, true);
-		*flags |= F_DATE_STOP;
-		return 1;
-	case 'X': /* --timestart */
-		if (*flags & F_TIME_START)
-			xtables_error(PARAMETER_PROBLEM,
-			           "Cannot specify --timestart more than once");
-		if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-			           "Unexpected \"!\" with --timestart");
-		info->daytime_start = time_parse_minutes(optarg);
-		*flags |= F_TIME_START;
-		return 1;
-	case 'Y': /* --timestop */
-		if (*flags & F_TIME_STOP)
-			xtables_error(PARAMETER_PROBLEM,
-			           "Cannot specify --timestop more than once");
-		if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-			           "Unexpected \"!\" with --timestop");
-		info->daytime_stop = time_parse_minutes(optarg);
-		*flags |= F_TIME_STOP;
-		return 1;
-	case 'l': /* --localtz */
-		if (*flags & F_TIMEZONE)
-			xtables_error(PARAMETER_PROBLEM,
-			           "Can only specify exactly one of --localtz or --utc");
+	struct xt_time_info *info = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_DATE_START:
+		info->date_start = time_parse_date(cb->arg, false);
+		break;
+	case O_DATE_STOP:
+		info->date_stop = time_parse_date(cb->arg, true);
+		break;
+	case O_TIME_START:
+		info->daytime_start = time_parse_minutes(cb->arg);
+		break;
+	case O_TIME_STOP:
+		info->daytime_stop = time_parse_minutes(cb->arg);
+		break;
+	case O_LOCAL_TZ:
 		info->flags |= XT_TIME_LOCAL_TZ;
-		*flags |= F_TIMEZONE;
-		return 1;
-	case 'm': /* --monthdays */
-		if (*flags & F_MONTHDAYS)
-			xtables_error(PARAMETER_PROBLEM,
-			           "Cannot specify --monthdays more than once");
-		info->monthdays_match = time_parse_monthdays(optarg);
-		if (invert)
+		break;
+	case O_MONTHDAYS:
+		info->monthdays_match = time_parse_monthdays(cb->arg);
+		if (cb->invert)
 			info->monthdays_match ^= XT_TIME_ALL_MONTHDAYS;
-		*flags |= F_MONTHDAYS;
-		return 1;
-	case 'w': /* --weekdays */
-		if (*flags & F_WEEKDAYS)
-			xtables_error(PARAMETER_PROBLEM,
-			           "Cannot specify --weekdays more than once");
-		info->weekdays_match = time_parse_weekdays(optarg);
-		if (invert)
+		break;
+	case O_WEEKDAYS:
+		info->weekdays_match = time_parse_weekdays(cb->arg);
+		if (cb->invert)
 			info->weekdays_match ^= XT_TIME_ALL_WEEKDAYS;
-		*flags |= F_WEEKDAYS;
-		return 1;
-	case 'u': /* --utc */
-		if (*flags & F_TIMEZONE)
-			xtables_error(PARAMETER_PROBLEM,
-			           "Can only specify exactly one of --localtz or --utc");
+		break;
+	case O_UTC:
 		info->flags &= ~XT_TIME_LOCAL_TZ;
-		*flags |= F_TIMEZONE;
-		return 1;
+		break;
 	}
-	return 0;
 }
 
 static void time_print_date(time_t date, const char *command)
@@ -474,10 +425,10 @@ static struct xtables_match time_match = {
 	.userspacesize = XT_ALIGN(sizeof(struct xt_time_info)),
 	.help          = time_help,
 	.init          = time_init,
-	.parse         = time_parse,
 	.print         = time_print,
 	.save          = time_save,
-	.extra_opts    = time_opts,
+	.x6_parse      = time_parse,
+	.x6_options    = time_opts,
 };
 
 void _init(void)
-- 
1.7.1

