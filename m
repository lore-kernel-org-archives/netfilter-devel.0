From: Amin Azez <azez@ufomechanic.net>
Subject: RE: xt_gateway 20070605 (kernel)
Date: Wed, 6 Jun 2007 08:01:05 +0100
Message-ID: <200706060821.l568L3v03553@server1.secure-linux-server.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Amin Azez <azez@ufomechanic.net>
To: Phil Oester <kernel@linuxace.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

I apologise again for top-posting and all the sins of pocket outlook quotin=
g.

As best as I can recall without the source in front of me a route cache ite=
m attached to the skb on routing is cast to a neighbour table entry. (they =
are the same waist up).=20

There is no way at forward or postrouting time to tell if the skb's attache=
d neighbour table member is (was once) a route cache entry or just a plain =
neighbour table entry.

This means it is not safe (hard to know when it is safe) to cast it back to=
 a route cache item to match what you need.

Perhaps yours is a case to use realm match as Patrick has mentioned.

What you want requires a change to the routing code so that it leaves evide=
nce that the next hop is a route entry.

BTW the ROUTE target doesn't route so much as transmit. I hope to alter it =
so that in PREROUTING (or later) it actually adds a route to the skb, so th=
at postrouting will work.

Sam

-----Original Message-----
From: "Phil Oester" <kernel@linuxace.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Cc: "Amin Azez" <azez@ufomechanic.net>; "Netfilter Developer Mailing List" =
<netfilter-devel@lists.netfilter.org>
Sent: 05/06/07 23:24
Subject: Re: xt_gateway 20070605 (kernel)

On Tue, Jun 05, 2007 at 01:17:57PM +0200, Jan Engelhardt wrote:
>=20
> Originally from Amin Azez <azez@ufomechanic.net>,
> http://lists.netfilter.org/pipermail/netfilter-devel/2007-June/027954.htm=
l
>=20
> This adds a gateway match to iptables that lets you match against the
> routed ipv4 gateway, it's very useful for SNAT if you want to avoid
> replicating your routing in your SNAT table.

Just a suggestion...for a while I've been needing the ability to match
on the routing table (but not just the gateway).  Could we perhaps name
this match 'route' instead (similar to the ROUTE target)?

Some of the things I'd like to be able to do is match on the length
of a route.  For instance we use lots of 10.x.x.x/30 nets internally
and I'd like to be able to match on them.  I haven't quite gotten around
to figuring out how to do this given the route cache doesn't include
prefix length, but I do think it would be useful.  I could see how
it could be combined with this gateway match.

Thoughts?

Phil
