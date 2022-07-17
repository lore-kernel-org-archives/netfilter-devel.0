Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 320AEC43334
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Jul 2022 13:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiGQNjZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 17 Jul 2022 09:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGQNjX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 Jul 2022 09:39:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EFAA0A1AF
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Jul 2022 06:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658065161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fPn6vHWTTXwJ/WSPByyok+BFMNE4FTaMJDqdlyphMQA=;
        b=hbNXCQIN0dCNyi6btk6QNGT18ujjKlg5gOCZeHSZEJJNTXAS3zhNmKxTFcKpezlSp/Uka8
        VzkbwOyb83tVmNRD2NbvjYV0pEN+E89ZdriqONYwdA/kOSw3ZNeJMgaYq1gbe9xDTf6PBA
        WjxvXfZb8jVUwly1ZcQ/CJEfLWPotJU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-oJU8XdilOB-N28nqd4-VZA-1; Sun, 17 Jul 2022 09:39:14 -0400
X-MC-Unique: oJU8XdilOB-N28nqd4-VZA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E46B480A0BC;
        Sun, 17 Jul 2022 13:39:13 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B73052166B26;
        Sun, 17 Jul 2022 13:39:13 +0000 (UTC)
Date:   Sun, 17 Jul 2022 15:39:10 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Switch to node list walk for overlap
 detection
Message-ID: <20220717153910.474aa5d6@elisabeth>
In-Reply-To: <YtFL8OWnViZGma3g@salvia>
References: <20220614010704.1416375-1-sbrivio@redhat.com>
        <Yrnh2lqhvvzrT2ii@salvia>
        <20220702015510.08ee9401@elisabeth>
        <YsQmS4+qdFz8s+sN@salvia>
        <20220706231242.492ba5d1@elisabeth>
        <YtFL8OWnViZGma3g@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 15 Jul 2022 13:13:52 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Wed, Jul 06, 2022 at 11:12:42PM +0200, Stefano Brivio wrote:
> > On Tue, 5 Jul 2022 13:53:47 +0200
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:  
> [...]
> > This simplifies the handling of those cases, we wouldn't need all those
> > clauses anymore, but I really think that the existing problem comes from
> > the fact we can *not* descend the tree just by selecting key values.  
> 
> Thanks for explaining.
> 
> The traversal rbtree via rb_first() and rb_next() is like an ordered
> linear list walk, maybe it is possible to reduce the number of
> elements to find an overlap?

Hah, yes, that's what I was also thinking about, but:

> I'm attaching an incremental patch on top of yours, idea is:
> 
> 1) find the closest element whose key is less than the new element
>    by descending the tree. This provides the first node to walk.

this step is also prone to the original issue, that is, the choice of
the first node to walk might also be affected by inactive elements.

Now, I _guess_ the way you implemented it (not checking if elements
are active in this step) should be correct in any case, because the
tree ordering is always correct, so any active element that might be
"hidden" should become part of the walk anyway.

But give me a couple of days to think about it and if there might be
other corner cases.

> 2) annotate closest active element that is less than the new element,
>    walking over the ordered list.
> 
> 3) annotate closest active element that is more than the new element,
>    Stop walking the ordered list.
> 
> 4) if new element is an exact match, then EEXIST.
> 
> 5) if new element is end and closest less than element is end, or
>    if new element is start and closest less than element is start, or
>    if new element is end and closest more than element is end,
>    Then ENOTEMPTY.

All these look safe (and correct) to me.

> Inactive/expired elements are skipped while walking the ordered linear
> list as usual.
> 
> With this incremental patch, I don't observe longer time to load
> interval sets.

Thanks a lot. I'll get back to you in a bit.

-- 
Stefano

