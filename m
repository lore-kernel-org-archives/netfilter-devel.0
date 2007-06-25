From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] Release of iptables 1.3.8
Date: Mon, 25 Jun 2007 15:21:10 +0200
Message-ID: <467FC146.3040801@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigA63809F50773741FEDDA63DB"
Cc: lwn@lwn.net
To: netfilter-announce@lists.netfilter.org,
	netfilter <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA63809F50773741FEDDA63DB
Content-Type: multipart/mixed; boundary="------------030103020908010709020805"

This is a multi-part message in MIME format.
--------------030103020908010709020805
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi!

The netfilter coreteam proudly presents:

	iptables version 1.3.8

This release contains lots of accumulated bugfixes, manpage updates, and
support for IPv6-MH, TCPMSS and port randomization for NAT. The
ChangeLog is attached to this mail. Upgrade is recommended.

Version 1.3.8 can be obtained from:

http://www.netfilter.org/projects/iptables/downloads.html
ftp://ftp.netfilter.org/pub/iptables/

Happy firewall,
Pablo (on behalf of the Netfilter Core Team)

--=20
"Pa=EDses en desarrollo es el nombre con que los expertos designan a los
pa=EDses arrollados por el desarrollo ajeno" -- Patas Arriba. La Escuela
del Mundo al Rev=E9s -- E. Galeano

--------------030103020908010709020805
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="ChangeLog"

- Fix build error of conntrack match
	[Yasuyuki Kozakai]

- Remove whitespace in ip6tables.c
	[Yasuyuki Kozakai]

- `-p all' and `-p 0' should be allowed in ip6tables
	[Yasuyuki Kozakai]

- hashlimit doc update
	[Jan Engelhardt]

- add --random option to DNAT and REDIRECT
	[Patrick McHardy]

- Makefile uses POSIX conform directory check
	[Roy Marples]

- Fix missing newlines in iptables-save/restore output
	[Pavol Rusnak]

- Update quota manpage for SMP
	[Phil Oester]

- Output for unspecified proto is `all' instead of `0'
	[Phil Oester]

- Fix iptables-save with --random option
	[Patrick McHardy]

- Remove unnecessary IP_NAT_RANGE_PROTO_RANDOM ifdefs
	[Patrick McHardy]

- Remove libnsl from LDLIBS
	[Patrick McHardy]

- Fix problem with iptables-restore and quotes
	[Pablo Neira Ayuso]

- Remove unnecessary includes
	[Patrick McHardy]

- Fix --modprobe parameter
	[Maurice van der Pot]

- ip6tables-restore should output error of modprobe after failed to load
	[Yasuyuki Kozakai]

- Add random option to SNAT
	[Eric Leblond]

- Fix missing space in error message
	[Patrick McHardy]

- Fixes for manpages of tcp, udp, and icmp{,6}
	[Yasuyuki Kozakai]

- Add ip6tables mh extension
	[Masahide Nakamura]

- Fix tcpmss manpage
	[Patrick McHardy]

- Add ip6tables TCPMSS extension
	[Arnaud Ebalard]

- Add UDPLITE multiport support
	[Patrick McHardy]

- Fix missing space in ruleset listing
	[Patrick McHardy]

- Remove extensions for unmaintained/obsolete patchlets
	[Patrick McHardy]

- Fix greedy debug grep
	[Patrick McHardy]

- Fix type in manpage
	[Thomas Aktaia]

- Fix compile/install error for iptables-xml with DO_MULTI=3D1
	[Lutz Jaenicke]

--------------030103020908010709020805--

--------------enigA63809F50773741FEDDA63DB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGf8FJW42mhw+ndNkRAk/zAJ9aZNXkoBHyKYn93GCFga3a4BzoFQCfUta8
xXaVOAatL6EpmErReEoD40Y=
=PCxm
-----END PGP SIGNATURE-----

--------------enigA63809F50773741FEDDA63DB--
