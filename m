From: Dave Johnson <dave-kernel@centerclick.org>
Subject: Re: [PATCH] netfilter: Wrong icmp6 checksum for ICMPV6_TIME_EXCEED
 in reverse SNATv6 path
Date: Mon, 24 Apr 2017 09:10:15 -0400
Message-ID: <22781.63799.889356.82121@gargle.gargle.HOWL>
References: <22774.51265.265373.257836@gargle.gargle.HOWL>
        <22776.44325.616928.335465@gargle.gargle.HOWL>
        <20170424084312.GA3597@salvia>
        <22781.62083.680363.165680@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lexington.centerclick.org ([45.32.7.34]:35253 "EHLO
        lexington.centerclick.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1170832AbdDXNSz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Apr 2017 09:18:55 -0400
In-Reply-To: <22781.62083.680363.165680@gargle.gargle.HOWL>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso writes:
> On Thu, Apr 20, 2017 at 08:44:21AM -0400, Dave Johnson wrote:
> > 
> > When recalculating the outer ICMPv6 checksum for a reverse path NATv6
> > such as ICMPV6_TIME_EXCEED nf_nat_icmpv6_reply_translation() was
> > accessing data beyond the headlen of the skb for non-linear skb.  This
> > resulted in incorrect ICMPv6 checksum as garbage data was used.
> > 
> > Signed-off-by: Dave Johnson <dave-kernel@centerclick.org>
> > ---
> > diff -rup linux-4.9.23.orig/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c linux-4.9.23/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
> > --- linux-4.9.23.orig/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c	2017-04-18 01:12:30.000000000 -0400
> > +++ linux-4.9.23/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c	2017-04-20 08:13:41.070493666 -0400
> > @@ -229,7 +229,12 @@ int nf_nat_icmpv6_reply_translation(stru
> >  		return 0;
> >  
> >  	if (skb->ip_summed != CHECKSUM_PARTIAL) {
> > -		struct ipv6hdr *ipv6h = ipv6_hdr(skb);
> > +		struct ipv6hdr *ipv6h;
> > +
> > +		if (!skb_make_writable(skb, skb->len))
> 
> can we just make sure what we need is linear? I mean, just the ipv6
> header that is what we need, instead of the entire skbuff.

the checksum below those lines is across the entire skb as unknown
updates were done in the l4 manip call just prior to this.

nf_nat_icmp_reply_translation() for ipv4 uses skb_checksum() to walk
non-linear skbs.  gave that a try and it works, will send an updated
patch in a bit.
