From: Netfilter Core Team <coreteam@netfilter.org>
Subject: Release of iptables-1.3.0
Date: Sun, 13 Feb 2005 00:27:26 +0100
Message-ID: <20050212232726.GE20269@sunbeam.de.gnumonks.org>
Reply-To: coreteam@netfilter.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k3qmt+ucFURmlhDS"
Cc: lwn@lwn.net
To: Netfilter Announcement List <netfilter-announce@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-announce>,
	<mailto:netfilter-announce-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-announce>
List-Post: <mailto:netfilter-announce@lists.netfilter.org>
List-Help: <mailto:netfilter-announce-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-announce>,
	<mailto:netfilter-announce-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-announce-bounces@lists.netfilter.org
Errors-To: netfilter-announce-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--k3qmt+ucFURmlhDS
Content-Type: multipart/mixed; boundary="VMt1DrMGOVs3KQwf"
Content-Disposition: inline


--VMt1DrMGOVs3KQwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

The netfilter coreteam proudly presents:

	iptables version 1.3.0

The final 1.3.0 version contains some minor bugfixes and is otherwise
identical to the 1.3.0rc1 release candidate.

1.3.x is a major update to 1.2.11.  Apart from fixing numerous bugs (see
changelog), it contains the much-hyped libiptc rewrite.

The ChangeLog is attached to this mail.

Version 1.3.0 can be obtained from:

	http://www.netfilter.org/files/iptables-1.3.0.tar.bz2
	ftp://ftp.netfilter.org/pub/iptables/iptables-1.3.0.tar.bz2

Please also note: Since Kernel 2.6.x is out, we now use
patch-o-matic-ng for both 2.4.x and 2.6.x. patch-o-matic-ng is
Distributed as seperate package:=20
	ftp://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot/
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

--VMt1DrMGOVs3KQwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-iptables-1.3.0.txt"
Content-Transfer-Encoding: quoted-printable

iptables v1.3.0 Changelog
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
This version requires kernel >=3D 2.4.4
This version recommends kernel >=3D 2.4.18

Bugs fixed from 1.3.0rc1:

- Fix realm match save/restore issue
	[ Harald Welte ]

- Fix hashlimit rule deletion from userspace
	[ Samuel Jean ]

- Fix hashlimit parameter handling / iptables-save
	[ Nikolai Malykh ]

- Fix multiport inversion
	[ Phil Oester ]

Bugs fixed from 1.2.11:

- Fix compilation on systems where /bin/sh !=3D bash
	[ Jozsef Kadlecsik ]

- Fix setting lib_dir in ip*tables-{save,restore}
	[ Martin Josefsson ]

- Fix module-autoloading in certain cases
	[ Harald Welte ]

- libipt_TTL: limit range of valid TTL to 0-255
	[ Maciej Soltysiak ]

- libip6t_HL: limit range of valid HL to 0-255
	[ Maciej Soltysiak ]

- libip{6}t_limit: Fix half-working limit invert check=20
	[ Phil Oester ]

- libipt_connbytes: Update to use the IP_CONNTRACK_ACCT counters
	[ Harald Welte ]

- libipt_conntrack: Fix typo
	[ Phil Oester ]

- libipt_dstlimit: Fix half-working invert check=20
	[ Phil Oester ]

- libipt_helper: Prevent user from using --helper multiple times
	[ Nicolas Bouliane ]

- libipt_iprange: Print error message if --dst-range used twice
	[ Nicolas Bouliane ]

- libipt_nth: Fix help message syntax
	[ Harald Welte ]

- libipt_psd: Fix option parsing
	[ Pablo Neira ]

- libipt_random: Fix help message syntax
	[ Harald Welte ]

- libipt_realm: Fix inversion of options
	[ Simon Lodal ]

- libipt_time: Fix C++ style delayed variable definition
	[ Olivier Clerget ]

- libipt_time: Print message about time match not adhering daylight saving
	[ Phil Oester ]

- libipt_tos: Print Error message if --tos is specified twice
	[ Nicolas Bouliane ]

- libipt_ttl: Cleanup ttl option parsing
	[ Phil Oester ]

- libipt_u32: Fix option parsing
	[ Piotr Gasid'o ]


Changes from 1.2.11:

- libiptc: complete rewrite for performance reasons
	[ Harald Welte, Martin Josefsson ]

- introduce "DO_MULTI=3D1" mode to build a muilti-call binary
	[ Bastiaan Bakker ]

- code cleanup, use C99 initializers
	[ Harald Welte, Pablo Neira ]

- Extension revision number support (if kernel supports the getsockopts).
	[ Rusty Russell ]

- Don't need ipt_entry_target()/ip6t_entry_target().
	[ Rusty Russell ]

- Don't re-initialize libiptc/libip6t unless modprobe attempt succeeds.
	[ Rusty Russell ]

- Implement IPTABLES_LIB_DIR and IP6TABLES_LIB_DIR environment variables
	[ Rusty Russell ]

- Add manpage section about 'raw' table
	[ Harald Welte ]


- libip{6}t_ROUTE: add ROUTE --tee mode
	[ Patrick Schaaf ]

- libip{6}t_multiport: Print Error message when `!' is used
	[ Patrick McHardy, Phil Oester ]

- New libip6t_physdev Match
	[ Bart De Schuymer ]

- libipt_CLUSTERIP: Fix compiler warning about const
	[ Harald Welte ]

- libipt_DNAT: Print Error message if `:' is used for port range
- libipt_SNAT: Print Error message if `:' is used for port range
	[ Phil Oester ]

- libipt_LOG: Add --log-uid option
	[ John Lange ]

- libipt_MARK: add bitwise operators
	[ Henrik Nordstrom, Rusty Russell ]

- libipt_SET: Update to ipset2
	[ Jozsef Kadlecsik ]

- libipt_account: Update to 0.1.16
	[ Piotr Gasid'o ]

- New libipt_comment Match
	[ Brad Fisher ]

- New libipt_hashlimit Match, supersedes dstlimit
	[ Harald Welte ]

- libipt_ttl: Use string_to_number()
	[ Rusty Russell ]


Please note: Since version 1.2.7a, patch-o-matic is now no longer part of
iptables but rather distributed as a seperate package
(ftp://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot)


--VMt1DrMGOVs3KQwf--

--k3qmt+ucFURmlhDS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCDpDeNfqJzMqajVsRAlNKAKChRYIRG+tDH0ebbT2qRqjfEHiBFACgocJH
2vPrQBVX9YEaeo97bw50mJY=
=RHBe
-----END PGP SIGNATURE-----

--k3qmt+ucFURmlhDS--
