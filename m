From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: rpfilter: skip locally generated bcast, too
Date: Tue, 16 Apr 2013 19:48:50 +0200
Message-ID: <20130416174850.GC1408@breakpoint.cc>
References: <1365799891-7731-1-git-send-email-fw@strlen.de>
 <20130416165526.GA3556@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42219 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965031Ab3DPRsv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:48:51 -0400
Content-Disposition: inline
In-Reply-To: <20130416165526.GA3556@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Florian,
> 
> > diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
> > index c301300..601abf2 100644
> > --- a/net/ipv4/netfilter/ipt_rpfilter.c
> > +++ b/net/ipv4/netfilter/ipt_rpfilter.c
> > @@ -76,7 +76,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
> >  	info = par->matchinfo;
> >  	invert = info->flags & XT_RPFILTER_INVERT;
> >  
> > -	if (par->in->flags & IFF_LOOPBACK)
> > +	if (skb_dst(skb)) /* locally generated? */
> 
> I'd prefer if this is narrowed down to locally generated traffic in
> the same way we do in nf_conntrack_broadcast.c.

Fair enough, i will change it.
