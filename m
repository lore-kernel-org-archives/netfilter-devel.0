From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_tables: fix rule batch with anonymous set
 and module autoload
Date: Sun, 16 Feb 2014 11:23:56 +0000
Message-ID: <20140216112355.GA1016@macbook.localnet>
References: <1392377228-3748-1-git-send-email-pablo@netfilter.org>
 <20140214113755.GC19082@macbook.localnet>
 <20140214123411.GA4422@localhost>
 <20140215093822.GB3815@macbook.localnet>
 <20140216103335.GA4499@localhost>
 <20140216104409.GB28646@macbook.localnet>
 <20140216111450.GA3647@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39039 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaBPLYA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 06:24:00 -0500
Content-Disposition: inline
In-Reply-To: <20140216111450.GA3647@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 16, 2014 at 12:14:50PM +0100, Pablo Neira Ayuso wrote:
> On Sun, Feb 16, 2014 at 10:44:09AM +0000, Patrick McHardy wrote:
> > > 
> > > That can be done, but I don't see why we allow the creation of
> > > anonymous sets out of the scope of a rule since:
> > > 
> > > * They can only be used by one single rule.
> > > * You cannot update them by adding/deleting elements.
> > > 
> > > The current API allows creating an anonymous set that can be left
> > > unused. I think we should only allow the creation of non-anonymous
> > > sets via NFT_MSG_NEWSET at some point.
> > 
> > The two main reasons are:
> > 
> > - it keeps the API simpler
> > - members might not fit into a single message and currently we can keep
> >   adding members as long as the set is not bound
> 
> I don't find a reason why not to use a non-anonymous (named) set in
> the "we need to add more elements" scenario.

Its not that we add to add more elements later. Its simply that the
amount of elements specified while creating the rule exceeds the
possible size we can squash into a nested attribute.

Simply:

nft filter output ip daddr { 10000 addresses } => fail

There's no reason to introduce this limitation.

> Going back to your proposal of using internal set ids to the
> transaction, we'll need to keep a temporary list of sets that has been
> created in that transaction, then once they are bound to the rule,
> we'll have to move the per-table set lists.

Yes, similar to the expressions lists. But that seems to be independant
of whether we use IDs or not, we simply have to be able to abort a
failed transaction.

> > I don't think we should change this.
> > 
> > It actually also is possible to use anonymous sets with more than one
> > rule, just nft doesn't provide a way to do it. The definition of an
> > anonymous set it (anonymous isn't the best name) a set that is automatically
> > destroyed once the last rule unbinds.
> 
> I like the "release set when unused" feature, but I think we can add
> that to named sets at some point. We can just add a different flag so
> named sets also benefit from this feature. I'm seeing different
> features that can be combined:
> 
> * Dynamically allocate the name, this is useful in case the user
>   wants to avoid a clash when allocating the set name.

This only works for literal sets though since we need a way to reference
them. Speaking of nft of course.

> * Release after set is unused, so the user doesn't need to release the
>   set from its application, which can be good in the dynamic rule-set
>   case.

Might be useful, I agree.

> * Don't allow updates, so the user makes sure nobody from userspace
>   can updates the content of that set anymore.

This is already possible for non-anonymous sets by specifying the
"constant" flag. I'll change that syntax though with the set descriptions.

> So anonymous sets will stand for the combination in which those three
> are set.
