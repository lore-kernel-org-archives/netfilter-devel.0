From: Eric Leblond <eric@regit.org>
Subject: NFCT filter and IPv6
Date: Tue, 17 Jul 2012 23:11:09 +0200
Message-ID: <1342559469.8476.54.camel@tiger.regit.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-p0SySNKaJxc0PqBIKu53"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:58494 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2GQVMB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:12:01 -0400
Received: from ip-92-50-100-48.unitymediagroup.de ([92.50.100.48] helo=[192.168.0.102])
	by ks28632.kimsufi.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <eric@regit.org>)
	id 1SrF3n-0000Z2-Lq
	for netfilter-devel@vger.kernel.org; Tue, 17 Jul 2012 23:11:59 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-p0SySNKaJxc0PqBIKu53
Content-Type: multipart/mixed; boundary="=-p+jpJNmh3Wmu+7YsgtIS"


--=-p+jpJNmh3Wmu+7YsgtIS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I was working on ulogd2 and getting mad with connection filtering in
IPv6 (IPv4 being ok). After analysis, it seems there is a problem.

I've modified the conntrack_filter in utils by applying the following
patch. It does nothing but inverting the logic of filtering and adding
filtering to destination.

If I do :

$ telnet 2::1

then

root@tiger:/home/eric/git/netfilter/libnetfilter_conntrack/utils# ./conntra=
ck_filter=20
TEST: waiting for 10 events...
 [UPDATE] tcp      6 432000 ESTABLISHED src=3D2::1 dst=3D2::1 sport=3D35738=
 dport=3D22 src=3D2::1 dst=3D2::1 sport=3D22 dport=3D35738 [ASSURED]

Am I missing something ?

Kernel is a 3.4.0:
Linux tiger 3.4.0-netfilter #22 SMP Sat Jul 14 21:39:33 CEST 2012 x86_64 GN=
U/Linux

BR,
--=20
Eric Leblond=20
Blog: http://home.regit.org/ - Portfolio: http://regit.500px.com/


--=-p+jpJNmh3Wmu+7YsgtIS
Content-Disposition: attachment; filename="0001-Modify-IPv6-logic.patch"
Content-Type: text/x-patch; name="0001-Modify-IPv6-logic.patch"; charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSA1ZWMzODc5OTkzYzUwMmY4MDhkNzhjNzUwZjU4NTU1NWEwY2QzMDE0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogRXJpYyBMZWJsb25kIDxlcmljQHJlZ2l0Lm9yZz4NCkRhdGU6
IFR1ZSwgMTcgSnVsIDIwMTIgMjM6MDQ6NDYgKzAyMDANClN1YmplY3Q6IFtQQVRDSF0gTW9kaWZ5
IElQdjYgbG9naWMNCg0KLS0tDQogdXRpbHMvY29ubnRyYWNrX2ZpbHRlci5jIHwgICAgMyArKy0N
CiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYg
LS1naXQgYS91dGlscy9jb25udHJhY2tfZmlsdGVyLmMgYi91dGlscy9jb25udHJhY2tfZmlsdGVy
LmMNCmluZGV4IGEzZWVlYmMuLmNmZGU1ZDQgMTAwNjQ0DQotLS0gYS91dGlscy9jb25udHJhY2tf
ZmlsdGVyLmMNCisrKyBiL3V0aWxzL2Nvbm50cmFja19maWx0ZXIuYw0KQEAgLTc0LDkgKzc0LDEw
IEBAIGludCBtYWluKHZvaWQpDQogCS8qIGlnbm9yZSB3aGF0ZXZlciB0aGF0IGNvbWVzIGZyb20g
OjoxIChsb29wYmFjaykgKi8NCiAJbmZjdF9maWx0ZXJfc2V0X2xvZ2ljKGZpbHRlciwNCiAJCQkg
ICAgICBORkNUX0ZJTFRFUl9TUkNfSVBWNiwNCi0JCQkgICAgICBORkNUX0ZJTFRFUl9MT0dJQ19O
RUdBVElWRSk7DQorCQkJICAgICAgTkZDVF9GSUxURVJfTE9HSUNfUE9TSVRJVkUpOw0KIA0KIAlu
ZmN0X2ZpbHRlcl9hZGRfYXR0cihmaWx0ZXIsIE5GQ1RfRklMVEVSX1NSQ19JUFY2LCAmZmlsdGVy
X2lwdjYpOw0KKwluZmN0X2ZpbHRlcl9hZGRfYXR0cihmaWx0ZXIsIE5GQ1RfRklMVEVSX0RTVF9J
UFY2LCAmZmlsdGVyX2lwdjYpOw0KIA0KIAlpZiAobmZjdF9maWx0ZXJfYXR0YWNoKG5mY3RfZmQo
aCksIGZpbHRlcikgPT0gLTEpIHsNCiAJCXBlcnJvcigibmZjdF9maWx0ZXJfYXR0YWNoIik7DQot
LSANCjEuNy4xMC40DQoNCg==


--=-p+jpJNmh3Wmu+7YsgtIS--

--=-p0SySNKaJxc0PqBIKu53
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlAF1O0ACgkQnxA7CdMWjzJv2gCeLCYGsrLP8a+tWrUXuW/lvlHa
ku4An3F5TrHfz1T61za/fW9a9fTF8BtH
=9knC
-----END PGP SIGNATURE-----

--=-p0SySNKaJxc0PqBIKu53--

