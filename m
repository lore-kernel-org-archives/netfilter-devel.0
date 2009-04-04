From: Peter Volkov <pva@gentoo.org>
Subject: [patch] iptables-1.4.3.1: unabled to restore proto and iface
 negated matches
Date: Sat, 04 Apr 2009 14:11:12 +0400
Message-ID: <1238839872.31963.621.camel@localhost>
References: <49C8DB3B.909@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EfY+QwnEqrN42KAZ+XPN"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:45366 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106AbZDDKLw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Apr 2009 06:11:52 -0400
In-Reply-To: <49C8DB3B.909@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-EfY+QwnEqrN42KAZ+XPN
Content-Type: multipart/mixed; boundary="=-7ma1aNmuc8F2Q5t3yOYn"


--=-7ma1aNmuc8F2Q5t3yOYn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi. After previous fix I've reviewed sources a bit and found that
protocol and iface negated matches are broken in the same regard. Patch
in attachment fixes them too.

--=20
Peter.

--=-7ma1aNmuc8F2Q5t3yOYn
Content-Disposition: attachment; filename="iptables-1.4.3.1-proto-iface-save-restore.patch"
Content-Type: text/x-patch; name="iptables-1.4.3.1-proto-iface-save-restore.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

Y29tbWl0IGEwOGRiMzQ5ZDBiZTk5YThhZThiNGFiMjcxNDg5YjQyNzM1ZjQ0MDQNCkF1dGhvcjog
UGV0ZXIgVm9sa292IDxwdmFAZ2VudG9vLm9yZz4NCkRhdGU6ICAgU2F0IEFwciA0IDE0OjA3OjMx
IDIwMDkgKzA0MDANCg0KICAgIEZpeCByZXN0b3JlIG9mIG5lZ2F0ZWQgaWZhY2UgYW5kIHByb3Rv
IG1hdGNoZXMNCiAgICANCiAgICBBdHRlbXQgdG8gcmVzdG9yZSBydWxlc2V0IHdpdGggISAtaSBp
ZmFjZSBvciAhIC1wIHByb3RvIG1hdGNoZXMgZmFpbA0KICAgIHdpdGggdGhlIGZvbGxvd2luZyBl
cnJvcjoNCiAgICANCiAgICBVc2luZyBpbnRyYXBvc2l0aW9uZWQgbmVnYXRpb24gKGAtLW9wdGlv
biAhIHRoaXNgKSBpcyBkZXByZWNhdGVkIGluDQogICAgZmF2b3Igb2YgZXh0cmFwb3NpdGlvbmVk
IChgISAtLW9wdGlvbiB0aGlzYCkuDQogICAgDQogICAgVGhpcyBwYXRjaCBmaXhlcyB0aGlzIGlz
c3VlLg0KDQpkaWZmIC0tZ2l0IGEvaXB0YWJsZXMuYyBiL2lwdGFibGVzLmMNCmluZGV4IGZlNDNh
YjAuLjM5Mjk4MWYgMTAwNjQ0DQotLS0gYS9pcHRhYmxlcy5jDQorKysgYi9pcHRhYmxlcy5jDQpA
QCAtMTAwMiwyMiArMTAwMiwyMiBAQCBzdGF0aWMgdm9pZCBwcmludF9wcm90byh1X2ludDE2X3Qg
cHJvdG8sIGludCBpbnZlcnQpDQogew0KIAlpZiAocHJvdG8pIHsNCiAJCXVuc2lnbmVkIGludCBp
Ow0KLQkJY29uc3QgY2hhciAqaW52ZXJ0c3RyID0gaW52ZXJ0ID8gIiEgIiA6ICIiOw0KKwkJY29u
c3QgY2hhciAqaW52ZXJ0c3RyID0gaW52ZXJ0ID8gIiEiIDogIiI7DQogDQogCQlzdHJ1Y3QgcHJv
dG9lbnQgKnBlbnQgPSBnZXRwcm90b2J5bnVtYmVyKHByb3RvKTsNCiAJCWlmIChwZW50KSB7DQot
CQkJcHJpbnRmKCItcCAlcyVzICIsIGludmVydHN0ciwgcGVudC0+cF9uYW1lKTsNCisJCQlwcmlu
dGYoIiVzIC1wICVzICIsIGludmVydHN0ciwgcGVudC0+cF9uYW1lKTsNCiAJCQlyZXR1cm47DQog
CQl9DQogDQogCQlmb3IgKGkgPSAwOyB4dGFibGVzX2NoYWluX3Byb3Rvc1tpXS5uYW1lICE9IE5V
TEw7ICsraSkNCiAJCQlpZiAoeHRhYmxlc19jaGFpbl9wcm90b3NbaV0ubnVtID09IHByb3RvKSB7
DQotCQkJCXByaW50ZigiLXAgJXMlcyAiLA0KKwkJCQlwcmludGYoIiVzIC1wICVzICIsDQogCQkJ
CSAgICAgICBpbnZlcnRzdHIsIHh0YWJsZXNfY2hhaW5fcHJvdG9zW2ldLm5hbWUpOw0KIAkJCQly
ZXR1cm47DQogCQkJfQ0KIA0KLQkJcHJpbnRmKCItcCAlcyV1ICIsIGludmVydHN0ciwgcHJvdG8p
Ow0KKwkJcHJpbnRmKCIlcyAtcCAldSAiLCBpbnZlcnRzdHIsIHByb3RvKTsNCiAJfQ0KIH0NCiAN
CkBAIC0xMDM5LDcgKzEwMzksNyBAQCBwcmludF9pZmFjZShjaGFyIGxldHRlciwgY29uc3QgY2hh
ciAqaWZhY2UsIGNvbnN0IHVuc2lnbmVkIGNoYXIgKm1hc2ssDQogCWlmIChtYXNrWzBdID09IDAp
DQogCQlyZXR1cm47DQogDQotCXByaW50ZigiLSVjICVzIiwgbGV0dGVyLCBpbnZlcnQgPyAiISAi
IDogIiIpOw0KKwlwcmludGYoIiVzIC0lYyAiLCBpbnZlcnQgPyAiISIgOiAiIiwgbGV0dGVyKTsN
CiANCiAJZm9yIChpID0gMDsgaSA8IElGTkFNU0laOyBpKyspIHsNCiAJCWlmIChtYXNrW2ldICE9
IDApIHsNCg==


--=-7ma1aNmuc8F2Q5t3yOYn--

--=-EfY+QwnEqrN42KAZ+XPN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEABECAAYFAknXMkAACgkQz6tlgEWSarOrPwCfbIeDoxqeQynFIooI8ex5DKtQ
nWEAn2G191wHwNEWiUSpvThbaVFT95PS
=M04C
-----END PGP SIGNATURE-----

--=-EfY+QwnEqrN42KAZ+XPN--

