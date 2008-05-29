From: Tom Eastep <teastep@shorewall.net>
Subject: [patch] ipset 2.3.0 segfault on '-U :all: {:all:|:default:}
Date: Thu, 29 May 2008 13:24:58 -0700
Message-ID: <483F111A.40700@shorewall.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCBFC0D22B4101D5309B3A68D"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lists.shorewall.net ([206.124.146.177]:50155 "EHLO
	lists.shorewall.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbYE2Ude (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2008 16:33:34 -0400
Received: from [172.20.1.102] (wireless.shorewall.net [206.124.146.180])
	by lists.shorewall.net (Postfix) with ESMTP id 0B0B92160D8
	for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2008 13:24:16 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCBFC0D22B4101D5309B3A68D
Content-Type: multipart/mixed;
 boundary="------------020005000804050607030209"

This is a multi-part message in MIME format.
--------------020005000804050607030209
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Segfault occurs at line 1641 as a result of dereferencing a null pointer =

while testing the set type for iptreemap.

Patch attached.

Disclaimer: I didn't research the consequences of this patch if there are=
=20
existing iptreemap sets.

-Tom
--=20
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key

--------------020005000804050607030209
Content-Type: text/x-patch;
 name="ipset.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="ipset.diff"

--- ipset.c~	2007-08-27 23:53:14.000000000 -0700
+++ ipset.c	2008-05-29 13:10:02.000000000 -0700
@@ -1638,7 +1638,7 @@
 	DP("(%s, %s) -> %s", set ? set->name : IPSET_TOKEN_ALL, adt, binding);
=20
 	/* Ugly */
-	if (strcmp(set->settype->typename, "iptreemap") =3D=3D 0)
+	if (set && strcmp(set->settype->typename, "iptreemap") =3D=3D 0)
 		exit_error(PARAMETER_PROBLEM,
 			"iptreemap type of sets cannot be used at binding operations\n");
 	/* Alloc memory for the data to send */

--------------020005000804050607030209--

--------------enigCBFC0D22B4101D5309B3A68D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFIPxEfO/MAbZfjDLIRAkT/AJ9hfjaHq2gjdWJccKyp/iH9d+g0wwCfeght
+qDzTUpVooOfX7uN5qkyDFc=
=uJjB
-----END PGP SIGNATURE-----

--------------enigCBFC0D22B4101D5309B3A68D--
