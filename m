From: =?ISO-8859-1?Q?C=E9dric?= de Launois <delaunois@info.ucl.ac.be>
Subject: [PATCH] New option for ROUTE target
Date: 22 Nov 2002 16:18:25 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1037978305.9490.24.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-s3PKOLRSxSQDi4Asy+5A"
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


--=-s3PKOLRSxSQDi4Asy+5A
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

I added a new option (--to option) for the ROUTE target. The ROUTE
target options are now:

  --iface name     : Send the packet directly through this 
                     interface.
  --to    w.x.y.z  : route the packet as if its destination IP address 
                     was w.x.y.z

This target never modifies packets but allows a different routing
scheme than the one provided by the standard kernel routing table.

Besides, the target can now apply on the PREROUTING, FORWARD and
POSTROUTING hook. Now, for example, you can use the ROUTE target to
force locally generated packets to go out a particular interface.

I've heard about the SWITCH target. It makes sense for me to see how
both targets can be integrated. But I need to know what is the precise
goal of the SWITCH target.

The patch is against the current cvs tree.

Cedric


--=-s3PKOLRSxSQDi4Asy+5A
Content-Disposition: attachment; filename=ROUTE.cvs.patch
Content-Type: text/x-patch; name=ROUTE.cvs.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by info.ucl.ac.be id QAA25274

diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch netfilter/patch-=
o-matic/extra/ROUTE.patch
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch	Sun Sep 22 13:25:41 20=
02
+++ netfilter/patch-o-matic/extra/ROUTE.patch	Fri Nov 22 16:14:59 2002
@@ -1,6 +1,6 @@
 diff -Nru linux.orig/include/linux/netfilter_ipv4/ipt_ROUTE.h linux/incl=
ude/linux/netfilter_ipv4/ipt_ROUTE.h
 --- linux.orig/include/linux/netfilter_ipv4/ipt_ROUTE.h	Thu Jan  1 01:00=
:00 1970
-+++ linux/include/linux/netfilter_ipv4/ipt_ROUTE.h	Thu Jun 20 11:18:09 2=
002
++++ linux/include/linux/netfilter_ipv4/ipt_ROUTE.h	Thu Nov 21 10:36:35 2=
002
 @@ -0,0 +1,17 @@
 +/* Header file for iptables ipt_ROUTE target
 + *
@@ -14,18 +14,20 @@
 +#define IPT_ROUTE_IFNAMSIZ 16
 +
 +struct ipt_route_target_info {
-+	unsigned int if_index;
-+	char if_name[IPT_ROUTE_IFNAMSIZ];
++	char ifname[IPT_ROUTE_IFNAMSIZ];
++	unsigned int ipto;
 +};
 +
 +#endif /*_IPT_ROUTE_H_target*/
 diff -Nru linux.orig/net/ipv4/netfilter/ipt_ROUTE.c linux/net/ipv4/netfi=
lter/ipt_ROUTE.c
 --- linux.orig/net/ipv4/netfilter/ipt_ROUTE.c	Thu Jan  1 01:00:00 1970
-+++ linux/net/ipv4/netfilter/ipt_ROUTE.c	Fri Sep 20 14:23:26 2002
-@@ -0,0 +1,269 @@
++++ linux/net/ipv4/netfilter/ipt_ROUTE.c	Fri Nov 22 14:53:06 2002
+@@ -0,0 +1,317 @@
 +/*
 + * This is a module which is used for directly sending a received packe=
t to
-+ * an interface specified by the user.
++ * an interface or a host specified by the user. This target NEVER modi=
fies=20
++ * packets but allows a different routing scheme than the one provided =
by=20
++ * the standard kernel routing table.
 + *
 + * Based on code from: ipt_MIRROR.c and various sources.
 + *
@@ -51,17 +53,26 @@
 +#endif
 +
 +
-+/* PRE : skb is the packet and ifindex is the interface index through w=
hich=20
-+ *       the packet should be rerouted
-+ * POST: if success, skb->dev is the output device with index 'ifindex'
-+ *       to which the packet must be sent and skb->dst is not NULL
++/* Try to route the packet according to the routing keys specified in
++ * route_info. Keys are :
++ *  - ifindex :=20
++ *      0 if no oif prefered,=20
++ *      otherwise set to the index of the desired oif
++ *  - route_info->ipto :
++ *      0 if no gateway specified,
++ *      otherwise set to the next host to which the pkt must be routed
++ * If success, skb->dev is the output device to which the packet must=20
++ * be sent and skb->dst is not NULL
++ *
 + * RETURN: -1 if an error occured
-+ *          1 if the packet has been succesfully rerouted to the device=
 with
-+ *            index 'ifindex', using the kernel routing table
-+ *          0 if the kernel routing table didn't yield the requested=20
-+ *            interface
++ *          1 if the packet was succesfully routed to the=20
++ *            destination desired
++ *          0 if the kernel routing table could not route the packet
++ *            according to the keys specified
 + */
-+static int route(struct sk_buff *skb, unsigned int ifindex)
++static int route(struct sk_buff *skb,
++		 unsigned int ifindex,
++		 const struct ipt_route_target_info *route_info)
 +{
 +	int err;
 +	struct rtable *rt;
@@ -73,16 +84,19 @@
 +		tos:RT_TOS(iph->tos)=20
 +	};
 +
++	/* The destination address may be overloaded by the target */
++	if (route_info->ipto)
++		key.dst =3D route_info->ipto;
++
 +	/* Trying to route the packet with the standard routing table. */
 +	if ((err =3D ip_route_output_key(&rt, &key))) {
 +		DEBUGP("ipt_ROUTE: couldn't route pkt (err: %i)",err);
 +		return -1;
 +	}
 +
-+	/* Check if the interface we are leaving by is the same as the
-+	 * one we requested.
-+	 */
-+	if (rt->u.dst.dev->ifindex =3D=3D ifindex) {
++	/* Success if no oif specified or if the oif correspond to the=20
++	 * one desired */
++	if (!ifindex || rt->u.dst.dev->ifindex =3D=3D ifindex) {
 +		/* Drop old route. */
 +		dst_release(skb->dst);
 +		skb->dst =3D &rt->u.dst;
@@ -95,6 +109,9 @@
 +	 * is one of our own addresses. This module makes it possible to
 +	 * reroute such packets by forcing the device to use.
 +	 */
++	DEBUGP("ipt_ROUTE: failed to route as desired (oif: %i)",=20
++	       rt->u.dst.dev->ifindex);
++
 +	return 0;
 +}
 +
@@ -147,7 +164,12 @@
 +	const struct ipt_route_target_info *route_info =3D targinfo;
 +	struct net_device *dev_out =3D NULL;
 +	struct sk_buff *skb =3D *pskb;
-+	unsigned int index =3D 0;
++	unsigned int ifindex =3D 0;
++
++	if (!route_info->ipto && !route_info->ifname[0]) {
++		DEBUGP(KERN_DEBUG "ipt_ROUTE: missing argument!\n");
++		return NF_ACCEPT;
++	}
 +
 +	/* raw socket (tcpdump) may have clone of incoming
 +	 * skb: don't disturb it
@@ -160,10 +182,10 @@
 +		skb =3D nskb;
 +	}
 +
-+	/* If we are not at FORWARD hook
++	/* If we are at PREROUTING hook
 +	 * the TTL isn't decreased by the IP stack
 +	 */
-+	if (hooknum !=3D NF_IP_FORWARD) {
++	if (hooknum =3D=3D NF_IP_PRE_ROUTING) {
 +		struct iphdr *iph =3D skb->nh.iph;
 +
 +		if (iph->ttl <=3D 1) {
@@ -192,7 +214,10 @@
 +		ip_decrease_ttl(iph);
 +	}
 +
-+	/* This packet will not be the same as before: clear nf fields */
++	/* Tell conntrack to forget this packet since it may get confused=20
++	 * when a packet is leaving with dst address =3D=3D our address.
++	 * Good idea ? Dunno. Need advice.
++	 */
 +	nf_conntrack_put(skb->nfct);
 +	skb->nfct =3D NULL;
 +	skb->nfcache =3D 0;
@@ -200,45 +225,66 @@
 +	skb->nf_debug =3D 0;
 +#endif
 +
-+	/* Getting the actual interface index */
-+	if ((index =3D route_info->if_index) =3D=3D 0) {
-+		/* The user specified a ifname, not a ifindex */
-+		if ((dev_out =3D dev_get_by_name(route_info->if_name)))
-+			index =3D dev_out->ifindex;
-+		else return NF_DROP;
++	if (route_info->ifname[0]) {
++		/* The user set the interface name to use.
++		 * Getting the current interface index.
++		 */
++		if ((dev_out =3D dev_get_by_name(route_info->ifname)))
++			ifindex =3D dev_out->ifindex;
++		else=20
++			/* Unknown interface name : packet dropped */
++			return NF_DROP;
++
 +	}
 +
-+	/* Trying the standard way */
-+	if (route(skb, index)=3D=3D1) {
++	DEBUGP(KERN_DEBUG "Index of %s is %i\n", route_info->ifname, ifindex);
++
++	/* Trying the standard way of routing packets */
++	if (route(skb, ifindex, route_info)=3D=3D1) {
++		DEBUGP(KERN_DEBUG "ROUTE ok, skb->dev->index=3D%i\n",
++		       skb->dev->ifindex);
++
 +		if (dev_out) dev_put(dev_out);
 +		if (ip_direct_send(skb) =3D=3D -EINVAL) return NF_DROP;
 +		return NF_STOLEN;
 +	}
 +
-+	/* Failed to correctly route. Trying the hard way */
-+	if (!dev_out) dev_out =3D dev_get_by_index(index);
++	if (!route_info->ifname[0]) {
++		if (dev_out) dev_put(dev_out);
++		return NF_DROP;
++	}
 +
-+	if (dev_out) {
++	/* Failed to correctly route. Trying the hard way */
 +
-+		/* Drop old route. */
-+		dst_release(skb->dst);
-+		skb->dst =3D NULL;
++	DEBUGP(KERN_DEBUG "HARD ROUTING\n");
 +
-+		/* Send the packet. This will also free skb !=20
-+		 * Do not go through the POST_ROUTING hook because=20
-+		 * skb->dst is not set and because it will probably
-+		 * get confused by the destination IP address.
-+		 */
-+		skb->dev =3D dev_out;
-+		dev_direct_send(skb);
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
 +		dev_put(dev_out);
-+
-+		return NF_STOLEN;
++		return NF_DROP;
 +	}
-+
-+	DEBUGP("ipt_ROUTE: Couldn't route the packet!\n");
-+
-+	return NF_DROP;
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
 +}
 +
 +
@@ -254,13 +300,15 @@
 +		return 0;
 +	}
 +
-+	if (hook_mask & ~(1 << NF_IP_PRE_ROUTING)) {
++	if (hook_mask & ~(  (1 << NF_IP_PRE_ROUTING)
++			  | (1 << NF_IP_FORWARD)
++			  | (1 << NF_IP_POST_ROUTING))) {
 +		printk("ipt_ROUTE: bad hook\n");
 +		return 0;
 +	}
 +
 +	if (targinfosize !=3D IPT_ALIGN(sizeof(struct ipt_route_target_info)))=
 {
-+		DEBUGP(KERN_WARNING "ipt_ROUTE: targinfosize %u !=3D %Zu\n",
++		printk(KERN_WARNING "ipt_ROUTE: targinfosize %u !=3D %Zu\n",
 +		       targinfosize,
 +		       IPT_ALIGN(sizeof(struct ipt_route_target_info)));
 +		return 0;
diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch.configure.help n=
etfilter/patch-o-matic/extra/ROUTE.patch.configure.help
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch.configure.help	Mon Jun=
 24 12:20:53 2002
+++ netfilter/patch-o-matic/extra/ROUTE.patch.configure.help	Fri Nov 22 1=
5:25:41 2002
@@ -2,11 +2,11 @@
 ROUTE target support
 CONFIG_IP_NF_TARGET_ROUTE
   This option adds a `ROUTE' target, which allows you to directly route
-  a received packet through a specified interface, even and especially
-  if the packet IP address is one of the router itself. Those packets=20
-  are locally delivered and cannot be forwarded to another computer=20
-  using the standard routing mechanisms.
-
+  a received packet through a specified interface or towards a host, eve=
n
+  if the regular destination of the packet is the router itself.
+  This target never modifies packets but allows a different routing sche=
me
+  than the one provided by the standard kernel routing table.
+ =20
   If you want to compile it as a module, say M here and read
   Documentation/modules.txt.  The module will be called ipt_ROUTE.o.
   If unsure, say `N'.
diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch.help netfilter/p=
atch-o-matic/extra/ROUTE.patch.help
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch.help	Sun Sep 22 13:25:=
41 2002
+++ netfilter/patch-o-matic/extra/ROUTE.patch.help	Fri Nov 22 16:14:40 20=
02
@@ -1,27 +1,28 @@
 Author: C=E9dric de Launois <delaunois@info.ucl.ac.be>
 Status: In Development/Works for me
  =20
-  This option adds a `ROUTE' target, which allows you to directly send
-  a received packet through a specified interface, even and especially
-  if the packet IP address is one of the router itself. Those packets=20
-  are locally delivered and cannot be forwarded to another computer=20
-  using the standard routing mechanisms.
-
-  This target is to be used inside the mangle table.
+  This option adds a `ROUTE' target, which allows you to directly route
+  a received packet through a specified interface or towards a host, eve=
n
+  if the regular destination of the packet is the router itself.
+  This target never modifies packets but allows a different routing sche=
me
+  than the one provided by the standard kernel routing table.
+	  =20
+  This target is to be used inside the mangle table, in the PREROUTING,
+  POSTROUTING or FORWARD hooks.
=20
   ROUTE target options:
-    --iface   name            Send the packet directly through iface nam=
e.
-    --ifindex index           Send the packet directly through iface ind=
ex.
+    --iface name      Send the packet directly through this interface.
+    --to    ip        Route the packet as if its destination address was=
 ip.
+
+  Examples :
=20
-  Example :
-  You want to install a ssh server on a computer inside your network but=
=20
-  you also want it to appear exactly as if it was located on the router.
-  A solution is to simply reroute packets with destination port 22 to th=
e
-  computer having the same IP as the router and hosting the ssh service,
-  thanks to this ROUTE target and an ipip tunnel.
+  To redirect all outgoing icmp packet to the eth1 interface :
+  # iptables -A POSTROUTING -t mangle -p icmp -j ROUTE --iface eth1
=20
-  # iptables -A PREROUTING -t mangle -i eth0 -p tcp --dport 22 -j ROUTE =
--iface tunl1
-  # iptables -A PREROUTING -t mangle -i tunl1 --j ROUTE --iface eth0
+  To tunnel all incoming http packets
+  # iptables -A PREROUTING -t mangle -p tcp --dport 80 -j ROUTE --iface =
tunl1
=20
+  To force the next-hop used for ssh packets
+  # iptables -A PREROUTING -t mangle -p tcp --dport 22 -j ROUTE --to w.x=
.y.z
=20
 =20
diff -Nru netfilter.orig/userspace/extensions/libipt_ROUTE.c netfilter/us=
erspace/extensions/libipt_ROUTE.c
--- netfilter.orig/userspace/extensions/libipt_ROUTE.c	Mon Jun 24 12:20:5=
3 2002
+++ netfilter/userspace/extensions/libipt_ROUTE.c	Fri Nov 22 16:14:30 200=
2
@@ -8,6 +8,9 @@
 #include <getopt.h>
 #include <iptables.h>
 #include <net/if.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ROUTE.h>
=20
@@ -17,15 +20,15 @@
 {
 	printf(
 "ROUTE target v%s options:\n"
-"  --iface   name                Send this packet directly through iface=
 name.\n"
-"  --ifindex index               Send this packet directly through iface=
 index.\n"
+"  --iface   name    Send the packet directly through this interface.\n"
+"  --to      ip      Route the packet as if its destination address was =
ip.\n"
 "\n",
 IPTABLES_VERSION);
 }
=20
 static struct option opts[] =3D {
 	{ "iface", 1, 0, '1' },
-	{ "ifindex", 1, 0, '2' },
+	{ "to", 1, 0, '2' },
 	{ 0 }
 };
=20
@@ -33,9 +36,15 @@
 static void
 init(struct ipt_entry_target *t, unsigned int *nfcache)
 {
+	struct ipt_route_target_info *route_info =3D=20
+		(struct ipt_route_target_info*)t->data;
+
+	route_info->ifname[0] =3D '\0';
+	route_info->ipto =3D 0;
 }
=20
 #define IPT_ROUTE_OPT_IF    0x01
+#define IPT_ROUTE_OPT_TO    0x02
=20
 /* Function which parses command options; returns true if it
    ate an option */
@@ -48,46 +57,36 @@
 		(struct ipt_route_target_info*)(*target)->data;
=20
 	switch (c) {
-		char *end;
 	case '1':
 		if (*flags & IPT_ROUTE_OPT_IF)
 			exit_error(PARAMETER_PROBLEM,
-				   "Can't specify --iface or --ifindex twice");
+				   "Can't specify --iface twice");
=20
 		if (check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --iface");
=20
-		if (strlen(optarg) > sizeof(route_info->if_name) - 1)
+		if (strlen(optarg) > sizeof(route_info->ifname) - 1)
 			exit_error(PARAMETER_PROBLEM,
 				   "Maximum interface name length %u",
-				   sizeof(route_info->if_name) - 1);
+				   sizeof(route_info->ifname) - 1);
=20
-		strcpy(route_info->if_name, optarg);
-		route_info->if_index =3D 0;
+		strcpy(route_info->ifname, optarg);
 		*flags |=3D IPT_ROUTE_OPT_IF;
 		break;
=20
 	case '2':
-		if (*flags & IPT_ROUTE_OPT_IF)
+		if (*flags & IPT_ROUTE_OPT_TO)
 			exit_error(PARAMETER_PROBLEM,
-				   "Can't specify --iface or --ifindex twice");
+				   "Can't specify --to twice");
=20
-		if (check_inverse(optarg, &invert, NULL, 0))
+		if (!inet_aton(optarg, (struct in_addr*)&route_info->ipto)) {
 			exit_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --ifindex");
-
-		route_info->if_name[0] =3D 0;
-		route_info->if_index =3D strtoul(optarg, &end, 0);
-		if (*end !=3D '\0' || end =3D=3D optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad ROUTE ifindex `%s'",
+				   "Invalid IP address %s",
 				   optarg);
+		}
=20
-		if (route_info->if_index =3D=3D 0)
-			exit_error(PARAMETER_PROBLEM,
-				   "Interface index can't be 0 !");
-
-		*flags |=3D IPT_ROUTE_OPT_IF;
+		*flags |=3D IPT_ROUTE_OPT_TO;
 		break;
=20
 	default:
@@ -102,7 +101,7 @@
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
-		           "ROUTE target: Parameter --iface is required");
+		           "ROUTE target: minimum 1 parameter is required");
 }
=20
 /* Prints out the targinfo. */
@@ -116,10 +115,13 @@
=20
 	printf("ROUTE ");
=20
-	if (route_info->if_name[0] !=3D 0)
-		printf("iface %s ", route_info->if_name);
-	else=20
-		printf("ifindex %u ", route_info->if_index);
+	if (route_info->ifname[0])
+		printf("iface %s ", route_info->ifname);
+
+	if (route_info->ipto) {
+		struct in_addr ip =3D { route_info->ipto };
+		printf("to %s ", inet_ntoa(ip));
+	}
 }
=20
 static

--=-s3PKOLRSxSQDi4Asy+5A--
