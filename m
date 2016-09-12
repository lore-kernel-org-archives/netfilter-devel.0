From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC] nftables: reverse path filtering for nft
Date: Mon, 12 Sep 2016 21:19:43 +0200
Message-ID: <20160912191943.GC11685@breakpoint.cc>
References: <20160910200102.GA11377@breakpoint.cc>
 <20160912120437.GA9323@salvia>
 <20160912122107.GB27566@breakpoint.cc>
 <20160912185228.GA10862@salvia>
 <20160912190025.GB11685@breakpoint.cc>
 <20160912191438.GA11229@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59162 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753113AbcILTTq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 15:19:46 -0400
Content-Disposition: inline
In-Reply-To: <20160912191438.GA11229@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Sep 12, 2016 at 09:00:25PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >         fib lookup ip daddr . oif
> > > 
> > > As you are basically looking for the route based on IPv4 address and
> > > the output interface, so this boils down to:
> > > 
> > >         fib lookup $expr $flags
> > 
> > How would the kernel disentangle the register data?
> 
> What I'm proposing is to represent this as a concatenation, since this
> represents the tuple that you use to look up for route.
> 
> > (i.e., how do i know where in the sreg e.g. the daddr is
> >  that i need to stuff in the flowi struct?)
> 
> You can iterate over the concatenation compound from the
> netlink_linearize path, it is just a list of expressions. Then, you
> can set the NFTA_FIB_* netlink attribute using them.

Ah, ok.  Interesting idea, I'll give this a shot.
