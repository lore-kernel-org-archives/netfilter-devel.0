From: "SiegeX" <siegex@atozcomp.com>
Subject: [PATCH] random match ported to 2.6
Date: Sat, 20 Nov 2004 19:13:03 -0800
Message-ID: <003101c4cf78$03558d20$0701a8c0@skynet>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
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

>From looking over past posts dealing with patches, seems that I didnt follo=
w the correct way of doing things with my earlier post so this is to make t=
hings easier for you guys.

This was patched agasint the latest STABLE PoM-ng.  Note that although this=
 patch looks pretty big, the only file that needed altering was ipt_random.=
c.  The rest of the patch is just building the linux-2.6 tree.


diff -uNr random-orig/info random/info
--- random-orig/info 2004-02-19 15:49:32.000000000 -0800
+++ random/info   2004-11-18 10:32:02.000000000 -0800
@@ -1,4 +1,3 @@
 Author: Fabrice MARIE <fabrice@netfilter.org>
 Status: Works For Me.
 Repository: base
-Requires: linux < 2.6.0
diff -uNr random-orig/linux-2.6/include/linux/netfilter_ipv4/ipt_random.h r=
andom/linux-2.6/include/linux/netfilter_ipv4/ipt_random.h
--- random-orig/linux-2.6/include/linux/netfilter_ipv4/ipt_random.h  1969-1=
2-31 16:00:00.000000000 -0800
+++ random/linux-2.6/include/linux/netfilter_ipv4/ipt_random.h 2003-12-18 1=
0:28:45.000000000 -0800
@@ -0,0 +1,11 @@
+#ifndef _IPT_RAND_H
+#define _IPT_RAND_H
+
+#include <linux/param.h>
+#include <linux/types.h>
+
+struct ipt_rand_info {
+  u_int8_t average;
+};
+
+#endif /*_IPT_RAND_H*/
diff -uNr random-orig/linux-2.6/include/linux/netfilter_ipv6/ip6t_random.h =
random/linux-2.6/include/linux/netfilter_ipv6/ip6t_random.h
--- random-orig/linux-2.6/include/linux/netfilter_ipv6/ip6t_random.h 1969-1=
2-31 16:00:00.000000000 -0800
+++ random/linux-2.6/include/linux/netfilter_ipv6/ip6t_random.h   2003-12-2=
0 08:36:09.000000000 -0800
@@ -0,0 +1,11 @@
+#ifndef _IP6T_RAND_H
+#define _IP6T_RAND_H
+
+#include <linux/param.h>
+#include <linux/types.h>
+
+struct ip6t_rand_info {
+  u_int8_t average;
+};
+
+#endif /*_IP6T_RAND_H*/
diff -uNr random-orig/linux-2.6/net/ipv4/netfilter/Kconfig.ladd random/linu=
x-2.6/net/ipv4/netfilter/Kconfig.ladd
--- random-orig/linux-2.6/net/ipv4/netfilter/Kconfig.ladd   1969-12-31 16:0=
0:00.000000000 -0800
+++ random/linux-2.6/net/ipv4/netfilter/Kconfig.ladd  2004-05-06 06:37:39.0=
00000000 -0700
@@ -0,0 +1,10 @@
+config IP_NF_MATCH_RANDOM
+  tristate  'random match support'
+  depends on IP_NF_IPTABLES
+  help
+    This option adds a `random' match,
+    which allow you to match packets randomly
+    following a given probability.
+
+    If you want to compile it as a module, say M here and read
+    Documentation/modules.txt.  If unsure, say `N'.
diff -uNr random-orig/linux-2.6/net/ipv4/netfilter/Makefile.ladd random/lin=
ux-2.6/net/ipv4/netfilter/Makefile.ladd
--- random-orig/linux-2.6/net/ipv4/netfilter/Makefile.ladd  1969-12-31 16:0=
0:00.000000000 -0800
+++ random/linux-2.6/net/ipv4/netfilter/Makefile.ladd 2003-12-18 10:28:45.0=
00000000 -0800
@@ -0,0 +1,3 @@
+obj-$(CONFIG_IP_NF_MATCH_TOS) +=3D ipt_tos.o
+
+obj-$(CONFIG_IP_NF_MATCH_RANDOM) +=3D ipt_random.o
diff -uNr random-orig/linux-2.6/net/ipv4/netfilter/ipt_random.c random/linu=
x-2.6/net/ipv4/netfilter/ipt_random.c
--- random-orig/linux-2.6/net/ipv4/netfilter/ipt_random.c   1969-12-31 16:0=
0:00.000000000 -0800
+++ random/linux-2.6/net/ipv4/netfilter/ipt_random.c  2004-11-18 10:39:22.0=
00000000 -0800
@@ -0,0 +1,92 @@
+/*
+  This is a module which is used for a "random" match support.
+  This file is distributed under the terms of the GNU General Public
+  License (GPL). Copies of the GPL can be obtained from:
+     ftp://prep.ai.mit.edu/pub/gnu/GPL
+
+  2001-10-14 Fabrice MARIE <fabrice@netfilter.org> : initial implementatio=
n.
+*/
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/random.h>
+#include <net/tcp.h>
+#include <linux/spinlock.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_random.h>
+
+MODULE_LICENSE("GPL");
+
+static int
+ipt_rand_match(const struct sk_buff *pskb,
+         const struct net_device *in,
+         const struct net_device *out,
+         const void *matchinfo,
+         int offset,
+         int *hotdrop)
+{
+  /* Parameters from userspace */
+  const struct ipt_rand_info *info =3D matchinfo;
+  u_int8_t random_number;
+
+  /* get 1 random number from the kernel random number generation routine =
*/
+  get_random_bytes((void *)(&random_number), 1);
+
+  /* Do we match ? */
+  if (random_number <=3D info->average)
+     return 1;
+  else
+     return 0;
+}
+
+static int
+ipt_rand_checkentry(const char *tablename,
+        const struct ipt_ip *e,
+        void *matchinfo,
+        unsigned int matchsize,
+        unsigned int hook_mask)
+{
+  /* Parameters from userspace */
+  const struct ipt_rand_info *info =3D matchinfo;
+
+  if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_rand_info))) {
+     printk("ipt_random: matchsize %u !=3D %u\n", matchsize,
+            IPT_ALIGN(sizeof(struct ipt_rand_info)));
+     return 0;
+  }
+
+  /* must be  1 <=3D average % <=3D 99 */
+  /* 1  x 2.55 =3D 2   */
+  /* 99 x 2.55 =3D 252 */
+  if ((info->average < 2) || (info->average > 252)) {
+     printk("ipt_random:  invalid average %u\n", info->average);
+     return 0;
+  }
+
+  return 1;
+}
+
+static struct ipt_match ipt_rand_reg =3D {
+  .name =3D "random",
+  .match =3D ipt_rand_match,
+  .checkentry =3D ipt_rand_checkentry,
+  .me =3D THIS_MODULE };
+
+static int __init init(void)
+{
+  if (ipt_register_match(&ipt_rand_reg))
+     return -EINVAL;
+
+  printk("ipt_random match loaded\n");
+  return 0;
+}
+
+static void __exit fini(void)
+{
+  ipt_unregister_match(&ipt_rand_reg);
+  printk("ipt_random match unloaded\n");
+}
+
+module_init(init);
+module_exit(fini);
diff -uNr random-orig/linux-2.6/net/ipv6/netfilter/Kconfig.ladd random/linu=
x-2.6/net/ipv6/netfilter/Kconfig.ladd
--- random-orig/linux-2.6/net/ipv6/netfilter/Kconfig.ladd   1969-12-31 16:0=
0:00.000000000 -0800
+++ random/linux-2.6/net/ipv6/netfilter/Kconfig.ladd  2004-05-06 06:37:39.0=
00000000 -0700
@@ -0,0 +1,10 @@
+config IP6_NF_MATCH_RANDOM
+  tristate  'Random match support'
+  depends on IP6_NF_IPTABLES
+  help
+    This option adds a `random' match,
+    which allow you to match packets randomly
+    following a given probability.
+
+    If you want to compile it as a module, say M here and read
+    Documentation/modules.txt.  If unsure, say `N'.
diff -uNr random-orig/linux-2.6/net/ipv6/netfilter/Makefile.ladd random/lin=
ux-2.6/net/ipv6/netfilter/Makefile.ladd
--- random-orig/linux-2.6/net/ipv6/netfilter/Makefile.ladd  1969-12-31 16:0=
0:00.000000000 -0800
+++ random/linux-2.6/net/ipv6/netfilter/Makefile.ladd 2003-12-20 08:36:09.0=
00000000 -0800
@@ -0,0 +1,3 @@
+obj-$(CONFIG_IP6_NF_TARGET_LOG) +=3D ip6t_LOG.o
+
+obj-$(CONFIG_IP6_NF_MATCH_RANDOM) +=3D ip6t_random.o
diff -uNr random-orig/linux-2.6/net/ipv6/netfilter/ip6t_random.c random/lin=
ux-2.6/net/ipv6/netfilter/ip6t_random.c
--- random-orig/linux-2.6/net/ipv6/netfilter/ip6t_random.c  1969-12-31 16:0=
0:00.000000000 -0800
+++ random/linux-2.6/net/ipv6/netfilter/ip6t_random.c 2003-12-20 08:36:09.0=
00000000 -0800
@@ -0,0 +1,97 @@
+/*
+  This is a module which is used for a "random" match support.
+  This file is distributed under the terms of the GNU General Public
+  License (GPL). Copies of the GPL can be obtained from:
+     ftp://prep.ai.mit.edu/pub/gnu/GPL
+
+  2001-10-14 Fabrice MARIE <fabrice@netfilter.org> : initial implementatio=
n.
+  2003-04-30 Maciej Soltysiak <solt@dns.toxicfilms.tv> : IPv6 Port
+*/
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/random.h>
+#include <net/tcp.h>
+#include <linux/spinlock.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_random.h>
+
+MODULE_LICENSE("GPL");
+
+static int
+ip6t_rand_match(const struct sk_buff *pskb,
+         const struct net_device *in,
+         const struct net_device *out,
+         const void *matchinfo,
+         int offset,
+         const void *hdr,
+         u_int16_t datalen,
+         int *hotdrop)
+{
+  /* Parameters from userspace */
+  const struct ip6t_rand_info *info =3D matchinfo;
+  u_int8_t random_number;
+
+  /* get 1 random number from the kernel random number generation routine =
*/
+  get_random_bytes((void *)(&random_number), 1);
+
+  /* Do we match ? */
+  if (random_number <=3D info->average)
+     return 1;
+  else
+     return 0;
+}
+
+static int
+ip6t_rand_checkentry(const char *tablename,
+        const struct ip6t_ip6 *e,
+        void *matchinfo,
+        unsigned int matchsize,
+        unsigned int hook_mask)
+{
+  /* Parameters from userspace */
+  const struct ip6t_rand_info *info =3D matchinfo;
+
+  if (matchsize !=3D IP6T_ALIGN(sizeof(struct ip6t_rand_info))) {
+     printk("ip6t_random: matchsize %u !=3D %u\n", matchsize,
+            IP6T_ALIGN(sizeof(struct ip6t_rand_info)));
+     return 0;
+  }
+
+  /* must be  1 <=3D average % <=3D 99 */
+  /* 1  x 2.55 =3D 2   */
+  /* 99 x 2.55 =3D 252 */
+  if ((info->average < 2) || (info->average > 252)) {
+     printk("ip6t_random:  invalid average %u\n", info->average);
+     return 0;
+  }
+
+  return 1;
+}
+
+static struct ip6t_match ip6t_rand_reg =3D {
+  {NULL, NULL},
+  "random",
+  ip6t_rand_match,
+  ip6t_rand_checkentry,
+  NULL,
+  THIS_MODULE };
+
+static int __init init(void)
+{
+  if (ip6t_register_match(&ip6t_rand_reg))
+     return -EINVAL;
+
+  printk("ip6t_random match loaded\n");
+  return 0;
+}
+
+static void __exit fini(void)
+{
+  ip6t_unregister_match(&ip6t_rand_reg);
+  printk("ip6t_random match unloaded\n");
+}
+
+module_init(init);
+module_exit(fini);
