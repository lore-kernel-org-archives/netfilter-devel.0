From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Tue, 28 Sep 2004 20:04:25 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040928180425.GA21097@zion.homelinux.com>
References: <Pine.LNX.4.61.0409280834520.29563@filer.marasystems.com>
	<1096369001.8661.165.camel@jzny.localdomain>
	<1096374273.7192.27.camel@nienna.balabit>
	<Pine.LNX.4.61.0409281432550.31930@filer.marasystems.com>
	<1096376252.7192.47.camel@nienna.balabit>
	<1096377276.8661.252.camel@jzny.localdomain>
	<1096379957.1026.5.camel@jzny.localdomain>
	<Pine.LNX.4.61.0409281642500.32737@filer.marasystems.com>
	<1096383406.7192.165.camel@nienna.balabit>
	<Pine.LNX.4.61.0409281658330.32737@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Cc: Harald Welte <laforge@netfilter.org>, Jamal Hadi Salim <hadi@znyx.com>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0409281658330.32737@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Henry, hi list members,

On Tue, Sep 28, 2004 at 05:07:50PM +0200, Henrik Nordstrom told us:
> And the flow question of existing connections is also not such big proble=
m=20
> as all you need is to look up the connection in conntrack and if not=20
> master you either drop the packet (multicast forwarding model) or=20
> request to become master of the connection (unicast forwarding model).=20
> The multicast forwarding model is a lot easier to implement but does not=
=20
> scale as well as all nodes need to see all traffic and drop the traffic=
=20
> for which they are not master.

just jumping in here:

Shouldn't a node be able to handle a connection for which it isn't the mast=
er?? Say,
if we have just one public IP address, we must divide our source ports for =
NAT into,
say N parts for N firewall cluster nodes. Now, shouldn't the division of th=
e ports
just be to avoid ambiguous tuples on the cluster at connection (NAT) setup =
time?? If
a node got an update for a tuple, then it should be able to handle this con=
nection
fully, no??

Ok, now (2 seconds ago :) it just made 'click' in my brain. This of course =
only
applies when it is guaranteed that one (reply) packet is seen by only one n=
ode in
our firewall cluster.  Of course, when we have some kind of multicasting so=
 that
each node will see all the traffic, this won't work and we have to make sur=
e that
only one node (preferrably the master of this connection) is handling the p=
acket.
But, as you wrote, multicasting does not scale as well as unicast. And when=
 using
multicast, we also would have to make sure that the initial packet which ca=
uses
a new connection to be set up is handled by only one node...how??


just my foggy thoughts and some interesting open questions to think about :=
-)

Sven

>=20
> This moves the "clusterIP" decision to after the conntrack lookup but=20
> before creating new conntrack sessions.
>=20
> Regards
> Henrik
>=20

--=20
Linux zion 2.6.9-rc1-mm4 #1 Tue Sep 7 12:57:19 CEST 2004 i686 athlon i386 G=
NU/Linux
 19:46:21  up 2 days, 18:59,  2 users,  load average: 0.03, 0.02, 0.02

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFBWaepo4FAdB2PneQRAoTqAJ9RuaK1lm3/dKAgjMShGxHA3hCcKgCdERgQ
Mm7CXLQ9r3wLhZCcKNQx8n8=
=S0mU
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
