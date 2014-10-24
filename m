From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: [PATCH] libipset: Bump lib version and update map file
Date: Fri, 24 Oct 2014 16:36:22 +0700
Message-ID: <20141024093622.GA5771@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Cc: kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:50990 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaJXJg1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:36:27 -0400
Received: by mail-pd0-f171.google.com with SMTP id r10so1167989pdi.16
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2014 02:36:27 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The ipset_parse_uint16() was introduced but no lib version bumped and
no map file updated.

Bump lib version to 9:0:6. (current and age was bumped)

Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
---
 Make_global.am   | 2 +-
 lib/libipset.map | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/Make_global.am b/Make_global.am
index 7953451..f9ec7b2 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -69,7 +69,7 @@
 # interface.=20
=20
 #            curr:rev:age
-LIBVERSION =3D 8:0:5
+LIBVERSION =3D 9:0:6
=20
 AM_CPPFLAGS =3D $(kinclude_CFLAGS) $(all_includes) -I$(top_srcdir)/include=
 \
 	-I/usr/local/include
diff --git a/lib/libipset.map b/lib/libipset.map
index 58174ec..61f6d6e 100644
--- a/lib/libipset.map
+++ b/lib/libipset.map
@@ -152,3 +152,8 @@ global:
   ipset_print_skbmark;
   ipset_print_skbprio;
 } LIBIPSET_4.2;
+
+LIBIPSET_4.4 {
+global:
+  ipset_parse_uint16;
+} LIBIPSET_4.3;
--=20
2.1.1


--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJUSh2WAAoJEJ0EcL2mzcRX394P/0tkfMRN5GehNMEpuihKfLlE
q0UQjSV5F9JuSMhvk/TKz2TykRuOORS+odkf3U+/SaNQaRl9clZVCMowagkz9/fz
F3p2qusnAOzPVFEVEk9jkvUHpAiUpqdqJW8BaYS8P24/CSQhBSBrCEnaQdYSZIek
jQZh3VLUoCt/eQGFtN6nRo/+N/8XsHTmEB93BDLXFqevvDeyhLr1nb9yCGyoI1fM
HoOaLUTFjymk3hq8Vewi4j1X2uYtdIwp+GCeqg1O2olY4L+OSWXYyJf36ltPYvvS
DA532epM/gAxbS447rQ6zUsS3Mab9X6Iw7tco5roSEcUsXHBVq86W/vegPpu2TfT
Equpk1bl70Xw1GuVkV/YnXNMEzBgCzs6yN/1aa0SI9jOMu1syyvjHxjieF4nDk9o
yw3shHv2SMXjshXOAnIfv/eOK/Sq1LVbAFoxj1JM084kOdv/N3baYWRepQCaNya+
2MHVLtFE5YMs/HqEs+lBxnk3EKJ7kiiZeuEsIMO4l1SMLjqjEtHMUoEkpN3FoTmk
WIlvpmRCbJnjMZjOFL38tDEccjxzEdeZEM+erTDc+1E+gRi3fOSd4pVOv7zs6/Fw
syMwjLIOlXUI9Kbew6K5QFBLgSJCgXSfwQhWx5DUG1tfOXszL2ZfNtBTHnoW7wdm
IbE8HRZ9mHJ7WOBV3Fbq
=1Tks
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
