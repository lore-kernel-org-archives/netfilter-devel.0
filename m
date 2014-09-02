From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] netfilter: nft_hash: no need for rcu in the hash set
 destroy path
Date: Tue, 2 Sep 2014 14:28:14 +0100
Message-ID: <20140902132813.GA29330@acer.localdomain>
References: <1409650721-9621-1-git-send-email-pablo@netfilter.org>
 <20140902101440.GA12450@acer.localdomain>
 <20140902103856.GA10730@salvia>
 <20140902105920.GB12450@acer.localdomain>
 <20140902122207.GA11880@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, tgraf@suug.ch
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64269 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaIBN2T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:28:19 -0400
Content-Disposition: inline
In-Reply-To: <20140902122207.GA11880@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 02, 2014 at 02:22:07PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Sep 02, 2014 at 11:59:22AM +0100, Patrick McHardy wrote:
> > On Tue, Sep 02, 2014 at 12:38:56PM +0200, Pablo Neira Ayuso wrote:
> > > On Tue, Sep 02, 2014 at 11:14:41AM +0100, Patrick McHardy wrote:
> > > > On Tue, Sep 02, 2014 at 11:38:39AM +0200, Pablo Neira Ayuso wrote:
> > > > > The sets are released from the rcu callback, after the rule is removed
> > > > > from the chain list, which implies that nfnetlink cannot update the
> > > > > hashes (thus, no resizing may occur) and no packets are walking on the
> > > > > set anymore.
> > > > 
> > > > Unrelated to your patch, but to the RCU destruction: how does that make
> > > > sure that nfnetlink notifications are received in the proper order?
> > > > I mean, theoretically a new set with the same name could exist at that
> > > > time. The same problem exists for all objects that have user defined
> > > > identifiers or refer to them.
> > > 
> > > All the events (with the exception of anonymous sets) are sent in
> > > order from the commit path, so they are delivered in order.
> > 
> > Sure, I was talking about independant additions:
> > 
> > - delete set X
> > - RCU callback delayed
> > - add set X, notify
> > - RCU callback executes, notifies for delete set X
> 
> Right, that's indeed a problem for bound-to-rule anonymous sets.
> 
> > Same thing applies to all other objects that don't have a unique identifier
> > chosen by the kernel.
> 
> All other objects are always notified in order from the commit path,
> so they seem fine to me.

You're right, this only seems to affect sets.

> > > The anonymous sets are problematic, we need to notify this from the
> > > commit path too to ensure the right ordering. I was trying to avoid
> > > some specific notify() interface in expr->ops but it seems we need it
> > > for nft_lookup.c.
> > > 
> > > Can you think of a better solution?
> > 
> > No, unless we can come up with a way that's synchronous.
> 
> I would really like not to go back to the two nearly consecutive
> synchronize_rcu() calls, it's slow.  I've been thinking on replacing
> the current check in the packet path by static keys, but I didn't
> manage to find the way yet.

Which check exactly are you referring to?
