From: Netfilter Core Team <coreteam@netfilter.org>
Subject: [ANNOUNCE] Release of iptables-1.3.1
Date: Mon, 7 Mar 2005 15:35:32 +0100
Message-ID: <20050307143532.GI30487@sunbeam.de.gnumonks.org>
Reply-To: coreteam@netfilter.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ECAkxgSy0pGoHfdA"
Cc: lwn@lwn.net
To: Netfilter Announcement List <netfilter-announce@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--ECAkxgSy0pGoHfdA
Content-Type: multipart/mixed; boundary="Zll6mx50Q8J7qlLQ"
Content-Disposition: inline


--Zll6mx50Q8J7qlLQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

The netfilter coreteam proudly presents:

	iptables version 1.3.1

The final 1.3.1 version contains some minor bugfixes to the
recently-released version 1.3.0

The ChangeLog is attached to this mail.

Version 1.3.1 can be obtained from:

	http://www.netfilter.org/files/iptables-1.3.1.tar.bz2
	ftp://ftp.netfilter.org/pub/iptables/iptables-1.3.1.tar.bz2

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

--Zll6mx50Q8J7qlLQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-iptables-1.3.1.txt"

iptables v1.3.1 Changelog
======================================================================
This version requires kernel >= 2.4.4
This version recommends kernel >= 2.4.18

Bugs fixed from 1.3.0:

- Fix CLUSTERIP rule deletion
	[ Pablo Neira ]

- Fix libip6t_random compilation
	[ Harald Welte ]

- Fix CONNMARK on 32bit userspace / 64bit kernel archs
	[ Pablo Neira ]

Changes from 1.3.0:

- remove bogus NFC_* stuff in iptables
	[ Pablo Neira ]

- libiptc: don't sort builtin chains, restores iptables-1.2.x sort order
	[ Olaf Rempel ]


Please note: Since version 1.2.7a, patch-o-matic is now no longer part of
iptables but rather distributed as a seperate package
(ftp://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot)


--Zll6mx50Q8J7qlLQ--

--ECAkxgSy0pGoHfdA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCLGa0NfqJzMqajVsRAvSwAJ4g++23LvPnbAGwYmr7iLFzLdm9XACgt8yk
wLl/c3V9XSk5ohn3359hkIo=
=fWic
-----END PGP SIGNATURE-----

--ECAkxgSy0pGoHfdA--
