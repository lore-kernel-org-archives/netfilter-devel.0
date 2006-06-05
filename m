From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] fix conntrack compilation
Date: Mon, 05 Jun 2006 15:01:47 +0200
Message-ID: <1149512507.20946.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-1Vh04hxRl/OisDMvqeC2"
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


--=-1Vh04hxRl/OisDMvqeC2
Content-Type: multipart/mixed; boundary="=-LcG4oshLI3lWD07B+9Mu"


--=-LcG4oshLI3lWD07B+9Mu
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hello,

It seems that subversion version of conntrack tool does not compile to
due the lack of inclusion of "config.h".

The attached patch fixes this issue.

BR,
--=20
=C9ric Leblond, eleblond@inl.fr
T=E9l=E9phone : 01 44 89 46 39, Fax : 01 44 89 45 01
INL, http://www.inl.fr

--=-LcG4oshLI3lWD07B+9Mu
Content-Disposition: attachment; filename=conntrack-compil.patch
Content-Type: text/x-patch; name=conntrack-compil.patch; charset=ISO-8859-15
Content-Transfer-Encoding: base64

SW5kZXg6IGluY2x1ZGUvY29ubnRyYWNrLmgNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSBpbmNsdWRlL2Nvbm50
cmFjay5oCShyw6l2aXNpb24gNjYyNCkNCisrKyBpbmNsdWRlL2Nvbm50cmFjay5oCShjb3BpZSBk
ZSB0cmF2YWlsKQ0KQEAgLTEsNiArMSwxMCBAQA0KICNpZm5kZWYgX0NPTk5UUkFDS19IDQogI2Rl
ZmluZSBfQ09OTlRSQUNLX0gNCiANCisjaWZkZWYgSEFWRV9DT05GSUdfSA0KKyNpbmNsdWRlICIu
Li9jb25maWcuaCINCisjZW5kaWYNCisNCiAjaW5jbHVkZSAibGludXhfbGlzdC5oIg0KICNpbmNs
dWRlIDxnZXRvcHQuaD4NCiAjaW5jbHVkZSA8bGlibmV0ZmlsdGVyX2Nvbm50cmFjay9saWJuZXRm
aWx0ZXJfY29ubnRyYWNrLmg+DQo=


--=-LcG4oshLI3lWD07B+9Mu--

--=-1Vh04hxRl/OisDMvqeC2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBEhCs6nxA7CdMWjzIRAgVBAJwNsqpD+k3ZgwpWm0GiJDfTbfBBVACfVPm2
1XT+hSZbReiVsRRoCzPNVCA=
=SJ8b
-----END PGP SIGNATURE-----

--=-1Vh04hxRl/OisDMvqeC2--
