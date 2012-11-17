From: Tom Eastep <teastep@shorewall.net>
Subject: [PATCH] Correct libxt_statistic save output
Date: Sat, 17 Nov 2012 14:05:59 -0800
Message-ID: <50A80A47.6010700@shorewall.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigECFB2DB77728AA5A6662EE4D"
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lists.shorewall.net ([70.90.191.124]:41620 "EHLO
	lists.shorewall.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab2KQWM1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Nov 2012 17:12:27 -0500
Received: from mac.shorewall.net (unknown [IPv6:2001:470:b:787:3c80:7eaa:7175:ac9f])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by lists.shorewall.net (Postfix) with ESMTPSA id 2E17E64E051
	for <netfilter-devel@vger.kernel.org>; Sat, 17 Nov 2012 14:06:08 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigECFB2DB77728AA5A6662EE4D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Suppressing '--packet 0' in save output resulted in restore failure.

This patch includes '--packet 0' in save output while continuing to
suppress it in print output.
---
 extensions/libxt_statistic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index 12a83dd..3a6632d 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -107,7 +107,7 @@ static void print_match(const struct
xt_statistic_info *info, char *prefix)
 		       (info->flags & XT_STATISTIC_INVERT) ? " !" : "",
 		       prefix,
 		       info->u.nth.every + 1);
-		if (info->u.nth.packet)
+		if (info->u.nth.packet || *prefix )
 			printf(" %spacket %u", prefix, info->u.nth.packet);
 		break;
 	}
--=20
1.7.2.5

--=20
Tom Eastep        \ When I die, I want to go like my Grandfather who
Shoreline,         \ died peacefully in his sleep. Not screaming like
Washington, USA     \ all of the passengers in his car
http://shorewall.net \________________________________________________


--------------enigECFB2DB77728AA5A6662EE4D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlCoCk4ACgkQO/MAbZfjDLLjiwCgtb5BvCHBDxEBhfFWoc4rs/pl
OVEAn1/51yOK+if+ytVk6Plq4O3wkRfX
=HNcb
-----END PGP SIGNATURE-----

--------------enigECFB2DB77728AA5A6662EE4D--
