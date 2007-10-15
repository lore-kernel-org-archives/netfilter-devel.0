From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] Release of iptables 1.4.0rc1
Date: Mon, 15 Oct 2007 18:52:32 +0200
Message-ID: <47139AD0.8060002@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCC00DAAB0E3375A5FFE6E023"
Cc: netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59545 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752714AbXJOQuH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:50:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCC00DAAB0E3375A5FFE6E023
Content-Type: multipart/mixed;
 boundary="------------010003060208030808080306"

This is a multi-part message in MIME format.
--------------010003060208030808080306
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi!

The netfilter coreteam proudly presents:

	iptables version 1.4.0rc1

This is the first release candidate of the new iptables branch 1.4. This
release candidate adds support for the generic xtables infrastructure
that strongly improves IPv6 support. Also several accumulated bugfixed
are included. Test it!

Version 1.4.0rc1 can be obtained from:

http://www.netfilter.org/projects/iptables/downloads.html
ftp://ftp.netfilter.org/pub/iptables/

On behalf of the Netfilter Core Team.
Happy testing!

--=20
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------010003060208030808080306
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="ChangeLog"

iptables v1.4.0rc1 Changelog
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Changes from 1.3.8:

- Add support for generic xtables infrastructure (improved IPv6 support!)=

	[ Yasuyuki Kozakai ]

- Deletes empty ->final_check() functions
	[ Jan Engelhardt ]

- Fix sparse warnings: non-C99 array declaration, incorrect function prot=
otypes
	[ Patrick McHardy ]

- Remove last vestiges of NFC
	[ Peter Riley ]

- Make @msg argument a const char *, just like printf
	[ Jan Engelhardt ]

- Makes it possible to omit extra_opts of matches/targets if unnecessary
	[ Jan Engelhardt ]

- Fix "iptables getsockopt failed strangely" when querying revisions for =
non-existant matches and targets
	[ Patrick McHardy]

- Introduces DEST_IPT_LIBDIR in Makefile
	[ Yasuyuki Kozakai ]

- Change default KERNEL_DIR location and add KBUILD_OUTPUT
	[ Sven Wegener ]

- Removes obsolete KERNEL_64_USERSPACE_32 definitions
	[ Yasuyuki Kozakai ]

- Fix unused function warning
	[ Patrick McHardy ]

--------------010003060208030808080306--

--------------enigCC00DAAB0E3375A5FFE6E023
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHE5rUW42mhw+ndNkRAigxAJ9mf+zYdP8VPxVOWnnPr9Tfdnm8JQCdG/nF
xQhzP0iKto8FjuvZrIIt3E8=
=l2gi
-----END PGP SIGNATURE-----

--------------enigCC00DAAB0E3375A5FFE6E023--
