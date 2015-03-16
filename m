From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: iptables at scale
Date: Tue, 17 Mar 2015 09:52:32 +1300
Message-ID: <20150317095232.23a153e9@redhat.com>
References: <SNT152-W61FA9088D57B93B1B5C878B8190@phx.gbl>
	<CAJ26g5SeC-shnX+PT2nijqJMLk45zg8VVqvEVk7xG-6r7XgP-w@mail.gmail.com>
	<SNT152-W53EABE020E8B236DF21FE0B8190@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: brouer@redhat.com,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Glen Miner <shaggie76@hotmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbbCPUwj convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2015 16:52:39 -0400
In-Reply-To: <SNT152-W53EABE020E8B236DF21FE0B8190@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 11 Mar 2015 17:27:35 -0400
Glen Miner <shaggie76@hotmail.com> wrote:

> >> What it does: makes UDP NAT proxies so people with strict-NAT or=20
> > multi-layer NAT can communicate. This essentially works out to be 4=
=20
> > iptables rules created for a pair of peers. They talk to our server=
 and=20
> > our server makes it look like they're talking to each other; fighti=
ng=20
> > bad NAT with our NAT is somewhat ironic but it's quite elegant.=20
> >=20
> > What exactly are these four rules, and what do they accomplish?=C2=A0
>=20
> aAddr : aPort is player A's real ip : port
> bAddr : bPort=C2=A0is=C2=A0player B's=C2=A0real=C2=A0ip=C2=A0: port
> nAddr : anPort is what player B uses to talk to A
> nAddr : bnPort is what player A uses to talk to B
>=20
> echo "*nat
> :PREROUTING - [0:0]
> -I PREROUTING -p udp -s $aAddr --sport $aPort -d $nAddr --dport $bnPo=
rt -j DNAT --to $bAddr:$bPort
> -I PREROUTING -p udp -s $bAddr --sport $bPort -d $nAddr --dport $anPo=
rt -j DNAT --to $aAddr:$aPort
> :POSTROUTING - [0:0]
> -A POSTROUTING -p udp -s $aAddr --sport $aPort -d $bAddr --dport $bPo=
rt =C2=A0-j SNAT --to $nAddr:$anPort
> -A POSTROUTING -p udp -s $bAddr --sport $bPort -d $aAddr --dport $aPo=
rt =C2=A0-j SNAT --to $nAddr:$bnPort
> COMMIT
> " | iptables-restore --noflush

It looks like you will have a very long list of rules in PREROUTING and
POSTROUTING.  You will likely have a scalability issues due to this, as
iptables will process these rules linear.  Thus, as you add more rules,
the overhead per packet increase.  You are basically shooting yourself
in the foot, by building your ruleset like this.

I solved the iptables update speed back in 2007-2008, and also had a
method for building a subnet-skeleton search tree with iptables chains,
what reduced the lookup complexity from O(n) to O(log N).

See my user-presentation:
 http://people.netfilter.org/hawk/presentations/nfws2008/nfws2008_userd=
ay_iptables_scale.pdf

See my developer presentation:
 http://people.netfilter.org/hawk/presentations/nfws2008/nfws2008_devel=
opers_iptables_scale.pdf

The iptables update speed, I on-purpose "only" fixed for
chain-lookups.  I left-in the scalability problem of updating a very
long list-of-rules in a single chain, because if someone would do that
(like you) they should experience this slowdown, and hopefully stop to
think about weather they are doing some thing wrong, like you ;-).  (As
you are only inserting or adding rules, not adding or deleting rules in
the middle of the chain, you are not hitting the really bad parts).


> > You won't be happy changing iptables rules on the fly for each=C2=A0
> > customer. Hire somebody who can program in C, point them at the=20
> > iptables kernel NAT module implementation, and maybe ipset, and get=
=20
> > them hacking away at a solution that works without table manipulati=
on.=20
>=20
> I can program in C; like I said: I translated the above command +
> some conntrack junk to direct function calls to skip process creation
> and parsing logic for 20x better performance. However, it's not
> really clear where I'd go instead short of reinventing iptables /
> conntrack and lord knows what else. Are you suggesting I write my own
> kernel hooks?

With my experience today, I would probably have written a simple
netfilter/iptables module that would do the work, having a hash-table
to match my rules, and be externally configurable via netlink messages
(to add and remove customers).  (Which is basically what Jan said about
hiring somebody with experience).

Today, we have nftables.  I'm not very experienced with nftables, but I
think that you problem might be solvable by using nftables "set"
functionality.  Reducing your entire ruleset to 4 nftables "set" rules.

A third option, is using conntrack-tools [1], like Jan also mentioned.
[1] http://netfilter.org/projects/conntrack-tools/index.html

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
