From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/3] netfilter: nft_ct: allow to set ctnetlink
 event types of a connection
Date: Sat, 15 Apr 2017 11:44:39 +0200
Message-ID: <20170415094439.GB1707@breakpoint.cc>
References: <20170415084505.26176-1-fw@strlen.de>
 <20170415084505.26176-2-fw@strlen.de>
 <20170415090945.GA4023@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56912 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752028AbdDOJps (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 05:45:48 -0400
Content-Disposition: inline
In-Reply-To: <20170415090945.GA4023@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I wonder if this should go in a oneliner, given this is fixing the
> fact that we may end up using the template. So someone has a chance to
> pass it to -stable. I'll be fine either way, no problem.

Ok. will do.

> > +#ifdef CONFIG_NF_CONNTRACK_EVENTS
> > +	case NFT_CT_EVENTMASK: {
> > +		struct nf_conntrack_ecache *e = nf_ct_ecache_find(ct);
> > +		u16 ctmask = (u16)regs->data[priv->sreg];
> 
> Liping added helpers to fetch data from registers, I think it
> applies to this case too.

Right, I forgot about this, thanks for noticing.
Having such huge backlog is crap, I won't do this again, ever :(
