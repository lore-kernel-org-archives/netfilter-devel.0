From: Netfilter Core Team <coreteam@netfilter.org>
Subject: [ANNOUNCE] Release of iptables-1.2.10
Date: Wed, 16 Jun 2004 21:38:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040616193819.GP12494@sunbeam.de.gnumonks.org>
Reply-To: coreteam@netfilter.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3Y2Mr1SP1gWKl0+e"
Cc: lwn@lwn.net
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Announcement List <netfilter-announce@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--3Y2Mr1SP1gWKl0+e
Content-Type: multipart/mixed; boundary="j9XQ5cF5hebrmXqw"
Content-Disposition: inline


--j9XQ5cF5hebrmXqw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

The netfilter coreteam proudly presents:

	iptables version 1.2.10

1.2.10 is (like most other 1.2.x releases) a maintainance release,
containing lots of bugfixes that have accumulated over time.

The ChangeLog is attached to this mail.

Version 1.2.10 can be obtained from:

	http://www.netfilter.org/files/iptables-1.2.10.tar.bz2
	ftp://ftp.netfilter.org/pub/iptables/iptables-1.2.10.tar.bz2

Please note that since iptables-1.2.7, patch-o-matic is no longer part of
iptables, but distributed as a seperate package.  You can obtain the
latest release and daily CVS snapshots from:

	ftp://ftp.netfilter.org/pub/patch-o-matic/

Please also note: Since Kernel 2.6.x is out, we now use
patch-o-matic-ng for both 2.4.x and 2.6.x. Distributed as seperate
package:=20
	ftp://ftp.netfilter.org/pub/patch-o-matic-ng
=09
More information can be found at the netfilter/iptables project homepage,
available at:

	http://www.netfilter.org/
	http://www.iptables.org/

Happy firewalling,

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--j9XQ5cF5hebrmXqw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-iptables-1.2.10.txt"
Content-Transfer-Encoding: quoted-printable

iptables v1.2.10 Changelog
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
This version requires kernel >=3D 2.4.4
This version recommends kernel >=3D 2.4.18

Bugs Fixed from 1.2.9:

- physdev match: fix new structure layout for kernel > 2.6.0-test8
	[ Bart De Schuymer ]

- Better 64bit / 32bit split architecture detection
- IPv6 LOG target: Fix compiler warnings on 64bit
- LOG target: Fix compiler warnings on 64bit
- IPv6 MARK target: Use full 64bit mark on 64bit archs
- MARK target: Use full 64bit mark on 64bit archs
- SAME target: Fix 64bit/32bit splitarch problems
- ULOG target: Fix 64bit/32bit splitarch problems
- conntrack match: Fix 64bit/32bit splitarch problem
- IPv6 limit match: Fix 64bit/32bit splitarch problem
- limit match: Fix 64bit/32bit splitarch problem
- IPv6 mark match: Use full 64bit mark on 64bit archs
- mark match: Use full 64bit mark on 64bit archs
- owner match: Fix compiler warnings on 64bit
	[ Martin Jofsefsson ]

- connbytes match: Fix signedness / unsigned issue
	[ Martin Josefsson ]

- connlimit match: Fix '/0' netmask
	[ David Ahern ]

- ipv6 owner match: fix possibly not zero terminated string
- helper match: fix possibly not zero terminated string
- recent match: fix possibly not zero terminated string
	[ Karsten Desler ]

- ICMP match: fix '--icmp-type any' case
	[ Harald Welte ]

- CONNMARK target: major update (add mark/mask matching)
	[ Henrik Nordstrom ]

- DSCP target: Fix cosmetic help message problem=20
	[ Maciej Soltysiak ]

- string match: Fix iptables-save/restore for ascii strings with spaces
	[ Michael Rash ]

- ip(6)tables-restore: Make sure matches are used in the same order
	[ Martin Josefsson ]

- ip(6)tables-restore: Fix '--verbose' option
- ip(6)tables-restore: Add '--test' option
- ip(6)tables-restore: Complain about missing 'COMMIT'
	[ Martin Josefsson ]

- ip(6)tables-restore: Allow embedding of quote character in quoted strings
	[ Michael Rash ]
=09
- libipq: Protect against spoofed queue messages (check if sender is kernel)
	[ Harald Welte ]


Changes from 1.2.9:

- time match: add 'datestart' and 'datestop' parameters
	[ Fabrice Marie ]

- modular manpage build, depending on actually compiled-in features
	[ Henrik Nordstrom ]

- additional documentation in manpage snippets formerly missing
	[ Harald Welte ]

- support new CLUSTERIP Target
	[ Harald Welte ]

- support new account match
	[ Piotr Gasid'o ]

- support new connrate match
	[ Nuuti Kotivuori ]

- support new dstlimit match
	[ Harald Welte ]

- support new 'set' match / 'SET' target
	[ Jozsef Kadlecsik ]

- osf match: add support for netlink reporting
	[ Evgeniy Polyakov ]

- new SCTP protocol match
	[ Kiran Kumar ]


Please note: Since version 1.2.7a, patch-o-matic is now no longer part of
iptables but rather distributed as a seperate package
(ftp://ftp.netfilter.org/pub/patch-o-matic/)

Please also note: Since Kernel 2.6.x is out, we now use patch-o-matic-ng, d=
istributed as seperate package:
(ftp://ftp.netfilter.org/pub/patch-o-matic-ng)


--j9XQ5cF5hebrmXqw--

--3Y2Mr1SP1gWKl0+e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA0KGrXaXGVTD0i/8RAsavAKCBx2BStvh52EKdKBktdkaviId3xwCgmD0b
6gHcB39EpYbfsM7f2DUX01g=
=ciLh
-----END PGP SIGNATURE-----

--3Y2Mr1SP1gWKl0+e--
