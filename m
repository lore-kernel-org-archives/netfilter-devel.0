From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: xt_time 20070915 (iptables)
Date: Sat, 15 Sep 2007 19:41:58 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709151941490.24423@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709151806080.24423@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: kaber@trash.net
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0709151806080.24423@fbirervta.pbzchgretzou.qr>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <http://lists.netfilter.org/pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


libipt_time from POM-ng, augmented by:

 * day-of-month support (for example "match on the 15th of each month")
 * inversion support for --weekdays and --monthdays
 * a wonderful manpage

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/Makefile               |    2=20
 extensions/libipt_time.man        |   57 ++++
 extensions/libxt_time.c           |  473 +++++++++++++++++++++++++++++++=
+++++++
 include/linux/netfilter/xt_time.h |   13 +
 4 files changed, 544 insertions(+), 1 deletion(-)

Index: iptables/extensions/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/extensions/Makefile
+++ iptables/extensions/Makefile
@@ -7,7 +7,7 @@
 #
 PF_EXT_SLIB:=3Dah addrtype conntrack ecn icmp iprange owner policy realm=
 recent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP R=
EDIRECT REJECT SAME SNAT TOS TTL ULOG
 PF6_EXT_SLIB:=3Dah dst eui64 frag hbh hl icmp6 ipv6header mh owner polic=
y rt HL LOG REJECT
-PFX_EXT_SLIB:=3Dconnbytes connmark connlimit comment dccp dscp esp hashl=
imit helper length limit mac mark multiport physdev pkttype quota sctp st=
ate statistic standard string tcp tcpmss u32 udp CLASSIFY CONNMARK DSCP M=
ARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
+PFX_EXT_SLIB:=3Dconnbytes connmark connlimit comment dccp dscp esp hashl=
imit helper length limit mac mark multiport physdev pkttype quota sctp st=
ate statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK D=
SCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
=20
 PF_EXT_SELINUX_SLIB:=3D
 PF6_EXT_SELINUX_SLIB:=3D
Index: iptables/extensions/libipt_time.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/extensions/libipt_time.man
@@ -0,0 +1,57 @@
+This matches if the packet arrival time/date is within a given range. Al=
l
+options are optional, but are ANDed when specified.
+.TP
+\fB--datestart\fR \fIYYYY\fR[\fB-\fR\fIMM\fR[\fBT\fR\fIDD\fR[\fB-\fR\fIh=
h\fR[\fB:\fR\fImm\fR[\fB:\fR\fIss\fR]]]]]
+.TP
+\fB--datestop\fR \fIYYYY\fR[\fB-\fR\fIMM\fR[\fBT\fR\fIDD\fR[\fB-\fR\fIhh=
\fR[\fB:\fR\fImm\fR[\fB:\fR\fIss\fR]]]]]
+Only match during the given time, which must be in ISO 8601 notation. Po=
ssible
+values are \fB1970\fR to \fB2038\fR for the year \fIYYYY\fR, \fB1\fR to
+\fB12\fR for the month \fIMM\fR, \fB1\fR to \fB31\fR for the day \fIDD\f=
R
+(subject to limits of the selected month), \fB0\fR to \fB23\fR for the h=
our
+\fIHH\fR, and \fB0\fR to \fB59\fR for the minute \fIMM\fR and seconds \f=
ISS\fR.
+The minimum possible date is 1970-01-01, the maximum date is 2038-01-19
+04:17:07.
+.TP
+\fB--timestart\fR \fIHH\fR:\fIMM\fR
+.TP
+\fB--timestop\fR \fIHH\fR:\fIMM\fR
+Only match during the given daytime. Possible values are \fB0\fR to \fB2=
3\fR
+for \fIHH\fR and \fB0\fR to \fB59\fR for \fIMM\fR. Leading zeroes are al=
lowed
+and ignored, i.e. the numbers are always interpreted in base-10.
+.TP
+[\fB!\fR] \fB--monthday\fR \fIday\fR[\fB,\fR\fIday\fR...]
+Only match on the given days of the month. Possible values are \fB1\fR
+to \fB31\fR. Note that specifying \fB31\fR will of course not match
+on months which do not have a 31st day; the same goes for 28- or 29-day
+February.
+.TP
+[\fB!\fR] \fB--weekdays\fR \fIday\fR[\fB,\fR\fIday\fR...]
+Only match on the given weekdays. Possible values are \fBMon\fR, \fBTue\=
fR,
+\fBWed\fR, \fBThu\fR, \fBFri\fR, \fBSat\fR, \fBSun\fR, or values from \f=
B1\fR
+to \fB7\fR, respectively. You may also use two-character variants (\fBMo=
\fR,
+\fBTu\fR, etc.).
+.PP
+EXAMPLES. To match on weekends, use:
+.IP
+-m time --weekdays Sa,Su
+.PP
+Or to match (once) on a national holiday block:
+.IP
+-m time --datestart 2007-12-24 --datestop 2007-12-27
+.PP
+Since the stop time is actually inclusive, you would need this to not ma=
tch
+the first second of the new day:
+.IP
+-m time --datestart 2007-01-01T17:00 --datestop 2007-01-01T23:59:59
+.PP
+During lunch hour:
+.IP
+-m time --timestart 12:30 --timestop 13:30
+.PP
+The fourth Friday in the month:
+.IP
+-m time --weekdays Fr --monthdays 22,23,24,25,26,27,28
+.PP
+(Note that this exploits a certain mathematical property. It is not poss=
ible to
+say "fourth Thursday OR fourth Friday" in one rule. It is possible with
+multiple rules, though.)
Index: iptables/extensions/libxt_time.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/extensions/libxt_time.c
@@ -0,0 +1,473 @@
+/*
+ *	libxt_time - iptables part for xt_time
+ *	Copyright =C2=A9 Jan Engelhardt <jengelh@computergmbh.de>, 2007
+ *
+ *	libxt_time.c is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 or 3 of the License.
+ *
+ *	Based on libipt_time.c.
+ */
+#include <sys/types.h>
+#include <getopt.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <time.h>
+#include <linux/netfilter/xt_time.h>
+#include <xtables.h>
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*x))
+
+enum {
+	F_DATE_START =3D 1 << 0,
+	F_DATE_STOP  =3D 1 << 1,
+	F_TIME_START =3D 1 << 2,
+	F_TIME_STOP  =3D 1 << 3,
+	F_MONTHDAYS  =3D 1 << 4,
+	F_WEEKDAYS   =3D 1 << 5,
+};
+
+static const char *const week_days[] =3D {
+	NULL, "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun",
+};
+
+static const struct option time_opts[] =3D {
+	{"datestart", 1, NULL, 'D'},
+	{"datestop",  1, NULL, 'E'},
+	{"timestart", 1, NULL, 'X'},
+	{"timestop",  1, NULL, 'Y'},
+	{"weekdays",  1, NULL, 'w'},
+	{"monthdays", 1, NULL, 'm'},
+	{NULL},
+};
+
+static void time_help(void)
+{
+	printf(
+"TIME v%s options:\n"
+"  --datestart value     YYYY[-MM[-DD[Thh[:mm[:ss]]]]]\n"
+"                        If any of month, day, hour, minute or second is=
\n"
+"                        not specified, then defaults to their smallest =
value.\n"
+"                        1970 <=3D YYYY <=3D 2038    0 <=3D hh <=3D 23\n=
"
+"                           1 <=3D MM   <=3D 12      0 <=3D mm <=3D 59\n=
"
+"                           1 <=3D DD   <=3D 31      0 <=3D ss <=3D 59\n=
"
+"  --datestop value      YYYY[-MM[-DD[Thh[:mm[:ss]]]]]\n"
+"                        If the whole option is ommited, default to neve=
r stop.\n"
+"                        Unspecified fields default to their largest val=
ue.\n"
+"  --timestart value	 HH:MM (default 00:00)\n"
+"  --timestop  value     HH:MM (default 23:59)\n"
+"  --monthdays value     A list of days to apply, separated by comma\n"
+"                        Possible days: 1..31\n"
+"                        Defaults to all days of the months.\n"
+"  --weekdays  value     A list of days to apply, separated by comma\n"
+"                        Possible days: Mon,Tue,Wed,Thu,Fri,Sat,Sun or 1=
..7\n"
+"                        Defaults to all weekdays.\n",
+IPTABLES_VERSION);
+}
+
+static void time_init(struct xt_entry_match *m)
+{
+	struct xt_time_info *info =3D (void *)m->data;
+
+	/* By default, we match on every day, every daytime */
+	info->monthdays_match =3D 0xFFFFFFFE;
+	info->weekdays_match  =3D 0xFE;
+	info->time_start      =3D 0;
+	info->time_stop       =3D 24 * 60 - 1; /* 23:59 */
+
+	/* ...and have no date-begin or date-end boundary */
+	info->date_start =3D 0;
+	info->date_stop  =3D LONG_MAX;
+}
+
+static time_t time_parse_date(const char *s, bool end)
+{
+	unsigned int month =3D 1, day =3D 1, hour =3D 0, minute =3D 0, second =3D=
 0;
+	unsigned int year  =3D end ? 2038 : 1970;
+	const char *os =3D s;
+	struct tm tm;
+	time_t ret;
+	char *e;
+
+	year =3D strtoul(s, &e, 10);
+	if ((*e !=3D '-' && *e !=3D '\0') || year < 1970 || year > 2038)
+		goto out;
+	if (*e =3D=3D '\0')
+		goto eval;
+
+	s =3D e + 1;
+	month =3D strtoul(s, &e, 10);
+	if ((*e !=3D '-' && *e !=3D '\0') || month > 12)
+		goto out;
+	if (*e =3D=3D '\0')
+		goto eval;
+
+	s =3D e + 1;
+	day =3D strtoul(s, &e, 10);
+	if ((*e !=3D 'T' && *e !=3D '\0') || day > 31)
+		goto out;
+	if (*e =3D=3D '\0')
+		goto eval;
+
+	s =3D e + 1;
+	hour =3D strtoul(s, &e, 10);
+	if ((*e !=3D ':' && *e !=3D '\0') || hour > 23)
+		goto out;
+	if (*e =3D=3D '\0')
+		goto eval;
+
+	s =3D e + 1;
+	minute =3D strtoul(s, &e, 10);
+	if ((*e !=3D ':' && *e !=3D '\0') || minute > 59)
+		goto out;
+	if (*e =3D=3D '\0')
+		goto eval;
+
+	s =3D e + 1;
+	second =3D strtoul(s, &e, 10);
+	if (*e !=3D '\0' || second > 59)
+		goto out;
+
+ eval:
+	tm.tm_year =3D year - 1900;
+	tm.tm_mon  =3D month - 1;
+	tm.tm_mday =3D day;
+	tm.tm_hour =3D hour;
+	tm.tm_min  =3D minute;
+	tm.tm_sec  =3D second;
+	ret =3D mktime(&tm);
+	if (ret >=3D 0)
+		return ret;
+	perror("mktime");
+	exit_error(OTHER_PROBLEM, "mktime returned an error");
+
+ out:
+	exit_error(PARAMETER_PROBLEM, "Invalid date \"%s\" specified. Should "
+	           "be YYYY[-MM[-DD[Thh[:mm[:ss]]]]]", os);
+	return -1;
+}
+
+static unsigned int time_parse_minutes(const char *s)
+{
+	unsigned int hour, minute;
+	char *e;
+
+	hour =3D strtoul(s, &e, 10);
+	if (*e !=3D ':' || hour > 23)
+		goto out;
+	s =3D e + 1;
+	minute =3D strtoul(s, &e, 10);
+	if (*e !=3D '\0' || minute > 59)
+		goto out;
+
+	return hour * 60 + minute;
+
+ out:
+	exit_error(PARAMETER_PROBLEM, "invalid time \"%s\" specified, "
+	           "should be HH:MM format, with 0 <=3D HH <=3D 23 and "
+	           "0 <=3D MM <=3D 59", s);
+	return -1;
+}
+
+static const char *my_strseg(char *buf, unsigned int buflen,
+    const char **arg, char delim)
+{
+	const char *sep;
+
+	if (*arg =3D=3D NULL || **arg =3D=3D '\0')
+		return NULL;
+	sep =3D strchr(*arg, delim);
+	if (sep =3D=3D NULL) {
+		snprintf(buf, buflen, "%s", *arg);
+		*arg =3D NULL;
+		return buf;
+	}
+	snprintf(buf, buflen, "%.*s", (unsigned int)(sep - *arg), *arg);
+	*arg =3D sep + 1;
+	return buf;
+}
+
+static uint32_t time_parse_monthdays(const char *arg)
+{
+	char day[3], *err =3D NULL;
+	uint32_t ret =3D 0;
+	unsigned int i;
+
+	while (my_strseg(day, sizeof(day), &arg, ',') !=3D NULL) {
+		i =3D strtoul(day, &err, 0);
+		if ((*err !=3D ',' && *err !=3D '\0') || i > 31)
+			exit_error(PARAMETER_PROBLEM,
+			           "%s is not a valid day for --monthdays", day);
+		ret |=3D 1 << i;
+	}
+
+	return ret;
+}
+
+static unsigned int time_parse_weekdays(const char *arg)
+{
+	char day[4], *err =3D NULL;
+	unsigned int i, ret =3D 0;
+	bool valid;
+
+	while (my_strseg(day, sizeof(day), &arg, ',') !=3D NULL) {
+		i =3D strtoul(day, &err, 0);
+		if (*err =3D=3D '\0') {
+			if (i =3D=3D 0)
+				exit_error(PARAMETER_PROBLEM,
+				           "No, the week does not begin with Sunday.");
+			ret |=3D 1 << i;
+			continue;
+		}
+
+		valid =3D false;
+		for (i =3D 1; i < ARRAY_SIZE(week_days); ++i)
+			if (strncmp(day, week_days[i], 2) =3D=3D 0) {
+				ret |=3D 1 << i;
+				valid =3D true;
+			}
+
+		if (!valid)
+			exit_error(PARAMETER_PROBLEM,
+			           "%s is not a valid day specifier", day);
+	}
+
+	return ret;
+}
+
+static int time_parse(int c, char **argv, int invert, unsigned int *flag=
s,
+                      const void *entry, struct xt_entry_match **match)
+{
+	struct xt_time_info *info =3D (void *)(*match)->data;
+
+	switch (c) {
+	case 'D': /* --datestart */
+		if (*flags & F_DATE_START)
+			exit_error(PARAMETER_PROBLEM,
+			           "Cannot specify --datestart twice");
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+			           "Unexpected \"!\" with --datestart");
+		info->date_start =3D time_parse_date(optarg, false);
+		*flags |=3D F_DATE_START;
+		break;
+	case 'E': /* --datestop */
+		if (*flags & F_DATE_STOP)
+			exit_error(PARAMETER_PROBLEM,
+			           "Cannot specify --datestop more than once");
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+			           "unexpected \"!\" with --datestop");
+		info->date_stop =3D time_parse_date(optarg, true);
+		*flags |=3D F_DATE_STOP;
+		break;
+	case 'X': /* --timestart */
+		if (*flags & F_TIME_START)
+			exit_error(PARAMETER_PROBLEM,
+			           "Cannot specify --timestart more than once");
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+			           "Unexpected \"!\" with --timestart");
+		info->time_start =3D time_parse_minutes(optarg);
+		*flags |=3D F_TIME_START;
+		break;
+	case 'Y': /* --timestop */
+		if (*flags & F_TIME_STOP)
+			exit_error(PARAMETER_PROBLEM,
+			           "Cannot specify --timestop more than once");
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+			           "Unexpected \"!\" with --timestop");
+		info->time_stop =3D time_parse_minutes(optarg);
+		*flags |=3D F_TIME_STOP;
+		break;
+	case 'm': /* --monthdays */
+		if (*flags & F_MONTHDAYS)
+			exit_error(PARAMETER_PROBLEM,
+			           "Cannot specify --monthdays more than once");
+		info->monthdays_match =3D time_parse_monthdays(optarg);
+		if (invert)
+			info->monthdays_match =3D ~info->monthdays_match;
+		*flags |=3D F_MONTHDAYS;
+		break;
+	case 'w': /* --weekdays */
+		if (*flags & F_WEEKDAYS)
+			exit_error(PARAMETER_PROBLEM,
+			           "Cannot specify --weekdays more than once");
+		info->weekdays_match =3D time_parse_weekdays(optarg);
+		if (invert)
+			info->weekdays_match =3D ~info->weekdays_match;
+		*flags |=3D F_WEEKDAYS;
+		break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+static void time_check(unsigned int flags)
+{
+}
+
+static void time_print_date(time_t date, const char *command)
+{
+	struct tm *t;
+
+	/* If it is the default value, do not print it. */
+	if (date =3D=3D 0 || date =3D=3D LONG_MAX)
+		return;
+
+	t =3D localtime(&date);
+	if (command !=3D NULL)
+		/*
+		 * Need a contiguous string (no whitespaces), hence using
+		 * the ISO 8601 variant with "T" in it.
+		 */
+		printf("%s %04u-%02u-%02uT%02u:%02u:%02u ",
+		       command, t->tm_year + 1900, t->tm_mon + 1,
+		       t->tm_mday, t->tm_hour, t->tm_min, t->tm_sec);
+	else
+		printf("%04u-%02u-%02u %02u:%02u:%02u ",
+		       t->tm_year + 1900, t->tm_mon + 1, t->tm_mday,
+		       t->tm_hour, t->tm_min, t->tm_sec);
+}
+
+static void time_print_monthdays(uint32_t mask)
+{
+	unsigned int i, nbdays =3D 0;
+
+	for (i =3D 1; i <=3D 31; ++i)
+		if (mask & (1 << i)) {
+			if (nbdays > 0)
+				printf(",%u", i);
+			else
+				printf("%u", i);
+			++nbdays;
+		}
+	printf(" ");
+}
+
+static void time_print_weekdays(unsigned int mask)
+{
+	unsigned int i, nbdays =3D 0;
+
+	for (i =3D 1; i <=3D 7; ++i)
+		if (mask & (1 << i)) {
+			if (nbdays > 0)
+				printf(",%s", week_days[i]);
+			else
+				printf("%s", week_days[i]);
+			++nbdays;
+		}
+	printf(" of month ");
+}
+
+static inline void divide_time(unsigned int fulltime, unsigned int *hour=
s,
+    unsigned int *minutes)
+{
+	*hours   =3D fulltime / 60;
+	*minutes =3D fulltime % 60;
+}
+
+static void time_print(const void *ip, const struct xt_entry_match *matc=
h,
+                       int numeric)
+{
+	struct xt_time_info *time =3D (void *)match->data;
+	unsigned int hour_start, hour_stop, minute_start, minute_stop;
+
+	divide_time(time->time_start, &hour_start, &minute_start);
+	divide_time(time->time_stop, &hour_stop, &minute_stop);
+	printf("TIME ");
+
+	if (time->time_start !=3D 0)
+		printf("from %02u:%02u ", hour_start, minute_start);
+	if (time->time_stop !=3D 24 * 60 - 1)
+		printf("to %02u:%02u ", hour_stop, minute_stop);
+
+	printf("on ");
+	if ((time->weekdays_match & 0xFE) =3D=3D 0xFE)
+		printf("all weekdays ");
+	else
+		time_print_weekdays(time->weekdays_match);
+
+	printf("on ");
+	if ((time->monthdays_match & 0xFFFFFFFE) =3D=3D 0xFFFFFFFE)
+		printf("all days of the month ");
+	else
+		time_print_monthdays(time->monthdays_match);
+
+	if (time->date_start !=3D 0) {
+		printf("starting from ");
+		time_print_date(time->date_start, NULL);
+	}
+	if (time->date_stop !=3D LONG_MAX) {
+		printf("until date ");
+		time_print_date(time->date_stop, NULL);
+	}
+}
+
+static void time_save(const void *ip, const struct xt_entry_match *match=
)
+{
+	const struct xt_time_info *time =3D (const void *)match->data;
+	unsigned int hour_start, hour_stop, minute_start, minute_stop;
+
+	divide_time(time->time_start, &hour_start, &minute_start);
+	divide_time(time->time_stop, &hour_stop, &minute_stop);
+
+	if (time->time_start !=3D 0)
+		printf("--timestart %02u:%02u ",
+		       hour_start, minute_start);
+	if (time->time_stop !=3D 24 * 60 - 1)
+		printf("--timestop %02u:%02u ",
+		       hour_stop, minute_stop);
+	if ((time->monthdays_match & 0xFFFFFFFE) !=3D 0xFFFFFFFE) {
+		printf("--monthdays ");
+		time_print_monthdays(time->monthdays_match);
+		printf(" ");
+	}
+	if ((time->weekdays_match & 0xFE) !=3D 0xFE) {
+		printf("--weekdays ");
+		time_print_weekdays(time->weekdays_match);
+		printf(" ");
+	}
+	time_print_date(time->date_start, "--datestart");
+	time_print_date(time->date_stop, "--datestop");
+}
+
+static struct xtables_match time_reg =3D {
+	.name          =3D "time",
+	.family        =3D AF_INET,
+	.version       =3D IPTABLES_VERSION,
+	.size          =3D XT_ALIGN(sizeof(struct xt_time_info)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_time_info)),
+	.help          =3D time_help,
+	.init          =3D time_init,
+	.parse         =3D time_parse,
+	.final_check   =3D time_check,
+	.print         =3D time_print,
+	.save          =3D time_save,
+	.extra_opts    =3D time_opts,
+};
+
+static struct xtables_match time6_reg =3D {
+	.name          =3D "time",
+	.family        =3D AF_INET6,
+	.version       =3D IPTABLES_VERSION,
+	.size          =3D XT_ALIGN(sizeof(struct xt_time_info)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_time_info)),
+	.help          =3D time_help,
+	.init          =3D time_init,
+	.parse         =3D time_parse,
+	.final_check   =3D time_check,
+	.print         =3D time_print,
+	.save          =3D time_save,
+	.extra_opts    =3D time_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&time_reg);
+	xtables_register_match(&time6_reg);
+}
Index: iptables/include/linux/netfilter/xt_time.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/include/linux/netfilter/xt_time.h
@@ -0,0 +1,13 @@
+#ifndef _XT_TIME_H
+#define _XT_TIME_H 1
+
+struct xt_time_info {
+	time_t date_start;
+	time_t date_stop;
+	u_int32_t monthdays_match;
+	u_int16_t time_start;
+	u_int16_t time_stop;
+	u_int8_t weekdays_match;
+};
+
+#endif /* _XT_TIME_H */
