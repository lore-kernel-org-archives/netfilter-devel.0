From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: xt_time 20070820
Date: Mon, 20 Aug 2007 21:19:35 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708201733090.5333@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-226435966-1187637575=:5333"
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-226435966-1187637575=:5333
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,


this is xt_time, posted for reference and discussion. Not perfect yet,=20
but a start.

<<<

ipt_time from POM-ng augmented by:

 * xtables
 * ipv6 support

It does have timezone support, BTW.

---
 include/linux/netfilter/xt_time.h |   26 +++++
 net/netfilter/Kconfig             |   15 +++
 net/netfilter/Makefile            |    1=20
 net/netfilter/xt_time.c           |  183 +++++++++++++++++++++++++++++++=
+++++++
 4 files changed, 225 insertions(+)

Index: linux-2.6.22.3/include/linux/netfilter/xt_time.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.22.3/include/linux/netfilter/xt_time.h
@@ -0,0 +1,26 @@
+#ifndef _XT_TIME_H
+#define _XT_TIME_H 1
+
+enum {
+	XT_TIME_MONDAY    =3D 1 << 1,
+	XT_TIME_TUESDAY   =3D 1 << 2,
+	XT_TIME_WEDNESDAY =3D 1 << 3,
+	XT_TIME_THURSDAY  =3D 1 << 4,
+	XT_TIME_FRIDAY    =3D 1 << 5,
+	XT_TIME_SATURDAY  =3D 1 << 6,
+	XT_TIME_SUNDAY    =3D 1 << 7,
+};
+
+struct xt_time_info {
+	u_int8_t  days_match;   /* 1 bit per day. -SMTWTFS                     =
 */
+	u_int16_t time_start;   /* 0 < time_start < 23*60+59 =3D 1439          =
   */
+	u_int16_t time_stop;    /* 0:0 < time_stat < 23:59                     =
 */
+
+				/* FIXME: Keep this one for userspace iptables binary compability: *=
/
+	u_int8_t kerneltime;   /* ignore skb time (and use kerneltime) or not. =
*/
+
+	time_t date_start;
+	time_t date_stop;
+};
+
+#endif /* _XT_TIME_H */
Index: linux-2.6.22.3/net/netfilter/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.22.3.orig/net/netfilter/Kconfig
+++ linux-2.6.22.3/net/netfilter/Kconfig
@@ -635,6 +635,21 @@ config NETFILTER_XT_MATCH_TCPMSS
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
+config NETFILTER_XT_MATCH_TIME
+	tristate '"time" match support'
+	depends on NETFILTER_XTABLES
+	---help---
+	  This option adds a "time" match, which allows you to match based on
+	  the packet arrival time/date (arrival time/date at the machine which
+	  netfilter is running on) or departure time/date (for locally
+	  generated packets).
+
+	  If you say Y here, try `iptables -m time --help` for
+	  more information.
+
+	  If you want to compile it as a module, say M here and read
+	  Documentation/modules.txt. If unsure, say N.
+
 config NETFILTER_XT_MATCH_HASHLIMIT
 	tristate '"hashlimit" match support'
 	depends on NETFILTER_XTABLES && (IP6_NF_IPTABLES || IP6_NF_IPTABLES=3Dn=
)
Index: linux-2.6.22.3/net/netfilter/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.22.3.orig/net/netfilter/Makefile
+++ linux-2.6.22.3/net/netfilter/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) +=3D
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) +=3D xt_state.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) +=3D xt_statistic.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) +=3D xt_string.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_TIME) +=3D xt_time.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) +=3D xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) +=3D xt_physdev.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HASHLIMIT) +=3D xt_hashlimit.o
Index: linux-2.6.22.3/net/netfilter/xt_time.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.22.3/net/netfilter/xt_time.c
@@ -0,0 +1,183 @@
+/*
+ *	xt_time
+ *	Copyright =C2=A9 Jan Engelhardt <jengelh@gmx.de>, 2007
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
+struct tm {
+	int tm_min;                   /* Minutes.     [0-59] */
+	int tm_hour;                  /* Hours.       [0-23] */
+	int tm_mday;                  /* Day.         [1-31] */
+	int tm_mon;                   /* Month.       [0-11] */
+	int tm_year;                  /* Year - 1900.  */
+	int tm_wday;                  /* Day of week. [0-6] */
+	int tm_yday;                  /* Days in year.[0-365] */
+};
+
+/* The localtime() function is borowed and modified from dietlibc */
+static void localtime(const u_int32_t time, struct tm *r)
+{
+	u_int32_t i, timep;
+	extern struct timezone sys_tz;
+	static const unsigned int __spm[] =3D {
+		0,
+		31,
+		31+28,
+		31+28+31,
+		31+28+31+30,
+		31+28+31+30+31,
+		31+28+31+30+31+30,
+		31+28+31+30+31+30+31,
+		31+28+31+30+31+30+31+31,
+		31+28+31+30+31+30+31+31+30,
+		31+28+31+30+31+30+31+31+30+31,
+		31+28+31+30+31+30+31+31+30+31+30,
+	};
+	u_int32_t work;
+
+	timep      =3D time - 60 * sys_tz.tz_minuteswest;
+	work       =3D timep % 86400; /* 1d =3D 86400s */
+	work      /=3D 60;
+	r->tm_min  =3D work % 60;
+	r->tm_hour =3D work / 60;
+	work       =3D timep / 86400;
+	r->tm_wday =3D (4 + work) % 7;
+	for (i =3D 1970; ; ++i) {
+		time_t k =3D (!(i % 4) && ((i % 100) || !(i % 400))) ? 366 : 365;
+		if (work > k)
+			work -=3D k;
+		else
+			break;
+	}
+	r->tm_year =3D i - 1900;
+	for (i =3D 11; i && __spm[i] > work; --i)
+		;
+	r->tm_mon =3D i;
+	r->tm_mday =3D work - __spm[i] + 1;
+}
+
+static const u_int8_t days_of_week[] =3D {
+	0,
+	XT_TIME_MONDAY,
+	XT_TIME_TUESDAY,
+	XT_TIME_WEDNESDAY,
+	XT_TIME_THURSDAY,
+	XT_TIME_FRIDAY,
+	XT_TIME_SATURDAY,
+	XT_TIME_SUNDAY,
+};
+
+static int xt_time_match(const struct sk_buff *skb,
+                         const struct net_device *in,
+                         const struct net_device *out,
+                         const struct xt_match *match, const void *match=
info,
+                         int offset, unsigned int protoff, int *hotdrop)
+{
+	const struct xt_time_info *info =3D matchinfo;
+	struct tm current_time;
+	unsigned int packet_time;
+	struct timeval stamp;
+
+	/* We might not have a timestamp, get one */
+	if (skb->tstamp.tv64 =3D=3D 0)
+		__net_timestamp((struct sk_buff *)skb);
+
+	skb_get_timestamp(skb, &stamp);
+
+	/* First we make sure we are in the date start-stop boundaries */
+	if (stamp.tv_sec < info->date_start || stamp.tv_sec > info->date_stop)
+		/* We are outside the date boundaries */
+		return false;
+
+	/* Transform the timestamp of the packet, in a human readable form */
+	localtime(stamp.tv_sec, &current_time);
+
+	/* check if we match this timestamp, we start by the days... */
+	if (!(info->days_match & days_of_week[current_time.tm_wday]))
+		/* the day does not match */
+		return false;
+
+	/*
+	 * Check the time now, both vesions:
+	 * "start < stop" and "start > stop" (midnight cross)
+	 */
+	packet_time =3D current_time.tm_hour * 60 + current_time.tm_min;
+	printk(KERN_WARNING "stamp: %lu, pkt_time: %u, tstart: %u, tstop: %u\n"=
,
+		stamp.tv_sec,
+		packet_time, info->time_start, info->time_stop);
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
+static int xt_time_check(const char *tablename, const void *ip,
+                         const struct xt_match *match, void *matchinfo,
+                         unsigned int hook_mask)
+{
+	struct xt_time_info *info =3D matchinfo;
+
+	/* xt_time's granularity is a minute, hence 24*60 =3D 1day */
+	if (info->time_start >=3D 24 * 60 || info->time_stop >=3D 24 * 60) {
+		printk(KERN_WARNING KBUILD_MODNAME ": invalid argument - "
+		       "start or stop time greater than 23:59h\n");
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
---699020219-226435966-1187637575=:5333--
