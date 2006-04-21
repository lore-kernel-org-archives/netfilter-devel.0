From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] Rsend : Transmit mark to userspace during conntrack event
Date: Fri, 21 Apr 2006 22:55:32 +0200
Message-ID: <1145652932.5191.6.camel@localhost.localdomain>
References: <1145223945.5659.4.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-EpFUzDGwd5Tv+av59Pzm"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1145223945.5659.4.camel@porky>
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


--=-EpFUzDGwd5Tv+av59Pzm
Content-Type: multipart/mixed; boundary="=-A1qEFq+nIvi1da0Uz3rv"


--=-A1qEFq+nIvi1da0Uz3rv
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Le dimanche 16 avril 2006 =E0 23:45 +0200, Eric Leblond a =E9crit :
> Hi,
>=20
> When userspace listen to conntrack event, the connection mark was not
> sent in the ctnetlink message. The following patch transmits the
> connection mark to userspace.
>=20
> BR,

--=-A1qEFq+nIvi1da0Uz3rv
Content-Disposition: attachment; filename=ctnetlink.patch
Content-Type: text/x-patch; name=ctnetlink.patch; charset=us-ascii
Content-Transfer-Encoding: base64

U2lnbmVkLW9mZi1ieTogRXJpYyBMZWJsb25kIDxlcmljQGlubC5mcj4NCg0KLS0tDQpUcmFuc21p
dCBjb25uZWN0aW9uIG1hcmsgdG8gdXNlcnNwYWNlDQoNCkNvbm5lY3Rpb24gbWFyayB3YXMgbm90
IHNlbnQgdG8gdXNlcnNwYWNlIHdoZW4gdXNlZCBpbiBldmVudCBsaW5zdGVuaW5nIG1vZGUuDQoN
CmRpZmYgLS1naXQgYS9uZXQvaXB2NC9uZXRmaWx0ZXIvaXBfY29ubnRyYWNrX25ldGxpbmsuYyBi
L25ldC9pcHY0L25ldGZpbHRlci9pcF9jb25udHJhY2tfbmV0bGluay5jDQppbmRleCAwMWJkN2Nh
Li4wOTgyYTlkIDEwMDY0NA0KLS0tIGEvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX2Nvbm50cmFja19u
ZXRsaW5rLmMNCisrKyBiL25ldC9pcHY0L25ldGZpbHRlci9pcF9jb25udHJhY2tfbmV0bGluay5j
DQpAQCAtMzg1LDYgKzM4NSw5IEBAIHN0YXRpYyBpbnQgY3RuZXRsaW5rX2Nvbm50cmFja19ldmVu
dChzdHINCiAJICAgIGN0bmV0bGlua19kdW1wX2NvdW50ZXJzKHNrYiwgY3QsIElQX0NUX0RJUl9S
RVBMWSkgPCAwKQ0KIAkJZ290byBuZmF0dHJfZmFpbHVyZTsNCiANCisJaWYgKGN0bmV0bGlua19k
dW1wX21hcmsoc2tiLGN0KSA8IDApDQorCQlnb3RvIG5mYXR0cl9mYWlsdXJlOw0KKw0KIAlubGgt
Pm5sbXNnX2xlbiA9IHNrYi0+dGFpbCAtIGI7DQogCW5mbmV0bGlua19zZW5kKHNrYiwgMCwgZ3Jv
dXAsIDApOw0KIAlyZXR1cm4gTk9USUZZX0RPTkU7DQpkaWZmIC0tZ2l0IGEvbmV0L25ldGZpbHRl
ci9uZl9jb25udHJhY2tfbmV0bGluay5jIGIvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfbmV0
bGluay5jDQppbmRleCBiZDEwZWI5Li40NThhMGQ1IDEwMDY0NA0KLS0tIGEvbmV0L25ldGZpbHRl
ci9uZl9jb25udHJhY2tfbmV0bGluay5jDQorKysgYi9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFj
a19uZXRsaW5rLmMNCkBAIC0zOTQsNiArMzk0LDkgQEAgc3RhdGljIGludCBjdG5ldGxpbmtfY29u
bnRyYWNrX2V2ZW50KHN0cg0KIAkgICAgY3RuZXRsaW5rX2R1bXBfY291bnRlcnMoc2tiLCBjdCwg
SVBfQ1RfRElSX1JFUExZKSA8IDApDQogCQlnb3RvIG5mYXR0cl9mYWlsdXJlOw0KIA0KKwlpZiAo
Y3RuZXRsaW5rX2R1bXBfbWFyayhza2IsY3QpIDwgMCkNCisJCWdvdG8gbmZhdHRyX2ZhaWx1cmU7
DQorDQogCW5saC0+bmxtc2dfbGVuID0gc2tiLT50YWlsIC0gYjsNCiAJbmZuZXRsaW5rX3NlbmQo
c2tiLCAwLCBncm91cCwgMCk7DQogCXJldHVybiBOT1RJRllfRE9ORTsNCg==


--=-A1qEFq+nIvi1da0Uz3rv--

--=-EpFUzDGwd5Tv+av59Pzm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBESUbEnxA7CdMWjzIRApdUAJ4t1m0N0W0F6FEiBaiP9t2iypZKWACfYtbx
fB3XfbgsHlOoFD9WOeAqW2Y=
=dUNy
-----END PGP SIGNATURE-----

--=-EpFUzDGwd5Tv+av59Pzm--
