From: Harald Welte <laforge@netfilter.org>
Subject: Re: help entries for CONFIG_IP_NF_ARP{TABLES,FILTER} ?
Date: Tue, 13 Jan 2004 01:06:58 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040113000658.GN20206@sunbeam.de.gnumonks.org>
References: <20040109024917.GD1440@fs.tum.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hNG1vEeyG8BCaHbQ"
Cc: netfilter-devel@lists.netfilter.org, David Miller <davem@redhat.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Adrian Bunk <bunk@fs.tum.de>
Content-Disposition: inline
In-Reply-To: <20040109024917.GD1440@fs.tum.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--hNG1vEeyG8BCaHbQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 09, 2004 at 03:49:17AM +0100, Adrian Bunk wrote:
> Hi Harald,
>=20
> both kernel 2.4 and 2.6 contain the CONFIG_IP_NF_ARP{TABLES,FILTER}=20
> options but lack help texts for these options. Could you (or someone=20
> else) provide help texts?

Sure, please see the attached help texts below.=20

David, please apply at your convenience.

--- linux-2.6.0-old/net/ipv4/netfilter/Kconfig	2003-10-25 20:44:33.00000000=
0 +0200
+++ linux-2.6.0/net/ipv4/netfilter/Kconfig	2004-01-13 00:58:46.000000000 +0=
100
@@ -529,10 +529,23 @@
=20
 config IP_NF_ARPTABLES
 	tristate "ARP tables support"
+	help
+	  arptables is a general, extensible packet identification framework.
+	  The ARP packet filtering and mangling (manipulation)subsystems
+	  use this: say Y or M here if you want to use either of those.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
=20
 config IP_NF_ARPFILTER
 	tristate "ARP packet filtering"
 	depends on IP_NF_ARPTABLES
+	help
+	  ARP packet filtering defines a table `filter', which has a series of
+	  rules for simple ARP packet filtering at local input and
+	  local output.  On a bridge, you can also specify filtering rules
+	  for forwarded ARP packets. See the man page for arptables(8).
+
+	  To compile it as a module, choose M here.  If unsure, say N.
=20
 config IP_NF_ARP_MANGLE
 	tristate "ARP payload mangling"


--- linux-2.4.24/Documentation/Configure.help	2003-11-28 19:26:19.000000000=
 +0100
+++ linux-2.4.24-help/Documentation/Configure.help	2004-01-13 01:05:32.0000=
00000 +0100
@@ -3235,11 +3235,32 @@
   If you want to compile it as a module, say M here and read
   <file:Documentation/modules.txt>.  If unsure, say `N'.
=20
+ARP tables support
+CONFIG_IP_NF_ARPTABLES
+  arptables is a general, extensible packet identification framework.
+  The ARP packet filtering and mangling (manipulation)subsystems
+  use this: say Y or M here if you want to use either of those.
+
+  If you want to compile it as a module, say M here and read
+  <file:Documentation/modules.txt>.  If unsure, say `N'.
+
+ARP packet filtering
+CONFIG_IP_NF_ARPFILTER
+  ARP packet filtering defines a table `filter', which has a series of
+  rules for simple ARP packet filtering at local input and
+  local output.  See the man page for arptables(8).
+
+  If you want to compile it as a module, say M here and read
+  <file:Documentation/modules.txt>.  If unsure, say `N'.
+
 ARP payload mangling
 CONFIG_IP_NF_ARP_MANGLE
   Allows altering the ARP packet payload: source and destination
   hardware and network addresses.
=20
+  If you want to compile it as a module, say M here and read
+  <file:Documentation/modules.txt>.  If unsure, say `N'.
+
 TCP Explicit Congestion Notification support
 CONFIG_INET_ECN
   Explicit Congestion Notification (ECN) allows routers to notify

> TIA
> Adrian

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--hNG1vEeyG8BCaHbQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAAzaiXaXGVTD0i/8RApWgAKCyocuUuDJk2ONv+W3nHnbXUPuK+gCbBDR5
aOvF+TOL3R2g4NZwecTLDX4=
=n1RR
-----END PGP SIGNATURE-----

--hNG1vEeyG8BCaHbQ--
