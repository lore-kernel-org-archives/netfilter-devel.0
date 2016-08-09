From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCH v2] netfilter: nft_nth: match every n packets
Date: Tue, 9 Aug 2016 16:13:40 +0200
Message-ID: <20160809141339.GA6805@sonyv>
References: <20160727220053.GA26643@sonyv>
 <20160727230105.GC2565@breakpoint.cc>
 <20160728074252.GA28885@sonyv>
 <20160728092059.GD2565@breakpoint.cc>
 <20160809105253.GA11493@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35788 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbcHIONo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Aug 2016 10:13:44 -0400
Received: by mail-wm0-f67.google.com with SMTP id i5so3372970wmg.2
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Aug 2016 07:13:44 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160809105253.GA11493@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 09, 2016 at 12:52:53PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jul 28, 2016 at 11:20:59AM +0200, Florian Westphal wrote:
> > Laura Garcia <nevola@gmail.com> wrote:
> > > On Thu, Jul 28, 2016 at 01:01:05AM +0200, Florian Westphal wrote:
> > > > How exactly is this used by nftables?
> > > > 
> > > > AFAIU usespace will check if ->dreg is 0 or not, but does that make
> > > > sense?
> > > > 
> > > > Seems to me it would be more straightforward to not use a dreg at all
> > > > and just NFT_BREAK if nval != 0?
> > > > 
> > > 
> > > The main idea is to provide a round robin like scheduling method, for
> > > example:
> > > 
> > > ip daddr <ipsaddr> dnat nth 3 map {
> > >         0: <ipdaddrA>,
> > >         1: <ipdaddrB>,
> > >         2: <ipdaddrC>
> > > }
> > > 
> > 
> > That makes sense, would be nice to place a small blurb in the commit
> > message.
> 
> I'd suggest you rename this to nft_numgen.c where numgen stands for
> 'number generator', then rename 'every' to 'until' (this sets the
> upper limit in the generator) and add support for random too, so we
> provide incremental and random number generators to start with and we
> leave room to extend this with more number generators in the future if
> needed.
> 
> Florian added random to meta, but I don't see an easy way to reuse
> this with maps unless we introduce another modulus/scale expression,
> and we should skip oversplitting expressions in way too basic
> operations.

So, do you mean something like this?

ip daddr <ipsaddr> dnat numgen nth 3 map {
        0: <ipdaddrA>,
        1: <ipdaddrB>,
        2: <ipdaddrC>
}

and

ip daddr <ipsaddr> dnat numgen random 3 map {
        0: <ipdaddrA>,
        1: <ipdaddrB>,
        2: <ipdaddrC>
}

Maybe _math_ could be a better name?
The counter expression could be included as well.

