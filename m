From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] cosmetic update to ip6t_ipv6header
Date: Thu, 2 Oct 2003 18:22:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002162237.GS5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VQx8a0J3gVIvXT58"
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


--VQx8a0J3gVIvXT58
Content-Type: multipart/mixed; boundary="9Qa/g5WmKbBEiQ5Y"
Content-Disposition: inline


--9Qa/g5WmKbBEiQ5Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

Please apply the following patch to your 2.6 tree, thanks.


Author: Maciej Soltysiak
Status: Trivial

This patch removes unused destroy callback in ip6t_ipv6header.c
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--9Qa/g5WmKbBEiQ5Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="85_ipv6header.patch"
Content-Transfer-Encoding: quoted-printable

--- linux-2.6.0-test6-plain/net/ipv6/netfilter/ip6t_ipv6header.c	2003-10-02=
 18:32:18.000000000 +0200
+++ linux-2.6.0-test6-ipv6header/net/ipv6/netfilter/ip6t_ipv6header.c	2003-=
10-02 18:32:28.000000000 +0200
@@ -126,18 +126,11 @@
 	return 1;
 }
=20
-static void
-ipv6header_destroy(void *matchinfo,
-		   unsigned int matchinfosize)
-{
-	return;
-}
-
 static struct ip6t_match ip6t_ipv6header_match =3D {
 	.name		=3D "ipv6header",
 	.match		=3D &ipv6header_match,
 	.checkentry	=3D &ipv6header_checkentry,
-	.destroy	=3D &ipv6header_destroy,
+	.destroy	=3D NULL,
 	.me		=3D THIS_MODULE,
 };
=20

--9Qa/g5WmKbBEiQ5Y--

--VQx8a0J3gVIvXT58
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fFDNXaXGVTD0i/8RAqPYAJ9aT5ASGnN9AJiP1UUN93v6f2aOhgCcDddZ
ZOMDAH/GFMuhLaxWnx27/lQ=
=PCoS
-----END PGP SIGNATURE-----

--VQx8a0J3gVIvXT58--
