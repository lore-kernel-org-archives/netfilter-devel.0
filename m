From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Tue, 28 Sep 2004 16:56:46 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1096383406.7192.165.camel@nienna.balabit>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>, Jamal Hadi Salim <hadi@znyx.com>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0409281642500.32737@filer.marasystems.com>
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

2004-09-28, k keltez=E9ssel 16:46-kor Henrik Nordstrom ezt =EDrta:
> Any controlled division of the tuple address space would solve the=20
> NAT problem.
>=20
> I would use IP addresses in this scheme.. it is very nice to have NAT a=
s=20
> non-intrusive as possible preserving what can be preserved of the origi=
nal=20
> tuple.

  Definitely. However, I don't see how it would be possible to use
MASQUERADE and a single public IP in this case. If you use the complete
reply tuple and some hash function to avoid two nodes using the same
reply tuple that would be a bit more capable. (Similar to that Jamal is
saying: the unique tuple allocation code would take care of allocating a
tuple whose hash value the node "owns". This part would be really
similar to ClusterIP.)

> There remains some delicate thinking on how to manage the traffic flows=
 in=20
> a sane manner to make sure the correct traffic is forwarded by the corr=
ect=20
> node, considering failovers, recoveries etc.

  Yes, of course. Full re-sync would be a somewhat more complicated
problem as well. But if we maintain some per-conntrack mark indicating
which node "owns" that entry, then even full re-sync could be
implemented quite easily: each node dumps all entries it is responsible
for. The protocol itself should be extended as well, we would need
per-node sequence numbers and per-node recovery requests.

--=20
 Regards,
   Krisztian KOVACS
