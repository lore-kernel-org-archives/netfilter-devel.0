From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: iptables bug using dhcpd3 on debian sarge 2.6.8
Date: Thu, 10 Mar 2005 10:35:30 +0100
Message-ID: <20050310093529.GA16672@zion.homelinux.com>
References: <6642317$1110205335422c6397f21926.15822394@config8.schlund.de>
	<422DC8B7.6060801@trash.net> <423000F1.2040802@rhcs.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Cc: netfilter-devel@lists.netfilter.org
To: richard hauswald <staenker@rhcs.de>
Content-Disposition: inline
In-Reply-To: <423000F1.2040802@rhcs.de>
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


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Richard,

On Thu, Mar 10, 2005 at 09:10:25AM +0100, richard hauswald told us:
> Patrick McHardy wrote:
>=20
> >
> >ISC DHCP uses AF_PACKET sockets on Linux by default, which receive
> >packets before iptables. There are some compile-time options to make it
> >use normal UDP sockets.
> >
> >Regards
> >Patrick
> >
> Thanks for that tip. But is this good or bad? I mean if i where a trojan=
=20
> programmer, couldn't i use these AF_PACKET sockets to code an iptables=20
> passing trojan?
> I'm not good programming networkstuff, so excuse my simple question.

as far as I know (and from reading the kernel source), for using
AF_PACKET sockets, you need the CAP_NET_RAW capability or you need to
be root, so in most setups (where probably no capabilities are used)
you need to be root. And when you (or a trojan) has root privileges,
it might as well alter the iptables rule set to allow its network
traffic going out...please anybody correct me if I'm wrong.


Sven

>=20
> Regards
> Richard Hauswald
>=20
>=20

--=20
Linux zion 2.6.11-mm1 #1 Mon Mar 7 11:17:40 CET 2005 i686 athlon i386 GNU/L=
inux
 10:30:33 up 10:51,  1 user,  load average: 0.14, 0.04, 0.01

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFCMBTho4FAdB2PneQRAri8AJ4xAKD7465sbcqYVT/X2HpcPxAAbQCfbTR3
z1WiR5w4N0Ym2SdrcLkIgx0=
=dPtO
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
