From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH 2.4+2.6] NAT: remove unused structure member
Date: Fri, 20 Feb 2004 21:06:26 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040220200626.GO4797@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIA99zTjfw9iS5Gl"
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


--WIA99zTjfw9iS5Gl
Content-Type: multipart/mixed; boundary="4v4CeaphHHcoDrun"
Content-Disposition: inline


--4v4CeaphHHcoDrun
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

The following patch (courtesy of Patrick McHardy) removes an unused
structure member... quite embarassing ;)

Please apply, thanks.

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--4v4CeaphHHcoDrun
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="59_ip_nat_h-unused-var.patch"
Content-Transfer-Encoding: quoted-printable

=3D=3D=3D=3D=3D include/linux/netfilter_ipv4/ip_nat.h 1.4 vs edited =3D=3D=
=3D=3D=3D
--- 1.4/include/linux/netfilter_ipv4/ip_nat.h	Thu Aug  8 16:49:17 2002
+++ edited/include/linux/netfilter_ipv4/ip_nat.h	Mon Aug 18 13:13:47 2003
@@ -105,9 +105,6 @@
 	/* Manipulations to be done on this conntrack. */
 	struct ip_nat_info_manip manips[IP_NAT_MAX_MANIPS];
=20
-	/* The mapping type which created us (NULL for null mapping). */
-	const struct ip_nat_mapping_type *mtype;
-
 	struct ip_nat_hash bysource, byipsproto;
=20
 	/* Helper (NULL if none). */

--4v4CeaphHHcoDrun--

--WIA99zTjfw9iS5Gl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFANmjCXaXGVTD0i/8RAmZpAJ0bZ0bgqDSsY/+X6GVq4RXntioSzgCdFI0u
e6nZdOQ8llccfvcIDvRqWaM=
=AGaO
-----END PGP SIGNATURE-----

--WIA99zTjfw9iS5Gl--
