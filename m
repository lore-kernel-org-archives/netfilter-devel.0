From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] remove EXPERIMENTAL mark from some netfilter stuff
Date: Sun, 24 Aug 2003 10:43:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030824084352.GN6750@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4IFtMBbmeqbTM/ox"
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


--4IFtMBbmeqbTM/ox
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

The following patch removes the outdated EXPERIMENTAL dependency on lots
of netfitler stuff in 2.6.0-test4 kernel. =20

Please apply, thanks.


diff -Nru linux-2.6.0-test4-unclean/net/ipv6/netfilter/Kconfig linux-2.6.0-=
test4-cosmetic/net/ipv6/netfilter/Kconfig
--- linux-2.6.0-test4-unclean/net/ipv6/netfilter/Kconfig	2003-08-23 01:59:0=
5.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv6/netfilter/Kconfig	2003-08-24 00:21:=
01.000000000 +0200
@@ -3,14 +3,14 @@
 #
=20
 menu "IPv6: Netfilter Configuration"
-	depends on INET && EXPERIMENTAL && IPV6!=3Dn && NETFILTER
+	depends on INET && IPV6!=3Dn && NETFILTER
=20
 #tristate 'Connection tracking (required for masq/NAT)' CONFIG_IP6_NF_CONN=
TRACK
 #if [ "$CONFIG_IP6_NF_CONNTRACK" !=3D "n" ]; then
 #  dep_tristate '  FTP protocol support' CONFIG_IP6_NF_FTP $CONFIG_IP6_NF_=
CONNTRACK
 #fi
 config IP6_NF_QUEUE
-	tristate "Userspace queueing via NETLINK (EXPERIMENTAL)"
+	tristate "Userspace queueing via NETLINK"
 	---help---
=20
 	  This option adds a queue handler to the kernel for IPv6
@@ -62,7 +62,7 @@
=20
 config IP6_NF_MATCH_RT
 	tristate "Routing header match support"
-	depends on IP6_NF_IPTABLES && EXPERIMENTAL
+	depends on IP6_NF_IPTABLES
 	help
 	  rt matching allows you to match packets based on the routing
 	  header of the packet.
@@ -72,7 +72,7 @@
=20
 config IP6_NF_MATCH_OPTS
 	tristate "Hop-by-hop and Dst opts header match support"
-	depends on IP6_NF_IPTABLES && EXPERIMENTAL
+	depends on IP6_NF_IPTABLES
 	help
 	  This allows one to match packets based on the hop-by-hop
 	  and destination options headers of a packet.
@@ -82,7 +82,7 @@
=20
 config IP6_NF_MATCH_FRAG
 	tristate "Fragmentation header match support"
-	depends on IP6_NF_IPTABLES && EXPERIMENTAL
+	depends on IP6_NF_IPTABLES
 	help
 	  frag matching allows you to match packets based on the fragmentation
 	  header of the packet.
@@ -112,7 +112,7 @@
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
=20
 config IP6_NF_MATCH_OWNER
-	tristate "Owner match support (EXPERIMENTAL)"
+	tristate "Owner match support"
 	depends on IP6_NF_IPTABLES
 	help
 	  Packet owner matching allows you to match locally-generated packets
@@ -134,8 +134,8 @@
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
=20
 config IP6_NF_MATCH_IPV6HEADER
-	tristate "IPv6 Extension Headers Match (EXPERIMENTAL)"
-	depends on IP6_NF_IPTABLES && EXPERIMENTAL
+	tristate "IPv6 Extension Headers Match"
+	depends on IP6_NF_IPTABLES
 	help
 	  This module allows one to match packets based upon
 	  the ipv6 extension headers.
@@ -144,8 +144,8 @@
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
=20
 config IP6_NF_MATCH_AHESP
-	tristate "AH/ESP match support (EXPERIMENTAL)"
-	depends on IP6_NF_IPTABLES && EXPERIMENTAL
+	tristate "AH/ESP match support"
+	depends on IP6_NF_IPTABLES
 	help
 	  This module allows one to match AH and ESP packets.
=20
@@ -163,7 +163,7 @@
 	  Documentation/modules.txt.  If unsure, say `N'.
=20
 config IP6_NF_MATCH_EUI64
-	tristate "EUI64 address check (EXPERIMENTAL)"
+	tristate "EUI64 address check"
 	depends on IP6_NF_IPTABLES
 	help
 	  This module performs checking on the IPv6 source address
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/Kconfig linux-2.6.0-=
test4-cosmetic/net/ipv4/netfilter/Kconfig
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/Kconfig	2003-08-23 23:19:0=
6.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/Kconfig	2003-08-24 00:18:=
50.000000000 +0200
@@ -74,8 +74,7 @@
 	  <file:Documentation/modules.txt>.  If unsure, say `Y'.
=20
 config IP_NF_QUEUE
-	tristate "Userspace queueing via NETLINK (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Userspace queueing via NETLINK"
 	help
 	  Netfilter has the ability to queue packets to user space: the
 	  netlink device can be used to access them using this driver.
@@ -272,8 +271,8 @@
 	  Documentation/modules.txt.  If unsure, say `N'.
=20
 config IP_NF_MATCH_OWNER
-	tristate "Owner match support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && IP_NF_IPTABLES
+	tristate "Owner match support"
+	depends on IP_NF_IPTABLES
 	help
 	  Packet owner matching allows you to match locally-generated packets
 	  based on who created them: the user, group, process or session.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4IFtMBbmeqbTM/ox
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/SHrIXaXGVTD0i/8RAkGHAJ9vHwqfcuHPoODUEW4QoeLQkGw/OgCfRh5r
WLDmE1SDQG5O6Ve69F6shOo=
=+Og0
-----END PGP SIGNATURE-----

--4IFtMBbmeqbTM/ox--
