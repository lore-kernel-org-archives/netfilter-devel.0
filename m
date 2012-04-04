From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: conntrack: drop malformed IPv4 packets
Date: Wed, 4 Apr 2012 17:14:46 +0200
Message-ID: <20120404151446.GB4148@1984>
References: <1333481769-16747-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1333481769-16747-2-git-send-email-kadlec@blackhole.kfki.hu>
 <1333482079.18626.323.camel@edumazet-glaptop>
 <20120404112339.GA3319@1984>
 <alpine.DEB.2.00.1204041357510.20388@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41232 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756686Ab2DDPOz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Apr 2012 11:14:55 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1204041357510.20388@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 04, 2012 at 02:07:45PM +0200, Jozsef Kadlecsik wrote:
> On Wed, 4 Apr 2012, Pablo Neira Ayuso wrote:
> 
> > On Tue, Apr 03, 2012 at 09:41:19PM +0200, Eric Dumazet wrote:
> > > On Tue, 2012-04-03 at 21:36 +0200, Jozsef Kadlecsik wrote:
> > > > It was reported that the Linux kernel sometimes logs:
> > > > 
> > > > klogd: [2629147.402413] kernel BUG at net / netfilter /
> > > > nf_conntrack_proto_tcp.c: 447!
> > > > klogd: [1072212.887368] kernel BUG at net / netfilter /
> > > > nf_conntrack_proto_tcp.c: 392
> > > > 
> > > > ipv4_get_l4proto() in nf_conntrack_l3proto_ipv4.c and tcp_error() in
> > > > nf_conntrack_proto_tcp.c should catch malformed packets, so the errors
> > > > at the indicated lines - TCP options parsing - should not happen.
> > > > However, tcp_error() relies on the "dataoff" offset to the TCP header,
> > > > calculated by ipv4_get_l4proto().  But ipv4_get_l4proto() does not check
> > > > bogus ihl values in IPv4 packets, which then can slip through tcp_error()
> > > > and get caught at the TCP options parsing routines.
> > > > 
> > > > The patch fixes ipv4_get_l4proto() by dropping packets with bogus
> > > > ihl value.
> > > > 
> > > > The patch closes netfilter bugzilla id 771.
> > > > 
> > > > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > > > ---
> > > >  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    8 ++++++++
> > > >  1 files changed, 8 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> > > > index de9da21..c93d052 100644
> > > > --- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> > > > +++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> > > > @@ -84,6 +84,14 @@ static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
> > > >  	*dataoff = nhoff + (iph->ihl << 2);
> > > >  	*protonum = iph->protocol;
> > > >  
> > > > +	/* Check bogus IP headers */
> > > > +	if (*dataoff > skb->len) {
> > > > +		pr_debug("nf_conntrack_ipv4: drop bogus IPv4 packet: "
> > > > +			 "nhoff %u, ihl %u, skblen %u\n",
> > > > +			 nhoff, iph->ihl << 2, skb->len);
> > > > +		return -NF_ACCEPT;
> > > 
> > > 		return -NF_DROP; ?
> > 
> > The connection tracking system should not drop packets. Well, we
> > sometimes do in special cases.
> > 
> > I think -NF_ACCEPT is fine, the user can add one rule to drop INVALID
> > packets (like this one) from iptables.
> 
> That's a nontrivial question and currently we are inconsistent: in 
> ipv4_get_l4proto() we drop all broken packets (IP header is incomplete or 
> fragments) and the condition above just adds a third category. However, in 
> ipv6_get_l4proto() we simply mark them as INVALID and in tcp_error() we do 
> the same.

Thanks for spotting that.

> So, should we convert ipv4_get_l4proto() to mark all broken packets as 
> INVALID?

Yes, I think we should stick to -NF_ACCEPT so we let the user drop the
packet via iptables.

BTW, if you send a follow-up patch for this, it would be also good to
log invalid packets in ipv4_get_l4proto. There's no nf_log_packet
invocation for these.
