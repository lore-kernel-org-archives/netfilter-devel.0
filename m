From: Tom Eastep <teastep@shorewall.net>
Subject: PATCH - Fix for --random option in DNAT and REDIRECT
Date: Wed, 14 Nov 2007 13:09:01 -0800
Message-ID: <473B63ED.7020307@shorewall.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig918F2C7BC736E2C607B76100"
To: Netfilter Development <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lists.shorewall.net ([206.124.146.177]:42513 "EHLO
	lists.shorewall.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758297AbXKNVSU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:18:20 -0500
Received: from [192.168.1.3] (wookie.shorewall.net [192.168.1.3])
	by lists.shorewall.net (Postfix) with ESMTP id 41FF517CC27
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Nov 2007 13:09:02 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig918F2C7BC736E2C607B76100
Content-Type: multipart/mixed;
 boundary="------------020003090104090006010704"

This is a multi-part message in MIME format.
--------------020003090104090006010704
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

The --random option produces "Unknown arg `--random'" errors with both th=
e
DNAT and REDIRECT targets. Corrected by the attached patch.

-Tom
--=20
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key

--------------020003090104090006010704
Content-Type: text/x-diff;
 name="random-patch.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="random-patch.diff"

diff -au ../iptables-1.3.8.standard/extensions/libipt_DNAT.c extensions/l=
ibipt_DNAT.c
--- ../iptables-1.3.8.standard/extensions/libipt_DNAT.c	2007-06-24 16:26:=
35.000000000 -0700
+++ extensions/libipt_DNAT.c	2007-11-14 12:56:40.000000000 -0800
@@ -180,6 +180,7 @@
 			*flags |=3D IPT_DNAT_OPT_RANDOM;
 		} else
 			*flags |=3D IPT_DNAT_OPT_RANDOM;
+		return 1;
 	default:
 		return 0;
 	}
Only in extensions/: libipt_DNAT.c~
diff -au ../iptables-1.3.8.standard/extensions/libipt_REDIRECT.c extensio=
ns/libipt_REDIRECT.c
--- ../iptables-1.3.8.standard/extensions/libipt_REDIRECT.c	2007-06-24 16=
:26:35.000000000 -0700
+++ extensions/libipt_REDIRECT.c	2007-11-14 12:56:20.000000000 -0800
@@ -24,7 +24,7 @@
=20
 static struct option opts[] =3D {
 	{ "to-ports", 1, 0, '1' },
-	{ "random", 1, 0, '2' },
+	{ "random", 0, 0, '2' },
 	{ 0 }
 };
=20
Only in extensions/: libipt_REDIRECT.c~

--------------020003090104090006010704--

--------------enig918F2C7BC736E2C607B76100
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHO2PtO/MAbZfjDLIRAtv9AKC3Zkg/XoPLR1eIYhVD8oL8rIc9AACgjcyD
LCNDPY1h68P/S1q81Ib1cqk=
=MgCp
-----END PGP SIGNATURE-----

--------------enig918F2C7BC736E2C607B76100--
