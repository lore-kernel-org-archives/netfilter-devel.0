From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: [PATCH] Yet another new option for ROUTE target
Date: 18 Dec 2002 12:58:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1040212733.439.18.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-UKWT7euwxloJAhIYn4pC"
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


--=-UKWT7euwxloJAhIYn4pC
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

I added yet another new option (--iif option) for the ROUTE target. 
This option lets you change the incoming interface of a packet.
This can be useful for testing purposes or unusual routing needs (see
http://lists.netfilter.org/pipermail/netfilter-devel/2002-December/010026.html)

I also cleaned up the code and somewhat standardized the option names.

The ROUTE target options are now:
 --oif ifname   Send the packet out using `ifname' network interface.
 --iif ifname   Change the packet's incoming interface to `ifname'.
 --gw  ip       Route the packet via this gateway.


Besides, the target can now apply on all five hooks.

I tried to do my best to test this target but it is quite hard to test
the different configurations, even with the help of user-mode linux.
Please tell me how this target works (or not) for you !

The patch is against the current cvs tree.

Cedric


--=-UKWT7euwxloJAhIYn4pC
Content-Disposition: attachment; filename=ROUTE.cvs.patch
Content-Type: text/x-patch; name=ROUTE.cvs.patch; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by info.ucl.ac.be id MAA01191

diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch netfilter/patch-=
o-matic/extra/ROUTE.patch
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch	Thu Dec  5 21:44:38 20=
02
+++ netfilter/patch-o-matic/extra/ROUTE.patch	Wed Dec 18 12:53:02 2002
@@ -1,7 +1,7 @@
 diff -Nru linux.orig/include/linux/netfilter_ipv4/ipt_ROUTE.h linux/incl=
ude/linux/netfilter_ipv4/ipt_ROUTE.h
 --- linux.orig/include/linux/netfilter_ipv4/ipt_ROUTE.h	Thu Jan  1 01:00=
:00 1970
-+++ linux/include/linux/netfilter_ipv4/ipt_ROUTE.h	Thu Nov 21 10:36:35 2=
002
-@@ -0,0 +1,17 @@
++++ linux/include/linux/netfilter_ipv4/ipt_ROUTE.h	Tue Dec 17 16:49:04 2=
002
+@@ -0,0 +1,18 @@
 +/* Header file for iptables ipt_ROUTE target
 + *
 + * (C) 2002 by C=E9dric de Launois <delaunois@info.ucl.ac.be>
@@ -14,22 +14,19 @@
 +#define IPT_ROUTE_IFNAMSIZ 16
 +
 +struct ipt_route_target_info {
-+	char ifname[IPT_ROUTE_IFNAMSIZ];
-+	unsigned int ipto;
++	char oif[IPT_ROUTE_IFNAMSIZ];
++	char iif[IPT_ROUTE_IFNAMSIZ];
++	unsigned int gw;
 +};
 +
 +#endif /*_IPT_ROUTE_H_target*/
 diff -Nru linux.orig/net/ipv4/netfilter/ipt_ROUTE.c linux/net/ipv4/netfi=
lter/ipt_ROUTE.c
 --- linux.orig/net/ipv4/netfilter/ipt_ROUTE.c	Thu Jan  1 01:00:00 1970
-+++ linux/net/ipv4/netfilter/ipt_ROUTE.c	Fri Nov 22 14:53:06 2002
-@@ -0,0 +1,317 @@
++++ linux/net/ipv4/netfilter/ipt_ROUTE.c	Wed Dec 18 12:40:26 2002
+@@ -0,0 +1,365 @@
 +/*
-+ * This is a module which is used for directly sending a received packe=
t to
-+ * an interface or a host specified by the user. This target NEVER modi=
fies=20
-+ * packets but allows a different routing scheme than the one provided =
by=20
-+ * the standard kernel routing table.
-+ *
-+ * Based on code from: ipt_MIRROR.c and various sources.
++ * This implements the ROUTE target, which enables you to setup unusual
++ * routes not supported by the standard kernel routing table.
 + *
 + * Copyright (C) 2002 Cedric de Launois <delaunois@info.ucl.ac.be>
 + *
@@ -44,6 +41,7 @@
 +#include <linux/netdevice.h>
 +#include <linux/route.h>
 +#include <net/ip.h>
++#include <net/route.h>
 +#include <net/icmp.h>
 +
 +#if 0
@@ -58,7 +56,7 @@
 + *  - ifindex :=20
 + *      0 if no oif prefered,=20
 + *      otherwise set to the index of the desired oif
-+ *  - route_info->ipto :
++ *  - route_info->gw :
 + *      0 if no gateway specified,
 + *      otherwise set to the next host to which the pkt must be routed
 + * If success, skb->dev is the output device to which the packet must=20
@@ -76,24 +74,24 @@
 +{
 +	int err;
 +	struct rtable *rt;
-+        struct iphdr *iph =3D skb->nh.iph;
++	struct iphdr *iph =3D skb->nh.iph;
 +	struct rt_key key =3D {=20
 +		dst:iph->daddr,
 +		src:0,
 +		oif:ifindex,=20
 +		tos:RT_TOS(iph->tos)=20
 +	};
-+
++=09
 +	/* The destination address may be overloaded by the target */
-+	if (route_info->ipto)
-+		key.dst =3D route_info->ipto;
-+
++	if (route_info->gw)
++		key.dst =3D route_info->gw;
++=09
 +	/* Trying to route the packet with the standard routing table. */
 +	if ((err =3D ip_route_output_key(&rt, &key))) {
 +		DEBUGP("ipt_ROUTE: couldn't route pkt (err: %i)",err);
 +		return -1;
 +	}
-+
++=09
 +	/* Success if no oif specified or if the oif correspond to the=20
 +	 * one desired */
 +	if (!ifindex || rt->u.dst.dev->ifindex =3D=3D ifindex) {
@@ -103,7 +101,7 @@
 +		skb->dev =3D skb->dst->dev;
 +		return 1;
 +	}
-+
++=09
 +	/* The interface selected by the routing table is not the one
 +	 * specified by the user. This may happen because the dst address
 +	 * is one of our own addresses. This module makes it possible to
@@ -111,7 +109,7 @@
 +	 */
 +	DEBUGP("ipt_ROUTE: failed to route as desired (oif: %i)",=20
 +	       rt->u.dst.dev->ifindex);
-+
++=09
 +	return 0;
 +}
 +
@@ -154,22 +152,120 @@
 +}
 +
 +
-+static unsigned int ipt_route_target(struct sk_buff **pskb,
-+				      unsigned int hooknum,
-+				      const struct net_device *in,
-+				      const struct net_device *out,
-+				      const void *targinfo,
-+				      void *userinfo)
++static unsigned int route_oif(const struct ipt_route_target_info *route=
_info,
++			      struct sk_buff *skb)=20
 +{
-+	const struct ipt_route_target_info *route_info =3D targinfo;
 +	struct net_device *dev_out =3D NULL;
-+	struct sk_buff *skb =3D *pskb;
 +	unsigned int ifindex =3D 0;
 +
-+	if (!route_info->ipto && !route_info->ifname[0]) {
-+		DEBUGP(KERN_DEBUG "ipt_ROUTE: missing argument!\n");
-+		return NF_ACCEPT;
++	/* The user set the interface name to use.
++	 * Getting the current interface index.
++	 */
++	if ((dev_out =3D dev_get_by_name(route_info->oif)))
++		ifindex =3D dev_out->ifindex;
++	else=20
++		/* Unknown interface name : packet dropped */
++		return NF_DROP;
++=09
++	DEBUGP(KERN_DEBUG "oif index of %s is %i\n", route_info->oif, ifindex)=
;
++
++
++	/* Trying the standard way of routing packets */
++	if (route(skb, ifindex, route_info)=3D=3D1) {
++		DEBUGP(KERN_DEBUG "ROUTE oif ok, skb->dev->index=3D%i\n",
++		       skb->dev->ifindex);
++
++		dev_put(dev_out);
++		if (ip_direct_send(skb) =3D=3D -EINVAL)=20
++			return NF_DROP;
++		else
++			return NF_STOLEN;
++	}
++
++	/* Failed to send to oif. Trying the hard way */
++
++	DEBUGP(KERN_DEBUG "HARD ROUTING\n");
++
++	/* Drop old route. */
++	dst_release(skb->dst);
++	skb->dst =3D NULL;
++
++	/* We have to force the use of an interface.
++	 * This interface must be a tunnel interface since
++	 * otherwise we can't guess the hw address for
++	 * the packet. For a tunnel interface, no hw address
++	 * is needed.
++	 */
++	if ((dev_out->type !=3D ARPHRD_TUNNEL)
++	    && (dev_out->type !=3D ARPHRD_IPGRE)) {
++		DEBUGP("ipt_ROUTE: can't guess the hw addr !\n");
++		dev_put(dev_out);
++		return NF_DROP;
 +	}
++=09
++	/* Send the packet. This will also free skb !=20
++	 * Do not go through the POST_ROUTING hook because=20
++	 * skb->dst is not set and because it will probably
++	 * get confused by the destination IP address.
++	 */
++	skb->dev =3D dev_out;
++	dev_direct_send(skb);
++	dev_put(dev_out);
++=09
++	return NF_STOLEN;
++}
++
++
++static unsigned int route_iif(const struct ipt_route_target_info *route=
_info,
++			      struct sk_buff *skb)=20
++{
++	struct net_device *dev_out =3D NULL;
++	unsigned int ifindex =3D 0;
++
++	/* Getting the current interface index. */
++	if ((dev_out =3D dev_get_by_name(route_info->iif)))
++		ifindex =3D dev_out->ifindex;
++	else=20
++		/* Unknown interface name : packet dropped */
++		return NF_DROP;
++
++	DEBUGP(KERN_DEBUG "iif index of %s is %i\n", route_info->iif, ifindex)=
;
++
++	skb->dev =3D dev_out;
++	dst_release(skb->dst);
++	skb->dst =3D NULL;
++	=09
++	netif_rx(skb);
++
++	return NF_STOLEN;
++}
++
++
++static unsigned int route_gw(const struct ipt_route_target_info *route_=
info,
++			     struct sk_buff *skb)=20
++{
++	if (route(skb, 0, route_info)!=3D1)
++		return NF_DROP;
++
++	DEBUGP(KERN_DEBUG "ROUTE gw ok, skb->dev->index=3D%i\n",
++	       skb->dev->ifindex);
++
++	if (ip_direct_send(skb) =3D=3D -EINVAL)=20
++		return NF_DROP;
++
++	return NF_STOLEN;
++}
++
++
++static unsigned int ipt_route_target(struct sk_buff **pskb,
++				     unsigned int hooknum,
++				     const struct net_device *in,
++				     const struct net_device *out,
++				     const void *targinfo,
++				     void *userinfo)
++{
++	const struct ipt_route_target_info *route_info =3D targinfo;
++	struct sk_buff *skb =3D *pskb;
 +
 +	/* raw socket (tcpdump) may have clone of incoming
 +	 * skb: don't disturb it
@@ -225,74 +321,25 @@
 +	skb->nf_debug =3D 0;
 +#endif
 +
-+	if (route_info->ifname[0]) {
-+		/* The user set the interface name to use.
-+		 * Getting the current interface index.
-+		 */
-+		if ((dev_out =3D dev_get_by_name(route_info->ifname)))
-+			ifindex =3D dev_out->ifindex;
-+		else=20
-+			/* Unknown interface name : packet dropped */
-+			return NF_DROP;
-+
-+	}
-+
-+	DEBUGP(KERN_DEBUG "Index of %s is %i\n", route_info->ifname, ifindex);
-+
-+	/* Trying the standard way of routing packets */
-+	if (route(skb, ifindex, route_info)=3D=3D1) {
-+		DEBUGP(KERN_DEBUG "ROUTE ok, skb->dev->index=3D%i\n",
-+		       skb->dev->ifindex);
-+
-+		if (dev_out) dev_put(dev_out);
-+		if (ip_direct_send(skb) =3D=3D -EINVAL) return NF_DROP;
-+		return NF_STOLEN;
-+	}
-+
-+	if (!route_info->ifname[0]) {
-+		if (dev_out) dev_put(dev_out);
-+		return NF_DROP;
-+	}
-+
-+	/* Failed to correctly route. Trying the hard way */
-+
-+	DEBUGP(KERN_DEBUG "HARD ROUTING\n");
++	if (route_info->oif[0])=20
++		return route_oif(route_info, skb);
++=09
++	if (route_info->iif[0])=20
++		return route_iif(route_info, skb);
 +
-+	/* Drop old route. */
-+	dst_release(skb->dst);
-+	skb->dst =3D NULL;
++	if (route_info->gw)=20
++		return route_gw(route_info, skb);
 +
-+	/* We have to force the use of an interface.
-+	 * This interface must be a tunnel interface since
-+	 * otherwise we can't guess the hw address for
-+	 * the packet. For a tunnel interface, no hw address
-+	 * is needed.
-+	 */
-+	if ((dev_out->type !=3D ARPHRD_TUNNEL)
-+	    && (dev_out->type !=3D ARPHRD_IPGRE)) {
-+		DEBUGP("ipt_ROUTE: can't guess the hw addr !\n");
-+		dev_put(dev_out);
-+		return NF_DROP;
-+	}
-+=09
-+	/* Send the packet. This will also free skb !=20
-+	 * Do not go through the POST_ROUTING hook because=20
-+	 * skb->dst is not set and because it will probably
-+	 * get confused by the destination IP address.
-+	 */
-+	skb->dev =3D dev_out;
-+	dev_direct_send(skb);
-+	dev_put(dev_out);
-+=09
-+	return NF_STOLEN;
++	DEBUGP(KERN_DEBUG "ipt_ROUTE: no parameter !\n");
++	return NF_ACCEPT;
 +}
 +
 +
 +static int ipt_route_checkentry(const char *tablename,
-+				 const struct ipt_entry *e,
-+				 void *targinfo,
-+				 unsigned int targinfosize,
-+				 unsigned int hook_mask)
++				const struct ipt_entry *e,
++				void *targinfo,
++				unsigned int targinfosize,
++				unsigned int hook_mask)
 +{
 +	if (strcmp(tablename, "mangle") !=3D 0) {
 +		printk("ipt_ROUTE: bad table `%s', use the `mangle' table.\n",
@@ -301,8 +348,10 @@
 +	}
 +
 +	if (hook_mask & ~(  (1 << NF_IP_PRE_ROUTING)
-+			  | (1 << NF_IP_FORWARD)
-+			  | (1 << NF_IP_POST_ROUTING))) {
++			    | (1 << NF_IP_LOCAL_IN)
++			    | (1 << NF_IP_FORWARD)
++			    | (1 << NF_IP_LOCAL_OUT)
++			    | (1 << NF_IP_POST_ROUTING))) {
 +		printk("ipt_ROUTE: bad hook\n");
 +		return 0;
 +	}
diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch.configure.help n=
etfilter/patch-o-matic/extra/ROUTE.patch.configure.help
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch.configure.help	Thu Dec=
  5 21:44:38 2002
+++ netfilter/patch-o-matic/extra/ROUTE.patch.configure.help	Wed Dec 18 1=
2:19:19 2002
@@ -1,14 +1,18 @@
 CONFIG_IP_NF_TARGET_LOG
 ROUTE target support
 CONFIG_IP_NF_TARGET_ROUTE
-  This option adds a `ROUTE' target, which allows you to directly route
-  a received packet through a specified interface or towards a host, eve=
n
-  if the regular destination of the packet is the router itself.
-  This target never modifies packets but allows a different routing sche=
me
-  than the one provided by the standard kernel routing table.
+  This option adds a `ROUTE' target, which enables you to setup unusual
+  routes not supported by the standard kernel routing table.
+  For example, the ROUTE lets you directly route a received packet throu=
gh=20
+  an interface or towards a host, even if the regular destination of the=
=20
+  packet is the router itself. The ROUTE target is also able to change t=
he=20
+  incoming interface of a packet.
+
+  This target does never modify the packet and is a final target.
+  It has to be used inside the mangle table.
+
  =20
   If you want to compile it as a module, say M here and read
   Documentation/modules.txt.  The module will be called ipt_ROUTE.o.
   If unsure, say `N'.
=20
-=20
diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch.help netfilter/p=
atch-o-matic/extra/ROUTE.patch.help
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch.help	Thu Dec  5 21:44:=
38 2002
+++ netfilter/patch-o-matic/extra/ROUTE.patch.help	Wed Dec 18 12:51:37 20=
02
@@ -1,28 +1,32 @@
 Author: C=E9dric de Launois <delaunois@info.ucl.ac.be>
 Status: In Development/Works for me
  =20
-  This option adds a `ROUTE' target, which allows you to directly route
-  a received packet through a specified interface or towards a host, eve=
n
-  if the regular destination of the packet is the router itself.
-  This target never modifies packets but allows a different routing sche=
me
-  than the one provided by the standard kernel routing table.
-	  =20
-  This target is to be used inside the mangle table, in the PREROUTING,
-  POSTROUTING or FORWARD hooks.
+  This option adds a `ROUTE' target, which enables you to setup unusual
+  routes not supported by the standard kernel routing table.
+  For example, the ROUTE lets you directly route a received packet throu=
gh=20
+  an interface or towards a host, even if the regular destination of the=
=20
+  packet is the router itself. The ROUTE target is also able to change t=
he=20
+  incoming interface of a packet.
+
+  This target does never modify the packet and is a final target.
+  It has to be used inside the mangle table.
=20
   ROUTE target options:
-    --iface name      Send the packet directly through this interface.
-    --to    ip        Route the packet as if its destination address was=
 ip.
+    --oif   ifname    Send the packet out using `ifname' network interfa=
ce.
+    --iif   ifname    Change the packet's incoming interface to `ifname'.
+    --gw    ip        Route the packet via this gateway.
=20
   Examples :
=20
   To redirect all outgoing icmp packet to the eth1 interface :
-  # iptables -A POSTROUTING -t mangle -p icmp -j ROUTE --iface eth1
+  # iptables -A POSTROUTING -t mangle -p icmp -j ROUTE --oif eth1
=20
-  To tunnel all incoming http packets
-  # iptables -A PREROUTING -t mangle -p tcp --dport 80 -j ROUTE --iface =
tunl1
+  To tunnel all incoming http packets :
+  # iptables -A PREROUTING -t mangle -p tcp --dport 80 -j ROUTE --oif tu=
nl1
=20
-  To force the next-hop used for ssh packets
-  # iptables -A PREROUTING -t mangle -p tcp --dport 22 -j ROUTE --to w.x=
.y.z
+  To force the next-hop used for ssh packets :
+  # iptables -A PREROUTING -t mangle -p tcp --dport 22 -j ROUTE --gw w.x=
.y.z
=20
+  To change the incoming network interface from eth0 to eth1 for icmp pa=
ckets :
+  # iptables -A PREROUTING -t mangle -p icmp -i eth0 -j ROUTE --iif eth1
 =20
diff -Nru netfilter.orig/userspace/extensions/libipt_ROUTE.c netfilter/us=
erspace/extensions/libipt_ROUTE.c
--- netfilter.orig/userspace/extensions/libipt_ROUTE.c	Thu Dec  5 21:44:3=
8 2002
+++ netfilter/userspace/extensions/libipt_ROUTE.c	Wed Dec 18 12:26:37 200=
2
@@ -20,15 +20,17 @@
 {
 	printf(
 "ROUTE target v%s options:\n"
-"  --iface   name    Send the packet directly through this interface.\n"
-"  --to      ip      Route the packet as if its destination address was =
ip.\n"
+"  --oif   \tifname \t\tSend the packet out using `ifname' network inter=
face\n"
+"  --iif   \tifname \t\tChange the packet's incoming interface to `ifnam=
e'\n"
+"  --gw    \tip     \t\tRoute the packet via this gateway\n"
 "\n",
 IPTABLES_VERSION);
 }
=20
 static struct option opts[] =3D {
-	{ "iface", 1, 0, '1' },
-	{ "to", 1, 0, '2' },
+	{ "oif", 1, 0, '1' },
+	{ "iif", 1, 0, '2' },
+	{ "gw", 1, 0, '3' },
 	{ 0 }
 };
=20
@@ -39,12 +41,14 @@
 	struct ipt_route_target_info *route_info =3D=20
 		(struct ipt_route_target_info*)t->data;
=20
-	route_info->ifname[0] =3D '\0';
-	route_info->ipto =3D 0;
+	route_info->oif[0] =3D '\0';
+	route_info->iif[0] =3D '\0';
+	route_info->gw =3D 0;
 }
=20
-#define IPT_ROUTE_OPT_IF    0x01
-#define IPT_ROUTE_OPT_TO    0x02
+
+#define IPT_ROUTE_OPT_IF       0x01
+#define IPT_ROUTE_OPT_GW       0x02
=20
 /* Function which parses command options; returns true if it
    ate an option */
@@ -60,33 +64,51 @@
 	case '1':
 		if (*flags & IPT_ROUTE_OPT_IF)
 			exit_error(PARAMETER_PROBLEM,
-				   "Can't specify --iface twice");
+				   "Can't specify --oif twice or --oif with --iif");
=20
 		if (check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --iface");
+				   "Unexpected `!' after --oif");
=20
-		if (strlen(optarg) > sizeof(route_info->ifname) - 1)
+		if (strlen(optarg) > sizeof(route_info->oif) - 1)
 			exit_error(PARAMETER_PROBLEM,
 				   "Maximum interface name length %u",
-				   sizeof(route_info->ifname) - 1);
+				   sizeof(route_info->oif) - 1);
=20
-		strcpy(route_info->ifname, optarg);
+		strcpy(route_info->oif, optarg);
 		*flags |=3D IPT_ROUTE_OPT_IF;
 		break;
=20
 	case '2':
-		if (*flags & IPT_ROUTE_OPT_TO)
+		if (*flags & IPT_ROUTE_OPT_IF)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --iif twice or --iif with --oif");
+
+		if (check_inverse(optarg, &invert, NULL, 0))
+			exit_error(PARAMETER_PROBLEM,
+				   "Unexpected `!' after --iif");
+
+		if (strlen(optarg) > sizeof(route_info->iif) - 1)
 			exit_error(PARAMETER_PROBLEM,
-				   "Can't specify --to twice");
+				   "Maximum interface name length %u",
+				   sizeof(route_info->iif) - 1);
+
+		strcpy(route_info->iif, optarg);
+		*flags |=3D IPT_ROUTE_OPT_IF;
+		break;
=20
-		if (!inet_aton(optarg, (struct in_addr*)&route_info->ipto)) {
+	case '3':
+		if (*flags & IPT_ROUTE_OPT_GW)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --gw twice");
+
+		if (!inet_aton(optarg, (struct in_addr*)&route_info->gw)) {
 			exit_error(PARAMETER_PROBLEM,
 				   "Invalid IP address %s",
 				   optarg);
 		}
=20
-		*flags |=3D IPT_ROUTE_OPT_TO;
+		*flags |=3D IPT_ROUTE_OPT_GW;
 		break;
=20
 	default:
@@ -96,14 +118,16 @@
 	return 1;
 }
=20
+
 static void
 final_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
-		           "ROUTE target: minimum 1 parameter is required");
+		           "ROUTE target: one parameter is required");
 }
=20
+
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
@@ -115,15 +139,38 @@
=20
 	printf("ROUTE ");
=20
-	if (route_info->ifname[0])
-		printf("iface %s ", route_info->ifname);
+	if (route_info->oif[0])
+		printf("oif %s ", route_info->oif);
+
+	if (route_info->iif[0])
+		printf("iif %s ", route_info->iif);
=20
-	if (route_info->ipto) {
-		struct in_addr ip =3D { route_info->ipto };
-		printf("to %s ", inet_ntoa(ip));
+	if (route_info->gw) {
+		struct in_addr ip =3D { route_info->gw };
+		printf("gw %s ", inet_ntoa(ip));
 	}
 }
=20
+
+static void save(const struct ipt_ip *ip,=20
+		 const struct ipt_entry_target *target)
+{
+	const struct ipt_route_target_info *route_info
+		=3D (const struct ipt_route_target_info *)target->data;
+
+	if (route_info->oif[0])
+		printf("--oif %s ", route_info->oif);
+
+	if (route_info->iif[0])
+		printf("--iif %s ", route_info->iif);
+
+	if (route_info->gw) {
+		struct in_addr ip =3D { route_info->gw };
+		printf("--gw %s ", inet_ntoa(ip));
+	}
+}
+
+
 static
 struct iptables_target route
 =3D { NULL,
@@ -136,7 +183,7 @@
     &parse,
     &final_check,
     &print,
-    NULL, /* save */
+    &save,
     opts
 };
=20

--=-UKWT7euwxloJAhIYn4pC--
