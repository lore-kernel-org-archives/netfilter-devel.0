From: kuznet@ms2.inr.ac.ru
Subject: Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's brain broke!)
Date: Wed, 14 Jan 2004 19:11:33 +0300 (MSK)
Sender: linux-net-owner@vger.kernel.org
Message-ID: <200401141611.TAA06882@yakov.inr.ac.ru>
References: <20040111130114.GJ20706@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kuznet@ms2.inr.ac.ru, rusty@rustcorp.com.au (Rusty Russell),
	fenio@o2.pl, davem@redhat.com, linux-net@vger.kernel.org,
	kaber@trash.net,
	netfilter-devel@lists.netfilter.org (Netfilter Development Mailinglist),
	boris@boris.ca, email@cs-ware.de, Jan.Schubert@GMX.li
Return-path: <linux-net-owner@vger.kernel.org>
To: laforge@netfilter.org (Harald Welte)
In-Reply-To: <20040111130114.GJ20706@sunbeam.de.gnumonks.org> from "Harald Welte" at Jan 11, 2004 02:01:14 PM
List-Id: netfilter-devel.vger.kernel.org

Hello!

> This means that ip_route_output_key() returns a route with a different
> outgoing interface than the skb->dst->dev of our to-be-masqueraded
> packet. =20
>
> Why was it wrong to specify skb->dst->dev->ifindex of the previous
> 'real' routing decision as key to our current routing decision?

Because in the situtation when ip_route_output_key() with oif=0 returns result
different of previous ip_route_output_key() you get undefined result.

I expected that you do ip_route_output_key() on _rewritten_ address,
in this case you have to _drop_ packet if routing contradicts to firewalling
rules or to send the packet via that interface which routng requires.
You cannot just blindly send packet to some random interface, when
firewalling rules are illegal.

> As an example case where I would suspect problems: The packet could be
> coming from a local socket, and the socket be bound to a specific
> interface (sk->bound_dev_if).

This is right observation. F.e. you could use skb->sk ? skb->sk->bound_dev_if : 0.

Alexey
