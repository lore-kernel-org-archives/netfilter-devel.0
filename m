Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE94C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jun 2022 09:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbiFNJ7G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jun 2022 05:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353060AbiFNJ6d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jun 2022 05:58:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C149D44A3A
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2022 02:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655200710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aa8u3eBjdqPs74ZtMPX/0InVvabJ933Yp3cB5UKs/YM=;
        b=L62UrNavyps8tuAoC70fd5qnsTkysf7MfLIQti1w14aT8plI8iBrv9q2gC6u1tOrBWiRN9
        7dmIFmM4IQX5gt3MxU2RpRlDeRy8JeQGpr+aXyhCmg/tTKmHxB0FaTMulrDpTulRKqtvv5
        O915JVKUJJKKgmXEThVVWPiVIATrb0w=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-mFjuK8aeNwy-7UbwexEE5Q-1; Tue, 14 Jun 2022 05:58:29 -0400
X-MC-Unique: mFjuK8aeNwy-7UbwexEE5Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E774B398CA64;
        Tue, 14 Jun 2022 09:58:28 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BD4C2166B26;
        Tue, 14 Jun 2022 09:58:28 +0000 (UTC)
Date:   Tue, 14 Jun 2022 11:58:14 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Move clauses for expired nodes, last
 active node as leaf
Message-ID: <20220614115814.61f8c667@elisabeth>
In-Reply-To: <Yp3CYfbdHH1lm945@salvia>
References: <20220512183421.712556-1-sbrivio@redhat.com>
        <YoKVFRR1gggECpiZ@salvia>
        <20220517145709.08694803@elisabeth>
        <20220520174524.439b5fa2@elisabeth>
        <YouhUq09zfcflOnz@salvia>
        <20220525141507.69c37709@elisabeth>
        <YpdKM/mArNz/vh/m@salvia>
        <20220603150445.3d797c87@elisabeth>
        <Yp3CYfbdHH1lm945@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 6 Jun 2022 11:01:21 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Fri, Jun 03, 2022 at 03:04:45PM +0200, Stefano Brivio wrote:
> > On Wed, 1 Jun 2022 13:15:08 +0200
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >   
> > > On Wed, May 25, 2022 at 02:15:07PM +0200, Stefano Brivio wrote:  
> > > > On Mon, 23 May 2022 16:59:30 +0200
> > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:    
> > > [...]  
> > > > > Another possibility? Maintain two trees, one for the existing
> > > > > generation (this is read-only) and another for the next generation
> > > > > (insertion/removals are performed on it), then swap them when commit
> > > > > happens?    
> > > > 
> > > > It sounded like a good idea and I actually started sketching it, but
> > > > there's one fundamental issue: it doesn't help with overlap detection
> > > > because we also want to check insertions that will be part of the live
> > > > copy. If, within one transaction, you delete and create elements, the
> > > > "dirty" copy is still dirty for the purposes of overlaps.    
> > > 
> > > Updates on the copy could be done without using the deactivate/active
> > > logic since it is not exposed to the packet path. Then, you use the
> > > copy (next generation of the datastructure) to check for overlaps? We
> > > need keep pointer to two sets in the rbtree private data area, the
> > > generation ID would point to the current set that is being used from
> > > the packet path. The stale tree is released from the commit phase (see
> > > below).  
> > 
> > Oh, right, I guess that would work. But at a first glance it looks more
> > complicated than the other idea:  
> 
> Yes, my idea would trigger a larger rewrite.
> 
> > > > For the lookup, that might help. Is it worth it right now, though? At
> > > > the moment I would go back and try to get overlap detection work
> > > > properly, at least, with my previous idea.    
> > > 
> > > If your idea is still in planning phase, could you summarize again the
> > > idea? You mentioned about using gc you mentioned, if it is more simple
> > > than my proposal, then it should be good to go too.  
> > 
> > ...hmm, no, forget about gc, that was flawed. I'm just "walking" the
> > tree (going through elements as a list, instead of descending it),
> > noting down closest left and right elements to what we're inserting,
> > and check it with similar criteria to what we already have (but much
> > simpler, because we don't have to infer anything from what might be in
> > other leaves/nodes).
> > 
> > That is, if you have elements 3 (start), 5 (end), 7 (start), 8 (end),
> > and you're inserting 6 as a start, we'll end up the tree walk with 5
> > (end) on the left and 7 (start) on the right, so we know it's not
> > overlapping.
> > 
> > If you insert 4 (as start or end), we know we have 3 and 5 around, so
> > it overlaps.
> > 
> > It's essentially the same as it is now, just dropping a lot of corner
> > cases and changing the way we go through the tree.
> > 
> > I kind of implemented it, I still need a bit to make it working.  
> 
> That sounds an incremental fix, I prefer this too.

...finally posted now.

> > > > > pipapo has similar requirements, currently it is relying on a
> > > > > workqueue to make some postprocess after the commit phase. At the
> > > > > expense of consuming more memory.    
> > > > 
> > > > Well, it keeps two copies already: all the insertions and removals are
> > > > done on the dirty copy. The two problems we have there are:
> > > > 
> > > > - the clean copy might also contain inactive elements (because on a
> > > >   "commit" operation the API doesn't guarantee that all inserted
> > > >   elements are active), so we need to check for those during lookup,
> > > >   which is quite heavy (in my tests that was 4% of the clock cycles
> > > >   needed for lookup in a set with 30 000 "port, protocol" entries)
> > > > 
> > > > - on every _activate() call, we also need to commit the dirty copy onto
> > > >   a clean one, instead of having one commit per transaction (because if
> > > >   there's a newly activated item, we need to see it from the lookup),
> > > >   so every transaction translates to a number of commit operations for
> > > >   the back-end.
> > > > 
> > > >   That also makes things a bit complicated and it might very well be
> > > >   related to point 3. below
> > > > 
> > > > ...there's no actual workqueue: garbage collection (for timed out
> > > > entries) only happens on commit, I don't see a particular problem with
> > > > it.
> > > > 
> > > > I think both issues would be solved if we had a more natural API, that
> > > > is, having a single call to the back-end implementing a commit
> > > > operation, instead of separately activating single entries. I don't
> > > > know how complicated this change would be.    
> > > 
> > > It should be possible to add a ->commit operation to set->ops, then
> > > call it at the end of the commit phase, ie. iterate over the list of
> > > existing sets in the table and call set->ops->commit().  
> > 
> > That sounds good, but when would we call it? Can it be independent of
> > the userspace version? Could we then obsolete the "activate" operation
> > (of course, by implementing commit() in all the sets)?  
> 
> Call it from nf_tables_commit().
> 
> I don't see how we can obsolete "activate" operation, though, the
> existing approach works at set element granularity.

Yes, and that's what I'm arguing against: it would be more natural, in
a transaction, to have a single commit operation for all the elements
at hand -- otherwise it's not so much of a transaction.

To the user it's atomic (minus bugs) because we have tricks to ensure
it, but to the set back-ends it's absolutely not. I think we have this
kind of situation:


nft            <->     core       <->   set back-end    <->    storage
                |                  |                     |

hash:   transaction commit    element commit       element commit

rbtree: transaction commit    element commit       element commit
                                                   ^ problematic to the
                                                   point we're
                                                   considering a
                                                   transaction approach

pipapo: transaction commit    element commit       transaction commit

The single advantage I see of the current approach is that with the
hash back-ends we don't need two copies of the hash table, but that
also has the downside of the nft_set_elem_active(&he->ext, genmask)
check in the lookup function, which should be, in relative terms, even
more expensive than it is in the pipapo implementation, given that hash
back-ends are (in most cases) faster.

-- 
Stefano

