From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: xt_time 2007-09-22
Date: Sat, 22 Sep 2007 13:26:51 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709221315590.15712@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36309 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbXIVL0x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Sep 2007 07:26:53 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id B7B721C070579
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Sep 2007 13:26:51 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Add the xt_time netfilter match

This is ipt_time from POM-ng enhanced by the following:

 * xtables/ipv6 support
 * second granularity for daytime
 * day-of-month support (for example "match on the 15th of each month")
 * match against UTC or local timezone

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/linux/netfilter/xt_time.h |   25 +++
 net/netfilter/Kconfig             |   14 ++
 net/netfilter/Makefile            |    1=20
 net/netfilter/xt_time.c           |  266 +++++++++++++++++++++++++++++=
+++++++++
 4 files changed, 306 insertions(+)

Index: linux-2.6.23/include/linux/netfilter/xt_time.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.23/include/linux/netfilter/xt_time.h
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
Index: linux-2.6.23/net/netfilter/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.23.orig/net/netfilter/Kconfig
+++ linux-2.6.23/net/netfilter/Kconfig
@@ -665,6 +665,20 @@ config NETFILTER_XT_MATCH_TCPMSS
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
+config NETFILTER_XT_MATCH_TIME
+	tristate '"time" match support'
+	depends on NETFILTER_XTABLES
+	---help---
+	  This option adds a "time" match, which allows you to match based on
+	  the packet arrival time (at the machine which netfilter is running)
+	  on) or departure time/date (for locally generated packets).
+
+	  If you say Y here, try `iptables -m time --help` for
+	  more information.
+
+	  If you want to compile it as a module, say M here.
+	  If unsure, say N.
+
 config NETFILTER_XT_MATCH_U32
 	tristate '"u32" match support'
 	depends on NETFILTER_XTABLES
Index: linux-2.6.23/net/netfilter/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.23.orig/net/netfilter/Makefile
+++ linux-2.6.23/net/netfilter/Makefile
@@ -73,6 +73,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) +=3D
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) +=3D xt_state.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) +=3D xt_statistic.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) +=3D xt_string.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_TIME) +=3D xt_time.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) +=3D xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) +=3D xt_physdev.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_U32) +=3D xt_u32.o
Index: linux-2.6.23/net/netfilter/xt_time.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.23/net/netfilter/xt_time.c
@@ -0,0 +1,266 @@
+/*
+ *	xt_time
+ *	Copyright =C2=A9 Jan Engelhardt <jengelh@computergmbh.de>, 2007
+ *
+ *	based on ipt_time by Fabrice MARIE <fabrice@netfilter.org>
+ *	This is a module which is used for time matching
+ *	It is using some modified code from dietlibc (localtime() function)
+ *	that you can find at http://www.fefe.de/dietlibc/
+ *	This file is distributed under the terms of the GNU General Public
+ *	License (GPL). Copies of the GPL can be obtained from gnu.org/gpl.
+ */
+#include <linux/ktime.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_time.h>
+
+struct xtm {
+	u_int8_t month;    /* (1-12) */
+	u_int8_t monthday; /* (1-31) */
+	u_int8_t weekday;  /* (1-7) */
+	u_int8_t hour;     /* (0-23) */
+	u_int8_t minute;   /* (0-59) */
+	u_int8_t second;   /* (0-59) */
+	unsigned int dse;
+};
+
+extern struct timezone sys_tz; /* ouch */
+
+static const u_int16_t days_since_year[] =3D {
+	0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334,
+};
+
+static const u_int16_t days_since_leapyear[] =3D {
+	0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335,
+};
+
+/*
+ * Since time progresses forward, it is best to organize this array in=
 reverse,
+ * to minimize lookup time.
+ */
+enum {
+	DSE_FIRST =3D 2039,
+};
+static const u_int16_t days_since_epoch[] =3D {
+	/* 2039 - 2030 */
+	25202, 24837, 24472, 24106, 23741, 23376, 23011, 22645, 22280, 21915,
+	/* 2029 - 2020 */
+	21550, 21184, 20819, 20454, 20089, 19723, 19358, 18993, 18628, 18262,
+	/* 2019 - 2010 */
+	17897, 17532, 17167, 16801, 16436, 16071, 15706, 15340, 14975, 14610,
+	/* 2009 - 2000 */
+	14245, 13879, 13514, 13149, 12784, 12418, 12053, 11688, 11323, 10957,
+	/* 1999 - 1990 */
+	10592, 10227, 9862, 9496, 9131, 8766, 8401, 8035, 7670, 7305,
+	/* 1989 - 1980 */
+	6940, 6574, 6209, 5844, 5479, 5113, 4748, 4383, 4018, 3652,
+	/* 1979 - 1970 */
+	3287, 2922, 2557, 2191, 1826, 1461, 1096, 730, 365, 0,
+};
+
+static inline bool is_leap(unsigned int y)
+{
+	return y % 4 =3D=3D 0 && (y % 100 !=3D 0 || y % 400 =3D=3D 0);
+}
+
+/*
+ * Each network packet has a (nano)seconds-since-the-epoch (SSTE) time=
stamp.
+ * Since we match against days and daytime, the SSTE value needs to be
+ * computed back into human-readable dates.
+ *
+ * This is done in three separate functions so that the most expensive
+ * calculations are done last, in case a "simple match" can be found e=
arlier.
+ */
+static inline unsigned int localtime_1(struct xtm *r, time_t time)
+{
+	unsigned int v, w;
+
+	/* Each day has 86400s, so finding the hour/minute is actually easy. =
*/
+	v         =3D time % 86400;
+	r->second =3D v % 60;
+	w         =3D v / 60;
+	r->minute =3D w % 60;
+	r->hour   =3D w / 60;
+	return v;
+}
+
+static inline void localtime_2(struct xtm *r, time_t time)
+{
+	/*
+	 * Here comes the rest (weekday, monthday). First, divide the SSTE
+	 * by seconds-per-day to get the number of _days_ since the epoch.
+	 */
+	r->dse =3D time / 86400;
+
+	/* 1970-01-01 (w=3D0) was a Thursday (4). */
+	r->weekday =3D (4 + r->dse) % 7;
+}
+
+static void localtime_3(struct xtm *r, time_t time)
+{
+	unsigned int year, i, w =3D r->dse;
+
+	/*
+	 * In each year, a certain number of days-since-the-epoch have passed=
=2E
+	 * Find the year that is closest to said days.
+	 *
+	 * Consider, for example, w=3D21612 (2029-03-04). Loop will abort on
+	 * dse[i] <=3D w, which happens when dse[i] =3D=3D 21550. This implie=
s
+	 * year =3D=3D 2009. w will then be 62.
+	 */
+	for (i =3D 0, year =3D DSE_FIRST; days_since_epoch[i] > w;
+	    ++i, --year)
+		/* just loop */;
+
+	w -=3D days_since_epoch[i];
+
+	/*
+	 * By now we have the current year, and the day of the year.
+	 * r->yearday =3D w;
+	 *
+	 * On to finding the month (like above). In each month, a certain
+	 * number of days-since-New Year have passed, and find the closest
+	 * one.
+	 *
+	 * Consider w=3D62 (in a non-leap year). Loop will abort on
+	 * dsy[i] < w, which happens when dsy[i] =3D=3D 31+28 (i =3D=3D 2).
+	 * Concludes i =3D=3D 2, i.e. 3rd month =3D> March.
+	 *
+	 * (A different approach to use would be to subtract a monthlength
+	 * from w repeatedly while counting.)
+	 */
+	if (is_leap(year)) {
+		for (i =3D ARRAY_SIZE(days_since_leapyear) - 1;
+		    i > 0 && days_since_year[i] > w; --i)
+			/* just loop */;
+	} else {
+		for (i =3D ARRAY_SIZE(days_since_year) - 1;
+		    i > 0 && days_since_year[i] > w; --i)
+			/* just loop */;
+	}
+
+	r->month    =3D i + 1;
+	r->monthday =3D w - days_since_year[i] + 1;
+	return;
+}
+
+static bool xt_time_match(const struct sk_buff *skb,
+                          const struct net_device *in,
+                          const struct net_device *out,
+                          const struct xt_match *match, const void *ma=
tchinfo,
+                          int offset, unsigned int protoff, bool *hotd=
rop)
+{
+	const struct xt_time_info *info =3D matchinfo;
+	unsigned int packet_time;
+	struct xtm current_time;
+	s64 stamp;
+
+	/*
+	 * We cannot use get_seconds() instead of __net_timestamp() here.
+	 * Suppose you have two rules:
+	 * 	1. match before 13:00
+	 * 	2. match after 13:00
+	 * If you match against processing time (get_seconds) it
+	 * may happen that the same packet matches both rules if
+	 * it arrived at the right moment before 13:00.
+	 */
+	if (skb->tstamp.tv64 =3D=3D 0)
+		__net_timestamp((struct sk_buff *)skb);
+
+	stamp =3D skb->tstamp.tv64;
+	do_div(stamp, NSEC_PER_SEC);
+
+	if (info->flags & XT_TIME_LOCAL_TZ)
+		/* Adjust for local timezone */
+		stamp -=3D 60 * sys_tz.tz_minuteswest;
+
+	/*
+	 * xt_time will match when _all_ of the following hold:
+	 *   - 'now' is in the global time range date_start..date_end
+	 *   - 'now' is in the monthday mask
+	 *   - 'now' is in the weekday mask
+	 *   - 'now' is in the daytime range time_start..time_end
+	 * (and by default, libxt_time will set these so as to match)
+	 */
+
+	if (stamp < info->date_start || stamp > info->date_stop)
+		return false;
+
+	packet_time =3D localtime_1(&current_time, stamp);
+
+	if (info->daytime_start < info->daytime_stop) {
+		if (packet_time < info->daytime_start ||
+		    packet_time > info->daytime_stop)
+			return false;
+	} else {
+		if (packet_time < info->daytime_start &&
+		    packet_time > info->daytime_stop)
+			return false;
+	}
+
+	localtime_2(&current_time, stamp);
+
+	if (!(info->weekdays_match & (1 << current_time.weekday)))
+		return false;
+
+	localtime_3(&current_time, stamp);
+
+	if (!(info->monthdays_match & (1 << current_time.monthday)))
+		return false;
+
+	return true;
+}
+
+static bool xt_time_check(const char *tablename, const void *ip,
+                          const struct xt_match *match, void *matchinf=
o,
+                          unsigned int hook_mask)
+{
+	struct xt_time_info *info =3D matchinfo;
+
+	if (info->daytime_start > XT_TIME_MAX_DAYTIME ||
+	    info->daytime_stop > XT_TIME_MAX_DAYTIME) {
+		printk(KERN_WARNING "xt_time: invalid argument - start or "
+		       "stop time greater than 23:59:59\n");
+		return false;
+	}
+
+	return true;
+}
+
+static struct xt_match xt_time_reg[] __read_mostly =3D {
+	{
+		.name       =3D "time",
+		.family     =3D AF_INET,
+		.match      =3D xt_time_match,
+		.matchsize  =3D sizeof(struct xt_time_info),
+		.checkentry =3D xt_time_check,
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "time",
+		.family     =3D AF_INET6,
+		.match      =3D xt_time_match,
+		.matchsize  =3D sizeof(struct xt_time_info),
+		.checkentry =3D xt_time_check,
+		.me         =3D THIS_MODULE,
+	},
+};
+
+static int __init xt_time_init(void)
+{
+	return xt_register_matches(xt_time_reg, ARRAY_SIZE(xt_time_reg));
+}
+
+static void __exit xt_time_exit(void)
+{
+	xt_unregister_matches(xt_time_reg, ARRAY_SIZE(xt_time_reg));
+}
+
+module_init(xt_time_init);
+module_exit(xt_time_exit);
+MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
+MODULE_DESCRIPTION("netfilter time match");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_time");
+MODULE_ALIAS("ip6t_time");

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
