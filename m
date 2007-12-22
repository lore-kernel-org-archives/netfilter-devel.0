From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] Release of iptables 1.4.0 final
Date: Sat, 22 Dec 2007 14:53:26 +0100
Message-ID: <476D16D6.2040001@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3DB129238798BC717D20CE50"
Cc: netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43058 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751366AbXLVNxz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Dec 2007 08:53:55 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3DB129238798BC717D20CE50
Content-Type: multipart/mixed;
 boundary="------------060203070200060909000903"

This is a multi-part message in MIME format.
--------------060203070200060909000903
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi!

The netfilter coreteam proudly presents:

	iptables version 1.4.0 final

The netfilter core team has released iptables-1.4.0. This is the first
final release of the new iptables branch 1.4. This release contains lots
of bugfixes and improvements for the previous release candidate which
strongly improves IPv6 support. Please, upgrade!

Version 1.4.0 can be obtained from:

http://www.netfilter.org/projects/iptables/downloads.html
ftp://ftp.netfilter.org/pub/iptables/

On behalf of the Netfilter Core Team.
Dum de dum, tum te tum.

--=20
"Los honestos son inadaptados sociales" -- Les Luthiers


--------------060203070200060909000903
Content-Type: text/plain;
 name="changes-iptables-1.4.0.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="changes-iptables-1.4.0.txt"

iptables v1.4.0 Changelog
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Changes from 1.4.0rc1:

- Don't use dlfcn.h if NO_SHARED_LIBS is defined
	[ Mike Frysinger ]

- Fix showing help text for matches/targets with revision as user
	[ Patrick McHardy ]

- Print warnings to stderr
	[ Max Kellermann ]

- Fix sscanf type errors
	[ Patrick McHardy ]

- Always print mask in iptables-save
	[ Jan Engelhardt ]

- Don't silenty exit on failure to open /proc/net/{ip,ip6}_tables_names
	[ Victor Stinner ]

- Adds --table to iptables-restore
	[ Peter Warasin ]

- Make DO_MULTI=3D1 work for ip6tables* binaries
	[ Hann-huei Chiou ]

- Add ip6tables-{save,restore} to non-experimental target, fix strict ali=
asing
warnings
	[ Patrick McHardy ]

- Introducing libxt_*.man files. Sorted matches and modules
	[ Laszlo Attila Toth ]

- Install ip6tables-{save,restore} manpages
	[ Patrick McHardy ]

- Performance optimization in sorting chain during pull-out
	[ Jesper Dangaard Brouer ]

- Fix sockfd use accounting for kernels without autoloading
	[ Patrick McHardy ]

- use <linux/types.h>
	[ Jan Engelhardt ]

- Fix make/compile error for iptables-1.4.0rc1
	[ Jesper Dangaard Brouer ]

- Fix for --random option in DNAT and REDIRECT
	[ Tom Eastep ]

- Document xt_statistic=20
	[ Stefano Sabatini ]

- sctp: fix - mistake to pass a pointer where array is required
	[ Li Zefan ]

- Fix connlimit output for inverted --connlimit-above: ! > is <=3D, not <=

	[ Patrick McHardy ]

- Add NFLOG manpage
	[ Patrick McHardy ]

- Move libipt_DSCP.man to libxt_DSCP.man for ip6tables.8
	[ Yasuyuki Kozakai ]

- Unifies libip[6]t_CONNSECMARK.man to libxt_CONNSECMARK.man
	[ Yasuyuki Kozakai ]

- Moves libipt_CLASSYFY.man to libxt_CLASSYFY.man for ip6tables.8
	[ Yasuyuki Kozakai ]

- fix check_inverse() call
	[ Jan Engelhardt ]

- Bump version to 1.4.0 final
	[ Pablo Neira Ayuso ]

--------------060203070200060909000903--

--------------enig3DB129238798BC717D20CE50
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHbRbWW42mhw+ndNkRAkEAAKCbfncUQLT8d1qtDETupzK4vXzA8gCfV73h
wV6zGCe7Qv5RqIxOFBTuRj4=
=Ynof
-----END PGP SIGNATURE-----

--------------enig3DB129238798BC717D20CE50--
