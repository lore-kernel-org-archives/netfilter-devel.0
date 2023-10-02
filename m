Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C8EE784B3
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Oct 2023 14:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237719AbjJBOXQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Oct 2023 10:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbjJBOXQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2023 10:23:16 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1751A4
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2023 07:23:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qnJpI-00020v-DW; Mon, 02 Oct 2023 16:23:12 +0200
Date:   Mon, 2 Oct 2023 16:23:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf 1/2] netfilter: nft_set_rbtree: move sync GC from
 insert path to set->ops->commit
Message-ID: <20231002142312.GC30843@breakpoint.cc>
References: <20230929164404.172081-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230929164404.172081-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> According to 2ee52ae94baa ("netfilter: nft_set_rbtree: skip sync GC for
> new elements in this transaction"), new elements in this transaction
> might expire before such transaction ends. Skip sync GC is needed for
> such elements otherwise commit path might walk over an already released
> object.
> 
> However, Florian found that while iterating the tree from the insert
> path for sync GC, it is possible that stale references could still
> happen for elements in the less-equal and great-than boundaries to
> narrow down the tree descend to speed up overlap detection, this
> triggers bogus overlap errors.
> 
> This patch skips expired elements in the overlap detection routine which
> iterates on the reversed ordered list of elements that represent the
> intervals. Since end elements provide no expiration extension, check for
> the next non-end element in this interval, hence, skip both elements in
> the iteration if the interval has expired.

10.1.2.3 - 10.1.2.30  (expired!)

transaction wants to add:
10.1.2.2 - 10.1.2.29

AFAICS, this is now mismerged into:

10.1.2.2 - 10.1.2.30, because walking back to
next end element from expired 10.1.2.3 will
find 10.1.2.29 as first preceeding end element, no?

and the "commit" operation comes after genid bump, so we can't
restrict that to "not active in next gen" or similar :-/

Can you use dead-bit instead?

Element has expired -> Mark element and the end-pair as dead,
then reap all expired and dead nodes from commit callback.

Problem is what to do after reset-inerval support is added,
because the newly-marked-dead elements could have a timeout
refresh already pending, and I don't see how this can be handled.
