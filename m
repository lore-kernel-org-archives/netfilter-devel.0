From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: xt_time 20070915
Date: Sat, 15 Sep 2007 18:07:59 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709151806080.24423@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: kaber@trash.net
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


For 2.6.24. Please comment, thanks!


=3D=3D=3D


ipt_time from POM-ng augmented by:

 * xtables
 * ipv6 support
 * day-of-month support (for example "match on the 15th of each month")
 * timezone (it was there before though) -
   it does *what the user expects* (which is good).

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/linux/netfilter/xt_time.h |   13 ++
 net/netfilter/Kconfig             |   14 ++
 net/netfilter/Makefile            |    1=20
 net/netfilter/xt_time.c           |  208 +++++++++++++++++++++++++++++++=
+++++++
 4 files changed, 236 insertions(+)

Index: linux-2.6.23/include/linux/netfilter/xt_time.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.23/include/linux/netfilter/xt_time.h
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
Index: linux-2.6.23/net/netfilter/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
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
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
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
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.23/net/netfilter/xt_time.c
@@ -0,0 +1,208 @@
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
+#include "xt_time.h"
+
+struct xtm {
+	unsigned int month;    /* (1-12) */
+	unsigned int monthday; /* (1-31) */
+	unsigned int weekday;  /* (1-7) */
+	unsigned int hour;     /* (0-23) */
+	unsigned int minute;   /* (0-59) */
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
+ * Since time progresses forward, it is best to organize this array in r=
everse,
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
+static void localtime(struct xtm *r, time_t time)
+{
+	unsigned int year, i, w;
+
+	time -=3D 60 * sys_tz.tz_minuteswest;
+
+	/* 1d=3D86400s. Daytime. */
+	w  =3D time % 86400;
+	w /=3D 60;
+	r->minute =3D w % 60;
+	r->hour   =3D w / 60;
+
+	/* Days since 1970-01-01 */
+	w =3D time / 86400;
+	r->weekday =3D (4 + w) % 7;
+
+	/*
+	 * Consider x=3D21551. Loop will abort on dse[i] <=3D x, which is with
+	 * dse[i] =3D 21550 (=3D> 2029-01-02).
+	 */
+	for (i =3D 0, year =3D DSE_FIRST; days_since_epoch[i] > w;
+	    ++i, --year)
+		/* just loop */;
+
+	w -=3D days_since_epoch[i];
+	/* r->yearday =3D w; */
+
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
+	printk(KERN_ERR "m=3D%u md=3D%u\n", r->month, r->monthday);
+	return;
+}
+
+static bool xt_time_match(const struct sk_buff *skb,
+                          const struct net_device *in,
+                          const struct net_device *out,
+                          const struct xt_match *match, const void *matc=
hinfo,
+                          int offset, unsigned int protoff, bool *hotdro=
p)
+{
+	const struct xt_time_info *info =3D matchinfo;
+	unsigned int packet_time;
+	struct xtm current_time;
+	s64 stamp;
+
+	if (skb->tstamp.tv64 =3D=3D 0)
+		__net_timestamp((struct sk_buff *)skb);
+
+	stamp =3D skb->tstamp.tv64;
+	do_div(stamp, NSEC_PER_SEC);
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
+	localtime(&current_time, stamp);
+
+	if (!(info->monthdays_match & (1 << current_time.monthday)))
+		return false;
+	if (!(info->weekdays_match & (1 << current_time.weekday)))
+		return false;
+
+	packet_time =3D current_time.hour * 60 + current_time.minute;
+	if (info->time_start < info->time_stop) {
+		if (packet_time < info->time_start ||
+		    packet_time > info->time_stop)
+			return false;
+	} else {
+		if (packet_time < info->time_start &&
+		    packet_time > info->time_stop)
+			return false;
+	}
+
+	return true;
+}
+
+static bool xt_time_check(const char *tablename, const void *ip,
+                          const struct xt_match *match, void *matchinfo,
+                          unsigned int hook_mask)
+{
+	struct xt_time_info *info =3D matchinfo;
+
+	/* xt_time's granularity is a minute, hence 24*60 =3D 1day */
+	if (info->time_start > 24 * 60 || info->time_stop >=3D 24 * 60) {
+		printk(KERN_WARNING "ipt_time: invalid argument - start or stop time g=
reater than 23:59h\n");
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
