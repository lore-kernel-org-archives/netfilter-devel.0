From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: [PATCH] update to ROUTE target
Date: 25 Jul 2003 15:16:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1059138966.17205.31.camel@descartes>
References: <1056465726.2457.30.camel@descartes>
	 <1058517461.25182.139.camel@descartes>
	 <1058724909.8305.307.camel@tux.rsn.bth.se>
	 <1059126202.17206.15.camel@descartes>
	 <Pine.LNX.4.52.0307251336050.5863@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-wTpTN5rC6wmz9hmIshhQ"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <Pine.LNX.4.52.0307251336050.5863@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-wTpTN5rC6wmz9hmIshhQ
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by info.ucl.ac.be id h6PDCSb1010169

Hi again,

Oops, I forgot to also submit changes to the ROUTE.patch.configure.help
and ROUTE.patch.help files to update the descriptions of the target.

I also modified ROUTE.patch.configure.in in order to make the ROUTE
target dependent of the CONFIG_IP_NF_MANGLE kernel option (since the
ROUTE target must be used inside the mangle table).

The patch is still against the very current cvs.

Thanks for applying it.

C=E9dric


--=-wTpTN5rC6wmz9hmIshhQ
Content-Disposition: attachment; filename=ROUTE.cvs.patch
Content-Type: text/x-patch; name=ROUTE.cvs.patch; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by info.ucl.ac.be id h6PDCSb1010169

diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch.config.in netfil=
ter/patch-o-matic/extra/ROUTE.patch.config.in
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch.config.in	2003-07-25 1=
4:30:09.000000000 +0200
+++ netfilter/patch-o-matic/extra/ROUTE.patch.config.in	2003-07-25 14:10:=
49.000000000 +0200
@@ -1,2 +1,3 @@
-  dep_tristate '  LOG target support' CONFIG_IP_NF_TARGET_LOG $CONFIG_IP=
_NF_IPTABLES
-  dep_tristate '  ROUTE target support' CONFIG_IP_NF_TARGET_ROUTE $CONFI=
G_IP_NF_IPTABLES
+    dep_tristate '    MARK target support' CONFIG_IP_NF_TARGET_MARK $CON=
FIG_IP_NF_MANGLE
+    dep_tristate '    ROUTE target support' CONFIG_IP_NF_TARGET_ROUTE $C=
ONFIG_IP_NF_MANGLE
+=20
\ Pas de fin de ligne =E0 la fin du fichier.
diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch.configure.help n=
etfilter/patch-o-matic/extra/ROUTE.patch.configure.help
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch.configure.help	2003-07=
-25 14:30:09.000000000 +0200
+++ netfilter/patch-o-matic/extra/ROUTE.patch.configure.help	2003-07-25 1=
4:15:05.000000000 +0200
@@ -1,16 +1,14 @@
-CONFIG_IP_NF_TARGET_LOG
+CONFIG_IP_NF_TARGET_MARK
 ROUTE target support
 CONFIG_IP_NF_TARGET_ROUTE
   This option adds a `ROUTE' target, which enables you to setup unusual
-  routes not supported by the standard kernel routing table.
-  For example, the ROUTE lets you directly route a received packet throu=
gh=20
+  routes. For example, the ROUTE lets you route a received packet throug=
h=20
   an interface or towards a host, even if the regular destination of the=
=20
   packet is the router itself. The ROUTE target is also able to change t=
he=20
   incoming interface of a packet.
=20
-  This target does never modify the packet and is a final target.
-  It has to be used inside the mangle table.
-
+  The target can be or not a final target. It has to be used inside the=20
+  mangle table.
  =20
   If you want to compile it as a module, say M here and read
   Documentation/modules.txt.  The module will be called ipt_ROUTE.o.
diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch.help netfilter/p=
atch-o-matic/extra/ROUTE.patch.help
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch.help	2003-07-25 14:30:=
09.000000000 +0200
+++ netfilter/patch-o-matic/extra/ROUTE.patch.help	2003-07-25 14:51:25.00=
0000000 +0200
@@ -1,32 +1,37 @@
 Author: C=E9dric de Launois <delaunois@info.ucl.ac.be>
-Status: In Development/Works for me
+Status: Experimental
  =20
   This option adds a `ROUTE' target, which enables you to setup unusual
-  routes not supported by the standard kernel routing table.
-  For example, the ROUTE lets you directly route a received packet throu=
gh=20
+  routes. For example, the ROUTE lets you route a received packet throug=
h=20
   an interface or towards a host, even if the regular destination of the=
=20
   packet is the router itself. The ROUTE target is also able to change t=
he=20
   incoming interface of a packet.
=20
-  This target does never modify the packet and is a final target.
-  It has to be used inside the mangle table.
+  The target can be or not a final target. It has to be used inside the=20
+  mangle table.
=20
   ROUTE target options:
-    --oif   ifname    Send the packet out using `ifname' network interfa=
ce.
-    --iif   ifname    Change the packet's incoming interface to `ifname'.
-    --gw    ip        Route the packet via this gateway.
+  --oif   ifname    Send the packet out using `ifname' network interface.
+  --iif   ifname    Change the packet's incoming interface to `ifname'.
+  --gw    ip        Route the packet via this gateway.
+  --continue        Route the packet and continue traversing the rules.
=20
-  Examples :
-
-  To redirect all outgoing icmp packet to the eth1 interface :
-  # iptables -A POSTROUTING -t mangle -p icmp -j ROUTE --oif eth1
+  Note that --iif and --continue can't be used together.
=20
-  To tunnel all incoming http packets :
-  # iptables -A PREROUTING -t mangle -p tcp --dport 80 -j ROUTE --oif tu=
nl1
-
-  To force the next-hop used for ssh packets :
-  # iptables -A PREROUTING -t mangle -p tcp --dport 22 -j ROUTE --gw w.x=
.y.z
+  Examples :
=20
-  To change the incoming network interface from eth0 to eth1 for icmp pa=
ckets :
-  # iptables -A PREROUTING -t mangle -p icmp -i eth0 -j ROUTE --iif eth1
+  # To force all outgoing icmp packet to go through the eth1 interface=20
+  # (final target) :
+  iptables -A POSTROUTING -t mangle -p icmp -j ROUTE --oif eth1
 =20
+  # To tunnel outgoing http packets and continue traversing the rules :
+  iptables -A POSTROUTING -t mangle -p tcp --dport 80 -j ROUTE --oif tun=
l1 --continue
+=20
+  # To forward all ssh packets to gateway w.x.y.z, and continue traversi=
ng
+  # the rules :
+  iptables -A POSTROUTING -t mangle -p tcp --dport 22 -j ROUTE --gw w.x.=
y.z --continue
+=20
+  # To change the incoming network interface from eth0 to eth1 for all i=
cmp
+  # packets (final target) :
+  iptables -A PREROUTING -t mangle -p icmp -i eth0 -j ROUTE --iif eth1
+

--=-wTpTN5rC6wmz9hmIshhQ--
