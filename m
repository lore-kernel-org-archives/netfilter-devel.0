From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v6 -next 2/4] netfilter: nftables: add connlabel set
 support
Date: Mon, 25 Apr 2016 14:29:33 +0200
Message-ID: <20160425122933.GE28797@breakpoint.cc>
References: <1461249284-12114-1-git-send-email-fw@strlen.de>
 <1461249284-12114-3-git-send-email-fw@strlen.de>
 <20160425103522.GB29560@macbook.localdomain>
 <20160425105909.GC28797@breakpoint.cc>
 <20160425111638.GB30849@macbook.localdomain>
 <20160425115622.GD28797@breakpoint.cc>
 <20160425121607.GA2907@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60239 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932147AbcDYM3g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 08:29:36 -0400
Content-Disposition: inline
In-Reply-To: <20160425121607.GA2907@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Different thing is to indicate the bit number from an immediate, ie.
> we use set_bit() based on the register data that we get, so we can use
> maps as Patrick suggests.

Right.

> > I don't want to resubmit until there is consensus as to what the
> > preferred solution is.
> >
> > We could go for a 3rd alternative, namely:
> > 
> > u16 bit = regs->data[priv->sreg];
> > set_bit(bit, ct->labels);
> >
> > i.e. have userspace place the _bit_ that we want to set in the
> > source register.
> > 
> > If we go for sreg that would be my favored solution.
> 
> I'm fine with this.

Ok.  Unless Patrick objects this is what I'll work on, i.e.
have nft_ct grab the bit number to toggle from the source register.

> > The only drawback vs #1 is that get and set work differently
> > (get places all labels into dreg, set expects bit to set).
> > 
> > (We also need to validate at eval time but thats not a problem
> >  in this case).
> 
> You mean a check to make sure we don't go over the boundary, just to
> avoid crashing. That seems OK to me.

Yes, thats what I meant.
