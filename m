From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 1/2] Specify nf_queue max length from userspace
Date: Tue, 13 Jun 2006 19:06:44 +0200
Message-ID: <1150218404.5386.2.camel@porky>
References: <1150217788.7164.4.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-E6t1J7Z8GpDyFn5Q0aBJ"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1150217788.7164.4.camel@porky>
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


--=-E6t1J7Z8GpDyFn5Q0aBJ
Content-Type: multipart/mixed; boundary="=-1CKmJoyaVoGn9yfovO5h"


--=-1CKmJoyaVoGn9yfovO5h
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Attach patch is against current git kernel tree.

--=20
Eric Leblond <eric@inl.fr>
INL

--=-1CKmJoyaVoGn9yfovO5h
Content-Disposition: attachment;
	filename=specify-queue-max-length-from-userspace.txt
Content-Transfer-Encoding: base64
Content-Type: text/plain; name=specify-queue-max-length-from-userspace.txt;
	charset=ISO-8859-15

U2lnbmVkLW9mZi1ieTogRXJpYyBMZWJsb25kIDxlcmljQGlubC5mcj4NCg0KDQotLS0NCg0KIGlu
Y2x1ZGUvbGludXgvbmV0ZmlsdGVyL25mbmV0bGlua19xdWV1ZS5oIHwgICAgMiArKw0KIG5ldC9u
ZXRmaWx0ZXIvbmZuZXRsaW5rX3F1ZXVlLmMgICAgICAgICAgIHwgICAgNyArKysrKystDQogMiBm
aWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pDQoNCjFmYjk4OGRj
NTFlMjQ2NTUwMGRmNTBmZjRlMDg1ZjgwYWNiN2I2YTMNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xp
bnV4L25ldGZpbHRlci9uZm5ldGxpbmtfcXVldWUuaCBiL2luY2x1ZGUvbGludXgvbmV0ZmlsdGVy
L25mbmV0bGlua19xdWV1ZS5oDQppbmRleCA5ZTc3NDM3Li5jZTMyYzU0IDEwMDY0NA0KLS0tIGEv
aW5jbHVkZS9saW51eC9uZXRmaWx0ZXIvbmZuZXRsaW5rX3F1ZXVlLmgNCisrKyBiL2luY2x1ZGUv
bGludXgvbmV0ZmlsdGVyL25mbmV0bGlua19xdWV1ZS5oDQpAQCAtNjcsNiArNjcsNyBAQCBzdHJ1
Y3QgbmZxbmxfbXNnX2NvbmZpZ19jbWQgew0KIH0gX19hdHRyaWJ1dGVfXyAoKHBhY2tlZCkpOw0K
IA0KIGVudW0gbmZxbmxfY29uZmlnX21vZGUgew0KKwlORlFOTF9DT1BZX1VOU1BFQywNCiAJTkZR
TkxfQ09QWV9OT05FLA0KIAlORlFOTF9DT1BZX01FVEEsDQogCU5GUU5MX0NPUFlfUEFDS0VULA0K
QEAgLTc1LDYgKzc2LDcgQEAgZW51bSBuZnFubF9jb25maWdfbW9kZSB7DQogc3RydWN0IG5mcW5s
X21zZ19jb25maWdfcGFyYW1zIHsNCiAJdV9pbnQzMl90CWNvcHlfcmFuZ2U7DQogCXVfaW50OF90
CWNvcHlfbW9kZTsJLyogZW51bSBuZnFubF9jb25maWdfbW9kZSAqLw0KKwl1X2ludDMyX3QgICBx
dWV1ZV9tYXhsZW47DQogfSBfX2F0dHJpYnV0ZV9fICgocGFja2VkKSk7DQogDQogDQpkaWZmIC0t
Z2l0IGEvbmV0L25ldGZpbHRlci9uZm5ldGxpbmtfcXVldWUuYyBiL25ldC9uZXRmaWx0ZXIvbmZu
ZXRsaW5rX3F1ZXVlLmMNCmluZGV4IDg2YTRhYzMuLjYwMzJhZDUgMTAwNjQ0DQotLS0gYS9uZXQv
bmV0ZmlsdGVyL25mbmV0bGlua19xdWV1ZS5jDQorKysgYi9uZXQvbmV0ZmlsdGVyL25mbmV0bGlu
a19xdWV1ZS5jDQpAQCAtOTM1LDggKzkzNSwxMyBAQCBuZnFubF9yZWN2X2NvbmZpZyhzdHJ1Y3Qg
c29jayAqY3RubCwgc3RyDQogCQkJZ290byBvdXRfcHV0Ow0KIAkJfQ0KIAkJcGFyYW1zID0gTkZB
X0RBVEEobmZxYVtORlFBX0NGR19QQVJBTVMtMV0pOw0KLQkJbmZxbmxfc2V0X21vZGUocXVldWUs
IHBhcmFtcy0+Y29weV9tb2RlLA0KKwkJaWYgKHBhcmFtcy0+Y29weV9tb2RlICE9IE5GUU5MX0NP
UFlfVU5TUEVDKXsNCisJCQluZnFubF9zZXRfbW9kZShxdWV1ZSwgcGFyYW1zLT5jb3B5X21vZGUs
DQogCQkJCW50b2hsKHBhcmFtcy0+Y29weV9yYW5nZSkpOw0KKwkJfQ0KKwkJaWYgKHBhcmFtcy0+
cXVldWVfbWF4bGVuKSB7DQorCQkJcXVldWUtPnF1ZXVlX21heGxlbj1udG9obChwYXJhbXMtPnF1
ZXVlX21heGxlbik7DQorCQl9DQogCX0NCiANCiBvdXRfcHV0Og0KLS0gDQoxLjMuMw0KDQo=


--=-1CKmJoyaVoGn9yfovO5h--

--=-E6t1J7Z8GpDyFn5Q0aBJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBEjvCknxA7CdMWjzIRAi1jAJ9DMhEOSxIln+zALvRf2b046uyDUgCfaFl9
MWI9adtc+vZD19NmaoXA2eA=
=wFjG
-----END PGP SIGNATURE-----

--=-E6t1J7Z8GpDyFn5Q0aBJ--
