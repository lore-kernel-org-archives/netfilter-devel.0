Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6E28CCA480
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Jul 2022 21:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbiGFVM6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Jul 2022 17:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234279AbiGFVM4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Jul 2022 17:12:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0DFB82980A
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2022 14:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657141970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y7h7IrPbsWI8QhyG3/mzkv9LzUq+QzL6ht7oJbYSp64=;
        b=gv4kfEwpRbsnr8Q/hE2H4fUb7CiFXspm44OfOyZ0N92D5Jl537vs6vie/BcqEBqL813QkH
        DjPDN3htYQEDN7YzOpluCKY940fszH5fPqYxhjL4oIy17dxVY3Y6LL5/UoqFS/dE3V93sy
        MUljE/rn5VaSDS8iVnPx/S65PDJvDDs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-GTmS-XzCNBygJXTQ-Kk-Mw-1; Wed, 06 Jul 2022 17:12:46 -0400
X-MC-Unique: GTmS-XzCNBygJXTQ-Kk-Mw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9897F811E76;
        Wed,  6 Jul 2022 21:12:46 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B417C23DBF;
        Wed,  6 Jul 2022 21:12:46 +0000 (UTC)
Date:   Wed, 6 Jul 2022 23:12:42 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Switch to node list walk for overlap
 detection
Message-ID: <20220706231242.492ba5d1@elisabeth>
In-Reply-To: <YsQmS4+qdFz8s+sN@salvia>
References: <20220614010704.1416375-1-sbrivio@redhat.com>
        <Yrnh2lqhvvzrT2ii@salvia>
        <20220702015510.08ee9401@elisabeth>
        <YsQmS4+qdFz8s+sN@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 5 Jul 2022 13:53:47 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Hi Stefano,
> 
> On Sat, Jul 02, 2022 at 01:55:10AM +0200, Stefano Brivio wrote:
> > On Mon, 27 Jun 2022 18:59:06 +0200
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >   
> > > Hi Stefano,
> > > 
> > > On Tue, Jun 14, 2022 at 03:07:04AM +0200, Stefano Brivio wrote:  
> > > > ...instead of a tree descent, which became overly complicated in an
> > > > attempt to cover cases where expired or inactive elements would
> > > > affect comparisons with the new element being inserted.
> > > >
> > > > Further, it turned out that it's probably impossible to cover all
> > > > those cases, as inactive nodes might entirely hide subtrees
> > > > consisting of a complete interval plus a node that makes the current
> > > > insertion not overlap.
> > > >
> > > > For the insertion operation itself, this essentially reverts back to
> > > > the implementation before commit 7c84d41416d8
> > > > ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion"),
> > > > except that cases of complete overlap are already handled in the
> > > > overlap detection phase itself, which slightly simplifies the loop to
> > > > find the insertion point.
> > > >
> > > > Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
> > > > Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> > > > ---
> > > >  net/netfilter/nft_set_rbtree.c | 194 ++++++++++-----------------------
> > > >  1 file changed, 58 insertions(+), 136 deletions(-)    
> > > 
> > > When running tests this is increasing the time to detect overlaps in
> > > my testbed, because of the linear list walk for each element.  
> > 
> > ...by the way, I observed it as well, and I was wondering: how bad is
> > too bad? My guess was that as long as we insert a few thousand elements
> > (with more, I expect hash or pipapo to be used) in a few seconds, it
> > should be good enough.  
> 
> From few seconds to less than 30 seconds in one testbed here.

I didn't understand: so it's really bad? Because sure, I see that
running the test scripts you shared now takes much longer, but I wonder
how far that is from actual use cases.

> > > So I have been looking at an alternative approach (see attached patch) to
> > > address your comments. The idea is to move out the overlapping nodes
> > > from the element in the tree, instead keep them in a list.
> > > 
> > >                         root
> > >                         /  \
> > >                      elem   elem -> update -> update
> > >                             /  \
> > >                          elem  elem
> > > 
> > > Each rbtree element in the tree .has pending_list which stores the
> > > element that supersede the existing (inactive) element. There is also a
> > > .list which is used to add the element to the .pending_list. Elements
> > > in the tree might have a .pending_list with one or more elements.  
> > 
> > I see a problem with this, that perhaps you already solved, but I don't
> > understand how.
> > 
> > The original issue here was that we have inactive elements in the tree
> > affecting the way we descend it to look for overlaps. Those inactive
> > elements are not necessarily overlapping with anything.
> > 
> > If they overlap, the issue is solved with your patch. But if they
> > don't...?
> >
> > Sure, we'll grant insertion of overlapping elements in case the overlap
> > is with an inactive one, but this solves the particular case of
> > matching elements, not overlapping intervals.
> > 
> > At a first reading, I thought you found some magic way to push out all
> > inactive elements to some parallel, linked structure, which we can
> > ignore as we look for overlapping _intervals_. But that doesn't seem to
> > be the case, right?  
> 
> With my patch, when descending the tree, the right or left branch is
> selected uniquely based on the key value (regardless the element
> state)

Hmm, but wait, that was exactly the problem I introduced (or at least
my understanding of it): if subtrees of entirely inactive nodes hide
(by affecting how we descend the tree) active nodes (that affect the
overlap decision), we can't actually reach any conclusion.

It's fine as long as it's inactive leaves, or single nodes, but not
more.

Let's say we need to insert element with key 6, as interval start,
given this tree, where:

- (s) and (e) mark starts and ends
- (i) and (a) mark inactive and active elements

                 4 (s, i)
                 /      \
                /        \
        2 (s, i)          7 (e, i)
        /      \          /      \
       /        \        /        \
  1 (s, a)  3 (e, a)  5 (s, i)  8 (s, i)

we visit elements with keys 4, 7, 5: we have an inactive start on the
left (5), an inactive end to the right (7), and we don't know if it
overlaps, because we couldn't see 1 and 3. Depending on how hard we
tried to fix bugs we hit in the past, we'll consider that an overlap
or not.

Without inactive elements, we would have this tree:

1 (s, a)
     \
      \
    3 (e, a)

where we visit elements with keys 1, 3: we find an active start on
the left, and then the corresponding end, also to the left, so we
conclude that start element with key 6 doesn't overlap.

> I removed the "turn left" when node is inactive case. There
> are also no more duplicated elements with the same value.

This simplifies the handling of those cases, we wouldn't need all those
clauses anymore, but I really think that the existing problem comes from
the fact we can *not* descend the tree just by selecting key values.

-- 
Stefano

