From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] trivial: fix email address in MODULE_AUTHOR
Date: Sat, 30 Aug 2003 22:05:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030830200504.GP17715@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="en6jyp4HM4Tn+Q16"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	trivial@rustcorp.com.au
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


--en6jyp4HM4Tn+Q16
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Sorry to bother you with something trivial like this...

Please apply, thanks.


--- linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_physdev.c	2003-08-30 =
21:45:31.000000000 +0200
+++ linux-2.6.0-test4-cosmetic-bart/net/ipv4/netfilter/ipt_physdev.c	2003-0=
8-30 21:45:44.000000000 +0200
@@ -9,7 +9,7 @@
 #define NOMATCH 0
=20
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Bart De Schuymer <bdschuy@pandora.be>");
+MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
 MODULE_DESCRIPTION("iptables bridge physical device match module");
=20
 static int
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--en6jyp4HM4Tn+Q16
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/UQNwXaXGVTD0i/8RAgGJAJ9dMjJueGu3kgWoI1apkgFkaKasaQCfQlMz
nxcsZx/YAaopPUN3/E7SwPg=
=dLqo
-----END PGP SIGNATURE-----

--en6jyp4HM4Tn+Q16--
