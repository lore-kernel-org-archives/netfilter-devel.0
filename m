From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: [PATCH] ROUTE target
Date: 24 Jun 2003 16:42:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056465726.2457.30.camel@descartes>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-DtJDVT8yn7LGPX1ZSC85"
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


--=-DtJDVT8yn7LGPX1ZSC85
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi !

Here is a new version of the ROUTE target. Following discussions,
it seems that there is a need to make the ROUTE target also a
non-final target. So I added a new option --force. When not using
this option, the behaviour is to set the route and continue traversal.
When using this option, the behaviour is as before, i.e. the packet
is sent and the packet is stolen. This remains useful when we have
to force the use of an interface (rather unfrequent).

Changes :
- ipt_ROUTE.c : 
     added --force option
     cosmetic changes
- ipt_ROUTE.h : added --force option
- libipt_ROUTE.c : added --force option
- ROUTE.patch.config.in : target kernel option now depends on
     CONFIG_IP_NF_MANGLE kernel option

The patch is against current cvs.

Cedric


--=-DtJDVT8yn7LGPX1ZSC85
Content-Disposition: attachment; filename=ROUTE.cvs.patch
Content-Type: text/x-patch; name=ROUTE.cvs.patch; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by info.ucl.ac.be id h5OEe5JX017137

diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch netfilter/patch-=
o-matic/extra/ROUTE.patch
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch	2003-06-24 15:10:12.00=
0000000 +0200
+++ netfilter/patch-o-matic/extra/ROUTE.patch	2003-06-24 15:22:19.0000000=
00 +0200
@@ -1,7 +1,7 @@
 diff -Nru linux.orig/include/linux/netfilter_ipv4/ipt_ROUTE.h linux/incl=
ude/linux/netfilter_ipv4/ipt_ROUTE.h
---- linux.orig/include/linux/netfilter_ipv4/ipt_ROUTE.h	Thu Jan  1 01:00=
:00 1970
-+++ linux/include/linux/netfilter_ipv4/ipt_ROUTE.h	Tue Dec 17 16:49:04 2=
002
-@@ -0,0 +1,18 @@
+--- linux.orig/include/linux/netfilter_ipv4/ipt_ROUTE.h	1970-01-01 01:00=
:00.000000000 +0100
++++ linux/include/linux/netfilter_ipv4/ipt_ROUTE.h	2003-06-24 10:40:54.0=
00000000 +0200
+@@ -0,0 +1,22 @@
 +/* Header file for iptables ipt_ROUTE target
 + *
 + * (C) 2002 by C=E9dric de Launois <delaunois@info.ucl.ac.be>
@@ -14,23 +14,27 @@
 +#define IPT_ROUTE_IFNAMSIZ 16
 +
 +struct ipt_route_target_info {
-+	char oif[IPT_ROUTE_IFNAMSIZ];
-+	char iif[IPT_ROUTE_IFNAMSIZ];
-+	unsigned int gw;
++	char      oif[IPT_ROUTE_IFNAMSIZ];      /* Output Interface Name */
++	char      iif[IPT_ROUTE_IFNAMSIZ];      /* Input Interface Name  */
++	u_int32_t gw;                           /* IP address of gateway */
++	u_int8_t  flags;
 +};
 +
++/* Values for "flags" field */
++#define IPT_ROUTE_FORCE        0x01
++
 +#endif /*_IPT_ROUTE_H_target*/
 diff -Nru linux.orig/net/ipv4/netfilter/ipt_ROUTE.c linux/net/ipv4/netfi=
lter/ipt_ROUTE.c
---- linux.orig/net/ipv4/netfilter/ipt_ROUTE.c	Thu Jan  1 01:00:00 1970
-+++ linux/net/ipv4/netfilter/ipt_ROUTE.c	Wed Feb 26 17:25:39 2003
-@@ -0,0 +1,359 @@
+--- linux.orig/net/ipv4/netfilter/ipt_ROUTE.c	1970-01-01 01:00:00.000000=
000 +0100
++++ linux/net/ipv4/netfilter/ipt_ROUTE.c	2003-06-24 15:19:15.000000000 +=
0200
+@@ -0,0 +1,370 @@
 +/*
 + * This implements the ROUTE target, which enables you to setup unusual
 + * routes not supported by the standard kernel routing table.
 + *
 + * Copyright (C) 2002 Cedric de Launois <delaunois@info.ucl.ac.be>
 + *
-+ * v 1.6 2003/02/26
++ * v 1.8 2003/06/24
 + *
 + * This software is distributed under GNU GPL v2, 1991
 + */
@@ -56,7 +60,7 @@
 +/* Try to route the packet according to the routing keys specified in
 + * route_info. Keys are :
 + *  - ifindex :=20
-+ *      0 if no oif prefered,=20
++ *      0 if no oif preferred,=20
 + *      otherwise set to the index of the desired oif
 + *  - route_info->gw :
 + *      0 if no gateway specified,
@@ -88,9 +92,10 @@
 +	if (route_info->gw)
 +		key.dst =3D route_info->gw;
 +=09
-+	/* Trying to route the packet with the standard routing table. */
++	/* Trying to route the packet using the standard routing table. */
 +	if ((err =3D ip_route_output_key(&rt, &key))) {
-+		DEBUGP("ipt_ROUTE: couldn't route pkt (err: %i)",err);
++		if (net_ratelimit())=20
++			DEBUGP("ipt_ROUTE: couldn't route pkt (err: %i)",err);
 +		return -1;
 +	}
 +=09
@@ -101,7 +106,6 @@
 +	/* Success if no oif specified or if the oif correspond to the=20
 +	 * one desired */
 +	if (!ifindex || rt->u.dst.dev->ifindex =3D=3D ifindex) {
-+		/* Drop old route. */
 +		skb->dst =3D &rt->u.dst;
 +		skb->dev =3D skb->dst->dev;
 +		return 1;
@@ -111,8 +115,9 @@
 +	 * specified by the user. This may happen because the dst address
 +	 * is one of our own addresses.
 +	 */
-+	DEBUGP("ipt_ROUTE: failed to route as desired (oif: %i)",=20
-+	       rt->u.dst.dev->ifindex);
++	if (net_ratelimit())=20
++		DEBUGP("ipt_ROUTE: failed to route as desired gw=3D%u.%u.%u.%u oif=3D=
%i (got oif=3D%i)\n",=20
++		       NIPQUAD(route_info->gw), ifindex, rt->u.dst.dev->ifindex);
 +=09
 +	return 0;
 +}
@@ -159,64 +164,70 @@
 +static unsigned int route_oif(const struct ipt_route_target_info *route=
_info,
 +			      struct sk_buff *skb)=20
 +{
-+	int err;
 +	unsigned int ifindex =3D 0;
 +	struct net_device *dev_out =3D NULL;
 +
 +	/* The user set the interface name to use.
 +	 * Getting the current interface index.
 +	 */
-+	if ((dev_out =3D dev_get_by_name(route_info->oif)))
++	if ((dev_out =3D dev_get_by_name(route_info->oif))) {
 +		ifindex =3D dev_out->ifindex;
-+	else=20
++	} else {
 +		/* Unknown interface name : packet dropped */
++		if (net_ratelimit())=20
++			DEBUGP("ipt_ROUTE: oif interface %s not found\n", route_info->oif);
 +		return NF_DROP;
-+=09
-+	DEBUGP(KERN_DEBUG "oif index of %s is %i\n", route_info->oif, ifindex)=
;
-+
-+
-+	/* Trying the standard way of routing packets */
-+	err =3D route(skb, ifindex, route_info);
-+	if (err=3D=3D1) {
-+		DEBUGP(KERN_DEBUG "ROUTE oif ok, skb->dev->index=3D%i\n",
-+		       skb->dev->ifindex);
-+
-+		dev_put(dev_out);
-+		ip_direct_send(skb);
-+		return NF_STOLEN;
 +	}
 +
-+	if (err) {
++	/* Trying the standard way of routing packets */
++	switch (route(skb, ifindex, route_info)) {
++	case 1:
 +		dev_put(dev_out);
-+		return NF_DROP;
-+	}
++		if (route_info->flags & IPT_ROUTE_FORCE) {
++			ip_direct_send(skb);
++			return NF_STOLEN;
++		}
 +
-+	/* Failed to send to oif. Trying the hard way */
++		return IPT_CONTINUE;
 +
-+	DEBUGP(KERN_DEBUG "HARD ROUTING\n");
++	case 0:
++		/* Failed to send to oif. Trying the hard way */
++		if (!(route_info->flags & IPT_ROUTE_FORCE))
++			return NF_DROP;
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
++		if (net_ratelimit())=20
++			DEBUGP("ipt_ROUTE: forcing the use of %i\n",
++			       ifindex);
++
++		/* We have to force the use of an interface.
++		 * This interface must be a tunnel interface since
++		 * otherwise we can't guess the hw address for
++		 * the packet. For a tunnel interface, no hw address
++		 * is needed.
++		 */
++		if ((dev_out->type !=3D ARPHRD_TUNNEL)
++		    && (dev_out->type !=3D ARPHRD_IPGRE)) {
++			if (net_ratelimit())=20
++				DEBUGP("ipt_ROUTE: can't guess the hw addr !\n");
++			dev_put(dev_out);
++			return NF_DROP;
++		}
++=09
++		/* Send the packet. This will also free skb
++		 * Do not go through the POST_ROUTING hook because=20
++		 * skb->dst is not set and because it will probably
++		 * get confused by the destination IP address.
++		 */
++		skb->dev =3D dev_out;
++		dev_direct_send(skb);
++		dev_put(dev_out);
++		return NF_STOLEN;
++	=09
++	default:
++		/* Unexpected error */
 +		dev_put(dev_out);
 +		return NF_DROP;
 +	}
-+=09
-+	/* Send the packet. This will also free skb
-+	 * Do not go through the POST_ROUTING hook because=20
-+	 * skb->dst is not set and because it will probably
-+	 * get confused by the destination IP address.
-+	 */
-+	skb->dev =3D dev_out;
-+	dev_direct_send(skb);
-+	dev_put(dev_out);
-+	return NF_STOLEN;
 +}
 +
 +
@@ -229,11 +240,12 @@
 +	/* Getting the current interface index. */
 +	if ((dev_out =3D dev_get_by_name(route_info->iif)))
 +		ifindex =3D dev_out->ifindex;
-+	else=20
++	else {
 +		/* Unknown interface name : packet dropped */
++		if (net_ratelimit())=20
++			DEBUGP("ipt_ROUTE: iif interface %s not found\n", route_info->oif);
 +		return NF_DROP;
-+
-+	DEBUGP(KERN_DEBUG "iif index of %s is %i\n", route_info->iif, ifindex)=
;
++	}
 +
 +	skb->dev =3D dev_out;
 +	dst_release(skb->dst);
@@ -251,12 +263,11 @@
 +	if (route(skb, 0, route_info)!=3D1)
 +		return NF_DROP;
 +
-+	DEBUGP(KERN_DEBUG "ROUTE gw ok, skb->dev->index=3D%i\n",
-+	       skb->dev->ifindex);
-+
-+	ip_direct_send(skb);
-+
-+	return NF_STOLEN;
++	if (route_info->flags & IPT_ROUTE_FORCE) {
++		ip_direct_send(skb);
++		return NF_STOLEN;
++	} else
++		return IPT_CONTINUE;
 +}
 +
 +
@@ -308,12 +319,14 @@
 +	 * when a packet is leaving with dst address =3D=3D our address.
 +	 * Good idea ? Dunno. Need advice.
 +	 */
-+	nf_conntrack_put(skb->nfct);
-+	skb->nfct =3D NULL;
-+	skb->nfcache =3D 0;
++	if (route_info->flags & IPT_ROUTE_FORCE) {
++		nf_conntrack_put(skb->nfct);
++		skb->nfct =3D NULL;
++		skb->nfcache =3D 0;
 +#ifdef CONFIG_NETFILTER_DEBUG
-+	skb->nf_debug =3D 0;
++		skb->nf_debug =3D 0;
 +#endif
++	}
 +
 +	if (route_info->oif[0])=20
 +		return route_oif(route_info, *pskb);
@@ -324,8 +337,10 @@
 +	if (route_info->gw)=20
 +		return route_gw(route_info, *pskb);
 +
-+	DEBUGP(KERN_DEBUG "ipt_ROUTE: no parameter !\n");
-+	return NF_ACCEPT;
++	if (net_ratelimit())=20
++		DEBUGP(KERN_DEBUG "ipt_ROUTE: no parameter !\n");
++
++	return IPT_CONTINUE;
 +}
 +
 +
diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch.config.in netfil=
ter/patch-o-matic/extra/ROUTE.patch.config.in
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch.config.in	2003-06-24 1=
5:10:12.000000000 +0200
+++ netfilter/patch-o-matic/extra/ROUTE.patch.config.in	2003-06-24 12:46:=
28.000000000 +0200
@@ -1,2 +1,2 @@
-  dep_tristate '  LOG target support' CONFIG_IP_NF_TARGET_LOG $CONFIG_IP=
_NF_IPTABLES
-  dep_tristate '  ROUTE target support' CONFIG_IP_NF_TARGET_ROUTE $CONFI=
G_IP_NF_IPTABLES
+    dep_tristate '    MARK target support' CONFIG_IP_NF_TARGET_MARK $CON=
FIG_IP_NF_MANGLE
+    dep_tristate '    ROUTE target support' CONFIG_IP_NF_TARGET_ROUTE $C=
ONFIG_IP_NF_MANGLE
diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch.configure.help n=
etfilter/patch-o-matic/extra/ROUTE.patch.configure.help
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch.configure.help	2003-06=
-24 15:10:12.000000000 +0200
+++ netfilter/patch-o-matic/extra/ROUTE.patch.configure.help	2003-06-24 1=
1:33:25.000000000 +0200
@@ -8,8 +8,8 @@
   packet is the router itself. The ROUTE target is also able to change t=
he=20
   incoming interface of a packet.
=20
-  This target does never modify the packet and is a final target.
-  It has to be used inside the mangle table.
+  The target can be or not a final target and has to be used inside the=20
+  mangle table.
=20
  =20
   If you want to compile it as a module, say M here and read
diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch.help netfilter/p=
atch-o-matic/extra/ROUTE.patch.help
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch.help	2003-06-24 15:10:=
12.000000000 +0200
+++ netfilter/patch-o-matic/extra/ROUTE.patch.help	2003-06-24 12:35:59.00=
0000000 +0200
@@ -8,24 +8,29 @@
   packet is the router itself. The ROUTE target is also able to change t=
he=20
   incoming interface of a packet.
=20
-  This target does never modify the packet and is a final target.
-  It has to be used inside the mangle table.
+  The target has to be used inside the mangle table.
=20
   ROUTE target options:
-    --oif   ifname    Send the packet out using `ifname' network interfa=
ce.
+    --oif   ifname    Route the packet through `ifname' network interfac=
e
     --iif   ifname    Change the packet's incoming interface to `ifname'.
     --gw    ip        Route the packet via this gateway.
+    --force           Force the use of the interface and send the packet.
+
+  The --force option can be used together with --oif or --gw. When using
+  this option, the target becomes a final target. Otherwise, the route
+  is simply set for the packet.
=20
   Examples :
=20
-  To redirect all outgoing icmp packet to the eth1 interface :
-  # iptables -A POSTROUTING -t mangle -p icmp -j ROUTE --oif eth1
+  To force all outgoing icmp packet to go through the eth1 interface=20
+  (final target) :
+  # iptables -A POSTROUTING -t mangle -p icmp -j ROUTE --oif eth1 --forc=
e
=20
   To tunnel all incoming http packets :
   # iptables -A PREROUTING -t mangle -p tcp --dport 80 -j ROUTE --oif tu=
nl1
=20
-  To force the next-hop used for ssh packets :
-  # iptables -A PREROUTING -t mangle -p tcp --dport 22 -j ROUTE --gw w.x=
.y.z
+  To change the the next-hop used for ssh packets :
+  # iptables -A POSTROUTING -t mangle -p tcp --dport 22 -j ROUTE --gw w.=
x.y.z
=20
   To change the incoming network interface from eth0 to eth1 for icmp pa=
ckets :
   # iptables -A PREROUTING -t mangle -p icmp -i eth0 -j ROUTE --iif eth1
diff -Nru netfilter.orig/userspace/extensions/libipt_ROUTE.c netfilter/us=
erspace/extensions/libipt_ROUTE.c
--- netfilter.orig/userspace/extensions/libipt_ROUTE.c	2003-06-24 15:10:1=
2.000000000 +0200
+++ netfilter/userspace/extensions/libipt_ROUTE.c	2003-06-24 15:19:48.000=
000000 +0200
@@ -1,5 +1,6 @@
 /* Shared library add-on to iptables to add ROUTE target support.
- * Author : C=E9dric de Launois, <delaunois@info.ucl.ac.be>
+ * Author : Cedric de Launois, <delaunois@info.ucl.ac.be>
+ * v 1.8 2003/06/24
  */
=20
 #include <stdio.h>
@@ -20,17 +21,19 @@
 {
 	printf(
 "ROUTE target v%s options:\n"
-"  --oif   \tifname \t\tSend the packet out using `ifname' network inter=
face\n"
+"  --oif   \tifname \t\tRoute the packet through `ifname' network interf=
ace\n"
 "  --iif   \tifname \t\tChange the packet's incoming interface to `ifnam=
e'\n"
 "  --gw    \tip     \t\tRoute the packet via this gateway\n"
+"  --force \t       \t\tForce the use of the interface and send the pack=
et\n"
 "\n",
-IPTABLES_VERSION);
+"1.8");
 }
=20
 static struct option opts[] =3D {
 	{ "oif", 1, 0, '1' },
 	{ "iif", 1, 0, '2' },
 	{ "gw", 1, 0, '3' },
+	{ "force", 0, 0, '4' },
 	{ 0 }
 };
=20
@@ -44,6 +47,7 @@
 	route_info->oif[0] =3D '\0';
 	route_info->iif[0] =3D '\0';
 	route_info->gw =3D 0;
+	route_info->flags =3D 0;
 }
=20
=20
@@ -111,6 +115,10 @@
 		*flags |=3D IPT_ROUTE_OPT_GW;
 		break;
=20
+	case '4':
+		route_info->flags |=3D IPT_ROUTE_FORCE;
+		break;
+
 	default:
 		return 0;
 	}
@@ -124,7 +132,7 @@
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
-		           "ROUTE target: one parameter is required");
+		           "ROUTE target: a oif, iif or gw parameter is required");
 }
=20
=20
@@ -149,6 +157,10 @@
 		struct in_addr ip =3D { route_info->gw };
 		printf("gw %s ", inet_ntoa(ip));
 	}
+
+	if (route_info->flags & IPT_ROUTE_FORCE)
+		printf("force");
+
 }
=20
=20
@@ -168,6 +180,9 @@
 		struct in_addr ip =3D { route_info->gw };
 		printf("--gw %s ", inet_ntoa(ip));
 	}
+
+	if (route_info->flags & IPT_ROUTE_FORCE)
+		printf("--force ");
 }
=20
=20

--=-DtJDVT8yn7LGPX1ZSC85--
