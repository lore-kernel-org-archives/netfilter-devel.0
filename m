Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDC7C43334
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Jun 2022 13:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243466AbiFEN2K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Jun 2022 09:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243794AbiFEN2J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Jun 2022 09:28:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 438532AE8
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Jun 2022 06:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654435682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zfQ0ypq+NeFcKywD7FFoFTLtx+A+cwLw3ABPEfWM7NI=;
        b=YP6fhhPKP5afR9rXXPLI8tAQsYdjE8FEdAn0Vrz1wnIXLWRrhpT6056KqeY7alr8jScyI/
        JQ6MJXpvxc2I5WjJ1jAC2wwJ+eMn92tnmyloA/q+m09Xo2+IOtAr6bgRIOT2c02saJHvUk
        j7ktad8lmK4szRnBFL0E0smYItLOpJU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-LtaF2AEQOhmB2DBhvv8cAw-1; Sun, 05 Jun 2022 09:27:59 -0400
X-MC-Unique: LtaF2AEQOhmB2DBhvv8cAw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52C4D80159B;
        Sun,  5 Jun 2022 13:27:59 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F368A40CFD0A;
        Sun,  5 Jun 2022 13:27:58 +0000 (UTC)
Date:   Fri, 3 Jun 2022 15:04:45 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Move clauses for expired nodes, last
 active node as leaf
Message-ID: <20220603150445.3d797c87@elisabeth>
In-Reply-To: <YpdKM/mArNz/vh/m@salvia>
References: <20220512183421.712556-1-sbrivio@redhat.com>
        <YoKVFRR1gggECpiZ@salvia>
        <20220517145709.08694803@elisabeth>
        <20220520174524.439b5fa2@elisabeth>
        <YouhUq09zfcflOnz@salvia>
        <20220525141507.69c37709@elisabeth>
        <YpdKM/mArNz/vh/m@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 1 Jun 2022 13:15:08 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Wed, May 25, 2022 at 02:15:07PM +0200, Stefano Brivio wrote:
> > On Mon, 23 May 2022 16:59:30 +0200
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:  
> [...]
> > > Another possibility? Maintain two trees, one for the existing
> > > generation (this is read-only) and another for the next generation
> > > (insertion/removals are performed on it), then swap them when commit
> > > happens?  
> > 
> > It sounded like a good idea and I actually started sketching it, but
> > there's one fundamental issue: it doesn't help with overlap detection
> > because we also want to check insertions that will be part of the live
> > copy. If, within one transaction, you delete and create elements, the
> > "dirty" copy is still dirty for the purposes of overlaps.  
> 
> Updates on the copy could be done without using the deactivate/active
> logic since it is not exposed to the packet path. Then, you use the
> copy (next generation of the datastructure) to check for overlaps? We
> need keep pointer to two sets in the rbtree private data area, the
> generation ID would point to the current set that is being used from
> the packet path. The stale tree is released from the commit phase (see
> below).

Oh, right, I guess that would work. But at a first glance it looks more
complicated than the other idea:

> > For the lookup, that might help. Is it worth it right now, though? At
> > the moment I would go back and try to get overlap detection work
> > properly, at least, with my previous idea.  
> 
> If your idea is still in planning phase, could you summarize again the
> idea? You mentioned about using gc you mentioned, if it is more simple
> than my proposal, then it should be good to go too.

...hmm, no, forget about gc, that was flawed. I'm just "walking" the
tree (going through elements as a list, instead of descending it),
noting down closest left and right elements to what we're inserting,
and check it with similar criteria to what we already have (but much
simpler, because we don't have to infer anything from what might be in
other leaves/nodes).

That is, if you have elements 3 (start), 5 (end), 7 (start), 8 (end),
and you're inserting 6 as a start, we'll end up the tree walk with 5
(end) on the left and 7 (start) on the right, so we know it's not
overlapping.

If you insert 4 (as start or end), we know we have 3 and 5 around, so
it overlaps.

It's essentially the same as it is now, just dropping a lot of corner
cases and changing the way we go through the tree.

I kind of implemented it, I still need a bit to make it working.

> > > pipapo has similar requirements, currently it is relying on a
> > > workqueue to make some postprocess after the commit phase. At the
> > > expense of consuming more memory.  
> > 
> > Well, it keeps two copies already: all the insertions and removals are
> > done on the dirty copy. The two problems we have there are:
> > 
> > - the clean copy might also contain inactive elements (because on a
> >   "commit" operation the API doesn't guarantee that all inserted
> >   elements are active), so we need to check for those during lookup,
> >   which is quite heavy (in my tests that was 4% of the clock cycles
> >   needed for lookup in a set with 30 000 "port, protocol" entries)
> > 
> > - on every _activate() call, we also need to commit the dirty copy onto
> >   a clean one, instead of having one commit per transaction (because if
> >   there's a newly activated item, we need to see it from the lookup),
> >   so every transaction translates to a number of commit operations for
> >   the back-end.
> > 
> >   That also makes things a bit complicated and it might very well be
> >   related to point 3. below
> > 
> > ...there's no actual workqueue: garbage collection (for timed out
> > entries) only happens on commit, I don't see a particular problem with
> > it.
> > 
> > I think both issues would be solved if we had a more natural API, that
> > is, having a single call to the back-end implementing a commit
> > operation, instead of separately activating single entries. I don't
> > know how complicated this change would be.  
> 
> It should be possible to add a ->commit operation to set->ops, then
> call it at the end of the commit phase, ie. iterate over the list of
> existing sets in the table and call set->ops->commit().

That sounds good, but when would we call it? Can it be independent of
the userspace version? Could we then obsolete the "activate" operation
(of course, by implementing commit() in all the sets)?

> > From a set back-end perspective it looks trivial (pipapo would be
> > greatly simplified, hash would also need to keep two copies but we
> > would remove some complexity by getting rid of some checks).
> >   
> > > > In the perspective of getting rid of it, I think we need:
> > > > 
> > > > 1. some "introductory" documentation for nft_set_pipapo -- I just
> > > >    got back to it (drawing some diagrams first...)
> > > > 
> > > > 2. to understand if the performance gap in the few (maybe not
> > > >    reasonable) cases where nft_set_rbtree matches faster than
> > > >    nft_set_pipapo is acceptable. Summary:
> > > >      https://lore.kernel.org/netfilter-devel/be7d4e51603633e7b88e4b0dde54b25a3e5a018b.1583598508.git.sbrivio@redhat.com/    
> > > 
> > > IIRC pipapo was not too far behind from rbtree for a few scenarios.  
> > 
> > Perhaps it would be good enough (minus points 1. and 3. here) to start
> > offering it as a default option (the change is trivial, setting
> > NFT_PIPAPO_MIN_FIELDS to 1) and see if regressions are reported (actually,
> > I doubt it).
> >   
> > > > 3. a solution for https://bugzilla.netfilter.org/show_bug.cgi?id=1583,
> > > >    it's an atomicity issue which has little to do with nft_set_pipapo
> > > >    structures themselves, but I couldn't figure out the exact issue
> > > >    yet. I'm struggling to find the time for it, so if somebody wants to
> > > >    give it a try, I'd be more than happy to reassign it...    
> > > 
> > > OK, a different problem, related to pipapo.  
> > 
> > Yes, I included it here because I wouldn't offer pipapo as rbtree
> > replacement as long as that issue is there.  
> 
> Makes sense, thanks for explaining.
> 

-- 
Stefano

