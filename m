From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] ipt_multiport invert fix
Date: Thu, 9 Jan 2003 15:34:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030109143412.GD9467@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tJKub4+frm2HVP3B"
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


--tJKub4+frm2HVP3B
Content-Type: multipart/mixed; boundary="rz/qo3iW6Lu5yGf1"
Content-Disposition: inline


--rz/qo3iW6Lu5yGf1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is the first of a series of patches you will receive from me today.

Please apply to 2.4.x and 2.5.x, thanks.


Author: Marcus Sundberg <marcus@ingate.com>

This patch fixes the multiport match, when it is used in combination
with the invert (!) flag.

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--rz/qo3iW6Lu5yGf1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ipt_multiport-invfix.patch"
Content-Transfer-Encoding: quoted-printable

diff -ur linux.current/net/ipv4/netfilter/ipt_multiport.c linux-mine/net/ip=
v4/netfilter/ipt_multiport.c
--- linux-2.4.19-rc1/net/ipv4/netfilter/ipt_multiport.c	Tue Jun 20 23:32:27=
 2000
+++ linux/net/ipv4/netfilter/ipt_multiport.c	Tue Jul  9 10:43:23 2002
@@ -78,7 +78,7 @@
=20
 	/* Must specify proto =3D=3D TCP/UDP, no unknown flags or bad count */
 	return (ip->proto =3D=3D IPPROTO_TCP || ip->proto =3D=3D IPPROTO_UDP)
-		&& !(ip->flags & IPT_INV_PROTO)
+		&& !(ip->invflags & IPT_INV_PROTO)
 		&& matchsize =3D=3D IPT_ALIGN(sizeof(struct ipt_multiport))
 		&& (multiinfo->flags =3D=3D IPT_MULTIPORT_SOURCE
 		    || multiinfo->flags =3D=3D IPT_MULTIPORT_DESTINATION


--rz/qo3iW6Lu5yGf1--

--tJKub4+frm2HVP3B
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+HYhkXaXGVTD0i/8RAucTAJ0aMoRYWiSwRo5AvaZ291U5CCChpgCeIRYO
0MEOMjimmspBr4/koe1FfzA=
=bk83
-----END PGP SIGNATURE-----

--tJKub4+frm2HVP3B--
