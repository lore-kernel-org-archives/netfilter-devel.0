From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's
 brain broke!)
Date: Thu, 15 Jan 2004 01:29:53 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401150128190.4927-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



---------- Forwarded message ----------
Date: Wed, 14 Jan 2004 23:50:44 +0100 (CET)
From: Henrik Nordstrom <hno@marasystems.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Harald Welte <laforge@netfilter.org>
Subject: Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's
    brain broke!) 

On Wed, 14 Jan 2004, Rusty Russell wrote:

> > And there are lots of users that have multiple DSL-dynip links these
> > days, trying to statically or dynamically balance web requests between
> > them, etc.
> 
> In that case, the interfaces are different, (ppp0 vs ppp1) so no
> problem.  You need something more complex to trigger the problem
> AFAICT.

Consider a firewall connected with ethernet to multiple DSL links not
using PPP-over-ethernet.

But i can not say I consider such setup sane in the DSL-dynip case, nor
how to overcome such trivial issues such as address assignment as such
setups generally use DHCP over the modem to assign the address and it is a
little hard to direct the DHCP request to the correct modem over a
broadcast ethernet.

A better case is the case of having multiple links from the same ethernet 
and wanting to SNAT based on the route taken. Masquerade with route lookup 
does this kind of magically by the route local source address field.

Hmm.. doesn't the SKB already have the route information by the time of
POSTROUTING? If so, why not simply use the route information already
there? MASQUERADE should never change the route taken, only the source
address of the packet so there should not be a need for an additional 
route lookup, and as the packet is already routed there should be no need 
to dig into the interface to find addressing informations..

I.e. why not use something like the following to find the source address 
in MASQUERADE:

    ((struct rtable*)skb->dst)->rt_src

Only worry is if there is POSTROUTING cases where skb->dst is not an
rtable (superset of dst_entry).

Regards
Henrik
