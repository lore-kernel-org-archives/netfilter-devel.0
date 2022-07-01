Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F29C43334
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Jul 2022 23:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiGAXzR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Jul 2022 19:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiGAXzQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Jul 2022 19:55:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB5CB3585A
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2022 16:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656719714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2CLsqyxnrR4RPo/tnuzo0TfXVz9ktb5cb2ZpkU4QfN4=;
        b=ZBB93c9pSZ0Oxf1mxsPl6v/85aAxNUK4NqxFf8VNzGLlCX+Nrapgtnuv8S9S9g8Bd6M/VX
        5n07gNrfTTfni0Nc7mtujxOq/oCGxY9aHHHewd2hpGOorWKP6HVzL6VJMLA8zeA9MfXTns
        rlhdLFjxXdky4NA6zdJ0Zdl5ijP/O+s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-S6Tfk_EoPBmDFsrtTe6OBA-1; Fri, 01 Jul 2022 19:55:13 -0400
X-MC-Unique: S6Tfk_EoPBmDFsrtTe6OBA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4685C185A79C;
        Fri,  1 Jul 2022 23:55:13 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DA1B1415307;
        Fri,  1 Jul 2022 23:55:13 +0000 (UTC)
Date:   Sat, 2 Jul 2022 01:55:10 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Switch to node list walk for overlap
 detection
Message-ID: <20220702015510.08ee9401@elisabeth>
In-Reply-To: <Yrnh2lqhvvzrT2ii@salvia>
References: <20220614010704.1416375-1-sbrivio@redhat.com>
        <Yrnh2lqhvvzrT2ii@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 27 Jun 2022 18:59:06 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Hi Stefano,
> 
> On Tue, Jun 14, 2022 at 03:07:04AM +0200, Stefano Brivio wrote:
> > ...instead of a tree descent, which became overly complicated in an
> > attempt to cover cases where expired or inactive elements would
> > affect comparisons with the new element being inserted.
> >
> > Further, it turned out that it's probably impossible to cover all
> > those cases, as inactive nodes might entirely hide subtrees
> > consisting of a complete interval plus a node that makes the current
> > insertion not overlap.
> >
> > For the insertion operation itself, this essentially reverts back to
> > the implementation before commit 7c84d41416d8
> > ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion"),
> > except that cases of complete overlap are already handled in the
> > overlap detection phase itself, which slightly simplifies the loop to
> > find the insertion point.
> >
> > Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
> > Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> > ---
> >  net/netfilter/nft_set_rbtree.c | 194 ++++++++++-----------------------
> >  1 file changed, 58 insertions(+), 136 deletions(-)  
> 
> When running tests this is increasing the time to detect overlaps in
> my testbed, because of the linear list walk for each element.

...by the way, I observed it as well, and I was wondering: how bad is
too bad? My guess was that as long as we insert a few thousand elements
(with more, I expect hash or pipapo to be used) in a few seconds, it
should be good enough.

> So I have been looking at an alternative approach (see attached patch) to
> address your comments. The idea is to move out the overlapping nodes
> from the element in the tree, instead keep them in a list.
> 
>                         root
>                         /  \
>                      elem   elem -> update -> update
>                             /  \
>                          elem  elem
> 
> Each rbtree element in the tree .has pending_list which stores the
> element that supersede the existing (inactive) element. There is also a
> .list which is used to add the element to the .pending_list. Elements
> in the tree might have a .pending_list with one or more elements.

I see a problem with this, that perhaps you already solved, but I don't
understand how.

The original issue here was that we have inactive elements in the tree
affecting the way we descend it to look for overlaps. Those inactive
elements are not necessarily overlapping with anything.

If they overlap, the issue is solved with your patch. But if they
don't...?

Sure, we'll grant insertion of overlapping elements in case the overlap
is with an inactive one, but this solves the particular case of
matching elements, not overlapping intervals.

At a first reading, I thought you found some magic way to push out all
inactive elements to some parallel, linked structure, which we can
ignore as we look for overlapping _intervals_. But that doesn't seem to
be the case, right?

-- 
Stefano

