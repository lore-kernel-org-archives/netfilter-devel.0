From: Eric Leblond <eric@regit.org>
Subject: p-o-m-ng patch
Date: Fri, 20 Feb 2004 14:41:30 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1077284489.27084.5.camel@tech004.alphalink.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zt0SMxx1ad/Bdcp8eBjw"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-zt0SMxx1ad/Bdcp8eBjw
Content-Type: multipart/mixed; boundary="=-rvDJxsqMhJJuK7GlIrGS"


--=-rvDJxsqMhJJuK7GlIrGS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

The best match code has a problem with selection of best directory when
initiating patchlet. Existence of a best directory was sufficient to
decide to choose this directory even if it is empty.
I attach a patch to Netfilter_POM.pm that solves the problem.

BR,
--=20
Eric Leblond
NuFW, Now User Filtering Works (http://www.nufw.org)

--=-rvDJxsqMhJJuK7GlIrGS
Content-Disposition: attachment; filename=netfilter_pom.patch
Content-Type: text/x-patch; name=netfilter_pom.patch; charset=ISO-8859-15
Content-Transfer-Encoding: base64

LS0tIE5ldGZpbHRlcl9QT00ucG0JMjAwNC0wMi0yMCAxNDozNjoxOC4wMDAwMDAwMDAgKzAxMDAN
CisrKyBOZXRmaWx0ZXJfUE9NLnBtLm5ldwkyMDA0LTAyLTIwIDE0OjM2OjMyLjAwMDAwMDAwMCAr
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
CiAJfQ0KIA0KQEAgLTY5MCw2ICs2OTIsNyBAQA0KIAlmb3IgbXkgJGZpbGUgKEB7JCRwYXRjaGxl
dHtsYWRkc317JHByb2p9e2Jlc3R9fSkgew0KIAkJbXkgJGRlc3RkaXIgPSAoJHByb2pkaXIgLiAi
LyIgLiBGaWxlOjpCYXNlbmFtZTo6ZGlybmFtZSgkZmlsZSkpOw0KIAkJbXkgJGJhc2VuYW1lID0g
RmlsZTo6QmFzZW5hbWU6OmJhc2VuYW1lKCRmaWxlKTsNCisNCiAJCWlmICgkcHJvaiBlcSAnbGlu
dXgnKSB7DQogCQkJaWYgKCR2ZXJzaW9ueydsaW51eCd9ID1+IC9eMlwuNFwuXGQrLyAmJg0KIAkJ
CSAgICAkYmFzZW5hbWUgPX4gL15LY29uZmlnLykgew0KQEAgLTcwNSw3ICs3MDgsNyBAQA0KIAkJ
IwkJZGllKCJ1bmFibGUgdG8gbWtwYXRoKCRkZXN0ZGlyKTogJCFcbiIpOw0KIAkJI30NCiAJCWlm
ICghYXBwbHlfbGluZWFkZCgkcGF0Y2hsZXQsICRmaWxlLA0KLQkJCQkgICAkJHBhdGNobGV0e2Jh
c2VkaXJ9LicvJy4kcHJvai4kJHBhdGNobGV0e2ZpbGVzfXskcHJvan17YmVzdF9wcmVmaXh9Licv
JywgDQorCQkJCSAgICQkcGF0Y2hsZXR7YmFzZWRpcn0uJy8nLiRwcm9qLiQkcGF0Y2hsZXR7bGFk
ZHN9eyRwcm9qfXtiZXN0X3ByZWZpeH0uJy8nLCANCiAJCQkJICAgJHByb2pkaXIsICRyZXZlcnQs
ICR0ZXN0KSkgew0KIAkJCSMgZG9uJ3Qgb3ZlcnJpZGUgJEVSUk1TRw0KIAkJCXJldHVybiAwOw0K


--=-rvDJxsqMhJJuK7GlIrGS--

--=-zt0SMxx1ad/Bdcp8eBjw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e=2E?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBANg6InxA7CdMWjzIRAjhlAJ9/lGWzKh+5/gtYYiQ9mYzr+IIJnwCdEXzV
eXCyLvL9dFsjMgB3omn3358=
=jkV2
-----END PGP SIGNATURE-----

--=-zt0SMxx1ad/Bdcp8eBjw--
