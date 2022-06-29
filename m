Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68ABDC43334
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jun 2022 08:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbiF2Iu0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 04:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiF2IuY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 04:50:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7271C3CFEE
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 01:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656492619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GCe9P62qonkghX/SYOJKpeahBUa4kaR0QHgPgVgWRFU=;
        b=DPvoslPRakmrIdsHVaPV9aDQWen2NOz0sUmxRfuu3XCL1oU540+prRnnrwr9Zwj/4L8V3U
        6fpdbN676QBJxFM9DhmJ6no9ocVyNlBMpEVKaFdS0IMGouqMNZpbXeaheBnCX6K/rEV5Ol
        CJIaqIKgeNPg1s5FfEKENOY3+V8eVK0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-eS0EMeHVNpak7svDJO6-Ug-1; Wed, 29 Jun 2022 04:50:13 -0400
X-MC-Unique: eS0EMeHVNpak7svDJO6-Ug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97A7D802E5C;
        Wed, 29 Jun 2022 08:50:13 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B87A2166B26;
        Wed, 29 Jun 2022 08:50:13 +0000 (UTC)
Date:   Wed, 29 Jun 2022 10:50:08 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Switch to node list walk for overlap
 detection
Message-ID: <20220629105008.65c9abce@elisabeth>
In-Reply-To: <Yrnh2lqhvvzrT2ii@salvia>
References: <20220614010704.1416375-1-sbrivio@redhat.com>
        <Yrnh2lqhvvzrT2ii@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

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
> 
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
> 
> The .deactivate path looks for the last (possibly) active element. The
> .remove path depends on the element state: a) element is singleton (no
> pending elements), then erase from tree, b) element has a pending
> list, then replace the first element in the pending_list by this node,
> and splice pending_list (there might be more elements), c) this
> element is in the pending_list, the just remove it. This handles both
> commit (walks through the list of transaction forward direction) and
> abort path (walks through the list of transactions in backward
> direction).

I think that's brilliant, give me a couple of days to have a thorough
look at it.

-- 
Stefano

