From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] netfilter: Remove some backward-compat Kconfig symbols
Date: Mon, 30 Dec 2013 00:43:51 +0100
Message-ID: <1388360631.2900.36.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-M3wHBS0+OvmMa6ARZwmL"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58379 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752699Ab3L2XoF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Dec 2013 18:44:05 -0500
Received: from [151.217.234.213] (helo=deadeye.wl.decadent.org.uk)
	by shadbolt.decadent.org.uk with esmtps (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <ben@decadent.org.uk>)
	id 1VxQ1Z-0002F7-FQ
	for netfilter-devel@vger.kernel.org; Sun, 29 Dec 2013 23:44:01 +0000
Received: from ben by deadeye.wl.decadent.org.uk with local (Exim 4.82)
	(envelope-from <ben@decadent.org.uk>)
	id 1VxQ1Y-0002uV-M3
	for netfilter-devel@vger.kernel.org; Mon, 30 Dec 2013 00:44:00 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-M3wHBS0+OvmMa6ARZwmL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Since Linux 3.4 or earlier, CONFIG_IP_NF_MATCH_ECN,
CONFIG_IP_NF_MATCH_TTL, CONFIG_IP_NF_TARGET_TTL have just selected the
xtables replacements for these symbols.  They should not be needed
any more.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/netfilter/Kconfig | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 1657e39b..a6cedb0 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -60,15 +60,6 @@ config IP_NF_MATCH_AH
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
-config IP_NF_MATCH_ECN
-	tristate '"ecn" match support'
-	depends on NETFILTER_ADVANCED
-	select NETFILTER_XT_MATCH_ECN
-	---help---
-	This is a backwards-compat option for the user's convenience
-	(e.g. when running oldconfig). It selects
-	CONFIG_NETFILTER_XT_MATCH_ECN.
-
 config IP_NF_MATCH_RPFILTER
 	tristate '"rpfilter" reverse path filter match support'
 	depends on NETFILTER_ADVANCED && (IP_NF_MANGLE || IP_NF_RAW)
@@ -79,15 +70,6 @@ config IP_NF_MATCH_RPFILTER
 	  To compile it as a module, choose M here.  If unsure, say N.
 	  The module will be called ipt_rpfilter.
=20
-config IP_NF_MATCH_TTL
-	tristate '"ttl" match support'
-	depends on NETFILTER_ADVANCED
-	select NETFILTER_XT_MATCH_HL
-	---help---
-	This is a backwards-compat option for the user's convenience
-	(e.g. when running oldconfig). It selects
-	CONFIG_NETFILTER_XT_MATCH_HL.
-
 # `filter', generic and specific targets
 config IP_NF_FILTER
 	tristate "Packet filtering"
@@ -268,15 +250,6 @@ config IP_NF_TARGET_ECN
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
-config IP_NF_TARGET_TTL
-	tristate '"TTL" target support'
-	depends on NETFILTER_ADVANCED && IP_NF_MANGLE
-	select NETFILTER_XT_TARGET_HL
-	---help---
-	This is a backwards-compatible option for the user's convenience
-	(e.g. when running oldconfig). It selects
-	CONFIG_NETFILTER_XT_TARGET_HL.
-
 # raw + specific targets
 config IP_NF_RAW
 	tristate  'raw table support (required for NOTRACK/TRACE)'

--=20
Ben Hutchings
Logic doesn't apply to the real world. - Marvin Minsky

--=-M3wHBS0+OvmMa6ARZwmL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUsCzt+e/yOyVhhEJAQrDHhAAmqwdCajiPUOoOgWx/YVT5kM2RhMxlCK+
wvLvcHutwH5xVKcYgiJ42S78JD4NyQq2pZr2iIwQuYS1d9Ojg3RqcrdNbzZOHS7e
KV9Omvzb7EgvMpRhmY/Of0IFXSfyzFc+nGOiRt0g7jynKNzIsV5piK9f+H+CtbM5
MnMkCg5uVwkaE0fbBV3NqOBxpdmWSxf1+EfOZrafQ2Rhop+sAhS7LlsA5thU40ls
H1uXMvsJcFIMxHX+q+iguLapnnqV094YCMUXbi2L+11iH+cSRkaLABQfU22UAqk/
zgGmy2d+80ugXc9w16WyJ62OkzYFi3mfSayRVVkDam6h77I0czDFJ8xSoUxaW5Jm
GyuhLExqyyP2cIgDduKIm2i9QFgPGG8cTM6dckI/6vukJRfFiD6bM7ntQrv3g3Fk
XXPn/RarLSmltJvpAbliJ+OqkRgIHkgvGGN5QM7plVKyBo41klMjr/WRkRh5I9CR
mAeGF3liS5a9M2FzwHi7kaQbPvnwon28SZNvnMj8i6atxxW63osFaNl8BsIttinD
GuKlPJxryOEItsBCfSM84RtaZUpt+KtYwmrRswRZ/Dp3tXBtoQbLxxRAoUMj5IrN
5iU4N7qh6ZpdaUr1nG4iKynE0+mycjUiB2/ZMMB24b3ocPEsw8x1qXINQib3bzSG
kkWWawEG8cg=
=8hwl
-----END PGP SIGNATURE-----

--=-M3wHBS0+OvmMa6ARZwmL--
