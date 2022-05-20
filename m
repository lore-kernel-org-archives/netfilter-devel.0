Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49572C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 May 2022 15:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351070AbiETPpq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 May 2022 11:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351097AbiETPpm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 May 2022 11:45:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72975179C1C
        for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2022 08:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653061532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s/BZ2TxZ/TW9ZxnRPaI2xjecl7ExB5N9vH4kQ+r9FTk=;
        b=eSnF9UIRi40IURC5cUbmISicWNhgMMYwZ5CR5Sfi8YsANKddAKsABDDY+5GohJ6MIMbsgt
        bITUeAGpZ6BeS/ZK0Kp7EfxEmXxXONGpMGePxnRC4sFMem+azItfct+udgpYQKuV82wb09
        4dNAy4t3LucNGkLvekzo7M2G1rmbULY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-g3g47UsCNgeeDG-Uf7CLkA-1; Fri, 20 May 2022 11:45:29 -0400
X-MC-Unique: g3g47UsCNgeeDG-Uf7CLkA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1F1880B718;
        Fri, 20 May 2022 15:45:28 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 36C522166B25;
        Fri, 20 May 2022 15:45:28 +0000 (UTC)
Date:   Fri, 20 May 2022 17:45:24 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Move clauses for expired nodes, last
 active node as leaf
Message-ID: <20220520174524.439b5fa2@elisabeth>
In-Reply-To: <20220517145709.08694803@elisabeth>
References: <20220512183421.712556-1-sbrivio@redhat.com>
        <YoKVFRR1gggECpiZ@salvia>
        <20220517145709.08694803@elisabeth>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 17 May 2022 14:57:09 +0200
Stefano Brivio <sbrivio@redhat.com> wrote:

> On Mon, 16 May 2022 20:16:53 +0200
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > Hi Stefano,
> > 
> > On Thu, May 12, 2022 at 08:34:21PM +0200, Stefano Brivio wrote:  
> > > In the overlap detection performed as part of the insertion operation,
> > > we have to skip nodes that are not active in the current generation or
> > > expired. This was done by adding several conditions in overlap decision
> > > clauses, which made it hard to check for correctness, and debug the
> > > actual issue this patch is fixing.
> > > 
> > > Consolidate these conditions into a single clause, so that we can
> > > proceed with debugging and fixing the following issue.
> > > 
> > > Case b3. described in comments covers the insertion of a start
> > > element after an existing end, as a leaf. If all the descendants of
> > > a given element are inactive, functionally, for the purposes of
> > > overlap detection, we still have to treat this as a leaf, but we don't.
> > > 
> > > If, in the same transaction, we remove a start element to the right,
> > > remove an end element to the left, and add a start element to the right
> > > of an existing, active end element, we don't hit case b3. For example:
> > > 
> > > - existing intervals: 1-2, 3-5, 6-7
> > > - transaction: delete 3-5, insert 4-5
> > > 
> > > node traversal might happen as follows:
> > > - 2 (active end)
> > > - 5 (inactive end)
> > > - 3 (inactive start)
> > > 
> > > when we add 4 as start element, we should simply consider 2 as
> > > preceding end, and consider it as a leaf, because interval 3-5 has been
> > > deleted. If we don't, we'll report an overlap because we forgot about
> > > this.
> > > 
> > > Add an additional flag which is set as we find an active end, and reset
> > > it if we find an active start (to the left). If we finish the traversal
> > > with this flag set, it means we need to functionally consider the
> > > previous active end as a leaf, and allow insertion instead of reporting
> > > overlap.    
> > 
> > I can still trigger EEXIST with deletion of existing interval. It
> > became harder to reproduce after this patch.
> > 
> > After hitting EEXIST, if I do:
> > 
> >         echo "flush ruleset" > test.nft
> >         nft list ruleset >> test.nft
> > 
> > to dump the existing ruleset, then I run the delete element command
> > again to remove the interval and it works. Before this patch I could
> > reproduce it by reloading an existing ruleset dump.
> > 
> > I'm running the script that I'm attaching manually, just one manual
> > invocation after another.  
> 
> Ouch, sorry for that.
> 
> It looks like there's another case where inactive elements still affect
> overlap detection in an unexpected way... at least with the structure
> of this patch it should be easier to find, I'm looking into that now.

...what a mess. I could figure that part out (it was a case symmetric
to what this patch fixed, in this case resolving to case b5.) but
there's then another case (found by triggering a specific tree topology
with 0044interval_overlap_1) where we first add a start element, then
fail to add the end element because the start element is completely
"hidden" in the tree by inactive nodes.

I tried to solve that with some backtracking, but that looks also
fragile. If I clean up the tree before insertion, instead, that will
only deal with expired nodes, not inactive nodes -- I can't erase
non-expired, inactive nodes because the API expects to find them at
some later point and call nft_rbtree_remove() on them.

Now I'm trying another approach that looks more robust: instead of
descending the tree to find overlaps, just going through it in the same
way nft_rbtree_gc() does (linearly, node by node), marking the
value-wise closest points from left and right _valid_ nodes, and
applying the same reasoning. I need a bit more time for this, but it
looks way simpler. Insertion itself would keep working as it does now.

In hindsight, it looks like it was a terrible idea to try to fix this
implementation. I really underestimated how bad this is. Functionally
speaking, it's not a red-black tree because:

- we can't use it as a sorted binary tree, given that some elements
  "don't matter" for some operations, or have another colour. We might
  try to think of it as some other structure and rebuild from there
  useful properties of sorted binary trees, but I'm not sure a
  "red-brown-black" tree would have any other use making it worth of
  any further research

- end elements being represented as their value plus one also break
  assumptions of sorted trees (this is the issue I'm actually facing
  with backtracking)

- left subtrees store keys greater than right subtrees, but this
  looks consistent so it's just added fun and could be fixed
  trivially (it's all reversed)

By the way, I think we _should_ have similar issues in the lookup
function. Given that it's possible to build a tree with a subtree of at
least three levels with entirely non-valid nodes, I guess we can hide a
valid interval from the lookup too. It's just harder to test.

In the perspective of getting rid of it, I think we need:

1. some "introductory" documentation for nft_set_pipapo -- I just
   got back to it (drawing some diagrams first...)

2. to understand if the performance gap in the few (maybe not
   reasonable) cases where nft_set_rbtree matches faster than
   nft_set_pipapo is acceptable. Summary:
     https://lore.kernel.org/netfilter-devel/be7d4e51603633e7b88e4b0dde54b25a3e5a018b.1583598508.git.sbrivio@redhat.com/

3. a solution for https://bugzilla.netfilter.org/show_bug.cgi?id=1583,
   it's an atomicity issue which has little to do with nft_set_pipapo
   structures themselves, but I couldn't figure out the exact issue
   yet. I'm struggling to find the time for it, so if somebody wants to
   give it a try, I'd be more than happy to reassign it...

Anyway, I'll post a different patch for nft_set_rbtree soon.

-- 
Stefano

