From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] hashlimit: trivial fix for bug introduced by hlist change
Date: Sun, 27 Mar 2005 11:28:49 +0200
Message-ID: <20050327092849.GZ18694@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4jz2RIiWkXBLiaBi"
Cc: jix@bugmachine.ca,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: David Miller <davem@davemloft.net>
Content-Disposition: inline
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


--4jz2RIiWkXBLiaBi
Content-Type: multipart/mixed; boundary="p+IlF8Xh9KY56wTg"
Content-Disposition: inline


--p+IlF8Xh9KY56wTg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Please apply the following fix to ipt_hashlimit.=20

Thanks,

Signed-off-by: Harald Welte <laforge@netfilter.org>

(No signed-off-by by original author, but at least from a legal point
there is no need, since trivial bugfixes don't even constitute a
copyrightable work)

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--p+IlF8Xh9KY56wTg
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: Received: from ganesha.gnumonks.org ([unix socket])
	by ganesha (Cyrus v2.1.17-IPv6-Debian-2.1.17-0woody.3.1) with LMTP;
	Sun, 27 Mar 2005 01:52:28 +0100
X-Sieve: CMU Sieve 2.2
Return-path: <jix@bugmachine.ca>
Received: from vishnu.netfilter.org ([213.95.27.115])
	by ganesha.gnumonks.org with esmtp
	(TLS-1.0:DHE_RSA_3DES_EDE_CBC_SHA:24) (Exim 4.34) id 1DFM0y-0002IT-GW
	for laforge@gnumonks.org; Sun, 27 Mar 2005 01:52:28 +0100
Received: from noc.routermonkey.net ([66.11.160.134])
	by vishnu.netfilter.org with esmtp (Exim 4.41 #1 (Debian))
	id 1DFM3t-0002zS-L9; Sun, 27 Mar 2005 01:55:31 +0100
Received: from bugmachine.ca (toxic.bug.qc.ca [192.168.3.10]) by
	noc.routermonkey.net (8.9.3/UW7.1.1) with SMTP id UAA20839;
	Sat, 26 Mar 2005 20:52:22 -0400 (GMT-0400)
Date: Sun, 27 Mar 2005 00:52:22 -0000
To: <laforge@netfilter.org>
Subject: [PATCH] IMPORTANT: trivial fix for bug introduced by hlist change
From: "Samuel Jean" <jix@bugmachine.ca>
X-Mailer: TWIG 2.7.7
Message-ID: <twig.1111884742.85179@bugmachine.ca>
X-Client-IP: 192.168.3.69
Cc: <kaber@trash.net>, <netfilter-devel@lists.netfilter.org>
Reply-To: jix@bugmachine.ca
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="--------part424603c6ca3fc"
X-Spam-Score: -2.6 (--)
X-Spam-Score: -1.1 (-)

This is a multi-part message in MIME format.

----------part424603c6ca3fc
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Harald,

I've introduced a really annoying bug with the hlist change.. *sigh*
__dsthash_find() will return junk as soon as there's something in the bucket.

Patch's attached.

Sorry for the inconveniant, please apply ASAP.


----------part424603c6ca3fc
Content-Type: application/octet-stream; name="hashlimit-corrupt.patch"
Content-Transfer-Encoding: base64

LS0tIGEvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9oYXNobGltaXQuYwkyMDA1LTAzLTI2IDE5OjMz
OjA2LjAwMDAwMDAwMCAtMDUwMAorKysgYi9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X2hhc2hsaW1p
dC5jCTIwMDUtMDMtMjYgMTk6Mzg6MjYuMDAwMDAwMDAwIC0wNTAwCkBAIC0xMTYsMTggKzExNiwx
OCBAQCBoYXNoX2RzdChjb25zdCBzdHJ1Y3QgaXB0X2hhc2hsaW1pdF9odGFiCiBzdGF0aWMgaW5s
aW5lIHN0cnVjdCBkc3RoYXNoX2VudCAqCiBfX2RzdGhhc2hfZmluZChjb25zdCBzdHJ1Y3QgaXB0
X2hhc2hsaW1pdF9odGFibGUgKmh0LCBzdHJ1Y3QgZHN0aGFzaF9kc3QgKmRzdCkKIHsKLQlzdHJ1
Y3QgZHN0aGFzaF9lbnQgKmVudCA9IE5VTEw7CisJc3RydWN0IGRzdGhhc2hfZW50ICplbnQ7CiAJ
c3RydWN0IGhsaXN0X25vZGUgKnBvczsKIAl1X2ludDMyX3QgaGFzaCA9IGhhc2hfZHN0KGh0LCBk
c3QpOwogCiAJaWYgKCFobGlzdF9lbXB0eSgmaHQtPmhhc2hbaGFzaF0pKQogCQlobGlzdF9mb3Jf
ZWFjaF9lbnRyeShlbnQsIHBvcywgJmh0LT5oYXNoW2hhc2hdLCBub2RlKSB7CiAJCQlpZiAoZHN0
X2NtcChlbnQsIGRzdCkpIHsKLQkJCQlicmVhazsKKwkJCQlyZXR1cm4gZW50OwogCQkJfQogCQl9
CiAJCi0JcmV0dXJuIGVudDsKKwlyZXR1cm4gTlVMTDsKIH0KIAogLyogYWxsb2NhdGUgZHN0aGFz
aF9lbnQsIGluaXRpYWxpemUgZHN0LCBwdXQgaW4gaHRhYmxlIGFuZCBsb2NrIGl0ICovCg==

----------part424603c6ca3fc--




--p+IlF8Xh9KY56wTg--

--4jz2RIiWkXBLiaBi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCRnzRXaXGVTD0i/8RAsCKAJ49TkGBGMiVi5rRcacI3U5JkuA9IwCfUVLz
4UlOiWt+CnyQDXoDIRTtyo8=
=q1gR
-----END PGP SIGNATURE-----

--4jz2RIiWkXBLiaBi--
