From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Tue, 28 Sep 2004 14:57:32 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1096376252.7192.47.camel@nienna.balabit>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>, hadi@cyberus.ca,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0409281432550.31930@filer.marasystems.com>
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

2004-09-28, k keltez=E9ssel 14:35-kor Henrik Nordstrom ezt =EDrta:
> > The problem could be circumvented if we statically partitioned the
> > address space between the nodes in the cluster. Unfortunately this is
> > not so simple as it sounds, since it is possible to have untranslated
> > connections using the possibly clasing tuples as well... (Maybe we co=
uld
> > apply implicit SNAT translations in this case?)
>=20
> I think for the active-active case the only viable setup is to enforce=20
> strict address separation, with the addresses used for NAT not used for=
=20
> anything else, and unique per firewall in the active-active cluster.
>=20
> This is not as bad as it sounds as the traffic needs to be partitioned =
as=20
> well. We certainly do not want to see assymetric flows in conntrack whe=
re=20
> traffic goes out via one gateway and returns on another.

  There are other solutions for that problem, for example Harald's
ClusterIP code. If we could integrate that with ct_sync we would be able
to do multi-master packet filter clusters without any load balancers
before the cluster. If the NAT core would be integrated with ClusterIP's
hash to avoid conntrack clashes we could do this without statically
assigning different NAT addresses to each node.

--=20
 Regards,
   Krisztian KOVACS
