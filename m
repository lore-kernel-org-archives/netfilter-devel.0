From: Netfilter Core Team <coreteam@netfilter.org>
Subject: Release of iptables-1.2.9
Date: Sun, 2 Nov 2003 18:16:11 +0100
Sender: netfilter-announce-admin@lists.netfilter.org
Message-ID: <20031102171611.GF1536@sunbeam.de.gnumonks.org>
Reply-To: coreteam@netfilter.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5uhzMJlTksuFv+PE"
Cc: lwn@lwn.net
Return-path: <netfilter-announce-admin@lists.netfilter.org>
To: Netfilter Announcement List <netfilter-announce@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-announce-admin@lists.netfilter.org
List-Help: <mailto:netfilter-announce-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-announce@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-announce>,
	<mailto:netfilter-announce-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-announce>,
	<mailto:netfilter-announce-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-announce/>
List-Id: netfilter-devel.vger.kernel.org


--5uhzMJlTksuFv+PE
Content-Type: multipart/mixed; boundary="9A1A73/U17WN0PFw"
Content-Disposition: inline


--9A1A73/U17WN0PFw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

The netfilter coreteam proudly presents:

	iptables version 1.2.9

1.2.9 is (like most other 1.2.x releases) a maintainance release,
containing lots of bugfixes that have accumulated over time.

The ChangeLog is attached to this mail.

Version 1.2.9 can be obtained from:

	http://www.netfilter.org/files/iptables-1.2.9.tar.bz2
	ftp://ftp.netfilter.org/pub/iptables/iptables-1.2.9.tar.bz2

Please note that since iptables-1.2.7, patch-o-matic is no longer part of
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

--9A1A73/U17WN0PFw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-iptables-1.2.9.txt"
Content-Transfer-Encoding: quoted-printable

iptables v1.2.9 Changelog
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
- MASQUERADE target: don't accept negative port numbers
	[ Yasuyuki Kozakai ]
- physdev match: fix new structure layout for kernel > 2.6.0-test8
	[ Bart De Schuymer ]

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


--9A1A73/U17WN0PFw--

--5uhzMJlTksuFv+PE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/pTvbNfqJzMqajVsRAss4AKCNsDjXjHy5ofTBHSjYaZkuJ8o+6gCeL7yu
iZuOZ1Yb0J7t63/mSHuUoak=
=Yqc8
-----END PGP SIGNATURE-----

--5uhzMJlTksuFv+PE--
