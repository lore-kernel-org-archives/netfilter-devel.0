From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] ECN target wrong tcp csum on little endian
Date: Thu, 9 Jan 2003 15:50:46 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030109145046.GK9467@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a1taQt+5gib656GU"
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


--a1taQt+5gib656GU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is another patch of the series of patches you will receive from me tod=
ay.

Please apply to 2.4.x and 2.5.x, thanks.


Author: Patrick McHardy <kaber@trash.net>

The 2.4.20 kernel included the new iptables 'ECN' target, enabling a select=
ive
ECN disable mechanism.   Unfortunately there was a bug in the incremental T=
CP
checksum update, resulting in broken TCP checksums on little endian machine=
s.
This patch fixes the Bug.


--- linux.old/net/ipv4/netfilter/ipt_ECN.c.orig	2002-12-09 23:14:20.0000000=
00 +0100
+++ linux/net/ipv4/netfilter/ipt_ECN.c	2002-12-09 23:13:27.000000000 +0100
@@ -88,8 +88,8 @@
 	}
 =09
 	if (diffs[0] !=3D *tcpflags) {
-		diffs[0] =3D htons(diffs[0]) ^ 0xFFFF;
-		diffs[1] =3D htons(*tcpflags);
+		diffs[0] =3D diffs[0] ^ 0xFFFF;
+		diffs[1] =3D *tcpflags;
 		tcph->check =3D csum_fold(csum_partial((char *)diffs,
 		                                    sizeof(diffs),
 		                                    tcph->check^0xFFFF));

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--a1taQt+5gib656GU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+HYxGXaXGVTD0i/8RAhrCAJ0bJs/xWuNWjtXRbwh+cyKAH/lP3gCgsSkW
twDOKjMcLBWKQ9dS8WcG2kE=
=iscJ
-----END PGP SIGNATURE-----

--a1taQt+5gib656GU--
