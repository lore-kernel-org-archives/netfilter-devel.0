From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Tue, 28 Sep 2004 22:57:23 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040928205723.GA23352@zion.homelinux.com>
References: <1096374273.7192.27.camel@nienna.balabit>
	<Pine.LNX.4.61.0409281432550.31930@filer.marasystems.com>
	<1096376252.7192.47.camel@nienna.balabit>
	<1096377276.8661.252.camel@jzny.localdomain>
	<1096379957.1026.5.camel@jzny.localdomain>
	<Pine.LNX.4.61.0409281642500.32737@filer.marasystems.com>
	<1096383406.7192.165.camel@nienna.balabit>
	<Pine.LNX.4.61.0409281658330.32737@filer.marasystems.com>
	<20040928180425.GA21097@zion.homelinux.com>
	<Pine.LNX.4.61.0409282042150.2167@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Cc: Harald Welte <laforge@netfilter.org>, Jamal Hadi Salim <hadi@znyx.com>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0409282042150.2167@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Henrik,

On Tue, Sep 28, 2004 at 08:47:15PM +0200, Henrik Nordstrom told us:
> >And when using multicast, we also would have to make sure that the=20
> >initial packet which causes a new connection to be set up is handled by=
=20
> >only one node...how??
>=20
> By hashing of the original tuple, dividing the address space among the=20
> currently active firewalls.
>=20
>=20
> The main problem for unicast active-active firewalls is how to handle loa=
d=20
> distribution, failover and recovery in an sane manner without requiring a=
=20
> load balancer infront of the firewalls.

I just thought about this all some more the last few hours and came to
kind of like the same conclusions. While unicast clustering surely
might be more scalable because each node just sees the traffic it is
responsible for, the problem is that the whole traffic must be split
before the firewall cluster. So one would need another special high tech
don't-know-what switch or something like that, so another possible point
of failure...with multicasting, this won't be a problem, as the traffic
will be automagically distruted among the nodes. And if one of the nodes
goes down for some reason, the other nodes will also take over this
nodes' traffic as soon as they realize this nodes' failure and so one of
the hashing function's parameters is adjusted to represent the new
situation...!?


Thanks for enlightening my, Henrik :-)

Sven

>=20
> Regards
> Henrik

--=20
Linux zion 2.6.9-rc1-mm4 #1 Tue Sep 7 12:57:19 CEST 2004 i686 athlon i386 G=
NU/Linux
 22:41:48  up 2 days, 21:55,  2 users,  load average: 0.10, 0.04, 0.01

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFBWdAzo4FAdB2PneQRAqlqAJ9SzHKlCSqyT9wT2+PtfgQ3DdUIpACeN8rm
dZjB4n4uvOgpuP/J/GerP1I=
=AmbX
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
