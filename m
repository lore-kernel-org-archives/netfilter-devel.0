From: Julian Anastasov <ja@ssi.bg>
Subject: Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's
 brain broke!)
Date: Tue, 13 Jan 2004 10:21:14 +0200 (EET)
Sender: linux-net-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0401130958420.1208@u.domain.uli>
References: <20040112234710.1B13C2C0C4@lists.samba.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Harald Welte <laforge@netfilter.org>, kuznet@ms2.inr.ac.ru,
	fenio@o2.pl, davem@redhat.com, linux-net@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>, boris@boris.ca,
	email@cs-ware.de, Jan.Schubert@GMX.li
Return-path: <linux-net-owner@vger.kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20040112234710.1B13C2C0C4@lists.samba.org>
List-Id: netfilter-devel.vger.kernel.org


	Hello,

On Mon, 12 Jan 2004, Rusty Russell wrote:

> > Why should we do a route lookup at all ? MASQUERADE doesn't need the
> > dst_entry but only the interface address. Using ifa_list->ifa_local
> > of the outgoing in_device seems like the simplest solution to me.
>
> You take all the fun out.

	Selecting link local addresses is not always a fun :)
The IP addresses are sorted by their scope.

> Yes, this is the best.  It always does *something*, and is
> predictable.  People with really complex routing shouldn't really use
> MASQUERADE, since it's designed for a specific, simple case.

	Don't do that for 2.4, the users will not be happy.
There are setups with non-default multipath routes, multipath
routes with nexthops sharing same outdev, WAN interfaces which
have their private link layer IPs at first position.

	MASQUERADE is better for some cases where SNAT can
not be used at all: using source address autoselection based
on the scope and the nexthop's GW IP.

	I vote for backing out the oif change and to return
to the previous state - the routing is still smarter than any
iptables rules.

> Cheers,
> Rusty.

Regards

--
Julian Anastasov <ja@ssi.bg>
