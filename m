From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] ulogd mysql fix
Date: Wed, 01 Aug 2007 13:48:35 +0200
Message-ID: <1185968915.30855.9.camel@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-P/SzO06ZLTASt+N1+Tx5"
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


--=-P/SzO06ZLTASt+N1+Tx5
Content-Type: multipart/mixed; boundary="=-yivk5xrqdSSkQxsU2bi8"


--=-yivk5xrqdSSkQxsU2bi8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

MySQL 5.0 has changed the default for database reconnection after
timeout. It is now not enabled by default. The following patch restores
the reconnection functionnality for the ulogd-mysql plugin.

BR,
--=20
=C3=89ric Leblond, eleblond@inl.fr
T=C3=A9l=C3=A9phone : 01 44 89 46 39, Fax : 01 44 89 45 01
INL, http://www.inl.fr

--=-yivk5xrqdSSkQxsU2bi8
Content-Disposition: attachment; filename=ulogd_mysql.diff
Content-Type: text/x-patch; name=ulogd_mysql.diff; charset=UTF-8
Content-Transfer-Encoding: base64

SW5kZXg6IG15c3FsL3Vsb2dkX01ZU1FMLmMNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSBteXNxbC91bG9nZF9N
WVNRTC5jCShyw6l2aXNpb24gNjk3OSkNCisrKyBteXNxbC91bG9nZF9NWVNRTC5jCShjb3BpZSBk
ZSB0cmF2YWlsKQ0KQEAgLTQwNyw2ICs0MDcsOSBAQA0KIHN0YXRpYyBpbnQgbXlzcWxfb3Blbl9k
YihjaGFyICpzZXJ2ZXIsIGludCBwb3J0LCBjaGFyICp1c2VyLCBjaGFyICpwYXNzLCANCiAJCQkg
Y2hhciAqZGIpDQogew0KKyNpZmRlZiBNWVNRTF9PUFRfUkVDT05ORUNUDQorCW15X2Jvb2wgdHJ1
ZXZhbCA9IDE7DQorI2VuZGlmIA0KIAlkYmggPSBteXNxbF9pbml0KE5VTEwpOw0KIAlpZiAoIWRi
aCkNCiAJCXJldHVybiAtMTsNCkBAIC00MTUsMTIgKzQxOCwyNSBAQA0KIAkJbXlzcWxfb3B0aW9u
cyhkYmgsIE1ZU1FMX09QVF9DT05ORUNUX1RJTUVPVVQsDQogCQkJKGNvbnN0IGNoYXIgKikgJmNv
bm5lY3RfdGltZW91dF9jZS51LnZhbHVlKTsNCiANCisjaWZkZWYgTVlTUUxfT1BUX1JFQ09OTkVD
VA0KKyMgIGlmIGRlZmluZWQoTVlTUUxfVkVSU0lPTl9JRCkgJiYgKE1ZU1FMX1ZFUlNJT05fSUQg
Pj0gNTAwMTkpDQorCW15c3FsX29wdGlvbnMoZGJoLCBNWVNRTF9PUFRfUkVDT05ORUNULCAmdHJ1
ZXZhbCk7DQorIyAgZW5kaWYNCisjZW5kaWYgDQorDQorDQogCWlmICghbXlzcWxfcmVhbF9jb25u
ZWN0KGRiaCwgc2VydmVyLCB1c2VyLCBwYXNzLCBkYiwgcG9ydCwgTlVMTCwgMCkpDQogCXsNCiAJ
CV9teXNxbF9maW5pKCk7DQogCQlyZXR1cm4gLTE7DQogCX0NCiANCisjaWZkZWYgTVlTUUxfT1BU
X1JFQ09OTkVDVA0KKyMgIGlmIGRlZmluZWQoTVlTUUxfVkVSU0lPTl9JRCkgJiYgKE1ZU1FMX1ZF
UlNJT05fSUQgPCA1MDAxOSkNCisJbXlzcWxfb3B0aW9ucyhkYmgsIE1ZU1FMX09QVF9SRUNPTk5F
Q1QsICZ0cnVldmFsKTsNCisjICBlbmRpZg0KKyNlbmRpZg0KKw0KIAlyZXR1cm4gMDsNCiB9DQog
DQo=


--=-yivk5xrqdSSkQxsU2bi8--

--=-P/SzO06ZLTASt+N1+Tx5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGsHMTnxA7CdMWjzIRAvMRAKCCULjVwZyt5aFTVlYOBISCxKkU3gCdG766
P3AP2UcUuBPFl367uK9+fvs=
=t/k1
-----END PGP SIGNATURE-----

--=-P/SzO06ZLTASt+N1+Tx5--
