From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Request for maintaining "condition" and "time"
Date: Wed, 11 Jul 2007 09:17:12 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707110912440.11053@fbirervta.pbzchgretzou.qr>
References: <13732b70707102143y64c43ea0hb7ba564f41b460c3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-699020219-689105779-1184138232=:11053"
Cc: netfilter-devel@lists.netfilter.org
To: "Gustavo Jr. Alves" <gjalves@gjalves.com.br>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <13732b70707102143y64c43ea0hb7ba564f41b460c3@mail.gmail.com>
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

---699020219-689105779-1184138232=:11053
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


On Jul 11 2007 01:43, Gustavo Jr. Alves wrote:
>
> I like to request permission for maintaining the "officials" condition
> and time modules. Actually I=C2=B4m developing a product who requires t=
his
> two modules and is very important to have both up-to-date.

time is already under 'my' hut (read: I've already changed it for 2.6.22)=
,
but I'm flexible.



ipt_time from POM-ng augmented by:

 * xtables
 * ipv6 support

---
 include/linux/netfilter/xt_time.h |   17 ++++
 net/netfilter/Kconfig             |   15 +++
 net/netfilter/Makefile            |    1=20
 net/netfilter/xt_time.c           |  161 +++++++++++++++++++++++++++++++=
+++++++
 4 files changed, 194 insertions(+)

Index: linux-2.6.22/include/linux/netfilter/xt_time.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.22/include/linux/netfilter/xt_time.h
@@ -0,0 +1,17 @@
+#ifndef _XT_TIME_H
+#define _XT_TIME_H 1
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
+
+#endif /* _XT_TIME_H */
Index: linux-2.6.22/net/netfilter/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.22.orig/net/netfilter/Kconfig
+++ linux-2.6.22/net/netfilter/Kconfig
@@ -712,6 +712,21 @@ config NETFILTER_XT_MATCH_TCPMSS
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
 config NETFILTER_XT_MATCH_U32
 	tristate '"u32" match support'
 	depends on NETFILTER_XTABLES
Index: linux-2.6.22/net/netfilter/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.22.orig/net/netfilter/Makefile
+++ linux-2.6.22/net/netfilter/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) +
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) +=3D xt_layer7.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) +=3D xt_statistic.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) +=3D xt_string.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_TIME) +=3D xt_time.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) +=3D xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) +=3D xt_physdev.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_U32) +=3D xt_u32.o
Index: linux-2.6.22/net/netfilter/xt_time.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.22/net/netfilter/xt_time.c
@@ -0,0 +1,161 @@
+/*
+ *	xt_time
+ *	Copyright =C2=A9 Jan Engelhardt <jengelh@gmx.de>, 2007
+ *
+ *	based on ipt_time by Fabrice MARIE <fabrice@netfilter.org>
+ *	This is a module which is used for time matching
+ *	It is using some modified code from dietlibc (localtime() function)
+ *	that you can find at http://www.fefe.de/dietlibc/
+ *	This file is distributed under the terms of the GNU General Public
+ *	License (GPL). Copies of the GPL can be obtained from gnu.org/license=
s.
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
+{ /* XXX: this still has some unneeded code */
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
+	timep      =3D time - (sys_tz.tz_minuteswest * 60);
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
+static const u_int8_t days_of_week[7] =3D
+	{1 << 6, 1 << 5, 1 << 4, 1 << 3, 1 << 2, 1 << 1, 1 << 0};
+
+static bool xt_time_match(const struct sk_buff *skb,
+                          const struct net_device *in,
+                          const struct net_device *out,
+                          const struct xt_match *match, const void *matc=
hinfo,
+                          int offset, unsigned int protoff, bool *hotdro=
p)
+{
+	const struct xt_time_info *info =3D matchinfo; /* match info for rule *=
/
+	struct tm currenttime;                       /* time human readable */
+	u_int16_t packet_time;
+	time_t stamp;
+
+	/* We might not have a timestamp, get one */
+	if (skb->tstamp.tv64 =3D=3D 0)
+		__net_timestamp((struct sk_buff *)skb);
+
+	stamp =3D skb->tstamp.tv64;
+	do_div(stamp, NSEC_PER_SEC);
+
+	/* First we make sure we are in the date start-stop boundaries */
+	if (stamp < info->date_start || stamp > info->date_stop)
+		/* We are outside the date boundaries */
+		return 0;
+
+	/* Transform the timestamp of the packet, in a human readable form */
+	localtime(stamp, &currenttime);
+
+	/* check if we match this timestamp, we start by the days... */
+	if (!(info->days_match & days_of_week[currenttime.tm_wday]))
+		/* the day does not match */
+		return 0;
+
+	/*
+	 * Check the time now, both vesions:
+	 * "start < stop" and "start > stop" (midnight cross)
+	 */
+	packet_time =3D currenttime.tm_hour * 60 + currenttime.tm_min;
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
+static struct xt_match xt_time_reg __read_mostly =3D {
+	.name       =3D "time",
+	.match      =3D xt_time_match,
+	.matchsize  =3D sizeof(struct xt_time_info),
+	.checkentry =3D xt_time_check,
+	.me         =3D THIS_MODULE,
+};
+
+static int __init xt_time_init(void)
+{
+	return xt_register_match(&xt_time_reg);
+}
+
+static void __exit xt_time_exit(void)
+{
+	xt_unregister_match(&xt_time_reg);
+}
+
+module_init(xt_time_init);
+module_exit(xt_time_exit);
+MODULE_AUTHOR("Jan Engelhardt <jengelh@gmx.de>");
+MODULE_DESCRIPTION("netfilter time match");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_time");
+MODULE_ALIAS("ip6t_time");
---699020219-689105779-1184138232=:11053--
