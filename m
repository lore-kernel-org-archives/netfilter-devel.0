From: =?ISO-8859-1?Q?C=E9dric?= de Launois <delaunoi@info.ucl.ac.be>
Subject: [PATCH] use of mangle table enforced for ROUTE target
Date: 20 Sep 2002 14:41:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1032525681.3132.9.camel@descartes>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-8kONKAU4jjzureSOkEVw"
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


--=-8kONKAU4jjzureSOkEVw
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi all,

Here is a patch against the current CVS tree to enforce the use
of the mangle table for the ROUTE target.

The mangle table is the natural place for this target.
Since this target may crash the kernel if it is used inside
the nat table (the interaction with nat is not well understood), I=20
now force the use of the mangle table for the target.

A patch against the Netfilter Extension HOWTO will soon follow to
reflect this change.

C=E9dric de Launois



--=-8kONKAU4jjzureSOkEVw
Content-Disposition: attachment; filename=ROUTE.cvs.patch
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; charset=ISO-8859-15

diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch netfilter/patch-o-=
matic/extra/ROUTE.patch
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch	Mon Jun 24 12:20:53 2002
+++ netfilter/patch-o-matic/extra/ROUTE.patch	Fri Sep 20 14:39:16 2002
@@ -21,16 +21,12 @@
 +#endif /*_IPT_ROUTE_H_target*/
 diff -Nru linux.orig/net/ipv4/netfilter/ipt_ROUTE.c linux/net/ipv4/netfilt=
er/ipt_ROUTE.c
 --- linux.orig/net/ipv4/netfilter/ipt_ROUTE.c	Thu Jan  1 01:00:00 1970
-+++ linux/net/ipv4/netfilter/ipt_ROUTE.c	Thu Jun 20 14:22:59 2002
-@@ -0,0 +1,267 @@
++++ linux/net/ipv4/netfilter/ipt_ROUTE.c	Fri Sep 20 14:23:26 2002
+@@ -0,0 +1,269 @@
 +/*
-+ * This is a module which is used for directly resending a received packe=
t to
++ * This is a module which is used for directly sending a received packet =
to
 + * an interface specified by the user.
-+ * This module is particularly useful when the destination IP address is =
an
-+ * address owned by the router itself. Packets with such addresses are lo=
cally
-+ * delivered by the kernel and cannot be forwarded using the standard rou=
ting=20
-+ * mechanisms.
-+
++ *
 + * Based on code from: ipt_MIRROR.c and various sources.
 + *
 + * Copyright (C) 2002 Cedric de Launois <delaunois@info.ucl.ac.be>
@@ -252,6 +248,12 @@
 +				 unsigned int targinfosize,
 +				 unsigned int hook_mask)
 +{
++	if (strcmp(tablename, "mangle") !=3D 0) {
++		printk("ipt_ROUTE: bad table `%s', use the `mangle' table.\n",
++		       tablename);
++		return 0;
++	}
++
 +	if (hook_mask & ~(1 << NF_IP_PRE_ROUTING)) {
 +		printk("ipt_ROUTE: bad hook\n");
 +		return 0;
diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch.help netfilter/pat=
ch-o-matic/extra/ROUTE.patch.help
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch.help	Mon Jun 24 12:20:53=
 2002
+++ netfilter/patch-o-matic/extra/ROUTE.patch.help	Fri Sep 20 13:56:08 2002
@@ -1,13 +1,15 @@
 Author: C=E9dric de Launois <delaunois@info.ucl.ac.be>
 Status: In Development/Works for me
  =20
-  This option adds a `ROUTE' target, which allows you to directly resend
+  This option adds a `ROUTE' target, which allows you to directly send
   a received packet through a specified interface, even and especially
   if the packet IP address is one of the router itself. Those packets=20
   are locally delivered and cannot be forwarded to another computer=20
   using the standard routing mechanisms.
=20
-  ROUTE target v1.2.7 options:
+  This target is to be used inside the mangle table.
+
+  ROUTE target options:
     --iface   name            Send the packet directly through iface name.
     --ifindex index           Send the packet directly through iface index=
.
=20
@@ -18,8 +20,8 @@
   computer having the same IP as the router and hosting the ssh service,
   thanks to this ROUTE target and an ipip tunnel.
=20
-  # iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 22 -j ROUTE --ifa=
ce tunl1
-  # iptables -A PREROUTING -t nat -i tunl1 --j ROUTE --iface eth0
+  # iptables -A PREROUTING -t mangle -i eth0 -p tcp --dport 22 -j ROUTE --=
iface tunl1
+  # iptables -A PREROUTING -t mangle -i tunl1 --j ROUTE --iface eth0
=20
=20
 =20

--=-8kONKAU4jjzureSOkEVw--
