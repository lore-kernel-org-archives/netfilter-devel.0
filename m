From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: [PATCH] ROUTE target for IPv6
Date: Mon, 01 Sep 2003 11:25:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1062408326.520.18.camel@descartes>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-tKG6MVvA9kCuQhg4gqEg"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-tKG6MVvA9kCuQhg4gqEg
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi all,

Here is a port of the ROUTE target for IPv6. It is based on the
IPv4 version of the ROUTE target. It has the same behaviour although 
not all options are currently implemented.

Current options are
  --oif ifname   Route the packet through `ifname' network interface
  --gw  ip       Route the packet via this gateway
  --continue     Route the packet and continue traversing the rules.

This target is not working as a module since rt6_lookup is not exported.

The patch is against current CVS.

Cedric


--=-tKG6MVvA9kCuQhg4gqEg
Content-Disposition: attachment; filename=ROUTE.cvs.patch.ipv6
Content-Type: text/x-patch; name=ROUTE.cvs.patch.ipv6; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by info.ucl.ac.be id h819Mp9H028391

diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch.ipv6 netfilter/p=
atch-o-matic/extra/ROUTE.patch.ipv6
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch.ipv6	1970-01-01 01:00:=
00.000000000 +0100
+++ netfilter/patch-o-matic/extra/ROUTE.patch.ipv6	2003-08-28 11:35:04.00=
0000000 +0200
@@ -0,0 +1,319 @@
+diff -Nru linux.orig/include/linux/netfilter_ipv6/ip6t_ROUTE.h linux/inc=
lude/linux/netfilter_ipv6/ip6t_ROUTE.h
+--- linux.orig/include/linux/netfilter_ipv6/ip6t_ROUTE.h	1970-01-01 01:0=
0:00.000000000 +0100
++++ linux/include/linux/netfilter_ipv6/ip6t_ROUTE.h	2003-08-05 16:41:43.=
000000000 +0200
+@@ -0,0 +1,22 @@
++/* Header file for iptables ip6t_ROUTE target
++ *
++ * (C) 2003 by C=E9dric de Launois <delaunois@info.ucl.ac.be>
++ *
++ * This software is distributed under GNU GPL v2, 1991
++ */
++#ifndef _IPT_ROUTE_H_target
++#define _IPT_ROUTE_H_target
++
++#define IP6T_ROUTE_IFNAMSIZ 16
++
++struct ip6t_route_target_info {
++	char      oif[IP6T_ROUTE_IFNAMSIZ];     /* Output Interface Name */
++	char      iif[IP6T_ROUTE_IFNAMSIZ];     /* Input Interface Name  */
++	u_int32_t gw[4];                        /* IPv6 address of gateway */
++	u_int8_t  flags;
++};
++
++/* Values for "flags" field */
++#define IP6T_ROUTE_CONTINUE        0x01
++
++#endif /*_IP6T_ROUTE_H_target*/
+diff -Nru linux.orig/net/ipv6/netfilter/ip6t_ROUTE.c linux/net/ipv6/netf=
ilter/ip6t_ROUTE.c
+--- linux.orig/net/ipv6/netfilter/ip6t_ROUTE.c	1970-01-01 01:00:00.00000=
0000 +0100
++++ linux/net/ipv6/netfilter/ip6t_ROUTE.c	2003-08-28 11:32:49.000000000 =
+0200
+@@ -0,0 +1,289 @@
++/*
++ * This implements the ROUTE v6 target, which enables you to setup unus=
ual
++ * routes not supported by the standard kernel routing table.
++ *
++ * Copyright (C) 2003 Cedric de Launois <delaunois@info.ucl.ac.be>
++ *
++ * v 1.0 2003/08/05
++ *
++ * This software is distributed under GNU GPL v2, 1991
++ */
++
++#include <linux/module.h>
++#include <linux/skbuff.h>
++#include <linux/ipv6.h>
++#include <linux/netfilter_ipv6/ip6_tables.h>
++#include <linux/netfilter_ipv6/ip6t_ROUTE.h>
++#include <linux/netdevice.h>
++#include <net/ipv6.h>
++#include <net/ndisc.h>
++#include <net/ip6_route.h>
++#include <linux/icmpv6.h>
++
++#if 1
++#define DEBUGP printk
++#else
++#define DEBUGP(format, args...)
++#endif
++
++#define NIP6(addr) \
++	ntohs((addr).s6_addr16[0]), \
++	ntohs((addr).s6_addr16[1]), \
++	ntohs((addr).s6_addr16[2]), \
++	ntohs((addr).s6_addr16[3]), \
++	ntohs((addr).s6_addr16[4]), \
++	ntohs((addr).s6_addr16[5]), \
++	ntohs((addr).s6_addr16[6]), \
++	ntohs((addr).s6_addr16[7])
++
++/* Route the packet according to the routing keys specified in
++ * route_info. Keys are :
++ *  - ifindex :=20
++ *      0 if no oif preferred,=20
++ *      otherwise set to the index of the desired oif
++ *  - route_info->gw :
++ *      0 if no gateway specified,
++ *      otherwise set to the next host to which the pkt must be routed
++ * If success, skb->dev is the output device to which the packet must=20
++ * be sent and skb->dst is not NULL
++ *
++ * RETURN:  1 if the packet was succesfully routed to the=20
++ *            destination desired
++ *          0 if the kernel routing table could not route the packet
++ *            according to the keys specified
++ */
++static int=20
++route6(struct sk_buff *skb,
++       unsigned int ifindex,
++       const struct ip6t_route_target_info *route_info)
++{
++	struct rt6_info *rt =3D NULL;
++	struct ipv6hdr *ipv6h =3D skb->nh.ipv6h;
++	struct in6_addr *gw =3D (struct in6_addr*)&route_info->gw;
++
++	DEBUGP("ip6t_ROUTE: called with: ");
++	DEBUGP("DST=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(ipv6h->d=
addr));
++	DEBUGP("GATEWAY=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(*gw)=
);
++	DEBUGP("OUT=3D%s\n", route_info->oif);
++=09
++	if (ipv6_addr_any(gw))
++		rt =3D rt6_lookup(&ipv6h->daddr, &ipv6h->saddr, ifindex, 1);
++	else
++		rt =3D rt6_lookup(gw, &ipv6h->saddr, ifindex, 1);
++
++	if (!rt)
++		goto no_route;
++
++	DEBUGP("ip6t_ROUTE: routing gives: ");
++	DEBUGP("DST=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(rt->rt6i=
_dst.addr));
++	DEBUGP("GATEWAY=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(rt->=
rt6i_gateway));
++	DEBUGP("OUT=3D%s\n", rt->rt6i_dev->name);
++
++	if (ifindex && rt->rt6i_dev->ifindex!=3Difindex)
++		goto wrong_route;
++=09
++	if (!rt->rt6i_nexthop) {
++		DEBUGP("ip6t_ROUTE: discovering neighbour\n");
++		rt->rt6i_nexthop =3D ndisc_get_neigh(rt->rt6i_dev, &rt->rt6i_dst.addr=
);
++	}
++
++	/* Drop old route. */
++	dst_release(skb->dst);
++	skb->dst =3D &rt->u.dst;
++	skb->dev =3D rt->rt6i_dev;
++	return 1;
++
++ wrong_route:
++	dst_release(&rt->u.dst);
++ no_route:
++	if (!net_ratelimit())
++		return 0;
++
++	printk("ip6t_ROUTE: no explicit route found ");
++	if (ifindex)
++		printk("via interface %s ", route_info->oif);
++	if (!ipv6_addr_any(gw))
++		printk("via gateway %04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x", NIP6(*g=
w));
++	printk("\n");
++	return 0;
++}
++
++
++/* Stolen from ip6_output_finish
++ * PRE : skb->dev is set to the device we are leaving by
++ *       skb->dst is not NULL
++ * POST: the packet is sent with the link layer header pushed
++ *       the packet is destroyed
++ */
++static void ip_direct_send(struct sk_buff *skb)
++{
++	struct dst_entry *dst =3D skb->dst;
++	struct hh_cache *hh =3D dst->hh;
++
++	if (hh) {
++		read_lock_bh(&hh->hh_lock);
++		memcpy(skb->data - 16, hh->hh_data, 16);
++		read_unlock_bh(&hh->hh_lock);
++		skb_push(skb, hh->hh_len);
++		hh->hh_output(skb);
++	} else if (dst->neighbour)
++		dst->neighbour->output(skb);
++	else {
++		if (net_ratelimit())
++			DEBUGP(KERN_DEBUG "ip6t_ROUTE: no hdr & no neighbour cache!\n");
++		kfree_skb(skb);
++	}
++}
++
++
++static unsigned int=20
++route6_oif(const struct ip6t_route_target_info *route_info,
++	   struct sk_buff *skb)=20
++{
++	unsigned int ifindex =3D 0;
++	struct net_device *dev_out =3D NULL;
++
++	/* The user set the interface name to use.
++	 * Getting the current interface index.
++	 */
++	if ((dev_out =3D dev_get_by_name(route_info->oif))) {
++		ifindex =3D dev_out->ifindex;
++	} else {
++		/* Unknown interface name : packet dropped */
++		if (net_ratelimit())=20
++			DEBUGP("ip6t_ROUTE: oif interface %s not found\n", route_info->oif);
++
++		if (route_info->flags & IP6T_ROUTE_CONTINUE)
++			return IP6T_CONTINUE;
++		else
++			return NF_DROP;
++	}
++
++	/* Trying the standard way of routing packets */
++	if (route6(skb, ifindex, route_info)) {
++		dev_put(dev_out);
++		if (route_info->flags & IP6T_ROUTE_CONTINUE)
++			return IP6T_CONTINUE;
++	=09
++		ip_direct_send(skb);
++		return NF_STOLEN;
++	} else=20
++		return NF_DROP;
++}
++
++
++static unsigned int=20
++route6_gw(const struct ip6t_route_target_info *route_info,
++	  struct sk_buff *skb)=20
++{
++	if (route6(skb, 0, route_info)) {
++		if (route_info->flags & IP6T_ROUTE_CONTINUE)
++			return IP6T_CONTINUE;
++
++		ip_direct_send(skb);
++		return NF_STOLEN;
++	} else
++		return NF_DROP;
++}
++
++
++static unsigned int=20
++ip6t_route_target(struct sk_buff **pskb,
++		  unsigned int hooknum,
++		  const struct net_device *in,
++		  const struct net_device *out,
++		  const void *targinfo,
++		  void *userinfo)
++{
++	const struct ip6t_route_target_info *route_info =3D targinfo;
++	struct sk_buff *skb =3D *pskb;
++	struct in6_addr *gw =3D (struct in6_addr*)&route_info->gw;
++
++	if (route_info->flags & IP6T_ROUTE_CONTINUE)
++		goto do_it;
++
++	/* If we are at PREROUTING or INPUT hook
++	 * the TTL isn't decreased by the IP stack
++	 */
++	if (hooknum =3D=3D NF_IP6_PRE_ROUTING ||
++	    hooknum =3D=3D NF_IP6_LOCAL_IN) {
++
++		struct ipv6hdr *ipv6h =3D skb->nh.ipv6h;
++
++		if (ipv6h->hop_limit <=3D 1) {
++			/* Force OUTPUT device used as source address */
++			skb->dev =3D skb->dst->dev;
++
++			icmpv6_send(skb, ICMPV6_TIME_EXCEED,=20
++				    ICMPV6_EXC_HOPLIMIT, 0, skb->dev);
++
++			return NF_DROP;
++		}
++
++		ipv6h->hop_limit--;
++	}
++
++
++ do_it:
++	if (route_info->oif[0])=20
++		return route6_oif(route_info, *pskb);
++=09
++	if (!ipv6_addr_any(gw))
++		return route6_gw(route_info, *pskb);
++
++	if (net_ratelimit())=20
++		DEBUGP(KERN_DEBUG "ip6t_ROUTE: no parameter !\n");
++
++	return IP6T_CONTINUE;
++}
++
++
++static int=20
++ip6t_route_checkentry(const char *tablename,
++		      const struct ip6t_entry *e,
++		      void *targinfo,
++		      unsigned int targinfosize,
++		      unsigned int hook_mask)
++{
++	if (strcmp(tablename, "mangle") !=3D 0) {
++		printk("ip6t_ROUTE: can only be called from \"mangle\" table.\n");
++		return 0;
++	}
++
++	if (targinfosize !=3D IP6T_ALIGN(sizeof(struct ip6t_route_target_info)=
)) {
++		printk(KERN_WARNING "ip6t_ROUTE: targinfosize %u !=3D %Zu\n",
++		       targinfosize,
++		       IP6T_ALIGN(sizeof(struct ip6t_route_target_info)));
++		return 0;
++	}
++
++	return 1;
++}
++
++
++static struct ip6t_target ip6t_route_reg =3D {
++	.name       =3D "ROUTE",
++	.target     =3D ip6t_route_target,
++	.checkentry =3D ip6t_route_checkentry,
++	.me         =3D THIS_MODULE
++};
++
++
++static int __init init(void)
++{
++	printk(KERN_DEBUG "registering ipv6 ROUTE target\n");
++	if (ip6t_register_target(&ip6t_route_reg))
++		return -EINVAL;
++
++	return 0;
++}
++
++
++static void __exit fini(void)
++{
++	ip6t_unregister_target(&ip6t_route_reg);
++}
++
++module_init(init);
++module_exit(fini);
++MODULE_LICENSE("GPL");
diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch.ipv6.config.in n=
etfilter/patch-o-matic/extra/ROUTE.patch.ipv6.config.in
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch.ipv6.config.in	1970-01=
-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/ROUTE.patch.ipv6.config.in	2003-08-06 1=
0:50:49.000000000 +0200
@@ -0,0 +1,2 @@
+    dep_tristate '    MARK target support' CONFIG_IP6_NF_TARGET_MARK $CO=
NFIG_IP6_NF_MANGLE
+    dep_mbool '    ROUTE target support' CONFIG_IP6_NF_TARGET_ROUTE $CON=
FIG_IP6_NF_MANGLE
\ Pas de fin de ligne =E0 la fin du fichier.
diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch.ipv6.configure.h=
elp netfilter/patch-o-matic/extra/ROUTE.patch.ipv6.configure.help
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch.ipv6.configure.help	19=
70-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/ROUTE.patch.ipv6.configure.help	2003-08=
-06 10:47:28.000000000 +0200
@@ -0,0 +1,12 @@
+CONFIG_IP6_NF_TARGET_MARK
+ROUTE target support
+CONFIG_IP6_NF_TARGET_ROUTE
+  This option adds a `ROUTE' target, which enables you to setup unusual
+  routes. The ROUTE target is also able to change the incoming interface
+  of a packet.
+
+  The target can be or not a final target. It has to be used inside the=20
+  mangle table.
+ =20
+  Not working as a module.
+
diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch.ipv6.help netfil=
ter/patch-o-matic/extra/ROUTE.patch.ipv6.help
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch.ipv6.help	1970-01-01 0=
1:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/ROUTE.patch.ipv6.help	2003-08-06 13:57:=
07.000000000 +0200
@@ -0,0 +1,28 @@
+Author: C=E9dric de Launois <delaunois@info.ucl.ac.be>
+Status: Experimental
+ =20
+  This option adds a `ROUTE' target, which enables you to setup unusual
+  routes. The ROUTE target is also able to change the incoming interface
+  of a packet.
+
+  The target can be or not a final target. It has to be used inside the=20
+  mangle table.
+
+  ROUTE target options:
+  --oif   ifname    Send the packet out using `ifname' network interface.
+  --gw    ip        Route the packet via this gateway.
+  --continue        Route the packet and continue traversing the rules.
+
+  Examples :
+
+  # To force all outgoing icmpv6 packet to go through the eth1 interface=
=20
+  # (final target) :
+  ip6tables -A POSTROUTING -t mangle -p icmpv6 -j ROUTE --oif eth1
+=20
+  # To tunnel outgoing http packets and continue traversing the rules :
+  ip6tables -A POSTROUTING -t mangle -p tcp --dport 80 -j ROUTE --oif tu=
nl1 --continue
+=20
+  # To forward all ssh packets to a gateway, and continue traversing
+  # the rules :
+  ip6tables -A POSTROUTING -t mangle -p tcp --dport 22 -j ROUTE --gw <ip=
v6_address> --continue
+=20
diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch.ipv6.makefile ne=
tfilter/patch-o-matic/extra/ROUTE.patch.ipv6.makefile
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch.ipv6.makefile	1970-01-=
01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/ROUTE.patch.ipv6.makefile	2003-08-06 10=
:16:49.000000000 +0200
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP6_NF_TARGET_MARK) +=3D ip6t_MARK.o
+obj-$(CONFIG_IP6_NF_TARGET_ROUTE) +=3D ip6t_ROUTE.o
diff -Nru netfilter.orig/userspace/extensions/libip6t_ROUTE.c netfilter/u=
serspace/extensions/libip6t_ROUTE.c
--- netfilter.orig/userspace/extensions/libip6t_ROUTE.c	1970-01-01 01:00:=
00.000000000 +0100
+++ netfilter/userspace/extensions/libip6t_ROUTE.c	2003-08-28 11:32:33.00=
0000000 +0200
@@ -0,0 +1,209 @@
+/* Shared library add-on to iptables to add ROUTE v6 target support.
+ * Author : Cedric de Launois, <delaunois@info.ucl.ac.be>
+ * v 1.0 2003/06/24
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <arpa/inet.h>
+
+#include <ip6tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_ROUTE.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"ROUTE target v%s options:\n"
+"    --oif   \tifname \t\tRoute the packet through `ifname' network inte=
rface\n"
+"    --gw    \tip     \t\tRoute the packet via this gateway\n"
+"    --continue\t     \t\tRoute the packet and continue traversing the r=
ules.\n"
+"\n",
+"1.0");
+}
+
+static struct option opts[] =3D {
+	{ "oif", 1, 0, '1' },
+	{ "iif", 1, 0, '2' },
+	{ "gw", 1, 0, '3' },
+	{ "continue", 0, 0, '4' },
+	{ 0 }
+};
+
+/* Initialize the target. */
+static void
+init(struct ip6t_entry_target *t, unsigned int *nfcache)
+{
+	struct ip6t_route_target_info *route_info =3D=20
+		(struct ip6t_route_target_info*)t->data;
+
+	route_info->oif[0] =3D '\0';
+	route_info->iif[0] =3D '\0';
+	route_info->gw[0] =3D 0;
+	route_info->gw[1] =3D 0;
+	route_info->gw[2] =3D 0;
+	route_info->gw[3] =3D 0;
+	route_info->flags =3D 0;
+}
+
+
+#define IP6T_ROUTE_OPT_OIF      0x01
+#define IP6T_ROUTE_OPT_IIF      0x02
+#define IP6T_ROUTE_OPT_GW       0x04
+#define IP6T_ROUTE_OPT_CONTINUE 0x08
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ip6t_entry *entry,
+      struct ip6t_entry_target **target)
+{
+	struct ip6t_route_target_info *route_info =3D=20
+		(struct ip6t_route_target_info*)(*target)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags & IP6T_ROUTE_OPT_OIF)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --oif twice");
+
+		if (check_inverse(optarg, &invert, NULL, 0))
+			exit_error(PARAMETER_PROBLEM,
+				   "Unexpected `!' after --oif");
+
+		if (strlen(optarg) > sizeof(route_info->oif) - 1)
+			exit_error(PARAMETER_PROBLEM,
+				   "Maximum interface name length %u",
+				   sizeof(route_info->oif) - 1);
+
+		strcpy(route_info->oif, optarg);
+		*flags |=3D IP6T_ROUTE_OPT_OIF;
+		break;
+
+	case '2':
+		exit_error(PARAMETER_PROBLEM,
+			   "--iif option not implemented");
+		break;
+
+	case '3':
+		if (*flags & IP6T_ROUTE_OPT_GW)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --gw twice");
+
+		if (check_inverse(optarg, &invert, NULL, 0))
+			exit_error(PARAMETER_PROBLEM,
+				   "Unexpected `!' after --gw");
+
+		if (!inet_pton(AF_INET6, optarg, (struct in6_addr*)&route_info->gw)) {
+			exit_error(PARAMETER_PROBLEM,
+				   "Invalid IPv6 address %s",
+				   optarg);
+		}
+
+		*flags |=3D IP6T_ROUTE_OPT_GW;
+		break;
+
+	case '4':
+		if (*flags & IP6T_ROUTE_OPT_CONTINUE)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --continue twice");
+
+		route_info->flags |=3D IP6T_ROUTE_CONTINUE;
+		*flags |=3D IP6T_ROUTE_OPT_CONTINUE;
+
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+
+static void
+final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+		           "ROUTE target: oif or gw option required");
+}
+
+
+/* Prints out the targinfo. */
+static void
+print(const struct ip6t_ip6 *ip,
+      const struct ip6t_entry_target *target,
+      int numeric)
+{
+	const struct ip6t_route_target_info *route_info
+		=3D (const struct ip6t_route_target_info *)target->data;
+
+	printf("ROUTE ");
+
+	if (route_info->oif[0])
+		printf("oif:%s ", route_info->oif);
+
+	if (route_info->gw[0]=20
+	    || route_info->gw[1]=20
+	    || route_info->gw[2]=20
+	    || route_info->gw[3]) {
+		char address[INET6_ADDRSTRLEN];
+		printf("gw:%s ", inet_ntop(AF_INET6, route_info->gw, address, INET6_AD=
DRSTRLEN));
+	}
+
+	if (route_info->flags & IP6T_ROUTE_CONTINUE)
+		printf("continue");
+
+}
+
+
+static void save(const struct ip6t_ip6 *ip,=20
+		 const struct ip6t_entry_target *target)
+{
+	const struct ip6t_route_target_info *route_info
+		=3D (const struct ip6t_route_target_info *)target->data;
+
+	if (route_info->oif[0])
+		printf("--oif %s ", route_info->oif);
+
+	if (route_info->gw[0]=20
+	    || route_info->gw[1]=20
+	    || route_info->gw[2]=20
+	    || route_info->gw[3]) {
+		char address[INET6_ADDRSTRLEN];
+		printf("--gw %s ", inet_ntop(AF_INET6, route_info->gw, address, INET6_=
ADDRSTRLEN));
+	}
+
+	if (route_info->flags & IP6T_ROUTE_CONTINUE)
+		printf("--continue ");
+}
+
+
+static
+struct ip6tables_target route
+=3D { NULL,
+    "ROUTE",
+    IPTABLES_VERSION,
+    IP6T_ALIGN(sizeof(struct ip6t_route_target_info)),
+    IP6T_ALIGN(sizeof(struct ip6t_route_target_info)),
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
+	register_target6(&route);
+}
diff -Nru netfilter.orig/userspace/extensions/.ROUTE-test6 netfilter/user=
space/extensions/.ROUTE-test6
--- netfilter.orig/userspace/extensions/.ROUTE-test6	1970-01-01 01:00:00.=
000000000 +0100
+++ netfilter/userspace/extensions/.ROUTE-test6	2003-08-05 16:17:50.00000=
0000 +0200
@@ -0,0 +1,2 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv6/ip6t_ROUTE.h ] && echo ROU=
TE

--=-tKG6MVvA9kCuQhg4gqEg--
