From: Netfilter Core Team <coreteam@netfilter.org>
Subject: [ANNOUNCE] Release of iptables-1.2.9rc1
Date: Tue, 7 Oct 2003 23:56:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031007215600.GE18246@sunbeam.de.gnumonks.org>
Reply-To: coreteam@netfilter.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="va9XEZk9/dJ5GUjX"
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


--va9XEZk9/dJ5GUjX
Content-Type: multipart/mixed; boundary="vM12nk/63StVgfqY"
Content-Disposition: inline


--vM12nk/63StVgfqY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

The netfilter coreteam proudly presents:

	iptables version 1.2.9rc1

Version 1.2.9rc1 is the first release candidate of the upcoming 1.2.9
version.  Please note that this is a _release candidate_ and not the
final version.  It is supposed to be stable, but might still contain
some minor glitches.  If you are testing 1.2.9rc1 and run into any bugs,
please report them immediately to our bugzilla bug tracking system.

The ChangeLog is attached to this mail.

Version 1.2.9rc1 can be obtained from:

	http://www.netfilter.org/files/iptables-1.2.9rc1.tar.bz2
	ftp://ftp.netfilter.org/pub/iptables/iptables-1.2.9rc1.tar.bz2

Please note that since iptables-1.2.7 patch-o-matic is no longer part of
iptables, but distributed as a seperate package.  You can obtain the
latest release and daily CVS snapshots from:

	ftp://ftp.netfilter.org/pub/patch-o-matic/
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

--vM12nk/63StVgfqY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-iptables-1.2.9rc1.txt"
Content-Transfer-Encoding: quoted-printable

iptables v1.2.9rc1 Changelog
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
This version requires kernel >=3D 2.4.4
This version recommends kernel >=3D 2.4.18

Bugs Fixed from 1.2.8:

- ip(6)tables-save/restore: fix memory leaks
	[ Harald Welte, Martin Josefsson ]
- ip6tables: fix printout of odd length netmasks
	[ Mikko Markus Torni ]
- condition match: fix iptables-save
	[ Stephane Ouellette ]
- fuzzy match: fix ip(6)tables-save
	[ Hime Aguiar e Oliveira Jr. ]
- mac match: fix ip(6)tables-save if used inverted (!)
	[ David Zambonini, Martin Josefsson ]
- ip6tables udp match: check for invalid port ranges
	[ Thomas Poehnitz ]
- LOG target: fix iptables-save (save loglevel numerically)
	[ Thomas Woerner ]
- mport match: fix iptables-save (save numerically)
	[ Thomas Woerner ]
- libipq: fix ipq_id_t definition on 'real' 64bit/64bit architectures
	[ Ryan Veety ]
- libip6tc: fix ipv6_prefix_length endianness bugs
	[ Mikko Markus Torni ]

Changes from 1.2.8:

- build plugins for connlimit, iprange, realm, CLASSIFY, CONNMARK, NETMAP
	[ Harald Welte ]
- libip(6)tc: Speedup due to inceremental chain cache updates
	[ Harald Welte ]
- recent match: Update to version 0.3.1 that was submitted to the kernel
	[ Stephen Frost ]
- physdev match: add --physdev-is-{in,out,bridge} option
	[ Bart de Schuymer ]
- REJECT target: add support for ICMP administratively prohibited=20
	[ Maciej Soltysiak ]
- conntrack match: add suport for CONFIRMED / unconfirmed state
	[ Harald Welte ]
- ROUTE target: new option: continue traversal
	[ Cedric de Launois ]
- varios cosmetic cleanups
	[ Stephane Ouellette ]
- iptables/libiptc: add support for the new 'raw' table
	[ Jozsef Kadlecsik ]

Please note: Since version 1.2.7a, patch-o-matic is now no longer part of
iptables but rather distributed as a seperate package
(ftp://ftp.netfilter.org/pub/patch-o-matic/)


--vM12nk/63StVgfqY--

--va9XEZk9/dJ5GUjX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/gzZwNfqJzMqajVsRAh24AKCUrb4qqnye1ZooEH80LmPaMnb7CACfWO46
mwG6KsQLwqDj7xZ9gc2Jhrw=
=bCJu
-----END PGP SIGNATURE-----

--va9XEZk9/dJ5GUjX--
