From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] cosmetic update to ip6t_ipv6header
Date: Thu, 2 Oct 2003 18:24:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002162456.GT5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O4VoXDY02cEAFJWy"
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


--O4VoXDY02cEAFJWy
Content-Type: multipart/mixed; boundary="YxhXyeZxSPLgOHN0"
Content-Disposition: inline


--YxhXyeZxSPLgOHN0
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

--YxhXyeZxSPLgOHN0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="66_ipv6header.patch"
Content-Transfer-Encoding: quoted-printable

diff -u linux.orig/net/ipv6/netfilter/ip6t_ipv6header.c linux/net/ipv6/netf=
ilter/ip6t_ipv6header.c
--- linux.orig/net/ipv6/netfilter/ip6t_ipv6header.c	2003-07-27 19:12:09.000=
000000 +0200
+++ linux/net/ipv6/netfilter/ip6t_ipv6header.c	2003-09-02 00:19:01.29517354=
4 +0200
@@ -129,20 +129,13 @@
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
 static struct ip6t_match
 ip6t_ipv6header_match =3D {
 	{ NULL, NULL },
 	"ipv6header",
 	&ipv6header_match,
 	&ipv6header_checkentry,
-	&ipv6header_destroy,
+	NULL,
 	THIS_MODULE
 };
=20

--YxhXyeZxSPLgOHN0--

--O4VoXDY02cEAFJWy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fFFYXaXGVTD0i/8RApwyAJ9dnHm0lxFXI64YkFx9fF76AZsNzgCfeNLc
/qo5V10iPVgGtxIDCqma3Og=
=1gCE
-----END PGP SIGNATURE-----

--O4VoXDY02cEAFJWy--
