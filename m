From: Netfilter Core Team <coreteam@netfilter.org>
Subject: [ANNOUNCE] Release of iptables-1.3.3
Date: Fri, 29 Jul 2005 15:45:29 +0200
Message-ID: <20050729134529.GA14066@sunbeam.de.gnumonks.org>
Reply-To: coreteam@netfilter.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="raC6veAxrt5nqIoY"
Cc: lwn@lwn.net
Return-path: <netfilter-bounces@lists.netfilter.org>
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


--raC6veAxrt5nqIoY
Content-Type: multipart/mixed; boundary="TakKZr9L6Hm6aLOc"
Content-Disposition: inline


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

The netfilter coreteam proudly presents:

	iptables version 1.3.3

The final 1.3.3 version contains accumulated bugfixes to the
last 1.3.2 version.  It also adds support for the upcoming (kernel
2.6.14) NFQUEUE target.

The ChangeLog is attached to this mail.

Version 1.3.3 can be obtained from:

	http://www.netfilter.org/files/iptables-1.3.3.tar.bz2
	ftp://ftp.netfilter.org/pub/iptables/iptables-1.3.3.tar.bz2

Please also note: patch-o-matic-ng is Distributed as seperate package:=20
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

--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-iptables-1.3.3.txt"

iptables v1.3.3 Changelog
======================================================================
This version requires kernel >= 2.4.0
This version recommends kernel >= 2.4.18

Bugs fixed from 1.3.2:

- Fix use-after-free in merge_options()
	[ Markus Sundberg ]

- Fix support for SNAT and DNAT to ICMP ID ranges
	[ Patrick McHardy ]

Changes from 1.3.2:

- Add support for new NFQUEUE targets for IPv4 and IPv6
	[ Harald Welte ]

- Minor manpage updates
	[ Harald Welte ]

- Fix numberous gcc-4 warnings throughout the code
	[ Harald Welte ]

Please note: Since version 1.2.7a, patch-o-matic is now no longer part of
iptables but rather distributed as a seperate package
(ftp://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot)


--TakKZr9L6Hm6aLOc--

--raC6veAxrt5nqIoY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC6jL5NfqJzMqajVsRAhIZAJ4mKktP07GDKwULlyaUw9JVHk6GhgCfaTb/
t6DckjAs20PBzhVNT+gDugM=
=zXpa
-----END PGP SIGNATURE-----

--raC6veAxrt5nqIoY--
