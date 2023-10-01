Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD8BE78493
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Oct 2023 21:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235249AbjJAVIY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Oct 2023 17:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235161AbjJAVIX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Oct 2023 17:08:23 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06702BF
        for <netfilter-devel@vger.kernel.org>; Sun,  1 Oct 2023 14:08:19 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qn3fk-0004xo-WF; Sun, 01 Oct 2023 23:08:17 +0200
Date:   Sun, 1 Oct 2023 23:08:16 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 1/2] netfilter: nft_set_rbtree: move sync GC from
 insert path to set->ops->commit
Message-ID: <20231001210816.GA15564@breakpoint.cc>
References: <20230929164404.172081-1-pablo@netfilter.org>
 <ZRdOxs+i1EuC+zoS@calendula>
 <20230930081038.GB23327@breakpoint.cc>
 <ZRnSGwk40jpUActD@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRnSGwk40jpUActD@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Sep 30, 2023 at 10:10:38AM +0200, Florian Westphal wrote:
> > It does.  If lockless doesn't return a match it falls back to readlock.
> 
> And it will in case of the update to remove the expired element, right?

Yes, but I don't think its a huge problem, this is short and we do not
grab wrlock until we actually unlink.

> > >   it might be possible to simply grab the spinlock
> > >   in write mode and release entries inmediately, without requiring the
> > >   sync GC batch infrastructure that pipapo is using.
> > 
> > Is there evidence that the on-demand GC is a problem?
> 
> After your last fix, not really, other than we have to be care not to
> zap elements that are in any of the pending transaction in this batch.

Right.  I don't see a problem with zapping those (newly added ones)
from the point-of-no-return phase, however, we don't have to worry about
rollback then.

> > It only searches in the relevant subtree, it should rarely, if ever,
> > encounter any expired element.
> 
> Not a problem now, but this path that we follow blocks a requested
> feature.
>
> I currently do not know how to support for set element timeout update
> with this on-demand GC on the rbtree. This feature will require a new
> update state in the transaction to update the timer for an element. We
> will have to be careful because on-demand GC might zap an expired
> element that got just refreshed in this transaction (unless we
> reintroduce some sort of 'busy' bit for updates again which is
> something I prefer we do not). With 2ee52ae94baa ("netfilter:
> nft_set_rbtree: skip sync GC for new elements in this transaction")
> I could fix by looking at the generation mask to infer that this
> element is 'busy' by some pending transaction, but I do not see a way
> with an element update command in place.

Not convinced. In particular, I don't understand what this has to do
with async vs. sync gc.  To me this depends how we want to handle
elements that have expired or expire during transaction.

Example:

Element E1, times out in 1 hour
Element E2, times out in 1 second
Element E3, timed out (1 second ago, 3 minutes ago, doesn't matter).

Userspace batch to kernel:
Update Element E1 to time out in 2 hours.
Update Element E2 to time out in 1 hour.
Update Element E3 to time out in 1 hour.

What is the expected outcome of this request?

Ignore E3 being reaped already and refresh the timeout (resurrection?)
Ignore E3 being reaped already and ignore the request?
Fail the transaction as E3 timed out already ("does not exist")?

Now, what about E2?  If transaction is large, it could become
like E3 *during the transaction* unless we introduce some freezing
mechanism.  Whats the expected outcome?

Whats the expected outcome if there is some other, unrelated
failure? I assume we have to roll back all the timeout updates, right?
If so, why not temporarily make the timeouts effective right away
and then roll back?

What if userspace asks to *shrink* timeouts? Same scenario:

Update Element E1 to time out in 1 second
Update Element E2 to time out in 1 second
Update Element E3 to time out in 1 second

We could say 'not supported' of course, would avoid the
rollback headache, because in this case long transaction
gc would definitely start to pick some of those elements
up for reaping...

> Maybe take your patch and then follow up to nf-next with this approach
> based once set element timer update is introduced? Otherwise, rbtree
> will block the introduction of this new feature for other sets too.

See above, I would first like to understand the expected
semantics of the timeout update facility.

I've pushed a (not very much tested) version of gc overhaul
to passive lookups based on expiry candidates, this removes
the need for gc sequence counters.

Its vs. nf.git but really should be re-targetted to nf-next, I'll
try to do this next week:

https://git.kernel.org/pub/scm/linux/kernel/git/fwestphal/nf.git/log/?h=nft_set_gc_query_08
