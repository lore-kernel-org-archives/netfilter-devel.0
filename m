From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: [PATCH] ROUTE target : update to pom-ng + new version for kernel
	2.6.x
Date: Wed, 21 Apr 2004 10:16:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1082535373.17611.39.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Ub68NJ1FVMS9ucuGargM"
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


--=-Ub68NJ1FVMS9ucuGargM
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

Here is a patch to convert the ROUTE target to the new pom-ng.
This patch also contains a corrected version of the ROUTE target
for kernels 2.6.x.

Other fixes for the ROUTE target will follow.

The patch is against the current cvs tree.

Cedric


--=-Ub68NJ1FVMS9ucuGargM
Content-Disposition: attachment; filename=ROUTE.pom-ng.patch
Content-Type: text/x-patch; name=ROUTE.pom-ng.patch; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by info.ucl.ac.be id i3L89ngB003723

diff -Nru ROUTE.orig/info ROUTE/info
--- ROUTE.orig/info	2004-02-20 00:11:50.000000000 +0100
+++ ROUTE/info	2004-03-08 14:19:22.000000000 +0100
@@ -1,4 +1,5 @@
 Author: C=E9dric de Launois <delaunois@info.ucl.ac.be>
 Status: Experimental
 Repository: extra
-Requires: linux < 2.6.0
+Recompile: netfilter
+Recompile: iptables
diff -Nru ROUTE.orig/linux/Documentation/Configure.help.ladd ROUTE/linux/=
Documentation/Configure.help.ladd
--- ROUTE.orig/linux/Documentation/Configure.help.ladd	2004-02-19 12:30:0=
8.000000000 +0100
+++ ROUTE/linux/Documentation/Configure.help.ladd	1970-01-01 01:00:00.000=
000000 +0100
@@ -1,16 +0,0 @@
-CONFIG_IP_NF_TARGET_MARK
-ROUTE target support
-CONFIG_IP_NF_TARGET_ROUTE
-  This option adds a `ROUTE' target, which enables you to setup unusual
-  routes. For example, the ROUTE lets you route a received packet throug=
h=20
-  an interface or towards a host, even if the regular destination of the=
=20
-  packet is the router itself. The ROUTE target is also able to change t=
he=20
-  incoming interface of a packet.
-
-  The target can be or not a final target. It has to be used inside the=20
-  mangle table.
- =20
-  If you want to compile it as a module, say M here and read
-  Documentation/modules.txt.  The module will be called ipt_ROUTE.o.
-  If unsure, say `N'.
-
diff -Nru ROUTE.orig/linux/Documentation/Configure.help.ladd_2 ROUTE/linu=
x/Documentation/Configure.help.ladd_2
--- ROUTE.orig/linux/Documentation/Configure.help.ladd_2	2004-03-05 10:30=
:26.000000000 +0100
+++ ROUTE/linux/Documentation/Configure.help.ladd_2	1970-01-01 01:00:00.0=
00000000 +0100
@@ -1,12 +0,0 @@
-CONFIG_IP6_NF_TARGET_MARK
-ROUTE target support
-CONFIG_IP6_NF_TARGET_ROUTE
-  This option adds a `ROUTE' target, which enables you to setup unusual
-  routes. The ROUTE target is also able to change the incoming interface
-  of a packet.
-
-  The target can be or not a final target. It has to be used inside the=20
-  mangle table.
- =20
-  Not working as a module.
-
diff -Nru ROUTE.orig/linux/include/linux/netfilter_ipv4/ipt_ROUTE.h ROUTE=
/linux/include/linux/netfilter_ipv4/ipt_ROUTE.h
--- ROUTE.orig/linux/include/linux/netfilter_ipv4/ipt_ROUTE.h	2003-12-18 =
19:47:54.000000000 +0100
+++ ROUTE/linux/include/linux/netfilter_ipv4/ipt_ROUTE.h	1970-01-01 01:00=
:00.000000000 +0100
@@ -1,22 +0,0 @@
-/* Header file for iptables ipt_ROUTE target
- *
- * (C) 2002 by C=E9dric de Launois <delaunois@info.ucl.ac.be>
- *
- * This software is distributed under GNU GPL v2, 1991
- */
-#ifndef _IPT_ROUTE_H_target
-#define _IPT_ROUTE_H_target
-
-#define IPT_ROUTE_IFNAMSIZ 16
-
-struct ipt_route_target_info {
-	char      oif[IPT_ROUTE_IFNAMSIZ];      /* Output Interface Name */
-	char      iif[IPT_ROUTE_IFNAMSIZ];      /* Input Interface Name  */
-	u_int32_t gw;                           /* IP address of gateway */
-	u_int8_t  flags;
-};
-
-/* Values for "flags" field */
-#define IPT_ROUTE_CONTINUE        0x01
-
-#endif /*_IPT_ROUTE_H_target*/
diff -Nru ROUTE.orig/linux/include/linux/netfilter_ipv6/ip6t_ROUTE.h ROUT=
E/linux/include/linux/netfilter_ipv6/ip6t_ROUTE.h
--- ROUTE.orig/linux/include/linux/netfilter_ipv6/ip6t_ROUTE.h	2003-12-20=
 17:43:09.000000000 +0100
+++ ROUTE/linux/include/linux/netfilter_ipv6/ip6t_ROUTE.h	1970-01-01 01:0=
0:00.000000000 +0100
@@ -1,22 +0,0 @@
-/* Header file for iptables ip6t_ROUTE target
- *
- * (C) 2003 by C=E9dric de Launois <delaunois@info.ucl.ac.be>
- *
- * This software is distributed under GNU GPL v2, 1991
- */
-#ifndef _IPT_ROUTE_H_target
-#define _IPT_ROUTE_H_target
-
-#define IP6T_ROUTE_IFNAMSIZ 16
-
-struct ip6t_route_target_info {
-	char      oif[IP6T_ROUTE_IFNAMSIZ];     /* Output Interface Name */
-	char      iif[IP6T_ROUTE_IFNAMSIZ];     /* Input Interface Name  */
-	u_int32_t gw[4];                        /* IPv6 address of gateway */
-	u_int8_t  flags;
-};
-
-/* Values for "flags" field */
-#define IP6T_ROUTE_CONTINUE        0x01
-
-#endif /*_IP6T_ROUTE_H_target*/
diff -Nru ROUTE.orig/linux/net/ipv4/netfilter/Config.in.ladd ROUTE/linux/=
net/ipv4/netfilter/Config.in.ladd
--- ROUTE.orig/linux/net/ipv4/netfilter/Config.in.ladd	2003-12-18 19:47:5=
4.000000000 +0100
+++ ROUTE/linux/net/ipv4/netfilter/Config.in.ladd	1970-01-01 01:00:00.000=
000000 +0100
@@ -1,3 +0,0 @@
-    dep_tristate '    MARK target support' CONFIG_IP_NF_TARGET_MARK $CON=
FIG_IP_NF_MANGLE
-    dep_tristate '    ROUTE target support' CONFIG_IP_NF_TARGET_ROUTE $C=
ONFIG_IP_NF_MANGLE
-=20
\ Pas de fin de ligne =E0 la fin du fichier.
diff -Nru ROUTE.orig/linux/net/ipv4/netfilter/ipt_ROUTE.c ROUTE/linux/net=
/ipv4/netfilter/ipt_ROUTE.c
--- ROUTE.orig/linux/net/ipv4/netfilter/ipt_ROUTE.c	2003-12-18 19:47:54.0=
00000000 +0100
+++ ROUTE/linux/net/ipv4/netfilter/ipt_ROUTE.c	1970-01-01 01:00:00.000000=
000 +0100
@@ -1,369 +0,0 @@
-/*
- * This implements the ROUTE target, which enables you to setup unusual
- * routes not supported by the standard kernel routing table.
- *
- * Copyright (C) 2002 Cedric de Launois <delaunois@info.ucl.ac.be>
- *
- * v 1.8 2003/07/25
- *
- * This software is distributed under GNU GPL v2, 1991
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_ROUTE.h>
-#include <linux/netdevice.h>
-#include <linux/route.h>
-#include <net/ip.h>
-#include <net/route.h>
-#include <net/icmp.h>
-
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
-
-/* Try to route the packet according to the routing keys specified in
- * route_info. Keys are :
- *  - ifindex :=20
- *      0 if no oif preferred,=20
- *      otherwise set to the index of the desired oif
- *  - route_info->gw :
- *      0 if no gateway specified,
- *      otherwise set to the next host to which the pkt must be routed
- * If success, skb->dev is the output device to which the packet must=20
- * be sent and skb->dst is not NULL
- *
- * RETURN: -1 if an error occured
- *          1 if the packet was succesfully routed to the=20
- *            destination desired
- *          0 if the kernel routing table could not route the packet
- *            according to the keys specified
- */
-static int route(struct sk_buff *skb,
-		 unsigned int ifindex,
-		 const struct ipt_route_target_info *route_info)
-{
-	int err;
-	struct rtable *rt;
-	struct iphdr *iph =3D skb->nh.iph;
-	struct rt_key key =3D {=20
-		dst:iph->daddr,
-		src:0,
-		oif:ifindex,=20
-		tos:RT_TOS(iph->tos)=20
-	};
-=09
-	/* The destination address may be overloaded by the target */
-	if (route_info->gw)
-		key.dst =3D route_info->gw;
-=09
-	/* Trying to route the packet using the standard routing table. */
-	if ((err =3D ip_route_output_key(&rt, &key))) {
-		if (net_ratelimit())=20
-			DEBUGP("ipt_ROUTE: couldn't route pkt (err: %i)",err);
-		return -1;
-	}
-=09
-	/* Drop old route. */
-	dst_release(skb->dst);
-	skb->dst =3D NULL;
-
-	/* Success if no oif specified or if the oif correspond to the=20
-	 * one desired */
-	if (!ifindex || rt->u.dst.dev->ifindex =3D=3D ifindex) {
-		skb->dst =3D &rt->u.dst;
-		skb->dev =3D skb->dst->dev;
-		return 1;
-	}
-=09
-	/* The interface selected by the routing table is not the one
-	 * specified by the user. This may happen because the dst address
-	 * is one of our own addresses.
-	 */
-	if (net_ratelimit())=20
-		DEBUGP("ipt_ROUTE: failed to route as desired gw=3D%u.%u.%u.%u oif=3D%=
i (got oif=3D%i)\n",=20
-		       NIPQUAD(route_info->gw), ifindex, rt->u.dst.dev->ifindex);
-=09
-	return 0;
-}
-
-
-/* Stolen from ip_finish_output2
- * PRE : skb->dev is set to the device we are leaving by
- *       skb->dst is not NULL
- * POST: the packet is sent with the link layer header pushed
- *       the packet is destroyed
- */
-static void ip_direct_send(struct sk_buff *skb)
-{
-	struct dst_entry *dst =3D skb->dst;
-	struct hh_cache *hh =3D dst->hh;
-
-	if (hh) {
-		read_lock_bh(&hh->hh_lock);
-		memcpy(skb->data - 16, hh->hh_data, 16);
-		read_unlock_bh(&hh->hh_lock);
-		skb_push(skb, hh->hh_len);
-		hh->hh_output(skb);
-	} else if (dst->neighbour)
-		dst->neighbour->output(skb);
-	else {
-		if (net_ratelimit())
-			DEBUGP(KERN_DEBUG "ipt_ROUTE: no hdr & no neighbour cache!\n");
-		kfree_skb(skb);
-	}
-}
-
-
-/* PRE : skb->dev is set to the device we are leaving by
- * POST: - the packet is directly sent to the skb->dev device, without=20
- *         pushing the link layer header.
- *       - the packet is destroyed
- */
-static inline int dev_direct_send(struct sk_buff *skb)
-{
-	return dev_queue_xmit(skb);
-}
-
-
-static unsigned int route_oif(const struct ipt_route_target_info *route_=
info,
-			      struct sk_buff *skb)=20
-{
-	unsigned int ifindex =3D 0;
-	struct net_device *dev_out =3D NULL;
-
-	/* The user set the interface name to use.
-	 * Getting the current interface index.
-	 */
-	if ((dev_out =3D dev_get_by_name(route_info->oif))) {
-		ifindex =3D dev_out->ifindex;
-	} else {
-		/* Unknown interface name : packet dropped */
-		if (net_ratelimit())=20
-			DEBUGP("ipt_ROUTE: oif interface %s not found\n", route_info->oif);
-		return NF_DROP;
-	}
-
-	/* Trying the standard way of routing packets */
-	switch (route(skb, ifindex, route_info)) {
-	case 1:
-		dev_put(dev_out);
-		if (route_info->flags & IPT_ROUTE_CONTINUE)
-			return IPT_CONTINUE;
-
-		ip_direct_send(skb);
-		return NF_STOLEN;
-
-	case 0:
-		/* Failed to send to oif. Trying the hard way */
-		if (route_info->flags & IPT_ROUTE_CONTINUE)
-			return NF_DROP;
-
-		if (net_ratelimit())=20
-			DEBUGP("ipt_ROUTE: forcing the use of %i\n",
-			       ifindex);
-
-		/* We have to force the use of an interface.
-		 * This interface must be a tunnel interface since
-		 * otherwise we can't guess the hw address for
-		 * the packet. For a tunnel interface, no hw address
-		 * is needed.
-		 */
-		if ((dev_out->type !=3D ARPHRD_TUNNEL)
-		    && (dev_out->type !=3D ARPHRD_IPGRE)) {
-			if (net_ratelimit())=20
-				DEBUGP("ipt_ROUTE: can't guess the hw addr !\n");
-			dev_put(dev_out);
-			return NF_DROP;
-		}
-=09
-		/* Send the packet. This will also free skb
-		 * Do not go through the POST_ROUTING hook because=20
-		 * skb->dst is not set and because it will probably
-		 * get confused by the destination IP address.
-		 */
-		skb->dev =3D dev_out;
-		dev_direct_send(skb);
-		dev_put(dev_out);
-		return NF_STOLEN;
-	=09
-	default:
-		/* Unexpected error */
-		dev_put(dev_out);
-		return NF_DROP;
-	}
-}
-
-
-static unsigned int route_iif(const struct ipt_route_target_info *route_=
info,
-			      struct sk_buff *skb)=20
-{
-	struct net_device *dev_out =3D NULL;
-	unsigned int ifindex =3D 0;
-
-	/* Getting the current interface index. */
-	if ((dev_out =3D dev_get_by_name(route_info->iif)))
-		ifindex =3D dev_out->ifindex;
-	else {
-		/* Unknown interface name : packet dropped */
-		if (net_ratelimit())=20
-			DEBUGP("ipt_ROUTE: iif interface %s not found\n", route_info->oif);
-		return NF_DROP;
-	}
-
-	skb->dev =3D dev_out;
-	dst_release(skb->dst);
-	skb->dst =3D NULL;
-	=09
-	netif_rx(skb);
-
-	return NF_STOLEN;
-}
-
-
-static unsigned int route_gw(const struct ipt_route_target_info *route_i=
nfo,
-			     struct sk_buff *skb)=20
-{
-	if (route(skb, 0, route_info)!=3D1)
-		return NF_DROP;
-
-	if (route_info->flags & IPT_ROUTE_CONTINUE)
-		return IPT_CONTINUE;
-
-	ip_direct_send(skb);
-	return NF_STOLEN;
-}
-
-
-static unsigned int ipt_route_target(struct sk_buff **pskb,
-				     unsigned int hooknum,
-				     const struct net_device *in,
-				     const struct net_device *out,
-				     const void *targinfo,
-				     void *userinfo)
-{
-	const struct ipt_route_target_info *route_info =3D targinfo;
-	struct sk_buff *skb =3D *pskb;
-
-	/* If we are at PREROUTING or INPUT hook
-	 * the TTL isn't decreased by the IP stack
-	 */
-	if (hooknum =3D=3D NF_IP_PRE_ROUTING ||
-	    hooknum =3D=3D NF_IP_LOCAL_IN) {
-
-		struct iphdr *iph =3D skb->nh.iph;
-
-		if (iph->ttl <=3D 1) {
-			struct rtable *rt;
-
-			if (ip_route_output(&rt, iph->saddr, iph->daddr,
-					    RT_TOS(iph->tos) | RTO_CONN,
-					    0)) {
-				return NF_DROP;
-			}
-
-			if (skb->dev =3D=3D rt->u.dst.dev) {
-				/* Drop old route. */
-				dst_release(skb->dst);
-				skb->dst =3D &rt->u.dst;
-
-				/* this will traverse normal stack, and=20
-				 * thus call conntrack on the icmp packet */
-				icmp_send(skb, ICMP_TIME_EXCEEDED,=20
-					  ICMP_EXC_TTL, 0);
-			}
-
-			return NF_DROP;
-		}
-
-		ip_decrease_ttl(iph);
-	}
-
-	/* Tell conntrack to forget this packet since it may get confused=20
-	 * when a packet is leaving with dst address =3D=3D our address.
-	 * Good idea ? Dunno. Need advice.
-	 */
-	if (!(route_info->flags & IPT_ROUTE_CONTINUE)) {
-		nf_conntrack_put(skb->nfct);
-		skb->nfct =3D NULL;
-		skb->nfcache =3D 0;
-#ifdef CONFIG_NETFILTER_DEBUG
-		skb->nf_debug =3D 0;
-#endif
-	}
-
-	if (route_info->oif[0])=20
-		return route_oif(route_info, *pskb);
-=09
-	if (route_info->iif[0])=20
-		return route_iif(route_info, *pskb);
-
-	if (route_info->gw)=20
-		return route_gw(route_info, *pskb);
-
-	if (net_ratelimit())=20
-		DEBUGP(KERN_DEBUG "ipt_ROUTE: no parameter !\n");
-
-	return IPT_CONTINUE;
-}
-
-
-static int ipt_route_checkentry(const char *tablename,
-				const struct ipt_entry *e,
-				void *targinfo,
-				unsigned int targinfosize,
-				unsigned int hook_mask)
-{
-	if (strcmp(tablename, "mangle") !=3D 0) {
-		printk("ipt_ROUTE: bad table `%s', use the `mangle' table.\n",
-		       tablename);
-		return 0;
-	}
-
-	if (hook_mask & ~(  (1 << NF_IP_PRE_ROUTING)
-			    | (1 << NF_IP_LOCAL_IN)
-			    | (1 << NF_IP_FORWARD)
-			    | (1 << NF_IP_LOCAL_OUT)
-			    | (1 << NF_IP_POST_ROUTING))) {
-		printk("ipt_ROUTE: bad hook\n");
-		return 0;
-	}
-
-	if (targinfosize !=3D IPT_ALIGN(sizeof(struct ipt_route_target_info))) =
{
-		printk(KERN_WARNING "ipt_ROUTE: targinfosize %u !=3D %Zu\n",
-		       targinfosize,
-		       IPT_ALIGN(sizeof(struct ipt_route_target_info)));
-		return 0;
-	}
-
-	return 1;
-}
-
-
-static struct ipt_target ipt_route_reg
-=3D { { NULL, NULL }, "ROUTE", ipt_route_target, ipt_route_checkentry, N=
ULL,
-    THIS_MODULE };
-
-
-static int __init init(void)
-{
-	if (ipt_register_target(&ipt_route_reg))
-		return -EINVAL;
-
-	return 0;
-}
-
-
-static void __exit fini(void)
-{
-	ipt_unregister_target(&ipt_route_reg);
-}
-
-module_init(init);
-module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru ROUTE.orig/linux/net/ipv4/netfilter/Kconfig.ladd ROUTE/linux/ne=
t/ipv4/netfilter/Kconfig.ladd
--- ROUTE.orig/linux/net/ipv4/netfilter/Kconfig.ladd	2003-12-21 21:09:27.=
000000000 +0100
+++ ROUTE/linux/net/ipv4/netfilter/Kconfig.ladd	1970-01-01 01:00:00.00000=
0000 +0100
@@ -1,3 +0,0 @@
-config IP_NF_TARGET_ROUTE
-	tristate  'ROUTE target support'
-	depends on IP_NF_MANGLE
diff -Nru ROUTE.orig/linux/net/ipv4/netfilter/Makefile.ladd ROUTE/linux/n=
et/ipv4/netfilter/Makefile.ladd
--- ROUTE.orig/linux/net/ipv4/netfilter/Makefile.ladd	2003-12-18 19:47:54=
.000000000 +0100
+++ ROUTE/linux/net/ipv4/netfilter/Makefile.ladd	1970-01-01 01:00:00.0000=
00000 +0100
@@ -1,2 +0,0 @@
-obj-$(CONFIG_IP_NF_TARGET_REDIRECT) +=3D ipt_REDIRECT.o
-obj-$(CONFIG_IP_NF_TARGET_ROUTE) +=3D ipt_ROUTE.o
diff -Nru ROUTE.orig/linux/net/ipv6/netfilter/Config.in.ladd ROUTE/linux/=
net/ipv6/netfilter/Config.in.ladd
--- ROUTE.orig/linux/net/ipv6/netfilter/Config.in.ladd	2003-12-20 17:43:0=
9.000000000 +0100
+++ ROUTE/linux/net/ipv6/netfilter/Config.in.ladd	1970-01-01 01:00:00.000=
000000 +0100
@@ -1,2 +0,0 @@
-    dep_tristate '    MARK target support' CONFIG_IP6_NF_TARGET_MARK $CO=
NFIG_IP6_NF_MANGLE
-    dep_mbool '    ROUTE target support' CONFIG_IP6_NF_TARGET_ROUTE $CON=
FIG_IP6_NF_MANGLE
\ Pas de fin de ligne =E0 la fin du fichier.
diff -Nru ROUTE.orig/linux/net/ipv6/netfilter/ip6t_ROUTE.c ROUTE/linux/ne=
t/ipv6/netfilter/ip6t_ROUTE.c
--- ROUTE.orig/linux/net/ipv6/netfilter/ip6t_ROUTE.c	2003-12-20 17:43:09.=
000000000 +0100
+++ ROUTE/linux/net/ipv6/netfilter/ip6t_ROUTE.c	1970-01-01 01:00:00.00000=
0000 +0100
@@ -1,289 +0,0 @@
-/*
- * This implements the ROUTE v6 target, which enables you to setup unusu=
al
- * routes not supported by the standard kernel routing table.
- *
- * Copyright (C) 2003 Cedric de Launois <delaunois@info.ucl.ac.be>
- *
- * v 1.0 2003/08/05
- *
- * This software is distributed under GNU GPL v2, 1991
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ipv6.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/netfilter_ipv6/ip6t_ROUTE.h>
-#include <linux/netdevice.h>
-#include <net/ipv6.h>
-#include <net/ndisc.h>
-#include <net/ip6_route.h>
-#include <linux/icmpv6.h>
-
-#if 1
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
-#define NIP6(addr) \
-	ntohs((addr).s6_addr16[0]), \
-	ntohs((addr).s6_addr16[1]), \
-	ntohs((addr).s6_addr16[2]), \
-	ntohs((addr).s6_addr16[3]), \
-	ntohs((addr).s6_addr16[4]), \
-	ntohs((addr).s6_addr16[5]), \
-	ntohs((addr).s6_addr16[6]), \
-	ntohs((addr).s6_addr16[7])
-
-/* Route the packet according to the routing keys specified in
- * route_info. Keys are :
- *  - ifindex :=20
- *      0 if no oif preferred,=20
- *      otherwise set to the index of the desired oif
- *  - route_info->gw :
- *      0 if no gateway specified,
- *      otherwise set to the next host to which the pkt must be routed
- * If success, skb->dev is the output device to which the packet must=20
- * be sent and skb->dst is not NULL
- *
- * RETURN:  1 if the packet was succesfully routed to the=20
- *            destination desired
- *          0 if the kernel routing table could not route the packet
- *            according to the keys specified
- */
-static int=20
-route6(struct sk_buff *skb,
-       unsigned int ifindex,
-       const struct ip6t_route_target_info *route_info)
-{
-	struct rt6_info *rt =3D NULL;
-	struct ipv6hdr *ipv6h =3D skb->nh.ipv6h;
-	struct in6_addr *gw =3D (struct in6_addr*)&route_info->gw;
-
-	DEBUGP("ip6t_ROUTE: called with: ");
-	DEBUGP("DST=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(ipv6h->da=
ddr));
-	DEBUGP("GATEWAY=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(*gw))=
;
-	DEBUGP("OUT=3D%s\n", route_info->oif);
-=09
-	if (ipv6_addr_any(gw))
-		rt =3D rt6_lookup(&ipv6h->daddr, &ipv6h->saddr, ifindex, 1);
-	else
-		rt =3D rt6_lookup(gw, &ipv6h->saddr, ifindex, 1);
-
-	if (!rt)
-		goto no_route;
-
-	DEBUGP("ip6t_ROUTE: routing gives: ");
-	DEBUGP("DST=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(rt->rt6i_=
dst.addr));
-	DEBUGP("GATEWAY=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(rt->r=
t6i_gateway));
-	DEBUGP("OUT=3D%s\n", rt->rt6i_dev->name);
-
-	if (ifindex && rt->rt6i_dev->ifindex!=3Difindex)
-		goto wrong_route;
-=09
-	if (!rt->rt6i_nexthop) {
-		DEBUGP("ip6t_ROUTE: discovering neighbour\n");
-		rt->rt6i_nexthop =3D ndisc_get_neigh(rt->rt6i_dev, &rt->rt6i_dst.addr)=
;
-	}
-
-	/* Drop old route. */
-	dst_release(skb->dst);
-	skb->dst =3D &rt->u.dst;
-	skb->dev =3D rt->rt6i_dev;
-	return 1;
-
- wrong_route:
-	dst_release(&rt->u.dst);
- no_route:
-	if (!net_ratelimit())
-		return 0;
-
-	printk("ip6t_ROUTE: no explicit route found ");
-	if (ifindex)
-		printk("via interface %s ", route_info->oif);
-	if (!ipv6_addr_any(gw))
-		printk("via gateway %04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x", NIP6(*gw=
));
-	printk("\n");
-	return 0;
-}
-
-
-/* Stolen from ip6_output_finish
- * PRE : skb->dev is set to the device we are leaving by
- *       skb->dst is not NULL
- * POST: the packet is sent with the link layer header pushed
- *       the packet is destroyed
- */
-static void ip_direct_send(struct sk_buff *skb)
-{
-	struct dst_entry *dst =3D skb->dst;
-	struct hh_cache *hh =3D dst->hh;
-
-	if (hh) {
-		read_lock_bh(&hh->hh_lock);
-		memcpy(skb->data - 16, hh->hh_data, 16);
-		read_unlock_bh(&hh->hh_lock);
-		skb_push(skb, hh->hh_len);
-		hh->hh_output(skb);
-	} else if (dst->neighbour)
-		dst->neighbour->output(skb);
-	else {
-		if (net_ratelimit())
-			DEBUGP(KERN_DEBUG "ip6t_ROUTE: no hdr & no neighbour cache!\n");
-		kfree_skb(skb);
-	}
-}
-
-
-static unsigned int=20
-route6_oif(const struct ip6t_route_target_info *route_info,
-	   struct sk_buff *skb)=20
-{
-	unsigned int ifindex =3D 0;
-	struct net_device *dev_out =3D NULL;
-
-	/* The user set the interface name to use.
-	 * Getting the current interface index.
-	 */
-	if ((dev_out =3D dev_get_by_name(route_info->oif))) {
-		ifindex =3D dev_out->ifindex;
-	} else {
-		/* Unknown interface name : packet dropped */
-		if (net_ratelimit())=20
-			DEBUGP("ip6t_ROUTE: oif interface %s not found\n", route_info->oif);
-
-		if (route_info->flags & IP6T_ROUTE_CONTINUE)
-			return IP6T_CONTINUE;
-		else
-			return NF_DROP;
-	}
-
-	/* Trying the standard way of routing packets */
-	if (route6(skb, ifindex, route_info)) {
-		dev_put(dev_out);
-		if (route_info->flags & IP6T_ROUTE_CONTINUE)
-			return IP6T_CONTINUE;
-	=09
-		ip_direct_send(skb);
-		return NF_STOLEN;
-	} else=20
-		return NF_DROP;
-}
-
-
-static unsigned int=20
-route6_gw(const struct ip6t_route_target_info *route_info,
-	  struct sk_buff *skb)=20
-{
-	if (route6(skb, 0, route_info)) {
-		if (route_info->flags & IP6T_ROUTE_CONTINUE)
-			return IP6T_CONTINUE;
-
-		ip_direct_send(skb);
-		return NF_STOLEN;
-	} else
-		return NF_DROP;
-}
-
-
-static unsigned int=20
-ip6t_route_target(struct sk_buff **pskb,
-		  unsigned int hooknum,
-		  const struct net_device *in,
-		  const struct net_device *out,
-		  const void *targinfo,
-		  void *userinfo)
-{
-	const struct ip6t_route_target_info *route_info =3D targinfo;
-	struct sk_buff *skb =3D *pskb;
-	struct in6_addr *gw =3D (struct in6_addr*)&route_info->gw;
-
-	if (route_info->flags & IP6T_ROUTE_CONTINUE)
-		goto do_it;
-
-	/* If we are at PREROUTING or INPUT hook
-	 * the TTL isn't decreased by the IP stack
-	 */
-	if (hooknum =3D=3D NF_IP6_PRE_ROUTING ||
-	    hooknum =3D=3D NF_IP6_LOCAL_IN) {
-
-		struct ipv6hdr *ipv6h =3D skb->nh.ipv6h;
-
-		if (ipv6h->hop_limit <=3D 1) {
-			/* Force OUTPUT device used as source address */
-			skb->dev =3D skb->dst->dev;
-
-			icmpv6_send(skb, ICMPV6_TIME_EXCEED,=20
-				    ICMPV6_EXC_HOPLIMIT, 0, skb->dev);
-
-			return NF_DROP;
-		}
-
-		ipv6h->hop_limit--;
-	}
-
-
- do_it:
-	if (route_info->oif[0])=20
-		return route6_oif(route_info, *pskb);
-=09
-	if (!ipv6_addr_any(gw))
-		return route6_gw(route_info, *pskb);
-
-	if (net_ratelimit())=20
-		DEBUGP(KERN_DEBUG "ip6t_ROUTE: no parameter !\n");
-
-	return IP6T_CONTINUE;
-}
-
-
-static int=20
-ip6t_route_checkentry(const char *tablename,
-		      const struct ip6t_entry *e,
-		      void *targinfo,
-		      unsigned int targinfosize,
-		      unsigned int hook_mask)
-{
-	if (strcmp(tablename, "mangle") !=3D 0) {
-		printk("ip6t_ROUTE: can only be called from \"mangle\" table.\n");
-		return 0;
-	}
-
-	if (targinfosize !=3D IP6T_ALIGN(sizeof(struct ip6t_route_target_info))=
) {
-		printk(KERN_WARNING "ip6t_ROUTE: targinfosize %u !=3D %Zu\n",
-		       targinfosize,
-		       IP6T_ALIGN(sizeof(struct ip6t_route_target_info)));
-		return 0;
-	}
-
-	return 1;
-}
-
-
-static struct ip6t_target ip6t_route_reg =3D {
-	.name       =3D "ROUTE",
-	.target     =3D ip6t_route_target,
-	.checkentry =3D ip6t_route_checkentry,
-	.me         =3D THIS_MODULE
-};
-
-
-static int __init init(void)
-{
-	printk(KERN_DEBUG "registering ipv6 ROUTE target\n");
-	if (ip6t_register_target(&ip6t_route_reg))
-		return -EINVAL;
-
-	return 0;
-}
-
-
-static void __exit fini(void)
-{
-	ip6t_unregister_target(&ip6t_route_reg);
-}
-
-module_init(init);
-module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru ROUTE.orig/linux/net/ipv6/netfilter/Kconfig.ladd ROUTE/linux/ne=
t/ipv6/netfilter/Kconfig.ladd
--- ROUTE.orig/linux/net/ipv6/netfilter/Kconfig.ladd	2003-12-23 12:41:11.=
000000000 +0100
+++ ROUTE/linux/net/ipv6/netfilter/Kconfig.ladd	1970-01-01 01:00:00.00000=
0000 +0100
@@ -1,3 +0,0 @@
-config IP6_NF_TARGET_ROUTE
-	tristate '    ROUTE target support'
-	depends on IP6_NF_MANGLE
diff -Nru ROUTE.orig/linux/net/ipv6/netfilter/Makefile.ladd ROUTE/linux/n=
et/ipv6/netfilter/Makefile.ladd
--- ROUTE.orig/linux/net/ipv6/netfilter/Makefile.ladd	2003-12-20 17:43:09=
.000000000 +0100
+++ ROUTE/linux/net/ipv6/netfilter/Makefile.ladd	1970-01-01 01:00:00.0000=
00000 +0100
@@ -1,2 +0,0 @@
-obj-$(CONFIG_IP6_NF_TARGET_MARK) +=3D ip6t_MARK.o
-obj-$(CONFIG_IP6_NF_TARGET_ROUTE) +=3D ip6t_ROUTE.o
diff -Nru ROUTE.orig/linux-2.4/Documentation/Configure.help.ladd ROUTE/li=
nux-2.4/Documentation/Configure.help.ladd
--- ROUTE.orig/linux-2.4/Documentation/Configure.help.ladd	1970-01-01 01:=
00:00.000000000 +0100
+++ ROUTE/linux-2.4/Documentation/Configure.help.ladd	2004-02-19 12:30:08=
.000000000 +0100
@@ -0,0 +1,16 @@
+CONFIG_IP_NF_TARGET_MARK
+ROUTE target support
+CONFIG_IP_NF_TARGET_ROUTE
+  This option adds a `ROUTE' target, which enables you to setup unusual
+  routes. For example, the ROUTE lets you route a received packet throug=
h=20
+  an interface or towards a host, even if the regular destination of the=
=20
+  packet is the router itself. The ROUTE target is also able to change t=
he=20
+  incoming interface of a packet.
+
+  The target can be or not a final target. It has to be used inside the=20
+  mangle table.
+ =20
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  The module will be called ipt_ROUTE.o.
+  If unsure, say `N'.
+
diff -Nru ROUTE.orig/linux-2.4/Documentation/Configure.help.ladd_2 ROUTE/=
linux-2.4/Documentation/Configure.help.ladd_2
--- ROUTE.orig/linux-2.4/Documentation/Configure.help.ladd_2	1970-01-01 0=
1:00:00.000000000 +0100
+++ ROUTE/linux-2.4/Documentation/Configure.help.ladd_2	2004-03-05 10:30:=
26.000000000 +0100
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
diff -Nru ROUTE.orig/linux-2.4/include/linux/netfilter_ipv4/ipt_ROUTE.h R=
OUTE/linux-2.4/include/linux/netfilter_ipv4/ipt_ROUTE.h
--- ROUTE.orig/linux-2.4/include/linux/netfilter_ipv4/ipt_ROUTE.h	1970-01=
-01 01:00:00.000000000 +0100
+++ ROUTE/linux-2.4/include/linux/netfilter_ipv4/ipt_ROUTE.h	2003-12-18 1=
9:47:54.000000000 +0100
@@ -0,0 +1,22 @@
+/* Header file for iptables ipt_ROUTE target
+ *
+ * (C) 2002 by C=E9dric de Launois <delaunois@info.ucl.ac.be>
+ *
+ * This software is distributed under GNU GPL v2, 1991
+ */
+#ifndef _IPT_ROUTE_H_target
+#define _IPT_ROUTE_H_target
+
+#define IPT_ROUTE_IFNAMSIZ 16
+
+struct ipt_route_target_info {
+	char      oif[IPT_ROUTE_IFNAMSIZ];      /* Output Interface Name */
+	char      iif[IPT_ROUTE_IFNAMSIZ];      /* Input Interface Name  */
+	u_int32_t gw;                           /* IP address of gateway */
+	u_int8_t  flags;
+};
+
+/* Values for "flags" field */
+#define IPT_ROUTE_CONTINUE        0x01
+
+#endif /*_IPT_ROUTE_H_target*/
diff -Nru ROUTE.orig/linux-2.4/include/linux/netfilter_ipv6/ip6t_ROUTE.h =
ROUTE/linux-2.4/include/linux/netfilter_ipv6/ip6t_ROUTE.h
--- ROUTE.orig/linux-2.4/include/linux/netfilter_ipv6/ip6t_ROUTE.h	1970-0=
1-01 01:00:00.000000000 +0100
+++ ROUTE/linux-2.4/include/linux/netfilter_ipv6/ip6t_ROUTE.h	2003-12-20 =
17:43:09.000000000 +0100
@@ -0,0 +1,22 @@
+/* Header file for iptables ip6t_ROUTE target
+ *
+ * (C) 2003 by C=E9dric de Launois <delaunois@info.ucl.ac.be>
+ *
+ * This software is distributed under GNU GPL v2, 1991
+ */
+#ifndef _IPT_ROUTE_H_target
+#define _IPT_ROUTE_H_target
+
+#define IP6T_ROUTE_IFNAMSIZ 16
+
+struct ip6t_route_target_info {
+	char      oif[IP6T_ROUTE_IFNAMSIZ];     /* Output Interface Name */
+	char      iif[IP6T_ROUTE_IFNAMSIZ];     /* Input Interface Name  */
+	u_int32_t gw[4];                        /* IPv6 address of gateway */
+	u_int8_t  flags;
+};
+
+/* Values for "flags" field */
+#define IP6T_ROUTE_CONTINUE        0x01
+
+#endif /*_IP6T_ROUTE_H_target*/
diff -Nru ROUTE.orig/linux-2.4/net/ipv4/netfilter/Config.in.ladd ROUTE/li=
nux-2.4/net/ipv4/netfilter/Config.in.ladd
--- ROUTE.orig/linux-2.4/net/ipv4/netfilter/Config.in.ladd	1970-01-01 01:=
00:00.000000000 +0100
+++ ROUTE/linux-2.4/net/ipv4/netfilter/Config.in.ladd	2003-12-18 19:47:54=
.000000000 +0100
@@ -0,0 +1,3 @@
+    dep_tristate '    MARK target support' CONFIG_IP_NF_TARGET_MARK $CON=
FIG_IP_NF_MANGLE
+    dep_tristate '    ROUTE target support' CONFIG_IP_NF_TARGET_ROUTE $C=
ONFIG_IP_NF_MANGLE
+=20
\ Pas de fin de ligne =E0 la fin du fichier.
diff -Nru ROUTE.orig/linux-2.4/net/ipv4/netfilter/ipt_ROUTE.c ROUTE/linux=
-2.4/net/ipv4/netfilter/ipt_ROUTE.c
--- ROUTE.orig/linux-2.4/net/ipv4/netfilter/ipt_ROUTE.c	1970-01-01 01:00:=
00.000000000 +0100
+++ ROUTE/linux-2.4/net/ipv4/netfilter/ipt_ROUTE.c	2003-12-18 19:47:54.00=
0000000 +0100
@@ -0,0 +1,369 @@
+/*
+ * This implements the ROUTE target, which enables you to setup unusual
+ * routes not supported by the standard kernel routing table.
+ *
+ * Copyright (C) 2002 Cedric de Launois <delaunois@info.ucl.ac.be>
+ *
+ * v 1.8 2003/07/25
+ *
+ * This software is distributed under GNU GPL v2, 1991
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_ROUTE.h>
+#include <linux/netdevice.h>
+#include <linux/route.h>
+#include <net/ip.h>
+#include <net/route.h>
+#include <net/icmp.h>
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+
+/* Try to route the packet according to the routing keys specified in
+ * route_info. Keys are :
+ *  - ifindex :=20
+ *      0 if no oif preferred,=20
+ *      otherwise set to the index of the desired oif
+ *  - route_info->gw :
+ *      0 if no gateway specified,
+ *      otherwise set to the next host to which the pkt must be routed
+ * If success, skb->dev is the output device to which the packet must=20
+ * be sent and skb->dst is not NULL
+ *
+ * RETURN: -1 if an error occured
+ *          1 if the packet was succesfully routed to the=20
+ *            destination desired
+ *          0 if the kernel routing table could not route the packet
+ *            according to the keys specified
+ */
+static int route(struct sk_buff *skb,
+		 unsigned int ifindex,
+		 const struct ipt_route_target_info *route_info)
+{
+	int err;
+	struct rtable *rt;
+	struct iphdr *iph =3D skb->nh.iph;
+	struct rt_key key =3D {=20
+		dst:iph->daddr,
+		src:0,
+		oif:ifindex,=20
+		tos:RT_TOS(iph->tos)=20
+	};
+=09
+	/* The destination address may be overloaded by the target */
+	if (route_info->gw)
+		key.dst =3D route_info->gw;
+=09
+	/* Trying to route the packet using the standard routing table. */
+	if ((err =3D ip_route_output_key(&rt, &key))) {
+		if (net_ratelimit())=20
+			DEBUGP("ipt_ROUTE: couldn't route pkt (err: %i)",err);
+		return -1;
+	}
+=09
+	/* Drop old route. */
+	dst_release(skb->dst);
+	skb->dst =3D NULL;
+
+	/* Success if no oif specified or if the oif correspond to the=20
+	 * one desired */
+	if (!ifindex || rt->u.dst.dev->ifindex =3D=3D ifindex) {
+		skb->dst =3D &rt->u.dst;
+		skb->dev =3D skb->dst->dev;
+		return 1;
+	}
+=09
+	/* The interface selected by the routing table is not the one
+	 * specified by the user. This may happen because the dst address
+	 * is one of our own addresses.
+	 */
+	if (net_ratelimit())=20
+		DEBUGP("ipt_ROUTE: failed to route as desired gw=3D%u.%u.%u.%u oif=3D%=
i (got oif=3D%i)\n",=20
+		       NIPQUAD(route_info->gw), ifindex, rt->u.dst.dev->ifindex);
+=09
+	return 0;
+}
+
+
+/* Stolen from ip_finish_output2
+ * PRE : skb->dev is set to the device we are leaving by
+ *       skb->dst is not NULL
+ * POST: the packet is sent with the link layer header pushed
+ *       the packet is destroyed
+ */
+static void ip_direct_send(struct sk_buff *skb)
+{
+	struct dst_entry *dst =3D skb->dst;
+	struct hh_cache *hh =3D dst->hh;
+
+	if (hh) {
+		read_lock_bh(&hh->hh_lock);
+		memcpy(skb->data - 16, hh->hh_data, 16);
+		read_unlock_bh(&hh->hh_lock);
+		skb_push(skb, hh->hh_len);
+		hh->hh_output(skb);
+	} else if (dst->neighbour)
+		dst->neighbour->output(skb);
+	else {
+		if (net_ratelimit())
+			DEBUGP(KERN_DEBUG "ipt_ROUTE: no hdr & no neighbour cache!\n");
+		kfree_skb(skb);
+	}
+}
+
+
+/* PRE : skb->dev is set to the device we are leaving by
+ * POST: - the packet is directly sent to the skb->dev device, without=20
+ *         pushing the link layer header.
+ *       - the packet is destroyed
+ */
+static inline int dev_direct_send(struct sk_buff *skb)
+{
+	return dev_queue_xmit(skb);
+}
+
+
+static unsigned int route_oif(const struct ipt_route_target_info *route_=
info,
+			      struct sk_buff *skb)=20
+{
+	unsigned int ifindex =3D 0;
+	struct net_device *dev_out =3D NULL;
+
+	/* The user set the interface name to use.
+	 * Getting the current interface index.
+	 */
+	if ((dev_out =3D dev_get_by_name(route_info->oif))) {
+		ifindex =3D dev_out->ifindex;
+	} else {
+		/* Unknown interface name : packet dropped */
+		if (net_ratelimit())=20
+			DEBUGP("ipt_ROUTE: oif interface %s not found\n", route_info->oif);
+		return NF_DROP;
+	}
+
+	/* Trying the standard way of routing packets */
+	switch (route(skb, ifindex, route_info)) {
+	case 1:
+		dev_put(dev_out);
+		if (route_info->flags & IPT_ROUTE_CONTINUE)
+			return IPT_CONTINUE;
+
+		ip_direct_send(skb);
+		return NF_STOLEN;
+
+	case 0:
+		/* Failed to send to oif. Trying the hard way */
+		if (route_info->flags & IPT_ROUTE_CONTINUE)
+			return NF_DROP;
+
+		if (net_ratelimit())=20
+			DEBUGP("ipt_ROUTE: forcing the use of %i\n",
+			       ifindex);
+
+		/* We have to force the use of an interface.
+		 * This interface must be a tunnel interface since
+		 * otherwise we can't guess the hw address for
+		 * the packet. For a tunnel interface, no hw address
+		 * is needed.
+		 */
+		if ((dev_out->type !=3D ARPHRD_TUNNEL)
+		    && (dev_out->type !=3D ARPHRD_IPGRE)) {
+			if (net_ratelimit())=20
+				DEBUGP("ipt_ROUTE: can't guess the hw addr !\n");
+			dev_put(dev_out);
+			return NF_DROP;
+		}
+=09
+		/* Send the packet. This will also free skb
+		 * Do not go through the POST_ROUTING hook because=20
+		 * skb->dst is not set and because it will probably
+		 * get confused by the destination IP address.
+		 */
+		skb->dev =3D dev_out;
+		dev_direct_send(skb);
+		dev_put(dev_out);
+		return NF_STOLEN;
+	=09
+	default:
+		/* Unexpected error */
+		dev_put(dev_out);
+		return NF_DROP;
+	}
+}
+
+
+static unsigned int route_iif(const struct ipt_route_target_info *route_=
info,
+			      struct sk_buff *skb)=20
+{
+	struct net_device *dev_out =3D NULL;
+	unsigned int ifindex =3D 0;
+
+	/* Getting the current interface index. */
+	if ((dev_out =3D dev_get_by_name(route_info->iif)))
+		ifindex =3D dev_out->ifindex;
+	else {
+		/* Unknown interface name : packet dropped */
+		if (net_ratelimit())=20
+			DEBUGP("ipt_ROUTE: iif interface %s not found\n", route_info->oif);
+		return NF_DROP;
+	}
+
+	skb->dev =3D dev_out;
+	dst_release(skb->dst);
+	skb->dst =3D NULL;
+	=09
+	netif_rx(skb);
+
+	return NF_STOLEN;
+}
+
+
+static unsigned int route_gw(const struct ipt_route_target_info *route_i=
nfo,
+			     struct sk_buff *skb)=20
+{
+	if (route(skb, 0, route_info)!=3D1)
+		return NF_DROP;
+
+	if (route_info->flags & IPT_ROUTE_CONTINUE)
+		return IPT_CONTINUE;
+
+	ip_direct_send(skb);
+	return NF_STOLEN;
+}
+
+
+static unsigned int ipt_route_target(struct sk_buff **pskb,
+				     unsigned int hooknum,
+				     const struct net_device *in,
+				     const struct net_device *out,
+				     const void *targinfo,
+				     void *userinfo)
+{
+	const struct ipt_route_target_info *route_info =3D targinfo;
+	struct sk_buff *skb =3D *pskb;
+
+	/* If we are at PREROUTING or INPUT hook
+	 * the TTL isn't decreased by the IP stack
+	 */
+	if (hooknum =3D=3D NF_IP_PRE_ROUTING ||
+	    hooknum =3D=3D NF_IP_LOCAL_IN) {
+
+		struct iphdr *iph =3D skb->nh.iph;
+
+		if (iph->ttl <=3D 1) {
+			struct rtable *rt;
+
+			if (ip_route_output(&rt, iph->saddr, iph->daddr,
+					    RT_TOS(iph->tos) | RTO_CONN,
+					    0)) {
+				return NF_DROP;
+			}
+
+			if (skb->dev =3D=3D rt->u.dst.dev) {
+				/* Drop old route. */
+				dst_release(skb->dst);
+				skb->dst =3D &rt->u.dst;
+
+				/* this will traverse normal stack, and=20
+				 * thus call conntrack on the icmp packet */
+				icmp_send(skb, ICMP_TIME_EXCEEDED,=20
+					  ICMP_EXC_TTL, 0);
+			}
+
+			return NF_DROP;
+		}
+
+		ip_decrease_ttl(iph);
+	}
+
+	/* Tell conntrack to forget this packet since it may get confused=20
+	 * when a packet is leaving with dst address =3D=3D our address.
+	 * Good idea ? Dunno. Need advice.
+	 */
+	if (!(route_info->flags & IPT_ROUTE_CONTINUE)) {
+		nf_conntrack_put(skb->nfct);
+		skb->nfct =3D NULL;
+		skb->nfcache =3D 0;
+#ifdef CONFIG_NETFILTER_DEBUG
+		skb->nf_debug =3D 0;
+#endif
+	}
+
+	if (route_info->oif[0])=20
+		return route_oif(route_info, *pskb);
+=09
+	if (route_info->iif[0])=20
+		return route_iif(route_info, *pskb);
+
+	if (route_info->gw)=20
+		return route_gw(route_info, *pskb);
+
+	if (net_ratelimit())=20
+		DEBUGP(KERN_DEBUG "ipt_ROUTE: no parameter !\n");
+
+	return IPT_CONTINUE;
+}
+
+
+static int ipt_route_checkentry(const char *tablename,
+				const struct ipt_entry *e,
+				void *targinfo,
+				unsigned int targinfosize,
+				unsigned int hook_mask)
+{
+	if (strcmp(tablename, "mangle") !=3D 0) {
+		printk("ipt_ROUTE: bad table `%s', use the `mangle' table.\n",
+		       tablename);
+		return 0;
+	}
+
+	if (hook_mask & ~(  (1 << NF_IP_PRE_ROUTING)
+			    | (1 << NF_IP_LOCAL_IN)
+			    | (1 << NF_IP_FORWARD)
+			    | (1 << NF_IP_LOCAL_OUT)
+			    | (1 << NF_IP_POST_ROUTING))) {
+		printk("ipt_ROUTE: bad hook\n");
+		return 0;
+	}
+
+	if (targinfosize !=3D IPT_ALIGN(sizeof(struct ipt_route_target_info))) =
{
+		printk(KERN_WARNING "ipt_ROUTE: targinfosize %u !=3D %Zu\n",
+		       targinfosize,
+		       IPT_ALIGN(sizeof(struct ipt_route_target_info)));
+		return 0;
+	}
+
+	return 1;
+}
+
+
+static struct ipt_target ipt_route_reg
+=3D { { NULL, NULL }, "ROUTE", ipt_route_target, ipt_route_checkentry, N=
ULL,
+    THIS_MODULE };
+
+
+static int __init init(void)
+{
+	if (ipt_register_target(&ipt_route_reg))
+		return -EINVAL;
+
+	return 0;
+}
+
+
+static void __exit fini(void)
+{
+	ipt_unregister_target(&ipt_route_reg);
+}
+
+module_init(init);
+module_exit(fini);
+MODULE_LICENSE("GPL");
diff -Nru ROUTE.orig/linux-2.4/net/ipv4/netfilter/Makefile.ladd ROUTE/lin=
ux-2.4/net/ipv4/netfilter/Makefile.ladd
--- ROUTE.orig/linux-2.4/net/ipv4/netfilter/Makefile.ladd	1970-01-01 01:0=
0:00.000000000 +0100
+++ ROUTE/linux-2.4/net/ipv4/netfilter/Makefile.ladd	2003-12-18 19:47:54.=
000000000 +0100
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_TARGET_REDIRECT) +=3D ipt_REDIRECT.o
+obj-$(CONFIG_IP_NF_TARGET_ROUTE) +=3D ipt_ROUTE.o
diff -Nru ROUTE.orig/linux-2.4/net/ipv6/netfilter/Config.in.ladd ROUTE/li=
nux-2.4/net/ipv6/netfilter/Config.in.ladd
--- ROUTE.orig/linux-2.4/net/ipv6/netfilter/Config.in.ladd	1970-01-01 01:=
00:00.000000000 +0100
+++ ROUTE/linux-2.4/net/ipv6/netfilter/Config.in.ladd	2003-12-20 17:43:09=
.000000000 +0100
@@ -0,0 +1,2 @@
+    dep_tristate '    MARK target support' CONFIG_IP6_NF_TARGET_MARK $CO=
NFIG_IP6_NF_MANGLE
+    dep_mbool '    ROUTE target support' CONFIG_IP6_NF_TARGET_ROUTE $CON=
FIG_IP6_NF_MANGLE
\ Pas de fin de ligne =E0 la fin du fichier.
diff -Nru ROUTE.orig/linux-2.4/net/ipv6/netfilter/CVS/Entries ROUTE/linux=
-2.4/net/ipv6/netfilter/CVS/Entries
--- ROUTE.orig/linux-2.4/net/ipv6/netfilter/CVS/Entries	1970-01-01 01:00:=
00.000000000 +0100
+++ ROUTE/linux-2.4/net/ipv6/netfilter/CVS/Entries	2004-03-08 10:06:41.00=
0000000 +0100
@@ -0,0 +1,5 @@
+/Config.in.ladd/1.1/Sat Dec 20 16:43:09 2003//
+/Kconfig.ladd/1.1/Tue Dec 23 11:41:11 2003//
+/Makefile.ladd/1.1/Sat Dec 20 16:43:09 2003//
+/ip6t_ROUTE.c/1.1/Sat Dec 20 16:43:09 2003//
+D
diff -Nru ROUTE.orig/linux-2.4/net/ipv6/netfilter/CVS/Repository ROUTE/li=
nux-2.4/net/ipv6/netfilter/CVS/Repository
--- ROUTE.orig/linux-2.4/net/ipv6/netfilter/CVS/Repository	1970-01-01 01:=
00:00.000000000 +0100
+++ ROUTE/linux-2.4/net/ipv6/netfilter/CVS/Repository	2004-03-08 10:06:41=
.000000000 +0100
@@ -0,0 +1 @@
+patch-o-matic-ng/ROUTE/linux/net/ipv6/netfilter
diff -Nru ROUTE.orig/linux-2.4/net/ipv6/netfilter/CVS/Root ROUTE/linux-2.=
4/net/ipv6/netfilter/CVS/Root
--- ROUTE.orig/linux-2.4/net/ipv6/netfilter/CVS/Root	1970-01-01 01:00:00.=
000000000 +0100
+++ ROUTE/linux-2.4/net/ipv6/netfilter/CVS/Root	2004-03-08 10:06:41.00000=
0000 +0100
@@ -0,0 +1 @@
+:pserver:cvs:cvs@pserver.netfilter.org:/cvspublic
diff -Nru ROUTE.orig/linux-2.4/net/ipv6/netfilter/ip6t_ROUTE.c ROUTE/linu=
x-2.4/net/ipv6/netfilter/ip6t_ROUTE.c
--- ROUTE.orig/linux-2.4/net/ipv6/netfilter/ip6t_ROUTE.c	1970-01-01 01:00=
:00.000000000 +0100
+++ ROUTE/linux-2.4/net/ipv6/netfilter/ip6t_ROUTE.c	2003-12-20 17:43:09.0=
00000000 +0100
@@ -0,0 +1,289 @@
+/*
+ * This implements the ROUTE v6 target, which enables you to setup unusu=
al
+ * routes not supported by the standard kernel routing table.
+ *
+ * Copyright (C) 2003 Cedric de Launois <delaunois@info.ucl.ac.be>
+ *
+ * v 1.0 2003/08/05
+ *
+ * This software is distributed under GNU GPL v2, 1991
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ipv6.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_ROUTE.h>
+#include <linux/netdevice.h>
+#include <net/ipv6.h>
+#include <net/ndisc.h>
+#include <net/ip6_route.h>
+#include <linux/icmpv6.h>
+
+#if 1
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+#define NIP6(addr) \
+	ntohs((addr).s6_addr16[0]), \
+	ntohs((addr).s6_addr16[1]), \
+	ntohs((addr).s6_addr16[2]), \
+	ntohs((addr).s6_addr16[3]), \
+	ntohs((addr).s6_addr16[4]), \
+	ntohs((addr).s6_addr16[5]), \
+	ntohs((addr).s6_addr16[6]), \
+	ntohs((addr).s6_addr16[7])
+
+/* Route the packet according to the routing keys specified in
+ * route_info. Keys are :
+ *  - ifindex :=20
+ *      0 if no oif preferred,=20
+ *      otherwise set to the index of the desired oif
+ *  - route_info->gw :
+ *      0 if no gateway specified,
+ *      otherwise set to the next host to which the pkt must be routed
+ * If success, skb->dev is the output device to which the packet must=20
+ * be sent and skb->dst is not NULL
+ *
+ * RETURN:  1 if the packet was succesfully routed to the=20
+ *            destination desired
+ *          0 if the kernel routing table could not route the packet
+ *            according to the keys specified
+ */
+static int=20
+route6(struct sk_buff *skb,
+       unsigned int ifindex,
+       const struct ip6t_route_target_info *route_info)
+{
+	struct rt6_info *rt =3D NULL;
+	struct ipv6hdr *ipv6h =3D skb->nh.ipv6h;
+	struct in6_addr *gw =3D (struct in6_addr*)&route_info->gw;
+
+	DEBUGP("ip6t_ROUTE: called with: ");
+	DEBUGP("DST=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(ipv6h->da=
ddr));
+	DEBUGP("GATEWAY=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(*gw))=
;
+	DEBUGP("OUT=3D%s\n", route_info->oif);
+=09
+	if (ipv6_addr_any(gw))
+		rt =3D rt6_lookup(&ipv6h->daddr, &ipv6h->saddr, ifindex, 1);
+	else
+		rt =3D rt6_lookup(gw, &ipv6h->saddr, ifindex, 1);
+
+	if (!rt)
+		goto no_route;
+
+	DEBUGP("ip6t_ROUTE: routing gives: ");
+	DEBUGP("DST=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(rt->rt6i_=
dst.addr));
+	DEBUGP("GATEWAY=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(rt->r=
t6i_gateway));
+	DEBUGP("OUT=3D%s\n", rt->rt6i_dev->name);
+
+	if (ifindex && rt->rt6i_dev->ifindex!=3Difindex)
+		goto wrong_route;
+=09
+	if (!rt->rt6i_nexthop) {
+		DEBUGP("ip6t_ROUTE: discovering neighbour\n");
+		rt->rt6i_nexthop =3D ndisc_get_neigh(rt->rt6i_dev, &rt->rt6i_dst.addr)=
;
+	}
+
+	/* Drop old route. */
+	dst_release(skb->dst);
+	skb->dst =3D &rt->u.dst;
+	skb->dev =3D rt->rt6i_dev;
+	return 1;
+
+ wrong_route:
+	dst_release(&rt->u.dst);
+ no_route:
+	if (!net_ratelimit())
+		return 0;
+
+	printk("ip6t_ROUTE: no explicit route found ");
+	if (ifindex)
+		printk("via interface %s ", route_info->oif);
+	if (!ipv6_addr_any(gw))
+		printk("via gateway %04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x", NIP6(*gw=
));
+	printk("\n");
+	return 0;
+}
+
+
+/* Stolen from ip6_output_finish
+ * PRE : skb->dev is set to the device we are leaving by
+ *       skb->dst is not NULL
+ * POST: the packet is sent with the link layer header pushed
+ *       the packet is destroyed
+ */
+static void ip_direct_send(struct sk_buff *skb)
+{
+	struct dst_entry *dst =3D skb->dst;
+	struct hh_cache *hh =3D dst->hh;
+
+	if (hh) {
+		read_lock_bh(&hh->hh_lock);
+		memcpy(skb->data - 16, hh->hh_data, 16);
+		read_unlock_bh(&hh->hh_lock);
+		skb_push(skb, hh->hh_len);
+		hh->hh_output(skb);
+	} else if (dst->neighbour)
+		dst->neighbour->output(skb);
+	else {
+		if (net_ratelimit())
+			DEBUGP(KERN_DEBUG "ip6t_ROUTE: no hdr & no neighbour cache!\n");
+		kfree_skb(skb);
+	}
+}
+
+
+static unsigned int=20
+route6_oif(const struct ip6t_route_target_info *route_info,
+	   struct sk_buff *skb)=20
+{
+	unsigned int ifindex =3D 0;
+	struct net_device *dev_out =3D NULL;
+
+	/* The user set the interface name to use.
+	 * Getting the current interface index.
+	 */
+	if ((dev_out =3D dev_get_by_name(route_info->oif))) {
+		ifindex =3D dev_out->ifindex;
+	} else {
+		/* Unknown interface name : packet dropped */
+		if (net_ratelimit())=20
+			DEBUGP("ip6t_ROUTE: oif interface %s not found\n", route_info->oif);
+
+		if (route_info->flags & IP6T_ROUTE_CONTINUE)
+			return IP6T_CONTINUE;
+		else
+			return NF_DROP;
+	}
+
+	/* Trying the standard way of routing packets */
+	if (route6(skb, ifindex, route_info)) {
+		dev_put(dev_out);
+		if (route_info->flags & IP6T_ROUTE_CONTINUE)
+			return IP6T_CONTINUE;
+	=09
+		ip_direct_send(skb);
+		return NF_STOLEN;
+	} else=20
+		return NF_DROP;
+}
+
+
+static unsigned int=20
+route6_gw(const struct ip6t_route_target_info *route_info,
+	  struct sk_buff *skb)=20
+{
+	if (route6(skb, 0, route_info)) {
+		if (route_info->flags & IP6T_ROUTE_CONTINUE)
+			return IP6T_CONTINUE;
+
+		ip_direct_send(skb);
+		return NF_STOLEN;
+	} else
+		return NF_DROP;
+}
+
+
+static unsigned int=20
+ip6t_route_target(struct sk_buff **pskb,
+		  unsigned int hooknum,
+		  const struct net_device *in,
+		  const struct net_device *out,
+		  const void *targinfo,
+		  void *userinfo)
+{
+	const struct ip6t_route_target_info *route_info =3D targinfo;
+	struct sk_buff *skb =3D *pskb;
+	struct in6_addr *gw =3D (struct in6_addr*)&route_info->gw;
+
+	if (route_info->flags & IP6T_ROUTE_CONTINUE)
+		goto do_it;
+
+	/* If we are at PREROUTING or INPUT hook
+	 * the TTL isn't decreased by the IP stack
+	 */
+	if (hooknum =3D=3D NF_IP6_PRE_ROUTING ||
+	    hooknum =3D=3D NF_IP6_LOCAL_IN) {
+
+		struct ipv6hdr *ipv6h =3D skb->nh.ipv6h;
+
+		if (ipv6h->hop_limit <=3D 1) {
+			/* Force OUTPUT device used as source address */
+			skb->dev =3D skb->dst->dev;
+
+			icmpv6_send(skb, ICMPV6_TIME_EXCEED,=20
+				    ICMPV6_EXC_HOPLIMIT, 0, skb->dev);
+
+			return NF_DROP;
+		}
+
+		ipv6h->hop_limit--;
+	}
+
+
+ do_it:
+	if (route_info->oif[0])=20
+		return route6_oif(route_info, *pskb);
+=09
+	if (!ipv6_addr_any(gw))
+		return route6_gw(route_info, *pskb);
+
+	if (net_ratelimit())=20
+		DEBUGP(KERN_DEBUG "ip6t_ROUTE: no parameter !\n");
+
+	return IP6T_CONTINUE;
+}
+
+
+static int=20
+ip6t_route_checkentry(const char *tablename,
+		      const struct ip6t_entry *e,
+		      void *targinfo,
+		      unsigned int targinfosize,
+		      unsigned int hook_mask)
+{
+	if (strcmp(tablename, "mangle") !=3D 0) {
+		printk("ip6t_ROUTE: can only be called from \"mangle\" table.\n");
+		return 0;
+	}
+
+	if (targinfosize !=3D IP6T_ALIGN(sizeof(struct ip6t_route_target_info))=
) {
+		printk(KERN_WARNING "ip6t_ROUTE: targinfosize %u !=3D %Zu\n",
+		       targinfosize,
+		       IP6T_ALIGN(sizeof(struct ip6t_route_target_info)));
+		return 0;
+	}
+
+	return 1;
+}
+
+
+static struct ip6t_target ip6t_route_reg =3D {
+	.name       =3D "ROUTE",
+	.target     =3D ip6t_route_target,
+	.checkentry =3D ip6t_route_checkentry,
+	.me         =3D THIS_MODULE
+};
+
+
+static int __init init(void)
+{
+	printk(KERN_DEBUG "registering ipv6 ROUTE target\n");
+	if (ip6t_register_target(&ip6t_route_reg))
+		return -EINVAL;
+
+	return 0;
+}
+
+
+static void __exit fini(void)
+{
+	ip6t_unregister_target(&ip6t_route_reg);
+}
+
+module_init(init);
+module_exit(fini);
+MODULE_LICENSE("GPL");
diff -Nru ROUTE.orig/linux-2.4/net/ipv6/netfilter/Makefile.ladd ROUTE/lin=
ux-2.4/net/ipv6/netfilter/Makefile.ladd
--- ROUTE.orig/linux-2.4/net/ipv6/netfilter/Makefile.ladd	1970-01-01 01:0=
0:00.000000000 +0100
+++ ROUTE/linux-2.4/net/ipv6/netfilter/Makefile.ladd	2003-12-20 17:43:09.=
000000000 +0100
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP6_NF_TARGET_MARK) +=3D ip6t_MARK.o
+obj-$(CONFIG_IP6_NF_TARGET_ROUTE) +=3D ip6t_ROUTE.o
diff -Nru ROUTE.orig/linux-2.6/include/linux/netfilter_ipv4/ipt_ROUTE.h R=
OUTE/linux-2.6/include/linux/netfilter_ipv4/ipt_ROUTE.h
--- ROUTE.orig/linux-2.6/include/linux/netfilter_ipv4/ipt_ROUTE.h	1970-01=
-01 01:00:00.000000000 +0100
+++ ROUTE/linux-2.6/include/linux/netfilter_ipv4/ipt_ROUTE.h	2003-12-18 1=
9:47:54.000000000 +0100
@@ -0,0 +1,22 @@
+/* Header file for iptables ipt_ROUTE target
+ *
+ * (C) 2002 by C=E9dric de Launois <delaunois@info.ucl.ac.be>
+ *
+ * This software is distributed under GNU GPL v2, 1991
+ */
+#ifndef _IPT_ROUTE_H_target
+#define _IPT_ROUTE_H_target
+
+#define IPT_ROUTE_IFNAMSIZ 16
+
+struct ipt_route_target_info {
+	char      oif[IPT_ROUTE_IFNAMSIZ];      /* Output Interface Name */
+	char      iif[IPT_ROUTE_IFNAMSIZ];      /* Input Interface Name  */
+	u_int32_t gw;                           /* IP address of gateway */
+	u_int8_t  flags;
+};
+
+/* Values for "flags" field */
+#define IPT_ROUTE_CONTINUE        0x01
+
+#endif /*_IPT_ROUTE_H_target*/
diff -Nru ROUTE.orig/linux-2.6/include/linux/netfilter_ipv6/ip6t_ROUTE.h =
ROUTE/linux-2.6/include/linux/netfilter_ipv6/ip6t_ROUTE.h
--- ROUTE.orig/linux-2.6/include/linux/netfilter_ipv6/ip6t_ROUTE.h	1970-0=
1-01 01:00:00.000000000 +0100
+++ ROUTE/linux-2.6/include/linux/netfilter_ipv6/ip6t_ROUTE.h	2003-12-20 =
17:43:09.000000000 +0100
@@ -0,0 +1,22 @@
+/* Header file for iptables ip6t_ROUTE target
+ *
+ * (C) 2003 by C=E9dric de Launois <delaunois@info.ucl.ac.be>
+ *
+ * This software is distributed under GNU GPL v2, 1991
+ */
+#ifndef _IPT_ROUTE_H_target
+#define _IPT_ROUTE_H_target
+
+#define IP6T_ROUTE_IFNAMSIZ 16
+
+struct ip6t_route_target_info {
+	char      oif[IP6T_ROUTE_IFNAMSIZ];     /* Output Interface Name */
+	char      iif[IP6T_ROUTE_IFNAMSIZ];     /* Input Interface Name  */
+	u_int32_t gw[4];                        /* IPv6 address of gateway */
+	u_int8_t  flags;
+};
+
+/* Values for "flags" field */
+#define IP6T_ROUTE_CONTINUE        0x01
+
+#endif /*_IP6T_ROUTE_H_target*/
diff -Nru ROUTE.orig/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c ROUTE/linux=
-2.6/net/ipv4/netfilter/ipt_ROUTE.c
--- ROUTE.orig/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	2004-02-22 18:29:=
10.000000000 +0100
+++ ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	2004-03-08 15:19:07.00=
0000000 +0100
@@ -19,6 +19,7 @@
 #include <net/ip.h>
 #include <net/route.h>
 #include <net/icmp.h>
+#include <net/checksum.h>
=20
 #if 0
 #define DEBUGP printk
@@ -28,6 +29,7 @@
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Cedric de Launois <delaunois@info.ucl.ac.be>");
+MODULE_DESCRIPTION("iptables ROUTE target module");
=20
 /* Try to route the packet according to the routing keys specified in
  * route_info. Keys are :
@@ -53,19 +55,24 @@
 	int err;
 	struct rtable *rt;
 	struct iphdr *iph =3D skb->nh.iph;
-	struct rt_key key =3D {=20
-		dst:iph->daddr,
-		src:0,
-		oif:ifindex,=20
-		tos:RT_TOS(iph->tos)=20
+	struct flowi fl =3D {
+		.oif =3D ifindex,
+		.nl_u =3D {
+			.ip4_u =3D {
+				.daddr =3D iph->daddr,
+				.saddr =3D 0,
+				.tos =3D RT_TOS(iph->tos),
+				.scope =3D RT_SCOPE_UNIVERSE,
+			}
+		}=20
 	};
 =09
 	/* The destination address may be overloaded by the target */
 	if (route_info->gw)
-		key.dst =3D route_info->gw;
+		fl.fld_dst =3D route_info->gw;
 =09
 	/* Trying to route the packet using the standard routing table. */
-	if ((err =3D ip_route_output_key(&rt, &key))) {
+	if ((err =3D ip_route_output_key(&rt, &fl))) {
 		if (net_ratelimit())=20
 			DEBUGP("ipt_ROUTE: couldn't route pkt (err: %i)",err);
 		return -1;
@@ -262,10 +269,21 @@
=20
 		if (iph->ttl <=3D 1) {
 			struct rtable *rt;
+			struct flowi fl =3D {
+				.oif =3D 0,
+				.nl_u =3D {
+					.ip4_u =3D {
+						.daddr =3D iph->daddr,
+						.saddr =3D iph->saddr,
+						.tos =3D RT_TOS(iph->tos),
+						.scope =3D ((iph->tos & RTO_ONLINK) ?
+							  RT_SCOPE_LINK :
+							  RT_SCOPE_UNIVERSE)
+					}
+				}=20
+			};
=20
-			if (ip_route_output(&rt, iph->saddr, iph->daddr,
-					    RT_TOS(iph->tos) | RTO_CONN,
-					    0)) {
+			if (ip_route_output_key(&rt, &fl)) {
 				return NF_DROP;
 			}
=20
@@ -284,6 +302,7 @@
 		}
=20
 		ip_decrease_ttl(iph);
+		iph->check =3D ip_fast_csum((unsigned char *)iph, iph->ihl);
 	}
=20
 	/* Tell conntrack to forget this packet since it may get confused=20
diff -Nru ROUTE.orig/linux-2.6/net/ipv4/netfilter/Kconfig.ladd ROUTE/linu=
x-2.6/net/ipv4/netfilter/Kconfig.ladd
--- ROUTE.orig/linux-2.6/net/ipv4/netfilter/Kconfig.ladd	1970-01-01 01:00=
:00.000000000 +0100
+++ ROUTE/linux-2.6/net/ipv4/netfilter/Kconfig.ladd	2004-03-08 14:02:45.0=
00000000 +0100
@@ -0,0 +1,16 @@
+config IP_NF_TARGET_ROUTE
+	tristate  'ROUTE target support'
+	depends on IP_NF_MANGLE
+	help
+	  This option adds a `ROUTE' target, which enables you to setup unusual
+	  routes. For example, the ROUTE lets you route a received packet throu=
gh=20
+	  an interface or towards a host, even if the regular destination of th=
e=20
+	  packet is the router itself. The ROUTE target is also able to change =
the=20
+	  incoming interface of a packet.
+=09
+	  The target can be or not a final target. It has to be used inside the=
=20
+	  mangle table.
+ =20
+	  If you want to compile it as a module, say M here and read
+	  Documentation/modules.txt.  The module will be called ipt_ROUTE.o.
+	  If unsure, say `N'.
diff -Nru ROUTE.orig/linux-2.6/net/ipv4/netfilter/Makefile.ladd ROUTE/lin=
ux-2.6/net/ipv4/netfilter/Makefile.ladd
--- ROUTE.orig/linux-2.6/net/ipv4/netfilter/Makefile.ladd	1970-01-01 01:0=
0:00.000000000 +0100
+++ ROUTE/linux-2.6/net/ipv4/netfilter/Makefile.ladd	2003-12-18 19:47:54.=
000000000 +0100
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_TARGET_REDIRECT) +=3D ipt_REDIRECT.o
+obj-$(CONFIG_IP_NF_TARGET_ROUTE) +=3D ipt_ROUTE.o
diff -Nru ROUTE.orig/linux-2.6/net/ipv6/netfilter/ip6t_ROUTE.c ROUTE/linu=
x-2.6/net/ipv6/netfilter/ip6t_ROUTE.c
--- ROUTE.orig/linux-2.6/net/ipv6/netfilter/ip6t_ROUTE.c	1970-01-01 01:00=
:00.000000000 +0100
+++ ROUTE/linux-2.6/net/ipv6/netfilter/ip6t_ROUTE.c	2003-12-20 17:43:09.0=
00000000 +0100
@@ -0,0 +1,289 @@
+/*
+ * This implements the ROUTE v6 target, which enables you to setup unusu=
al
+ * routes not supported by the standard kernel routing table.
+ *
+ * Copyright (C) 2003 Cedric de Launois <delaunois@info.ucl.ac.be>
+ *
+ * v 1.0 2003/08/05
+ *
+ * This software is distributed under GNU GPL v2, 1991
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ipv6.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_ROUTE.h>
+#include <linux/netdevice.h>
+#include <net/ipv6.h>
+#include <net/ndisc.h>
+#include <net/ip6_route.h>
+#include <linux/icmpv6.h>
+
+#if 1
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+#define NIP6(addr) \
+	ntohs((addr).s6_addr16[0]), \
+	ntohs((addr).s6_addr16[1]), \
+	ntohs((addr).s6_addr16[2]), \
+	ntohs((addr).s6_addr16[3]), \
+	ntohs((addr).s6_addr16[4]), \
+	ntohs((addr).s6_addr16[5]), \
+	ntohs((addr).s6_addr16[6]), \
+	ntohs((addr).s6_addr16[7])
+
+/* Route the packet according to the routing keys specified in
+ * route_info. Keys are :
+ *  - ifindex :=20
+ *      0 if no oif preferred,=20
+ *      otherwise set to the index of the desired oif
+ *  - route_info->gw :
+ *      0 if no gateway specified,
+ *      otherwise set to the next host to which the pkt must be routed
+ * If success, skb->dev is the output device to which the packet must=20
+ * be sent and skb->dst is not NULL
+ *
+ * RETURN:  1 if the packet was succesfully routed to the=20
+ *            destination desired
+ *          0 if the kernel routing table could not route the packet
+ *            according to the keys specified
+ */
+static int=20
+route6(struct sk_buff *skb,
+       unsigned int ifindex,
+       const struct ip6t_route_target_info *route_info)
+{
+	struct rt6_info *rt =3D NULL;
+	struct ipv6hdr *ipv6h =3D skb->nh.ipv6h;
+	struct in6_addr *gw =3D (struct in6_addr*)&route_info->gw;
+
+	DEBUGP("ip6t_ROUTE: called with: ");
+	DEBUGP("DST=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(ipv6h->da=
ddr));
+	DEBUGP("GATEWAY=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(*gw))=
;
+	DEBUGP("OUT=3D%s\n", route_info->oif);
+=09
+	if (ipv6_addr_any(gw))
+		rt =3D rt6_lookup(&ipv6h->daddr, &ipv6h->saddr, ifindex, 1);
+	else
+		rt =3D rt6_lookup(gw, &ipv6h->saddr, ifindex, 1);
+
+	if (!rt)
+		goto no_route;
+
+	DEBUGP("ip6t_ROUTE: routing gives: ");
+	DEBUGP("DST=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(rt->rt6i_=
dst.addr));
+	DEBUGP("GATEWAY=3D%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(rt->r=
t6i_gateway));
+	DEBUGP("OUT=3D%s\n", rt->rt6i_dev->name);
+
+	if (ifindex && rt->rt6i_dev->ifindex!=3Difindex)
+		goto wrong_route;
+=09
+	if (!rt->rt6i_nexthop) {
+		DEBUGP("ip6t_ROUTE: discovering neighbour\n");
+		rt->rt6i_nexthop =3D ndisc_get_neigh(rt->rt6i_dev, &rt->rt6i_dst.addr)=
;
+	}
+
+	/* Drop old route. */
+	dst_release(skb->dst);
+	skb->dst =3D &rt->u.dst;
+	skb->dev =3D rt->rt6i_dev;
+	return 1;
+
+ wrong_route:
+	dst_release(&rt->u.dst);
+ no_route:
+	if (!net_ratelimit())
+		return 0;
+
+	printk("ip6t_ROUTE: no explicit route found ");
+	if (ifindex)
+		printk("via interface %s ", route_info->oif);
+	if (!ipv6_addr_any(gw))
+		printk("via gateway %04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x", NIP6(*gw=
));
+	printk("\n");
+	return 0;
+}
+
+
+/* Stolen from ip6_output_finish
+ * PRE : skb->dev is set to the device we are leaving by
+ *       skb->dst is not NULL
+ * POST: the packet is sent with the link layer header pushed
+ *       the packet is destroyed
+ */
+static void ip_direct_send(struct sk_buff *skb)
+{
+	struct dst_entry *dst =3D skb->dst;
+	struct hh_cache *hh =3D dst->hh;
+
+	if (hh) {
+		read_lock_bh(&hh->hh_lock);
+		memcpy(skb->data - 16, hh->hh_data, 16);
+		read_unlock_bh(&hh->hh_lock);
+		skb_push(skb, hh->hh_len);
+		hh->hh_output(skb);
+	} else if (dst->neighbour)
+		dst->neighbour->output(skb);
+	else {
+		if (net_ratelimit())
+			DEBUGP(KERN_DEBUG "ip6t_ROUTE: no hdr & no neighbour cache!\n");
+		kfree_skb(skb);
+	}
+}
+
+
+static unsigned int=20
+route6_oif(const struct ip6t_route_target_info *route_info,
+	   struct sk_buff *skb)=20
+{
+	unsigned int ifindex =3D 0;
+	struct net_device *dev_out =3D NULL;
+
+	/* The user set the interface name to use.
+	 * Getting the current interface index.
+	 */
+	if ((dev_out =3D dev_get_by_name(route_info->oif))) {
+		ifindex =3D dev_out->ifindex;
+	} else {
+		/* Unknown interface name : packet dropped */
+		if (net_ratelimit())=20
+			DEBUGP("ip6t_ROUTE: oif interface %s not found\n", route_info->oif);
+
+		if (route_info->flags & IP6T_ROUTE_CONTINUE)
+			return IP6T_CONTINUE;
+		else
+			return NF_DROP;
+	}
+
+	/* Trying the standard way of routing packets */
+	if (route6(skb, ifindex, route_info)) {
+		dev_put(dev_out);
+		if (route_info->flags & IP6T_ROUTE_CONTINUE)
+			return IP6T_CONTINUE;
+	=09
+		ip_direct_send(skb);
+		return NF_STOLEN;
+	} else=20
+		return NF_DROP;
+}
+
+
+static unsigned int=20
+route6_gw(const struct ip6t_route_target_info *route_info,
+	  struct sk_buff *skb)=20
+{
+	if (route6(skb, 0, route_info)) {
+		if (route_info->flags & IP6T_ROUTE_CONTINUE)
+			return IP6T_CONTINUE;
+
+		ip_direct_send(skb);
+		return NF_STOLEN;
+	} else
+		return NF_DROP;
+}
+
+
+static unsigned int=20
+ip6t_route_target(struct sk_buff **pskb,
+		  unsigned int hooknum,
+		  const struct net_device *in,
+		  const struct net_device *out,
+		  const void *targinfo,
+		  void *userinfo)
+{
+	const struct ip6t_route_target_info *route_info =3D targinfo;
+	struct sk_buff *skb =3D *pskb;
+	struct in6_addr *gw =3D (struct in6_addr*)&route_info->gw;
+
+	if (route_info->flags & IP6T_ROUTE_CONTINUE)
+		goto do_it;
+
+	/* If we are at PREROUTING or INPUT hook
+	 * the TTL isn't decreased by the IP stack
+	 */
+	if (hooknum =3D=3D NF_IP6_PRE_ROUTING ||
+	    hooknum =3D=3D NF_IP6_LOCAL_IN) {
+
+		struct ipv6hdr *ipv6h =3D skb->nh.ipv6h;
+
+		if (ipv6h->hop_limit <=3D 1) {
+			/* Force OUTPUT device used as source address */
+			skb->dev =3D skb->dst->dev;
+
+			icmpv6_send(skb, ICMPV6_TIME_EXCEED,=20
+				    ICMPV6_EXC_HOPLIMIT, 0, skb->dev);
+
+			return NF_DROP;
+		}
+
+		ipv6h->hop_limit--;
+	}
+
+
+ do_it:
+	if (route_info->oif[0])=20
+		return route6_oif(route_info, *pskb);
+=09
+	if (!ipv6_addr_any(gw))
+		return route6_gw(route_info, *pskb);
+
+	if (net_ratelimit())=20
+		DEBUGP(KERN_DEBUG "ip6t_ROUTE: no parameter !\n");
+
+	return IP6T_CONTINUE;
+}
+
+
+static int=20
+ip6t_route_checkentry(const char *tablename,
+		      const struct ip6t_entry *e,
+		      void *targinfo,
+		      unsigned int targinfosize,
+		      unsigned int hook_mask)
+{
+	if (strcmp(tablename, "mangle") !=3D 0) {
+		printk("ip6t_ROUTE: can only be called from \"mangle\" table.\n");
+		return 0;
+	}
+
+	if (targinfosize !=3D IP6T_ALIGN(sizeof(struct ip6t_route_target_info))=
) {
+		printk(KERN_WARNING "ip6t_ROUTE: targinfosize %u !=3D %Zu\n",
+		       targinfosize,
+		       IP6T_ALIGN(sizeof(struct ip6t_route_target_info)));
+		return 0;
+	}
+
+	return 1;
+}
+
+
+static struct ip6t_target ip6t_route_reg =3D {
+	.name       =3D "ROUTE",
+	.target     =3D ip6t_route_target,
+	.checkentry =3D ip6t_route_checkentry,
+	.me         =3D THIS_MODULE
+};
+
+
+static int __init init(void)
+{
+	printk(KERN_DEBUG "registering ipv6 ROUTE target\n");
+	if (ip6t_register_target(&ip6t_route_reg))
+		return -EINVAL;
+
+	return 0;
+}
+
+
+static void __exit fini(void)
+{
+	ip6t_unregister_target(&ip6t_route_reg);
+}
+
+module_init(init);
+module_exit(fini);
+MODULE_LICENSE("GPL");
diff -Nru ROUTE.orig/linux-2.6/net/ipv6/netfilter/Kconfig.ladd ROUTE/linu=
x-2.6/net/ipv6/netfilter/Kconfig.ladd
--- ROUTE.orig/linux-2.6/net/ipv6/netfilter/Kconfig.ladd	1970-01-01 01:00=
:00.000000000 +0100
+++ ROUTE/linux-2.6/net/ipv6/netfilter/Kconfig.ladd	2004-03-08 15:06:42.0=
00000000 +0100
@@ -0,0 +1,11 @@
+config IP6_NF_TARGET_ROUTE
+	tristate '    ROUTE target support'
+	depends on IP6_NF_MANGLE
+	help
+	  This option adds a `ROUTE' target, which enables you to setup unusual
+	  routes. The ROUTE target is also able to change the incoming interfac=
e
+	  of a packet.
+=09
+	  The target can be or not a final target. It has to be used inside the=
=20
+	  mangle table.
+
diff -Nru ROUTE.orig/linux-2.6/net/ipv6/netfilter/Makefile.ladd ROUTE/lin=
ux-2.6/net/ipv6/netfilter/Makefile.ladd
--- ROUTE.orig/linux-2.6/net/ipv6/netfilter/Makefile.ladd	1970-01-01 01:0=
0:00.000000000 +0100
+++ ROUTE/linux-2.6/net/ipv6/netfilter/Makefile.ladd	2003-12-20 17:43:09.=
000000000 +0100
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP6_NF_TARGET_MARK) +=3D ip6t_MARK.o
+obj-$(CONFIG_IP6_NF_TARGET_ROUTE) +=3D ip6t_ROUTE.o

--=-Ub68NJ1FVMS9ucuGargM--
