From: Eric Leblond <eric@inl.fr>
Subject: Re: ip_conntrack_tuple and marks
Date: Tue, 26 Sep 2006 00:08:03 +0200
Message-ID: <1159222083.18152.12.camel@localhost.localdomain>
References: <451448A9.6000407@gmx.net>	<4515F7F8.9030000@netfilter.org>
	<4516C70A.3050502@gmx.net>	<451700B1.7070103@rtij.nl>
	<4517E205.8090807@gmx.net>  <45182332.8090303@rtij.nl>
	<1159221370.18152.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
In-Reply-To: <1159221370.18152.7.camel@localhost.localdomain>
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

Humm,

Sorry, I miss a part of the thread... forget about my previous message.

In the setup you describe and in almost all cases. The differences is in
the interfaces.
=20
Could it be a a way to differentiate the connection tracking entries ?

BR,

Le lundi 25 septembre 2006 =E0 23:56 +0200, Eric Leblond a =E9crit :
> Hi,
>=20
> Le lundi 25 septembre 2006 =E0 20:42 +0200, Martijn Lievaart a =E9crit :
> > Carl-Daniel Hailfinger wrote:
> >=20
> > >No, they are not. Let me explain:
> > >The box in question has two pairs of interfaces.
> > >eth0: 10.0.0.254/24   eth1: 10.0.1.254/24
> > >eth2: 10.0.0.254/24   eth3: 10.0.1.254/24
> > >I want to do routing and firewalling between eth0 and eth1. That's
> > >simple. However, I also want to do routing and filtering between
> > >eth2 and eth3. Although eth0 and eth2 have the same subnet, they
> > >are NOT the same network, they just happen to have identical
> > >configurations. Same goes for eth1 and eth3.
>=20
> It is more an on iproute problem.
> You could do that by using two dedicated routing tables and by setting
> carefully routing table :
>  ip rule dev eth1 lookup table eth0eth1
>  ip rule dev eth0 lookup table eth0eth1
>  ip rule dev eth2 lookup table eth2eth3
>  ip rule dev eth3 lookup table eth2eth3
>=20
> In eth0eth1 table :
> ip route add 10.0.1.0/24 iif eth1
> ip route add 10.0.0.0/24 iif eth0
>=20
> Almost same thing for eth2eth2.
>=20
> Note: syntax given of ip route and ip rule is approximative.
>=20
> BR,
>=20
> > > =20
> > >
> >=20
> > OK, it's clear to me now. I don't think you can achieve that with=20
> > current netfilter connection tracking.
> >=20
> > >/\/\/\/\/\/\/\/\    +------+   /\/\/\/\/\/\/\/\
> > >\              /    |      |   \              /
> > > | 10.0.0.0/24 |---eth0  eth1---| 10.0.1.0/24 |
> > >/              \    |      |   /              \
> > >\/\/\/\/\/\/\/\/    +------+   \/\/\/\/\/\/\/\/
> > >
> > >
> > >/\/\/\/\/\/\/\/\    +------+   /\/\/\/\/\/\/\/\
> > >\              /    |      |   \              /
> > > | 10.0.0.0/24 |---eth2  eth3---| 10.0.1.0/24 |
> > >/              \    |      |   /              \
> > >\/\/\/\/\/\/\/\/    +------+   \/\/\/\/\/\/\/\/
> > > =20
> > >
> >=20
> > Why not do it exactly like that, but with two real boxes? Makes=20
> > interconnecting later also a nobrainer (NETMAP).
> >=20
> > M4
> >=20
> >=20
>=20
>=20
