From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC] nftables: reverse path filtering for nft
Date: Tue, 13 Sep 2016 00:46:20 +0200
Message-ID: <20160912224620.GD11685@breakpoint.cc>
References: <20160910200102.GA11377@breakpoint.cc>
 <20160912120437.GA9323@salvia>
 <20160912122107.GB27566@breakpoint.cc>
 <20160912185228.GA10862@salvia>
 <20160912190025.GB11685@breakpoint.cc>
 <20160912191438.GA11229@salvia>
 <20160912191943.GC11685@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60034 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751673AbcILWqZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 18:46:25 -0400
Content-Disposition: inline
In-Reply-To: <20160912191943.GC11685@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Sep 12, 2016 at 09:00:25PM +0200, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > >         fib lookup ip daddr . oif
> > > > 
> > > > As you are basically looking for the route based on IPv4 address and
> > > > the output interface, so this boils down to:
> > > > 
> > > >         fib lookup $expr $flags
> > > 
> > > How would the kernel disentangle the register data?
> > 
> > What I'm proposing is to represent this as a concatenation, since this
> > represents the tuple that you use to look up for route.
> > 
> > > (i.e., how do i know where in the sreg e.g. the daddr is
> > >  that i need to stuff in the flowi struct?)
> > 
> > You can iterate over the concatenation compound from the
> > netlink_linearize path, it is just a list of expressions. Then, you
> > can set the NFTA_FIB_* netlink attribute using them.
> 
> Ah, ok.  Interesting idea, I'll give this a shot.

Seems it might be better to handle this from the evaluation step
since it allows earlier error detection (e.g. use of
fib .. ip6 flowlabel from an ipv4 base for instance).

