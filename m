From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] Set mark to 0 from libnetfilter_conntrack
Date: Wed, 25 Oct 2006 20:38:18 +0200
Message-ID: <1161801498.12718.22.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-tz1OPTqAqaQr7ei+QGNU"
Cc: pablo@netfilter.org
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


--=-tz1OPTqAqaQr7ei+QGNU
Content-Type: multipart/mixed; boundary="=-5RnfP9zq0GNUKMNuMWPD"


--=-5RnfP9zq0GNUKMNuMWPD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Damien Boucard from INL has discovered a bug in libnetfilter_conntrack :
Mark can not be set to 0.

After looking at the code I've found that we only change the mark if it
is not set to 0 :
	if (ct->mark !=3D 0)
		nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_MARK, &mark,
		       sizeof(u_int32_t));

What's the cleanest way to solve this. I don't see any mean to correct
this except adding an IPS_CHANGE_MARK flag.

Proposed patch is attached to the mail.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-5RnfP9zq0GNUKMNuMWPD
Content-Disposition: attachment; filename=enable_setting_mark_to_zero.patch
Content-Type: text/x-patch; name=enable_setting_mark_to_zero.patch;
	charset=ISO-8859-15
Content-Transfer-Encoding: base64

SW5kZXg6IGluY2x1ZGUvbGlibmV0ZmlsdGVyX2Nvbm50cmFjay9saWJuZXRmaWx0ZXJfY29ubnRy
YWNrLmgNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0NCi0tLSBpbmNsdWRlL2xpYm5ldGZpbHRlcl9jb25udHJhY2svbGli
bmV0ZmlsdGVyX2Nvbm50cmFjay5oCShyZXZpc2lvbiA2Njg5KQ0KKysrIGluY2x1ZGUvbGlibmV0
ZmlsdGVyX2Nvbm50cmFjay9saWJuZXRmaWx0ZXJfY29ubnRyYWNrLmgJKHdvcmtpbmcgY29weSkN
CkBAIC0xOTYsNiArMTk2LDEwIEBADQogCUlQU19GSVhFRF9USU1FT1VUX0JJVCA9IDEwLA0KIAlJ
UFNfRklYRURfVElNRU9VVCA9ICgxIDw8IElQU19GSVhFRF9USU1FT1VUX0JJVCksDQogDQorICAg
IC8qIENvbm5lY3RpbyBtdXN0IGNoYW5nZSBNQVJLICovDQorCUlQU19DSEFOR0VfTUFSS19CSVQg
PSAxMSwNCisJSVBTX0NIQU5HRV9NQVJLID0gKDEgPDwgSVBTX0ZJWEVEX0NIQU5HRV9NQVJLKSwN
CisNCiB9Ow0KIA0KIGVudW0gew0KSW5kZXg6IHNyYy9saWJuZXRmaWx0ZXJfY29ubnRyYWNrLmMN
Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT0NCi0tLSBzcmMvbGlibmV0ZmlsdGVyX2Nvbm50cmFjay5jCShyZXZpc2lvbiA2
Njg5KQ0KKysrIHNyYy9saWJuZXRmaWx0ZXJfY29ubnRyYWNrLmMJKHdvcmtpbmcgY29weSkNCkBA
IC05NzYsNyArOTc2LDcgQEANCiAJbmZubF9hZGRhdHRyX2woJnJlcS0+bmxoLCBzaXplb2YoYnVm
KSwgQ1RBX1RJTUVPVVQsICZ0aW1lb3V0LCANCiAJCSAgICAgICBzaXplb2YodV9pbnQzMl90KSk7
DQogCQ0KLQlpZiAoY3QtPm1hcmsgIT0gMCkNCisJaWYgKGN0LT5zdGF0dXMgJiBJUFNfQ0hBTkdF
X01BUkspDQogCQluZm5sX2FkZGF0dHJfbCgmcmVxLT5ubGgsIHNpemVvZihidWYpLCBDVEFfTUFS
SywgJm1hcmssDQogCQkJICAgICAgIHNpemVvZih1X2ludDMyX3QpKTsNCiANCg==


--=-5RnfP9zq0GNUKMNuMWPD--

--=-tz1OPTqAqaQr7ei+QGNU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBFP68anxA7CdMWjzIRAn6GAJsHnj7xoiuguZ/3MrOxOIH4XODH1gCfUiIf
P+LpReRwCnRMudnGZ/35apo=
=cuA1
-----END PGP SIGNATURE-----

--=-tz1OPTqAqaQr7ei+QGNU--
