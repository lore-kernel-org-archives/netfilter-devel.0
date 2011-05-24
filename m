From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 05/10] libxt_time: remove --localtz option
Date: Tue, 24 May 2011 03:21:36 +0200
Message-ID: <1306200102-12148-6-git-send-email-jengelh@medozas.de>
References: <1306200102-12148-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41739 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031047Ab1EXBVu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 21:21:50 -0400
In-Reply-To: <1306200102-12148-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Comparing against the kernel time zone has significant caveats. This
patch adds documentation about the issue, and makes --utc the default
setting for libxt_time.

Furthremore, remove recognition of the "--localtz" option, to avoid
confusion with one's shell TZ environment variable, and rename it to
"--kerneltz" to be explicit about whose timezone will be used.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_time.c   |   21 ++++++++++++---------
 extensions/libxt_time.man |   39 +++++++++++++++++++++++++++++++--------
 2 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index a666433..e91f801 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -26,8 +26,10 @@ enum {
 	O_WEEKDAYS,
 	O_LOCAL_TZ,
 	O_UTC,
+	O_KERNEL_TZ,
 	F_LOCAL_TZ  = 1 << O_LOCAL_TZ,
 	F_UTC       = 1 << O_UTC,
+	F_KERNEL_TZ = 1 << O_KERNEL_TZ,
 };
 
 static const char *const week_days[] = {
@@ -47,6 +49,8 @@ static const struct xt_option_entry time_opts[] = {
 	 .excl = F_UTC},
 	{.name = "utc", .id = O_UTC, .type = XTTYPE_NONE,
 	 .excl = F_LOCAL_TZ},
+	{.name = "kerneltz", .id = O_KERNEL_TZ, .type = XTTYPE_NONE,
+	 .excl = F_UTC},
 	XTOPT_TABLEEND,
 };
 
@@ -63,7 +67,7 @@ static void time_help(void)
 "[!] --weekdays value     List of weekdays on which to match, sep. by comma\n"
 "                         (Possible days: Mon,Tue,Wed,Thu,Fri,Sat,Sun or 1 to 7\n"
 "                         Defaults to all weekdays.)\n"
-"    --localtz/--utc      Time is interpreted as UTC/local time\n");
+"    --ktz                Work with the kernel timezone instead of UTC\n");
 }
 
 static void time_init(struct xt_entry_match *m)
@@ -79,9 +83,6 @@ static void time_init(struct xt_entry_match *m)
 	/* ...and have no date-begin or date-end boundary */
 	info->date_start = 0;
 	info->date_stop  = INT_MAX;
-
-	/* local time is default */
-	info->flags |= XT_TIME_LOCAL_TZ;
 }
 
 static time_t time_parse_date(const char *s, bool end)
@@ -275,6 +276,11 @@ static void time_parse(struct xt_option_call *cb)
 		info->daytime_stop = time_parse_minutes(cb->arg);
 		break;
 	case O_LOCAL_TZ:
+		xtables_error(PARAMETER_PROBLEM,
+			"--localtz is no longer supported, see manpage "
+			"for details.");
+		break;
+	case O_KERNEL_TZ:
 		info->flags |= XT_TIME_LOCAL_TZ;
 		break;
 	case O_MONTHDAYS:
@@ -287,9 +293,6 @@ static void time_parse(struct xt_option_call *cb)
 		if (cb->invert)
 			info->weekdays_match ^= XT_TIME_ALL_WEEKDAYS;
 		break;
-	case O_UTC:
-		info->flags &= ~XT_TIME_LOCAL_TZ;
-		break;
 	}
 }
 
@@ -425,8 +428,8 @@ static void time_save(const void *ip, const struct xt_entry_match *match)
 	}
 	time_print_date(info->date_start, "--datestart");
 	time_print_date(info->date_stop, "--datestop");
-	if (!(info->flags & XT_TIME_LOCAL_TZ))
-		printf(" --utc");
+	if (info->flags & XT_TIME_LOCAL_TZ)
+		printf(" --kerneltz");
 }
 
 static struct xtables_match time_match = {
diff --git a/extensions/libxt_time.man b/extensions/libxt_time.man
index 4aff7ff..1d677b9 100644
--- a/extensions/libxt_time.man
+++ b/extensions/libxt_time.man
@@ -1,5 +1,6 @@
 This matches if the packet arrival time/date is within a given range. All
-options are optional, but are ANDed when specified.
+options are optional, but are ANDed when specified. All times are interpreted
+as UTC by default.
 .TP
 \fB\-\-datestart\fP \fIYYYY\fP[\fB\-\fP\fIMM\fP[\fB\-\fP\fIDD\fP[\fBT\fP\fIhh\fP[\fB:\fP\fImm\fP[\fB:\fP\fIss\fP]]]]]
 .TP
@@ -29,13 +30,35 @@ Only match on the given weekdays. Possible values are \fBMon\fP, \fBTue\fP,
 to \fB7\fP, respectively. You may also use two-character variants (\fBMo\fP,
 \fBTu\fP, etc.).
 .TP
-\fB\-\-utc\fP
-Interpret the times given for \fB\-\-datestart\fP, \fB\-\-datestop\fP,
-\fB\-\-timestart\fP and \fB\-\-timestop\fP to be UTC.
-.TP
-\fB\-\-localtz\fP
-Interpret the times given for \fB\-\-datestart\fP, \fB\-\-datestop\fP,
-\fB\-\-timestart\fP and \fB\-\-timestop\fP to be local kernel time. (Default)
+\fB\-\-kerneltz\fP
+Use the kernel timezone instead of UTC to determine whether a packet meets the
+time regulations.
+.PP
+About kernel timezones: Linux keeps the system time in UTC, and always does so.
+On boot, system time is initialized from a referential time source. Where this
+time source has no timezone information, such as the x86 CMOS RTC, UTC will be
+assumed. If the time source is however not in UTC, userspace should provide the
+correct system time and timezone to the kernel once it has the information.
+.PP
+Local time is a feature on top of the (timezone independent) system time. Each
+process has its own idea of local time, specified via the TZ environment
+variable. The kernel also has its own timezone offset variable. The TZ
+userspace environment variable specifies how the UTC-based system time is
+displayed, e.g. when you run date(1), or what you see on your desktop clock.
+The TZ string may resolve to different offsets at different dates, which is
+what enables the automatic time-jumping in userspace. when DST changes. The
+kernel's timezone offset variable is used when it has to convert between
+non-UTC sources, such as FAT filesystems, to UTC (since the latter is what the
+rest of the system uses).
+.PP
+The caveat with the kernel timezone is that Linux distributions may ignore to
+set the kernel timezone, and instead only set the system time. Even if a
+particular distribution does set the timezone at boot, it is usually does not
+keep the kernel timezone offset - which is what changes on DST - up to date.
+ntpd will not touch the kernel timezone, so running it will not resolve the
+issue. As such, one may encounter a timezone that is always +0000, or one that
+is wrong half of the time of the year. As such, \fBusing \-\-kerneltz is highly
+discouraged.\fP
 .PP
 EXAMPLES. To match on weekends, use:
 .IP
-- 
1.7.3.4

