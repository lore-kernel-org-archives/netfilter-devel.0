From: Netfilter Core Team <coreteam@netfilter.org>
Subject: Release of iptables-1.3.5
Date: Wed, 1 Feb 2006 14:09:45 +0100
Message-ID: <20060201130945.GG31060@sunbeam.de.gnumonks.org>
Reply-To: coreteam@netfilter.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KR/qxknboQ7+Tpez"
Cc: lwn@lwn.net
Return-path: <netfilter-announce-bounces@lists.netfilter.org>
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


--KR/qxknboQ7+Tpez
Content-Type: multipart/mixed; boundary="qp4W5+cUSnZs0RIF"
Content-Disposition: inline


--qp4W5+cUSnZs0RIF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

The netfilter coreteam proudly presents:

	iptables version 1.3.5

The 1.3.5 version contains accumulated bugfixes to the last 1.3.4
version.  It also fixes some compilation problems with old kernel
headers.  The most noteworthy new features are:

	- support for full netfilter/ipsec interoperability via
	  policy match

	- support for ipv6 stateful packet filtering using
	  nf_conntrack and the ip6tables 'state' and 'conntrack'
	  match.

The ChangeLog is attached to this mail.

Version 1.3.5 can be obtained from:

	http://www.netfilter.org/files/iptables-1.3.5.tar.bz2
	ftp://ftp.netfilter.org/pub/iptables/iptables-1.3.5.tar.bz2

More information can be found at the netfilter/iptables project homepage,
available at:

	http://www.netfilter.org/

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

--qp4W5+cUSnZs0RIF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-iptables-1.3.5.txt"
Content-Transfer-Encoding: quoted-printable

iptables v1.3.5 Changelog
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
This version requires kernel >=3D 2.4.0
This version recommends kernel >=3D 2.4.18

Bugs fixed from 1.3.4:

- Fix conntrack --ctproto option in iptables-save
	[ Phil Oester ]

- Fix string match '--from' option in iptables-save
	[ Michael Rash ]

- Fix option parser of ttl match
	[ Patrick McHardy ]

- Get rid of gcc-4 warnings
	[ Patrick McHardy ]

- Fix spelling of 'address' in DNAT/SNAT manpage section
	[ MJ Anthony ]

- Fix 'tcp-rst' parsing in REJECT target
	[ Torsten Hilbrich ]

- Fix probing for supported revisions
	[ Jones Desougi ]

- Fix compilation of iptables on [old] systems that don't have IPT_F_GOTO
	[ Harald Welte ]

- Only set revisions on real targets, not on jumps
	[ Pablo Neira ]

- Fix memory leak in TC_COMMIT() of libiptc
	[ Markus Sundberg ]

- Correctly propagate errors of setsockopt to calling function
	[ Harald Welte ]

- Fix connbytes match iptables-save
	[ Unknown ]

- Fix sctp match compilation against recent kernel headers
	[ Harald Welte ]

- Fix conntrack match compilation against 2.4.0 kernel headers
	[ Harald Welte ]

Changes from 1.3.4:

- Add support for ip6tables connmark match and target=20
	[ Harald Welte ]

- Add support for ip6tables state match
	[ Harald Welte ]

- Add support for new policy ip[6]tables match
	[ Patrick McHardy ]

- Major manpage update
	[ Yasuyuki Kozakai ]

- Remove ippool support, it has been deprecated by ipset long time ago
	[ Harald Welte ]

Please note: Since version 1.2.7a, patch-o-matic is now no longer part of
iptables but rather distributed as a seperate package
(ftp://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot)


--qp4W5+cUSnZs0RIF--

--KR/qxknboQ7+Tpez
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD4LMZNfqJzMqajVsRAkNtAJ41u3JIIMDybv7bR1ECQaMhfBzDiACfZakO
KDP4qNZGqIKzzFk+G6oamE0=
=U6fY
-----END PGP SIGNATURE-----

--KR/qxknboQ7+Tpez--
