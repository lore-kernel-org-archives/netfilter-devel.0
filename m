From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: nft_ct: fix expiration getter
Date: Fri, 8 Jul 2016 16:54:00 +0200
Message-ID: <20160708145400.GB20973@breakpoint.cc>
References: <1467809586-15950-1-git-send-email-fw@strlen.de>
 <20160708125646.GA23652@salvia>
 <20160708132543.GA23868@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34922 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754180AbcGHOyH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jul 2016 10:54:07 -0400
Content-Disposition: inline
In-Reply-To: <20160708132543.GA23868@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Jul 08, 2016 at 02:56:46PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Jul 06, 2016 at 02:53:06PM +0200, Florian Westphal wrote:
> > > We need to compute timeout.expires - jiffies, not the other way around.
> > > Add a helper, another patch can then later change more places in
> > > conntrack code where we currently open-code this.
> > >
> > > Will allow us to only change one place later when we remove per-ct timer.
> > 
> > Applied, thanks.
> 
> I just realized that this is broken from userspace, look:
> 
> # nft --debug=netlink add rule x y ct expiration 10s
> ip x y
>   [ ct load expiration => reg 1 ]
>   [ cmp eq reg 1 0x0000000a ]
> 
> <cmdline>:1:1-30: Error: Could not process rule: No such file or
> directory
> add rule x y ct expiration 10s
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> jiffies_to_msecs() returns milliseconds, but userspace uses seconds.

Ack, thanks for catching this.
I only tested that 'ct expiration gt 0' was matching :-/
