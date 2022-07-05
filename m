Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07047C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Jul 2022 11:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiGELyA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Jul 2022 07:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiGELxv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Jul 2022 07:53:51 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C58051583E
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Jul 2022 04:53:50 -0700 (PDT)
Date:   Tue, 5 Jul 2022 13:53:47 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Switch to node list walk for overlap
 detection
Message-ID: <YsQmS4+qdFz8s+sN@salvia>
References: <20220614010704.1416375-1-sbrivio@redhat.com>
 <Yrnh2lqhvvzrT2ii@salvia>
 <20220702015510.08ee9401@elisabeth>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220702015510.08ee9401@elisabeth>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano,

On Sat, Jul 02, 2022 at 01:55:10AM +0200, Stefano Brivio wrote:
> On Mon, 27 Jun 2022 18:59:06 +0200
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > Hi Stefano,
> > 
> > On Tue, Jun 14, 2022 at 03:07:04AM +0200, Stefano Brivio wrote:
> > > ...instead of a tree descent, which became overly complicated in an
> > > attempt to cover cases where expired or inactive elements would
> > > affect comparisons with the new element being inserted.
> > >
> > > Further, it turned out that it's probably impossible to cover all
> > > those cases, as inactive nodes might entirely hide subtrees
> > > consisting of a complete interval plus a node that makes the current
> > > insertion not overlap.
> > >
> > > For the insertion operation itself, this essentially reverts back to
> > > the implementation before commit 7c84d41416d8
> > > ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion"),
> > > except that cases of complete overlap are already handled in the
> > > overlap detection phase itself, which slightly simplifies the loop to
> > > find the insertion point.
> > >
> > > Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
> > > Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> > > ---
> > >  net/netfilter/nft_set_rbtree.c | 194 ++++++++++-----------------------
> > >  1 file changed, 58 insertions(+), 136 deletions(-)  
> > 
> > When running tests this is increasing the time to detect overlaps in
> > my testbed, because of the linear list walk for each element.
> 
> ...by the way, I observed it as well, and I was wondering: how bad is
> too bad? My guess was that as long as we insert a few thousand elements
> (with more, I expect hash or pipapo to be used) in a few seconds, it
> should be good enough.

From few seconds to less than 30 seconds in one testbed here.

> > So I have been looking at an alternative approach (see attached patch) to
> > address your comments. The idea is to move out the overlapping nodes
> > from the element in the tree, instead keep them in a list.
> > 
> >                         root
> >                         /  \
> >                      elem   elem -> update -> update
> >                             /  \
> >                          elem  elem
> > 
> > Each rbtree element in the tree .has pending_list which stores the
> > element that supersede the existing (inactive) element. There is also a
> > .list which is used to add the element to the .pending_list. Elements
> > in the tree might have a .pending_list with one or more elements.
> 
> I see a problem with this, that perhaps you already solved, but I don't
> understand how.
> 
> The original issue here was that we have inactive elements in the tree
> affecting the way we descend it to look for overlaps. Those inactive
> elements are not necessarily overlapping with anything.
> 
> If they overlap, the issue is solved with your patch. But if they
> don't...?
>
> Sure, we'll grant insertion of overlapping elements in case the overlap
> is with an inactive one, but this solves the particular case of
> matching elements, not overlapping intervals.
> 
> At a first reading, I thought you found some magic way to push out all
> inactive elements to some parallel, linked structure, which we can
> ignore as we look for overlapping _intervals_. But that doesn't seem to
> be the case, right?

With my patch, when descending the tree, the right or left branch is
selected uniquely based on the key value (regardless the element
state), I removed the "turn left" when node is inactive case. There
are also no more duplicated elements with the same value.
