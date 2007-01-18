From: Eric Leblond <eric@inl.fr>
Subject: [Patch 2/2] libnetfilter_queue and iface conversion to string
Date: Fri, 19 Jan 2007 00:33:11 +0100
Message-ID: <1169163191.8926.20.camel@localhost>
References: <1167257854.31765.21.camel@localhost>
	<45940145.3020003@netfilter.org> <1167349247.15420.13.camel@localhost>
	<20070107142607.GC13543@prithivi.gnumonks.org>
	<1168296086.12298.6.camel@localhost>
	<20070109115120.GX7655@prithivi.gnumonks.org>
	<1169162676.8926.14.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-sVR48ViuZ83zwczKcI06"
Cc: Vincent Deffontaines <vincent@inl.fr>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>, Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <1169162676.8926.14.camel@localhost>
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


--=-sVR48ViuZ83zwczKcI06
Content-Type: multipart/mixed; boundary="=-ee5rsBqzMBkSLbCgyREc"


--=-ee5rsBqzMBkSLbCgyREc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Here's the patch against libnetfilter_queue.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-ee5rsBqzMBkSLbCgyREc
Content-Disposition: attachment; filename=libnetfilter_queue_iface_name.diff
Content-Type: text/x-patch; name=libnetfilter_queue_iface_name.diff;
	charset=ISO-8859-15
Content-Transfer-Encoding: base64

SW5kZXg6IGluY2x1ZGUvbGlibmV0ZmlsdGVyX3F1ZXVlL2xpYm5ldGZpbHRlcl9xdWV1ZS5oDQo9
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09DQotLS0gaW5jbHVkZS9saWJuZXRmaWx0ZXJfcXVldWUvbGlibmV0ZmlsdGVyX3F1
ZXVlLmgJKHLDqXZpc2lvbiA2NzM3KQ0KKysrIGluY2x1ZGUvbGlibmV0ZmlsdGVyX3F1ZXVlL2xp
Ym5ldGZpbHRlcl9xdWV1ZS5oCShjb3BpZSBkZSB0cmF2YWlsKQ0KQEAgLTgwLDYgKzgwLDExIEBA
DQogZXh0ZXJuIHVfaW50MzJfdCBuZnFfZ2V0X291dGRldihzdHJ1Y3QgbmZxX2RhdGEgKm5mYWQp
Ow0KIGV4dGVybiB1X2ludDMyX3QgbmZxX2dldF9waHlzb3V0ZGV2KHN0cnVjdCBuZnFfZGF0YSAq
bmZhZCk7DQogDQorZXh0ZXJuIGNoYXIqIG5mcV9nZXRfaW5kZXZfbmFtZShzdHJ1Y3QgbmZxX2Rh
dGEgKm5mYWQpOw0KK2V4dGVybiBjaGFyKiBuZnFfZ2V0X3BoeXNpbmRldl9uYW1lKHN0cnVjdCBu
ZnFfZGF0YSAqbmZhZCk7DQorZXh0ZXJuIGNoYXIqIG5mcV9nZXRfb3V0ZGV2X25hbWUoc3RydWN0
IG5mcV9kYXRhICpuZmFkKTsNCitleHRlcm4gY2hhciogbmZxX2dldF9waHlzb3V0ZGV2X25hbWUo
c3RydWN0IG5mcV9kYXRhICpuZmFkKTsNCisNCiBleHRlcm4gc3RydWN0IG5mcW5sX21zZ19wYWNr
ZXRfaHcgKm5mcV9nZXRfcGFja2V0X2h3KHN0cnVjdCBuZnFfZGF0YSAqbmZhZCk7DQogDQogLyog
cmV0dXJuIC0xIGlmIHByb2JsZW0sIGxlbmd0aCBvdGhlcndpc2UgKi8NCkluZGV4OiBzcmMvbGli
bmV0ZmlsdGVyX3F1ZXVlLmMNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSBzcmMvbGlibmV0ZmlsdGVyX3F1ZXVl
LmMJKHLDqXZpc2lvbiA2NzM3KQ0KKysrIHNyYy9saWJuZXRmaWx0ZXJfcXVldWUuYwkoY29waWUg
ZGUgdHJhdmFpbCkNCkBAIC00MTksNiArNDE5LDMxIEBADQogCXJldHVybiBudG9obChuZm5sX2dl
dF9kYXRhKG5mYWQtPmRhdGEsIE5GUUFfSUZJTkRFWF9QSFlTT1VUREVWLCB1X2ludDMyX3QpKTsN
CiB9DQogDQorY2hhciogbmZxX2dldF9pbmRldl9uYW1lKHN0cnVjdCBuZnFfZGF0YSAqbmZhZCkN
Cit7DQorCXVfaW50MzJfdCBpZmluZGV4ID0gbmZxX2dldF9pbmRldihuZmFkKTsNCisJcmV0dXJu
IG5saWZfaW5kZXhfMm5hbWUoaWZpbmRleCk7DQorfQ0KKw0KK2NoYXIqIG5mcV9nZXRfcGh5c2lu
ZGV2X25hbWUoc3RydWN0IG5mcV9kYXRhICpuZmFkKQ0KK3sNCisJdV9pbnQzMl90IGlmaW5kZXgg
PSBuZnFfZ2V0X3BoeXNpbmRldihuZmFkKTsNCisJcmV0dXJuIG5saWZfaW5kZXhfMm5hbWUoaWZp
bmRleCk7DQorfQ0KKw0KK2NoYXIqIG5mcV9nZXRfb3V0ZGV2X25hbWUoc3RydWN0IG5mcV9kYXRh
ICpuZmFkKQ0KK3sNCisJdV9pbnQzMl90IGlmaW5kZXggPSBuZnFfZ2V0X291dGRldihuZmFkKTsN
CisJcmV0dXJuIG5saWZfaW5kZXhfMm5hbWUoaWZpbmRleCk7DQorfQ0KKw0KK2NoYXIqIG5mcV9n
ZXRfcGh5c291dGRldl9uYW1lKHN0cnVjdCBuZnFfZGF0YSAqbmZhZCkNCit7DQorCXVfaW50MzJf
dCBpZmluZGV4ID0gbmZxX2dldF9waHlzb3V0ZGV2KG5mYWQpOw0KKwlyZXR1cm4gbmxpZl9pbmRl
eF8ybmFtZShpZmluZGV4KTsNCit9DQorDQorDQogc3RydWN0IG5mcW5sX21zZ19wYWNrZXRfaHcg
Km5mcV9nZXRfcGFja2V0X2h3KHN0cnVjdCBuZnFfZGF0YSAqbmZhZCkNCiB7DQogCXJldHVybiBu
Zm5sX2dldF9wb2ludGVyX3RvX2RhdGEobmZhZC0+ZGF0YSwgTkZRQV9IV0FERFIsDQo=


--=-ee5rsBqzMBkSLbCgyREc--

--=-sVR48ViuZ83zwczKcI06
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBFsAO3nxA7CdMWjzIRAnr4AJ9gcK4okDmLeGsro3z3mAJN+wO6pACfaald
RFrUvpMnAQmRFVleq9p5If4=
=yVnY
-----END PGP SIGNATURE-----

--=-sVR48ViuZ83zwczKcI06--
