From: Julian Anastasov <ja@ssi.bg>
Subject: Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's
 brain broke!)
Date: Mon, 12 Jan 2004 13:08:43 +0200 (EET)
Sender: linux-net-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0401121259260.3121-100000@l>
References: <4001F33A.9000802@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>, <kuznet@ms2.inr.ac.ru>,
	Rusty Russell <rusty@rustcorp.com.au>, <fenio@o2.pl>,
	<davem@redhat.com>, <linux-net@vger.kernel.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>, <boris@boris.ca>,
	<email@cs-ware.de>, <Jan.Schubert@GMX.li>
Return-path: <linux-net-owner@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4001F33A.9000802@trash.net>
List-Id: netfilter-devel.vger.kernel.org


	Hello,

On Mon, 12 Jan 2004, Patrick McHardy wrote:

> Why should we do a route lookup at all ? MASQUERADE doesn't need the
> dst_entry but only the interface address. Using ifa_list->ifa_local
> of the outgoing in_device seems like the simplest solution to me.

	Because it is possible the output interface to be used for
many logical subnets. In such cases it is desired maddr to be
the preferred source address for the target. If the users do not
want to fill the routing cache with such entries they can add
SNAT rule for each path. The drawback is that SNAT has only -o
match, there is no GW match. As result, we can not properly assign
maddr in setups that have two GWs on same output interface.

> Regards,
> Patrick

Regards

--
Julian Anastasov <ja@ssi.bg>

