From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 1/2] Specify nf_queue max length from userspace
Date: Mon, 19 Jun 2006 21:57:10 +0200
Message-ID: <1150747030.6979.6.camel@porky>
References: <1150217788.7164.4.camel@porky> <1150218404.5386.2.camel@porky>
	<4496D030.1010400@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-0SJaSyL5AHcWq9a4eM4L"
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


--=-0SJaSyL5AHcWq9a4eM4L
Content-Type: multipart/mixed; boundary="=-0UW69WzY69BhJKxNIhQm"


--=-0UW69WzY69BhJKxNIhQm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> > @@ -75,6 +76,7 @@ enum nfqnl_config_mode {
> >  struct nfqnl_msg_config_params {
> >  	u_int32_t	copy_range;
> >  	u_int8_t	copy_mode;	/* enum nfqnl_config_mode */
> > +	u_int32_t   queue_maxlen;
> >  } __attribute__ ((packed));
>=20
> This too. Why not just use a new attribute?

I did not like the idea of having params split between two structures.
And as the user base is still small, I thought we may break ABI to have
something cleaner.
Pablo and you do not like the idea, I wrote a patch that should not
break the ABI (attached to the mail).
In fact, after introducing the new attribute, I just found it is in a
way cleaner than my initial one because code does not depend from a
structure.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-0UW69WzY69BhJKxNIhQm
Content-Disposition: attachment;
	filename=specify-queue-max-length-from-userspace.patch
Content-Type: text/x-patch; name=specify-queue-max-length-from-userspace.patch;
	charset=ISO-8859-15
Content-Transfer-Encoding: base64

LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tDQogDQpTaWduZWQtb2ZmLWJ5OiBFcmljIExlYmxvbmQgPGVyaWNAaW5s
LmZyPg0KIA0KIA0KLS0tDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXIvbmZu
ZXRsaW5rX3F1ZXVlLmggYi9pbmNsdWRlL2xpbnV4L25ldGZpbHRlci9uZm5ldGxpbmtfcXVldWUu
aA0KaW5kZXggOWU3NzQzNy4uMjJmZmFjMCAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvbmV0
ZmlsdGVyL25mbmV0bGlua19xdWV1ZS5oDQorKysgYi9pbmNsdWRlL2xpbnV4L25ldGZpbHRlci9u
Zm5ldGxpbmtfcXVldWUuaA0KQEAgLTgyLDYgKzgyLDcgQEAgZW51bSBuZnFubF9hdHRyX2NvbmZp
ZyB7DQogCU5GUUFfQ0ZHX1VOU1BFQywNCiAJTkZRQV9DRkdfQ01ELAkJCS8qIG5mcW5sX21zZ19j
b25maWdfY21kICovDQogCU5GUUFfQ0ZHX1BBUkFNUywJCS8qIG5mcW5sX21zZ19jb25maWdfcGFy
YW1zICovDQorCU5GUUFfQ0ZHX1FVRVVFX01BWExFTiwJCS8qIHVfaW50MzJfdCAqLw0KIAlfX05G
UUFfQ0ZHX01BWA0KIH07DQogI2RlZmluZSBORlFBX0NGR19NQVggKF9fTkZRQV9DRkdfTUFYLTEp
DQpkaWZmIC0tZ2l0IGEvbmV0L25ldGZpbHRlci9uZm5ldGxpbmtfcXVldWUuYyBiL25ldC9uZXRm
aWx0ZXIvbmZuZXRsaW5rX3F1ZXVlLmMNCmluZGV4IDg2YTRhYzMuLjkzNmM4NmIgMTAwNjQ0DQot
LS0gYS9uZXQvbmV0ZmlsdGVyL25mbmV0bGlua19xdWV1ZS5jDQorKysgYi9uZXQvbmV0ZmlsdGVy
L25mbmV0bGlua19xdWV1ZS5jDQpAQCAtOTM5LDYgKzkzOSwxNCBAQCBuZnFubF9yZWN2X2NvbmZp
ZyhzdHJ1Y3Qgc29jayAqY3RubCwgc3RyDQogCQkJCW50b2hsKHBhcmFtcy0+Y29weV9yYW5nZSkp
Ow0KIAl9DQogDQorCWlmIChuZnFhW05GUUFfQ0ZHX1FVRVVFX01BWExFTi0xXSkgew0KKwkJdV9p
bnQzMl90ICpxdWV1ZV9tYXhsZW47DQorCQlxdWV1ZV9tYXhsZW4gPSBORkFfREFUQShuZnFhW05G
UUFfQ0ZHX1FVRVVFX01BWExFTi0xXSk7DQorCQlzcGluX2xvY2tfYmgoJnF1ZXVlLT5sb2NrKTsN
CisJCXF1ZXVlLT5xdWV1ZV9tYXhsZW4gPSBudG9obCgqcXVldWVfbWF4bGVuKTsNCisJCXNwaW5f
dW5sb2NrX2JoKCZxdWV1ZS0+bG9jayk7DQorCX0NCisNCiBvdXRfcHV0Og0KIAlpbnN0YW5jZV9w
dXQocXVldWUpOw0KIAlyZXR1cm4gcmV0Ow0K


--=-0UW69WzY69BhJKxNIhQm--

--=-0SJaSyL5AHcWq9a4eM4L
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBElwGWnxA7CdMWjzIRAl93AJ0SVV871AmTD8yn0GWTYsdxRwuy3ACbBlvG
EJl/oK4QQ17gJ/U1GfERoDI=
=2DaY
-----END PGP SIGNATURE-----

--=-0SJaSyL5AHcWq9a4eM4L--
