From: =?ISO-8859-1?Q?C=E9dric?= de Launois <delaunoi@info.ucl.ac.be>
Subject: [PATCH] libipt_ROUTE.c : compilation errors
Date: 17 Jun 2002 18:12:47 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1024330367.11605.52.camel@descartes>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-HGjGbApED0PEUAdxL1Sz"
Cc: Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Netfilter-devel <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-HGjGbApED0PEUAdxL1Sz
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

I promise this is my last patch for today...

Here's a patch to fix two (harmless, but obviously wrong) compilation
errors in libipt_ROUTE.c. I used NETFILTER_VERSION where all=20
extensions are now using IPTABLES_VERSION, and I used the old
two-argument check_invert() where this function now has a four-argument
form.
Thanks Patrick !

I wasn't using the last cvs version when I programmed these lines...

The patch is against the current cvs tree.

C=E9dric

diff -Nru netfilter.orig/userspace/extensions/libipt_ROUTE.c
netfilter/userspace/extensions/libipt_ROUTE.c
--- netfilter.orig/userspace/extensions/libipt_ROUTE.c	Thu Jun 13
18:12:01 2002
+++ netfilter/userspace/extensions/libipt_ROUTE.c	Mon Jun 17 17:57:44
2002
@@ -21,7 +21,7 @@
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
@@ -57,7 +57,7 @@
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --iface or --ifindex twice");
=20
-		if (check_inverse(optarg, &invert))
+		if (check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --iface");
=20
@@ -74,7 +74,7 @@
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --iface or --ifindex twice");
=20
-		if (check_inverse(optarg, &invert))
+		if (check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --ifindex");
=20
@@ -124,7 +124,7 @@
 struct iptables_target route
 =3D { NULL,
     "ROUTE",
-    NETFILTER_VERSION,
+    IPTABLES_VERSION,
     IPT_ALIGN(sizeof(struct ipt_route_target_info)),
     IPT_ALIGN(sizeof(struct ipt_route_target_info)),
     &help,



--=-HGjGbApED0PEUAdxL1Sz
Content-Disposition: attachment; filename=ROUTE.cvs.patch
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; charset=ISO-8859-15

diff -Nru netfilter.orig/userspace/extensions/libipt_ROUTE.c netfilter/user=
space/extensions/libipt_ROUTE.c
--- netfilter.orig/userspace/extensions/libipt_ROUTE.c	Thu Jun 13 18:12:01 =
2002
+++ netfilter/userspace/extensions/libipt_ROUTE.c	Mon Jun 17 17:57:44 2002
@@ -21,7 +21,7 @@
 "  --iface   name                Send this packet directly through iface n=
ame.\n"
 "  --ifindex index               Send this packet directly through iface i=
ndex.\n"
 "\n",
-NETFILTER_VERSION);
+IPTABLES_VERSION);
 }
=20
 static struct option opts[] =3D {
@@ -57,7 +57,7 @@
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --iface or --ifindex twice");
=20
-		if (check_inverse(optarg, &invert))
+		if (check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --iface");
=20
@@ -74,7 +74,7 @@
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --iface or --ifindex twice");
=20
-		if (check_inverse(optarg, &invert))
+		if (check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --ifindex");
=20
@@ -124,7 +124,7 @@
 struct iptables_target route
 =3D { NULL,
     "ROUTE",
-    NETFILTER_VERSION,
+    IPTABLES_VERSION,
     IPT_ALIGN(sizeof(struct ipt_route_target_info)),
     IPT_ALIGN(sizeof(struct ipt_route_target_info)),
     &help,

--=-HGjGbApED0PEUAdxL1Sz--
