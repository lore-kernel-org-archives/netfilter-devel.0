From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Tue, 28 Sep 2004 14:11:45 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1096373505.7192.14.camel@nienna.balabit>
References: <1092407190.2402.120.camel@nienna.balabit>
	<1095993739.1044.9.camel@jzny.localdomain>
	<20040925075253.GQ3236@sunbeam.de.gnumonks.org>
	<1096290473.1075.64.camel@jzny.localdomain>
	<20040927133904.GP3236@sunbeam.de.gnumonks.org>
	<1096339276.8660.30.camel@jzny.localdomain>
	<Pine.LNX.4.61.0409280834520.29563@filer.marasystems.com>
	<876ef97a0409280458228a7509@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: nf-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tobias DiPasquale <codeslinger@gmail.com>
In-Reply-To: <876ef97a0409280458228a7509@mail.gmail.com>
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

2004-09-28, k keltez=E9ssel 13:58-kor Tobias DiPasquale ezt =EDrta:
> On Tue, 28 Sep 2004 08:46:25 +0200 (CEST), Henrik Nordstrom
> <hno@marasystems.com> wrote:
> > No, this is about a different issue entirely.
> >=20
> > Lets assume you have two Active-Active gateways G and H, two clients =
A and
> > B and one server S. On the gateway NAT is used to masquerade all traf=
fic
> > to a single external IP address.
> >=20
> > Due to the Active-Active setup traffic from A goes via the gateway G =
and
> > traffic from B goes via H.
> >=20
> > Now you have a SYN from A,31285 to S,80 and also a SYN sent by B,3128=
5 to
> > S,80. You then end up with two identical NAT assignments and the two
> > connections will conflict with each other.
>=20
> Why use NAT at all for active-active? Its pretty slow in comparison to
> the shared MAC/IP schema delineated at UltraMonkey.org:
>=20
> http://www.ultramonkey.org/papers/active_active/active_active.shtml
>=20
> Am I missing something? Is NAT required for some reason?

  Ok, but this is not redirector failover, ct_sync is simply a general
purpose conntrack state replication solution. And as such, it should be
able to handle NAT-related conntrack data as well. If you have a
multi-master (load balancing) packet filter cluster it still has to be
able to do anything you can do with a single node.

--=20
 Regards,
   Krisztian KOVACS
