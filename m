From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] new iptables modules (iprange, CLASSIFY, SAME, NETMAP)
Date: Sun, 24 Aug 2003 16:38:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030824143828.GE10987@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ns7jmDPpOpCD+GE/"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Ns7jmDPpOpCD+GE/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

The following patch against 2.6.0-test4 adds four more iptables modules.
They are adding the following functionality
- iprange: matching against an arbitrary contiguous range of ip addresses
- CLASSIFY: setting skb->priority from iptables (so you can skip tc filter)
- NETMAP: SNAT a whole network 1:1 to another network
- SAME: tries to keep the assigned ip per client the same within an SNAT
  pool

Please apply, thanks!

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linuxppc25-030824-unclean-unexp-mir=
ror-cosmetic/include/linux/netfilter_ipv4/ipt_CLASSIFY.h linuxppc25-030824-=
unclean-unexperimental-mirror-cosmetic/include/linux/netfilter_ipv4/ipt_CLA=
SSIFY.h
--- linuxppc25-030824-unclean-unexp-mirror-cosmetic/include/linux/netfilter=
_ipv4/ipt_CLASSIFY.h	1970-01-01 01:00:00.000000000 +0100
+++ linuxppc25-030824-unclean-unexperimental-mirror-cosmetic/include/linux/=
netfilter_ipv4/ipt_CLASSIFY.h	2003-08-24 16:14:32.000000000 +0200
@@ -0,0 +1,8 @@
+#ifndef _IPT_CLASSIFY_H
+#define _IPT_CLASSIFY_H
+
+struct ipt_classify_target_info {
+	u_int32_t priority;
+};
+
+#endif /*_IPT_CLASSIFY_H */
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linuxppc25-030824-unclean-unexp-mir=
ror-cosmetic/include/linux/netfilter_ipv4/ipt_SAME.h linuxppc25-030824-uncl=
ean-unexperimental-mirror-cosmetic/include/linux/netfilter_ipv4/ipt_SAME.h
--- linuxppc25-030824-unclean-unexp-mirror-cosmetic/include/linux/netfilter=
_ipv4/ipt_SAME.h	1970-01-01 01:00:00.000000000 +0100
+++ linuxppc25-030824-unclean-unexperimental-mirror-cosmetic/include/linux/=
netfilter_ipv4/ipt_SAME.h	2003-08-24 16:20:40.000000000 +0200
@@ -0,0 +1,19 @@
+#ifndef _IPT_SAME_H
+#define _IPT_SAME_H
+
+#define IPT_SAME_MAX_RANGE	10
+
+#define IPT_SAME_NODST		0x01
+
+struct ipt_same_info
+{
+	unsigned char info;
+	u_int32_t rangesize;
+	u_int32_t ipnum;
+	u_int32_t *iparray;
+
+	/* hangs off end. */
+	struct ip_nat_range range[IPT_SAME_MAX_RANGE];
+};
+
+#endif /*_IPT_SAME_H*/
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linuxppc25-030824-unclean-unexp-mir=
ror-cosmetic/include/linux/netfilter_ipv4/ipt_iprange.h linuxppc25-030824-u=
nclean-unexperimental-mirror-cosmetic/include/linux/netfilter_ipv4/ipt_ipra=
nge.h
--- linuxppc25-030824-unclean-unexp-mirror-cosmetic/include/linux/netfilter=
_ipv4/ipt_iprange.h	1970-01-01 01:00:00.000000000 +0100
+++ linuxppc25-030824-unclean-unexperimental-mirror-cosmetic/include/linux/=
netfilter_ipv4/ipt_iprange.h	2003-08-24 16:14:32.000000000 +0200
@@ -0,0 +1,23 @@
+#ifndef _IPT_IPRANGE_H
+#define _IPT_IPRANGE_H
+
+#define IPRANGE_SRC		0x01	/* Match source IP address */
+#define IPRANGE_DST		0x02	/* Match destination IP address */
+#define IPRANGE_SRC_INV		0x10	/* Negate the condition */
+#define IPRANGE_DST_INV		0x20	/* Negate the condition */
+
+struct ipt_iprange {
+	/* Inclusive: network order. */
+	u_int32_t min_ip, max_ip;
+};
+
+struct ipt_iprange_info
+{
+	struct ipt_iprange src;
+	struct ipt_iprange dst;
+
+	/* Flags from above */
+	u_int8_t flags;
+};
+
+#endif /* _IPT_IPRANGE_H */
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linuxppc25-030824-unclean-unexp-mir=
ror-cosmetic/net/ipv4/netfilter/Kconfig linuxppc25-030824-unclean-unexperim=
ental-mirror-cosmetic/net/ipv4/netfilter/Kconfig
--- linuxppc25-030824-unclean-unexp-mirror-cosmetic/net/ipv4/netfilter/Kcon=
fig	2003-08-24 16:40:11.000000000 +0200
+++ linuxppc25-030824-unclean-unexperimental-mirror-cosmetic/net/ipv4/netfi=
lter/Kconfig	2003-08-24 16:14:32.000000000 +0200
@@ -105,6 +105,16 @@
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
=20
+config IP_NF_MATCH_IPRANGE
+	tristate "IP range match support"
+	depends on IP_NF_IPTABLES
+	help
+	  This option makes possible to match IP addresses against IP address
+	  ranges.
+
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+
 config IP_NF_MATCH_MAC
 	tristate "MAC address match support"
 	depends on IP_NF_IPTABLES
@@ -354,6 +364,28 @@
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
=20
+config IP_NF_TARGET_NETMAP
+	tristate "NETMAP target support"
+	depends on IP_NF_NAT
+	help
+	  NETMAP is an implementation of static 1:1 NAT mapping of network
+	  addresses. It maps the network address part, while keeping the host
+	  address part intact. It is similar to Fast NAT, except that
+	  Netfilter's connection tracking doesn't work well with Fast NAT.
+
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+
+config IP_NF_TARGET_SAME
+	tristate "SAME target support"
+	depends on IP_NF_NAT
+	help
+	  This option adds a `SAME' target, which works like the standard SNAT
+	  target, but attempts to give clients the same IP for all connections.
+
+	  If you want to compile it as a module, say M here and read
+	  Documentation/modules.txt.  If unsure, say `N'.
+
 config IP_NF_NAT_LOCAL
 	bool "NAT of local connections (READ HELP)"
 	depends on IP_NF_NAT
@@ -473,6 +505,19 @@
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
=20
+config IP_NF_TARGET_CLASSIFY
+	tristate "CLASSIFY target support"
+	depends on IP_NF_MANGLE
+	help
+	  This option adds a `CLASSIFY' target, which enables the user to set
+	  the priority of a packet. Some qdiscs can use this value for
+	  classification, among these are:
+
+  	  atm, cbq, dsmark, pfifo_fast, htb, prio
+
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+
 config IP_NF_TARGET_LOG
 	tristate "LOG target support"
 	depends on IP_NF_IPTABLES
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linuxppc25-030824-unclean-unexp-mir=
ror-cosmetic/net/ipv4/netfilter/Makefile linuxppc25-030824-unclean-unexperi=
mental-mirror-cosmetic/net/ipv4/netfilter/Makefile
--- linuxppc25-030824-unclean-unexp-mirror-cosmetic/net/ipv4/netfilter/Make=
file	2003-08-24 16:40:08.000000000 +0200
+++ linuxppc25-030824-unclean-unexperimental-mirror-cosmetic/net/ipv4/netfi=
lter/Makefile	2003-08-24 16:14:32.000000000 +0200
@@ -44,6 +44,7 @@
 obj-$(CONFIG_IP_NF_MATCH_LIMIT) +=3D ipt_limit.o
 obj-$(CONFIG_IP_NF_MATCH_MARK) +=3D ipt_mark.o
 obj-$(CONFIG_IP_NF_MATCH_MAC) +=3D ipt_mac.o
+obj-$(CONFIG_IP_NF_MATCH_IPRANGE) +=3D ipt_iprange.o
=20
 obj-$(CONFIG_IP_NF_MATCH_PKTTYPE) +=3D ipt_pkttype.o
 obj-$(CONFIG_IP_NF_MATCH_MULTIPORT) +=3D ipt_multiport.o
@@ -73,6 +74,9 @@
 obj-$(CONFIG_IP_NF_TARGET_MARK) +=3D ipt_MARK.o
 obj-$(CONFIG_IP_NF_TARGET_MASQUERADE) +=3D ipt_MASQUERADE.o
 obj-$(CONFIG_IP_NF_TARGET_REDIRECT) +=3D ipt_REDIRECT.o
+obj-$(CONFIG_IP_NF_TARGET_NETMAP) +=3D ipt_NETMAP.o
+obj-$(CONFIG_IP_NF_TARGET_SAME) +=3D ipt_SAME.o
+obj-$(CONFIG_IP_NF_TARGET_CLASSIFY) +=3D ipt_CLASSIFY.o
 obj-$(CONFIG_IP_NF_NAT_SNMP_BASIC) +=3D ip_nat_snmp_basic.o
 obj-$(CONFIG_IP_NF_TARGET_LOG) +=3D ipt_LOG.o
 obj-$(CONFIG_IP_NF_TARGET_ULOG) +=3D ipt_ULOG.o
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linuxppc25-030824-unclean-unexp-mir=
ror-cosmetic/net/ipv4/netfilter/ipt_CLASSIFY.c linuxppc25-030824-unclean-un=
experimental-mirror-cosmetic/net/ipv4/netfilter/ipt_CLASSIFY.c
--- linuxppc25-030824-unclean-unexp-mirror-cosmetic/net/ipv4/netfilter/ipt_=
CLASSIFY.c	1970-01-01 01:00:00.000000000 +0100
+++ linuxppc25-030824-unclean-unexperimental-mirror-cosmetic/net/ipv4/netfi=
lter/ipt_CLASSIFY.c	2003-08-24 16:29:39.000000000 +0200
@@ -0,0 +1,86 @@
+/*
+ * This is a module which is used for setting the skb->priority field
+ * of an skb for qdisc classification.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <net/checksum.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_CLASSIFY.h>
+
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("iptables qdisc classification target module");
+
+static unsigned int
+target(struct sk_buff **pskb,
+       const struct net_device *in,
+       const struct net_device *out,
+       unsigned int hooknum,
+       const void *targinfo,
+       void *userinfo)
+{
+	const struct ipt_classify_target_info *clinfo =3D targinfo;
+
+	if((*pskb)->priority !=3D clinfo->priority) {
+		(*pskb)->priority =3D clinfo->priority;
+		(*pskb)->nfcache |=3D NFC_ALTERED;
+	}
+
+	return IPT_CONTINUE;
+}
+
+static int
+checkentry(const char *tablename,
+           const struct ipt_entry *e,
+           void *targinfo,
+           unsigned int targinfosize,
+           unsigned int hook_mask)
+{
+	if (targinfosize !=3D IPT_ALIGN(sizeof(struct ipt_classify_target_info))){
+		printk(KERN_ERR "CLASSIFY: invalid size (%u !=3D %u).\n",
+		       targinfosize,
+		       IPT_ALIGN(sizeof(struct ipt_classify_target_info)));
+		return 0;
+	}
+=09
+	if (hook_mask & ~(1 << NF_IP_POST_ROUTING)) {
+		printk(KERN_ERR "CLASSIFY: only valid in POST_ROUTING.\n");
+		return 0;
+	}
+
+	if (strcmp(tablename, "mangle") !=3D 0) {
+		printk(KERN_WARNING "CLASSIFY: can only be called from "
+		                    "\"mangle\" table, not \"%s\".\n",
+		                    tablename);
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct ipt_target ipt_classify_reg =3D {=20
+	.name 		=3D "CLASSIFY",=20
+	.target 	=3D target,
+	.checkentry	=3D checkentry,
+	.me 		=3D THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	if (ipt_register_target(&ipt_classify_reg))
+		return -EINVAL;
+
+	return 0;
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_target(&ipt_classify_reg);
+}
+
+module_init(init);
+module_exit(fini);
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linuxppc25-030824-unclean-unexp-mir=
ror-cosmetic/net/ipv4/netfilter/ipt_NETMAP.c linuxppc25-030824-unclean-unex=
perimental-mirror-cosmetic/net/ipv4/netfilter/ipt_NETMAP.c
--- linuxppc25-030824-unclean-unexp-mirror-cosmetic/net/ipv4/netfilter/ipt_=
NETMAP.c	1970-01-01 01:00:00.000000000 +0100
+++ linuxppc25-030824-unclean-unexperimental-mirror-cosmetic/net/ipv4/netfi=
lter/ipt_NETMAP.c	2003-08-24 16:31:59.000000000 +0200
@@ -0,0 +1,112 @@
+/* NETMAP - static NAT mapping of IP network addresses (1:1).
+   The mapping can be applied to source (POSTROUTING),
+   destination (PREROUTING), or both (with separate rules).
+
+   Author: Svenning Soerensen <svenning@post5.tele.dk>
+*/
+
+#include <linux/config.h>
+#include <linux/ip.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv4/ip_nat_rule.h>
+
+#define MODULENAME "NETMAP"
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Svenning Soerensen <svenning@post5.tele.dk>");
+MODULE_DESCRIPTION("iptables 1:1 NAT mapping of IP networks target");
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+static int
+check(const char *tablename,
+      const struct ipt_entry *e,
+      void *targinfo,
+      unsigned int targinfosize,
+      unsigned int hook_mask)
+{
+	const struct ip_nat_multi_range *mr =3D targinfo;
+
+	if (strcmp(tablename, "nat") !=3D 0) {
+		DEBUGP(MODULENAME":check: bad table `%s'.\n", tablename);
+		return 0;
+	}
+	if (targinfosize !=3D IPT_ALIGN(sizeof(*mr))) {
+		DEBUGP(MODULENAME":check: size %u.\n", targinfosize);
+		return 0;
+	}
+	if (hook_mask & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_POST_ROUTING))) {
+		DEBUGP(MODULENAME":check: bad hooks %x.\n", hook_mask);
+		return 0;
+	}
+	if (!(mr->range[0].flags & IP_NAT_RANGE_MAP_IPS)) {
+		DEBUGP(MODULENAME":check: bad MAP_IPS.\n");
+		return 0;
+	}
+	if (mr->rangesize !=3D 1) {
+		DEBUGP(MODULENAME":check: bad rangesize %u.\n", mr->rangesize);
+		return 0;
+	}
+	return 1;
+}
+
+static unsigned int
+target(struct sk_buff **pskb,
+       const struct net_device *in,
+       const struct net_device *out,
+       unsigned int hooknum,
+       const void *targinfo,
+       void *userinfo)
+{
+	struct ip_conntrack *ct;
+	enum ip_conntrack_info ctinfo;
+	u_int32_t new_ip, netmask;
+	const struct ip_nat_multi_range *mr =3D targinfo;
+	struct ip_nat_multi_range newrange;
+
+	IP_NF_ASSERT(hooknum =3D=3D NF_IP_PRE_ROUTING
+		     || hooknum =3D=3D NF_IP_POST_ROUTING);
+	ct =3D ip_conntrack_get(*pskb, &ctinfo);
+
+	netmask =3D ~(mr->range[0].min_ip ^ mr->range[0].max_ip);
+
+	if (hooknum =3D=3D NF_IP_PRE_ROUTING)
+		new_ip =3D (*pskb)->nh.iph->daddr & ~netmask;
+	else
+		new_ip =3D (*pskb)->nh.iph->saddr & ~netmask;
+	new_ip |=3D mr->range[0].min_ip & netmask;
+
+	newrange =3D ((struct ip_nat_multi_range)
+	{ 1, { { mr->range[0].flags | IP_NAT_RANGE_MAP_IPS,
+		 new_ip, new_ip,
+		 mr->range[0].min, mr->range[0].max } } });
+
+	/* Hand modified range to generic setup. */
+	return ip_nat_setup_info(ct, &newrange, hooknum);
+}
+
+static struct ipt_target target_module =3D {=20
+	.name 		=3D MODULENAME,
+	.target 	=3D target,=20
+	.checkentry 	=3D check,
+    	.me 		=3D THIS_MODULE=20
+};
+
+static int __init init(void)
+{
+	return ipt_register_target(&target_module);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_target(&target_module);
+}
+
+module_init(init);
+module_exit(fini);
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linuxppc25-030824-unclean-unexp-mir=
ror-cosmetic/net/ipv4/netfilter/ipt_SAME.c linuxppc25-030824-unclean-unexpe=
rimental-mirror-cosmetic/net/ipv4/netfilter/ipt_SAME.c
--- linuxppc25-030824-unclean-unexp-mirror-cosmetic/net/ipv4/netfilter/ipt_=
SAME.c	1970-01-01 01:00:00.000000000 +0100
+++ linuxppc25-030824-unclean-unexperimental-mirror-cosmetic/net/ipv4/netfi=
lter/ipt_SAME.c	2003-08-24 16:24:09.000000000 +0200
@@ -0,0 +1,206 @@
+/* Same.  Just like SNAT, only try to make the connections
+ * 	  between client A and server B always have the same source ip.
+ *
+ * (C) 2000 Rusty Russell.  GPL.
+ *
+ * 010320 Martin Josefsson <gandalf@wlug.westbo.se>
+ * 	* copied ipt_BALANCE.c to ipt_SAME.c and changed a few things.
+ * 010728 Martin Josefsson <gandalf@wlug.westbo.se>
+ * 	* added --nodst to not include destination-ip in new source
+ * 	  calculations.
+ *	* added some more sanity-checks.
+ * 010729 Martin Josefsson <gandalf@wlug.westbo.se>
+ * 	* fixed a buggy if-statement in same_check(), should have
+ * 	  used ntohl() but didn't.
+ * 	* added support for multiple ranges. IPT_SAME_MAX_RANGE is
+ * 	  defined in linux/include/linux/netfilter_ipv4/ipt_SAME.h
+ * 	  and is currently set to 10.
+ * 	* added support for 1-address range, nice to have now that
+ * 	  we have multiple ranges.
+ */
+#include <linux/types.h>
+#include <linux/ip.h>
+#include <linux/timer.h>
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/netdevice.h>
+#include <linux/if.h>
+#include <linux/inetdevice.h>
+#include <net/protocol.h>
+#include <net/checksum.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv4/ip_nat_rule.h>
+#include <linux/netfilter_ipv4/ipt_SAME.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Martin Josefsson <gandalf@wlug.westbo.se>");
+MODULE_DESCRIPTION("iptables special SNAT module for consistent sourceip");
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+static int
+same_check(const char *tablename,
+	      const struct ipt_entry *e,
+	      void *targinfo,
+	      unsigned int targinfosize,
+	      unsigned int hook_mask)
+{
+	unsigned int count, countess, rangeip, index =3D 0;
+	struct ipt_same_info *mr =3D targinfo;
+
+	mr->ipnum =3D 0;
+
+	if (strcmp(tablename, "nat") !=3D 0) {
+		DEBUGP("same_check: bad table `%s'.\n", tablename);
+		return 0;
+	}
+	if (targinfosize !=3D IPT_ALIGN(sizeof(*mr))) {
+		DEBUGP("same_check: size %u.\n", targinfosize);
+		return 0;
+	}
+	if (hook_mask & ~(1 << NF_IP_PRE_ROUTING | 1 << NF_IP_POST_ROUTING)) {
+		DEBUGP("same_check: bad hooks %x.\n", hook_mask);
+		return 0;
+	}
+	if (mr->rangesize < 1) {
+		DEBUGP("same_check: need at least one dest range.\n");
+		return 0;
+	}
+	if (mr->rangesize > IPT_SAME_MAX_RANGE) {
+		DEBUGP("same_check: too many ranges specified, maximum "
+				"is %u ranges\n",
+				IPT_SAME_MAX_RANGE);
+		return 0;
+	}
+	for (count =3D 0; count < mr->rangesize; count++) {
+		if (ntohl(mr->range[count].min_ip) >
+				ntohl(mr->range[count].max_ip)) {
+			DEBUGP("same_check: min_ip is larger than max_ip in "
+				"range `%u.%u.%u.%u-%u.%u.%u.%u'.\n",
+				NIPQUAD(mr->range[count].min_ip),
+				NIPQUAD(mr->range[count].max_ip));
+			return 0;
+		}
+		if (!(mr->range[count].flags & IP_NAT_RANGE_MAP_IPS)) {
+			DEBUGP("same_check: bad MAP_IPS.\n");
+			return 0;
+		}
+		rangeip =3D (ntohl(mr->range[count].max_ip) -=20
+					ntohl(mr->range[count].min_ip) + 1);
+		mr->ipnum +=3D rangeip;
+	=09
+		DEBUGP("same_check: range %u, ipnum =3D %u\n", count, rangeip);
+	}
+	DEBUGP("same_check: total ipaddresses =3D %u\n", mr->ipnum);
+=09
+	mr->iparray =3D kmalloc((sizeof(u_int32_t) * mr->ipnum), GFP_KERNEL);
+	if (!mr->iparray) {
+		DEBUGP("same_check: Couldn't allocate %u bytes "
+			"for %u ipaddresses!\n",=20
+			(sizeof(u_int32_t) * mr->ipnum), mr->ipnum);
+		return 0;
+	}
+	DEBUGP("same_check: Allocated %u bytes for %u ipaddresses.\n",
+			(sizeof(u_int32_t) * mr->ipnum), mr->ipnum);
+=09
+	for (count =3D 0; count < mr->rangesize; count++) {
+		for (countess =3D ntohl(mr->range[count].min_ip);
+				countess <=3D ntohl(mr->range[count].max_ip);
+					countess++) {
+			mr->iparray[index] =3D countess;
+			DEBUGP("same_check: Added ipaddress `%u.%u.%u.%u' "
+				"in index %u.\n",
+				HIPQUAD(countess), index);
+			index++;
+		}
+	}
+	return 1;
+}
+
+static void=20
+same_destroy(void *targinfo,
+		unsigned int targinfosize)
+{
+	struct ipt_same_info *mr =3D targinfo;
+
+	kfree(mr->iparray);
+=09
+	DEBUGP("same_destroy: Deallocated %u bytes for %u ipaddresses.\n",
+			(sizeof(u_int32_t) * mr->ipnum), mr->ipnum);
+}
+
+static unsigned int
+same_target(struct sk_buff **pskb,
+		const struct net_device *in,
+		const struct net_device *out,
+		unsigned int hooknum,
+		const void *targinfo,
+		void *userinfo)
+{
+	struct ip_conntrack *ct;
+	enum ip_conntrack_info ctinfo;
+	u_int32_t tmpip, aindex, new_ip;
+	const struct ipt_same_info *mr =3D targinfo;
+	struct ip_nat_multi_range newrange;
+	const struct ip_conntrack_tuple *t;
+
+	IP_NF_ASSERT(hooknum =3D=3D NF_IP_PRE_ROUTING ||
+			hooknum =3D=3D NF_IP_POST_ROUTING);
+	ct =3D ip_conntrack_get(*pskb, &ctinfo);
+
+	t =3D &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+
+	/* Base new source on real src ip and optionally dst ip,
+	   giving some hope for consistency across reboots.
+	   Here we calculate the index in mr->iparray which
+	   holds the ipaddress we should use */
+=09
+	tmpip =3D ntohl(t->src.ip);
+
+	if (!(mr->info & IPT_SAME_NODST))
+		tmpip +=3D ntohl(t->dst.ip);
+=09
+	aindex =3D tmpip % mr->ipnum;
+	=09
+	new_ip =3D htonl(mr->iparray[aindex]);
+
+	DEBUGP("ipt_SAME: src=3D%u.%u.%u.%u dst=3D%u.%u.%u.%u, "
+			"new src=3D%u.%u.%u.%u\n",
+			NIPQUAD(t->src.ip), NIPQUAD(t->dst.ip),
+			NIPQUAD(new_ip));
+
+	/* Transfer from original range. */
+	newrange =3D ((struct ip_nat_multi_range)
+		{ 1, { { mr->range[0].flags | IP_NAT_RANGE_MAP_IPS,
+			 new_ip, new_ip,
+			 mr->range[0].min, mr->range[0].max } } });
+
+	/* Hand modified range to generic setup. */
+	return ip_nat_setup_info(ct, &newrange, hooknum);
+}
+
+static struct ipt_target same_reg =3D {=20
+	.name		=3D "SAME",
+	.target		=3D same_target,
+	.checkentry	=3D same_check,
+	.destroy	=3D same_destroy,
+	.me		=3D THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	return ipt_register_target(&same_reg);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_target(&same_reg);
+}
+
+module_init(init);
+module_exit(fini);
+
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linuxppc25-030824-unclean-unexp-mir=
ror-cosmetic/net/ipv4/netfilter/ipt_iprange.c linuxppc25-030824-unclean-une=
xperimental-mirror-cosmetic/net/ipv4/netfilter/ipt_iprange.c
--- linuxppc25-030824-unclean-unexp-mirror-cosmetic/net/ipv4/netfilter/ipt_=
iprange.c	1970-01-01 01:00:00.000000000 +0100
+++ linuxppc25-030824-unclean-unexperimental-mirror-cosmetic/net/ipv4/netfi=
lter/ipt_iprange.c	2003-08-24 16:19:02.000000000 +0200
@@ -0,0 +1,97 @@
+/*
+ * iptables module to match IP address ranges
+ *   (c) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ *
+ * Released under the terms of GNU GPLv2.
+ *
+ */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_iprange.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_DESCRIPTION("iptables arbitrary IP range match module");
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset, int *hotdrop)
+{
+	const struct ipt_iprange_info *info =3D matchinfo;
+	const struct iphdr *iph =3D skb->nh.iph;
+
+	if (info->flags & IPRANGE_SRC) {
+		if (((ntohl(iph->saddr) < ntohl(info->src.min_ip))
+			  || (ntohl(iph->saddr) > ntohl(info->src.max_ip)))
+			 ^ !!(info->flags & IPRANGE_SRC_INV)) {
+			DEBUGP("src IP %u.%u.%u.%u NOT in range %s"
+			       "%u.%u.%u.%u-%u.%u.%u.%u\n",
+				NIPQUAD(iph->saddr),
+			        info->flags & IPRANGE_SRC_INV ? "(INV) " : "",
+				NIPQUAD(info->src.min_ip),
+				NIPQUAD(info->src.max_ip));
+			return 0;
+		}
+	}
+	if (info->flags & IPRANGE_DST) {
+		if (((ntohl(iph->daddr) < ntohl(info->dst.min_ip))
+			  || (ntohl(iph->daddr) > ntohl(info->dst.max_ip)))
+			 ^ !!(info->flags & IPRANGE_DST_INV)) {
+			DEBUGP("dst IP %u.%u.%u.%u NOT in range %s"
+			       "%u.%u.%u.%u-%u.%u.%u.%u\n",
+				NIPQUAD(iph->daddr),
+			        info->flags & IPRANGE_DST_INV ? "(INV) " : "",
+				NIPQUAD(info->dst.min_ip),
+				NIPQUAD(info->dst.max_ip));
+			return 0;
+		}
+	}
+	return 1;
+}
+
+static int check(const char *tablename,
+		 const struct ipt_ip *ip,
+		 void *matchinfo,
+		 unsigned int matchsize,
+		 unsigned int hook_mask)
+{
+	/* verify size */
+	if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_iprange_info)))
+		return 0;
+
+	return 1;
+}
+
+static struct ipt_match iprange_match =3D=20
+{=20
+	.list =3D { NULL, NULL },=20
+	.name =3D "iprange",=20
+	.match =3D &match,=20
+	.checkentry =3D &check,=20
+	.destroy =3D NULL,=20
+	.me =3D THIS_MODULE
+};
+
+static int __init init(void)
+{
+	return ipt_register_match(&iprange_match);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&iprange_match);
+}
+
+module_init(init);
+module_exit(fini);

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Ns7jmDPpOpCD+GE/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/SM3kXaXGVTD0i/8RAp9LAJ0f7vUPBJMV1TShiGUx2QORxyz72gCgrt73
/0ONPLiXXgwAAN+MLxzgF7M=
=cZ8M
-----END PGP SIGNATURE-----

--Ns7jmDPpOpCD+GE/--
