From: Peter Volkov <pva@gentoo.org>
Subject: [patch] arptables: some patches from debian
Date: Sat, 09 Oct 2010 17:17:29 +0400
Message-ID: <1286630249.3611.514.camel@tablet>
References: <1284558534.22085.164.camel@tablet>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-c4zcYOKG3W1X+/+7XcxZ"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: ebtables-devel@lists.sourceforge.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:45749 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab0JINRz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Oct 2010 09:17:55 -0400
In-Reply-To: <1284558534.22085.164.camel@tablet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-c4zcYOKG3W1X+/+7XcxZ
Content-Type: multipart/mixed; boundary="=-dFCnLdaKxR8JuCc5NiW0"


--=-dFCnLdaKxR8JuCc5NiW0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi again. What is the best way to contact arptables developers? My
previous patch was left without attention, should I resend it? In
attachment there are three fixes from debian:

1. arptables_save patch makes arp_tables don't resolve host names and
don't convert '*' interface names to any. Remove '*' interface names.
2. manpage patch removes old version from man page
3. is a patch from Jeroen van Wolffelaar to make arptables --proto-type
also accept hexadecimal inputs (ethernet protocol numbers are often
specfied in hex, not decimal), using standard strtol() behaviour (hex
iff starts with 0x).

Please, apply.
--=20
Peter.

--=-dFCnLdaKxR8JuCc5NiW0
Content-Disposition: attachment; filename="arptables-0.0.3.4-arptables_save.patch"
Content-Type: text/x-patch; name="arptables-0.0.3.4-arptables_save.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

IyBEb24ndCByZXNvbHZlIGhvc3QgbmFtZXMgYW5kIGRvbid0IGNvbnZlcnQgJyonIGludGVyZmFj
ZSBuYW1lcyB0byBhbnkuDQojIFJlbW92ZSAnKicgaW50ZXJmYWNlIG5hbWVzLg0KDQpkaWZmIC11
ck5hZCBhcnB0YWJsZXMtMC4wLjMuM34vYXJwdGFibGVzLXNhdmUgYXJwdGFibGVzLTAuMC4zLjMv
YXJwdGFibGVzLXNhdmUNCi0tLSBhcnB0YWJsZXMtMC4wLjMuM34vYXJwdGFibGVzLXNhdmUJMjAw
OS0wOC0xOSAxNDoxNzoxNy4wMDAwMDAwMDAgKzAyMDANCisrKyBhcnB0YWJsZXMtMC4wLjMuMy9h
cnB0YWJsZXMtc2F2ZQkyMDA5LTA4LTE5IDE0OjE5OjU4LjAwMDAwMDAwMCArMDIwMA0KQEAgLTM1
LDYgKzM1LDggQEANCiAJIyBEdWUgdG8gYXJwdGFibGVzICJpc3N1ZXMiIHdpdGggZGlzcGxheWlu
ZyBkZXZpY2UgbmFtZXMNCiAgICAgICAgICMgd2UgbmVlZCB0byB1c2UgLXYgYW5kIHRoZW4gZG8g
c29tZSBwcm9jZXNzaW5nDQogCSRsaW5lID1+IHMvXHMsXHMuKi8vOw0KKwkkbGluZSA9fiBzLy1p
XHNcKi8vOw0KKwkkbGluZSA9fiBzLy1vXHNcKi8vOw0KICAgICAgICAgJHJ1bGVzID0gJHJ1bGVz
IC4gIi1BICRjaGFpbiAkbGluZVxuIjsNCiAgICAgfQ0KIA0KQEAgLTQ3LDcgKzQ5LDcgQEANCiAj
ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
DQogDQogdW5sZXNzICgteCAiJHRvb2wiKSB7IHByaW50ICJFUlJPUjogVG9vbCAkdG9vbCBpc24n
dCBleGVjdXRhYmxlIjsgZXhpdCAtMTsgfTsNCi0kdGFibGUgPWAkdG9vbCAtdCBmaWx0ZXIgLUwg
LXZgOw0KKyR0YWJsZSA9YCR0b29sIC10IGZpbHRlciAtTCAtdiAtbmA7DQogdW5sZXNzICgkPyA9
PSAwKSB7IHByaW50ICR0YWJsZTsgZXhpdCAtMSB9Ow0KICZwcm9jZXNzX3RhYmxlKCR0YWJsZSk7
DQogDQo=


--=-dFCnLdaKxR8JuCc5NiW0
Content-Disposition: attachment; filename="arptables-0.0.3.4-manpage.patch"
Content-Type: text/x-patch; name="arptables-0.0.3.4-manpage.patch"; charset="UTF-8"
Content-Transfer-Encoding: base64

ZGlmZiAtdXJOYWQgYXJwdGFibGVzLTAuMC4zLjN+L2FycHRhYmxlcy44IGFycHRhYmxlcy0wLjAu
My4zL2FycHRhYmxlcy44DQotLS0gYXJwdGFibGVzLTAuMC4zLjN+L2FycHRhYmxlcy44CTIwMDct
MDgtMTkgMTU6MDQ6NTEuMDAwMDAwMDAwICswMjAwDQorKysgYXJwdGFibGVzLTAuMC4zLjMvYXJw
dGFibGVzLjgJMjAwOC0wNS0wOCAxODo1NjozNS4wMDAwMDAwMDAgKzAyMDANCkBAIC0yMiw3ICsy
Miw3IEBADQogLlwiDQogLlwiDQogLlNIIE5BTUUNCi1hcnB0YWJsZXMgKHYuMC4wLjMtMykgXC0g
QVJQIHRhYmxlIGFkbWluaXN0cmF0aW9uDQorYXJwdGFibGVzIFwtIEFSUCB0YWJsZSBhZG1pbmlz
dHJhdGlvbg0KIC5TSCBTWU5PUFNJUw0KIC5CUiAiYXJwdGFibGVzICIgWyAiLXQgdGFibGUiIF0g
IiAtIiBbIEFEIF0gIiBjaGFpbiBydWxlLXNwZWNpZmljYXRpb24gIiBbIG9wdGlvbnMgXQ0KIC5i
cg0K


--=-dFCnLdaKxR8JuCc5NiW0
Content-Disposition: attachment; filename="arptables-0.0.3.4-type.patch"
Content-Type: text/x-patch; name="arptables-0.0.3.4-type.patch"; charset="UTF-8"
Content-Transfer-Encoding: base64

IyBQYXRjaCBmcm9tIEplcm9lbiB2YW4gV29sZmZlbGFhciA8amVyb2VuQHdvbGZmZWxhYXIubmw+
IHRvIG1ha2UNCiMgYXJwdGFibGVzIC0tcHJvdG8tdHlwZSBhbHNvIGFjY2VwdCBoZXhhZGVjaW1h
bCBpbnB1dHMgKGV0aGVybmV0IHByb3RvY29sDQojIG51bWJlcnMgYXJlIG9mdGVuIHNwZWNmaWVk
IGluIGhleCwgbm90IGRlY2ltYWwpLCB1c2luZyBzdGFuZGFyZCBzdHJ0b2woKQ0KIyBiZWhhdmlv
dXIgKGhleCBpZmYgc3RhcnRzIHdpdGggMHgpLg0KDQpkaWZmIC11ck5hZCBhcnB0YWJsZXMtMC4w
LjMuM34vYXJwdGFibGVzLmMgYXJwdGFibGVzLTAuMC4zLjMvYXJwdGFibGVzLmMNCi0tLSBhcnB0
YWJsZXMtMC4wLjMuM34vYXJwdGFibGVzLmMJMjAwNy0wOC0xOSAxNTowNDo1MS4wMDAwMDAwMDAg
KzAyMDANCisrKyBhcnB0YWJsZXMtMC4wLjMuMy9hcnB0YWJsZXMuYwkyMDA4LTA1LTA4IDE5OjE2
OjQzLjAwMDAwMDAwMCArMDIwMA0KQEAgLTIwMzksNyArMjAzOSw3IEBADQogCQkJY2hlY2tfaW52
ZXJzZShvcHRhcmcsICZpbnZlcnQsICZvcHRpbmQsIGFyZ2MpOw0KIAkJCXNldF9vcHRpb24oJm9w
dGlvbnMsIE9QVF9QX1RZUEUsICZmdy5hcnAuaW52ZmxhZ3MsDQogCQkJCSAgIGludmVydCk7DQot
CQkJaWYgKGdldDE2X2FuZF9tYXNrKGFyZ3Zbb3B0aW5kIC0gMV0sICZmdy5hcnAuYXJwcm8sICZm
dy5hcnAuYXJwcm9fbWFzaywgMTApKSB7DQorCQkJaWYgKGdldDE2X2FuZF9tYXNrKGFyZ3Zbb3B0
aW5kIC0gMV0sICZmdy5hcnAuYXJwcm8sICZmdy5hcnAuYXJwcm9fbWFzaywgMCkpIHsNCiAJCQkJ
aWYgKHN0cmNhc2VjbXAoYXJndltvcHRpbmQtMV0sICJpcHY0IikpDQogCQkJCQlleGl0X2Vycm9y
KFBBUkFNRVRFUl9QUk9CTEVNLCAiUHJvYmxlbSB3aXRoIHNwZWNpZmllZCBwcm90b2NvbCB0eXBl
Iik7DQogCQkJCWZ3LmFycC5hcnBybyA9IGh0b25zKDB4ODAwKTsNCg==


--=-dFCnLdaKxR8JuCc5NiW0--

--=-c4zcYOKG3W1X+/+7XcxZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAkywa2kACgkQz6tlgEWSarPDTgCfYuIphVrGF9U6IezZvvA43txs
S6MAn11vYe/u+TiAKpNLi3s4QwbvxV7Y
=MtMl
-----END PGP SIGNATURE-----

--=-c4zcYOKG3W1X+/+7XcxZ--

