From: =?ISO-8859-1?Q?C=E9dric?= de Launois <delaunoi@info.ucl.ac.be>
Subject: [PATCH] ROUTE target : bug fixes
Date: 20 Jun 2002 16:12:41 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1024582362.2418.30.camel@descartes>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Here is a patch for 'ROUTE' target :

1) The ipt_ROUTE.c code has been reworked. This patch fixes a bug
   in the previous version : a dev_put() was missing after the call=20
   to dev_get_by_index().

2) libipt_ROUTE.c now allows the user to specify the name of an
   interface that currently does not exist, like for the -i and -o
   options.

3) The 'ROUTE.patch.help' and 'ROUTE.patch.configure.help' were
   slightly modified.

This patch is against the current (june 20th) cvs tree, so this patch
is to apply INSTEAD of the last ROUTE patch (june 17th, yet not applied
on the cvs).

Doing
   patch -p0 < ROUTE.cvs.patch
in the same directory as netfilter/ should apply the patch correctly.

C=E9dric de Launois


**************************

diff -Nru netfilter.orig/userspace/extensions/libipt_ROUTE.c
netfilter/userspace/extensions/libipt_ROUTE.c
--- netfilter.orig/userspace/extensions/libipt_ROUTE.c	Thu Jun 13
18:12:01 2002
+++ netfilter/userspace/extensions/libipt_ROUTE.c	Thu Jun 20 12:18:46
2002
@@ -6,11 +6,10 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
-
 #include <iptables.h>
+#include <net/if.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ROUTE.h>
-#include <net/if.h>
=20
 /* Function which prints out usage message. */
 static void
@@ -21,7 +20,7 @@
 "  --iface   name                Send this packet directly through
iface name.\n"
 "  --ifindex index               Send this packet directly through
iface index.\n"
 "\n",
-NETFILTER_VERSION);
+IPTABLES_VERSION);
 }
=20
 static struct option opts[] =3D {
@@ -48,8 +47,6 @@
 	struct ipt_route_target_info *route_info =3D=20
 		(struct ipt_route_target_info*)(*target)->data;
=20
-	unsigned int if_index;
-
 	switch (c) {
 		char *end;
 	case '1':
@@ -57,15 +54,17 @@
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --iface or --ifindex twice");
=20
-		if (check_inverse(optarg, &invert))
+		if (check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --iface");
=20
-		if ((if_index =3D if_nametoindex(optarg))=3D=3D0)
+		if (strlen(optarg) > sizeof(route_info->if_name) - 1)
 			exit_error(PARAMETER_PROBLEM,
-				   "Unknown interface name %s", optarg);
+				   "Maximum interface name length %u",
+				   sizeof(route_info->if_name) - 1);
=20
-		route_info->if_index =3D if_index;
+		strcpy(route_info->if_name, optarg);
+		route_info->if_index =3D 0;
 		*flags |=3D IPT_ROUTE_OPT_IF;
 		break;
=20
@@ -74,14 +73,19 @@
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --iface or --ifindex twice");
=20
-		if (check_inverse(optarg, &invert))
+		if (check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --ifindex");
=20
+		route_info->if_name[0] =3D 0;
 		route_info->if_index =3D strtoul(optarg, &end, 0);
-
 		if (*end !=3D '\0' || end =3D=3D optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad ROUTE ifindex `%s'", optarg);
+			exit_error(PARAMETER_PROBLEM, "Bad ROUTE ifindex `%s'",
+				   optarg);
+
+		if (route_info->if_index =3D=3D 0)
+			exit_error(PARAMETER_PROBLEM,
+				   "Interface index can't be 0 !");
=20
 		*flags |=3D IPT_ROUTE_OPT_IF;
 		break;
@@ -112,19 +116,17 @@
=20
 	printf("ROUTE ");
=20
-	if (route_info->if_index !=3D 0) {
-		char buf[IF_NAMESIZE];
-		printf("iface %s(%d) ",
-		       if_indextoname(route_info->if_index, buf),
-		       route_info->if_index);
-	}
+	if (route_info->if_name[0] !=3D 0)
+		printf("iface %s ", route_info->if_name);
+	else=20
+		printf("ifindex %u ", route_info->if_index);
 }
=20
 static
 struct iptables_target route
 =3D { NULL,
     "ROUTE",
-    NETFILTER_VERSION,
+    IPTABLES_VERSION,
     IPT_ALIGN(sizeof(struct ipt_route_target_info)),
     IPT_ALIGN(sizeof(struct ipt_route_target_info)),
     &help,
diff -Nru netfilter.orig/userspace/patch-o-matic/extra/ROUTE.patch
netfilter/userspace/patch-o-matic/extra/ROUTE.patch
--- netfilter.orig/userspace/patch-o-matic/extra/ROUTE.patch	Thu Jun 13
18:12:01 2002
+++ netfilter/userspace/patch-o-matic/extra/ROUTE.patch	Thu Jun 20
15:29:27 2002
@@ -1,54 +1,41 @@
-diff -Nru linux/include/linux/netfilter_ipv4/ipt_ROUTE.h
linux-new/include/linux/netfilter_ipv4/ipt_ROUTE.h
---- linux/include/linux/netfilter_ipv4/ipt_ROUTE.h	Thu Jan  1 01:00:00
1970
-+++ linux-new/include/linux/netfilter_ipv4/ipt_ROUTE.h	Mon Jun 10
09:21:41 2002
-@@ -0,0 +1,8 @@
+diff -Nru linux.orig/include/linux/netfilter_ipv4/ipt_ROUTE.h
linux/include/linux/netfilter_ipv4/ipt_ROUTE.h
+--- linux.orig/include/linux/netfilter_ipv4/ipt_ROUTE.h	Thu Jan  1
01:00:00 1970
++++ linux/include/linux/netfilter_ipv4/ipt_ROUTE.h	Thu Jun 20 11:18:09
2002
+@@ -0,0 +1,17 @@
++/* Header file for iptables ipt_ROUTE target
++ *
++ * (C) 2002 by C=E9dric de Launois <delaunois@info.ucl.ac.be>
++ *
++ * This software is distributed under GNU GPL v2, 1991
++ */
 +#ifndef _IPT_ROUTE_H_target
 +#define _IPT_ROUTE_H_target
 +
++#define IPT_ROUTE_IFNAMSIZ 16
++
 +struct ipt_route_target_info {
 +	unsigned int if_index;
++	char if_name[IPT_ROUTE_IFNAMSIZ];
 +};
 +
 +#endif /*_IPT_ROUTE_H_target*/
-diff -Nru linux/net/ipv4/netfilter/ipt_ROUTE.c
linux-new/net/ipv4/netfilter/ipt_ROUTE.c
---- linux/net/ipv4/netfilter/ipt_ROUTE.c	Thu Jan  1 01:00:00 1970
-+++ linux-new/net/ipv4/netfilter/ipt_ROUTE.c	Mon Jun 10 10:41:30 2002
-@@ -0,0 +1,247 @@
+diff -Nru linux.orig/net/ipv4/netfilter/ipt_ROUTE.c
linux/net/ipv4/netfilter/ipt_ROUTE.c
+--- linux.orig/net/ipv4/netfilter/ipt_ROUTE.c	Thu Jan  1 01:00:00 1970
++++ linux/net/ipv4/netfilter/ipt_ROUTE.c	Thu Jun 20 14:22:59 2002
+@@ -0,0 +1,267 @@
 +/*
-+ * This is a module which is used for rerouting packets without
modifying them.
-+ * This module is particularly useful when the dst IP is one of our
own IP=20
-+ * addresses. Packet with those addresses are locally delivered and
-+ * cannot be forwarded using the standard routing mechanisms.
-+ *
-+ * This module can reroute packets to the interface selected by the
user.
-+ * Example :
-+ *
-+ * iptables -A PREROUTING -i eth0 -p tcp --dport 8000:8200 -j ROUTE
--iface eth1
-+ *
-+ * i.e. the module reroute tcp packets coming from eth0 with dsp port
8000-8200=20
-+ * towards iface eth1.
-+ *
-+ * The rerouting is used by i.e. RSIP protocol when RSAP-IP method is=20
-+ * selected.
-+ *
++ * This is a module which is used for directly resending a received
packet to
++ * an interface specified by the user.
++ * This module is particularly useful when the destination IP address
is an
++ * address owned by the router itself. Packets with such addresses are
locally
++ * delivered by the kernel and cannot be forwarded using the standard
routing=20
++ * mechanisms.
++
 + * Based on code from: ipt_MIRROR.c and various sources.
 + *
 + * Copyright (C) 2002 Cedric de Launois <delaunois@info.ucl.ac.be>
 + *
-+ * This program is free software; you can redistribute it and/or
modify it
-+ * under the terms of the GNU General Public License as published by
the
-+ * Free Software Foundation; either version 2 of the License, or (at
your
-+ * option) any later version.
-+ *
-+ * This program is distributed in the hope that it will be useful, but
-+ * WITHOUT ANY WARRANTY; without even the implied warranty of
-+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-+ * General Public License for more details.
-+ *
-+ * You should have received a copy of the GNU General Public License
-+ * along with this program; if not, write to the Free Software
Foundation,
-+ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
-+ *
++ * This software is distributed under GNU GPL v2, 1991
 + */
 +
 +#include <linux/module.h>
@@ -61,20 +48,28 @@
 +#include <net/ip.h>
 +#include <net/icmp.h>
 +
++#if 0
++#define DEBUGP printk
++#else
++#define DEBUGP(format, args...)
++#endif
++
 +
 +/* PRE : skb is the packet and ifindex is the interface index through
which=20
 + *       the packet should be rerouted
-+ * POST: skb->dev is the output device towards which the packet is
rerouted
-+ *       returns 0 if the packet could not be rerouted
-+ *       returns 1 and skb->dst is not NULL if a regular route has
been found
-+ *       in the routing table
-+ *       returns 2 and skb->dst is NULL otherwise
++ * POST: if success, skb->dev is the output device with index
'ifindex'
++ *       to which the packet must be sent and skb->dst is not NULL
++ * RETURN: -1 if an error occured
++ *          1 if the packet has been succesfully rerouted to the
device with
++ *            index 'ifindex', using the kernel routing table
++ *          0 if the kernel routing table didn't yield the requested=20
++ *            interface
 + */
 +static int route(struct sk_buff *skb, unsigned int ifindex)
 +{
 +	int err;
-+        struct iphdr *iph =3D skb->nh.iph;
 +	struct rtable *rt;
++        struct iphdr *iph =3D skb->nh.iph;
 +	struct rt_key key =3D {=20
 +		dst:iph->daddr,
 +		src:0,
@@ -82,23 +77,14 @@
 +		tos:RT_TOS(iph->tos)=20
 +	};
 +
-+	nf_conntrack_put(skb->nfct);
-+	skb->nfct =3D NULL;
-+
 +	/* Trying to route the packet with the standard routing table. */
 +	if ((err =3D ip_route_output_key(&rt, &key))) {
-+		printk("ipt_ROUTE couldn't route pkt (err: %i)",err);
-+		return 0;
-+	}
-+
-+	/* Drop old device. */
-+	if (skb->dev) {
-+		dev_put(skb->dev);
-+		skb->dev =3D NULL;
++		DEBUGP("ipt_ROUTE: couldn't route pkt (err: %i)",err);
++		return -1;
 +	}
 +
 +	/* Check if the interface we are leaving by is the same as the
-+         * one we requested.
++	 * one we requested.
 +	 */
 +	if (rt->u.dst.dev->ifindex =3D=3D ifindex) {
 +		/* Drop old route. */
@@ -107,54 +93,51 @@
 +		skb->dev =3D skb->dst->dev;
 +		return 1;
 +	}
++
 +	/* The interface selected by the routing table is not the one
 +	 * specified by the user. This may happen because the dst address
 +	 * is one of our own addresses. This module makes it possible to
 +	 * reroute such packets by forcing the device to use.
-+	 * This is useful i.e. to the RSIP protocol (RFC3102).
 +	 */
-+	if ((skb->dev =3D dev_get_by_index(ifindex)) !=3D NULL) {
-+		/* Drop old route. */
-+		dst_release(skb->dst);
-+		skb->dst =3D NULL;
-+		return 2;
-+	}
-+
 +	return 0;
 +}
 +
 +
-+/* PRE : skb->dev is set to the device we are leaving by
-+ * POST: - if skb->dst is not NULL, then the packet is sent with the
-+ *         link layer header pushed
-+ *       - if skb->dst is NULL, then the packet is directly sent to
-+ *         the skb->dev device, without pushing the link layer header.
-+ *         This should be only used for tunnel interfaces, for which
-+ *         link layer headers are automatically generated.
++/* Stolen from ip_finish_output2
++ * PRE : skb->dev is set to the device we are leaving by
++ *       skb->dst is not NULL
++ * POST: the packet is sent with the link layer header pushed
 + */
-+static void ip_direct_send(struct sk_buff *skb)
++static inline int ip_direct_send(struct sk_buff *skb)
 +{
 +	struct dst_entry *dst =3D skb->dst;
 +	struct hh_cache *hh;
 +
-+	if (!dst) {
-+		dev_queue_xmit(skb);
-+		return;
-+	}
-+
 +	hh =3D dst->hh;
 +	if (hh) {
 +		read_lock_bh(&hh->hh_lock);
 +		memcpy(skb->data - 16, hh->hh_data, 16);
 +		read_unlock_bh(&hh->hh_lock);
 +		skb_push(skb, hh->hh_len);
-+		hh->hh_output(skb);
++		return hh->hh_output(skb);
 +	} else if (dst->neighbour)
-+		dst->neighbour->output(skb);
-+	else {
-+		printk(KERN_DEBUG "khm in MIRROR\n");
-+		kfree_skb(skb);
-+	}
++		return dst->neighbour->output(skb);
++
++	if (net_ratelimit())
++		DEBUGP(KERN_DEBUG "ipt_ROUTE: no hdr & no neighbour cache!\n");
++	kfree_skb(skb);
++	return -EINVAL;
++}
++
++
++/* PRE : skb->dev is set to the device we are leaving by
++ * POST: - the packet is directly sent to the skb->dev device, without
++ *         pushing the link layer header.
++ *       - skb has been freed !!
++ */
++static inline int dev_direct_send(struct sk_buff *skb)
++{
++	return dev_queue_xmit(skb);
 +}
 +
 +
@@ -166,17 +149,26 @@
 +				      void *userinfo)
 +{
 +	const struct ipt_route_target_info *route_info =3D targinfo;
++	struct net_device *dev_out =3D NULL;
++	struct sk_buff *skb =3D *pskb;
++	unsigned int index =3D 0;
 +
-+	printk("RCV from IN=3D%s OUT=3D%s PROTO=3D%u \n",
-+	       in ? in->name : "",
-+	       out ? out->name : "",
-+	       (*pskb)->protocol);
++	/* raw socket (tcpdump) may have clone of incoming
++	 * skb: don't disturb it
++	 */
++	if (skb_cloned(skb) && !skb->sk) {
++		struct sk_buff *nskb =3D skb_copy(skb, GFP_ATOMIC);
++		if (!nskb)
++			return NF_DROP;
++		kfree_skb(skb);
++		skb =3D nskb;
++	}
 +
 +	/* If we are not at FORWARD hook
 +	 * the TTL isn't decreased by the IP stack
 +	 */
 +	if (hooknum !=3D NF_IP_FORWARD) {
-+		struct iphdr *iph =3D (*pskb)->nh.iph;
++		struct iphdr *iph =3D skb->nh.iph;
 +
 +		if (iph->ttl <=3D 1) {
 +			struct rtable *rt;
@@ -187,14 +179,14 @@
 +				return NF_DROP;
 +			}
 +
-+			if ((*pskb)->dev =3D=3D rt->u.dst.dev) {
++			if (skb->dev =3D=3D rt->u.dst.dev) {
 +				/* Drop old route. */
-+				dst_release((*pskb)->dst);
-+				(*pskb)->dst =3D &rt->u.dst;
++				dst_release(skb->dst);
++				skb->dst =3D &rt->u.dst;
 +
 +				/* this will traverse normal stack, and=20
 +				 * thus call conntrack on the icmp packet */
-+				icmp_send(*pskb, ICMP_TIME_EXCEEDED,=20
++				icmp_send(skb, ICMP_TIME_EXCEEDED,=20
 +					  ICMP_EXC_TTL, 0);
 +			}
 +
@@ -204,14 +196,52 @@
 +		ip_decrease_ttl(iph);
 +	}
 +
++	/* This packet will not be the same as before: clear nf fields */
++	nf_conntrack_put(skb->nfct);
++	skb->nfct =3D NULL;
++	skb->nfcache =3D 0;
++#ifdef CONFIG_NETFILTER_DEBUG
++	skb->nf_debug =3D 0;
++#endif
++
++	/* Getting the actual interface index */
++	if ((index =3D route_info->if_index) =3D=3D 0) {
++		/* The user specified a ifname, not a ifindex */
++		if ((dev_out =3D dev_get_by_name(route_info->if_name)))
++			index =3D dev_out->ifindex;
++		else return NF_DROP;
++	}
++
++	/* Trying the standard way */
++	if (route(skb, index)=3D=3D1) {
++		if (dev_out) dev_put(dev_out);
++		if (ip_direct_send(skb) =3D=3D -EINVAL) return NF_DROP;
++		return NF_STOLEN;
++	}
++
++	/* Failed to correctly route. Trying the hard way */
++	if (!dev_out) dev_out =3D dev_get_by_index(index);
 +
-+	if (route(*pskb, route_info->if_index)) {
++	if (dev_out) {
 +
-+		ip_direct_send(*pskb);
++		/* Drop old route. */
++		dst_release(skb->dst);
++		skb->dst =3D NULL;
++
++		/* Send the packet. This will also free skb !=20
++		 * Do not go through the POST_ROUTING hook because=20
++		 * skb->dst is not set and because it will probably
++		 * get confused by the destination IP address.
++		 */
++		skb->dev =3D dev_out;
++		dev_direct_send(skb);
++		dev_put(dev_out);
 +
 +		return NF_STOLEN;
 +	}
 +
++	DEBUGP("ipt_ROUTE: Couldn't route the packet!\n");
++
 +	return NF_DROP;
 +}
 +
@@ -222,14 +252,13 @@
 +				 unsigned int targinfosize,
 +				 unsigned int hook_mask)
 +{
-+	/* Only working on PRE_ROUTING */
 +	if (hook_mask & ~(1 << NF_IP_PRE_ROUTING)) {
-+		printk("ROUTE: bad hook\n");
++		printk("ipt_ROUTE: bad hook\n");
 +		return 0;
 +	}
 +
 +	if (targinfosize !=3D IPT_ALIGN(sizeof(struct ipt_route_target_info)))
{
-+		printk(KERN_WARNING "ROUTE: targinfosize %u !=3D %Zu\n",
++		DEBUGP(KERN_WARNING "ipt_ROUTE: targinfosize %u !=3D %Zu\n",
 +		       targinfosize,
 +		       IPT_ALIGN(sizeof(struct ipt_route_target_info)));
 +		return 0;
diff -Nru
netfilter.orig/userspace/patch-o-matic/extra/ROUTE.patch.configure.help
netfilter/userspace/patch-o-matic/extra/ROUTE.patch.configure.help
---
netfilter.orig/userspace/patch-o-matic/extra/ROUTE.patch.configure.help	Thu=
 Jun 13 18:12:01 2002
+++
netfilter/userspace/patch-o-matic/extra/ROUTE.patch.configure.help	Thu
Jun 20 12:33:54 2002
@@ -7,10 +7,8 @@
   are locally delivered and cannot be forwarded to another computer=20
   using the standard routing mechanisms.
=20
-  This target is particularly useful if you intend to use RSIP protocol
-  (RFC3102, RFC3103).
-
   If you want to compile it as a module, say M here and read
-  Documentation/modules.txt.  If unsure, say `N'.
+  Documentation/modules.txt.  The module will be called ipt_ROUTE.o.
+  If unsure, say `N'.
=20
 =20
diff -Nru netfilter.orig/userspace/patch-o-matic/extra/ROUTE.patch.help
netfilter/userspace/patch-o-matic/extra/ROUTE.patch.help
--- netfilter.orig/userspace/patch-o-matic/extra/ROUTE.patch.help	Thu
Jun 13 18:12:01 2002
+++ netfilter/userspace/patch-o-matic/extra/ROUTE.patch.help	Thu Jun 20
12:43:22 2002
@@ -1,13 +1,25 @@
 Author: C=E9dric de Launois <delaunois@info.ucl.ac.be>
 Status: In Development/Works for me
  =20
-  This option adds a `ROUTE' target, which allows you to directly route
+  This option adds a `ROUTE' target, which allows you to directly
resend
   a received packet through a specified interface, even and especially
   if the packet IP address is one of the router itself. Those packets=20
   are locally delivered and cannot be forwarded to another computer=20
   using the standard routing mechanisms.
=20
-  This target is particularly useful if you intend to use RSIP protocol
-  (RFC3102, RFC3103).
+  ROUTE target v1.2.7 options:
+    --iface   name            Send the packet directly through iface
name.
+    --ifindex index           Send the packet directly through iface
index.
+
+  Example :
+  You want to install a ssh server on a computer inside your network
but=20
+  you also want it to appear exactly as if it was located on the
router.
+  A solution is to simply reroute packets with destination port 22 to
the
+  computer having the same IP as the router and hosting the ssh
service,
+  thanks to this ROUTE target and an ipip tunnel.
+
+  # iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 22 -j ROUTE
--iface tunl1
+  # iptables -A PREROUTING -t nat -i tunl1 --j ROUTE --iface eth0
+
=20
 =20
