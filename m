From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: [PATCH] netfilter: ipset: Fix library interface version
Date: Sat, 26 Oct 2013 15:02:06 +0700
Message-ID: <20131026080206.GA19266@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:65086 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab3JZICO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Oct 2013 04:02:14 -0400
Received: by mail-pd0-f181.google.com with SMTP id x10so261962pdj.26
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2013 01:02:13 -0700 (PDT)
Received: from nitrogen.neutroncom.local ([223.204.62.64])
        by mx.google.com with ESMTPSA id o1sm14395678pbe.37.2013.10.26.01.02.11
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Sat, 26 Oct 2013 01:02:12 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* The library interface version should be 5:0:2 which it will create the
  libipset.so.3.2.0 instead of 4:1:2 which create the libipset.so.2.2.1

Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
---
 Make_global.am   | 2 +-
 lib/libipset.map | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 9c228cc..33645da 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -69,7 +69,7 @@
 # interface.=20
=20
 #            curr:rev:age
-LIBVERSION =3D 4:1:2
+LIBVERSION =3D 5:0:2
=20
 AM_CPPFLAGS =3D $(kinclude_CFLAGS) $(all_includes) -I$(top_srcdir)/include=
 \
 	-I/usr/local/include
diff --git a/lib/libipset.map b/lib/libipset.map
index ab0b96f..b684e82 100644
--- a/lib/libipset.map
+++ b/lib/libipset.map
@@ -128,7 +128,7 @@ global:
   ipset_parse_uint64;
 } LIBIPSET_3.0;
=20
-LIBIPSET_4.1 {
+LIBIPSET_5.0 {
 global:
   ipset_parse_comment;
   ipset_print_comment;
--=20
1.8.4.rc3


--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSa3b+AAoJEJ0EcL2mzcRXPt4P/A6V+uai7w6frGFTii0xVzme
EuOnN+8V303hFV7rPL/Ri2YyRMSq/3uUS+NW/kyzbNl4Z48DqYbA1OuE2J2l7lGp
HwXQKRJA0H1x83M+uVqYrWTU7Z3CnnGr/R6M8A+Yxv0HDMalraEYGkjCBDa/i5Fe
Ayqa2Si2YLH1ebApa161rOd2WmPC8iOMTa5QbojZdULHXZJNFl0/iVMe49NbXWx3
iNnmbZHUmUdgCZZ1oTEoaWt3Kio/U4P/+/mFzBnHiyXY8dzmsfHo5GuxYYFaW2oQ
A/yqvix92HzO5bczGvgoyW6r3LC5W7YK5idS+aUKGGyc2mzXouhISAK0+cn+hyVV
/sMK8wKUvgwmK8/ZuEIwdeJBthKG42kBnRuS3EjpWiEMnjf2B6MNznxA6U9/oRMH
iMtpjdq+A6iulcxlBzf6vjpB4E8DniLFGtwu3p1fyiWpfQ21SU+b4cHIt/gVW6NV
PnFUefhX0x+79MAijiTcG/bO7ezfp7apAu4RAopF+KwCR9LQMdKG8suVrmY2p32u
90ArVEfpOU8RI568QIhTlwPmRyaLzvT9qm9QpldnDnaIuCWiPeoimBX8oStpYGVs
0zcjGdl7GXrU7t+GIiTTarTgvsdyKD55KUJf4KGFJM/V7o1z77v/2mrJrjRyw5bx
gu+qTBrUHaQDFI4TcFau
=tl+J
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
