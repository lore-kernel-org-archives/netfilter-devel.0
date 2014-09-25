From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: [PATCH] ipset: Fix hyphen used as minus sign in manpage
Date: Thu, 25 Sep 2014 14:56:11 +0700
Message-ID: <20140925075611.GA12768@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Cc: kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51998 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaIYH4R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:56:17 -0400
Received: by mail-pa0-f50.google.com with SMTP id lj1so1987286pab.23
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2014 00:56:16 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
---
 src/ipset.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/ipset.8 b/src/ipset.8
index a7bd94f..c923956 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -319,7 +319,7 @@ the above would appear as: "allow access to SMB share o=
n \\\\fileserv\\"
 .SS "skbinfo, skbmark, skbprio, skbqueue"
 All set types support the optional \fBskbinfo\fR extension. This extension=
 allow to
 store the metainfo (firewall mark, tc class and hardware queue) with every=
 entry and map it to
-packets by usage of SET netfilter target with --map-set option.
+packets by usage of SET netfilter target with \-\-map\-set option.
 \fBskbmark\fR option format: \fBMARK\fR or \fBMARK/MASK\fR, where \fBMARK\=
fR and \fBMASK\fR are 32bit hex
 numbers with 0x prefix. If only \fBmark\fR is specified mask 0xffffffff ar=
e used.
 \fBskbprio\fR option has tc class format: \fBMAJOR:MINOR\fR, where \fBmajo=
r\fR and \fBminor\fR numbers
--=20
2.1.0


--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJUI8qbAAoJEJ0EcL2mzcRXz3EQANEhFoIoIbrqBFVSu88mUUlA
4LWjuvM3jWIHwAGps02sy2IgpMhPAM0eoBe4Z8ITdU4G38SWm1z7jFWgzWBESB/F
sh7uzaik4WRFZ2X4yt34ANTcYCSwD/CKlck72esVBX/nIT0SYyr4t0rp1vSVww6i
MIJZwiBEPG5WsZs9CMb8A0VHYVF3KL47UtF7g5MXR1oCD6L84aL0biUcW7FjXMU4
i7oMewyTXMXp1WtxjeNRqDRtd9s12JNjGa33ewCVipEDVwbY0CfPkH+EySvPvgtJ
CxMZEFmkAv/Tjd1EqYcTs5YkBJEquTp7SrkY5ZNA9dMOBDf1MVgQp/5Vef8MjK+G
tWEWqA2aWyxQowUmCNAVdPy4iSIckeb8XF6NvtXPk+zCREcYA0goGVQttrN+Q+GF
9n25ExfMMvDR7Dm5rzO6kme1HHEXl+yK28OV8BKVmcq6hVI9hTD9/eOlsYNI8eEA
+7xTMe0ZeQv+OxGz+D6MTA/GWonjWMxlvl7NOFUeyfBOppffLlFOuIb5k29dr1BV
PU48cwOcVLrv1+yQH1di8XbgtcPjawllbIZOlVvOXwUjzqrIULTDHcLANCUykBtG
Qp9ti5YrE4wmYdMAc4LD2LCBk5DxmLk2E/A9CUGUjJI9rBqK3rzYSItfYHg/bfVJ
UC1YML6Ic6JxA0i/2K/m
=jH+4
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
