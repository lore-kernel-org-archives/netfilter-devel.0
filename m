From: Gianni Tedesco <gianni@scaramanga.co.uk>
Subject: [PATCH]: mv .NETLINK.test .NETLINK-test
Date: 08 Jul 2003 14:04:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1057669496.10481.5.camel@sherbert>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZWFCcc7j+GEVbY2HEygn"
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-ZWFCcc7j+GEVbY2HEygn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Harald, all.

Slight bug in the 1.2.8 rev, .NETLINK.test should be .NETLINK-test
following patch fixes it, but would be easier to do mv, cvs delete, cvs
add.

Apologies if this is fixed in CVS.

diff -urN iptables-1.2.8.orig/extensions/.NETLINK-test iptables-1.2.8/exten=
sions/.NETLINK-test
--- iptables-1.2.8.orig/extensions/.NETLINK-test        Thu Jan  1 01:00:00=
 1970
+++ iptables-1.2.8/extensions/.NETLINK-test     Thu Feb 15 08:05:09 2001
@@ -0,0 +1,2 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/net/ipv4/netfilter/ipt_NETLINK.c ] && echo NETLINK
diff -urN iptables-1.2.8.orig/extensions/.NETLINK.test iptables-1.2.8/exten=
sions/.NETLINK.test
--- iptables-1.2.8.orig/extensions/.NETLINK.test        Thu Feb 15 08:05:09=
 2001
+++ iptables-1.2.8/extensions/.NETLINK.test     Thu Jan  1 01:00:00 1970
@@ -1,2 +0,0 @@
-#! /bin/sh
-[ -f $KERNEL_DIR/net/ipv4/netfilter/ipt_NETLINK.c ] && echo NETLINK

--=20
// Gianni Tedesco (gianni at scaramanga dot co dot uk)
lynx --source www.scaramanga.co.uk/gianni-at-ecsc.asc | gpg --import
8646BE7D: 6D9F 2287 870E A2C9 8F60 3A3C 91B5 7669 8646 BE7D


--=-ZWFCcc7j+GEVbY2HEygn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA/CsF4kbV2aYZGvn0RAkCcAJ9HkfEml0oI+QfP6+atXwH8lJkawQCfd4+h
D1iIx81I5Kirx8Ef/SFmky8=
=LX4V
-----END PGP SIGNATURE-----

--=-ZWFCcc7j+GEVbY2HEygn--
