From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft cache updates
Date: Mon, 9 Nov 2015 19:38:05 +0100
Message-ID: <20151109183805.GA2240@salvia>
References: <20151109153055.GI8098@macbook.localdomain>
 <20151109164847.GA1723@salvia>
 <20151109170510.GA9715@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34005 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbbKISiL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 13:38:11 -0500
Content-Disposition: inline
In-Reply-To: <20151109170510.GA9715@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 09, 2015 at 05:05:11PM +0000, Patrick McHardy wrote:
> On 09.11, Pablo Neira Ayuso wrote:
> > On Mon, Nov 09, 2015 at 03:30:56PM +0000, Patrick McHardy wrote:
> > > Hi Pablo,
> > > 
> > > I'm wondering what the rational for the current cache update behaviour is.
> > > The changelog states it is somehow related to the requested command, but
> > > that doesn't seem to be true.
> > > 
> > > Even "nft describe" fails with EPERM as user since the cache appears to be
> > > initialized unconditionally, which is a bit unfortunate. Also I used to
> > > test things parsing, evaluation and even netlink generation without actually
> > > adding those rules as user, which does not work anymore.  This might
> > > be harder to get working again, but I'm not sure why we do a full
> > > initialization anyways.  The only thing that appears to be needed
> > > are sets, and those only in some specific circumstances.
> > 
> > To look up for the existing sets we need the existing tables and
> > chains, they are essential part of the object hierarchy. So this is
> > what we're currently dumping.
> 
> Well, its not really necessary to have all elements present, the set handle
> is enough to recreate the hierarchy. Unless we need properties of the table
> or chains themselves its quite useless.

Currently, we may have to bail out in the middle of an incremental
update if the set doesn't exist.  So for sets, we would have to say
sort of "This set 'x' doesn't exist, we don't have it in the cache",
while for other objects the kernel will report the error. Doesn't this
look a bit inconsistent?

> > In general, we need this for incremental updates, in scenarios where
> > we have objects that are defined in kernelspace but userspace refers
> > to them.
> > 
> > As you said we can disable the cache in many cases, depending on the
> > command or if the ruleset file starts by:
> > 
> > flush ruleset
> > 
> > but I have left this out as follow up work, I just wanted to make sure
> > incremental updates where working, as well as the existing changes.
> 
> I understand. But with dumping the full hierarchy it seems reasonable to
> do the update in the place where we are doing it right now. But we actually
> only need a very small subset of that, and if we wouldn't dump all of that
> information it would actually make sense to move it to the spots that refer
> to (existing) sets only.

Got it, we can defer the set cache population by when we refer to a
set that doesn't exist. And we infer the existing table and chains
from the set handle. Probably there is a way to avoid this.

What do we do with nft -i? We just retrieve the cache if we need it
too?

Do you think this will cover all kind of command combinations?

add rule ...
add rule ...
list ruleset

This above is not working now, but what should we expect from listing
after adding?

> > nft describe should be easy to restore.
> > 
> > Regarding inconditional check for table and chain, we have to make it
> > from the evaluation step in sets, so leaving other objects without
> > checking this seems inconsistent to me.
> 
> But we don't actually need any of that information, do we?
>
> > Another side effect of this is better error reporting to the user.
> 
> I can see that it is useful, but causing an error for reporting an error
> doesn't seem like the correct way to do it. I'm also generally uncertain
> about checking this *beforehand*, our usual approach is that solely the
> kernel is responsible for determining object existance etc. We could
> also interpret context to get the same error reporting.
>
> Last point would be overhead of dumping all that information we don't
> *really* need.

That is something that we should avoid.

> Even if we say this is acceptable (I think correctly putting netlink
> errors in context is better since it allows to properly report many
> other errors as well), I'd prefer if it wouldn't cause a hard failure
> such as EPERM.

The EPERM problem only happens when runs as user, apart from testing,
how useful can this be? This needs net admin capabilities anyway,
we'll hit this anyway if you try a command as user that refers to a
set that doesn't exists in our cache.

Let me have a look, it shouldn't be that large patch to add on-demand
set cache population (and infer table and chain cache from the set
handle).

BTW, apart from the obvious listing case, I think we'll need this
infrastructure to work with a full consistent cache when performing
ruleset transformations.
