From: Eric Leblond <eric@regit.org>
Subject: Re: p-o-m-ng patch
Date: Fri, 20 Feb 2004 19:15:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1077300913.5116.12.camel@porky>
References: <1077284489.27084.5.camel@tech004.alphalink.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vvl5axvW82D4Cs6TQNo/"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <1077284489.27084.5.camel@tech004.alphalink.fr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-vvl5axvW82D4Cs6TQNo/
Content-Type: multipart/mixed; boundary="=-6lb7Z89fzaRQGy6XNSvt"


--=-6lb7Z89fzaRQGy6XNSvt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Some adjustement, this patch does not solve the issue of
Documentation/Configure.help.ladd in the CONNMARK patch.
This ladd should not be applied if we're compiling a 2.6 kernel.

I resend a corrected version.

BR,

Le ven 20/02/2004 =C3=A0 14:41, Eric Leblond a =C3=A9crit :
> Hi,
>=20
> The best match code has a problem with selection of best directory when
> initiating patchlet. Existence of a best directory was sufficient to
> decide to choose this directory even if it is empty.
> I attach a patch to Netfilter_POM.pm that solves the problem.
>=20
> BR,
--=20
Eric Leblond
Nufw, Now User Filtering Works (http://www.nufw.org)

--=-6lb7Z89fzaRQGy6XNSvt
Content-Disposition: attachment; filename=netfilter_pom.patch
Content-Type: text/x-patch; name=netfilter_pom.patch; charset=UTF-8
Content-Transfer-Encoding: base64

LS0tIE5ldGZpbHRlcl9QT00ucG0JMjAwNC0wMi0yMCAxOToxMzoxMy4wMDAwMDAwMDAgKzAxMDAN
CisrKyBOZXRmaWx0ZXJfUE9NLnBtLm5ldwkyMDA0LTAyLTIwIDE5OjEyOjU4LjAwMDAwMDAwMCAr
MDEwMA0KQEAgLTIyNCw5ICsyMjQsMTEgQEANCiAJCQkJCTogdmVyc2lvbl9jb21wYXJlKCR2ZXIs
ICI9PSIsICR2ZXJzaW9ueyRwcm9qfSk7DQogCQkJCWlmICgkbWF0Y2ggJiYgJG1hdGNoID4gJGJp
bmdvKSB7DQogCQkJCQkkYmluZ28gPSAkbWF0Y2g7DQorICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGlmICgoJHR5cGUgZXEgInBhdGNoIikgb3IgKHNjYWxhciBAeyQkcGF0
Y2hsZXR7JHR5cGV9eyRwcm9qfXskdmVyfX0pKXsNCiAJCQkJCSQkcGF0Y2hsZXR7JHR5cGV9eyRw
cm9qfXtiZXN0fSA9DQogCQkJCQkJJCRwYXRjaGxldHskdHlwZX17JHByb2p9eyR2ZXJ9Ow0KIAkJ
CQkJJCRwYXRjaGxldHskdHlwZX17JHByb2p9e2Jlc3RfcHJlZml4fSA9ICR2ZXIgPyAiLSR2ZXIi
IDogJyc7DQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH0NCiAJCQkJ
fQ0KIAkJCX0NCiAJCQlpZiAoJGJpbmdvIDwgMCkgew0KQEAgLTUxNSw3ICs1MTcsNyBAQA0KIAlt
eSAkbG9va2luZ2ZvcjsNCiANCiAJaWYgKCFvcGVuKExBREQsICRsYWRkaXIuJy8nLiRsYWRkZmls
ZSkpIHsNCi0JCSRFUlJNU0cgPSAidW5hYmxlIHRvIG9wZW4gbGFkZCAkbGFkZGZpbGUiOw0KKwkJ
JEVSUk1TRyA9ICJ1bmFibGUgdG8gb3BlbiBsYWRkICRsYWRkaXIvJGxhZGRmaWxlIjsNCiAJCXJl
dHVybiAwOw0KIAl9DQogDQpAQCAtNTMzLDcgKzUzNSw3IEBADQogDQogCWlmICghb3BlbihTUkMs
ICRrZXJuZWxkaXIuJy8nLiRzcmNmaWxlKSkgew0KIAkJY2xvc2UoTEFERCk7DQotCQkkRVJSTVNH
ID0gInVuYWJsZSB0byBvcGVuIGxhZGQgc3JjICRzcmNmaWxlIjsNCisJCSRFUlJNU0cgPSAidW5h
YmxlIHRvIG9wZW4gbGFkZCBzcmMgJGtlcm5lbGRpci8kc3JjZmlsZSI7DQogCQlyZXR1cm4gMDsN
CiAJfQ0KIA0KQEAgLTY5MCwxMyArNjkyLDE0IEBADQogCWZvciBteSAkZmlsZSAoQHskJHBhdGNo
bGV0e2xhZGRzfXskcHJvan17YmVzdH19KSB7DQogCQlteSAkZGVzdGRpciA9ICgkcHJvamRpciAu
ICIvIiAuIEZpbGU6OkJhc2VuYW1lOjpkaXJuYW1lKCRmaWxlKSk7DQogCQlteSAkYmFzZW5hbWUg
PSBGaWxlOjpCYXNlbmFtZTo6YmFzZW5hbWUoJGZpbGUpOw0KKw0KIAkJaWYgKCRwcm9qIGVxICds
aW51eCcpIHsNCiAJCQlpZiAoJHZlcnNpb257J2xpbnV4J30gPX4gL14yXC40XC5cZCsvICYmDQog
CQkJICAgICRiYXNlbmFtZSA9fiAvXktjb25maWcvKSB7DQogCQkJICAgIAluZXh0Ow0KIAkJCX0N
CiAJCQlpZiAoJHZlcnNpb257J2xpbnV4J30gPX4gL14yXC42XC5cZCsvICYmDQotCQkJICAgICRi
YXNlbmFtZSA9fiAvXkNvbmZpZ1wuaW4vKSB7DQorCQkJICAgICggKCRiYXNlbmFtZSA9fiAvXkNv
bmZpZ1wuaW4vKSBvciAoJGJhc2VuYW1lID1+IC9eQ29uZmlndXJlLmhlbHAvICkpKSB7DQogCQkJ
ICAgIAluZXh0Ow0KIAkJCX0NCiAJCX0NCkBAIC03MDUsNyArNzA4LDcgQEANCiAJCSMJCWRpZSgi
dW5hYmxlIHRvIG1rcGF0aCgkZGVzdGRpcik6ICQhXG4iKTsNCiAJCSN9DQogCQlpZiAoIWFwcGx5
X2xpbmVhZGQoJHBhdGNobGV0LCAkZmlsZSwNCi0JCQkJICAgJCRwYXRjaGxldHtiYXNlZGlyfS4n
LycuJHByb2ouJCRwYXRjaGxldHtmaWxlc317JHByb2p9e2Jlc3RfcHJlZml4fS4nLycsIA0KKwkJ
CQkgICAkJHBhdGNobGV0e2Jhc2VkaXJ9LicvJy4kcHJvai4kJHBhdGNobGV0e2xhZGRzfXskcHJv
an17YmVzdF9wcmVmaXh9LicvJywgDQogCQkJCSAgICRwcm9qZGlyLCAkcmV2ZXJ0LCAkdGVzdCkp
IHsNCiAJCQkjIGRvbid0IG92ZXJyaWRlICRFUlJNU0cNCiAJCQlyZXR1cm4gMDsNCg==

--=-6lb7Z89fzaRQGy6XNSvt--

--=-vvl5axvW82D4Cs6TQNo/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e=2E?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD4DBQBANk6xnxA7CdMWjzIRArLsAJdZZOTiZ1ELeBxmwTG1YG271xepAJ9Cl4oY
8JxurUTpTHQ/FMw6MWBi5w==
=J/sf
-----END PGP SIGNATURE-----

--=-vvl5axvW82D4Cs6TQNo/--
