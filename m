From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: [PATCH] libipset: Add missing ipset_parse_uint16 to map file
Date: Fri, 17 Oct 2014 11:06:44 +0700
Message-ID: <20141017040644.GA27263@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Cc: kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:52143 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaJQEGu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Oct 2014 00:06:50 -0400
Received: by mail-pd0-f173.google.com with SMTP id g10so37047pdj.4
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2014 21:06:49 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The libipset was not included the ipset_parse_uint16 symbol

Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
---
 lib/libipset.map | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/libipset.map b/lib/libipset.map
index 58174ec..74069dc 100644
--- a/lib/libipset.map
+++ b/lib/libipset.map
@@ -149,6 +149,7 @@ LIBIPSET_4.3 {
 global:
   ipset_parse_skbmark;
   ipset_parse_skbprio;
+  ipset_parse_uint16;
   ipset_print_skbmark;
   ipset_print_skbprio;
 } LIBIPSET_4.2;
--=20
2.1.1


--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJUQJXUAAoJEJ0EcL2mzcRXdE4P/0KTLF61eVbL4lJYMgdCLjbx
ju08QeHTPQYrZGpdt1SvrW1w6dju5t37mDajXEfWd1fMlu0AxKBJIBDOZyKwKDva
sV7PhwS9uuvYQn29KYqozxPyzIIHBWZob9oojHOe/Ud+8vfDbDUuyjaUkuGiHQcS
Zy91P56DddcjksrFqK08O1r17sHy18dW6waQB0PZ3V+LkAOxsU4tBAPcM311SHpo
HdmD+8m3vOboJg+ogAAQtDEnxEPMi7mVK8AZ7x9sP6HwpW/7/mFVsxOiXlX+kMjU
Jr8YkVrmzQzLAMrWDxudiiek02zLWi1J89gpEj61qAOZSJ5rDyC25FamZEPKeKey
vGBkLlVYPGqPgRwZsZjBHDYOHrTawBUMgt476ehN9u1aW27hvX9NnoPQHtwYOLMq
OCBUT85zbEHV/UqajOHsQfUurowvRDk52HeGJ6DyHtM4BFh6c6muuFLWaYKTljYS
b39iIDtybhf9tpuI0cScuAAWF/+saLABvcrzC1zcpK1tyr9uNTnZtGFTFn8US69h
ucgXKdpsfyYRsKZtumHV1a/svp+B7yfF2oro7EYOcUmPQLFsLad149RYLn/BEs5C
v/rYEgGV54e5HffDpABJcwef3H+Sxs4HJGPuT5aw5LtW5C5OiLP4lHa6MYTtZSK0
i2OOv2jTYxsoLM6ARSBb
=P3YT
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
