From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 4/5] netfilter: nfnetlink_queue: add skb info attribute
Date: Tue, 16 Apr 2013 19:47:51 +0200
Message-ID: <20130416174751.GB1408@breakpoint.cc>
References: <1366126328-25874-1-git-send-email-fw@strlen.de>
 <1366126328-25874-5-git-send-email-fw@strlen.de>
 <1366127722.4459.139.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42216 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965043Ab3DPRrw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:47:52 -0400
Content-Disposition: inline
In-Reply-To: <1366127722.4459.139.camel@edumazet-glaptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Tue, 2013-04-16 at 17:32 +0200, Florian Westphal wrote:
> > Once we allow userspace to receive gso/gro packets, userspace
> > needs to be able to determine when checksums appear to be
> > broken, but are not.
> > 
> > NFQA_SKB_CSUMNOTREADY means 'checksums will be fixed in kernel
> > later, pretend they are ok'.
> > 
> > NFQA_SKB_GSO could be used for statistics, or to determine when
> > packet size exceeds mtu.

[..]

> > +static int nfqnl_put_packet_info(struct sk_buff *nlskb, struct sk_buff *packet)
> > +{
> > +	__u32 flags = 0;
> > +
> > +	if (skb_is_gso(packet))
> > +		flags = NFQA_SKB_GSO;
>  
> > +	if (packet->ip_summed == CHECKSUM_PARTIAL)
> > +		flags |= NFQA_SKB_CSUMNOTREADY;
> > +
> > +	return nla_put_be32(nlskb, NFQA_SKB_INFO, htonl(flags));
> 
> Maybe you could avoid sending NFQA_SKB_INFO if flags == 0 ?

Sure, will change it in the next round.
