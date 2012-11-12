From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC v2] netfilter: add connlabel conntrack extension
Date: Mon, 12 Nov 2012 20:02:28 +0100
Message-ID: <20121112190228.GA29254@1984>
References: <1351860231-5434-1-git-send-email-fw@strlen.de>
 <20121107200427.GB12876@breakpoint.cc>
 <20121112064457.GA11330@1984>
 <20121112123053.GB20678@breakpoint.cc>
 <20121112162415.GA16990@1984>
 <20121112163208.GD20678@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35860 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab2KLTCh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Nov 2012 14:02:37 -0500
Content-Disposition: inline
In-Reply-To: <20121112163208.GD20678@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 12, 2012 at 05:32:08PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Don't see how, nfct_attr_unset clears the entire attribute.
> > > I admit that it would be nice if one could re-use existing api...
> > > 
> > > Right now nfct_attr_set_l(.. ATTR_CONNLABELS..) can be used to assign
> > > the bit-vector directly (and _get can be used to retrieve the
> > > label bit-vector).
> > 
> > You could use a nfct_bitmask object and methods to modify it:
> > 
> > struct nfct_bitmask *nfct_bitmask_alloc(void)
> > nfct_bitmask_set_bit(struct nfct_bitmask *, uint16_t bit)
> > nfct_bitmask_test_bit(struct nfct_bitmask *, uint16_t bit)
> > nfct_bitmask_unset_bit(struct nfct_bitmask *, uint16_t bit)
> 
> $ git grep nfct_bitmask
> zsh: exit 1
> 
> What library is that? My search-engine fu fails.

It doesn't exist so far :-), but I think it should not require much
effort by using the existing include/internal/bitops.h in
libnetfilter_conntrack.

> > Then you can attach the bitmask to the object:
> > 
> > nfct_set_attr(ct, ATTR_CONNLABELS, bitmask);
> > 
> > The setter would do the special handling internally by attaching the
> > bitmask label to the ct object.
> 
> Sounds good.
> 
> > > I think that we should avoid it; else this might become a
> > > portability nightmare where applications end up
> > > trying half a zillion names (/etc/xtables, /usr/etc, /usr/local...)
> > 
> > We can provide some constant to recommend a path. My only concern is
> > that the hardcoded path may not exist in some filesystem, thus,
> > forcing to recompile the library.
> > 
> > Anyway, I think the main user for this will be the conntrack utility
> > and any netfilter utilities.
> 
> True.
> 
> > I'd go for the cache-based approach, ie. store a lookup array in
> > memory extracted from the file.
> 
> Oh.  I wanted to avoid this to not bloat the library.
> I'll add a cache.
> 
> > Examples files usually help to see how the API looks in action, if you
> > can attach one in the next round, in would be great.
> 
> Will do.
> 
> Thanks a lot for your help!

Regards.
