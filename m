From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: remove redundant skb check in
 nf_conntrack_put_reasm
Date: Thu, 20 Jun 2013 16:15:37 +0200
Message-ID: <20130620141537.GH2124@breakpoint.cc>
References: <20130619142735.GA2758@gmail.com>
 <20130620092259.GD2124@breakpoint.cc>
 <20130620095846.GA19504@localhost>
 <20130620000135.GB819@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37007 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030216Ab3FTOPj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:15:39 -0400
Content-Disposition: inline
In-Reply-To: <20130620000135.GB819@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester <kernel@linuxace.com> wrote:
> On Thu, Jun 20, 2013 at 11:58:46AM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Jun 20, 2013 at 11:22:59AM +0200, Florian Westphal wrote:
> > > Phil Oester <kernel@linuxace.com> wrote:
> > > > kfree_skb already checks for skb existence - remove redundant check from
> > > > nf_conntrack_put_reasm.
> > > 
> > > This is called for every free'd skb, in almost all cases
> > > the condition will be false.
> > > 
> > > So I think its ok to keep this check.
> > 
> > I see, we'll hit branch mispredictions most of the time. I have kept
> > this back. Thanks Florian.
> 
> If we're concerned about branch mispredictions, we should change the check to
> match the one at the top of kfree_skb:
>         if (unlikely(!skb))
>                 return;

Its the opposite.  For kfree_skb skb is (virtually) never NULL.

> However nf_conntrack_put_reasm is only used in 3 places in the entire tree.
> Unclear why we don't just call kfree_skb directly in these 3 places.

I guess what you could do is s/nf_conntrack_put_reasm/kfree_skb/g and
also change skb_release_head_state() to use

#ifdef NET_SKBUFF_NF_DEFRAG_NEEDED
        if (skb->nfct) /* usually NULL */
	        kfree_skb(skb->nfct);
#endif

[ or show that there is no performance degradation for workloads where
  we end up calling kfree_skb(NULL) in hot path ]
