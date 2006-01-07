From: Harald Welte <laforge@netfilter.org>
Subject: [ANNOUNCE] multiple netfilter.org releases
Date: Sat, 7 Jan 2006 16:56:18 +0100
Message-ID: <20060107155618.GM4898@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rr/zTE2kOLnfAECX"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Announcement List <netfilter-announce@lists.netfilter.org>
Content-Disposition: inline
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


--Rr/zTE2kOLnfAECX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Today the netfilter project released

libnfnetlink-0.0.14
	ftp://ftp.netfilter.org/pub/libnfnetlink/libnfnetlink-0.0.14.tar.bz2
	This is the low-level communications library

libnetfilter_conntrack-0.0.30
	ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/libnetfilter_conntrack-=
0.0.30.tar.bz2
	This is the userspace library for the ip_conntrack netlink interface
	It is currently only used by the conntrack program (see below)
	Needs libnfnetlink >=3D 0.0.13

conntrack-1.00beta1
	ftp://ftp.netfilter.org/pub/conntrack/conntrack-1.00beta1.tar.bz2
	The userspace connection tracking table administration program
	Needs libnetfilter_conntrack-0.0.30

btw: Support for building debian packages is now included in the
abovementioned releases (Thanks to Max Kellermann).

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

--Rr/zTE2kOLnfAECX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDv+SiXaXGVTD0i/8RAn3SAJsHbvba4g4C0rEIfwqo6NasRLftdQCfW7V6
Mx4KsnIGSmnl7IM1R4jzEc4=
=TH07
-----END PGP SIGNATURE-----

--Rr/zTE2kOLnfAECX--
