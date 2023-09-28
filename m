Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09203E732D0
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 13:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbjI1Nt0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 09:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbjI1NtZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 09:49:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4E311F
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 06:49:24 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qlrON-0005Ar-35; Thu, 28 Sep 2023 15:49:23 +0200
Date:   Thu, 28 Sep 2023 15:49:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: nft_set_rbtree: fix spurious
 insertion failure
Message-ID: <20230928134923.GD27208@breakpoint.cc>
References: <20230928131247.3391-1-fw@strlen.de>
 <ZRWBxJBxQ4z7QYVo@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRWBxJBxQ4z7QYVo@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Sep 28, 2023 at 03:12:44PM +0200, Florian Westphal wrote:
> > nft_rbtree_gc_elem() walks back and removes the end interval element that
> > comes before the expired element.
> > 
> > There is a small chance that we've cached this element as 'rbe_ge'.
> > If this happens, we hold and test a pointer that has been queued for
> > freeing.
> > 
> > It also causes spurious insertion failures:
> > 
> > $ cat nft-test.20230921-143934.826.dMBwHt/test-testcases-sets-0044interval_overlap_0.1/testout.log
> > Error: Could not process rule: File exists
> > add element t s {  0 -  2 }
> >                    ^^^^^^
> > Failed to insert  0 -  2 given:
> > table ip t {
> >         set s {
> >                 type inet_service
> >                 flags interval,timeout
> >                 timeout 2s
> >                 gc-interval 2s
> >         }
> > }
> > 
> > The set (rbtree) is empty. The 'failure' doesn't happen on next attempt.
> > 
> > Reason is that when we try to insert, the tree may hold an expired
> > element that collides with the range we're adding.
> > While we do evict/erase this element, we can trip over this check:
> > 
> > if (rbe_ge && nft_rbtree_interval_end(rbe_ge) && nft_rbtree_interval_end(new))
> >       return -ENOTEMPTY;
> > 
> > rbe_ge was erased by the synchronous gc, we should not have done this
> > check.  Next attempt won't find it, so retry results in successful
> > insertion.
> > 
> > Restart in-kernel to avoid such spurious errors.
> > 
> > Such restart are rare, unless userspace intentionally adds very large
> > numbers of elements with very short timeouts while setting a huge
> > gc interval.
> > 
> > Even in this case, this cannot loop forever, on each retry an existing
> > element has been removed.
> > 
> > As the caller is holding the transaction mutex, its impossible
> > for a second entity to add more expiring elements to the tree.
> > 
> > After this it also becomes feasible to remove the async gc worker
> > and perform all garbage collection from the commit path.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  Changes since v1:
> >   - restart entire insertion process in case we remove
> >   element that we held as lesser/greater overlap detection
> Thanks, I am still looking at finding a way to move this to .commit,
> if no better solution, then let's get this in for the next round.

I don't think its that bad.  In most cases, no restart is required
as no expired elements in the interesting range will ever be found.

I think its fine really, no need to go for two trees or anything
like pipapo is doing.

I have a few patches that build on top of this, first one
gets rid of async worker and places it in commit.
