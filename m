From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] netfilter: add size check for udp packet mangling
Date: Thu, 2 Oct 2003 16:29:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002142937.GE5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="swlN0wgI/kvYg8fI"
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


--swlN0wgI/kvYg8fI
Content-Type: multipart/mixed; boundary="RCtlW7D4TSjJV1yL"
Content-Disposition: inline


--RCtlW7D4TSjJV1yL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

Please apply the following patch to your 2.6 tree and push it for kernel
inclusion, thanks.

Author: Patrick McHardy <kaber@trash.net>

Add size check to ip_nat_mangle_udp_packet

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--RCtlW7D4TSjJV1yL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="76_mangle_udp-sizecheck.patch"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1355  -> 1.1356=20
#	net/ipv4/netfilter/ip_nat_helper.c	1.18    -> 1.19  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/09/27	kaber@trash.net	1.1356
# [NETFILTER]: Add size check to ip_nat_mangle_udp_packet
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ip_nat_helper.c b/net/ipv4/netfilter/ip_nat_=
helper.c
--- a/net/ipv4/netfilter/ip_nat_helper.c	Sat Sep 27 21:08:22 2003
+++ b/net/ipv4/netfilter/ip_nat_helper.c	Sat Sep 27 21:08:22 2003
@@ -217,6 +217,12 @@
 	struct iphdr *iph;
 	struct udphdr *udph;
=20
+	/* UDP helpers might accidentally mangle the wrong packet */
+	iph =3D (*pskb)->nh.iph;
+	if ((*pskb)->len < iph->ihl*4 + sizeof(*udph) +=20
+	                       match_offset + match_len)
+		return 0;
+
 	if (!skb_ip_make_writable(pskb, (*pskb)->len))
 		return 0;
=20

--RCtlW7D4TSjJV1yL--

--swlN0wgI/kvYg8fI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fDZRXaXGVTD0i/8RAsMnAJkB7GeKt+/w9514XLiY/uSla4wtegCgm9MS
5XDUwtw8OM8FmtafloOts30=
=wvWZ
-----END PGP SIGNATURE-----

--swlN0wgI/kvYg8fI--
