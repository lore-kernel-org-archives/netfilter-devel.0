From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6+2.4] fix DEBUG compile in ipt_MASQUERADE
Date: Mon, 29 Mar 2004 12:44:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040329104437.GF1528@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VSaCG/zfRnOiPJtU"
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


--VSaCG/zfRnOiPJtU
Content-Type: multipart/mixed; boundary="a7XSrSxqzVsaECgU"
Content-Disposition: inline


--a7XSrSxqzVsaECgU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is a bugfix to ipt_MASQUERADE.c to make it compile when debugging
is switched on.  The patch applies cleanly to 2.4.x and 2.6.x.

Please submit,

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--a7XSrSxqzVsaECgU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.4.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nur linux-2.4.22-1.2115.nptl/net/ipv4/netfilter/ipt_MASQUERADE.c new/=
net/ipv4/netfilter/ipt_MASQUERADE.c
--- linux-2.4.22-1.2115.nptl/net/ipv4/netfilter/ipt_MASQUERADE.c	2003-10-29=
 23:18:34.000000000 +0300
+++ new/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-02-18 06:49:11.000000000 +=
0300
@@ -32,7 +32,7 @@
 	const struct ip_nat_multi_range *mr =3D targinfo;
=20
 	if (strcmp(tablename, "nat") !=3D 0) {
-		DEBUGP("masquerade_check: bad table `%s'.\n", table);
+		DEBUGP("masquerade_check: bad table `%s'.\n", tablename);
 		return 0;
 	}
 	if (targinfosize !=3D IPT_ALIGN(sizeof(*mr))) {

--a7XSrSxqzVsaECgU--

--VSaCG/zfRnOiPJtU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAZ/4VXaXGVTD0i/8RAiUKAJwOPjLejLwAn9tyjBf+XWjIAsbiggCeNLuT
+WpG80hai12s7tEOvhVdMQw=
=Yh25
-----END PGP SIGNATURE-----

--VSaCG/zfRnOiPJtU--
