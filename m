From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] Dump mark even if event is a DESTROY event
Date: Tue, 20 Feb 2007 10:45:21 +0100
Message-ID: <1171964721.26768.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-PQ7pilW9haec0Ufmimp/"
To: netfilter-devel@lists.netfilter.org
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


--=-PQ7pilW9haec0Ufmimp/
Content-Type: multipart/mixed; boundary="=-N9w0aqKisX/IsEMlk+A2"


--=-N9w0aqKisX/IsEMlk+A2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

Mark is scarcely dump by nfnetlink_conntrack event handler. As it can be
used to test that a connection is part of a given subset, I think it
should be almost always dumped.

The attached patch implements this behaviour.

BR,
--=20
=C9ric Leblond, eleblond@inl.fr
T=E9l=E9phone : 01 44 89 46 39, Fax : 01 44 89 45 01
INL, http://www.inl.fr

--=-N9w0aqKisX/IsEMlk+A2
Content-Disposition: attachment;
	filename=0002-Dump-mark-even-if-event-is-a-DESTROY-event.txt
Content-Type: text/plain;
	name=0002-Dump-mark-even-if-event-is-a-DESTROY-event.txt;
	charset=ISO-8859-15
Content-Transfer-Encoding: base64

U2lnbmVkLW9mZi1ieTogRXJpYyBMZWJsb25kIDxlcmljQGlubC5mcj4NCi0tLQ0KIG5ldC9uZXRm
aWx0ZXIvbmZfY29ubnRyYWNrX25ldGxpbmsuYyB8ICAgMTIgKysrKysrLS0tLS0tDQogMSBmaWxl
cyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQg
YS9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19uZXRsaW5rLmMgYi9uZXQvbmV0ZmlsdGVyL25m
X2Nvbm50cmFja19uZXRsaW5rLmMNCmluZGV4IGM2NGYwMjkuLjNlMjkxZTMgMTAwNjQ0DQotLS0g
YS9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19uZXRsaW5rLmMNCisrKyBiL25ldC9uZXRmaWx0
ZXIvbmZfY29ubnRyYWNrX25ldGxpbmsuYw0KQEAgLTM4OSwxNyArMzg5LDE3IEBAIHN0YXRpYyBp
bnQgY3RuZXRsaW5rX2Nvbm50cmFja19ldmVudChzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKnRoaXMs
DQogCQkgICAgJiYgY3RuZXRsaW5rX2R1bXBfaGVscGluZm8oc2tiLCBjdCkgPCAwKQ0KIAkJICAg
IAlnb3RvIG5mYXR0cl9mYWlsdXJlOw0KIA0KLSNpZmRlZiBDT05GSUdfTkZfQ09OTlRSQUNLX01B
UksNCi0JCWlmICgoZXZlbnRzICYgSVBDVF9NQVJLIHx8IGN0LT5tYXJrKQ0KLQkJICAgICYmIGN0
bmV0bGlua19kdW1wX21hcmsoc2tiLCBjdCkgPCAwKQ0KLQkJICAgIAlnb3RvIG5mYXR0cl9mYWls
dXJlOw0KLSNlbmRpZg0KLQ0KIAkJaWYgKGV2ZW50cyAmIElQQ1RfQ09VTlRFUl9GSUxMSU5HICYm
DQogCQkgICAgKGN0bmV0bGlua19kdW1wX2NvdW50ZXJzKHNrYiwgY3QsIElQX0NUX0RJUl9PUklH
SU5BTCkgPCAwIHx8DQogCQkgICAgIGN0bmV0bGlua19kdW1wX2NvdW50ZXJzKHNrYiwgY3QsIElQ
X0NUX0RJUl9SRVBMWSkgPCAwKSkNCiAJCQlnb3RvIG5mYXR0cl9mYWlsdXJlOw0KIAl9DQorCQ0K
KyNpZmRlZiBDT05GSUdfTkZfQ09OTlRSQUNLX01BUksNCisJaWYgKChldmVudHMgJiBJUENUX01B
UksgfHwgY3QtPm1hcmspDQorCSAgICAmJiBjdG5ldGxpbmtfZHVtcF9tYXJrKHNrYiwgY3QpIDwg
MCkNCisJICAgIAlnb3RvIG5mYXR0cl9mYWlsdXJlOw0KKyNlbmRpZg0KIA0KIAlubGgtPm5sbXNn
X2xlbiA9IHNrYi0+dGFpbCAtIGI7DQogCW5mbmV0bGlua19zZW5kKHNrYiwgMCwgZ3JvdXAsIDAp
Ow0KLS0gDQoxLjQuNC4zDQoNCg==


--=-N9w0aqKisX/IsEMlk+A2--

--=-PQ7pilW9haec0Ufmimp/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBF2sMwnxA7CdMWjzIRAhrYAJ4sEU2VeB/D5OBrz1spIzLApPhr+ACeODaL
jH7JnQmvOTskEjBzWVo5S5w=
=7aMN
-----END PGP SIGNATURE-----

--=-PQ7pilW9haec0Ufmimp/--
