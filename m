From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: xt_time 2007-09-22 (iptables)
Date: Sat, 22 Sep 2007 13:28:02 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709221326540.15712@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709221315590.15712@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36311 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbXIVL2D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Sep 2007 07:28:03 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 57C3F1C07021E
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Sep 2007 13:28:02 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0709221315590.15712@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Add the libxt_time iptables match

This is libipt_time from POM-ng enhanced by the following:

 * day-of-month support (for example "match on the 15th of each month")
 * inversion support for --weekdays and --monthdays
 * match against UTC or local timezone
 * a manpage

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/Makefile               |    2=20
 extensions/libipt_time.man        |   69 +++++
 extensions/libxt_time.c           |  504 +++++++++++++++++++++++++++++=
+++++++++
 include/linux/netfilter/xt_time.h |   25 +
 4 files changed, 599 insertions(+), 1 deletion(-)

Index: iptables/extensions/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/extensions/Makefile
+++ iptables/extensions/Makefile
@@ -7,7 +7,7 @@
 #
 PF_EXT_SLIB:=3Dah addrtype conntrack ecn icmp iprange owner policy rea=
lm recent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETM=
AP REDIRECT REJECT SAME SNAT TOS TTL ULOG
 PF6_EXT_SLIB:=3Dah dst eui64 frag hbh hl icmp6 ipv6header mh owner pol=
icy rt HL LOG REJECT
-PFX_EXT_SLIB:=3Dconnbytes connmark connlimit comment dccp dscp esp has=
hlimit helper length limit mac mark multiport physdev pkttype quota sct=
p state statistic standard string tcp tcpmss u32 udp CLASSIFY CONNMARK =
DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
+PFX_EXT_SLIB:=3Dconnbytes connmark connlimit comment dccp dscp esp has=
hlimit helper length limit mac mark multiport physdev pkttype quota sct=
p state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONN=
MARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
=20
 PF_EXT_SELINUX_SLIB:=3D
 PF6_EXT_SELINUX_SLIB:=3D
Index: iptables/extensions/libipt_time.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/extensions/libipt_time.man
@@ -0,0 +1,69 @@
+This matches if the packet arrival time/date is within a given range. =
All
+options are optional, but are ANDed when specified.
+.TP
+\fB--datestart\fR \fIYYYY\fR[\fB-\fR\fIMM\fR[\fB-\fR\fIDD\fR[\fBT\fR\f=
Ihh\fR[\fB:\fR\fImm\fR[\fB:\fR\fIss\fR]]]]]
+.TP
+\fB--datestop\fR \fIYYYY\fR[\fB-\fR\fIMM\fR[\fB-\fR\fIDD\fR[\fBT\fR\fI=
hh\fR[\fB:\fR\fImm\fR[\fB:\fR\fIss\fR]]]]]
+.IP
+Only match during the given time, which must be in ISO 8601 "T" notati=
on.
+The possible time range is 1970-01-01T00:00:00 to 2038-01-19T04:17:07.
+.IP
+If --datestart or --datestop are not specified, it will default to 197=
0-01-01
+and 2038-01-19, respectively.
+.TP
+\fB--timestart\fR \fIhh\fR\fB:\fR\fImm\fR[\fB:\fR\fIss\fR]
+.TP
+\fB--timestop\fR \fIhh\fR\fB:\fR\fImm\fR[\fB:\fR\fIss\fR]
+.IP
+Only match during the given daytime. The possible time range is 00:00:=
00 to
+23:59:59. Leading zeroes are allowed (e.g. "06:03") and correctly inte=
rpreted
+as base-10.
+.TP
+[\fB!\fR] \fB--monthday\fR \fIday\fR[\fB,\fR\fIday\fR...]
+.IP
+Only match on the given days of the month. Possible values are \fB1\fR
+to \fB31\fR. Note that specifying \fB31\fR will of course not match
+on months which do not have a 31st day; the same goes for 28- or 29-da=
y
+February.
+.TP
+[\fB!\fR] \fB--weekdays\fR \fIday\fR[\fB,\fR\fIday\fR...]
+.IP
+Only match on the given weekdays. Possible values are \fBMon\fR, \fBTu=
e\fR,
+\fBWed\fR, \fBThu\fR, \fBFri\fR, \fBSat\fR, \fBSun\fR, or values from =
\fB1\fR
+to \fB7\fR, respectively. You may also use two-character variants (\fB=
Mo\fR,
+\fBTu\fR, etc.).
+.TP
+\fB--utc\fR
+.IP
+Interpret the times given for \fB--datestart\fR, \fB--datestop\fR,
+\fB--timestart\fR and \fB--timestop\fR to be UTC.
+.TP
+\fB--localtz\fR
+.IP
+Interpret the times given for \fB--datestart\fR, \fB--datestop\fR,
+\fB--timestart\fR and \fB--timestop\fR to be local kernel time. (Defau=
lt)
+.PP
+EXAMPLES. To match on weekends, use:
+.IP
+-m time --weekdays Sa,Su
+.PP
+Or, to match (once) on a national holiday block:
+.IP
+-m time --datestart 2007-12-24 --datestop 2007-12-27
+.PP
+Since the stop time is actually inclusive, you would need the followin=
g stop
+time to not match the first second of the new day:
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
+(Note that this exploits a certain mathematical property. It is not po=
ssible to
+say "fourth Thursday OR fourth Friday" in one rule. It is possible wit=
h
+multiple rules, though.)
Index: iptables/extensions/libxt_time.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/extensions/libxt_time.c
@@ -0,0 +1,504 @@
+/*
+ *	libxt_time - iptables part for xt_time
+ *	Copyright =C2=A9 Jan Engelhardt <jengelh@computergmbh.de>, 2007
+ *
+ *	libxt_time.c is free software; you can redistribute it and/or modif=
y
+ *	it under the terms of the GNU General Public License as published b=
y
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
+enum { /* getopt "seen" bits */
+	F_DATE_START =3D 1 << 0,
+	F_DATE_STOP  =3D 1 << 1,
+	F_TIME_START =3D 1 << 2,
+	F_TIME_STOP  =3D 1 << 3,
+	F_MONTHDAYS  =3D 1 << 4,
+	F_WEEKDAYS   =3D 1 << 5,
+	F_TIMEZONE   =3D 1 << 6,
+};
+
+static const char *const week_days[] =3D {
+	NULL, "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun",
+};
+
+static const struct option time_opts[] =3D {
+	{"datestart", true,  NULL, 'D'},
+	{"datestop",  true,  NULL, 'E'},
+	{"timestart", true,  NULL, 'X'},
+	{"timestop",  true,  NULL, 'Y'},
+	{"weekdays",  true,  NULL, 'w'},
+	{"monthdays", true,  NULL, 'm'},
+	{"localtz",   false, NULL, 'l'},
+	{"utc",       false, NULL, 'u'},
+	{NULL},
+};
+
+static void time_help(void)
+{
+	printf(
+"TIME v%s options:\n"
+"  --datestart time     Start and stop time, to be given in ISO 8601\n=
"
+"  --datestop time      (YYYY[-MM[-DD[Thh[:mm[:ss]]]]])\n"
+"  --timestart time     Start and stop daytime (hh:mm[:ss])\n"
+"  --timestop time      (between 00:00:00 and 23:59:59)\n"
+"  --monthdays value    List of days on which to match, separated by c=
omma\n"
+"                       (Possible days: 1 to 31; defaults to all)\n"
+"  --weekdays value     List of weekdays on which to match, sep. by co=
mma\n"
+"                       (Possible days: Mon,Tue,Wed,Thu,Fri,Sat,Sun or=
 1 to 7\n"
+"                       Defaults to all weekdays.)\n"
+"  --localtz/--utc      Time is interpreted as UTC/local time\n",
+IPTABLES_VERSION);
+}
+
+static void time_init(struct xt_entry_match *m)
+{
+	struct xt_time_info *info =3D (void *)m->data;
+
+	/* By default, we match on every day, every daytime */
+	info->monthdays_match =3D XT_TIME_ALL_MONTHDAYS;
+	info->weekdays_match  =3D XT_TIME_ALL_WEEKDAYS;
+	info->daytime_start   =3D XT_TIME_MIN_DAYTIME;
+	info->daytime_stop    =3D XT_TIME_MAX_DAYTIME;
+
+	/* ...and have no date-begin or date-end boundary */
+	info->date_start =3D 0;
+	info->date_stop  =3D LONG_MAX;
+
+	/* local time is default */
+	info->flags |=3D XT_TIME_LOCAL_TZ;
+}
+
+static time_t time_parse_date(const char *s, bool end)
+{
+	unsigned int month =3D 1, day =3D 1, hour =3D 0, minute =3D 0, second=
 =3D 0;
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
+	exit_error(PARAMETER_PROBLEM, "Invalid date \"%s\" specified. Should =
"
+	           "be YYYY[-MM[-DD[Thh[:mm[:ss]]]]]", os);
+	return -1;
+}
+
+static unsigned int time_parse_minutes(const char *s)
+{
+	unsigned int hour, minute, second =3D 0;
+	char *e;
+
+	hour =3D strtoul(s, &e, 10);
+	if (*e !=3D ':' || hour > 23)
+		goto out;
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
+	return 60 * 60 * hour + 60 * minute + second;
+
+ out:
+	exit_error(PARAMETER_PROBLEM, "invalid time \"%s\" specified, "
+	           "should be hh:mm[:ss] format and within the boundaries", s=
);
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
+				           "No, the week does NOT begin with Sunday.");
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
+static int time_parse(int c, char **argv, int invert, unsigned int *fl=
ags,
+                      const void *entry, struct xt_entry_match **match=
)
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
+		return 1;
+	case 'E': /* --datestop */
+		if (*flags & F_DATE_STOP)
+			exit_error(PARAMETER_PROBLEM,
+			           "Cannot specify --datestop more than once");
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+			           "unexpected \"!\" with --datestop");
+		info->date_stop =3D time_parse_date(optarg, true);
+		*flags |=3D F_DATE_STOP;
+		return 1;
+	case 'X': /* --timestart */
+		if (*flags & F_TIME_START)
+			exit_error(PARAMETER_PROBLEM,
+			           "Cannot specify --timestart more than once");
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+			           "Unexpected \"!\" with --timestart");
+		info->daytime_start =3D time_parse_minutes(optarg);
+		*flags |=3D F_TIME_START;
+		return 1;
+	case 'Y': /* --timestop */
+		if (*flags & F_TIME_STOP)
+			exit_error(PARAMETER_PROBLEM,
+			           "Cannot specify --timestop more than once");
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+			           "Unexpected \"!\" with --timestop");
+		info->daytime_stop =3D time_parse_minutes(optarg);
+		*flags |=3D F_TIME_STOP;
+		return 1;
+	case 'l': /* --localtz */
+		if (*flags & F_TIMEZONE)
+			exit_error(PARAMETER_PROBLEM,
+			           "Can only specify exactly one of --localtz or --utc");
+		info->flags |=3D XT_TIME_LOCAL_TZ;
+		*flags |=3D F_TIMEZONE;
+		return 1;
+	case 'm': /* --monthdays */
+		if (*flags & F_MONTHDAYS)
+			exit_error(PARAMETER_PROBLEM,
+			           "Cannot specify --monthdays more than once");
+		info->monthdays_match =3D time_parse_monthdays(optarg);
+		if (invert)
+			info->monthdays_match ^=3D XT_TIME_ALL_MONTHDAYS;
+		*flags |=3D F_MONTHDAYS;
+		return 1;
+	case 'w': /* --weekdays */
+		if (*flags & F_WEEKDAYS)
+			exit_error(PARAMETER_PROBLEM,
+			           "Cannot specify --weekdays more than once");
+		info->weekdays_match =3D time_parse_weekdays(optarg);
+		if (invert)
+			info->weekdays_match ^=3D XT_TIME_ALL_WEEKDAYS;
+		*flags |=3D F_WEEKDAYS;
+		return 1;
+	case 'u': /* --utc */
+		if (*flags & F_TIMEZONE)
+			exit_error(PARAMETER_PROBLEM,
+			           "Can only specify exactly one of --localtz or --utc");
+		info->flags &=3D ~XT_TIME_LOCAL_TZ;
+		*flags |=3D F_TIMEZONE;
+		return 1;
+	}
+	return 0;
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
+		 * the ISO 8601 "T" variant.
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
+static void time_print_monthdays(uint32_t mask, bool human_readable)
+{
+	unsigned int i, nbdays =3D 0;
+
+	for (i =3D 1; i <=3D 31; ++i)
+		if (mask & (1 << i)) {
+			if (nbdays++ > 0)
+				printf(",");
+			printf("%u", i);
+			if (human_readable)
+				switch (i % 10) {
+					case 1:
+						printf("st");
+						break;
+					case 2:
+						printf("nd");
+						break;
+					case 3:
+						printf("rd");
+						break;
+					default:
+						printf("th");
+						break;
+				}
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
+	printf(" ");
+}
+
+static inline void divide_time(unsigned int fulltime, unsigned int *ho=
urs,
+    unsigned int *minutes, unsigned int *seconds)
+{
+	*seconds  =3D fulltime % 60;
+	fulltime /=3D 60;
+	*minutes  =3D fulltime % 60;
+	*hours    =3D fulltime / 60;
+}
+
+static void time_print(const void *ip, const struct xt_entry_match *ma=
tch,
+                       int numeric)
+{
+	struct xt_time_info *info =3D (void *)match->data;
+	unsigned int h, m, s;
+
+	printf("TIME ");
+
+	if (info->daytime_start !=3D XT_TIME_MIN_DAYTIME ||
+	    info->daytime_stop !=3D XT_TIME_MAX_DAYTIME) {
+		divide_time(info->daytime_start, &h, &m, &s);
+		printf("from %02u:%02u:%02u ", h, m, s);
+		divide_time(info->daytime_stop, &h, &m, &s);
+		printf("to %02u:%02u:%02u ", h, m, s);
+	}
+	if (info->weekdays_match !=3D XT_TIME_ALL_WEEKDAYS) {
+		printf("on ");
+		time_print_weekdays(info->weekdays_match);
+	}
+	if (info->monthdays_match !=3D XT_TIME_ALL_MONTHDAYS) {
+		printf("on ");
+		time_print_monthdays(info->monthdays_match, true);
+	}
+	if (info->date_start !=3D 0) {
+		printf("starting from ");
+		time_print_date(info->date_start, NULL);
+	}
+	if (info->date_stop !=3D LONG_MAX) {
+		printf("until date ");
+		time_print_date(info->date_stop, NULL);
+	}
+	if (!(info->flags & XT_TIME_LOCAL_TZ))
+		printf("UTC ");
+}
+
+static void time_save(const void *ip, const struct xt_entry_match *mat=
ch)
+{
+	const struct xt_time_info *info =3D (const void *)match->data;
+	unsigned int h, m, s;
+
+	if (info->daytime_start !=3D XT_TIME_MIN_DAYTIME ||
+	    info->daytime_stop !=3D XT_TIME_MAX_DAYTIME) {
+		divide_time(info->daytime_start, &h, &m, &s);
+		printf("--timestart %02u:%02u:%02u ", h, m, s);
+		divide_time(info->daytime_stop, &h, &m, &s);
+		printf("--timestop %02u:%02u:%02u ", h, m, s);
+	}
+	if (info->monthdays_match !=3D XT_TIME_ALL_MONTHDAYS) {
+		printf("--monthdays ");
+		time_print_monthdays(info->monthdays_match, false);
+	}
+	if (info->weekdays_match !=3D XT_TIME_ALL_WEEKDAYS) {
+		printf("--weekdays ");
+		time_print_weekdays(info->weekdays_match);
+		printf(" ");
+	}
+	time_print_date(info->date_start, "--datestart");
+	time_print_date(info->date_stop, "--datestop");
+	if (!(info->flags & XT_TIME_LOCAL_TZ))
+		printf("--utc ");
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
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/include/linux/netfilter/xt_time.h
@@ -0,0 +1,25 @@
+#ifndef _XT_TIME_H
+#define _XT_TIME_H 1
+
+struct xt_time_info {
+	u_int32_t date_start;
+	u_int32_t date_stop;
+	u_int32_t daytime_start;
+	u_int32_t daytime_stop;
+	u_int32_t monthdays_match;
+	u_int8_t weekdays_match;
+	u_int8_t flags;
+};
+
+enum {
+	/* Match against local time (instead of UTC) */
+	XT_TIME_LOCAL_TZ =3D 1 << 0,
+
+	/* Shortcuts */
+	XT_TIME_ALL_MONTHDAYS =3D 0xFFFFFFFE,
+	XT_TIME_ALL_WEEKDAYS  =3D 0xFE,
+	XT_TIME_MIN_DAYTIME   =3D 0,
+	XT_TIME_MAX_DAYTIME   =3D 24 * 60 * 60 - 1,
+};
+
+#endif /* _XT_TIME_H */
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
