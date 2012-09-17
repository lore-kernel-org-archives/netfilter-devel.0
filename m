From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] libxt_time: add support to ignore day transition
Date: Mon, 17 Sep 2012 12:23:08 +0200
Message-ID: <1347877389-15728-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35387 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751462Ab2IQKVQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:21:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, if you want to do something like:
"match Monday, starting 23:00, for two hours"
You need two rules, one for Mon 23:00 to 0:00 and one for Tue 0:00-1:00.
The rule
--weekdays Mo --timestart 23:00  --timestop 01:00
looks correct, but it will first match on monday from midnight to 1 a.m.
and then again for another hour from 23:00 onwards.

This permits userspace to explicitly ignore the day transition and
match for a single, continuous time period instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_time.c           |   20 ++++++++++++++++++++
 extensions/libxt_time.man         |   12 ++++++++++++
 include/linux/netfilter/xt_time.h |    1 +
 3 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index 44c05b8..9c5bda8 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -22,6 +22,7 @@ enum {
 	O_DATE_STOP,
 	O_TIME_START,
 	O_TIME_STOP,
+	O_TIME_CONTIGUOUS,
 	O_MONTHDAYS,
 	O_WEEKDAYS,
 	O_LOCAL_TZ,
@@ -30,6 +31,7 @@ enum {
 	F_LOCAL_TZ  = 1 << O_LOCAL_TZ,
 	F_UTC       = 1 << O_UTC,
 	F_KERNEL_TZ = 1 << O_KERNEL_TZ,
+	F_TIME_CONTIGUOUS = 1 << O_TIME_CONTIGUOUS,
 };
 
 static const char *const week_days[] = {
@@ -41,6 +43,7 @@ static const struct xt_option_entry time_opts[] = {
 	{.name = "datestop", .id = O_DATE_STOP, .type = XTTYPE_STRING},
 	{.name = "timestart", .id = O_TIME_START, .type = XTTYPE_STRING},
 	{.name = "timestop", .id = O_TIME_STOP, .type = XTTYPE_STRING},
+	{.name = "contiguous", .id = O_TIME_CONTIGUOUS, .type = XTTYPE_NONE},
 	{.name = "weekdays", .id = O_WEEKDAYS, .type = XTTYPE_STRING,
 	 .flags = XTOPT_INVERT},
 	{.name = "monthdays", .id = O_MONTHDAYS, .type = XTTYPE_STRING,
@@ -273,6 +276,9 @@ static void time_parse(struct xt_option_call *cb)
 	case O_TIME_STOP:
 		info->daytime_stop = time_parse_minutes(cb->arg);
 		break;
+	case O_TIME_CONTIGUOUS:
+		info->flags |= XT_TIME_CONTIGUOUS;
+		break;
 	case O_LOCAL_TZ:
 		fprintf(stderr, "WARNING: --localtz is being replaced by "
 		        "--kerneltz, since \"local\" is ambiguous. Note the "
@@ -403,6 +409,8 @@ static void time_print(const void *ip, const struct xt_entry_match *match,
 	}
 	if (!(info->flags & XT_TIME_LOCAL_TZ))
 		printf(" UTC");
+	if (info->flags & XT_TIME_CONTIGUOUS)
+		printf(" contiguous");
 }
 
 static void time_save(const void *ip, const struct xt_entry_match *match)
@@ -429,6 +437,17 @@ static void time_save(const void *ip, const struct xt_entry_match *match)
 	time_print_date(info->date_stop, "--datestop");
 	if (info->flags & XT_TIME_LOCAL_TZ)
 		printf(" --kerneltz");
+	if (info->flags & XT_TIME_CONTIGUOUS)
+		printf(" --contiguous");
+}
+
+static void time_check(struct xt_fcheck_call *cb)
+{
+	const struct xt_time_info *info = (const void *) cb->data;
+	if ((cb->xflags & F_TIME_CONTIGUOUS) &&
+	     info->daytime_start < info->daytime_stop)
+		xtables_error(PARAMETER_PROBLEM,
+			"time: --contiguous only makes sense when stoptime is smaller than starttime");
 }
 
 static struct xtables_match time_match = {
@@ -442,6 +461,7 @@ static struct xtables_match time_match = {
 	.print         = time_print,
 	.save          = time_save,
 	.x6_parse      = time_parse,
+	.x6_fcheck     = time_check,
 	.x6_options    = time_opts,
 };
 
diff --git a/extensions/libxt_time.man b/extensions/libxt_time.man
index 1d677b9..4c0cae0 100644
--- a/extensions/libxt_time.man
+++ b/extensions/libxt_time.man
@@ -30,6 +30,10 @@ Only match on the given weekdays. Possible values are \fBMon\fP, \fBTue\fP,
 to \fB7\fP, respectively. You may also use two-character variants (\fBMo\fP,
 \fBTu\fP, etc.).
 .TP
+\fB\-\-contiguous\fP
+When \fB\-\-timestop\fP is smaller than \fB\-\-timestart\fP value, match
+this as a single time period instead distinct intervals.  See EXAMPLES.
+.TP
 \fB\-\-kerneltz\fP
 Use the kernel timezone instead of UTC to determine whether a packet meets the
 time regulations.
@@ -84,3 +88,11 @@ The fourth Friday in the month:
 (Note that this exploits a certain mathematical property. It is not possible to
 say "fourth Thursday OR fourth Friday" in one rule. It is possible with
 multiple rules, though.)
+.PP
+Matching across days might not do what is expected.  For instance,
+.IP
+\-m time \-\-weekdays Mo \-\-timestart 23:00  \-\-timestop 01:00
+Will match Monday, for one hour from midnight to 1 a.m., and then
+again for another hour from 23:00 onwards.  If this is unwanted, e.g. if you
+would like 'match for two hours from Montay 23:00 onwards' you need to also specify
+the \-\-contiguous option in the example above.
diff --git a/include/linux/netfilter/xt_time.h b/include/linux/netfilter/xt_time.h
index 7c37fac..a21d5bf 100644
--- a/include/linux/netfilter/xt_time.h
+++ b/include/linux/netfilter/xt_time.h
@@ -16,6 +16,7 @@ struct xt_time_info {
 enum {
 	/* Match against local time (instead of UTC) */
 	XT_TIME_LOCAL_TZ = 1 << 0,
+	XT_TIME_CONTIGUOUS = 1 << 1,
 
 	/* Shortcuts */
 	XT_TIME_ALL_MONTHDAYS = 0xFFFFFFFE,
-- 
1.7.8.6

