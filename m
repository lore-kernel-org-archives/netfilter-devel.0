From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] netfilter cosmetic: add/correct copyright notices
Date: Tue, 27 Jan 2004 22:42:47 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040127214247.GC11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kf9dPzkPP9+q7vtQ"
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


--Kf9dPzkPP9+q7vtQ
Content-Type: multipart/mixed; boundary="livrSZtJkVq9DDdS"
Content-Disposition: inline


--livrSZtJkVq9DDdS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

The attached patch adds and/or corrects copyright notices and GPL
statements throughout the netfilter code.

It applies cleanly to 2.6.2-rc2.

Please apply,  thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--livrSZtJkVq9DDdS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="linux-2.6.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
conntrack_core.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter=
/ip_conntrack_core.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_conntrack_cor=
e.c	2003-12-18 05:35:25.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_conntrack=
_core.c	2004-01-19 08:04:46.136207776 -0500
@@ -2,8 +2,12 @@
    but required by, the NAT layer; it can also be used by an iptables
    extension. */
=20
-/* (c) 1999 Paul `Rusty' Russell.  Licenced under the GNU General
- * Public Licence.=20
+/* (C) 1999-2001 Paul `Rusty' Russell =20
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  *
  * 23 Apr 2001: Harald Welte <laforge@gnumonks.org>
  * 	- new API and handling of conntrack/nat helpers
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
conntrack_ftp.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/=
ip_conntrack_ftp.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_conntrack_ftp=
=2Ec	2003-12-18 05:39:12.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_conntrack=
_ftp.c	2004-01-19 08:04:56.932566480 -0500
@@ -1,4 +1,13 @@
 /* FTP extension for IP connection tracking. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell =20
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/config.h>
 #include <linux/module.h>
 #include <linux/netfilter.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
conntrack_proto_generic.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/=
netfilter/ip_conntrack_proto_generic.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_conntrack_pro=
to_generic.c	2003-12-18 05:37:07.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_conntrack=
_proto_generic.c	2004-01-19 08:06:15.186670048 -0500
@@ -1,3 +1,11 @@
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
conntrack_proto_icmp.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/net=
filter/ip_conntrack_proto_icmp.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_conntrack_pro=
to_icmp.c	2003-12-18 05:35:37.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_conntrack=
_proto_icmp.c	2004-01-19 08:06:40.476825360 -0500
@@ -1,3 +1,11 @@
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
conntrack_proto_tcp.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netf=
ilter/ip_conntrack_proto_tcp.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_conntrack_pro=
to_tcp.c	2003-12-18 05:40:02.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_conntrack=
_proto_tcp.c	2004-01-19 08:07:10.016334672 -0500
@@ -1,3 +1,11 @@
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
conntrack_proto_udp.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netf=
ilter/ip_conntrack_proto_udp.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_conntrack_pro=
to_udp.c	2003-12-18 05:35:24.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_conntrack=
_proto_udp.c	2004-01-19 08:07:43.372263800 -0500
@@ -1,3 +1,11 @@
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
conntrack_standalone.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/net=
filter/ip_conntrack_standalone.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_conntrack_sta=
ndalone.c	2003-12-18 05:37:39.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_conntrack=
_standalone.c	2004-01-19 08:08:22.153368176 -0500
@@ -4,8 +4,13 @@
    These are not required by the compatibility layer.
 */
=20
-/* (c) 1999 Paul `Rusty' Russell.  Licenced under the GNU General
-   Public Licence. */
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
=20
 #include <linux/config.h>
 #include <linux/types.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
conntrack_tftp.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter=
/ip_conntrack_tftp.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_conntrack_tft=
p.c	2003-12-18 05:37:02.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_conntrack=
_tftp.c	2004-01-19 08:09:35.904156352 -0500
@@ -1,5 +1,9 @@
-/*
- * Licensed under GNU GPL version 2 Copyright Magnus Boden <mb@ozaba.mine.=
nu>
+/* (C) 2001-2002 Magnus Boden <mb@ozaba.mine.nu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
  * Version: 0.0.7
  *
  * Thu 21 Mar 2002 Harald Welte <laforge@gnumonks.org>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
fw_compat.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_f=
w_compat.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_fw_compat.c	2=
003-12-18 05:37:27.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_fw_compat=
=2Ec	2004-01-19 08:15:18.972002112 -0500
@@ -1,5 +1,14 @@
 /* Compatibility framework for ipchains and ipfwadm support; designed
    to look as much like the 2.2 infrastructure as possible. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 struct notifier_block;
=20
 #include <linux/netfilter_ipv4.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
fw_compat_masq.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter=
/ip_fw_compat_masq.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_fw_compat_mas=
q.c	2003-12-18 05:39:15.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_fw_compat=
_masq.c	2004-01-19 08:10:45.167626704 -0500
@@ -4,6 +4,15 @@
    ports 61000:65095 (in 2.0 and 2.2 they get EADDRINUSE).  Just DON'T
    DO IT.
  */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/skbuff.h>
 #include <linux/in.h>
 #include <linux/ip.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
fw_compat_redir.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilte=
r/ip_fw_compat_redir.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_fw_compat_red=
ir.c	2003-12-18 05:39:01.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_fw_compat=
_redir.c	2004-01-19 08:11:09.512925656 -0500
@@ -7,6 +7,15 @@
    FIXME: Timing is overly simplistic.  If anyone complains, make it
    use conntrack.
 */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/config.h>
 #include <linux/netfilter.h>
 #include <linux/ip.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
nat_core.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_na=
t_core.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_nat_core.c	20=
03-12-18 05:36:23.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_nat_core.=
c	2004-01-19 08:12:02.036940792 -0500
@@ -1,7 +1,13 @@
 /* NAT for netfilter; shared with compatibility layer. */
=20
-/* (c) 1999 Paul `Rusty' Russell.  Licenced under the GNU General
-   Public Licence. */
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/timer.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
nat_ftp.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_nat=
_ftp.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_nat_ftp.c	200=
3-12-18 05:38:40.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_nat_ftp.c=
	2004-01-19 08:12:26.995146568 -0500
@@ -1,4 +1,13 @@
 /* FTP extension for TCP NAT alteration. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/ip.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
nat_helper.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_=
nat_helper.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_nat_helper.c	=
2003-12-18 05:36:25.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_nat_helpe=
r.c	2004-01-19 08:13:43.611499112 -0500
@@ -1,8 +1,11 @@
-/* ip_nat_mangle.c - generic support functions for NAT helpers=20
+/* ip_nat_helper.c - generic support functions for NAT helpers=20
  *
- * (C) 2000-2002 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2000-2002 Harald Welte <laforge@netfilter.org>
+ * (C) 2003-2004 Netfilter Core Team <coreteam@netfilter.org>
  *
- * distributed under the terms of GNU GPL
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  *
  * 	14 Jan 2002 Harald Welte <laforge@gnumonks.org>:
  *		- add support for SACK adjustment=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
nat_proto_icmp.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter=
/ip_nat_proto_icmp.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_nat_proto_icm=
p.c	2003-12-18 05:37:00.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_nat_proto=
_icmp.c	2004-01-19 08:14:15.562641800 -0500
@@ -1,3 +1,11 @@
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/netfilter.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
nat_proto_tcp.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/=
ip_nat_proto_tcp.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_nat_proto_tcp=
=2Ec	2003-12-18 05:35:37.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_nat_proto=
_tcp.c	2004-01-19 08:14:45.989016288 -0500
@@ -1,3 +1,11 @@
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/netfilter.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
nat_proto_udp.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/=
ip_nat_proto_udp.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_nat_proto_udp=
=2Ec	2003-12-18 05:36:28.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_nat_proto=
_udp.c	2004-01-19 08:15:12.266021576 -0500
@@ -1,3 +1,11 @@
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/netfilter.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
nat_proto_unknown.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfil=
ter/ip_nat_proto_unknown.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_nat_proto_unk=
nown.c	2003-12-18 05:37:55.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_nat_proto=
_unknown.c	2004-01-19 08:15:43.180321888 -0500
@@ -2,6 +2,14 @@
  * don't understand.  It's returned by ip_ct_find_proto().
  */
=20
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/netfilter.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
nat_rule.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_na=
t_rule.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_nat_rule.c	20=
03-12-18 05:37:31.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_nat_rule.=
c	2004-01-19 08:16:30.050196584 -0500
@@ -1,3 +1,11 @@
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 /* Everything about the rules for NAT. */
 #include <linux/types.h>
 #include <linux/ip.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
nat_standalone.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter=
/ip_nat_standalone.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_nat_standalon=
e.c	2003-12-18 05:39:12.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_nat_stand=
alone.c	2004-01-19 08:17:15.022359776 -0500
@@ -4,9 +4,15 @@
    These are not required by the compatibility layer.
 */
=20
-/* (c) 1999 Paul `Rusty' Russell.  Licenced under the GNU General
- * Public Licence.
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/*
  * 23 Apr 2001: Harald Welte <laforge@gnumonks.org>
  * 	- new API and handling of conntrack/nat helpers
  * 	- now capable of multiple expectations for one master
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
nat_tftp.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_na=
t_tftp.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_nat_tftp.c	20=
03-12-18 05:36:57.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_nat_tftp.=
c	2004-01-19 08:17:45.106786248 -0500
@@ -1,5 +1,9 @@
-/*
- * Licensed under GNU GPL version 2 Copyright Magnus Boden <mb@ozaba.mine.=
nu>
+/* (C) 2001-2002 Magnus Boden <mb@ozaba.mine.nu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
  * Version: 0.0.7
  *
  * Thu 21 Mar 2002 Harald Welte <laforge@gnumonks.org>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
queue.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_queue=
=2Ec
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_queue.c	2003-=
12-18 05:40:19.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_queue.c	2=
004-01-19 08:19:35.814956048 -0500
@@ -2,7 +2,11 @@
  * This is a module which is used for queueing IPv4 packets and
  * communicating with userspace via netlink.
  *
- * (C) 2000-2002 James Morris, this code is GPL.
+ * (C) 2000-2002 James Morris <jmorris@intercode.com.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  *
  * 2000-03-27: Simplified code (thanks to Andi Kleen for clues).
  * 2000-05-20: Fixed notifier problems (following Miguel Freitas' report).
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_=
tables.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_tabl=
es.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ip_tables.c	2003=
-12-18 05:36:41.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip_tables.c	=
2004-01-19 08:20:21.807964048 -0500
@@ -2,7 +2,11 @@
  * Packet matching code.
  *
  * Copyright (C) 1999 Paul `Rusty' Russell & Michael J. Neuling
- * Copyright (C) 2009-2002 Netfilter core team <coreteam@netfilter.org>
+ * Copyright (C) 2000-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  *
  * 19 Jan 2002 Harald Welte <laforge@gnumonks.org>
  * 	- increase module usage count as soon as we have rules inside
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_CLASSIFY.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_=
CLASSIFY.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_CLASSIFY.c	2=
003-12-18 05:35:26.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_CLASSIFY=
=2Ec	2004-01-19 08:22:12.977063776 -0500
@@ -3,6 +3,13 @@
  * of an skb for qdisc classification.
  */
=20
+/* (C) 2001-2002 Patrick McHardy <kaber@trash.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_DSCP.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_DSCP=
=2Ec
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_DSCP.c	2003-=
12-18 05:39:52.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_DSCP.c	2=
004-01-19 08:23:37.442223120 -0500
@@ -1,8 +1,11 @@
 /* iptables module for setting the IPv4 DSCP field, Version 1.8
  *
- * (C) 2002 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2002 by Harald Welte <laforge@netfilter.org>
  * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
- * This software is distributed under GNU GPL v2, 1991
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as=20
+ * published by the Free Software Foundation.
  *=20
  * See RFC2474 for a description of the DSCP field within the IP Header.
  *
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_ECN.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_ECN.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_ECN.c	2003-1=
2-18 05:40:00.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_ECN.c	20=
04-01-19 08:24:33.795656096 -0500
@@ -1,9 +1,11 @@
 /* iptables module for the IPv4 and TCP ECN bits, Version 1.5
  *
- * (C) 2002 by Harald Welte <laforge@gnumonks.org>
- *=20
- * This software is distributed under GNU GPL v2, 1991
+ * (C) 2002 by Harald Welte <laforge@netfilter.org>
  *=20
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as=20
+ * published by the Free Software Foundation.
+ *
  * ipt_ECN.c,v 1.5 2002/08/18 19:36:51 laforge Exp
 */
=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_LOG.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_LOG.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_LOG.c	2003-1=
2-18 05:39:26.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_LOG.c	20=
04-01-19 08:25:01.721410736 -0500
@@ -1,6 +1,15 @@
 /*
  * This is a module which is used for logging packets.
  */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/skbuff.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_MARK.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_MARK=
=2Ec
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_MARK.c	2003-=
12-18 05:38:10.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_MARK.c	2=
004-01-19 08:25:41.876306264 -0500
@@ -1,4 +1,12 @@
 /* This is a module which is used for setting the NFMARK field of an skb. =
*/
+
+/* (C) 1999-2001 Marc Boucher <marc@mbsi.ca>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_MASQUERADE.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip=
t_MASQUERADE.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_MASQUERADE.c=
	2003-12-18 05:38:29.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_MASQUERA=
DE.c	2004-01-19 08:26:01.530318400 -0500
@@ -1,5 +1,14 @@
 /* Masquerade.  Simple mapping which alters range to a local IP address
    (depending on route). */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/config.h>
 #include <linux/types.h>
 #include <linux/ip.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_NETMAP.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_NE=
TMAP.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_NETMAP.c	200=
3-12-18 05:37:53.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_NETMAP.c=
	2004-01-19 08:27:32.730453872 -0500
@@ -1,9 +1,14 @@
 /* NETMAP - static NAT mapping of IP network addresses (1:1).
-   The mapping can be applied to source (POSTROUTING),
-   destination (PREROUTING), or both (with separate rules).
-
-   Author: Svenning Soerensen <svenning@post5.tele.dk>
-*/
+ * The mapping can be applied to source (POSTROUTING),
+ * destination (PREROUTING), or both (with separate rules).
+ */
+
+/* (C) 2000-2001 Svenning Soerensen <svenning@post5.tele.dk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
=20
 #include <linux/config.h>
 #include <linux/ip.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_REDIRECT.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_=
REDIRECT.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_REDIRECT.c	2=
003-12-18 05:37:03.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_REDIRECT=
=2Ec	2004-01-19 08:28:13.712223696 -0500
@@ -1,4 +1,12 @@
 /* Redirect.  Simple mapping which alters dst to a local IP address. */
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/types.h>
 #include <linux/ip.h>
 #include <linux/timer.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_REJECT.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_RE=
JECT.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_REJECT.c	200=
3-12-18 05:39:20.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_REJECT.c=
	2004-01-19 08:28:50.149684360 -0500
@@ -3,6 +3,15 @@
  * Added support for customized reject packets (Jozsef Kadlecsik).
  * Added support for ICMP type-3-code-13 (Maciej Soltysiak). [RFC 1812]
  */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/config.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_SAME.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_SAME=
=2Ec
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_SAME.c	2003-=
12-18 05:38:39.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_SAME.c	2=
004-01-19 08:30:22.195691240 -0500
@@ -1,7 +1,12 @@
 /* Same.  Just like SNAT, only try to make the connections
  * 	  between client A and server B always have the same source ip.
  *
- * (C) 2000 Rusty Russell.  GPL.
+ * (C) 2000 Paul `Rusty' Russell
+ * (C) 2001 Martin Josefsson
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  *
  * 010320 Martin Josefsson <gandalf@wlug.westbo.se>
  * 	* copied ipt_BALANCE.c to ipt_SAME.c and changed a few things.
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_TCPMSS.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_TC=
PMSS.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_TCPMSS.c	200=
3-12-18 05:37:54.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_TCPMSS.c=
	2004-01-19 08:31:11.572184872 -0500
@@ -1,8 +1,13 @@
 /*
  * This is a module which is used for setting the MSS option in TCP packet=
s.
  *
- * Copyright (c) 2000 Marc Boucher
+ * Copyright (C) 2000 Marc Boucher <marc@mbsi.ca>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_TOS.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_TOS.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_TOS.c	2003-1=
2-18 05:35:49.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_TOS.c	20=
04-01-19 08:32:18.368030360 -0500
@@ -1,4 +1,13 @@
 /* This is a module which is used for setting the TOS field of a packet. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_ULOG.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_ULOG=
=2Ec
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_ULOG.c	2003-=
12-18 05:37:07.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_ULOG.c	2=
004-01-19 08:33:00.233665816 -0500
@@ -1,7 +1,7 @@
 /*
  * netfilter module for userspace packet logging daemons
  *
- * (C) 2000-2002 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2000-2002 by Harald Welte <laforge@netfilter.org>
  *
  * 2000/09/22 ulog-cprange feature added
  * 2001/01/04 in-kernel queue as proposed by Sebastian Zander=20
@@ -14,7 +14,12 @@
  * 2002/08/29 fix shifted/unshifted nlgroup bug -HW
  * 2002/10/30 fix uninitialized mac_len field - <Anders K. Pedersen>
  *
- * Released under the terms of the GPL
+ * (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  *
  * This module accepts two parameters:=20
  *=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_ah.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_ah.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_ah.c	2003-12=
-18 05:38:32.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_ah.c	200=
4-01-19 08:33:42.075304920 -0500
@@ -1,4 +1,11 @@
 /* Kernel module to match AH parameters. */
+/* (C) 1999-2000 Yon Uriarte <yon@astaro.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_conntrack.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt=
_conntrack.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_conntrack.c	=
2003-12-18 05:39:45.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_conntrac=
k.c	2004-01-19 08:34:20.240502928 -0500
@@ -1,7 +1,13 @@
 /* Kernel module to match connection tracking information.
  * Superset of Rusty's minimalistic state match.
- * GPL (C) 2001  Marc Boucher (marc@mbsi.ca).
+ *
+ * (C) 2001  Marc Boucher (marc@mbsi.ca).
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_dscp.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_dscp=
=2Ec
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_dscp.c	2003-=
12-18 05:38:55.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_dscp.c	2=
004-01-19 08:35:00.429393288 -0500
@@ -2,9 +2,11 @@
  *
  * ipt_dscp.c,v 1.3 2002/08/05 19:00:21 laforge Exp
  *
- * (C) 2002 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2002 by Harald Welte <laforge@netfilter.org>
  *
- * This software is distributed under the terms  GNU GPL
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  */
=20
 #include <linux/module.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_ecn.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_ecn.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_ecn.c	2003-1=
2-18 05:37:45.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_ecn.c	20=
04-01-19 08:35:28.478129232 -0500
@@ -4,7 +4,9 @@
  *
  * (C) 2002 by Harald Welte <laforge@gnumonks.org>
  *
- * This software is distributed under the terms GNU GPL v2
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  */
=20
 #include <linux/module.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_esp.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_esp.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_esp.c	2003-1=
2-18 05:37:54.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_esp.c	20=
04-01-19 08:35:46.369409344 -0500
@@ -1,4 +1,12 @@
 /* Kernel module to match ESP parameters. */
+
+/* (C) 1999-2000 Yon Uriarte <yon@astaro.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_helper.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_he=
lper.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_helper.c	200=
3-12-18 05:39:06.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_helper.c=
	2004-01-19 08:36:35.444948728 -0500
@@ -1,12 +1,15 @@
+/* iptables module to match on related connections */
 /*
- * iptables module to match on related connections
- *   (c) 2001 Martin Josefsson <gandalf@wlug.westbo.se>
+ * (C) 2001 Martin Josefsson <gandalf@wlug.westbo.se>
  *
- * Released under the terms of GNU GPLv2.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  *
  *   19 Mar 2002 Harald Welte <laforge@gnumonks.org>:
  *   		 - Port to newnat infrastructure
  */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_iprange.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_i=
prange.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_iprange.c	20=
03-12-18 05:37:53.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_iprange.=
c	2004-01-19 08:37:18.233443888 -0500
@@ -1,9 +1,11 @@
 /*
  * iptables module to match IP address ranges
- *   (c) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
  *
- * Released under the terms of GNU GPLv2.
+ * (C) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  */
 #include <linux/module.h>
 #include <linux/skbuff.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_length.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_le=
ngth.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_length.c	200=
3-12-18 05:39:08.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_length.c=
	2004-01-19 08:37:49.141745112 -0500
@@ -1,4 +1,11 @@
 /* Kernel module to match packet length. */
+/* (C) 1999-2001 James Morris <jmorros@intercode.com.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_limit.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_lim=
it.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_limit.c	2003=
-12-18 05:35:49.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_limit.c	=
2004-01-19 08:39:05.373156176 -0500
@@ -1,12 +1,18 @@
 /* Kernel module to control the rate
  *
- * J=E9r=F4me de Vivie   <devivie@info.enserb.u-bordeaux.fr>
- * Herv=E9 Eychenne   <eychenne@info.enserb.u-bordeaux.fr>
- *
  * 2 September 1999: Changed from the target RATE to the match
  *                   `limit', removed logging.  Did I mention that
  *                   Alexey is a fucking genius?
  *                   Rusty Russell (rusty@rustcorp.com.au).  */
+
+/* (C) 1999 J=E9r=F4me de Vivie <devivie@info.enserb.u-bordeaux.fr>
+ * (C) 1999 Herv=E9 Eychenne <eychenne@info.enserb.u-bordeaux.fr>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/spinlock.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_mac.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_mac.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_mac.c	2003-1=
2-18 05:35:59.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_mac.c	20=
04-01-19 08:39:26.554936056 -0500
@@ -1,4 +1,13 @@
 /* Kernel module to match MAC address parameters. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/if_ether.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_mark.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_mark=
=2Ec
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_mark.c	2003-=
12-18 05:40:36.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_mark.c	2=
004-01-19 08:39:48.030671248 -0500
@@ -1,4 +1,12 @@
 /* Kernel module to match NFMARK values. */
+
+/* (C) 1999-2001 Marc Boucher <marc@mbsi.ca>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_multiport.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt=
_multiport.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_multiport.c	=
2003-12-18 05:36:27.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_multipor=
t.c	2004-01-19 08:40:04.685139384 -0500
@@ -1,5 +1,14 @@
 /* Kernel module to match one of a list of TCP/UDP ports: ports are in
    the same place so we can treat them as equal. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/udp.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_owner.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_own=
er.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_owner.c	2003=
-12-18 05:39:49.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_owner.c	=
2004-01-19 08:40:32.248949048 -0500
@@ -1,8 +1,13 @@
 /* Kernel module to match various things tied to sockets associated with
-   locally generated outgoing packets.
+   locally generated outgoing packets. */
=20
-   Copyright (C) 2000 Marc Boucher
+/* (C) 2000 Marc Boucher <marc@mbsi.ca>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/file.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_physdev.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_p=
hysdev.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_physdev.c	20=
03-12-18 05:36:53.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_physdev.=
c	2004-01-19 08:41:12.689801104 -0500
@@ -1,5 +1,13 @@
 /* Kernel module to match the bridge port in and
  * out device for IP packets coming into contact with a bridge. */
+
+/* (C) 2001-2003 Bart De Schuymer <bdschuym@pandora.be>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter_ipv4/ipt_physdev.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_pkttype.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_p=
kttype.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_pkttype.c	20=
03-12-18 05:40:38.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_pkttype.=
c	2004-01-19 08:43:05.517648664 -0500
@@ -1,3 +1,10 @@
+/* (C) 1999-2001 Michal Ludvig <michal@logix.cz>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/if_ether.h>
@@ -7,6 +14,8 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
 MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Michal Ludvig <michal@logix.cz>");
+MODULE_DESCRIPTION("IP tables match to match on linklayer packet type");
=20
 static int match(const struct sk_buff *skb,
       const struct net_device *in,
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_state.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_sta=
te.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_state.c	2003=
-12-18 05:40:10.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_state.c	=
2004-01-19 08:43:51.525654384 -0500
@@ -1,6 +1,13 @@
-/* Kernel module to match connection tracking information.
- * GPL (C) 1999  Rusty Russell (rusty@rustcorp.com.au).
+/* Kernel module to match connection tracking information. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_tcpmss.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_tc=
pmss.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_tcpmss.c	200=
3-12-18 05:36:03.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_tcpmss.c=
	2004-01-19 08:44:22.331971112 -0500
@@ -1,4 +1,12 @@
 /* Kernel module to match TCP MSS values. */
+
+/* Copyright (C) 2000 Marc Boucher <marc@mbsi.ca>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <net/tcp.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_tos.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_tos.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_tos.c	2003-1=
2-18 05:39:52.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_tos.c	20=
04-01-19 08:44:45.089511440 -0500
@@ -1,4 +1,13 @@
 /* Kernel module to match TOS values. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
_ttl.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_ttl.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt_ttl.c	2003-1=
2-18 05:40:09.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ipt_ttl.c	20=
04-01-19 08:45:26.319243568 -0500
@@ -2,9 +2,11 @@
  *
  * ipt_ttl.c,v 1.5 2000/11/13 11:16:08 laforge Exp
  *
- * (C) 2000,2001 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2000,2001 by Harald Welte <laforge@netfilter.org>
  *
- * This software is distributed under the terms  GNU GPL
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  */
=20
 #include <linux/module.h>
@@ -13,7 +15,7 @@
 #include <linux/netfilter_ipv4/ipt_ttl.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
-MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
+MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("IP tables TTL matching module");
 MODULE_LICENSE("GPL");
=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
able_filter.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip=
table_filter.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/iptable_filter.c=
	2003-12-18 05:37:23.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/iptable_filt=
er.c	2004-01-19 08:45:53.856057336 -0500
@@ -2,7 +2,14 @@
  * This is the 1999 rewrite of IP Firewalling, aiming for kernel 2.3.x.
  *
  * Copyright (C) 1999 Paul `Rusty' Russell & Michael J. Neuling
+ * Copyright (C) 2000-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
  */
+
 #include <linux/module.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/ipt=
able_mangle.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/ip=
table_mangle.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv4/netfilter/iptable_mangle.c=
	2003-12-18 05:39:26.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/netfilter/iptable_mang=
le.c	2004-01-19 08:46:14.815870960 -0500
@@ -2,6 +2,11 @@
  * This is the 1999 rewrite of IP Firewalling, aiming for kernel 2.3.x.
  *
  * Copyright (C) 1999 Paul `Rusty' Russell & Michael J. Neuling
+ * Copyright (C) 2000-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  *
  * Extended to all five netfilter hooks by Brad Chapman & Harald Welte
  */
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
_queue.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6_que=
ue.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6_queue.c	2003=
-12-18 05:36:51.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6_queue.c	=
2004-01-19 08:47:59.291988176 -0500
@@ -8,6 +8,10 @@
  *     Universidad Politecnica de Alcala de Henares - Alcala de H. (Madrid=
) - Spain
  *     email: fanton@it.uc3m.es
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
  * 2001-11-06: First try. Working with ip_queue.c for IPv4 and trying
  *             to adapt it to IPv6
  *             HEAVILY based in ipqueue.c by James Morris. It's just
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
_tables.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6_ta=
bles.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6_tables.c	200=
3-12-18 05:39:27.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6_tables.c=
	2004-01-19 08:48:32.167990264 -0500
@@ -4,6 +4,10 @@
  * Copyright (C) 1999 Paul `Rusty' Russell & Michael J. Neuling
  * Copyright (C) 2000-2002 Netfilter core team <coreteam@netfilter.org>
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
  * 19 Jan 2002 Harald Welte <laforge@gnumonks.org>
  * 	- increase module usage count as soon as we have rules inside
  * 	  a table
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
t_LOG.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_LOG=
=2Ec
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6t_LOG.c	2003-=
12-18 05:36:57.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_LOG.c	2=
004-01-19 08:49:08.728432232 -0500
@@ -1,6 +1,15 @@
 /*
  * This is a module which is used for logging packets.
  */
+
+/* (C) 2001 Jan Rekorajski <baggins@pld.org.pl>
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
t_MARK.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_MA=
RK.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6t_MARK.c	2003=
-12-18 05:39:45.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_MARK.c	=
2004-01-19 08:49:32.041888048 -0500
@@ -1,4 +1,12 @@
 /* This is a module which is used for setting the NFMARK field of an skb. =
*/
+
+/* (C) 1999-2001 Marc Boucher <marc@mbsi.ca>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
t_ah.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_ah.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6t_ah.c	2003-1=
2-18 05:36:09.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_ah.c	20=
04-01-19 08:50:43.280058200 -0500
@@ -1,4 +1,12 @@
 /* Kernel module to match AH parameters. */
+
+/* (C) 2001-2002 Andras Kis-Szabo <kisza@sch.bme.hu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ipv6.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
t_dst.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_dst=
=2Ec
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6t_dst.c	2003-=
12-18 05:35:47.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_dst.c	2=
004-01-19 08:50:37.236976888 -0500
@@ -1,4 +1,13 @@
 /* Kernel module to match Hop-by-Hop and Destination parameters. */
+
+/* (C) 2001-2002 Andras Kis-Szabo <kisza@sch.bme.hu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ipv6.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
t_esp.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_esp=
=2Ec
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6t_esp.c	2003-=
12-18 05:38:27.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_esp.c	2=
004-01-19 08:50:57.887837480 -0500
@@ -1,4 +1,12 @@
 /* Kernel module to match ESP parameters. */
+/* (C) 2001-2002 Andras Kis-Szabo <kisza@sch.bme.hu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ipv6.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
t_eui64.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_e=
ui64.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6t_eui64.c	200=
3-12-18 05:35:38.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_eui64.c=
	2004-01-19 08:51:18.853650192 -0500
@@ -1,4 +1,12 @@
 /* Kernel module to match EUI64 address parameters. */
+
+/* (C) 2001-2002 Andras Kis-Szabo <kisza@sch.bme.hu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ipv6.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
t_frag.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_fr=
ag.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6t_frag.c	2003=
-12-18 05:36:37.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_frag.c	=
2004-01-19 08:51:43.487905216 -0500
@@ -1,4 +1,12 @@
 /* Kernel module to match FRAG parameters. */
+
+/* (C) 2001-2002 Andras Kis-Szabo <kisza@sch.bme.hu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ipv6.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
t_hbh.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_hbh=
=2Ec
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6t_hbh.c	2003-=
12-18 05:39:19.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_hbh.c	2=
004-01-19 08:52:01.977094432 -0500
@@ -1,4 +1,12 @@
 /* Kernel module to match Hop-by-Hop and Destination parameters. */
+
+/* (C) 2001-2002 Andras Kis-Szabo <kisza@sch.bme.hu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ipv6.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
t_hl.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_hl.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6t_hl.c	2003-1=
2-18 05:38:41.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_hl.c	20=
04-01-19 08:52:44.749592024 -0500
@@ -1,9 +1,11 @@
-/*
- * Hop Limit matching module
- * Maciej Soltysiak <solt@dns.toxicfilms.tv>
+/* Hop Limit matching module */
+
+/* (C) 2001-2002 Maciej Soltysiak <solt@dns.toxicfilms.tv>
  * Based on HW's ttl module
  *
- * This software is distributed under the terms  GNU GPL
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  */
=20
 #include <linux/module.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
t_ipv6header.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/i=
p6t_ipv6header.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6t_ipv6header.=
c	2003-12-18 05:40:15.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_ipv6hea=
der.c	2004-01-19 08:53:19.299339664 -0500
@@ -1,9 +1,16 @@
 /* ipv6header match - matches IPv6 packets based
-on whether they contain certain headers */
+   on whether they contain certain headers */
=20
 /* Original idea: Brad Chapman=20
  * Rewritten by: Andras Kis-Szabo <kisza@sch.bme.hu> */
=20
+/* (C) 2001-2002 Andras Kis-Szabo <kisza@sch.bme.hu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ipv6.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
t_length.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_=
length.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6t_length.c	20=
03-12-18 05:39:57.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_length.=
c	2004-01-19 08:53:49.951679800 -0500
@@ -1,5 +1,13 @@
 /* Length Match - IPv6 Port */
=20
+/* (C) 1999-2001 James Morris <jmorros@intercode.com.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter_ipv6/ip6t_length.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
t_limit.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_l=
imit.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6t_limit.c	200=
3-12-18 05:36:41.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_limit.c=
	2004-01-19 08:54:11.999328048 -0500
@@ -1,12 +1,18 @@
 /* Kernel module to control the rate
  *
- * J=E9r=F4me de Vivie   <devivie@info.enserb.u-bordeaux.fr>
- * Herv=E9 Eychenne   <eychenne@info.enserb.u-bordeaux.fr>
- *
  * 2 September 1999: Changed from the target RATE to the match
  *                   `limit', removed logging.  Did I mention that
  *                   Alexey is a fucking genius?
  *                   Rusty Russell (rusty@rustcorp.com.au).  */
+
+/* (C) 1999 J=E9r=F4me de Vivie <devivie@info.enserb.u-bordeaux.fr>
+ * (C) 1999 Herv=E9 Eychenne <eychenne@info.enserb.u-bordeaux.fr>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/spinlock.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
t_mac.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_mac=
=2Ec
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6t_mac.c	2003-=
12-18 05:39:44.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_mac.c	2=
004-01-19 08:54:36.410616968 -0500
@@ -1,4 +1,13 @@
 /* Kernel module to match MAC address parameters. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/if_ether.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
t_mark.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_ma=
rk.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6t_mark.c	2003=
-12-18 05:40:34.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_mark.c	=
2004-01-19 08:55:00.975882480 -0500
@@ -1,4 +1,13 @@
 /* Kernel module to match NFMARK values. */
+
+/* (C) 1999-2001 Marc Boucher <marc@mbsi.ca>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
t_multiport.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip=
6t_multiport.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6t_multiport.c=
	2003-12-18 05:40:04.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_multipo=
rt.c	2004-01-19 08:55:22.375629224 -0500
@@ -1,5 +1,14 @@
 /* Kernel module to match one of a list of TCP/UDP ports: ports are in
    the same place so we can treat them as equal. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/udp.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
t_owner.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_o=
wner.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6t_owner.c	200=
3-12-18 05:39:15.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_owner.c=
	2004-01-19 08:55:52.694020128 -0500
@@ -1,8 +1,13 @@
 /* Kernel module to match various things tied to sockets associated with
-   locally generated outgoing packets.
+   locally generated outgoing packets. */
=20
-   Copyright (C) 2000,2001 Marc Boucher
+/* (C) 2000-2001 Marc Boucher <marc@mbsi.ca>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/file.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
t_rt.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_rt.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6t_rt.c	2003-1=
2-18 05:36:49.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6t_rt.c	20=
04-01-19 08:56:16.796356016 -0500
@@ -1,4 +1,12 @@
 /* Kernel module to match ROUTING parameters. */
+
+/* (C) 2001-2002 Andras Kis-Szabo <kisza@sch.bme.hu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ipv6.h>
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
table_filter.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/i=
p6table_filter.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6table_filter.=
c	2003-12-18 05:35:56.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6table_fil=
ter.c	2004-01-19 08:56:45.606976136 -0500
@@ -2,7 +2,13 @@
  * This is the 1999 rewrite of IP Firewalling, aiming for kernel 2.3.x.
  *
  * Copyright (C) 1999 Paul `Rusty' Russell & Michael J. Neuling
+ * Copyright (C) 2000-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  */
+
 #include <linux/module.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6=
table_mangle.c linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/i=
p6table_mangle.c
--- linuxppc25bh-031218-orinoco_monitor/net/ipv6/netfilter/ip6table_mangle.=
c	2003-12-18 05:37:28.000000000 -0500
+++ linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv6/netfilter/ip6table_man=
gle.c	2004-01-19 08:57:08.802449888 -0500
@@ -2,6 +2,13 @@
  * IPv6 packet mangling table, a port of the IPv4 mangle table to IPv6
  *
  * Copyright (C) 2000-2001 by Harald Welte <laforge@gnumonks.org>
+ * Copyright (C) 2000-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Extended to all five netfilter hooks by Brad Chapman & Harald Welte
  */
 #include <linux/module.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>

--livrSZtJkVq9DDdS--

--Kf9dPzkPP9+q7vtQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAFttXXaXGVTD0i/8RAu46AJ45wNaTOu4i2v6avoNsc2ElSZuTjACfUXWU
rPE4PuDhE1MR5nMRfsj13yM=
=4GVa
-----END PGP SIGNATURE-----

--Kf9dPzkPP9+q7vtQ--
