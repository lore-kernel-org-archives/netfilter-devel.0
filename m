From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] netfilter: remove unnccessarry memsets
Date: Sun, 30 Nov 2003 18:00:15 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031130123014.GA26749@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
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


--NDin8bjvE/0mNLFQ
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Since 2.4.23 is out, I am now sending you a couple of pending 2.4.x=20
netfilter fixes.

This mail contains the first one.  Please apply.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="61-remove-memsets.patch"
Content-Transfer-Encoding: quoted-printable

=3D=3D=3D=3D=3D net/ipv4/netfilter/ip_conntrack_tftp.c 1.1 vs edited =3D=3D=
=3D=3D=3D
--- 1.1/net/ipv4/netfilter/ip_conntrack_tftp.c	Mon Mar 31 17:08:21 2003
+++ edited/net/ipv4/netfilter/ip_conntrack_tftp.c	Sun Jun 29 21:31:10 2003
@@ -94,8 +94,6 @@
=20
 	for (i =3D 0 ; (i < MAX_PORTS) && ports[i] ; i++) {
 		/* Create helper structure */
-		memset(&tftp[i], 0, sizeof(struct ip_conntrack_helper));
-
 		tftp[i].tuple.dst.protonum =3D IPPROTO_UDP;
 		tftp[i].tuple.src.u.udp.port =3D htons(ports[i]);
 		tftp[i].mask.dst.protonum =3D 0xFFFF;
=3D=3D=3D=3D=3D net/ipv4/netfilter/ip_nat_tftp.c 1.1 vs edited =3D=3D=3D=3D=
=3D
--- 1.1/net/ipv4/netfilter/ip_nat_tftp.c	Mon Mar 31 17:08:21 2003
+++ edited/net/ipv4/netfilter/ip_nat_tftp.c	Sun Jun 29 21:31:53 2003
@@ -160,8 +160,6 @@
 		ports[0] =3D TFTP_PORT;
=20
 	for (i =3D 0 ; (i < MAX_PORTS) && ports[i] ; i++) {
-		memset(&tftp[i], 0, sizeof(struct ip_nat_helper));
-
 		tftp[i].tuple.dst.protonum =3D IPPROTO_UDP;
 		tftp[i].tuple.src.u.udp.port =3D htons(ports[i]);
 		tftp[i].mask.dst.protonum =3D 0xFFFF;

--4Ckj6UjgE2iN1+kY--

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/yeLsXaXGVTD0i/8RAivdAJ4xUYKtUppt9gDfll4KMrQgaK9PxQCeN0IA
JNoVBS0Lab/VJLcVLAy/W0I=
=9Rqe
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
