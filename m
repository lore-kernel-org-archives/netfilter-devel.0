From: Netfilter Core Team <coreteam@netfilter.org>
Subject: Release of iptables-1.3.4
Date: Thu, 3 Nov 2005 19:53:39 +0100
Message-ID: <20051103185339.GM905@sunbeam.de.gnumonks.org>
Reply-To: coreteam@netfilter.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n1iI6MeELQa9IOaF"
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


--n1iI6MeELQa9IOaF
Content-Type: multipart/mixed; boundary="4oF+6Ged69J0+4/e"
Content-Disposition: inline


--4oF+6Ged69J0+4/e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

The netfilter coreteam proudly presents:

	iptables version 1.3.4

The 1.3.4 version contains accumulated bugfixes to the last 1.3.3
version.  It also fixes some compilation problems with the latest
(2.6.14) kernel release.

The ChangeLog is attached to this mail.

Version 1.3.4 can be obtained from:

	http://www.netfilter.org/files/iptables-1.3.4.tar.bz2
	ftp://ftp.netfilter.org/pub/iptables/iptables-1.3.4.tar.bz2

Please also note: patch-o-matic-ng is Distributed as seperate package:=20
	ftp://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot/
=09
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

--4oF+6Ged69J0+4/e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-iptables-1.3.4.txt"
Content-Transfer-Encoding: quoted-printable

iptables v1.3.4 Changelog
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
This version requires kernel >=3D 2.4.0
This version recommends kernel >=3D 2.4.18

Bugs fixed from 1.3.3:

- Fix parsing of NFQUEUE queue numbers
	[ Eric Leblond ]

- Add documentation of --queue-num parameter to NFQUEUE manpage
	[ Eric Leblond ]

- Fix 'hash-init' parameter of CLUSTERIP target
	[ KOVACS Krisztian ]

- Fix CONNMARK match and target: Marks are now always 32bit
	[ Deti Fliegl ]

- Print error message when multiple "--to" DNAT/SNAT args are used
  with kernel >=3D 2.6.10
  	[ Phil Oester ]

- Fix compilation of connbytes match with 2.6.14 kernel
	[ Harald Welte ]

- Fix address inversion of conntrack match
	[ Tom Eastep ]

- Fix sorting of chain names=20
	[ Robert de Barth ]

Changes from 1.3.2:

- Add support for DCCP port and type matching
	[ Harald Welte ]

- Add support for new in-kernel string match
	[ Pablo Neira ]

Please note: Since version 1.2.7a, patch-o-matic is now no longer part of
iptables but rather distributed as a seperate package
(ftp://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot)


--4oF+6Ged69J0+4/e--

--n1iI6MeELQa9IOaF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDalyzXaXGVTD0i/8RAoEWAJ0aswaARW7Bf5q3hufUGFtzNZI+dQCgs4RG
4c/56+imPOX3exyXJT/VBTw=
=6Fw0
-----END PGP SIGNATURE-----

--n1iI6MeELQa9IOaF--
