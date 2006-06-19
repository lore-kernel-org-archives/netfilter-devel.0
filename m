From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 2/2] Specify nf_queue max length from userspace
Date: Mon, 19 Jun 2006 22:01:08 +0200
Message-ID: <1150747268.6979.10.camel@porky>
References: <1150217788.7164.4.camel@porky> <1150218404.5386.2.camel@porky>
	<4496D030.1010400@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-V2nr1swufP6zIYhTA2Wc"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4496D030.1010400@trash.net>
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


--=-V2nr1swufP6zIYhTA2Wc
Content-Type: multipart/mixed; boundary="=-V+oP7trzLqhfhKzu2dhg"


--=-V+oP7trzLqhfhKzu2dhg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Please found attached to this mail a libnetfilter_queue patch related to
my previous mail and patch.

BR,

On Mon, 2006-06-19 at 18:26 +0200, Patrick McHardy wrote:
> Eric Leblond wrote:
> > Attach patch is against current git kernel tree.
> >=20
> >=20
> >=20
> > -----------------------------------------------------------------------=
-
> >=20
> > Signed-off-by: Eric Leblond <eric@inl.fr>
> >=20
> >=20
> > ---
> >=20
> >  include/linux/netfilter/nfnetlink_queue.h |    2 ++
> >  net/netfilter/nfnetlink_queue.c           |    7 ++++++-
> >  2 files changed, 8 insertions(+), 1 deletions(-)
> >=20
> > 1fb988dc51e2465500df50ff4e085f80acb7b6a3
> > diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/=
netfilter/nfnetlink_queue.h
> > index 9e77437..ce32c54 100644
> > --- a/include/linux/netfilter/nfnetlink_queue.h
> > +++ b/include/linux/netfilter/nfnetlink_queue.h
> > @@ -67,6 +67,7 @@ struct nfqnl_msg_config_cmd {
> >  } __attribute__ ((packed));
> > =20
> >  enum nfqnl_config_mode {
> > +	NFQNL_COPY_UNSPEC,
> >  	NFQNL_COPY_NONE,
> >  	NFQNL_COPY_META,
> >  	NFQNL_COPY_PACKET,
>=20
> Looks like an ABI breaker.
>=20
> > @@ -75,6 +76,7 @@ enum nfqnl_config_mode {
> >  struct nfqnl_msg_config_params {
> >  	u_int32_t	copy_range;
> >  	u_int8_t	copy_mode;	/* enum nfqnl_config_mode */
> > +	u_int32_t   queue_maxlen;
> >  } __attribute__ ((packed));
>=20
> This too. Why not just use a new attribute?
--=20
Eric Leblond <eric@inl.fr>
INL

--=-V+oP7trzLqhfhKzu2dhg
Content-Disposition: attachment;
	filename*0=libnetfilter_queue-specify-queue-max-length-from-userspace.pa;
	filename*1=tch
Content-Type: text/x-patch;
	name=libnetfilter_queue-specify-queue-max-length-from-userspace.patch;
	charset=ISO-8859-15
Content-Transfer-Encoding: base64

LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tDQogDQpTaWduZWQtb2ZmLWJ5OiBFcmljIExlYmxvbmQgPGVyaWNAaW5s
LmZyPg0KIA0KIA0KLS0tDQoNCg0KSW5kZXg6IGluY2x1ZGUvbGlibmV0ZmlsdGVyX3F1ZXVlL2xp
bnV4X25mbmV0bGlua19xdWV1ZS5oDQo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQotLS0gaW5jbHVkZS9saWJuZXRmaWx0
ZXJfcXVldWUvbGludXhfbmZuZXRsaW5rX3F1ZXVlLmgJKHLDqXZpc2lvbiA2NDcwKQ0KKysrIGlu
Y2x1ZGUvbGlibmV0ZmlsdGVyX3F1ZXVlL2xpbnV4X25mbmV0bGlua19xdWV1ZS5oCShjb3BpZSBk
ZSB0cmF2YWlsKQ0KQEAgLTEsMTMgKzEsMTMgQEANCiAjaWZuZGVmIF9ORk5FVExJTktfUVVFVUVf
SA0KICNkZWZpbmUgX05GTkVUTElOS19RVUVVRV9IDQogDQotI2luY2x1ZGUgPGxpbnV4L3R5cGVz
Lmg+DQotI2luY2x1ZGUgPGxpYm5mbmV0bGluay9saW51eF9uZm5ldGxpbmsuaD4NCi0NCiAjaWZu
ZGVmIGFsaWduZWRfdTY0DQogI2RlZmluZSBhbGlnbmVkX3U2NCB1bnNpZ25lZCBsb25nIGxvbmcg
X19hdHRyaWJ1dGVfXygoYWxpZ25lZCg4KSkpDQogI2VuZGlmDQogDQorI2luY2x1ZGUgPGxpbnV4
L3R5cGVzLmg+DQorI2luY2x1ZGUgPGxpYm5mbmV0bGluay9saW51eF9uZm5ldGxpbmsuaD4NCisN
CiBlbnVtIG5mcW5sX21zZ190eXBlcyB7DQogCU5GUU5MX01TR19QQUNLRVQsCQkvKiBwYWNrZXQg
ZnJvbSBrZXJuZWwgdG8gdXNlcnNwYWNlICovDQogCU5GUU5MX01TR19WRVJESUNULAkJLyogdmVy
ZGljdCBmcm9tIHVzZXJzcGFjZSB0byBrZXJuZWwgKi8NCkBAIC04Niw2ICs4Niw3IEBADQogCU5G
UUFfQ0ZHX1VOU1BFQywNCiAJTkZRQV9DRkdfQ01ELAkJCS8qIG5mcW5sX21zZ19jb25maWdfY21k
ICovDQogCU5GUUFfQ0ZHX1BBUkFNUywJCS8qIG5mcW5sX21zZ19jb25maWdfcGFyYW1zICovDQor
CU5GUUFfQ0ZHX1FVRVVFX01BWExFTiwJCS8qIHVfaW50MzJfdCAqLw0KIAlfX05GUUFfQ0ZHX01B
WA0KIH07DQogI2RlZmluZSBORlFBX0NGR19NQVggKF9fTkZRQV9DRkdfTUFYLTEpDQpJbmRleDog
aW5jbHVkZS9saWJuZXRmaWx0ZXJfcXVldWUvbGlibmV0ZmlsdGVyX3F1ZXVlLmgNCj09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0NCi0tLSBpbmNsdWRlL2xpYm5ldGZpbHRlcl9xdWV1ZS9saWJuZXRmaWx0ZXJfcXVldWUuaAko
csOpdmlzaW9uIDY0NzApDQorKysgaW5jbHVkZS9saWJuZXRmaWx0ZXJfcXVldWUvbGlibmV0Zmls
dGVyX3F1ZXVlLmgJKGNvcGllIGRlIHRyYXZhaWwpDQpAQCAtNDksNiArNDksOSBAQA0KIGV4dGVy
biBpbnQgbmZxX3NldF9tb2RlKHN0cnVjdCBuZnFfcV9oYW5kbGUgKnFoLA0KIAkJCSAgdV9pbnQ4
X3QgbW9kZSwgdW5zaWduZWQgaW50IGxlbik7DQogDQoraW50IG5mcV9zZXRfcXVldWVfbWF4bGVu
KHN0cnVjdCBuZnFfcV9oYW5kbGUgKnFoLA0KKwkJCXVfaW50MzJfdCBxdWV1ZWxlbik7DQorDQog
ZXh0ZXJuIGludCBuZnFfc2V0X3ZlcmRpY3Qoc3RydWN0IG5mcV9xX2hhbmRsZSAqcWgsDQogCQkJ
ICAgICB1X2ludDMyX3QgaWQsDQogCQkJICAgICB1X2ludDMyX3QgdmVyZGljdCwNCkluZGV4OiBz
cmMvbGlibmV0ZmlsdGVyX3F1ZXVlLmMNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSBzcmMvbGlibmV0ZmlsdGVy
X3F1ZXVlLmMJKHLDqXZpc2lvbiA2NDcwKQ0KKysrIHNyYy9saWJuZXRmaWx0ZXJfcXVldWUuYwko
Y29waWUgZGUgdHJhdmFpbCkNCkBAIC0yODgsNiArMjg4LDIzIEBADQogCXJldHVybiBuZm5sX3Rh
bGsocWgtPmgtPm5mbmxoLCBubWgsIDAsIDAsIE5VTEwsIE5VTEwsIE5VTEwpOw0KIH0NCiANCitp
bnQgbmZxX3NldF9xdWV1ZV9tYXhsZW4oc3RydWN0IG5mcV9xX2hhbmRsZSAqcWgsDQorCQkJCXVf
aW50MzJfdCBxdWV1ZWxlbikNCit7DQorCWNoYXIgYnVmW05GTkxfSEVBREVSX0xFTg0KKwkJK05G
QV9MRU5HVEgoc2l6ZW9mKHN0cnVjdCBuZnFubF9tc2dfY29uZmlnX3BhcmFtcykpXTsNCisJdV9p
bnQzMl90IHF1ZXVlX21heGxlbiA9IGh0b25sKHF1ZXVlbGVuKTsNCisJc3RydWN0IG5sbXNnaGRy
ICpubWggPSAoc3RydWN0IG5sbXNnaGRyICopIGJ1ZjsNCisNCisJbmZubF9maWxsX2hkcihxaC0+
aC0+bmZubHNzaCwgbm1oLCAwLCBBRl9VTlNQRUMsIHFoLT5pZCwNCisJCQlORlFOTF9NU0dfQ09O
RklHLCBOTE1fRl9SRVFVRVNUfE5MTV9GX0FDSyk7DQorDQorCW5mbmxfYWRkYXR0cl9sKG5taCwg
c2l6ZW9mKGJ1ZiksIE5GUUFfQ0ZHX1FVRVVFX01BWExFTiwgJnF1ZXVlX21heGxlbiwNCisJCQlz
aXplb2YocXVldWVfbWF4bGVuKSk7DQorDQorCXJldHVybiBuZm5sX3RhbGsocWgtPmgtPm5mbmxo
LCBubWgsIDAsIDAsIE5VTEwsIE5VTEwsIE5VTEwpOw0KK30NCisNCiBzdGF0aWMgaW50IF9fc2V0
X3ZlcmRpY3Qoc3RydWN0IG5mcV9xX2hhbmRsZSAqcWgsIHVfaW50MzJfdCBpZCwNCiAJCXVfaW50
MzJfdCB2ZXJkaWN0LCB1X2ludDMyX3QgbWFyaywgaW50IHNldF9tYXJrLA0KIAkJdV9pbnQzMl90
IGRhdGFfbGVuLCB1bnNpZ25lZCBjaGFyICpkYXRhKQ0K


--=-V+oP7trzLqhfhKzu2dhg--

--=-V2nr1swufP6zIYhTA2Wc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBElwKEnxA7CdMWjzIRAoLyAJ9idqMRC5DfgHAq4nhPardbLQd1lgCfUS1q
C0Njl/Gf3vssbKXBpuU6poc=
=UEPW
-----END PGP SIGNATURE-----

--=-V2nr1swufP6zIYhTA2Wc--
