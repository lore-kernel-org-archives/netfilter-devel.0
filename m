From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Tue, 28 Sep 2004 14:24:34 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1096374273.7192.27.camel@nienna.balabit>
References: <1092407190.2402.120.camel@nienna.balabit>
	<1095993739.1044.9.camel@jzny.localdomain>
	<20040925075253.GQ3236@sunbeam.de.gnumonks.org>
	<1096290473.1075.64.camel@jzny.localdomain>
	<20040927133904.GP3236@sunbeam.de.gnumonks.org>
	<1096339276.8660.30.camel@jzny.localdomain>
	<Pine.LNX.4.61.0409280834520.29563@filer.marasystems.com>
	<1096369001.8661.165.camel@jzny.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: hadi@cyberus.ca
In-Reply-To: <1096369001.8661.165.camel@jzny.localdomain>
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

2004-09-28, k keltez=E9ssel 12:56-kor jamal ezt =EDrta:
> On Tue, 2004-09-28 at 02:46, Henrik Nordstrom wrote:
>=20
> > Lets assume you have two Active-Active gateways G and H, two clients =
A and=20
> > B and one server S. On the gateway NAT is used to masquerade all traf=
fic=20
> > to a single external IP address.
> >=20
> > Due to the Active-Active setup traffic from A goes via the gateway G =
and=20
> > traffic from B goes via H.
> >=20
> > Now you have a SYN from A,31285 to S,80 and also a SYN sent by B,3128=
5 to=20
> > S,80. You then end up with two identical NAT assignments and the two=20
> > connections will conflict with each other.
>=20
> if we even look at the 5 tuples {srcIP,DstIP, proto, srcport,dstport} w=
e
> already have a distinction, no?
> i.e in the example you provide srcIP would be different.
>=20
> I can see an issue if those 5 tuples match and you have to find
> something else to distinguish them since Linux contracking doesnt keep
> track of TCP sequence numbers and window dilations. If it did i dont se=
e
> why this would be a problem. I think i am having a hard time visualizin=
g
> when you would even need to kick in sequence number checks,

  Not necessarily. You cannot (easily) decide which conntrack the reply
packets belong to. So, in the above scenario the following is perfectly
possible:

A -------- G\
             --------S
B -------- H/

Let's suppose the SYN packages from A and B arrive to G and H
simultaneously, so that neither G nor H knows anything about the other
connection yet. When the NAT core searches for a suitable new source
address for the connection, it is possible that each node will choose
exactly the same new source IP:port pair. (Because they obviously do
uniqueness checks based only on their own conntrack state table.) And if
the two connections were destined to the same IP:port, the reply packets
for both connections will look exactly the same. In case of TCP you
could probably make guesses based on sequence numbers and such, but what
would you do in case of other protocols?

  The problem could be circumvented if we statically partitioned the
address space between the nodes in the cluster. Unfortunately this is
not so simple as it sounds, since it is possible to have untranslated
connections using the possibly clasing tuples as well... (Maybe we could
apply implicit SNAT translations in this case?)

--=20
 Regards,
   Krisztian KOVACS
