From: Harald Welte <laforge@netfilter.org>
Subject: [ANNOUNCE] multiple netfilter.org releases
Date: Sat, 5 Nov 2005 20:29:31 +0100
Message-ID: <20051105192931.GI16000@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mXDO3udm/xYWQeMQ"
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Announcement List <netfilter-announce@lists.netfilter.org>
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


--mXDO3udm/xYWQeMQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Today the netfilter project released

libnfnetlink-0.0.11
	ftp://ftp.netfilter.org/pub/libnfnetlink/libnfnetlink-0.0.11.tar.bz2
	This is the low-level communications library

libnetfilter_log-0.0.10
	ftp://ftp.netfilter.org/pub/libnetfilter_log/libnetfilter_log-0.0.10.tar.b=
z2
	This is the userspace library for nfnetlink_log in 2.6.14
	It is used by the upcoming ulogd-2.00beta release
	Needs libnfnetlink-0.0.11

libnetfilter_queue-0.0.10
	ftp://ftp.netfilter.org/pub/libnetfilter_queue/libnetfilter_queue-0.0.10.t=
ar.bz2
	This is the userspace library for nfnetlink_queue in 2.6.14
	It is used by applications that traditionally used libipq
	NuFW already has a working port
	Needs libnfnetlink-0.0.11

libnetfilter_conntrack-0.0.20
	ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/libnetfilter_conntrack-=
0.0.20.tar.bz2
	This is the userspace library for the ip_conntrack netlink interface
	It is currently only used by the conntrack program (see below)
	Needs libnfnetlink-0.0.11

conntrack-0.90
	ftp://ftp.netfilter.org/pub/conntrack/conntrack-0.90.tar.bz2
	The userspace connection tracking table administration program
	Needs libnetfilter_conntrack-0.0.20

btw: Anybody interested in building debian packages of the ones above?
Preferrably an 'official' debian developer, who would be able to get
those packages into unstable...

Happy firewalling,
	Harald (for the Netfilter Core Team)

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--mXDO3udm/xYWQeMQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDbQgaXaXGVTD0i/8RAnHhAJ9eV1sFI8HJpPOvKJeW1LatpvVbyQCeKNCN
R/5yCaVDFQPp9Ik56BsW3ko=
=Dhkr
-----END PGP SIGNATURE-----

--mXDO3udm/xYWQeMQ--
