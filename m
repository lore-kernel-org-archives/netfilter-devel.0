From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: (no subject)
Date: Wed, 16 Feb 2005 12:26:33 +0100
Message-ID: <1108553193.3685.7.camel@nienna.balabit>
References: <20050215210947.32682.qmail@ad.mailbox.hu>
	<Pine.LNX.4.58.0502160910450.16487@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
In-reply-to: <Pine.LNX.4.58.0502160910450.16487@blackhole.kfki.hu>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
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


  Hi,

2005-02-16, sze keltez=E9ssel 09.14-kor Jozsef Kadlecsik ezt =EDrta:
> > To be short, my problem is the following:
> > I must track outgoing SYN+ACK packets (confirmation of connection
> > request) and incoming ACK packets acknowledging the SYN+ACKs. Wit=
h this,
> > the module would be able to calculate the ratio of half open
> > connections.
> > It is easy to track outgoing SYN+ACKs, but to decide if an incomi=
ng ACK
> > is a response to a former SYN+ACK I have to track the state of th=
e TCP
> > connection. Of course I dont want to do this, because the TCP con=
ntrack
> > module makes this - It would be a nonsense and a source of incons=
istency
> > to track the state in both modules.
>=20
> You could rely on event notification from the nfnetlink-ctnetlink-0=
.13
> patch from patch-o-matic-ng. Unfortunately it seems to me
> nfnetlink-ctnetlink's a little bit out of sync compared to the rece=
nt
> kernel trees.

  The event notification part of ctnetlink is available for 2.6 kerne=
ls
as well (from the netfilter-ha patchset, for example), thanks to Pabl=
o
Neira's work.

--=20
KOVACS Krisztian <hidden@sch.bme.hu>
