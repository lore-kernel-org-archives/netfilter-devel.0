From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3 nf-next 5/7] netfilter: add and use nf_ct_set helper
Date: Mon, 23 Jan 2017 22:22:02 +0100
Message-ID: <20170123212202.GB13546@breakpoint.cc>
References: <1485174530-7678-1-git-send-email-fw@strlen.de>
 <1485174530-7678-6-git-send-email-fw@strlen.de>
 <20170123125403.GA1962@salvia>
 <20170123161026.GA13546@breakpoint.cc>
 <alpine.DEB.2.10.1701232033320.21987@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51986 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750705AbdAWVW3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Jan 2017 16:22:29 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1701232033320.21987@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > > > --- a/net/netfilter/core.c
> > > > +++ b/net/netfilter/core.c
> > > > @@ -375,7 +375,7 @@ void nf_ct_attach(struct sk_buff *new, const struct sk_buff *skb)
> > > >  {
> > > >  	void (*attach)(struct sk_buff *, const struct sk_buff *);
> > > >  
> > > > -	if (skb_nfct(skb)) {
> > > > +	if (skb->nfct) {
> > > 
> > > I guess this slipped through accidentally. No need to resent, I can
> > > amend it here.
> > 
> > Hmm, let me review this.  I thin the skb_nfct() conversion is erroneous.
> > (Q: If original is UNTRRACKED, should the reply packet that is being
> >  attached be UNTRACKED or INVALID?)
> 
> If the packet is UNTRACKED, then how can there be a reply packet from 
> conntrack point of view? In my opinion it's the user responsibility to 
> handle both directions.

afaics it would happen with this:

-t raw -j UNTRACKED
-t filter -j REJECT

REJECT target ends up calling nf_ct_attach to associate the rst/icmp
packet with original skb->nfct.

