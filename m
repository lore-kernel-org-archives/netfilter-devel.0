From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] Time match module port to IPv6
Date: Sat, 3 May 2003 17:18:19 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0305031716090.24297@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-23717851-208348636-1051975099=:24297"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---23717851-208348636-1051975099=:24297
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hello,

Here is another Fabrice's module ported to IPv6.
This time i am using .time-test6 file :)

Regards,
Maciej

diff -Nru netfilter.orig/patch-o-matic/base/time.patch.ipv6 netfilter/patch-o-matic/base/time.patch.ipv6
--- netfilter.orig/patch-o-matic/base/time.patch.ipv6	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/time.patch.ipv6	2003-05-03 16:56:46.000000000 +0200
@@ -0,0 +1,207 @@
+diff -Nru linux.orig/include/linux/netfilter_ipv6/ip6t_time.h linux/include/linux/netfilter_ipv6/ip6t_time.h
+--- linux.orig/include/linux/netfilter_ipv6/ip6t_time.h	1970-01-01 01:00:00.000000000 +0100
++++ linux/include/linux/netfilter_ipv6/ip6t_time.h	2003-04-30 16:07:14.000000000 +0200
+@@ -0,0 +1,13 @@
++#ifndef __ip6t_time_h_included__
++#define __ip6t_time_h_included__
++
++
++struct ip6t_time_info {
++	u_int8_t  days_match;   /* 1 bit per day. -SMTWTFS                      */
++	u_int16_t time_start;   /* 0 < time_start < 23*60+59 = 1439             */
++	u_int16_t time_stop;    /* 0:0 < time_stat < 23:59                      */
++	u_int8_t  kerneltime;   /* ignore skb time (and use kerneltime) or not. */
++};
++
++
++#endif /* __ip6t_time_h_included__ */
+diff -Nru linux.orig/net/ipv6/netfilter/ip6t_time.c linux/net/ipv6/netfilter/ip6t_time.c
+--- linux.orig/net/ipv6/netfilter/ip6t_time.c	1970-01-01 01:00:00.000000000 +0100
++++ linux/net/ipv6/netfilter/ip6t_time.c	2003-04-30 16:24:33.000000000 +0200
+@@ -0,0 +1,186 @@
++/*
++  This is a module which is used for time matching
++  It is using some modified code from dietlibc (localtime() function)
++  that you can find at http://www.fefe.de/dietlibc/
++  This file is distributed under the terms of the GNU General Public
++  License (GPL). Copies of the GPL can be obtained from: ftp://prep.ai.mit.edu/pub/gnu/GPL
++  2001-05-04 Fabrice MARIE <fabrice@netfilter.org> : initial development.
++  2001-21-05 Fabrice MARIE <fabrice@netfilter.org> : bug fix in the match code,
++     thanks to "Zeng Yu" <zengy@capitel.com.cn> for bug report.
++  2001-26-09 Fabrice MARIE <fabrice@netfilter.org> : force the match to be in LOCAL_IN or PRE_ROUTING only.
++  2001-30-11 Fabrice : added the possibility to use the match in FORWARD/OUTPUT with a little hack,
++     added Nguyen Dang Phuoc Dong <dongnd@tlnet.com.vn> patch to support timezones.
++  2003-04-30 Maciej Soltysiak <solt@dns.toxicfilms.tv> : IPv6 Port
++*/
++
++#include <linux/module.h>
++#include <linux/skbuff.h>
++#include <linux/netfilter_ipv6/ip6_tables.h>
++#include <linux/netfilter_ipv6/ip6t_time.h>
++#include <linux/time.h>
++
++MODULE_AUTHOR("Fabrice MARIE <fabrice@netfilter.org>");
++MODULE_DESCRIPTION("Match arrival timestamp");
++MODULE_LICENSE("GPL");
++
++struct tm
++{
++	int tm_sec;                   /* Seconds.     [0-60] (1 leap second) */
++	int tm_min;                   /* Minutes.     [0-59] */
++	int tm_hour;                  /* Hours.       [0-23] */
++	int tm_mday;                  /* Day.         [1-31] */
++	int tm_mon;                   /* Month.       [0-11] */
++	int tm_year;                  /* Year - 1900.  */
++	int tm_wday;                  /* Day of week. [0-6] */
++	int tm_yday;                  /* Days in year.[0-365] */
++	int tm_isdst;                 /* DST.         [-1/0/1]*/
++
++	long int tm_gmtoff;           /* we don't care, we count from GMT */
++	const char *tm_zone;          /* we don't care, we count from GMT */
++};
++
++void
++localtime(const time_t *timepr, struct tm *r);
++
++static int
++match(const struct sk_buff *skb,
++      const struct net_device *in,
++      const struct net_device *out,
++      const void *matchinfo,
++      int offset,
++      const void *hdr,
++      u_int16_t datalen,
++      int *hotdrop)
++{
++	const struct ip6t_time_info *info = matchinfo;   /* match info for rule */
++	struct tm currenttime;                          /* time human readable */
++	u_int8_t days_of_week[7] = {64, 32, 16, 8, 4, 2, 1};
++	u_int16_t packet_time;
++	struct timeval kerneltimeval;
++	time_t packet_local_time;
++
++	/* if kerneltime=1, we don't read the skb->timestamp but kernel time instead */
++	if (info->kerneltime)
++	{
++		do_gettimeofday(&kerneltimeval);
++		packet_local_time = kerneltimeval.tv_sec;
++	}
++	else
++		packet_local_time = skb->stamp.tv_sec;
++
++	/* Transform the timestamp of the packet, in a human readable form */
++	localtime(&packet_local_time, &currenttime);
++
++	/* check if we match this timestamp, we start by the days... */
++	if ((days_of_week[currenttime.tm_wday] & info->days_match) != days_of_week[currenttime.tm_wday])
++		return 0; /* the day doesn't match */
++
++	/* ... check the time now */
++	packet_time = (currenttime.tm_hour * 60) + currenttime.tm_min;
++	if ((packet_time < info->time_start) || (packet_time > info->time_stop))
++		return 0;
++
++	/* here we match ! */
++	return 1;
++}
++
++static int
++checkentry(const char *tablename,
++           const struct ip6t_ip6 *ip,
++           void *matchinfo,
++           unsigned int matchsize,
++           unsigned int hook_mask)
++{
++	struct ip6t_time_info *info = matchinfo;   /* match info for rule */
++
++	/* First, check that we are in the correct hook */
++	/* PRE_ROUTING, LOCAL_IN or FROWARD */
++	if (hook_mask
++            & ~((1 << NF_IP6_PRE_ROUTING) | (1 << NF_IP6_LOCAL_IN) | (1 << NF_IP6_FORWARD) | (1 << NF_IP6_LOCAL_OUT)))
++	{
++		printk("ip6t_time: error, only valid for PRE_ROUTING, LOCAL_IN, FORWARD and OUTPUT)\n");
++		return 0;
++	}
++	/* we use the kerneltime if we are in forward or output */
++	info->kerneltime = 1;
++	if (hook_mask & ~((1 << NF_IP6_FORWARD) | (1 << NF_IP6_LOCAL_OUT)))
++		/* if not, we use the skb time */
++		info->kerneltime = 0;
++
++	/* Check the size */
++	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_time_info)))
++		return 0;
++	/* Now check the coherence of the data ... */
++	if ((info->time_start > 1439) ||        /* 23*60+59 = 1439*/
++	    (info->time_stop  > 1439))
++	{
++		printk(KERN_WARNING "ip6t_time: invalid argument\n");
++		return 0;
++	}
++
++	return 1;
++}
++
++static struct ip6t_match time_match
++= { { NULL, NULL }, "time", &match, &checkentry, NULL, THIS_MODULE };
++
++static int __init init(void)
++{
++	printk("ip6t_time loading\n");
++	return ip6t_register_match(&time_match);
++}
++
++static void __exit fini(void)
++{
++	ip6t_unregister_match(&time_match);
++	printk("ip6t_time unloaded\n");
++}
++
++module_init(init);
++module_exit(fini);
++
++
++/* The part below is borowed and modified from dietlibc */
++
++/* seconds per day */
++#define SPD 24*60*60
++
++void
++localtime(const time_t *timepr, struct tm *r) {
++	time_t i;
++	time_t timep;
++	extern struct timezone sys_tz;
++	const unsigned int __spm[12] =
++		{ 0,
++		  (31),
++		  (31+28),
++		  (31+28+31),
++		  (31+28+31+30),
++		  (31+28+31+30+31),
++		  (31+28+31+30+31+30),
++		  (31+28+31+30+31+30+31),
++		  (31+28+31+30+31+30+31+31),
++		  (31+28+31+30+31+30+31+31+30),
++		  (31+28+31+30+31+30+31+31+30+31),
++		  (31+28+31+30+31+30+31+31+30+31+30),
++		};
++	register time_t work;
++
++	timep = (*timepr) - (sys_tz.tz_minuteswest * 60);
++	work=timep%(SPD);
++	r->tm_sec=work%60; work/=60;
++	r->tm_min=work%60; r->tm_hour=work/60;
++	work=timep/(SPD);
++	r->tm_wday=(4+work)%7;
++	for (i=1970; ; ++i) {
++		register time_t k= (!(i%4) && ((i%100) || !(i%400)))?366:365;
++		if (work>k)
++			work-=k;
++		else
++			break;
++	}
++	r->tm_year=i-1900;
++	for (i=11; i && __spm[i]>work; --i) ;
++	r->tm_mon=i;
++	r->tm_mday=work-__spm[i]+1;
++}
diff -Nru netfilter.orig/patch-o-matic/base/time.patch.ipv6.config.in netfilter/patch-o-matic/base/time.patch.ipv6.config.in
--- netfilter.orig/patch-o-matic/base/time.patch.ipv6.config.in	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/time.patch.ipv6.config.in	2003-05-03 16:58:27.000000000 +0200
@@ -0,0 +1,2 @@
+  dep_tristate '  MAC address match support' CONFIG_IP6_NF_MATCH_MAC $CONFIG_IP6_NF_IPTABLES
+  dep_tristate '  Time match support' CONFIG_IP6_NF_MATCH_TIME $CONFIG_IP6_NF_FILTER
diff -Nru netfilter.orig/patch-o-matic/base/time.patch.ipv6.configure.help netfilter/patch-o-matic/base/time.patch.ipv6.configure.help
--- netfilter.orig/patch-o-matic/base/time.patch.ipv6.configure.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/time.patch.ipv6.configure.help	2003-05-03 16:59:06.000000000 +0200
@@ -0,0 +1,13 @@
+CONFIG_IP6_NF_MATCH_MAC
+TIME patch support
+CONFIG_IP6_NF_MATCH_TIME
+  This option adds a `time' match, which allows you
+  to matchbased on the packet arrival time
+  (arrival time at the machine which the netfilter is running on) or
+  departure time (for locally generated packets).
+
+  If you say Y here, try iptables -m time --help for more information.
+
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `N'.
+
diff -Nru netfilter.orig/patch-o-matic/base/time.patch.ipv6.help netfilter/patch-o-matic/base/time.patch.ipv6.help
--- netfilter.orig/patch-o-matic/base/time.patch.ipv6.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/time.patch.ipv6.help	2003-05-03 16:57:31.000000000 +0200
@@ -0,0 +1,30 @@
+Author: Fabrice MARIE <fabrice@netfilter.org>
+Ported: Maciej Soltysiak <solt@dns.toxicfilms.tv>
+Status: It Works For Me.
+
+This option adds CONFIG_IP6_NF_MATCH_TIME, which supplies a time match module.
+This match allows you to filter based on the packet arrival time
+(arrival time at the machine which the netfilter is running on) or
+departure time (for locally generated packets).
+
+Supported options are:
+--timestart HH:MM
+  The starting point of the time match frame.
+
+--timestop HH:MM
+  The stopping point of the time match frame
+
+--days Tue,Mon...
+  Days of the week to match separated by a coma, no space
+  (one of Sun,Mon,Tue,Wed,Thu,Fri,Sat)
+
+Example:
+  -A INPUT -m time --timestart 8:00 --timestop 18:00 --days Mon,Tue,Wed,Thu,Fri
+  will match packets that have an arrival timestamp in the range 8:00->18:00 from Monday
+  to Friday.
+
+  -A OUTPUT -m time --timestart 8:00 --timestop 18:00 --Days Mon
+  will match the packets (locally generated) that have a departure timestamp
+  in the range 8:00->18:00 on Monday only.
+
+This is an IPv6 port from IPv4 module.
diff -Nru netfilter.orig/patch-o-matic/base/time.patch.ipv6.makefile netfilter/patch-o-matic/base/time.patch.ipv6.makefile
--- netfilter.orig/patch-o-matic/base/time.patch.ipv6.makefile	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/time.patch.ipv6.makefile	2003-05-03 17:00:16.000000000 +0200
@@ -0,0 +1,3 @@
+obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
+
+obj-$(CONFIG_IP6_NF_MATCH_TIME) += ip6t_time.o
diff -Nru netfilter.orig/userspace/extensions/.time-test6 netfilter/userspace/extensions/.time-test6
--- netfilter.orig/userspace/extensions/.time-test6	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/.time-test6	2003-05-03 16:49:29.000000000 +0200
@@ -0,0 +1,3 @@
+#!/bin/sh
+# True if random is applied.
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv6/ip6t_time.h ] && echo time
diff -Nru netfilter.orig/userspace/extensions/libip6t_time.c netfilter/userspace/extensions/libip6t_time.c
--- netfilter.orig/userspace/extensions/libip6t_time.c	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/libip6t_time.c	2003-05-03 16:50:09.000000000 +0200
@@ -0,0 +1,313 @@
+/* Shared library add-on to ip6tables to add TIME matching support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <ip6tables.h>
+#include <linux/netfilter_ipv6/ip6t_time.h>
+#include <time.h>
+
+static int globaldays;
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"TIME v%s options:\n"
+" --timestart value --timestop value --days listofdays\n"
+"          timestart value : HH:MM\n"
+"          timestop  value : HH:MM\n"
+"          listofdays value: a list of days to apply -> ie. Mon,Tue,Wed,Thu,Fri. Case sensitive\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "timestart", 1, 0, '1' },
+	{ "timestop", 1, 0, '2' },
+	{ "days", 1, 0, '3'},
+	{0}
+};
+
+/* Initialize the match. */
+static void
+init(struct ip6t_entry_match *m, unsigned int *nfcache)
+{
+	/* caching not yet implemented */
+        *nfcache |= NFC_UNKNOWN;
+	globaldays = 0;
+}
+
+/**
+ * param: part1, a pointer on a string 2 chars maximum long string, that will contain the hours.
+ * param: part2, a pointer on a string 2 chars maximum long string, that will contain the minutes.
+ * param: str_2_parse, the string to parse.
+ * return: 1 if ok, 0 if error.
+ */
+static int
+split_time(char **part1, char **part2, const char *str_2_parse)
+{
+	unsigned short int i,j=0;
+	char *rpart1 = *part1;
+	char *rpart2 = *part2;
+	unsigned char found_column = 0;
+
+	/* Check the length of the string */
+	if (strlen(str_2_parse) > 5)
+		return 0;
+	/* parse the first part until the ':' */
+	for (i=0; i<2; i++)
+	{
+		if (str_2_parse[i] == ':')
+			found_column = 1;
+		else
+			rpart1[i] = str_2_parse[i];
+	}
+	if (!found_column)
+		i++;
+	j=i;
+	/* parse the second part */
+	for (; i<strlen(str_2_parse); i++)
+	{
+		rpart2[i-j] = str_2_parse[i];
+	}
+	/* if we are here, format should be ok. */
+	return 1;
+}
+
+static void
+parse_time_string(unsigned int *hour, unsigned int *minute, const char *time)
+{
+	char *hours;
+	char *minutes;
+
+	hours = (char *)malloc(3);
+	minutes = (char *)malloc(3);
+	bzero((void *)hours, 3);
+	bzero((void *)minutes, 3);
+
+	if (split_time(&hours, &minutes, time) == 1)
+	{
+                /* if the number starts with 0, replace it with a space else
+                   this string_to_number will interpret it as octal !! */
+                if ((hours[0] == '0') && (hours[1] != '\0'))
+			hours[0] = ' ';
+		if ((minutes[0] == '0') && (minutes[1] != '\0'))
+			minutes[0] = ' ';
+
+		if((string_to_number(hours, 0, 23, hour) == -1) ||
+			(string_to_number(minutes, 0, 59, minute) == -1)) {
+			*hour = *minute = (-1);
+		}
+	}
+	if ((*hour != (-1)) && (*minute != (-1))) {
+		free(hours);
+		free(minutes);
+		return;
+	}
+
+	/* If we are here, there was a problem ..*/
+	exit_error(PARAMETER_PROBLEM,
+		   "invalid time `%s' specified, should be HH:MM format", time);
+}
+
+/* return 1->ok, return 0->error */
+static int
+parse_day(int *days, int from, int to, const char *string)
+{
+	char *dayread;
+	char *days_str[7] = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
+	unsigned short int days_of_week[7] = {64, 32, 16, 8, 4, 2, 1};
+	unsigned int i;
+
+	dayread = (char *)malloc(4);
+	bzero(dayread, 4);
+	if ((to-from) != 3) {
+		free(dayread);
+		return 0;
+	}
+	for (i=from; i<to; i++)
+		dayread[i-from] = string[i];
+	for (i=0; i<7; i++)
+		if (strcmp(dayread, days_str[i]) == 0)
+		{
+			*days |= days_of_week[i];
+			free(dayread);
+			return 1;
+		}
+	/* if we are here, we didn't read a valid day */
+	free(dayread);
+	return 0;
+}
+
+static void
+parse_days_string(int *days, const char *daystring)
+{
+	int len;
+	int i=0;
+	char *err = "invalid days `%s' specified, should be Sun,Mon,Tue... format";
+
+	len = strlen(daystring);
+	if (len < 3)
+		exit_error(PARAMETER_PROBLEM, err, daystring);
+	while(i<len)
+	{
+		if (parse_day(days, i, i+3, daystring) == 0)
+			exit_error(PARAMETER_PROBLEM, err, daystring);
+		i += 4;
+	}
+}
+
+#define IP6T_TIME_START 0x01
+#define IP6T_TIME_STOP  0x02
+#define IP6T_TIME_DAYS  0x04
+
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ip6t_entry *entry,
+      unsigned int *nfcache,
+      struct ip6t_entry_match **match)
+{
+	struct ip6t_time_info *timeinfo = (struct ip6t_time_info *)(*match)->data;
+	int hours, minutes;
+
+	switch (c)
+	{
+		/* timestart */
+	case '1':
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+                                   "unexpected '!' with --timestart");
+		if (*flags & IP6T_TIME_START)
+                        exit_error(PARAMETER_PROBLEM,
+                                   "Can't specify --timestart twice");
+		parse_time_string(&hours, &minutes, optarg);
+		timeinfo->time_start = (hours * 60) + minutes;
+		*flags |= IP6T_TIME_START;
+		break;
+		/* timestop */
+	case '2':
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+                                   "unexpected '!' with --timestop");
+		if (*flags & IP6T_TIME_STOP)
+                        exit_error(PARAMETER_PROBLEM,
+                                   "Can't specify --timestop twice");
+		parse_time_string(&hours, &minutes, optarg);
+		timeinfo->time_stop = (hours * 60) + minutes;
+		*flags |= IP6T_TIME_STOP;
+		break;
+
+		/* days */
+	case '3':
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+                                   "unexpected '!' with --days");
+		if (*flags & IP6T_TIME_DAYS)
+                        exit_error(PARAMETER_PROBLEM,
+                                   "Can't specify --days twice");
+		parse_days_string(&globaldays, optarg);
+		timeinfo->days_match = globaldays;
+		*flags |= IP6T_TIME_DAYS;
+		break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+/* Final check; must have specified --timestart --timestop --days. */
+static void
+final_check(unsigned int flags)
+{
+	if (flags != (IP6T_TIME_START | IP6T_TIME_STOP | IP6T_TIME_DAYS))
+		exit_error(PARAMETER_PROBLEM,
+			   "TIME match: You must specify `--timestart --timestop and --days'");
+}
+
+
+static void
+print_days(int daynum)
+{
+	char *days[7] = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
+	unsigned short int days_of_week[7] = {64, 32, 16, 8, 4, 2, 1};
+	unsigned short int i, nbdays=0;
+
+	for (i=0; i<7; i++) {
+		if ((days_of_week[i] & daynum) == days_of_week[i])
+		{
+			if (nbdays>0)
+				printf(",%s", days[i]);
+			else
+				printf("%s", days[i]);
+			++nbdays;
+		}
+	}
+}
+
+static void
+divide_time(int fulltime, int *hours, int *minutes)
+{
+	*hours = fulltime / 60;
+	*minutes = fulltime % 60;
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const struct ip6t_ip6 *ip,
+      const struct ip6t_entry_match *match,
+      int numeric)
+{
+	struct ip6t_time_info *time = ((struct ip6t_time_info *)match->data);
+	int hour_start, hour_stop, minute_start, minute_stop;
+
+	divide_time(time->time_start, &hour_start, &minute_start);
+	divide_time(time->time_stop, &hour_stop, &minute_stop);
+	printf(" TIME from %d:%d to %d:%d on ",
+	       hour_start, minute_start,
+	       hour_stop, minute_stop);
+	print_days(time->days_match);
+	printf(" ");
+}
+
+/* Saves the data in parsable form to stdout. */
+static void
+save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+{
+	struct ip6t_time_info *time = ((struct ip6t_time_info *)match->data);
+	int hour_start, hour_stop, minute_start, minute_stop;
+
+	divide_time(time->time_start, &hour_start, &minute_start);
+	divide_time(time->time_stop, &hour_stop, &minute_stop);
+	printf(" --timestart %.2d:%.2d --timestop %.2d:%.2d --days ",
+	       hour_start, minute_start,
+	       hour_stop, minute_stop);
+	print_days(time->days_match);
+	printf(" ");
+}
+
+static
+struct ip6tables_match timestruct
+= { NULL,
+    "time",
+    IPTABLES_VERSION,
+    IP6T_ALIGN(sizeof(struct ip6t_time_info)),
+    IP6T_ALIGN(sizeof(struct ip6t_time_info)),
+    &help,
+    &init,
+    &parse,
+    &final_check,
+    &print,
+    &save,
+    opts
+};
+
+void _init(void)
+{
+	register_match6(&timestruct);
+}
---23717851-208348636-1051975099=:24297
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="time6.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.51.0305031718190.24297@dns.toxicfilms.tv>
Content-Description: time6.patch
Content-Disposition: attachment; filename="time6.patch"

ZGlmZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS90
aW1lLnBhdGNoLmlwdjYgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS90
aW1lLnBhdGNoLmlwdjYNCi0tLSBuZXRmaWx0ZXIub3JpZy9wYXRjaC1vLW1h
dGljL2Jhc2UvdGltZS5wYXRjaC5pcHY2CTE5NzAtMDEtMDEgMDE6MDA6MDAu
MDAwMDAwMDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMv
YmFzZS90aW1lLnBhdGNoLmlwdjYJMjAwMy0wNS0wMyAxNjo1Njo0Ni4wMDAw
MDAwMDAgKzAyMDANCkBAIC0wLDAgKzEsMjA3IEBADQorZGlmZiAtTnJ1IGxp
bnV4Lm9yaWcvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJfaXB2Ni9pcDZ0X3Rp
bWUuaCBsaW51eC9pbmNsdWRlL2xpbnV4L25ldGZpbHRlcl9pcHY2L2lwNnRf
dGltZS5oDQorLS0tIGxpbnV4Lm9yaWcvaW5jbHVkZS9saW51eC9uZXRmaWx0
ZXJfaXB2Ni9pcDZ0X3RpbWUuaAkxOTcwLTAxLTAxIDAxOjAwOjAwLjAwMDAw
MDAwMCArMDEwMA0KKysrKyBsaW51eC9pbmNsdWRlL2xpbnV4L25ldGZpbHRl
cl9pcHY2L2lwNnRfdGltZS5oCTIwMDMtMDQtMzAgMTY6MDc6MTQuMDAwMDAw
MDAwICswMjAwDQorQEAgLTAsMCArMSwxMyBAQA0KKysjaWZuZGVmIF9faXA2
dF90aW1lX2hfaW5jbHVkZWRfXw0KKysjZGVmaW5lIF9faXA2dF90aW1lX2hf
aW5jbHVkZWRfXw0KKysNCisrDQorK3N0cnVjdCBpcDZ0X3RpbWVfaW5mbyB7
DQorKwl1X2ludDhfdCAgZGF5c19tYXRjaDsgICAvKiAxIGJpdCBwZXIgZGF5
LiAtU01UV1RGUyAgICAgICAgICAgICAgICAgICAgICAqLw0KKysJdV9pbnQx
Nl90IHRpbWVfc3RhcnQ7ICAgLyogMCA8IHRpbWVfc3RhcnQgPCAyMyo2MCs1
OSA9IDE0MzkgICAgICAgICAgICAgKi8NCisrCXVfaW50MTZfdCB0aW1lX3N0
b3A7ICAgIC8qIDA6MCA8IHRpbWVfc3RhdCA8IDIzOjU5ICAgICAgICAgICAg
ICAgICAgICAgICovDQorKwl1X2ludDhfdCAga2VybmVsdGltZTsgICAvKiBp
Z25vcmUgc2tiIHRpbWUgKGFuZCB1c2Uga2VybmVsdGltZSkgb3Igbm90LiAq
Lw0KKyt9Ow0KKysNCisrDQorKyNlbmRpZiAvKiBfX2lwNnRfdGltZV9oX2lu
Y2x1ZGVkX18gKi8NCitkaWZmIC1OcnUgbGludXgub3JpZy9uZXQvaXB2Ni9u
ZXRmaWx0ZXIvaXA2dF90aW1lLmMgbGludXgvbmV0L2lwdjYvbmV0ZmlsdGVy
L2lwNnRfdGltZS5jDQorLS0tIGxpbnV4Lm9yaWcvbmV0L2lwdjYvbmV0Zmls
dGVyL2lwNnRfdGltZS5jCTE5NzAtMDEtMDEgMDE6MDA6MDAuMDAwMDAwMDAw
ICswMTAwDQorKysrIGxpbnV4L25ldC9pcHY2L25ldGZpbHRlci9pcDZ0X3Rp
bWUuYwkyMDAzLTA0LTMwIDE2OjI0OjMzLjAwMDAwMDAwMCArMDIwMA0KK0BA
IC0wLDAgKzEsMTg2IEBADQorKy8qDQorKyAgVGhpcyBpcyBhIG1vZHVsZSB3
aGljaCBpcyB1c2VkIGZvciB0aW1lIG1hdGNoaW5nDQorKyAgSXQgaXMgdXNp
bmcgc29tZSBtb2RpZmllZCBjb2RlIGZyb20gZGlldGxpYmMgKGxvY2FsdGlt
ZSgpIGZ1bmN0aW9uKQ0KKysgIHRoYXQgeW91IGNhbiBmaW5kIGF0IGh0dHA6
Ly93d3cuZmVmZS5kZS9kaWV0bGliYy8NCisrICBUaGlzIGZpbGUgaXMgZGlz
dHJpYnV0ZWQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQ
dWJsaWMNCisrICBMaWNlbnNlIChHUEwpLiBDb3BpZXMgb2YgdGhlIEdQTCBj
YW4gYmUgb2J0YWluZWQgZnJvbTogZnRwOi8vcHJlcC5haS5taXQuZWR1L3B1
Yi9nbnUvR1BMDQorKyAgMjAwMS0wNS0wNCBGYWJyaWNlIE1BUklFIDxmYWJy
aWNlQG5ldGZpbHRlci5vcmc+IDogaW5pdGlhbCBkZXZlbG9wbWVudC4NCisr
ICAyMDAxLTIxLTA1IEZhYnJpY2UgTUFSSUUgPGZhYnJpY2VAbmV0ZmlsdGVy
Lm9yZz4gOiBidWcgZml4IGluIHRoZSBtYXRjaCBjb2RlLA0KKysgICAgIHRo
YW5rcyB0byAiWmVuZyBZdSIgPHplbmd5QGNhcGl0ZWwuY29tLmNuPiBmb3Ig
YnVnIHJlcG9ydC4NCisrICAyMDAxLTI2LTA5IEZhYnJpY2UgTUFSSUUgPGZh
YnJpY2VAbmV0ZmlsdGVyLm9yZz4gOiBmb3JjZSB0aGUgbWF0Y2ggdG8gYmUg
aW4gTE9DQUxfSU4gb3IgUFJFX1JPVVRJTkcgb25seS4NCisrICAyMDAxLTMw
LTExIEZhYnJpY2UgOiBhZGRlZCB0aGUgcG9zc2liaWxpdHkgdG8gdXNlIHRo
ZSBtYXRjaCBpbiBGT1JXQVJEL09VVFBVVCB3aXRoIGEgbGl0dGxlIGhhY2ss
DQorKyAgICAgYWRkZWQgTmd1eWVuIERhbmcgUGh1b2MgRG9uZyA8ZG9uZ25k
QHRsbmV0LmNvbS52bj4gcGF0Y2ggdG8gc3VwcG9ydCB0aW1lem9uZXMuDQor
KyAgMjAwMy0wNC0zMCBNYWNpZWogU29sdHlzaWFrIDxzb2x0QGRucy50b3hp
Y2ZpbG1zLnR2PiA6IElQdjYgUG9ydA0KKysqLw0KKysNCisrI2luY2x1ZGUg
PGxpbnV4L21vZHVsZS5oPg0KKysjaW5jbHVkZSA8bGludXgvc2tidWZmLmg+
DQorKyNpbmNsdWRlIDxsaW51eC9uZXRmaWx0ZXJfaXB2Ni9pcDZfdGFibGVz
Lmg+DQorKyNpbmNsdWRlIDxsaW51eC9uZXRmaWx0ZXJfaXB2Ni9pcDZ0X3Rp
bWUuaD4NCisrI2luY2x1ZGUgPGxpbnV4L3RpbWUuaD4NCisrDQorK01PRFVM
RV9BVVRIT1IoIkZhYnJpY2UgTUFSSUUgPGZhYnJpY2VAbmV0ZmlsdGVyLm9y
Zz4iKTsNCisrTU9EVUxFX0RFU0NSSVBUSU9OKCJNYXRjaCBhcnJpdmFsIHRp
bWVzdGFtcCIpOw0KKytNT0RVTEVfTElDRU5TRSgiR1BMIik7DQorKw0KKytz
dHJ1Y3QgdG0NCisrew0KKysJaW50IHRtX3NlYzsgICAgICAgICAgICAgICAg
ICAgLyogU2Vjb25kcy4gICAgIFswLTYwXSAoMSBsZWFwIHNlY29uZCkgKi8N
CisrCWludCB0bV9taW47ICAgICAgICAgICAgICAgICAgIC8qIE1pbnV0ZXMu
ICAgICBbMC01OV0gKi8NCisrCWludCB0bV9ob3VyOyAgICAgICAgICAgICAg
ICAgIC8qIEhvdXJzLiAgICAgICBbMC0yM10gKi8NCisrCWludCB0bV9tZGF5
OyAgICAgICAgICAgICAgICAgIC8qIERheS4gICAgICAgICBbMS0zMV0gKi8N
CisrCWludCB0bV9tb247ICAgICAgICAgICAgICAgICAgIC8qIE1vbnRoLiAg
ICAgICBbMC0xMV0gKi8NCisrCWludCB0bV95ZWFyOyAgICAgICAgICAgICAg
ICAgIC8qIFllYXIgLSAxOTAwLiAgKi8NCisrCWludCB0bV93ZGF5OyAgICAg
ICAgICAgICAgICAgIC8qIERheSBvZiB3ZWVrLiBbMC02XSAqLw0KKysJaW50
IHRtX3lkYXk7ICAgICAgICAgICAgICAgICAgLyogRGF5cyBpbiB5ZWFyLlsw
LTM2NV0gKi8NCisrCWludCB0bV9pc2RzdDsgICAgICAgICAgICAgICAgIC8q
IERTVC4gICAgICAgICBbLTEvMC8xXSovDQorKw0KKysJbG9uZyBpbnQgdG1f
Z210b2ZmOyAgICAgICAgICAgLyogd2UgZG9uJ3QgY2FyZSwgd2UgY291bnQg
ZnJvbSBHTVQgKi8NCisrCWNvbnN0IGNoYXIgKnRtX3pvbmU7ICAgICAgICAg
IC8qIHdlIGRvbid0IGNhcmUsIHdlIGNvdW50IGZyb20gR01UICovDQorK307
DQorKw0KKyt2b2lkDQorK2xvY2FsdGltZShjb25zdCB0aW1lX3QgKnRpbWVw
ciwgc3RydWN0IHRtICpyKTsNCisrDQorK3N0YXRpYyBpbnQNCisrbWF0Y2go
Y29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrYiwNCisrICAgICAgY29uc3Qgc3Ry
dWN0IG5ldF9kZXZpY2UgKmluLA0KKysgICAgICBjb25zdCBzdHJ1Y3QgbmV0
X2RldmljZSAqb3V0LA0KKysgICAgICBjb25zdCB2b2lkICptYXRjaGluZm8s
DQorKyAgICAgIGludCBvZmZzZXQsDQorKyAgICAgIGNvbnN0IHZvaWQgKmhk
ciwNCisrICAgICAgdV9pbnQxNl90IGRhdGFsZW4sDQorKyAgICAgIGludCAq
aG90ZHJvcCkNCisrew0KKysJY29uc3Qgc3RydWN0IGlwNnRfdGltZV9pbmZv
ICppbmZvID0gbWF0Y2hpbmZvOyAgIC8qIG1hdGNoIGluZm8gZm9yIHJ1bGUg
Ki8NCisrCXN0cnVjdCB0bSBjdXJyZW50dGltZTsgICAgICAgICAgICAgICAg
ICAgICAgICAgIC8qIHRpbWUgaHVtYW4gcmVhZGFibGUgKi8NCisrCXVfaW50
OF90IGRheXNfb2Zfd2Vla1s3XSA9IHs2NCwgMzIsIDE2LCA4LCA0LCAyLCAx
fTsNCisrCXVfaW50MTZfdCBwYWNrZXRfdGltZTsNCisrCXN0cnVjdCB0aW1l
dmFsIGtlcm5lbHRpbWV2YWw7DQorKwl0aW1lX3QgcGFja2V0X2xvY2FsX3Rp
bWU7DQorKw0KKysJLyogaWYga2VybmVsdGltZT0xLCB3ZSBkb24ndCByZWFk
IHRoZSBza2ItPnRpbWVzdGFtcCBidXQga2VybmVsIHRpbWUgaW5zdGVhZCAq
Lw0KKysJaWYgKGluZm8tPmtlcm5lbHRpbWUpDQorKwl7DQorKwkJZG9fZ2V0
dGltZW9mZGF5KCZrZXJuZWx0aW1ldmFsKTsNCisrCQlwYWNrZXRfbG9jYWxf
dGltZSA9IGtlcm5lbHRpbWV2YWwudHZfc2VjOw0KKysJfQ0KKysJZWxzZQ0K
KysJCXBhY2tldF9sb2NhbF90aW1lID0gc2tiLT5zdGFtcC50dl9zZWM7DQor
Kw0KKysJLyogVHJhbnNmb3JtIHRoZSB0aW1lc3RhbXAgb2YgdGhlIHBhY2tl
dCwgaW4gYSBodW1hbiByZWFkYWJsZSBmb3JtICovDQorKwlsb2NhbHRpbWUo
JnBhY2tldF9sb2NhbF90aW1lLCAmY3VycmVudHRpbWUpOw0KKysNCisrCS8q
IGNoZWNrIGlmIHdlIG1hdGNoIHRoaXMgdGltZXN0YW1wLCB3ZSBzdGFydCBi
eSB0aGUgZGF5cy4uLiAqLw0KKysJaWYgKChkYXlzX29mX3dlZWtbY3VycmVu
dHRpbWUudG1fd2RheV0gJiBpbmZvLT5kYXlzX21hdGNoKSAhPSBkYXlzX29m
X3dlZWtbY3VycmVudHRpbWUudG1fd2RheV0pDQorKwkJcmV0dXJuIDA7IC8q
IHRoZSBkYXkgZG9lc24ndCBtYXRjaCAqLw0KKysNCisrCS8qIC4uLiBjaGVj
ayB0aGUgdGltZSBub3cgKi8NCisrCXBhY2tldF90aW1lID0gKGN1cnJlbnR0
aW1lLnRtX2hvdXIgKiA2MCkgKyBjdXJyZW50dGltZS50bV9taW47DQorKwlp
ZiAoKHBhY2tldF90aW1lIDwgaW5mby0+dGltZV9zdGFydCkgfHwgKHBhY2tl
dF90aW1lID4gaW5mby0+dGltZV9zdG9wKSkNCisrCQlyZXR1cm4gMDsNCisr
DQorKwkvKiBoZXJlIHdlIG1hdGNoICEgKi8NCisrCXJldHVybiAxOw0KKyt9
DQorKw0KKytzdGF0aWMgaW50DQorK2NoZWNrZW50cnkoY29uc3QgY2hhciAq
dGFibGVuYW1lLA0KKysgICAgICAgICAgIGNvbnN0IHN0cnVjdCBpcDZ0X2lw
NiAqaXAsDQorKyAgICAgICAgICAgdm9pZCAqbWF0Y2hpbmZvLA0KKysgICAg
ICAgICAgIHVuc2lnbmVkIGludCBtYXRjaHNpemUsDQorKyAgICAgICAgICAg
dW5zaWduZWQgaW50IGhvb2tfbWFzaykNCisrew0KKysJc3RydWN0IGlwNnRf
dGltZV9pbmZvICppbmZvID0gbWF0Y2hpbmZvOyAgIC8qIG1hdGNoIGluZm8g
Zm9yIHJ1bGUgKi8NCisrDQorKwkvKiBGaXJzdCwgY2hlY2sgdGhhdCB3ZSBh
cmUgaW4gdGhlIGNvcnJlY3QgaG9vayAqLw0KKysJLyogUFJFX1JPVVRJTkcs
IExPQ0FMX0lOIG9yIEZST1dBUkQgKi8NCisrCWlmIChob29rX21hc2sNCisr
ICAgICAgICAgICAgJiB+KCgxIDw8IE5GX0lQNl9QUkVfUk9VVElORykgfCAo
MSA8PCBORl9JUDZfTE9DQUxfSU4pIHwgKDEgPDwgTkZfSVA2X0ZPUldBUkQp
IHwgKDEgPDwgTkZfSVA2X0xPQ0FMX09VVCkpKQ0KKysJew0KKysJCXByaW50
aygiaXA2dF90aW1lOiBlcnJvciwgb25seSB2YWxpZCBmb3IgUFJFX1JPVVRJ
TkcsIExPQ0FMX0lOLCBGT1JXQVJEIGFuZCBPVVRQVVQpXG4iKTsNCisrCQly
ZXR1cm4gMDsNCisrCX0NCisrCS8qIHdlIHVzZSB0aGUga2VybmVsdGltZSBp
ZiB3ZSBhcmUgaW4gZm9yd2FyZCBvciBvdXRwdXQgKi8NCisrCWluZm8tPmtl
cm5lbHRpbWUgPSAxOw0KKysJaWYgKGhvb2tfbWFzayAmIH4oKDEgPDwgTkZf
SVA2X0ZPUldBUkQpIHwgKDEgPDwgTkZfSVA2X0xPQ0FMX09VVCkpKSANCisr
CQkvKiBpZiBub3QsIHdlIHVzZSB0aGUgc2tiIHRpbWUgKi8NCisrCQlpbmZv
LT5rZXJuZWx0aW1lID0gMDsNCisrDQorKwkvKiBDaGVjayB0aGUgc2l6ZSAq
Lw0KKysJaWYgKG1hdGNoc2l6ZSAhPSBJUDZUX0FMSUdOKHNpemVvZihzdHJ1
Y3QgaXA2dF90aW1lX2luZm8pKSkNCisrCQlyZXR1cm4gMDsNCisrCS8qIE5v
dyBjaGVjayB0aGUgY29oZXJlbmNlIG9mIHRoZSBkYXRhIC4uLiAqLw0KKysJ
aWYgKChpbmZvLT50aW1lX3N0YXJ0ID4gMTQzOSkgfHwgICAgICAgIC8qIDIz
KjYwKzU5ID0gMTQzOSovDQorKwkgICAgKGluZm8tPnRpbWVfc3RvcCAgPiAx
NDM5KSkNCisrCXsNCisrCQlwcmludGsoS0VSTl9XQVJOSU5HICJpcDZ0X3Rp
bWU6IGludmFsaWQgYXJndW1lbnRcbiIpOw0KKysJCXJldHVybiAwOw0KKysJ
fQ0KKysNCisrCXJldHVybiAxOw0KKyt9DQorKw0KKytzdGF0aWMgc3RydWN0
IGlwNnRfbWF0Y2ggdGltZV9tYXRjaA0KKys9IHsgeyBOVUxMLCBOVUxMIH0s
ICJ0aW1lIiwgJm1hdGNoLCAmY2hlY2tlbnRyeSwgTlVMTCwgVEhJU19NT0RV
TEUgfTsNCisrDQorK3N0YXRpYyBpbnQgX19pbml0IGluaXQodm9pZCkNCisr
ew0KKysJcHJpbnRrKCJpcDZ0X3RpbWUgbG9hZGluZ1xuIik7DQorKwlyZXR1
cm4gaXA2dF9yZWdpc3Rlcl9tYXRjaCgmdGltZV9tYXRjaCk7DQorK30NCisr
DQorK3N0YXRpYyB2b2lkIF9fZXhpdCBmaW5pKHZvaWQpDQorK3sNCisrCWlw
NnRfdW5yZWdpc3Rlcl9tYXRjaCgmdGltZV9tYXRjaCk7DQorKwlwcmludGso
ImlwNnRfdGltZSB1bmxvYWRlZFxuIik7DQorK30NCisrDQorK21vZHVsZV9p
bml0KGluaXQpOw0KKyttb2R1bGVfZXhpdChmaW5pKTsNCisrDQorKw0KKysv
KiBUaGUgcGFydCBiZWxvdyBpcyBib3Jvd2VkIGFuZCBtb2RpZmllZCBmcm9t
IGRpZXRsaWJjICovDQorKw0KKysvKiBzZWNvbmRzIHBlciBkYXkgKi8NCisr
I2RlZmluZSBTUEQgMjQqNjAqNjANCisrDQorK3ZvaWQNCisrbG9jYWx0aW1l
KGNvbnN0IHRpbWVfdCAqdGltZXByLCBzdHJ1Y3QgdG0gKnIpIHsNCisrCXRp
bWVfdCBpOw0KKysJdGltZV90IHRpbWVwOw0KKysJZXh0ZXJuIHN0cnVjdCB0
aW1lem9uZSBzeXNfdHo7DQorKwljb25zdCB1bnNpZ25lZCBpbnQgX19zcG1b
MTJdID0NCisrCQl7IDAsDQorKwkJICAoMzEpLA0KKysJCSAgKDMxKzI4KSwN
CisrCQkgICgzMSsyOCszMSksDQorKwkJICAoMzErMjgrMzErMzApLA0KKysJ
CSAgKDMxKzI4KzMxKzMwKzMxKSwNCisrCQkgICgzMSsyOCszMSszMCszMSsz
MCksDQorKwkJICAoMzErMjgrMzErMzArMzErMzArMzEpLA0KKysJCSAgKDMx
KzI4KzMxKzMwKzMxKzMwKzMxKzMxKSwNCisrCQkgICgzMSsyOCszMSszMCsz
MSszMCszMSszMSszMCksDQorKwkJICAoMzErMjgrMzErMzArMzErMzArMzEr
MzErMzArMzEpLA0KKysJCSAgKDMxKzI4KzMxKzMwKzMxKzMwKzMxKzMxKzMw
KzMxKzMwKSwNCisrCQl9Ow0KKysJcmVnaXN0ZXIgdGltZV90IHdvcms7DQor
Kw0KKysJdGltZXAgPSAoKnRpbWVwcikgLSAoc3lzX3R6LnR6X21pbnV0ZXN3
ZXN0ICogNjApOw0KKysJd29yaz10aW1lcCUoU1BEKTsNCisrCXItPnRtX3Nl
Yz13b3JrJTYwOyB3b3JrLz02MDsNCisrCXItPnRtX21pbj13b3JrJTYwOyBy
LT50bV9ob3VyPXdvcmsvNjA7DQorKwl3b3JrPXRpbWVwLyhTUEQpOw0KKysJ
ci0+dG1fd2RheT0oNCt3b3JrKSU3Ow0KKysJZm9yIChpPTE5NzA7IDsgKytp
KSB7DQorKwkJcmVnaXN0ZXIgdGltZV90IGs9ICghKGklNCkgJiYgKChpJTEw
MCkgfHwgIShpJTQwMCkpKT8zNjY6MzY1Ow0KKysJCWlmICh3b3JrPmspDQor
KwkJCXdvcmstPWs7DQorKwkJZWxzZQ0KKysJCQlicmVhazsNCisrCX0NCisr
CXItPnRtX3llYXI9aS0xOTAwOw0KKysJZm9yIChpPTExOyBpICYmIF9fc3Bt
W2ldPndvcms7IC0taSkgOw0KKysJci0+dG1fbW9uPWk7DQorKwlyLT50bV9t
ZGF5PXdvcmstX19zcG1baV0rMTsNCisrfQ0KZGlmZiAtTnJ1IG5ldGZpbHRl
ci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS90aW1lLnBhdGNoLmlwdjYuY29u
ZmlnLmluIG5ldGZpbHRlci9wYXRjaC1vLW1hdGljL2Jhc2UvdGltZS5wYXRj
aC5pcHY2LmNvbmZpZy5pbg0KLS0tIG5ldGZpbHRlci5vcmlnL3BhdGNoLW8t
bWF0aWMvYmFzZS90aW1lLnBhdGNoLmlwdjYuY29uZmlnLmluCTE5NzAtMDEt
MDEgMDE6MDA6MDAuMDAwMDAwMDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3Bh
dGNoLW8tbWF0aWMvYmFzZS90aW1lLnBhdGNoLmlwdjYuY29uZmlnLmluCTIw
MDMtMDUtMDMgMTY6NTg6MjcuMDAwMDAwMDAwICswMjAwDQpAQCAtMCwwICsx
LDIgQEANCisgIGRlcF90cmlzdGF0ZSAnICBNQUMgYWRkcmVzcyBtYXRjaCBz
dXBwb3J0JyBDT05GSUdfSVA2X05GX01BVENIX01BQyAkQ09ORklHX0lQNl9O
Rl9JUFRBQkxFUw0KKyAgZGVwX3RyaXN0YXRlICcgIFRpbWUgbWF0Y2ggc3Vw
cG9ydCcgQ09ORklHX0lQNl9ORl9NQVRDSF9USU1FICRDT05GSUdfSVA2X05G
X0ZJTFRFUg0KZGlmZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0
aWMvYmFzZS90aW1lLnBhdGNoLmlwdjYuY29uZmlndXJlLmhlbHAgbmV0Zmls
dGVyL3BhdGNoLW8tbWF0aWMvYmFzZS90aW1lLnBhdGNoLmlwdjYuY29uZmln
dXJlLmhlbHANCi0tLSBuZXRmaWx0ZXIub3JpZy9wYXRjaC1vLW1hdGljL2Jh
c2UvdGltZS5wYXRjaC5pcHY2LmNvbmZpZ3VyZS5oZWxwCTE5NzAtMDEtMDEg
MDE6MDA6MDAuMDAwMDAwMDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3BhdGNo
LW8tbWF0aWMvYmFzZS90aW1lLnBhdGNoLmlwdjYuY29uZmlndXJlLmhlbHAJ
MjAwMy0wNS0wMyAxNjo1OTowNi4wMDAwMDAwMDAgKzAyMDANCkBAIC0wLDAg
KzEsMTMgQEANCitDT05GSUdfSVA2X05GX01BVENIX01BQw0KK1RJTUUgcGF0
Y2ggc3VwcG9ydA0KK0NPTkZJR19JUDZfTkZfTUFUQ0hfVElNRQ0KKyAgVGhp
cyBvcHRpb24gYWRkcyBhIGB0aW1lJyBtYXRjaCwgd2hpY2ggYWxsb3dzIHlv
dQ0KKyAgdG8gbWF0Y2hiYXNlZCBvbiB0aGUgcGFja2V0IGFycml2YWwgdGlt
ZQ0KKyAgKGFycml2YWwgdGltZSBhdCB0aGUgbWFjaGluZSB3aGljaCB0aGUg
bmV0ZmlsdGVyIGlzIHJ1bm5pbmcgb24pIG9yDQorICBkZXBhcnR1cmUgdGlt
ZSAoZm9yIGxvY2FsbHkgZ2VuZXJhdGVkIHBhY2tldHMpLg0KKw0KKyAgSWYg
eW91IHNheSBZIGhlcmUsIHRyeSBpcHRhYmxlcyAtbSB0aW1lIC0taGVscCBm
b3IgbW9yZSBpbmZvcm1hdGlvbi4NCisgDQorICBJZiB5b3Ugd2FudCB0byBj
b21waWxlIGl0IGFzIGEgbW9kdWxlLCBzYXkgTSBoZXJlIGFuZCByZWFkDQor
ICBEb2N1bWVudGF0aW9uL21vZHVsZXMudHh0LiAgSWYgdW5zdXJlLCBzYXkg
YE4nLg0KKw0KZGlmZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0
aWMvYmFzZS90aW1lLnBhdGNoLmlwdjYuaGVscCBuZXRmaWx0ZXIvcGF0Y2gt
by1tYXRpYy9iYXNlL3RpbWUucGF0Y2guaXB2Ni5oZWxwDQotLS0gbmV0Zmls
dGVyLm9yaWcvcGF0Y2gtby1tYXRpYy9iYXNlL3RpbWUucGF0Y2guaXB2Ni5o
ZWxwCTE5NzAtMDEtMDEgMDE6MDA6MDAuMDAwMDAwMDAwICswMTAwDQorKysg
bmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS90aW1lLnBhdGNoLmlwdjYu
aGVscAkyMDAzLTA1LTAzIDE2OjU3OjMxLjAwMDAwMDAwMCArMDIwMA0KQEAg
LTAsMCArMSwzMCBAQA0KK0F1dGhvcjogRmFicmljZSBNQVJJRSA8ZmFicmlj
ZUBuZXRmaWx0ZXIub3JnPg0KK1BvcnRlZDogTWFjaWVqIFNvbHR5c2lhayA8
c29sdEBkbnMudG94aWNmaWxtcy50dj4NCitTdGF0dXM6IEl0IFdvcmtzIEZv
ciBNZS4NCisNCitUaGlzIG9wdGlvbiBhZGRzIENPTkZJR19JUDZfTkZfTUFU
Q0hfVElNRSwgd2hpY2ggc3VwcGxpZXMgYSB0aW1lIG1hdGNoIG1vZHVsZS4N
CitUaGlzIG1hdGNoIGFsbG93cyB5b3UgdG8gZmlsdGVyIGJhc2VkIG9uIHRo
ZSBwYWNrZXQgYXJyaXZhbCB0aW1lDQorKGFycml2YWwgdGltZSBhdCB0aGUg
bWFjaGluZSB3aGljaCB0aGUgbmV0ZmlsdGVyIGlzIHJ1bm5pbmcgb24pIG9y
DQorZGVwYXJ0dXJlIHRpbWUgKGZvciBsb2NhbGx5IGdlbmVyYXRlZCBwYWNr
ZXRzKS4NCisNCitTdXBwb3J0ZWQgb3B0aW9ucyBhcmU6DQorLS10aW1lc3Rh
cnQgSEg6TU0NCisgIFRoZSBzdGFydGluZyBwb2ludCBvZiB0aGUgdGltZSBt
YXRjaCBmcmFtZS4NCisNCistLXRpbWVzdG9wIEhIOk1NDQorICBUaGUgc3Rv
cHBpbmcgcG9pbnQgb2YgdGhlIHRpbWUgbWF0Y2ggZnJhbWUNCisNCistLWRh
eXMgVHVlLE1vbi4uLg0KKyAgRGF5cyBvZiB0aGUgd2VlayB0byBtYXRjaCBz
ZXBhcmF0ZWQgYnkgYSBjb21hLCBubyBzcGFjZQ0KKyAgKG9uZSBvZiBTdW4s
TW9uLFR1ZSxXZWQsVGh1LEZyaSxTYXQpDQorDQorRXhhbXBsZToNCisgIC1B
IElOUFVUIC1tIHRpbWUgLS10aW1lc3RhcnQgODowMCAtLXRpbWVzdG9wIDE4
OjAwIC0tZGF5cyBNb24sVHVlLFdlZCxUaHUsRnJpDQorICB3aWxsIG1hdGNo
IHBhY2tldHMgdGhhdCBoYXZlIGFuIGFycml2YWwgdGltZXN0YW1wIGluIHRo
ZSByYW5nZSA4OjAwLT4xODowMCBmcm9tIE1vbmRheQ0KKyAgdG8gRnJpZGF5
Lg0KKw0KKyAgLUEgT1VUUFVUIC1tIHRpbWUgLS10aW1lc3RhcnQgODowMCAt
LXRpbWVzdG9wIDE4OjAwIC0tRGF5cyBNb24NCisgIHdpbGwgbWF0Y2ggdGhl
IHBhY2tldHMgKGxvY2FsbHkgZ2VuZXJhdGVkKSB0aGF0IGhhdmUgYSBkZXBh
cnR1cmUgdGltZXN0YW1wDQorICBpbiB0aGUgcmFuZ2UgODowMC0+MTg6MDAg
b24gTW9uZGF5IG9ubHkuDQorDQorVGhpcyBpcyBhbiBJUHY2IHBvcnQgZnJv
bSBJUHY0IG1vZHVsZS4NCmRpZmYgLU5ydSBuZXRmaWx0ZXIub3JpZy9wYXRj
aC1vLW1hdGljL2Jhc2UvdGltZS5wYXRjaC5pcHY2Lm1ha2VmaWxlIG5ldGZp
bHRlci9wYXRjaC1vLW1hdGljL2Jhc2UvdGltZS5wYXRjaC5pcHY2Lm1ha2Vm
aWxlDQotLS0gbmV0ZmlsdGVyLm9yaWcvcGF0Y2gtby1tYXRpYy9iYXNlL3Rp
bWUucGF0Y2guaXB2Ni5tYWtlZmlsZQkxOTcwLTAxLTAxIDAxOjAwOjAwLjAw
MDAwMDAwMCArMDEwMA0KKysrIG5ldGZpbHRlci9wYXRjaC1vLW1hdGljL2Jh
c2UvdGltZS5wYXRjaC5pcHY2Lm1ha2VmaWxlCTIwMDMtMDUtMDMgMTc6MDA6
MTYuMDAwMDAwMDAwICswMjAwDQpAQCAtMCwwICsxLDMgQEANCitvYmotJChD
T05GSUdfSVA2X05GX1RBUkdFVF9MT0cpICs9IGlwNnRfTE9HLm8NCisNCitv
YmotJChDT05GSUdfSVA2X05GX01BVENIX1RJTUUpICs9IGlwNnRfdGltZS5v
DQpkaWZmIC1OcnUgbmV0ZmlsdGVyLm9yaWcvdXNlcnNwYWNlL2V4dGVuc2lv
bnMvLnRpbWUtdGVzdDYgbmV0ZmlsdGVyL3VzZXJzcGFjZS9leHRlbnNpb25z
Ly50aW1lLXRlc3Q2DQotLS0gbmV0ZmlsdGVyLm9yaWcvdXNlcnNwYWNlL2V4
dGVuc2lvbnMvLnRpbWUtdGVzdDYJMTk3MC0wMS0wMSAwMTowMDowMC4wMDAw
MDAwMDAgKzAxMDANCisrKyBuZXRmaWx0ZXIvdXNlcnNwYWNlL2V4dGVuc2lv
bnMvLnRpbWUtdGVzdDYJMjAwMy0wNS0wMyAxNjo0OToyOS4wMDAwMDAwMDAg
KzAyMDANCkBAIC0wLDAgKzEsMyBAQA0KKyMhL2Jpbi9zaA0KKyMgVHJ1ZSBp
ZiByYW5kb20gaXMgYXBwbGllZC4NCitbIC1mICRLRVJORUxfRElSL2luY2x1
ZGUvbGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2dF90aW1lLmggXSAmJiBlY2hv
IHRpbWUNCmRpZmYgLU5ydSBuZXRmaWx0ZXIub3JpZy91c2Vyc3BhY2UvZXh0
ZW5zaW9ucy9saWJpcDZ0X3RpbWUuYyBuZXRmaWx0ZXIvdXNlcnNwYWNlL2V4
dGVuc2lvbnMvbGliaXA2dF90aW1lLmMNCi0tLSBuZXRmaWx0ZXIub3JpZy91
c2Vyc3BhY2UvZXh0ZW5zaW9ucy9saWJpcDZ0X3RpbWUuYwkxOTcwLTAxLTAx
IDAxOjAwOjAwLjAwMDAwMDAwMCArMDEwMA0KKysrIG5ldGZpbHRlci91c2Vy
c3BhY2UvZXh0ZW5zaW9ucy9saWJpcDZ0X3RpbWUuYwkyMDAzLTA1LTAzIDE2
OjUwOjA5LjAwMDAwMDAwMCArMDIwMA0KQEAgLTAsMCArMSwzMTMgQEANCisv
KiBTaGFyZWQgbGlicmFyeSBhZGQtb24gdG8gaXA2dGFibGVzIHRvIGFkZCBU
SU1FIG1hdGNoaW5nIHN1cHBvcnQuICovDQorI2luY2x1ZGUgPHN0ZGlvLmg+
DQorI2luY2x1ZGUgPG5ldGRiLmg+DQorI2luY2x1ZGUgPHN0cmluZy5oPg0K
KyNpbmNsdWRlIDxzdGRsaWIuaD4NCisjaW5jbHVkZSA8Z2V0b3B0Lmg+DQor
DQorI2luY2x1ZGUgPGlwNnRhYmxlcy5oPg0KKyNpbmNsdWRlIDxsaW51eC9u
ZXRmaWx0ZXJfaXB2Ni9pcDZ0X3RpbWUuaD4NCisjaW5jbHVkZSA8dGltZS5o
Pg0KKw0KK3N0YXRpYyBpbnQgZ2xvYmFsZGF5czsNCisNCisvKiBGdW5jdGlv
biB3aGljaCBwcmludHMgb3V0IHVzYWdlIG1lc3NhZ2UuICovDQorc3RhdGlj
IHZvaWQNCitoZWxwKHZvaWQpDQorew0KKwlwcmludGYoDQorIlRJTUUgdiVz
IG9wdGlvbnM6XG4iDQorIiAtLXRpbWVzdGFydCB2YWx1ZSAtLXRpbWVzdG9w
IHZhbHVlIC0tZGF5cyBsaXN0b2ZkYXlzXG4iDQorIiAgICAgICAgICB0aW1l
c3RhcnQgdmFsdWUgOiBISDpNTVxuIg0KKyIgICAgICAgICAgdGltZXN0b3Ag
IHZhbHVlIDogSEg6TU1cbiINCisiICAgICAgICAgIGxpc3RvZmRheXMgdmFs
dWU6IGEgbGlzdCBvZiBkYXlzIHRvIGFwcGx5IC0+IGllLiBNb24sVHVlLFdl
ZCxUaHUsRnJpLiBDYXNlIHNlbnNpdGl2ZVxuIiwNCitJUFRBQkxFU19WRVJT
SU9OKTsNCit9DQorDQorc3RhdGljIHN0cnVjdCBvcHRpb24gb3B0c1tdID0g
ew0KKwl7ICJ0aW1lc3RhcnQiLCAxLCAwLCAnMScgfSwNCisJeyAidGltZXN0
b3AiLCAxLCAwLCAnMicgfSwNCisJeyAiZGF5cyIsIDEsIDAsICczJ30sDQor
CXswfQ0KK307DQorDQorLyogSW5pdGlhbGl6ZSB0aGUgbWF0Y2guICovDQor
c3RhdGljIHZvaWQNCitpbml0KHN0cnVjdCBpcDZ0X2VudHJ5X21hdGNoICpt
LCB1bnNpZ25lZCBpbnQgKm5mY2FjaGUpDQorew0KKwkvKiBjYWNoaW5nIG5v
dCB5ZXQgaW1wbGVtZW50ZWQgKi8NCisgICAgICAgICpuZmNhY2hlIHw9IE5G
Q19VTktOT1dOOw0KKwlnbG9iYWxkYXlzID0gMDsNCit9DQorDQorLyoqDQor
ICogcGFyYW06IHBhcnQxLCBhIHBvaW50ZXIgb24gYSBzdHJpbmcgMiBjaGFy
cyBtYXhpbXVtIGxvbmcgc3RyaW5nLCB0aGF0IHdpbGwgY29udGFpbiB0aGUg
aG91cnMuDQorICogcGFyYW06IHBhcnQyLCBhIHBvaW50ZXIgb24gYSBzdHJp
bmcgMiBjaGFycyBtYXhpbXVtIGxvbmcgc3RyaW5nLCB0aGF0IHdpbGwgY29u
dGFpbiB0aGUgbWludXRlcy4NCisgKiBwYXJhbTogc3RyXzJfcGFyc2UsIHRo
ZSBzdHJpbmcgdG8gcGFyc2UuDQorICogcmV0dXJuOiAxIGlmIG9rLCAwIGlm
IGVycm9yLg0KKyAqLw0KK3N0YXRpYyBpbnQNCitzcGxpdF90aW1lKGNoYXIg
KipwYXJ0MSwgY2hhciAqKnBhcnQyLCBjb25zdCBjaGFyICpzdHJfMl9wYXJz
ZSkNCit7DQorCXVuc2lnbmVkIHNob3J0IGludCBpLGo9MDsNCisJY2hhciAq
cnBhcnQxID0gKnBhcnQxOw0KKwljaGFyICpycGFydDIgPSAqcGFydDI7DQor
CXVuc2lnbmVkIGNoYXIgZm91bmRfY29sdW1uID0gMDsNCisNCisJLyogQ2hl
Y2sgdGhlIGxlbmd0aCBvZiB0aGUgc3RyaW5nICovDQorCWlmIChzdHJsZW4o
c3RyXzJfcGFyc2UpID4gNSkNCisJCXJldHVybiAwOw0KKwkvKiBwYXJzZSB0
aGUgZmlyc3QgcGFydCB1bnRpbCB0aGUgJzonICovDQorCWZvciAoaT0wOyBp
PDI7IGkrKykNCisJew0KKwkJaWYgKHN0cl8yX3BhcnNlW2ldID09ICc6JykN
CisJCQlmb3VuZF9jb2x1bW4gPSAxOw0KKwkJZWxzZQ0KKwkJCXJwYXJ0MVtp
XSA9IHN0cl8yX3BhcnNlW2ldOw0KKwl9DQorCWlmICghZm91bmRfY29sdW1u
KQ0KKwkJaSsrOw0KKwlqPWk7DQorCS8qIHBhcnNlIHRoZSBzZWNvbmQgcGFy
dCAqLw0KKwlmb3IgKDsgaTxzdHJsZW4oc3RyXzJfcGFyc2UpOyBpKyspDQor
CXsNCisJCXJwYXJ0MltpLWpdID0gc3RyXzJfcGFyc2VbaV07DQorCX0NCisJ
LyogaWYgd2UgYXJlIGhlcmUsIGZvcm1hdCBzaG91bGQgYmUgb2suICovDQor
CXJldHVybiAxOw0KK30NCisNCitzdGF0aWMgdm9pZA0KK3BhcnNlX3RpbWVf
c3RyaW5nKHVuc2lnbmVkIGludCAqaG91ciwgdW5zaWduZWQgaW50ICptaW51
dGUsIGNvbnN0IGNoYXIgKnRpbWUpDQorew0KKwljaGFyICpob3VyczsNCisJ
Y2hhciAqbWludXRlczsNCisNCisJaG91cnMgPSAoY2hhciAqKW1hbGxvYygz
KTsNCisJbWludXRlcyA9IChjaGFyICopbWFsbG9jKDMpOw0KKwliemVybygo
dm9pZCAqKWhvdXJzLCAzKTsNCisJYnplcm8oKHZvaWQgKiltaW51dGVzLCAz
KTsNCisNCisJaWYgKHNwbGl0X3RpbWUoJmhvdXJzLCAmbWludXRlcywgdGlt
ZSkgPT0gMSkNCisJew0KKyAgICAgICAgICAgICAgICAvKiBpZiB0aGUgbnVt
YmVyIHN0YXJ0cyB3aXRoIDAsIHJlcGxhY2UgaXQgd2l0aCBhIHNwYWNlIGVs
c2UNCisgICAgICAgICAgICAgICAgICAgdGhpcyBzdHJpbmdfdG9fbnVtYmVy
IHdpbGwgaW50ZXJwcmV0IGl0IGFzIG9jdGFsICEhICovDQorICAgICAgICAg
ICAgICAgIGlmICgoaG91cnNbMF0gPT0gJzAnKSAmJiAoaG91cnNbMV0gIT0g
J1wwJykpDQorCQkJaG91cnNbMF0gPSAnICc7DQorCQlpZiAoKG1pbnV0ZXNb
MF0gPT0gJzAnKSAmJiAobWludXRlc1sxXSAhPSAnXDAnKSkNCisJCQltaW51
dGVzWzBdID0gJyAnOw0KKw0KKwkJaWYoKHN0cmluZ190b19udW1iZXIoaG91
cnMsIDAsIDIzLCBob3VyKSA9PSAtMSkgfHwNCisJCQkoc3RyaW5nX3RvX251
bWJlcihtaW51dGVzLCAwLCA1OSwgbWludXRlKSA9PSAtMSkpIHsNCisJCQkq
aG91ciA9ICptaW51dGUgPSAoLTEpOw0KKwkJfQ0KKwl9DQorCWlmICgoKmhv
dXIgIT0gKC0xKSkgJiYgKCptaW51dGUgIT0gKC0xKSkpIHsNCisJCWZyZWUo
aG91cnMpOw0KKwkJZnJlZShtaW51dGVzKTsNCisJCXJldHVybjsNCisJfQ0K
Kw0KKwkvKiBJZiB3ZSBhcmUgaGVyZSwgdGhlcmUgd2FzIGEgcHJvYmxlbSAu
LiovDQorCWV4aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JMRU0sDQorCQkgICAi
aW52YWxpZCB0aW1lIGAlcycgc3BlY2lmaWVkLCBzaG91bGQgYmUgSEg6TU0g
Zm9ybWF0IiwgdGltZSk7DQorfQ0KKw0KKy8qIHJldHVybiAxLT5vaywgcmV0
dXJuIDAtPmVycm9yICovDQorc3RhdGljIGludA0KK3BhcnNlX2RheShpbnQg
KmRheXMsIGludCBmcm9tLCBpbnQgdG8sIGNvbnN0IGNoYXIgKnN0cmluZykN
Cit7DQorCWNoYXIgKmRheXJlYWQ7DQorCWNoYXIgKmRheXNfc3RyWzddID0g
eyJTdW4iLCAiTW9uIiwgIlR1ZSIsICJXZWQiLCAiVGh1IiwgIkZyaSIsICJT
YXQifTsNCisJdW5zaWduZWQgc2hvcnQgaW50IGRheXNfb2Zfd2Vla1s3XSA9
IHs2NCwgMzIsIDE2LCA4LCA0LCAyLCAxfTsNCisJdW5zaWduZWQgaW50IGk7
DQorDQorCWRheXJlYWQgPSAoY2hhciAqKW1hbGxvYyg0KTsNCisJYnplcm8o
ZGF5cmVhZCwgNCk7DQorCWlmICgodG8tZnJvbSkgIT0gMykgew0KKwkJZnJl
ZShkYXlyZWFkKTsNCisJCXJldHVybiAwOw0KKwl9DQorCWZvciAoaT1mcm9t
OyBpPHRvOyBpKyspDQorCQlkYXlyZWFkW2ktZnJvbV0gPSBzdHJpbmdbaV07
DQorCWZvciAoaT0wOyBpPDc7IGkrKykNCisJCWlmIChzdHJjbXAoZGF5cmVh
ZCwgZGF5c19zdHJbaV0pID09IDApDQorCQl7DQorCQkJKmRheXMgfD0gZGF5
c19vZl93ZWVrW2ldOw0KKwkJCWZyZWUoZGF5cmVhZCk7DQorCQkJcmV0dXJu
IDE7DQorCQl9DQorCS8qIGlmIHdlIGFyZSBoZXJlLCB3ZSBkaWRuJ3QgcmVh
ZCBhIHZhbGlkIGRheSAqLw0KKwlmcmVlKGRheXJlYWQpOw0KKwlyZXR1cm4g
MDsNCit9DQorDQorc3RhdGljIHZvaWQNCitwYXJzZV9kYXlzX3N0cmluZyhp
bnQgKmRheXMsIGNvbnN0IGNoYXIgKmRheXN0cmluZykNCit7DQorCWludCBs
ZW47DQorCWludCBpPTA7DQorCWNoYXIgKmVyciA9ICJpbnZhbGlkIGRheXMg
YCVzJyBzcGVjaWZpZWQsIHNob3VsZCBiZSBTdW4sTW9uLFR1ZS4uLiBmb3Jt
YXQiOw0KKw0KKwlsZW4gPSBzdHJsZW4oZGF5c3RyaW5nKTsNCisJaWYgKGxl
biA8IDMpDQorCQlleGl0X2Vycm9yKFBBUkFNRVRFUl9QUk9CTEVNLCBlcnIs
IGRheXN0cmluZyk7CQ0KKwl3aGlsZShpPGxlbikNCisJew0KKwkJaWYgKHBh
cnNlX2RheShkYXlzLCBpLCBpKzMsIGRheXN0cmluZykgPT0gMCkNCisJCQll
eGl0X2Vycm9yKFBBUkFNRVRFUl9QUk9CTEVNLCBlcnIsIGRheXN0cmluZyk7
DQorCQlpICs9IDQ7DQorCX0NCit9DQorDQorI2RlZmluZSBJUDZUX1RJTUVf
U1RBUlQgMHgwMQ0KKyNkZWZpbmUgSVA2VF9USU1FX1NUT1AgIDB4MDINCisj
ZGVmaW5lIElQNlRfVElNRV9EQVlTICAweDA0DQorDQorDQorLyogRnVuY3Rp
b24gd2hpY2ggcGFyc2VzIGNvbW1hbmQgb3B0aW9uczsgcmV0dXJucyB0cnVl
IGlmIGl0DQorICAgYXRlIGFuIG9wdGlvbiAqLw0KK3N0YXRpYyBpbnQNCitw
YXJzZShpbnQgYywgY2hhciAqKmFyZ3YsIGludCBpbnZlcnQsIHVuc2lnbmVk
IGludCAqZmxhZ3MsDQorICAgICAgY29uc3Qgc3RydWN0IGlwNnRfZW50cnkg
KmVudHJ5LA0KKyAgICAgIHVuc2lnbmVkIGludCAqbmZjYWNoZSwNCisgICAg
ICBzdHJ1Y3QgaXA2dF9lbnRyeV9tYXRjaCAqKm1hdGNoKQ0KK3sNCisJc3Ry
dWN0IGlwNnRfdGltZV9pbmZvICp0aW1laW5mbyA9IChzdHJ1Y3QgaXA2dF90
aW1lX2luZm8gKikoKm1hdGNoKS0+ZGF0YTsNCisJaW50IGhvdXJzLCBtaW51
dGVzOw0KKw0KKwlzd2l0Y2ggKGMpDQorCXsNCisJCS8qIHRpbWVzdGFydCAq
Lw0KKwljYXNlICcxJzoNCisJCWlmIChpbnZlcnQpDQorCQkJZXhpdF9lcnJv
cihQQVJBTUVURVJfUFJPQkxFTSwNCisgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICJ1bmV4cGVjdGVkICchJyB3aXRoIC0tdGltZXN0YXJ0
Iik7DQorCQlpZiAoKmZsYWdzICYgSVA2VF9USU1FX1NUQVJUKQ0KKyAgICAg
ICAgICAgICAgICAgICAgICAgIGV4aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JM
RU0sDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiQ2Fu
J3Qgc3BlY2lmeSAtLXRpbWVzdGFydCB0d2ljZSIpOw0KKwkJcGFyc2VfdGlt
ZV9zdHJpbmcoJmhvdXJzLCAmbWludXRlcywgb3B0YXJnKTsNCisJCXRpbWVp
bmZvLT50aW1lX3N0YXJ0ID0gKGhvdXJzICogNjApICsgbWludXRlczsNCisJ
CSpmbGFncyB8PSBJUDZUX1RJTUVfU1RBUlQ7DQorCQlicmVhazsNCisJCS8q
IHRpbWVzdG9wICovDQorCWNhc2UgJzInOg0KKwkJaWYgKGludmVydCkNCisJ
CQlleGl0X2Vycm9yKFBBUkFNRVRFUl9QUk9CTEVNLA0KKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgInVuZXhwZWN0ZWQgJyEnIHdpdGgg
LS10aW1lc3RvcCIpOw0KKwkJaWYgKCpmbGFncyAmIElQNlRfVElNRV9TVE9Q
KQ0KKyAgICAgICAgICAgICAgICAgICAgICAgIGV4aXRfZXJyb3IoUEFSQU1F
VEVSX1BST0JMRU0sDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAiQ2FuJ3Qgc3BlY2lmeSAtLXRpbWVzdG9wIHR3aWNlIik7DQorCQlw
YXJzZV90aW1lX3N0cmluZygmaG91cnMsICZtaW51dGVzLCBvcHRhcmcpOw0K
KwkJdGltZWluZm8tPnRpbWVfc3RvcCA9IChob3VycyAqIDYwKSArIG1pbnV0
ZXM7DQorCQkqZmxhZ3MgfD0gSVA2VF9USU1FX1NUT1A7DQorCQlicmVhazsN
CisNCisJCS8qIGRheXMgKi8NCisJY2FzZSAnMyc6DQorCQlpZiAoaW52ZXJ0
KQ0KKwkJCWV4aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JMRU0sDQorICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAidW5leHBlY3RlZCAnIScg
d2l0aCAtLWRheXMiKTsNCisJCWlmICgqZmxhZ3MgJiBJUDZUX1RJTUVfREFZ
UykNCisgICAgICAgICAgICAgICAgICAgICAgICBleGl0X2Vycm9yKFBBUkFN
RVRFUl9QUk9CTEVNLA0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIkNhbid0IHNwZWNpZnkgLS1kYXlzIHR3aWNlIik7DQorCQlwYXJz
ZV9kYXlzX3N0cmluZygmZ2xvYmFsZGF5cywgb3B0YXJnKTsNCisJCXRpbWVp
bmZvLT5kYXlzX21hdGNoID0gZ2xvYmFsZGF5czsNCisJCSpmbGFncyB8PSBJ
UDZUX1RJTUVfREFZUzsNCisJCWJyZWFrOw0KKwlkZWZhdWx0Og0KKwkJcmV0
dXJuIDA7DQorCX0NCisJcmV0dXJuIDE7DQorfQ0KKw0KKy8qIEZpbmFsIGNo
ZWNrOyBtdXN0IGhhdmUgc3BlY2lmaWVkIC0tdGltZXN0YXJ0IC0tdGltZXN0
b3AgLS1kYXlzLiAqLw0KK3N0YXRpYyB2b2lkDQorZmluYWxfY2hlY2sodW5z
aWduZWQgaW50IGZsYWdzKQ0KK3sNCisJaWYgKGZsYWdzICE9IChJUDZUX1RJ
TUVfU1RBUlQgfCBJUDZUX1RJTUVfU1RPUCB8IElQNlRfVElNRV9EQVlTKSkN
CisJCWV4aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JMRU0sDQorCQkJICAgIlRJ
TUUgbWF0Y2g6IFlvdSBtdXN0IHNwZWNpZnkgYC0tdGltZXN0YXJ0IC0tdGlt
ZXN0b3AgYW5kIC0tZGF5cyciKTsNCit9DQorDQorDQorc3RhdGljIHZvaWQN
CitwcmludF9kYXlzKGludCBkYXludW0pDQorew0KKwljaGFyICpkYXlzWzdd
ID0geyJTdW4iLCAiTW9uIiwgIlR1ZSIsICJXZWQiLCAiVGh1IiwgIkZyaSIs
ICJTYXQifTsNCisJdW5zaWduZWQgc2hvcnQgaW50IGRheXNfb2Zfd2Vla1s3
XSA9IHs2NCwgMzIsIDE2LCA4LCA0LCAyLCAxfTsNCisJdW5zaWduZWQgc2hv
cnQgaW50IGksIG5iZGF5cz0wOw0KKw0KKwlmb3IgKGk9MDsgaTw3OyBpKysp
IHsNCisJCWlmICgoZGF5c19vZl93ZWVrW2ldICYgZGF5bnVtKSA9PSBkYXlz
X29mX3dlZWtbaV0pDQorCQl7DQorCQkJaWYgKG5iZGF5cz4wKQ0KKwkJCQlw
cmludGYoIiwlcyIsIGRheXNbaV0pOw0KKwkJCWVsc2UNCisJCQkJcHJpbnRm
KCIlcyIsIGRheXNbaV0pOw0KKwkJCSsrbmJkYXlzOw0KKwkJfQ0KKwl9DQor
fQ0KKw0KK3N0YXRpYyB2b2lkDQorZGl2aWRlX3RpbWUoaW50IGZ1bGx0aW1l
LCBpbnQgKmhvdXJzLCBpbnQgKm1pbnV0ZXMpDQorew0KKwkqaG91cnMgPSBm
dWxsdGltZSAvIDYwOw0KKwkqbWludXRlcyA9IGZ1bGx0aW1lICUgNjA7DQor
fQ0KKw0KKy8qIFByaW50cyBvdXQgdGhlIG1hdGNoaW5mby4gKi8NCitzdGF0
aWMgdm9pZA0KK3ByaW50KGNvbnN0IHN0cnVjdCBpcDZ0X2lwNiAqaXAsDQor
ICAgICAgY29uc3Qgc3RydWN0IGlwNnRfZW50cnlfbWF0Y2ggKm1hdGNoLA0K
KyAgICAgIGludCBudW1lcmljKQ0KK3sNCisJc3RydWN0IGlwNnRfdGltZV9p
bmZvICp0aW1lID0gKChzdHJ1Y3QgaXA2dF90aW1lX2luZm8gKiltYXRjaC0+
ZGF0YSk7DQorCWludCBob3VyX3N0YXJ0LCBob3VyX3N0b3AsIG1pbnV0ZV9z
dGFydCwgbWludXRlX3N0b3A7DQorDQorCWRpdmlkZV90aW1lKHRpbWUtPnRp
bWVfc3RhcnQsICZob3VyX3N0YXJ0LCAmbWludXRlX3N0YXJ0KTsNCisJZGl2
aWRlX3RpbWUodGltZS0+dGltZV9zdG9wLCAmaG91cl9zdG9wLCAmbWludXRl
X3N0b3ApOw0KKwlwcmludGYoIiBUSU1FIGZyb20gJWQ6JWQgdG8gJWQ6JWQg
b24gIiwNCisJICAgICAgIGhvdXJfc3RhcnQsIG1pbnV0ZV9zdGFydCwNCisJ
ICAgICAgIGhvdXJfc3RvcCwgbWludXRlX3N0b3ApOw0KKwlwcmludF9kYXlz
KHRpbWUtPmRheXNfbWF0Y2gpOw0KKwlwcmludGYoIiAiKTsNCit9DQorDQor
LyogU2F2ZXMgdGhlIGRhdGEgaW4gcGFyc2FibGUgZm9ybSB0byBzdGRvdXQu
ICovDQorc3RhdGljIHZvaWQNCitzYXZlKGNvbnN0IHN0cnVjdCBpcDZ0X2lw
NiAqaXAsIGNvbnN0IHN0cnVjdCBpcDZ0X2VudHJ5X21hdGNoICptYXRjaCkN
Cit7DQorCXN0cnVjdCBpcDZ0X3RpbWVfaW5mbyAqdGltZSA9ICgoc3RydWN0
IGlwNnRfdGltZV9pbmZvICopbWF0Y2gtPmRhdGEpOw0KKwlpbnQgaG91cl9z
dGFydCwgaG91cl9zdG9wLCBtaW51dGVfc3RhcnQsIG1pbnV0ZV9zdG9wOw0K
Kw0KKwlkaXZpZGVfdGltZSh0aW1lLT50aW1lX3N0YXJ0LCAmaG91cl9zdGFy
dCwgJm1pbnV0ZV9zdGFydCk7DQorCWRpdmlkZV90aW1lKHRpbWUtPnRpbWVf
c3RvcCwgJmhvdXJfc3RvcCwgJm1pbnV0ZV9zdG9wKTsNCisJcHJpbnRmKCIg
LS10aW1lc3RhcnQgJS4yZDolLjJkIC0tdGltZXN0b3AgJS4yZDolLjJkIC0t
ZGF5cyAiLA0KKwkgICAgICAgaG91cl9zdGFydCwgbWludXRlX3N0YXJ0LA0K
KwkgICAgICAgaG91cl9zdG9wLCBtaW51dGVfc3RvcCk7DQorCXByaW50X2Rh
eXModGltZS0+ZGF5c19tYXRjaCk7DQorCXByaW50ZigiICIpOw0KK30NCisN
CitzdGF0aWMNCitzdHJ1Y3QgaXA2dGFibGVzX21hdGNoIHRpbWVzdHJ1Y3QN
Cis9IHsgTlVMTCwNCisgICAgInRpbWUiLA0KKyAgICBJUFRBQkxFU19WRVJT
SU9OLA0KKyAgICBJUDZUX0FMSUdOKHNpemVvZihzdHJ1Y3QgaXA2dF90aW1l
X2luZm8pKSwNCisgICAgSVA2VF9BTElHTihzaXplb2Yoc3RydWN0IGlwNnRf
dGltZV9pbmZvKSksDQorICAgICZoZWxwLA0KKyAgICAmaW5pdCwNCisgICAg
JnBhcnNlLA0KKyAgICAmZmluYWxfY2hlY2ssDQorICAgICZwcmludCwNCisg
ICAgJnNhdmUsDQorICAgIG9wdHMNCit9Ow0KKw0KK3ZvaWQgX2luaXQodm9p
ZCkNCit7DQorCXJlZ2lzdGVyX21hdGNoNigmdGltZXN0cnVjdCk7DQorfQ0K

---23717851-208348636-1051975099=:24297--
