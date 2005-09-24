From: Netfilter Core Team <coreteam@netfilter.org>
Subject: Release of libnfnetlink,
	libnfnetlink_conntrack and conntrack
Date: Sat, 24 Sep 2005 23:54:13 +0200
Message-ID: <20050924215413.GD731@sunbeam.de.gnumonks.org>
Reply-To: coreteam@netfilter.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QmaI2uGQ+01Rg0vj"
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


--QmaI2uGQ+01Rg0vj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

The netfilter project proudly presents:

	libnfnetlink-0.0.10
	libnfnetlink_conntrack-0.0.10
	conntrack-0.81

Each of those three releases is the first official release of the
respective project.  They're the counterparts to the first pieces of the
"next generation" netfilter subsystem that will be present in the 2.6.14
linux kernel release.

libnfnetlink
	is the low-level userspace library for nfnetlink based
	communication between the kernel-side netfilter and the
	userspace world.

libnfnetlink_conntrack
	is the librarry for userspace access to the in-kernel connection
	tracking table.

conntrack
	is a commandline program for listing, querying, deleting,
	updating entries in the connection tracking table.  It also
	supports real-time tracing of connection tracking state changes
	(conntrack events).

You can download the three releases from=20
	ftp://ftp.netfilter.org/pub/libnfnetlink/libnfnetlink-0.0.10.tar.bz2
	ftp://ftp.netfilter.org/pub/libnfnetlink_conntrack/libnfnetlink_conntrack-=
0.0.10.tar.bz2
	ftp://ftp.netfilter.org/pub/conntrack/conntrack-0.81.tar.bz2

Happy firewalling,

	Harald Welte (for the Netfilter Core Team)

p.s.: expect some more news on libnfnetlink_log and libnfnetlink_queue
in the next couple of days(!)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--QmaI2uGQ+01Rg0vj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDNcsFXaXGVTD0i/8RAhFrAJ4vyt6fJITWH/FJXVE/CoAMv4Lq5gCgjsqO
w6dMRmFTvrfBjBexhf6qajk=
=9yJf
-----END PGP SIGNATURE-----

--QmaI2uGQ+01Rg0vj--
