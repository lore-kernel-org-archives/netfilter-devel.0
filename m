From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4+2.6] ip_conntrack_tftp: explanatory DEBUGP statements
Date: Wed, 7 Apr 2004 11:19:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040407091941.GM27556@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m+utxuhC6KVTvgNz"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--m+utxuhC6KVTvgNz
Content-Type: multipart/mixed; boundary="XRwESHC7KXlqFpSs"
Content-Disposition: inline


--XRwESHC7KXlqFpSs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Please apply the following (cosmetic) patch, adding more debug information
to the tftp helper.  As you can figure, this is nothing important at
all.

Patch applies cleanly to 2.4.x and 2.6.x.

Thanks a lot,

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--XRwESHC7KXlqFpSs
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: Received: from ganesha.gnumonks.org ([unix socket])
	by ganesha (Cyrus v2.1.15-IPv6-Debian-2.1.15-0woody.1.0) with LMTP; Sat, 03 Apr 2004 11:01:30 +0200
X-Sieve: CMU Sieve 2.2
Return-path: <extreme@zayanionline.com>
Received: from vishnu.netfilter.org ([213.95.27.115])
	by ganesha.gnumonks.org with esmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.30)
	id 1B9h1u-0008Fs-1S
	for laforge@gnumonks.org; Sat, 03 Apr 2004 11:01:30 +0200
Received: from [168.187.148.211] (helo=sillypoint.zayanionline.com)
	by vishnu.netfilter.org with esmtp (Exim 4.22 #1 (Debian))
	id 1B9h1m-0008Lm-Bo; Sat, 03 Apr 2004 11:01:23 +0200
Received: from [192.0.0.5] ([192.0.0.5])
	by sillypoint.zayanionline.com (8.12.8/8.12.8) with ESMTP id i338uecl032522;
	Sat, 3 Apr 2004 11:56:42 +0300
Date: Sat, 3 Apr 2004 11:56:40 +0300 (AST)
From: Vineet Mehta <extreme@zayanionline.com>
To: Harald Welte <laforge@netfilter.org>
cc: netfilter devel <netfilter-devel@lists.netfilter.org>
Subject: ip_conntrack_tftp: added explanatory DEBUGP statements
Message-ID: <Pine.LNX.4.44.0404031142250.32495-200000@sillypoint.zayanionline.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1146563692-464064345-1080982600=:32495"
X-Spam-Score: 0.0 (/)
X-Spam-Score: -4.9 (----)

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1146563692-464064345-1080982600=:32495
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi all,

This patch makes TFTP Conntrack module (ip_conntrack_tftp.c) to understand 
more Opcodes then the previous READ/WRITE. This is then used in DEBUGP 
statements, to make output more informative.

Thanks and Regards,
Extreme

---1146563692-464064345-1080982600=:32495
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="ip_conntrack_tftp-2.4.25.diff"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0404031156400.32495@sillypoint.zayanionline.com>
Content-Description: 
Content-Disposition: attachment; filename="ip_conntrack_tftp-2.4.25.diff"

ZGlmZiAtTnVyIHBhdGNoZWQtMi40LjI1L2luY2x1ZGUvbGludXgvbmV0Zmls
dGVyX2lwdjQvaXBfY29ubnRyYWNrX3RmdHAuaCBsaW51eC0yLjQuMjUvaW5j
bHVkZS9saW51eC9uZXRmaWx0ZXJfaXB2NC9pcF9jb25udHJhY2tfdGZ0cC5o
DQotLS0gcGF0Y2hlZC0yLjQuMjUvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJf
aXB2NC9pcF9jb25udHJhY2tfdGZ0cC5oCTIwMDMtMDYtMTMgMTc6NTE6Mzgu
MDAwMDAwMDAwICswMzAwDQorKysgbGludXgtMi40LjI1L2luY2x1ZGUvbGlu
dXgvbmV0ZmlsdGVyX2lwdjQvaXBfY29ubnRyYWNrX3RmdHAuaAkyMDA0LTA0
LTAzIDEwOjEwOjQ2LjAwMDAwMDAwMCArMDMwMA0KQEAgLTksNSArOSw4IEBA
DQogDQogI2RlZmluZSBURlRQX09QQ09ERV9SRUFECTENCiAjZGVmaW5lIFRG
VFBfT1BDT0RFX1dSSVRFCTINCisjZGVmaW5lIFRGVFBfT1BDT0RFX0RBVEEJ
Mw0KKyNkZWZpbmUgVEZUUF9PUENPREVfQUNLCQk0DQorI2RlZmluZSBURlRQ
X09QQ09ERV9FUlJPUgk1DQogDQogI2VuZGlmIC8qIF9JUF9DVF9URlRQICov
DQpkaWZmIC1OdXIgcGF0Y2hlZC0yLjQuMjUvbmV0L2lwdjQvbmV0ZmlsdGVy
L2lwX2Nvbm50cmFja190ZnRwLmMgbGludXgtMi40LjI1L25ldC9pcHY0L25l
dGZpbHRlci9pcF9jb25udHJhY2tfdGZ0cC5jDQotLS0gcGF0Y2hlZC0yLjQu
MjUvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX2Nvbm50cmFja190ZnRwLmMJMjAw
NC0wMi0xOCAxNjozNjozMi4wMDAwMDAwMDAgKzAzMDANCisrKyBsaW51eC0y
LjQuMjUvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX2Nvbm50cmFja190ZnRwLmMJ
MjAwNC0wNC0wMyAxMDoxMzowOC4wMDAwMDAwMDAgKzAzMDANCkBAIC02NCw2
ICs2NCwxMyBAQA0KIAkJRFVNUF9UVVBMRSgmZXhwLm1hc2spOw0KIAkJaXBf
Y29ubnRyYWNrX2V4cGVjdF9yZWxhdGVkKGN0LCAmZXhwKTsNCiAJCWJyZWFr
Ow0KKwljYXNlIFRGVFBfT1BDT0RFX0RBVEE6DQorCWNhc2UgVEZUUF9PUENP
REVfQUNLOg0KKwkJREVCVUdQKCJEYXRhL0FDSyBvcGNvZGVcbiIpOw0KKwkJ
YnJlYWs7DQorCWNhc2UgVEZUUF9PUENPREVfRVJST1I6DQorCQlERUJVR1Ao
IkVycm9yIG9wY29kZVxuIik7DQorCQlicmVhazsNCiAJZGVmYXVsdDoNCiAJ
CURFQlVHUCgiVW5rbm93biBvcGNvZGVcbiIpOw0KIAl9DQo=
---1146563692-464064345-1080982600=:32495--

--XRwESHC7KXlqFpSs--

--m+utxuhC6KVTvgNz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAc8etXaXGVTD0i/8RAj4CAJ9yZBi5QkIjLVy2ozcSxcAR7PqGCACeIayy
UxiP2ejwpRMoOMzlUX4P940=
=43X8
-----END PGP SIGNATURE-----

--m+utxuhC6KVTvgNz--
