From: Sven Schuster <schuster.sven@gmx.de>
Subject: [PATCH] another little fix for convert2pomng.sh
Date: Thu, 19 Feb 2004 00:52:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040218235222.GA10511@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Harald,

here is another little patch for convert2pomng.sh: in current pom-ng=20
the patch files are named "linux.patch" whereas the script would copy=20
them to a file just called "patch". This one is really trivial and
just for correctness as I think the script shouldn't be needed any
more in the future when old pom has become obsolete. I stumbled
across this while reconverting pom to pom-ng. Expect the results of
reconverting tomorrow in the evening.


Regards

Sven


--- patch-o-matic-ng/convert2pomng.sh.orig	2004-02-19 00:43:22.156364561 +0=
100
+++ patch-o-matic-ng/convert2pomng.sh	2004-02-19 00:44:18.526386326 +0100
@@ -52,7 +52,7 @@
 	rmdir -p $DESTDIR/$d
 done
=20
-cp $PREFIX $DESTDIR/patch
+cp $PREFIX $DESTDIR/linux.patch
 patch -d $DESTDIR/linux -p1 -i ../patch -r /dev/null -b
 find $DESTDIR/linux -name \*.orig -exec rm -f \{\} \;
=20

--=20
Linux zion 2.6.3-rc2 #2 Fri Feb 13 00:07:44 CET 2004 i686 athlon i386 GNU/L=
inux
 00:45:54  up 2 days, 18 min,  3 users,  load average: 0.04, 0.06, 0.05

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAM/q2o4FAdB2PneQRAvWeAJoDPqgzlKBNC4Y0MN2mdmX5Qwp9mwCeNmDF
exFY/Pg77fmSiCSSrStgc4M=
=tauW
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
