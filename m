From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack
Date: Mon, 23 Feb 2004 14:27:10 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200402230527.OAA02726@toshiba.co.jp>
References: <200402200942.13265.tato.net@tin.it>
	<200402201258.VAA29529@toshiba.co.jp>
	<200402221110.28339.tato.net@tin.it>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: yasuyuki.kozakai@toshiba.co.jp, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: tato.net@tin.it
In-Reply-To: <200402221110.28339.tato.net@tin.it>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi,

From: Davide Guerri <tato.net@tin.it>
Date: Sun, 22 Feb 2004 11:10:28 +0100

> > > I've also downloaded the nf_conntrack patch included in your post on
> > > netfilter-devel, I've applied it to a vanilla 2.6.0 Kernel and I'm going
> > > to try it. Prior to read that code, I would ask you if it can handle
> > > mixed IPv6-IPv4 tuples.
> >
> > Thank you for using nf_conntrack. But you cannot handle mixed tuples
> > (ex. src = IPv6, dst = IPv4) in now.
> 
> Sorry, I've expressed myself badly! What I need is to change the expected 
> reply of the conntrack from an IPv4 tuple to an IPv6 tuple and vice versa. 
> Hence what I would to know is if nf_conntrack can handles original-direction 
> tuples of one type and reply-direction tuple of the other type (so that it 
> will be possible to track a "NA(P)T-PT'ed connection").

You're right. I mistook.

Please assume that initiator is IPv4 node. Likely IPv4 NAT, nf_conntrack
create conntrack which has following tuples.

          | Src	           |Dst
-------------------------------------------
          | Address | Port |Address | Port
-------------------------------------------
Original  | A4	    | a	   |B4      | b
Reply	  | B4	    | b	   |A4      | a


NA(P)T-PT module will select unique tuple, and change tuple of conntrack.

          | Src	           |Dst
-------------------------------------------
          | Address | Port |Address | Port
-------------------------------------------
Original  | A4	    | a	   |B4      | b
Reply	  | B'6	    | b    |A'6     | a'

# A4, B4   : IPv4 addr
# A'6, B'6 : IPv6 addr

nf_conntrack doesn't need to care about weather tuple has changed or not.
It just find conntrack which has tuple matched with IPv{4,6} header of packet,
and update states of it.

Handling tuple and conntrack in NA(P)T-PT are same as IPv4 NAT.
The differences are creating IPv{4,6} header and passing to other network stack.
And please care about relation of IPv4 NAT and NA(P)T-PT. These are exclusive.

> > You need to write NA(P)T-PT code based on nf_conntrack. Maybe IPv4 NAT
> > codes help you. The biggest issue is how pass packets from IPv4 stack to
> > IPv6 stack and vice versa. I imagine that addresses in packets are mangled
> > at only NF_IP{6}_PRE_ROUNTING, and then called netif_rx().
> 
> That was my first idea. But I've seen some code that makes use 
> ip_route_me_harder() + ip_output() for injecting IPv4 packets, and 
> ip6_route_me_harder() + ip6_output for IPv6 packets.
> I fear that with netif_rx() traslated packet would be tracked again, and this 
> is not what I need. (I'm sorry but I'm still studying netfilter and conntrack 
> (and English too ;) ) so it's likely that I'm wrong).

Sorry, I'm confusing. Which path should packets go through ? we need to design
so that users can filter/log packets before and/or after translating.
At least, translated packets should go through NF_IP{6}_FORWARD, I think.

> > BTW, if allowed, could you Cc to netfilter-devel for other folks who
> > interested in this area ?
> 
> I've just done it ;)

Thanks!

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
