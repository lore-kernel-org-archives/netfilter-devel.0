From: Eric Leblond <eric@inl.fr>
Subject: Resend: [Patch 2/2] libnetfilter_queue and iface conversion to
	string
Date: Fri, 19 Jan 2007 17:17:58 +0100
Message-ID: <1169223478.8926.35.camel@localhost>
References: <1167257854.31765.21.camel@localhost>
	<45940145.3020003@netfilter.org> <1167349247.15420.13.camel@localhost>
	<20070107142607.GC13543@prithivi.gnumonks.org>
	<1168296086.12298.6.camel@localhost>
	<20070109115120.GX7655@prithivi.gnumonks.org>
	<1169162676.8926.14.camel@localhost>
	<1169163191.8926.20.camel@localhost> <45B0E2EE.1060500@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-MqNT9lX3yM4vdN3DbRlb"
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Vincent Deffontaines <vincent@inl.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45B0E2EE.1060500@trash.net>
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


--=-MqNT9lX3yM4vdN3DbRlb
Content-Type: multipart/mixed; boundary="=-mFB2gmTpngZm/N7EanD8"


--=-mFB2gmTpngZm/N7EanD8
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

Le vendredi 19 janvier 2007 =E0 16:25 +0100, Patrick McHardy a =E9crit :
> Eric Leblond wrote:
> > Index: src/libnetfilter_queue.c
> > +char* nfq_get_indev_name(struct nfq_data *nfad)
> > +{
> This might appear annoying, but I don't like inconsistency since
> it distracts me. So char * please, as in the parameters or in
> the other functions in this file.

Ok, not a problem. I'm sorry that I've missed this coding style point
too :(

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-mFB2gmTpngZm/N7EanD8
Content-Disposition: attachment; filename=libnetfilter_queue-ifacename.diff
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name=libnetfilter_queue-ifacename.diff;
	charset=ISO-8859-15

SW5kZXg6IGluY2x1ZGUvbGlibmV0ZmlsdGVyX3F1ZXVlL2xpYm5ldGZpbHRlcl9xdWV1ZS5oDQo9
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09DQotLS0gaW5jbHVkZS9saWJuZXRmaWx0ZXJfcXVldWUvbGlibmV0ZmlsdGVyX3F1
ZXVlLmgJKHLDqXZpc2lvbiA2NzM3KQ0KKysrIGluY2x1ZGUvbGlibmV0ZmlsdGVyX3F1ZXVlL2xp
Ym5ldGZpbHRlcl9xdWV1ZS5oCShjb3BpZSBkZSB0cmF2YWlsKQ0KQEAgLTgwLDYgKzgwLDExIEBA
DQogZXh0ZXJuIHVfaW50MzJfdCBuZnFfZ2V0X291dGRldihzdHJ1Y3QgbmZxX2RhdGEgKm5mYWQp
Ow0KIGV4dGVybiB1X2ludDMyX3QgbmZxX2dldF9waHlzb3V0ZGV2KHN0cnVjdCBuZnFfZGF0YSAq
bmZhZCk7DQogDQorZXh0ZXJuIGNoYXIgKm5mcV9nZXRfaW5kZXZfbmFtZShzdHJ1Y3QgbmZxX2Rh
dGEgKm5mYWQpOw0KK2V4dGVybiBjaGFyICpuZnFfZ2V0X3BoeXNpbmRldl9uYW1lKHN0cnVjdCBu
ZnFfZGF0YSAqbmZhZCk7DQorZXh0ZXJuIGNoYXIgKm5mcV9nZXRfb3V0ZGV2X25hbWUoc3RydWN0
IG5mcV9kYXRhICpuZmFkKTsNCitleHRlcm4gY2hhciAqbmZxX2dldF9waHlzb3V0ZGV2X25hbWUo
c3RydWN0IG5mcV9kYXRhICpuZmFkKTsNCisNCiBleHRlcm4gc3RydWN0IG5mcW5sX21zZ19wYWNr
ZXRfaHcgKm5mcV9nZXRfcGFja2V0X2h3KHN0cnVjdCBuZnFfZGF0YSAqbmZhZCk7DQogDQogLyog
cmV0dXJuIC0xIGlmIHByb2JsZW0sIGxlbmd0aCBvdGhlcndpc2UgKi8NCkluZGV4OiBzcmMvbGli
bmV0ZmlsdGVyX3F1ZXVlLmMNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSBzcmMvbGlibmV0ZmlsdGVyX3F1ZXVl
LmMJKHLDqXZpc2lvbiA2NzM3KQ0KKysrIHNyYy9saWJuZXRmaWx0ZXJfcXVldWUuYwkoY29waWUg
ZGUgdHJhdmFpbCkNCkBAIC00MTksNiArNDE5LDMxIEBADQogCXJldHVybiBudG9obChuZm5sX2dl
dF9kYXRhKG5mYWQtPmRhdGEsIE5GUUFfSUZJTkRFWF9QSFlTT1VUREVWLCB1X2ludDMyX3QpKTsN
CiB9DQogDQorY2hhciAqbmZxX2dldF9pbmRldl9uYW1lKHN0cnVjdCBuZnFfZGF0YSAqbmZhZCkN
Cit7DQorCXVfaW50MzJfdCBpZmluZGV4ID0gbmZxX2dldF9pbmRldihuZmFkKTsNCisJcmV0dXJu
IG5saWZfaW5kZXhfMm5hbWUoaWZpbmRleCk7DQorfQ0KKw0KK2NoYXIgKm5mcV9nZXRfcGh5c2lu
ZGV2X25hbWUoc3RydWN0IG5mcV9kYXRhICpuZmFkKQ0KK3sNCisJdV9pbnQzMl90IGlmaW5kZXgg
PSBuZnFfZ2V0X3BoeXNpbmRldihuZmFkKTsNCisJcmV0dXJuIG5saWZfaW5kZXhfMm5hbWUoaWZp
bmRleCk7DQorfQ0KKw0KK2NoYXIgKm5mcV9nZXRfb3V0ZGV2X25hbWUoc3RydWN0IG5mcV9kYXRh
ICpuZmFkKQ0KK3sNCisJdV9pbnQzMl90IGlmaW5kZXggPSBuZnFfZ2V0X291dGRldihuZmFkKTsN
CisJcmV0dXJuIG5saWZfaW5kZXhfMm5hbWUoaWZpbmRleCk7DQorfQ0KKw0KK2NoYXIgKm5mcV9n
ZXRfcGh5c291dGRldl9uYW1lKHN0cnVjdCBuZnFfZGF0YSAqbmZhZCkNCit7DQorCXVfaW50MzJf
dCBpZmluZGV4ID0gbmZxX2dldF9waHlzb3V0ZGV2KG5mYWQpOw0KKwlyZXR1cm4gbmxpZl9pbmRl
eF8ybmFtZShpZmluZGV4KTsNCit9DQorDQorDQogc3RydWN0IG5mcW5sX21zZ19wYWNrZXRfaHcg
Km5mcV9nZXRfcGFja2V0X2h3KHN0cnVjdCBuZnFfZGF0YSAqbmZhZCkNCiB7DQogCXJldHVybiBu
Zm5sX2dldF9wb2ludGVyX3RvX2RhdGEobmZhZC0+ZGF0YSwgTkZRQV9IV0FERFIsDQo=


--=-mFB2gmTpngZm/N7EanD8--

--=-MqNT9lX3yM4vdN3DbRlb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBFsO82nxA7CdMWjzIRAls9AKCJZ94d4YXvYoxr/PXLDtFdKiLn0gCfUqO+
1sNBi4c63YKGYU7Ip4V5Ve0=
=YxHm
-----END PGP SIGNATURE-----

--=-MqNT9lX3yM4vdN3DbRlb--
