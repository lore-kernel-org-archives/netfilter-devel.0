From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] netfilter fix (6/7): nat 64bit bigendian fixes
Date: Tue, 24 Jun 2003 16:05:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624140532.GF2645@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XStn23h1fwudRqtG"
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


--XStn23h1fwudRqtG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Here goes the sixth...


Author: Jakub Bogusz <qboosh@pld.org.pl>

This patch fixes bugs related to machine endianess (harmless on
little-endians, but causing that some of conntrack modules don't work on
big-endian machines) in netfilter/ip_nat code.  Bugs are similar to those f=
ixed
in 42_conntrack-bigendian-fixes.patch (which fixed netfilter/ip_conntrack c=
ode).


--- linux-2.4.20/net/ipv4/netfilter/ip_nat_ftp.c.orig	Fri Nov 29 00:53:15 2=
002
+++ linux-2.4.20/net/ipv4/netfilter/ip_nat_ftp.c	Thu May 22 09:30:36 2003
@@ -84,7 +84,7 @@
 		mr.range[0].flags |=3D IP_NAT_RANGE_PROTO_SPECIFIED;
 		mr.range[0].min =3D mr.range[0].max
 			=3D ((union ip_conntrack_manip_proto)
-				{ htons(exp_ftp_info->port) });
+				{ .tcp =3D { htons(exp_ftp_info->port) } });
 	}
 	return ip_nat_setup_info(ct, &mr, hooknum);
 }
--- linux-2.4.20/net/ipv4/netfilter/ip_nat_snmp_basic.c.orig	Fri Nov 29 00:=
53:15 2002
+++ linux-2.4.20/net/ipv4/netfilter/ip_nat_snmp_basic.c	Thu May 22 10:27:06=
 2003
@@ -1309,9 +1309,9 @@
 	"snmp",
 	IP_NAT_HELPER_F_STANDALONE,
 	THIS_MODULE,
-	{ { 0, { __constant_htons(SNMP_PORT) } },
+	{ { 0, { .udp =3D { __constant_htons(SNMP_PORT) } } },
 	  { 0, { 0 }, IPPROTO_UDP } },
-	{ { 0, { 0xFFFF } },
+	{ { 0, { .udp =3D { 0xFFFF } } },
 	  { 0, { 0 }, 0xFFFF } },
 	nat_help, NULL };
 =20
@@ -1320,9 +1320,9 @@
 	"snmp_trap",
 	IP_NAT_HELPER_F_STANDALONE,
 	THIS_MODULE,
-	{ { 0, { __constant_htons(SNMP_TRAP_PORT) } },
+	{ { 0, { .udp =3D { __constant_htons(SNMP_TRAP_PORT) } } },
 	  { 0, { 0 }, IPPROTO_UDP } },
-	{ { 0, { 0xFFFF } },
+	{ { 0, { .udp =3D { 0xFFFF } } },
 	  { 0, { 0 }, 0xFFFF } },
 	nat_help, NULL };
=20
--- linux-2.4.20/net/ipv4/netfilter/ip_nat_amanda.c.orig	Tue May 20 11:18:2=
3 2003
+++ linux-2.4.20/net/ipv4/netfilter/ip_nat_amanda.c	Thu May 22 09:53:49 2003
@@ -84,7 +84,7 @@
 		mr.range[0].flags |=3D IP_NAT_RANGE_PROTO_SPECIFIED;
 		mr.range[0].min =3D mr.range[0].max
 			=3D ((union ip_conntrack_manip_proto)
-				{ htons(port) });
+				{ .udp =3D { htons(port) } });
 	}
=20
 	return ip_nat_setup_info(ct, &mr, hooknum);

=20

Please apply, thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--XStn23h1fwudRqtG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++FqsXaXGVTD0i/8RApQzAKCBWBQpvcI55jZHd6Ba9TlNhv9oOwCgsYDy
JswYzbfTb8mBdFAk/8QpRH4=
=cHWr
-----END PGP SIGNATURE-----

--XStn23h1fwudRqtG--
