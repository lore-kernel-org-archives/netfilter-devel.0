From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH][RESEND] IPv6 port of the time match.
Date: Thu, 7 Aug 2003 16:16:50 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0308071614570.16724@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

Hello,

this is a third resend of the match, it still received no response.

Regards,
Maciej

diff -Nru netfilter.orig/patch-o-matic/base/time.patch.ipv6 netfilter/patch-o-matic/base/time.patch.ipv6
--- netfilter.orig/patch-o-matic/base/time.patch.ipv6	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/time.patch.ipv6	2003-05-03 16:56:46.000000000 +0200
@@ -0,0 +1,211 @@
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
+@@ -0,0 +1,190 @@
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
++static struct ip6t_match time_match = {
++	.name		= "time",
++	.match		= &match,
++	.checkentry	= &checkentry,
++	.me		= THIS_MODULE
++};
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
@@ -0,0 +1,312 @@
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
+struct ip6tables_match timestruct = {
+    .name		= "time",
+    .version		= IPTABLES_VERSION,
+    .size		= IP6T_ALIGN(sizeof(struct ip6t_time_info)),
+    .userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_time_info)),
+    .help		= &help,
+    .init		= &init,
+    .parse		= &parse,
+    .final_check	= &final_check,
+    .print		= &print,
+    .save		= &save,
+    .extra_opts	= opts
+};
+
+void _init(void)
+{
+	register_match6(&timestruct);
+}
