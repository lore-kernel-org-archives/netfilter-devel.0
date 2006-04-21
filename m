From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 1/3] [kernel patch] fixed duration connection
Date: Fri, 21 Apr 2006 22:53:14 +0200
Message-ID: <1145652794.5191.3.camel@localhost.localdomain>
References: <1144139619.5186.24.camel@localhost.localdomain>
	<4433CCBF.6060103@trash.net> <4436DF6B.4060208@inl.fr>
	<4436E03E.9030402@inl.fr> <44381584.4020109@trash.net>
	<20060412083835.GN31616@sunbeam.de.gnumonks.org>
	<20060412104824.GU31616@sunbeam.de.gnumonks.org>
	<443D4FCE.2030802@trash.net>
	<56883.194.167.18.244.1144945066.squirrel@mail.inl.fr>
	<444843CC.3070105@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-P10DL89m7q1wuonupaXY"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	nufw-devel@nongnu.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <444843CC.3070105@trash.net>
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


--=-P10DL89m7q1wuonupaXY
Content-Type: multipart/mixed; boundary="=-TXctcXq5+9MswIhcRlR1"


--=-TXctcXq5+9MswIhcRlR1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Le vendredi 21 avril 2006 =E0 04:30 +0200, Patrick McHardy a =E9crit :
> Eric Leblond wrote:
> Thanks. Now all I need is a Signed-off-by: line :)
> Please send one for your ctnetlink fix as well.

I attach it to the mail and I hope this is ok. I stupidly did not manage
to get an autmotic way to add the Signed-off-by ...

BR,
--=20
Eric Leblond <eric@inl.fr>

--=-TXctcXq5+9MswIhcRlR1
Content-Disposition: attachment; filename=fixed_timeout.patch
Content-Type: text/x-patch; name=fixed_timeout.patch; charset=us-ascii
Content-Transfer-Encoding: base64

U2lnbmVkLW9mZi1ieTogRXJpYyBMZWJsb25kIDxlcmljQGlubC5mcj4NCg0KLS0tDQpBZGQgZml4
ZWQgdGltZW91dCBmbGFnIGluIGNvbm5lY3Rpb24gdHJhY2tpbmcNCg0KQWRkIGEgZmxhZyBpbiBh
IGNvbm5lY3Rpb24gc3RhdHVzIHRvIGhhdmUgYSBub24gdXBkYXRlZCB0aW1lb3V0Lg0KVGhpcyBw
ZXJtaXRzIHRvIGhhdmUgY29ubmVjdGlvbiB0aGF0IGF1dG9tYXRpY2FsbHkgZHllIGF0IGEgZ2l2
ZW4NCnRpbWUuDQoNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L25ldGZpbHRlci9uZl9jb25u
dHJhY2tfY29tbW9uLmggYi9pbmNsdWRlL2xpbnV4L25ldGZpbHRlci9uZl9jb25udHJhY2tfY29t
bW9uLmgNCmluZGV4IDNmZjg4YzguLjY4ZDI4MmQgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4
L25ldGZpbHRlci9uZl9jb25udHJhY2tfY29tbW9uLmgNCisrKyBiL2luY2x1ZGUvbGludXgvbmV0
ZmlsdGVyL25mX2Nvbm50cmFja19jb21tb24uaA0KQEAgLTY5LDYgKzY5LDExIEBAIGVudW0gaXBf
Y29ubnRyYWNrX3N0YXR1cyB7DQogCS8qIENvbm5lY3Rpb24gaXMgZHlpbmcgKHJlbW92ZWQgZnJv
bSBsaXN0cyksIGNhbiBub3QgYmUgdW5zZXQuICovDQogCUlQU19EWUlOR19CSVQgPSA5LA0KIAlJ
UFNfRFlJTkcgPSAoMSA8PCBJUFNfRFlJTkdfQklUKSwNCisNCisgICAgLyogQ29ubmVjdGlvbiBo
YXMgZml4ZWQgdGltZW91dC4gKi8NCisJSVBTX0ZJWEVEX1RJTUVPVVRfQklUID0gMTAsDQorCUlQ
U19GSVhFRF9USU1FT1VUID0gKDEgPDwgSVBTX0ZJWEVEX1RJTUVPVVRfQklUKSwNCisNCiB9Ow0K
IA0KIC8qIENvbm5lY3Rpb24gdHJhY2tpbmcgZXZlbnQgYml0cyAqLw0KZGlmZiAtLWdpdCBhL25l
dC9pcHY0L25ldGZpbHRlci9pcF9jb25udHJhY2tfY29yZS5jIGIvbmV0L2lwdjQvbmV0ZmlsdGVy
L2lwX2Nvbm50cmFja19jb3JlLmMNCmluZGV4IGNlYWFiYzEuLmQzNGVkZDcgMTAwNjQ0DQotLS0g
YS9uZXQvaXB2NC9uZXRmaWx0ZXIvaXBfY29ubnRyYWNrX2NvcmUuYw0KKysrIGIvbmV0L2lwdjQv
bmV0ZmlsdGVyL2lwX2Nvbm50cmFja19jb3JlLmMNCkBAIC0xMTMwLDYgKzExMzAsMTIgQEAgdm9p
ZCBfX2lwX2N0X3JlZnJlc2hfYWNjdChzdHJ1Y3QgaXBfY29ubg0KIA0KIAl3cml0ZV9sb2NrX2Jo
KCZpcF9jb25udHJhY2tfbG9jayk7DQogDQorCS8qIE9ubHkgdXBkYXRlIGlmIHRoaXMgaXMgbm90
IGEgZml4ZWQgdGltZW91dCAqLw0KKwlpZiAodGVzdF9iaXQoSVBTX0ZJWEVEX1RJTUVPVVRfQklU
LCAmY3QtPnN0YXR1cykpew0KKwkJd3JpdGVfdW5sb2NrX2JoKCZpcF9jb25udHJhY2tfbG9jayk7
DQorCQlyZXR1cm47DQorCX0NCisNCiAJLyogSWYgbm90IGluIGhhc2ggdGFibGUsIHRpbWVyIHdp
bGwgbm90IGJlIGFjdGl2ZSB5ZXQgKi8NCiAJaWYgKCFpc19jb25maXJtZWQoY3QpKSB7DQogCQlj
dC0+dGltZW91dC5leHBpcmVzID0gZXh0cmFfamlmZmllczsNCmRpZmYgLS1naXQgYS9uZXQvbmV0
ZmlsdGVyL25mX2Nvbm50cmFja19jb3JlLmMgYi9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19j
b3JlLmMNCmluZGV4IDU2Mzg5YzguLmE4ODA2OTIgMTAwNjQ0DQotLS0gYS9uZXQvbmV0ZmlsdGVy
L25mX2Nvbm50cmFja19jb3JlLmMNCisrKyBiL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2Nv
cmUuYw0KQEAgLTE0MDMsNiArMTQwMywxMiBAQCB2b2lkIF9fbmZfY3RfcmVmcmVzaF9hY2N0KHN0
cnVjdCBuZl9jb25uDQogDQogCXdyaXRlX2xvY2tfYmgoJm5mX2Nvbm50cmFja19sb2NrKTsNCiAN
CisJLyogT25seSB1cGRhdGUgaWYgdGhpcyBpcyBub3QgYSBmaXhlZCB0aW1lb3V0ICovDQorCWlm
ICh0ZXN0X2JpdChJUFNfRklYRURfVElNRU9VVF9CSVQsICZjdC0+c3RhdHVzKSkgew0KKwkJd3Jp
dGVfdW5sb2NrX2JoKCZuZl9jb25udHJhY2tfbG9jayk7DQorCQlyZXR1cm47DQorCX0NCisNCiAJ
LyogSWYgbm90IGluIGhhc2ggdGFibGUsIHRpbWVyIHdpbGwgbm90IGJlIGFjdGl2ZSB5ZXQgKi8N
CiAJaWYgKCFuZl9jdF9pc19jb25maXJtZWQoY3QpKSB7DQogCQljdC0+dGltZW91dC5leHBpcmVz
ID0gZXh0cmFfamlmZmllczsNCg==


--=-TXctcXq5+9MswIhcRlR1--

--=-P10DL89m7q1wuonupaXY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBESUY5nxA7CdMWjzIRAg98AJoCDvRLdVEL/AqeeDRjfC503gJOwgCfakWY
uvNlbx31FF0ZrnKDfRuFaQE=
=HK6L
-----END PGP SIGNATURE-----

--=-P10DL89m7q1wuonupaXY--
