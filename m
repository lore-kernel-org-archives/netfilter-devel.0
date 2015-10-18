From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] src: add interface wildcard matching
Date: Sun, 18 Oct 2015 21:43:30 +0200
Message-ID: <20151018194330.GB4386@breakpoint.cc>
References: <1445191336-2041-1-git-send-email-pablo@netfilter.org>
 <20151018183313.GA4386@breakpoint.cc>
 <20151018190445.GB7250@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:32939 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865AbbJRTnd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Oct 2015 15:43:33 -0400
Content-Disposition: inline
In-Reply-To: <20151018190445.GB7250@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> On 18.10, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Contrary to iptables, we use '*' as wildcard as in udev since the '+' can be
> > > used as a valid interface name.
> > 
> > '*' can also be part of an interface name, seems only '/', ':', and ' '
> > (space) are disallowed.
> > 
> > >  # nft --debug=netlink add rule test test iifname eth\*
> > >  ip test test
> > >    [ meta load iifname => reg 1 ]
> > >    [ bitwise reg 1 = (reg=1 & 0x00ffffff 0x00000000 0x00000000 0x00000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
> > >    [ cmp eq reg 1 0x2a687465 0x00000000 0x00000000 0x00000000 ]
> > 
> > Why do we need a bitwise op for this?
> > 
> > Instead we could just ask for cmp of 3 bytes ('eth' instead of 4 'eth\0')?
> > 
> > You might recall ancient RFC patch for this:
> > https://patchwork.ozlabs.org/patch/283639/
> 
> This is actually something I think should be implemented as general
> optimzation. It also applies to network address matches, where we
> can also avoid loading unnecessary data. Other cases will benefit
> from this as well.

Sorry, I'm dense.

So what you're saying is that Pablos patch with bitwise op + cmp is fine
and that you'd suggest to later add code to e.g. netlink serialize step
that checks if bitop+cmp can be replaced by a single cmp operation?
