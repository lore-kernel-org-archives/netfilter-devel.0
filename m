From: Eric Leblond <eric@inl.fr>
Subject: [Resend] Userspace code related to fixed timeout patch
Date: Sat, 01 Jul 2006 16:08:45 +0200
Message-ID: <1151762925.20139.17.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-5/jjjA5Q7AjH/6BlkocW"
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


--=-5/jjjA5Q7AjH/6BlkocW
Content-Type: multipart/mixed; boundary="=-K/4iRjkYXIUQqCrZwUVi"


--=-K/4iRjkYXIUQqCrZwUVi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Fixed timeout patch
(http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3D3510) has
been applied to Linus git tree but the related changes of userspace
library and tool have not been applied to netfilter.org subversion :

http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3D3489
http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3D3485

Is it possible to push them to subversion ?

I attach the patches for convenience.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-K/4iRjkYXIUQqCrZwUVi
Content-Disposition: attachment;
	filename=libnetfilter_conntrack_fixed_timeout-flag.patch
Content-Type: text/x-patch;
	name=libnetfilter_conntrack_fixed_timeout-flag.patch;
	charset=ISO-8859-15
Content-Transfer-Encoding: base64

SW5kZXg6IGluY2x1ZGUvbGlibmV0ZmlsdGVyX2Nvbm50cmFjay9saWJuZXRmaWx0ZXJfY29ubnRy
YWNrLmgNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0NCi0tLSBpbmNsdWRlL2xpYm5ldGZpbHRlcl9jb25udHJhY2svbGli
bmV0ZmlsdGVyX2Nvbm50cmFjay5oCShyw6l2aXNpb24gNjU3OCkNCisrKyBpbmNsdWRlL2xpYm5l
dGZpbHRlcl9jb25udHJhY2svbGlibmV0ZmlsdGVyX2Nvbm50cmFjay5oCShjb3BpZSBkZSB0cmF2
YWlsKQ0KQEAgLTE5MSw2ICsxOTEsMTEgQEANCiAJLyogQ29ubmVjdGlvbiBpcyBkeWluZyAocmVt
b3ZlZCBmcm9tIGxpc3RzKSwgY2FuIG5vdCBiZSB1bnNldC4gKi8NCiAJSVBTX0RZSU5HX0JJVCA9
IDksDQogCUlQU19EWUlORyA9ICgxIDw8IElQU19EWUlOR19CSVQpLA0KKw0KKyAgICAvKiBDb25u
ZWN0aW9uIGhhcyBmaXhlZCB0aW1lb3V0LiAqLw0KKwlJUFNfRklYRURfVElNRU9VVF9CSVQgPSAx
MCwNCisJSVBTX0ZJWEVEX1RJTUVPVVQgPSAoMSA8PCBJUFNfRklYRURfVElNRU9VVF9CSVQpLA0K
Kw0KIH07DQogDQogZW51bSB7DQo=


--=-K/4iRjkYXIUQqCrZwUVi
Content-Disposition: attachment; filename=conntrack_fixed_timeout-flag.patch
Content-Type: text/x-patch; name=conntrack_fixed_timeout-flag.patch;
	charset=ISO-8859-15
Content-Transfer-Encoding: base64

SW5kZXg6IHNyYy9jb25udHJhY2suYw0KPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KLS0tIHNyYy9jb25udHJhY2suYwko
csOpdmlzaW9uIDY1NzgpDQorKysgc3JjL2Nvbm50cmFjay5jCShjb3BpZSBkZSB0cmF2YWlsKQ0K
QEAgLTMzNSwxMyArMzM1LDEzIEBADQogI2RlZmluZSBQQVJTRV9NQVggMg0KIA0KIHN0YXRpYyBz
dHJ1Y3QgcGFyc2VfcGFyYW1ldGVyIHsNCi0JY2hhciAJKnBhcmFtZXRlcls1XTsNCisJY2hhciAJ
KnBhcmFtZXRlcls2XTsNCiAJc2l6ZV90ICBzaXplOw0KLQl1bnNpZ25lZCBpbnQgdmFsdWVbNV07
DQorCXVuc2lnbmVkIGludCB2YWx1ZVs2XTsNCiB9IHBhcnNlX2FycmF5W1BBUlNFX01BWF0gPSB7
DQotCXsgeyJBU1NVUkVEIiwgIlNFRU5fUkVQTFkiLCAiVU5TRVQiLCAiU1JDX05BVCIsICJEU1Rf
TkFUIn0sIDUsDQorCXsgeyJBU1NVUkVEIiwgIlNFRU5fUkVQTFkiLCAiVU5TRVQiLCAiU1JDX05B
VCIsICJEU1RfTkFUIiwiRklYRURfVElNRU9VVCJ9LCA2LA0KIAkgIHsgSVBTX0FTU1VSRUQsIElQ
U19TRUVOX1JFUExZLCAwLCANCi0JICAgIElQU19TUkNfTkFUX0RPTkUsIElQU19EU1RfTkFUX0RP
TkV9IH0sDQorCSAgICBJUFNfU1JDX05BVF9ET05FLCBJUFNfRFNUX05BVF9ET05FLCBJUFNfRklY
RURfVElNRU9VVH0gfSwNCiAJeyB7IkFMTCIsICJORVciLCAiVVBEQVRFUyIsICJERVNUUk9ZIn0s
IDQsDQogCSAge34wVSwgTkZfTkVUTElOS19DT05OVFJBQ0tfTkVXLCBORl9ORVRMSU5LX0NPTk5U
UkFDS19VUERBVEUsIA0KIAkgICBORl9ORVRMSU5LX0NPTk5UUkFDS19ERVNUUk9ZfSB9LA0K


--=-K/4iRjkYXIUQqCrZwUVi--

--=-5/jjjA5Q7AjH/6BlkocW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBEpoHtnxA7CdMWjzIRAheAAJ4rHgj03bxrT9T7/8geUPWkwDjKHQCeI+Jb
ox+446v4fv2wPzPDuZcGCRU=
=1tVH
-----END PGP SIGNATURE-----

--=-5/jjjA5Q7AjH/6BlkocW--
