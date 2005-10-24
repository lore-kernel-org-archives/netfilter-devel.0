From: Eric Leblond <eleblond@inl.fr>
Subject: [PATCH] autogen.sh for libnetfilter_conntrack
Date: Mon, 24 Oct 2005 10:10:44 +0200
Message-ID: <1130141444.11255.10.camel@localhost.localdomain>
References: <1130141237.11255.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-LuIyUpkfNmCh34VVGcH3"
Cc: gryzor@inl.fr, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1130141237.11255.4.camel@localhost.localdomain>
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


--=-LuIyUpkfNmCh34VVGcH3
Content-Type: multipart/mixed; boundary="=-S29y9x8a8T4Via9Bb/ZU"


--=-S29y9x8a8T4Via9Bb/ZU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I've just added a "libtoolize -f" call to autogen.sh. It was not
compiling cleanly from svn without that.

Le lundi 24 octobre 2005 =E0 10:07 +0200, Eric Leblond a =E9crit :
> Hi,
>=20
> Here's just a simple autogen.sh for conntrack. I've suppressed explicit
> linking with 1.6 version as this is really boring.
>=20
> BR,=20
--=20
Eric Leblond <eleblond@inl.fr>
INL

--=-S29y9x8a8T4Via9Bb/ZU
Content-Disposition: attachment; filename=libnetfilter_conntrack.diff
Content-Type: text/x-patch; name=libnetfilter_conntrack.diff; charset=us-ascii
Content-Transfer-Encoding: base64

SW5kZXg6IGF1dG9nZW4uc2gNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSBhdXRvZ2VuLnNoCShyw6l2aXNpb24g
NDM3NykNCisrKyBhdXRvZ2VuLnNoCShjb3BpZSBkZSB0cmF2YWlsKQ0KQEAgLTExLDcgKzExLDgg
QEANCiAgICAgZmkNCiB9DQogDQotcnVuIGFjbG9jYWwtMS42DQorcnVuIGFjbG9jYWwNCitydW4g
bGlidG9vbGl6ZSAtZg0KICNydW4gYXV0b2hlYWRlcg0KLXJ1biBhdXRvbWFrZS0xLjYgLWENCity
dW4gYXV0b21ha2UgLWENCiBydW4gYXV0b2NvbmYNCg==


--=-S29y9x8a8T4Via9Bb/ZU--

--=-LuIyUpkfNmCh34VVGcH3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBDXJcEnxA7CdMWjzIRAgNRAJsHnc/qYPcnss1YoFsZG5EH3dMy6QCfSc/l
v4i8v3tp97GAjTC1YcjzSCA=
=LHz2
-----END PGP SIGNATURE-----

--=-LuIyUpkfNmCh34VVGcH3--
