Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F658E78486
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Oct 2023 20:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbjJAUKQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Oct 2023 16:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235346AbjJAUKQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Oct 2023 16:10:16 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB377C6
        for <netfilter-devel@vger.kernel.org>; Sun,  1 Oct 2023 13:10:10 -0700 (PDT)
Received: from [78.30.34.192] (port=43188 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qn2lP-008ktb-NS; Sun, 01 Oct 2023 22:10:06 +0200
Date:   Sun, 1 Oct 2023 22:10:03 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 1/2] netfilter: nft_set_rbtree: move sync GC from
 insert path to set->ops->commit
Message-ID: <ZRnSGwk40jpUActD@calendula>
References: <20230929164404.172081-1-pablo@netfilter.org>
 <ZRdOxs+i1EuC+zoS@calendula>
 <20230930081038.GB23327@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230930081038.GB23327@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Sat, Sep 30, 2023 at 10:10:38AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > - read spin lock is required for the sync GC to make sure this does
> >   not zap entries that are being used from the datapath.
> 
> It needs to grab the write spinlock for each rb_erase, plus
> the seqcount increase to make sure that parallel lookup doesn't
> miss an element in the tree.

Right, read lock is not enough for sync GC, and it would be also
required by this approach.

> > - the full GC batch could be used to amortize the memory allocation
> >   (not only two slots as it happens now, I am recycling an existing
> >    function).
> 
> Yes.
> 
> > - ENOMEM on GC sync commit path could be an issue. It is too late to
> >   fail. The tree would start collecting expired elements that might
> >   duplicate existing, triggering bogus mismatches. In this path the
> >   commit_mutex is held, and this set backend does not support for
> >   lockless read,
> 
> It does.  If lockless doesn't return a match it falls back to readlock.

And it will in case of the update to remove the expired element, right?

> >   it might be possible to simply grab the spinlock
> >   in write mode and release entries inmediately, without requiring the
> >   sync GC batch infrastructure that pipapo is using.
> 
> Is there evidence that the on-demand GC is a problem?

After your last fix, not really, other than we have to be care not to
zap elements that are in any of the pending transaction in this batch.

> It only searches in the relevant subtree, it should rarely, if ever,
> encounter any expired element.

Not a problem now, but this path that we follow blocks a requested
feature.

I currently do not know how to support for set element timeout update
with this on-demand GC on the rbtree. This feature will require a new
update state in the transaction to update the timer for an element. We
will have to be careful because on-demand GC might zap an expired
element that got just refreshed in this transaction (unless we
reintroduce some sort of 'busy' bit for updates again which is
something I prefer we do not). With 2ee52ae94baa ("netfilter:
nft_set_rbtree: skip sync GC for new elements in this transaction")
I could fix by looking at the generation mask to infer that this
element is 'busy' by some pending transaction, but I do not see a way
with an element update command in place.

Maybe take your patch and then follow up to nf-next with this approach
based once set element timer update is introduced? Otherwise, rbtree
will block the introduction of this new feature for other sets too.
