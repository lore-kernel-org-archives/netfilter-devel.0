From: Peter Volkov <pva@gentoo.org>
Subject: Some iptables-1.4.3 issues (was: Release of iptables-1.4.3)
Date: Tue, 24 Mar 2009 11:09:16 +0300
Message-ID: <1237882157.9988.2533.camel@localhost>
References: <49C79C90.80804@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-v2vaeY09u4kIUqLQSOnb"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:60959 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088AbZCXIJh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:09:37 -0400
In-Reply-To: <49C79C90.80804@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-v2vaeY09u4kIUqLQSOnb
Content-Type: multipart/mixed; boundary="=-991dRvM2b/vKk1dXk9dE"


--=-991dRvM2b/vKk1dXk9dE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi, Patrick. Thank you for new itpables release. There are some issues I
experience with it:

1. build fails:

if i686-pc-linux-gnu-gcc -DHAVE_CONFIG_H -I. -I. -I.    -D_LARGEFILE_SOURCE=
=3D1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=3D64     -D_REENTRANT -Wall -Waggre=
gate-return -Wmissing-declarations     -Wmissing-prototypes -Wredundant-dec=
ls -Wshadow -Wstrict-prototypes     -Winline -pipe   -DXTABLES_LIBDIR=3D\"/=
lib/xtables\" -DXTABLES_INTERNAL -I./include -I./include -I no/include -I n=
o/include -DIPTABLES_MULTI -DNO_SHARED_LIBS=3D1 -O2 -march=3Di686 -pipe -mt=
une=3Di686 -march=3Dpentium-m -ggdb -U_FORTIFY_SOURCE -MT iptables_static-x=
tables.o -MD -MP -MF ".deps/iptables_static-xtables.Tpo" -c -o iptables_sta=
tic-xtables.o `test -f 'xtables.c' || echo './'`xtables.c; \
        then mv -f ".deps/iptables_static-xtables.Tpo" ".deps/iptables_stat=
ic-xtables.Po"; else rm -f ".deps/iptables_static-xtables.Tpo"; exit 1; fi
xtables.c: In function 'xtables_find_target':
xtables.c:641: error: 'LOAD_MUST_SUCCEED' undeclared (first use in this fun=
ction)

The following simple sed fixes this issue:
sed -e 's:\<\(LOAD_MUST_SUCCEED\)\>:XTF_\1:' -i xtables.c

2. build fails with --as-needed. Patch in attachment
(iptables-1.4.3--as-needed.patch) fixes this issue.

3. http://bugzilla.netfilter.org/show_bug.cgi?id=3D568 is still there,
although proposed patch fixes the issue.

Could you apply this changes?

--=20
Peter.

--=-991dRvM2b/vKk1dXk9dE
Content-Disposition: attachment; filename="iptables-1.4.3--as-needed.patch"
Content-Type: text/x-patch; name="iptables-1.4.3--as-needed.patch"; charset="UTF-8"
Content-Transfer-Encoding: base64

PT09IG1vZGlmaWVkIGZpbGUgJ01ha2VmaWxlLmFtJw0KLS0tIE1ha2VmaWxlLmFtCTIwMDktMDMt
MjMgMjA6MzY6MTIgKzAwMDANCisrKyBNYWtlZmlsZS5hbQkyMDA5LTAzLTIzIDIwOjM3OjA1ICsw
MDAwDQpAQCAtMjYsNyArMjYsNyBAQA0KICMgaXB0YWJsZXMsIGR5bmFtaWMNCiBpcHRhYmxlc19T
T1VSQ0VTICAgICAgICAgID0gaXB0YWJsZXMtc3RhbmRhbG9uZS5jIGlwdGFibGVzLmMNCiBpcHRh
Ymxlc19MREZMQUdTICAgICAgICAgID0gLXJkeW5hbWljDQotaXB0YWJsZXNfTERBREQgICAgICAg
ICAgICA9IC1sbSBsaWJpcHRjL2xpYmlwdGMubGEgZXh0ZW5zaW9ucy9saWJleHQ0LmEgbGlieHRh
Ymxlcy5sYQ0KK2lwdGFibGVzX0xEQUREICAgICAgICAgICAgPSBsaWJpcHRjL2xpYmlwdGMubGEg
ZXh0ZW5zaW9ucy9saWJleHQ0LmEgbGlieHRhYmxlcy5sYSAtbG0NCiANCiBpcHRhYmxlc194bWxf
TERBREQgICAgICAgID0gbGlieHRhYmxlcy5sYQ0KIGlwdGFibGVzX211bHRpX1NPVVJDRVMgICAg
PSBpcHRhYmxlcy1tdWx0aS5jIGlwdGFibGVzLXNhdmUuYyBcDQpAQCAtNDcsMTQgKzQ3LDE0IEBA
DQogIyBpcHRhYmxlcy1tdWx0aSwgc2VtaS1zdGF0aWMNCiBpcHRhYmxlc19zdGF0aWNfU09VUkNF
UyAgID0gJHtpcHRhYmxlc19tdWx0aV9TT1VSQ0VTfSB4dGFibGVzLmMNCiBpcHRhYmxlc19zdGF0
aWNfQ0ZMQUdTICAgID0gJHtpcHRhYmxlc19tdWx0aV9DRkxBR1N9IC1ETk9fU0hBUkVEX0xJQlM9
MQ0KLWlwdGFibGVzX3N0YXRpY19MREFERCAgICAgPSAtbG0gbGliaXB0Yy9saWJpcHRjLmxhIGV4
dGVuc2lvbnMvbGliZXh0NC5hDQoraXB0YWJsZXNfc3RhdGljX0xEQUREICAgICA9IGxpYmlwdGMv
bGliaXB0Yy5sYSBleHRlbnNpb25zL2xpYmV4dDQuYSAtbG0NCiANCiBpcHRhYmxlc194bWxfU09V
UkNFUyAgICAgID0gaXB0YWJsZXMteG1sLmMNCiANCiAjIGlwNnRhYmxlcywgZHluYW1pYw0KIGlw
NnRhYmxlc19TT1VSQ0VTICAgICAgICAgPSBpcDZ0YWJsZXMtc3RhbmRhbG9uZS5jIGlwNnRhYmxl
cy5jDQogaXA2dGFibGVzX0xERkxBR1MgICAgICAgICA9IC1yZHluYW1pYw0KLWlwNnRhYmxlc19M
REFERCAgICAgICAgICAgPSAtbG0gbGliaXB0Yy9saWJpcHRjLmxhIGV4dGVuc2lvbnMvbGliZXh0
Ni5hIGxpYnh0YWJsZXMubGENCitpcDZ0YWJsZXNfTERBREQgICAgICAgICAgID0gbGliaXB0Yy9s
aWJpcHRjLmxhIGV4dGVuc2lvbnMvbGliZXh0Ni5hIGxpYnh0YWJsZXMubGEgLWxtDQogDQogaXA2
dGFibGVzX211bHRpX1NPVVJDRVMgICA9IGlwNnRhYmxlcy1tdWx0aS5jIGlwNnRhYmxlcy1zYXZl
LmMgXA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpcDZ0YWJsZXMtcmVzdG9yZS5jIGlw
NnRhYmxlcy1zdGFuZGFsb25lLmMgXA0KQEAgLTc0LDcgKzc0LDcgQEANCiAjIGlwdGFibGVzLW11
bHRpLCBzZW1pLXN0YXRpYw0KIGlwNnRhYmxlc19zdGF0aWNfU09VUkNFUyAgICA9ICR7aXA2dGFi
bGVzX211bHRpX1NPVVJDRVN9IHh0YWJsZXMuYw0KIGlwNnRhYmxlc19zdGF0aWNfQ0ZMQUdTICAg
ICA9ICR7aXA2dGFibGVzX211bHRpX0NGTEFHU30gLUROT19TSEFSRURfTElCUz0xDQotaXA2dGFi
bGVzX3N0YXRpY19MREFERCAgICAgID0gLWxtIGxpYmlwdGMvbGliaXB0Yy5sYSBleHRlbnNpb25z
L2xpYmV4dDYuYQ0KK2lwNnRhYmxlc19zdGF0aWNfTERBREQgICAgICA9IGxpYmlwdGMvbGliaXB0
Yy5sYSBleHRlbnNpb25zL2xpYmV4dDYuYSAtbG0NCiANCiBiaW5fUFJPR1JBTVMgICAgID0gaXB0
YWJsZXMteG1sDQogc2Jpbl9QUk9HUkFNUyAgICA9DQoNCg==


--=-991dRvM2b/vKk1dXk9dE--

--=-v2vaeY09u4kIUqLQSOnb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAknIlSwACgkQz6tlgEWSarNtUwCfXlP6Z4ia9v3z7sUyzQRfgCon
VdsAn1AgE6nxJgX7QoKoPhUhQxEdWf+m
=qte/
-----END PGP SIGNATURE-----

--=-v2vaeY09u4kIUqLQSOnb--

