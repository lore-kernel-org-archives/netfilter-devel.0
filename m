From: Martin Josefsson <gandalf@netfilter.org>
Subject: [PATCH 2.4 correct] cosmetic update to ip6t_ipv6header
Date: Mon, 13 Oct 2003 20:20:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1066069251.29179.159.camel@tux.rsn.bth.se>
References: <20031002162456.GT5758@sunbeam.de.gnumonks.org>
	 <20031002233619.5c43cae7.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nSTpQ+sawpTtvcQsA9KN"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
In-Reply-To: <20031002233619.5c43cae7.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-nSTpQ+sawpTtvcQsA9KN
Content-Type: multipart/mixed; boundary="=-RNhYGjOSdUlv+4wcb0Hx"


--=-RNhYGjOSdUlv+4wcb0Hx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2003-10-03 at 08:36, David S. Miller wrote:
> On Thu, 2 Oct 2003 18:24:56 +0200
> Harald Welte <laforge@netfilter.org> wrote:
>=20
> > Please apply the following patch to your 2.6 tree, thanks.
>=20
> Mass confusion... the subject says 2.4, here you're saying
> 2.6..
>=20
> Because you sent me the 2.6.x variant of this patch already I
> tried to put it into 2.4.x but that got rejects.

Here's the correct 2.4 version.
Found to be missing when syncing patch-o-matic.

Author: Maciej Soltysiak

This patch removes unused destroy callback in ip6t_ipv6header.c

--=20
/Martin

--=-RNhYGjOSdUlv+4wcb0Hx
Content-Disposition: attachment; filename=85_ipv6header.patch
Content-Type: text/x-patch; name=85_ipv6header.patch; charset=iso-8859-15
Content-Transfer-Encoding: base64

ZGlmZiAtdSBsaW51eC5vcmlnL25ldC9pcHY2L25ldGZpbHRlci9pcDZ0X2lwdjZoZWFkZXIuYyBs
aW51eC9uZXQvaXB2Ni9uZXRmaWx0ZXIvaXA2dF9pcHY2aGVhZGVyLmMNCi0tLSBsaW51eC5vcmln
L25ldC9pcHY2L25ldGZpbHRlci9pcDZ0X2lwdjZoZWFkZXIuYwkyMDAzLTA3LTI3IDE5OjEyOjA5
LjAwMDAwMDAwMCArMDIwMA0KKysrIGxpbnV4L25ldC9pcHY2L25ldGZpbHRlci9pcDZ0X2lwdjZo
ZWFkZXIuYwkyMDAzLTA5LTAyIDAwOjE5OjAxLjI5NTE3MzU0NCArMDIwMA0KQEAgLTEyOSwyMCAr
MTI5LDEzIEBADQogCXJldHVybiAxOw0KIH0NCiANCi1zdGF0aWMgdm9pZA0KLWlwdjZoZWFkZXJf
ZGVzdHJveSh2b2lkICptYXRjaGluZm8sDQotCQkgICB1bnNpZ25lZCBpbnQgbWF0Y2hpbmZvc2l6
ZSkNCi17DQotCXJldHVybjsNCi19DQotDQogc3RhdGljIHN0cnVjdCBpcDZ0X21hdGNoDQogaXA2
dF9pcHY2aGVhZGVyX21hdGNoID0gew0KIAl7IE5VTEwsIE5VTEwgfSwNCiAJImlwdjZoZWFkZXIi
LA0KIAkmaXB2NmhlYWRlcl9tYXRjaCwNCiAJJmlwdjZoZWFkZXJfY2hlY2tlbnRyeSwNCi0JJmlw
djZoZWFkZXJfZGVzdHJveSwNCisJTlVMTCwNCiAJVEhJU19NT0RVTEUNCiB9Ow0KIA0K

--=-RNhYGjOSdUlv+4wcb0Hx--

--=-nSTpQ+sawpTtvcQsA9KN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/iu0CWm2vlfa207ERAqfLAJ4wOS3ZGgQM3s9DUieeVTLJTtMnNQCfXTof
Ts42jPlg07Lxu3mYVYON8jA=
=o0nF
-----END PGP SIGNATURE-----

--=-nSTpQ+sawpTtvcQsA9KN--
