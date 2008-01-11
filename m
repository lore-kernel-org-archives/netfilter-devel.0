From: Eric Leblond <eric@inl.fr>
Subject: Ulogd2: fix db OUTPUT system
Date: Fri, 11 Jan 2008 23:22:35 +0100
Message-ID: <1200090155.22717.7.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wcndSpKOSQzQYCII6fZl"
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:52993 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757380AbYAKWWh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2008 17:22:37 -0500
Received: from bayen.regit.org ([81.57.69.189] helo=[192.168.1.2])
	by fydelkass.inl.fr with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <eric@inl.fr>)
	id 1JDSGp-0001Pk-UC
	for netfilter-devel@vger.kernel.org; Fri, 11 Jan 2008 23:22:36 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-wcndSpKOSQzQYCII6fZl
Content-Type: multipart/mixed; boundary="=-fRHhCP2jo3UwOzD7GNZ+"


--=-fRHhCP2jo3UwOzD7GNZ+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

The following patch fixes MySQL and Pgsql output modules.

The callback function was not correctly initialized and this was leading
to a crash by calling the a NULL function. This patch correctly inits
the callback.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-fRHhCP2jo3UwOzD7GNZ+
Content-Disposition: attachment;
	filename*0=0002-Set-callback-in-db-module-to-avoid-calling-NULL-func.pat;
	filename*1=ch
Content-Type: application/mbox;
	name=0002-Set-callback-in-db-module-to-avoid-calling-NULL-func.patch
Content-Transfer-Encoding: base64

RnJvbSBjMWUwOGM4NDQ1YzgwMTI0Y2EzNjI4NjZmNTc5NDllZTM5OGRmOGNjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFcmljIGxlYmxvbmQgPGVyaWNAaW5sLmZyPgpEYXRlOiBGcmks
IDExIEphbiAyMDA4IDIzOjA1OjMyICswMTAwClN1YmplY3Q6IFtQQVRDSF0gU2V0IGNhbGxiYWNr
IGluIGRiIG1vZHVsZSB0byBhdm9pZCBjYWxsaW5nIE5VTEwgZnVuY3Rpb24uCgoKU2lnbmVkLW9m
Zi1ieTogRXJpYyBsZWJsb25kIDxlcmljQGlubC5mcj4KLS0tCiB1dGlsL2RiLmMgfCAgICA1ICsr
KystCiAxIGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS91dGlsL2RiLmMgYi91dGlsL2RiLmMKaW5kZXggMTM0MDFhZS4uNjVkMGYzOSAx
MDA2NDQKLS0tIGEvdXRpbC9kYi5jCisrKyBiL3V0aWwvZGIuYwpAQCAtMTE0LDYgKzExNCw4IEBA
IHN0YXRpYyBpbnQgc3FsX2NyZWF0ZXN0bXQoc3RydWN0IHVsb2dkX3BsdWdpbnN0YW5jZSAqdXBp
KQogCXJldHVybiAwOwogfQogCitzdGF0aWMgaW50IF9pbml0X2RiKHN0cnVjdCB1bG9nZF9wbHVn
aW5zdGFuY2UgKnVwaSk7CisKIGludCB1bG9nZF9kYl9jb25maWd1cmUoc3RydWN0IHVsb2dkX3Bs
dWdpbnN0YW5jZSAqdXBpLAogCQkJc3RydWN0IHVsb2dkX3BsdWdpbnN0YW5jZV9zdGFjayAqc3Rh
Y2spCiB7CkBAIC0xNjQsNiArMTY2LDggQEAgaW50IHVsb2dkX2RiX3N0YXJ0KHN0cnVjdCB1bG9n
ZF9wbHVnaW5zdGFuY2UgKnVwaSkKIAlpZiAocmV0IDwgMCkKIAkJZGktPmRyaXZlci0+Y2xvc2Vf
ZGIodXBpKTsKIAorCWRpLT5pbnRlcnAgPSAmX2luaXRfZGI7CisKIAlyZXR1cm4gcmV0OwogfQog
CkBAIC0xODEsNyArMTg1LDYgQEAgaW50IHVsb2dkX2RiX3N0b3Aoc3RydWN0IHVsb2dkX3BsdWdp
bnN0YW5jZSAqdXBpKQogCXJldHVybiAwOwogfQogCi1zdGF0aWMgaW50IF9pbml0X2RiKHN0cnVj
dCB1bG9nZF9wbHVnaW5zdGFuY2UgKnVwaSk7CiAKIHN0YXRpYyBpbnQgX2luaXRfcmVjb25uZWN0
KHN0cnVjdCB1bG9nZF9wbHVnaW5zdGFuY2UgKnVwaSkKIHsKLS0gCjEuNS4yLjUKCg==


--=-fRHhCP2jo3UwOzD7GNZ+--

--=-wcndSpKOSQzQYCII6fZl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHh+wrnxA7CdMWjzIRAprSAJ9JZCWP6XVoY8j+05dm7wjdB/CqggCghzEH
O9ncwi1nTACq/m5Z4YurjcA=
=6uBJ
-----END PGP SIGNATURE-----

--=-wcndSpKOSQzQYCII6fZl--

