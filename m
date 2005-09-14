From: Tom Eastep <teastep@shorewall.net>
Subject: [PATCH] Another iptables-save buglet
Date: Wed, 14 Sep 2005 15:09:40 -0700
Message-ID: <200509141509.47686.teastep@shorewall.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1968225.xIgXgEsnqE";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

--nextPart1968225.xIgXgEsnqE
Content-Type: multipart/mixed;
  boundary="Boundary-01=_k+JKDmJqeESzjUy"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_k+JKDmJqeESzjUy
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

The conntrack match extension doesn't handle address inversion correctly.

Patch attached.
=2DTom
=2D-=20
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key

--Boundary-01=_k+JKDmJqeESzjUy
Content-Type: text/x-diff;
  charset="us-ascii";
  name="conntrack.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="conntrack.diff"

=2D-- iptables-1.3.3/extensions/libipt_conntrack.c~	2005-02-19 11:19:17.000=
000000 -0800
+++ iptables-1.3.3/extensions/libipt_conntrack.c	2005-09-14 14:58:12.000000=
000 -0700
@@ -414,8 +414,8 @@
 {
 	char buf[BUFSIZ];
=20
=2D        if (inv)
=2D               	fputc('!', stdout);
+        if (inv)=20
+               	printf("! ");
=20
 	if (mask->s_addr =3D=3D 0L && !numeric)
 		printf("%s ", "anywhere");

--Boundary-01=_k+JKDmJqeESzjUy--

--nextPart1968225.xIgXgEsnqE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBDKJ+rO/MAbZfjDLIRAjGlAKDF/xPACJF+AiBPvKdlXU9R6zGDdQCgyviM
QkX1UloJSn5zAKqcO2sF55k=
=D/aN
-----END PGP SIGNATURE-----

--nextPart1968225.xIgXgEsnqE--
