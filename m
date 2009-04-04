From: Peter Volkov <pva@gentoo.org>
Subject: [patch] iptables-1.4.3.1: unabled to restore ! -s 192.168.1.0/24
 match
Date: Sat, 04 Apr 2009 13:50:34 +0400
Message-ID: <1238838634.31963.578.camel@localhost>
References: <49C8DB3B.909@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-052zGZhlKC4M4jD2XEBz"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:47002 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbZDDJvO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Apr 2009 05:51:14 -0400
In-Reply-To: <49C8DB3B.909@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-052zGZhlKC4M4jD2XEBz
Content-Type: multipart/mixed; boundary="=-MTGnwJ6Cbk6v0KH6hrmd"


--=-MTGnwJ6Cbk6v0KH6hrmd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi. We've received bug report about broken ! -s 192.168.1.0/24 match:
http://bugs.gentoo.org/264089

Steps to reproduce:
iptables -A INPUT -i eth0 ! --src 192.168.1.0/24
iptables-save > ruleset
iptables-restore < ruleset
Using intrapositioned negation (`--option ! this`) is deprecated in favor o=
f extrapositioned (`! --option this`).

Patch in attachment is supposed to fix this issue. Please, if it's
correct, apply.

--=20
Peter.

--=-MTGnwJ6Cbk6v0KH6hrmd
Content-Disposition: attachment; filename="iptables-1.4.3.1-src-save-restore.patch"
Content-Type: text/x-patch; name="iptables-1.4.3.1-src-save-restore.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

Y29tbWl0IGJhOGI5ZDU1NTkwNTBiMTdkYTU1NjJiOGJlMjE4NTQyODk5MzdiM2UNCkF1dGhvcjog
UGV0ZXIgVm9sa292IDxwdmFAZ2VudG9vLm9yZz4NCkRhdGU6ICAgU2F0IEFwciA0IDEzOjMzOjU5
IDIwMDkgKzA0MDANCg0KICAgIEZpeCBzYXZlIG9mIG5lZ2F0ZWQgbWF0Y2ggKCEgLXMgMTkyLjE2
OC4xLjAvMjQpDQogICAgDQogICAgaXB0YWJsZXMtcmVzdG9yZSB1bmFibGVkIHRvIHJlc3RvcmUg
ISAtcyAxOTIuMTY4LjEuMC8yNCBtYXRjaCBzYXZlZCBieQ0KICAgIGlwdGFibGVzLXNhdmUuIFRo
aXMgcGF0Y2ggZml4ZXMgb3JkZXJpbmcgb2Ygb3V0cHV0IGlzc3VlZCBieSBwcmludF9pcC4NCiAg
ICBSZXBvcnRlZCBhdCBodHRwOi8vYnVncy5nZW50b28ub3JnLzI2NDA4OSwgdGhhbmsgWWFyIE9k
aW4gZm9yIHJlcG9ydC4NCg0KZGlmZiAtLWdpdCBhL2lwdGFibGVzLmMgYi9pcHRhYmxlcy5jDQpp
bmRleCAzNDQ5ZGVjLi5mZTQzYWIwIDEwMDY0NA0KLS0tIGEvaXB0YWJsZXMuYw0KKysrIGIvaXB0
YWJsZXMuYw0KQEAgLTEwODksOSArMTA4OSw5IEBAIHN0YXRpYyB2b2lkIHByaW50X2lwKGNoYXIg
KnByZWZpeCwgdV9pbnQzMl90IGlwLCB1X2ludDMyX3QgbWFzaywgaW50IGludmVydCkNCiAJaWYg
KCFtYXNrICYmICFpcCAmJiAhaW52ZXJ0KQ0KIAkJcmV0dXJuOw0KIA0KLQlwcmludGYoIiVzICVz
JXUuJXUuJXUuJXUiLA0KLQkJcHJlZml4LA0KKwlwcmludGYoIiVzJXMgJXUuJXUuJXUuJXUiLA0K
IAkJaW52ZXJ0ID8gIiEgIiA6ICIiLA0KKwkJcHJlZml4LA0KIAkJSVBfUEFSVFMoaXApKTsNCiAN
CiAJaWYgKG1hc2sgPT0gMHhGRkZGRkZGRlUpIHsNCg==


--=-MTGnwJ6Cbk6v0KH6hrmd--

--=-052zGZhlKC4M4jD2XEBz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEABECAAYFAknXLWoACgkQz6tlgEWSarPIKwCggpVtCOC0aJaWtLzpu/aXYoHP
ZUoAoJQBSkBUC1+y1CU0Oya2Ns+/t+cN
=OsPt
-----END PGP SIGNATURE-----

--=-052zGZhlKC4M4jD2XEBz--

