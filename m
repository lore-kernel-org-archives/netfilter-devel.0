From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Wed, 29 Sep 2004 13:29:57 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1096457397.3744.21.camel@nienna.balabit>
References: <1092407190.2402.120.camel@nienna.balabit>
	<1095993739.1044.9.camel@jzny.localdomain>
	<20040925075253.GQ3236@sunbeam.de.gnumonks.org>
	<1096290473.1075.64.camel@jzny.localdomain>
	<20040927133904.GP3236@sunbeam.de.gnumonks.org>
	<1096339276.8660.30.camel@jzny.localdomain>
	<Pine.LNX.4.61.0409280834520.29563@filer.marasystems.com>
	<1096369001.8661.165.camel@jzny.localdomain>
	<1096374273.7192.27.camel@nienna.balabit>
	<Pine.LNX.4.61.0409281432550.31930@filer.marasystems.com>
	<1096376252.7192.47.camel@nienna.balabit>
	<1096377276.8661.252.camel@jzny.localdomain>
	<1096379957.1026.5.camel@jzny.localdomain>
	<Pine.LNX.4.61.0409281642500.32737@filer.marasystems.com>
	<1096383406.7192.165.camel@nienna.balabit>
	<Pine.LNX.4.61.0409281658330.32737@filer.marasystems.com>
	<1096424069.1046.84.camel@jzny.localdomain>
	<Pine.LNX.4.61.0409291000490.11661@filer.marasystems.com>
	<10964
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: hadi@znyx.com
In-Reply-To: <1096456390.1044.212.camel@jzny.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2004-09-29, sze keltez=E9ssel 13:13-kor Jamal Hadi Salim ezt =EDrta:
> Sorry, I meant symetric setup .. i.e equal looking machines with same o=
r
> similar set of addresses. Two masquareding examples:
>=20
> I:
> Machine A: internal IP: 10.0.0.1, external 1.1.1.1
> Machine B: internal IP: 10.0.0.2, external 1.1.1.2
>=20
> On failover, all addresses taken over by peer; state synced, things=20
> run as before.

  This is (almost) possible with the current code: all we should do is
to extend cts_proto to handle multiple redundancy groups at the same
time. Such a solution plus some simple VRRP-based redundancy would be
able to handle such a setup.

--=20
 Regards,
   Krisztian KOVACS
