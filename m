From: Sven Schuster <schuster.sven@gmx.de>
Subject: [PATCH] fix bug in convert2pomng.sh
Date: Wed, 18 Feb 2004 11:18:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040218101816.GA13588@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
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


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Harald, hi Netfilter-devel-list,

attached you find a patch against convert2pomng.sh.
The original version didn't create additional .ladd files if there where
more than one entries to add. For example with the nfnetlink-ctnetlink
patch there were the files

nfnetlink-ctnetlink-0.13.patch.ip_conntrack.h
nfnetlink-ctnetlink-0.13.patch.ip_conntrack.h-2
nfnetlink-ctnetlink-0.13.patch.ip_conntrack.h-3
nfnetlink-ctnetlink-0.13.patch.ip_conntrack.h-3
nfnetlink-ctnetlink-0.13.patch.ip_conntrack.h-4
nfnetlink-ctnetlink-0.13.patch.ip_conntrack.h-5
nfnetlink-ctnetlink-0.13.patch.ip_conntrack.h-6
nfnetlink-ctnetlink-0.13.patch.ip_conntrack.h-7
nfnetlink-ctnetlink-0.13.patch.ip_conntrack.h-8

But because of an error in the script each part was created as=20

ip_conntrack.h.ladd

and so just the last part (...-8) went into pom-ng.

I tested this one and it worked, the parts were correctly created as

ip_conntrack.h.ladd
ip_conntrack.h.ladd_2
=2E..

I hope the fix is fine (and a diff for patch -p0 too :-)! If it is,
wouldn't most patches from pom need to be converted to pom-ng again??

BTW, I'm currently about to port the nfnetlink-ctnetlink patch to 2.6
(which actually brought my attention to this bug), is anyone else=20
working on this??


Regards

Sven



--- convert2pomng.sh.orig	Wed Feb 18 10:32:33 2004
+++ convert2pomng.sh	Wed Feb 18 10:55:54 2004
@@ -31,19 +31,19 @@
 done
=20
 for f in $PREFIX.makefile*; do
-	postfix=3D${f##$PREFIX.makefile} | sed -e s/-/_/
+	postfix=3D$(echo "${f##$PREFIX.makefile}" | sed -e s/-/_/)
 	newfile=3D$DESTDIR/linux/net/ipv4/netfilter/Makefile.ladd$postfix
 	cp $f $newfile
 done
=20
 for f in $PREFIX.config.in*; do
-	postfix=3D${f##$PREFIX.config.in} | sed -e s/-/_/
+	postfix=3D$(echo "${f##$PREFIX.config.in}" | sed -e s/-/_/)
 	newfile=3D$DESTDIR/linux/net/ipv4/netfilter/Config.in.ladd$postfix
 	cp $f $newfile
 done
=20
 for f in $PREFIX.ip_conntrack.h*; do
-	postfix=3D${f##$PREFIX.ip_conntrack.h} | sed -e s/-/_/
+	postfix=3D$(echo "${f##$PREFIX.ip_conntrack.h}" | sed -e s/-/_/)
 	newfile=3D$DESTDIR/linux/include/linux/netfilter_ipv4/ip_conntrack.h.ladd=
$postfix
 	cp $f $newfile
 done

--=20
Linux zion 2.6.3-rc2 #2 Fri Feb 13 00:07:44 CET 2004 i686 athlon i386 GNU/L=
inux
 11:14:59  up 1 day, 10:47,  4 users,  load average: 0.04, 0.04, 0.00

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAMzvoo4FAdB2PneQRAnFTAJ0VXAgWqWK7AbC2gpMSTy9PoppOggCfQlOp
cB8dZMZgfZgNIk3GxCcrMOA=
=eFT9
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
