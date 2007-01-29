From: Eric Leblond <eric@inl.fr>
Subject: Re: [Patch 2/2] libnetfilter_queue, iface conversion to string
Date: Mon, 29 Jan 2007 11:36:11 +0100
Message-ID: <1170066971.2924.7.camel@localhost>
References: <1167257854.31765.21.camel@localhost>
	<45940145.3020003@netfilter.org> <1167349247.15420.13.camel@localhost>
	<20070107142607.GC13543@prithivi.gnumonks.org>
	<1168296086.12298.6.camel@localhost>
	<20070109115120.GX7655@prithivi.gnumonks.org>
	<1169162676.8926.14.camel@localhost>
	<1169163050.8926.16.camel@localhost>
	<45B0E24A.7040906@trash.net> <45B10222.1040806@netfilter.org>
	<20070122123618.GM9631@prithivi.gnumonks.org>
	<59155.90.13.189.211.1169586830.squirrel@mail.inl.fr>
	<45B80BFB.2060203@netfilter.org>
	<41024.80.214.249.17.1169727370.squirrel@mail.inl.fr>
	<45B966DA.9040009@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-h8gRsB/aSKtWAVmDoy3s"
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>, Vincent Deffontaines <vincent@inl.fr>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45B966DA.9040009@netfilter.org>
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


--=-h8gRsB/aSKtWAVmDoy3s
Content-Type: multipart/mixed; boundary="=-GEXNAw1PQLy9gR9hY4S2"


--=-GEXNAw1PQLy9gR9hY4S2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

Le vendredi 26 janvier 2007 =E0 03:26 +0100, Pablo Neira Ayuso a =E9crit :
> Eric,
>=20
> Eric Leblond wrote:
> > Here's the updated patch for libnetfilter_queue.
>=20
> Could you resend a patch that fits the change that I introduced in
> nlif_index2name that requires a buffer to be passed? Thanks.

Here's the related patch.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-GEXNAw1PQLy9gR9hY4S2
Content-Disposition: attachment; filename=libnetfilter_queue-ifacename.diff
Content-Type: text/x-patch; name=libnetfilter_queue-ifacename.diff;
	charset=ISO-8859-15
Content-Transfer-Encoding: base64

SW5kZXg6IGluY2x1ZGUvbGlibmV0ZmlsdGVyX3F1ZXVlL2xpYm5ldGZpbHRlcl9xdWV1ZS5oDQo9
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09DQotLS0gaW5jbHVkZS9saWJuZXRmaWx0ZXJfcXVldWUvbGlibmV0ZmlsdGVyX3F1
ZXVlLmgJKHLDqXZpc2lvbiA2NzQ2KQ0KKysrIGluY2x1ZGUvbGlibmV0ZmlsdGVyX3F1ZXVlL2xp
Ym5ldGZpbHRlcl9xdWV1ZS5oCShjb3BpZSBkZSB0cmF2YWlsKQ0KQEAgLTgwLDYgKzgwLDE1IEBA
DQogZXh0ZXJuIHVfaW50MzJfdCBuZnFfZ2V0X291dGRldihzdHJ1Y3QgbmZxX2RhdGEgKm5mYWQp
Ow0KIGV4dGVybiB1X2ludDMyX3QgbmZxX2dldF9waHlzb3V0ZGV2KHN0cnVjdCBuZnFfZGF0YSAq
bmZhZCk7DQogDQorZXh0ZXJuIGludCBuZnFfZ2V0X2luZGV2X25hbWUoc3RydWN0IG5saWZfaGFu
ZGxlICpubGlmX2hhbmRsZSwNCisJCQkgICAgICBzdHJ1Y3QgbmZxX2RhdGEgKm5mYWQsIGNoYXIg
Km5hbWUpOw0KK2V4dGVybiBpbnQgbmZxX2dldF9waHlzaW5kZXZfbmFtZShzdHJ1Y3QgbmxpZl9o
YW5kbGUgKm5saWZfaGFuZGxlLA0KKwkJCSAgICAgICAgICBzdHJ1Y3QgbmZxX2RhdGEgKm5mYWQs
IGNoYXIgKm5hbWUpOw0KK2V4dGVybiBpbnQgbmZxX2dldF9vdXRkZXZfbmFtZShzdHJ1Y3Qgbmxp
Zl9oYW5kbGUgKm5saWZfaGFuZGxlLA0KKwkJCSAgICAgICBzdHJ1Y3QgbmZxX2RhdGEgKm5mYWQs
IGNoYXIgKm5hbWUpOw0KK2V4dGVybiBpbnQgbmZxX2dldF9waHlzb3V0ZGV2X25hbWUoc3RydWN0
IG5saWZfaGFuZGxlICpubGlmX2hhbmRsZSwNCisJCQkJICAgc3RydWN0IG5mcV9kYXRhICpuZmFk
LCBjaGFyICpuYW1lKTsNCisNCiBleHRlcm4gc3RydWN0IG5mcW5sX21zZ19wYWNrZXRfaHcgKm5m
cV9nZXRfcGFja2V0X2h3KHN0cnVjdCBuZnFfZGF0YSAqbmZhZCk7DQogDQogLyogcmV0dXJuIC0x
IGlmIHByb2JsZW0sIGxlbmd0aCBvdGhlcndpc2UgKi8NCkluZGV4OiBzcmMvbGlibmV0ZmlsdGVy
X3F1ZXVlLmMNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0NCi0tLSBzcmMvbGlibmV0ZmlsdGVyX3F1ZXVlLmMJKHLDqXZp
c2lvbiA2NzQ2KQ0KKysrIHNyYy9saWJuZXRmaWx0ZXJfcXVldWUuYwkoY29waWUgZGUgdHJhdmFp
bCkNCkBAIC00MTksNiArNDE5LDM1IEBADQogCXJldHVybiBudG9obChuZm5sX2dldF9kYXRhKG5m
YWQtPmRhdGEsIE5GUUFfSUZJTkRFWF9QSFlTT1VUREVWLCB1X2ludDMyX3QpKTsNCiB9DQogDQor
aW50IG5mcV9nZXRfaW5kZXZfbmFtZShzdHJ1Y3QgbmxpZl9oYW5kbGUgKm5saWZfaGFuZGxlLA0K
KwkJCXN0cnVjdCBuZnFfZGF0YSAqbmZhZCwgY2hhciAqbmFtZSkNCit7DQorCXVfaW50MzJfdCBp
ZmluZGV4ID0gbmZxX2dldF9pbmRldihuZmFkKTsNCisJcmV0dXJuIG5saWZfaW5kZXgybmFtZShu
bGlmX2hhbmRsZSwgaWZpbmRleCwgbmFtZSk7DQorfQ0KKw0KK2ludCBuZnFfZ2V0X3BoeXNpbmRl
dl9uYW1lKHN0cnVjdCBubGlmX2hhbmRsZSAqbmxpZl9oYW5kbGUsDQorCQkJICAgc3RydWN0IG5m
cV9kYXRhICpuZmFkLCBjaGFyICpuYW1lKQ0KK3sNCisJdV9pbnQzMl90IGlmaW5kZXggPSBuZnFf
Z2V0X3BoeXNpbmRldihuZmFkKTsNCisJcmV0dXJuIG5saWZfaW5kZXgybmFtZShubGlmX2hhbmRs
ZSwgaWZpbmRleCwgbmFtZSk7DQorfQ0KKw0KK2ludCBuZnFfZ2V0X291dGRldl9uYW1lKHN0cnVj
dCBubGlmX2hhbmRsZSAqbmxpZl9oYW5kbGUsDQorCQkJc3RydWN0IG5mcV9kYXRhICpuZmFkLCBj
aGFyICpuYW1lKQ0KK3sNCisJdV9pbnQzMl90IGlmaW5kZXggPSBuZnFfZ2V0X291dGRldihuZmFk
KTsNCisJcmV0dXJuIG5saWZfaW5kZXgybmFtZShubGlmX2hhbmRsZSwgaWZpbmRleCwgbmFtZSk7
DQorfQ0KKw0KK2ludCBuZnFfZ2V0X3BoeXNvdXRkZXZfbmFtZShzdHJ1Y3QgbmxpZl9oYW5kbGUg
Km5saWZfaGFuZGxlLA0KKwkJCSAgICBzdHJ1Y3QgbmZxX2RhdGEgKm5mYWQsIGNoYXIgKm5hbWUp
DQorew0KKwl1X2ludDMyX3QgaWZpbmRleCA9IG5mcV9nZXRfcGh5c291dGRldihuZmFkKTsNCisJ
cmV0dXJuIG5saWZfaW5kZXgybmFtZShubGlmX2hhbmRsZSwgaWZpbmRleCwgbmFtZSk7DQorfQ0K
Kw0KKw0KIHN0cnVjdCBuZnFubF9tc2dfcGFja2V0X2h3ICpuZnFfZ2V0X3BhY2tldF9odyhzdHJ1
Y3QgbmZxX2RhdGEgKm5mYWQpDQogew0KIAlyZXR1cm4gbmZubF9nZXRfcG9pbnRlcl90b19kYXRh
KG5mYWQtPmRhdGEsIE5GUUFfSFdBRERSLA0K


--=-GEXNAw1PQLy9gR9hY4S2--

--=-h8gRsB/aSKtWAVmDoy3s
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBFvc4bnxA7CdMWjzIRAizMAJ9QeG7vbHyPqKmdAs2otnYrH1UOHQCfa8pO
84RPTXmJJ6xLISdR+PaeJ/U=
=hPb1
-----END PGP SIGNATURE-----

--=-h8gRsB/aSKtWAVmDoy3s--
