From: Julian Anastasov <ja@ssi.bg>
Subject: Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's
 brain broke!)
Date: Thu, 15 Jan 2004 01:42:10 +0200 (EET)
Sender: linux-net-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0401150057550.1124@u.domain.uli>
References: <200401141611.TAA06882@yakov.inr.ac.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Rusty Russell <rusty@rustcorp.com.au>, fenio@o2.pl,
	davem@redhat.com, linux-net@vger.kernel.org, kaber@trash.net,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>, boris@boris.ca,
	email@cs-ware.de, Jan.Schubert@GMX.li
Return-path: <linux-net-owner@vger.kernel.org>
To: kuznet@ms2.inr.ac.ru
In-Reply-To: <200401141611.TAA06882@yakov.inr.ac.ru>
List-Id: netfilter-devel.vger.kernel.org


	Hello,

On Wed, 14 Jan 2004 kuznet@ms2.inr.ac.ru wrote:

> > Why was it wrong to specify skb->dst->dev->ifindex of the previous
> > 'real' routing decision as key to our current routing decision?
>
> Because in the situtation when ip_route_output_key() with oif=0 returns result
> different of previous ip_route_output_key() you get undefined result.
>
> I expected that you do ip_route_output_key() on _rewritten_ address,

	Nobody does output route on maddr, it is present only in 2.2

> in this case you have to _drop_ packet if routing contradicts to firewalling
> rules or to send the packet via that interface which routng requires.
> You cannot just blindly send packet to some random interface, when
> firewalling rules are illegal.

	Ah, no, you explain the 2.2 algorithm. 2.4 uses output
route only for the first packet, just to select maddr. While
2.2 uses 2nd route call by maddr for all next packets, 2.4
relies only on the routing cache for them.

	IMO, the rules should be:

1. packet should not change its outdev after routing (firewalling
expectation)

	In the discussed case, oif is provided only for the
1st packet in connection, providing oif=0 easily breaks
the above rule when multipath route is used - the input
route can return oif1 while the output route can return oif2.
Note the main thing: the goal before now was that oif is
provided to keep one packet to its outdev, not two packets
to same outdev, because:

2. different packets from one NAT connection still can be routed
through alive path (possibly different outdev) after the initial
path fails. This looks valid as long as we route by maddr which is
true for 2.2 but not for 2.4. Currently, such routing by maddr for
all next packets is not implemented in 2.4 with the excuse of
saving one routing call. With the current tools it can be done
with the cost of 2nd route call (the 1st is the input route).

	Now I'll remind you about my lsrc routing argument which
allows to route properly NAT connections by providing lsrc=maddr
in a ROUTING hook, only with single input route - a combination
from the current input and output route logic. It can be used
exactly from NAT because relying on the routing cache for binding
long living connections to its path is wrong.

	If this sounds complex, returning to the previous way
of providing oif still works better than now.

> Alexey

Regards

--
Julian Anastasov <ja@ssi.bg>
