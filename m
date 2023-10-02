Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F6CBE776C6
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Oct 2023 21:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjJBVhm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Oct 2023 17:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjJBVhl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2023 17:37:41 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71346AB
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2023 14:37:38 -0700 (PDT)
Received: from [78.30.34.192] (port=36642 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qnQbe-00GTzA-LR; Mon, 02 Oct 2023 23:37:36 +0200
Date:   Mon, 2 Oct 2023 23:37:33 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 1/2] netfilter: nft_set_rbtree: move sync GC from
 insert path to set->ops->commit
Message-ID: <ZRs4HTMWTx2eVjb8@calendula>
References: <20230929164404.172081-1-pablo@netfilter.org>
 <20231002142312.GC30843@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231002142312.GC30843@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 02, 2023 at 04:23:12PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > According to 2ee52ae94baa ("netfilter: nft_set_rbtree: skip sync GC for
> > new elements in this transaction"), new elements in this transaction
> > might expire before such transaction ends. Skip sync GC is needed for
> > such elements otherwise commit path might walk over an already released
> > object.
> > 
> > However, Florian found that while iterating the tree from the insert
> > path for sync GC, it is possible that stale references could still
> > happen for elements in the less-equal and great-than boundaries to
> > narrow down the tree descend to speed up overlap detection, this
> > triggers bogus overlap errors.
> > 
> > This patch skips expired elements in the overlap detection routine which
> > iterates on the reversed ordered list of elements that represent the
> > intervals. Since end elements provide no expiration extension, check for
> > the next non-end element in this interval, hence, skip both elements in
> > the iteration if the interval has expired.
> 
> 10.1.2.3 - 10.1.2.30  (expired!)
> 
> transaction wants to add:
> 10.1.2.2 - 10.1.2.29
> 
> AFAICS, this is now mismerged into:
> 
> 10.1.2.2 - 10.1.2.30, because walking back to
> next end element from expired 10.1.2.3 will
> find 10.1.2.29 as first preceeding end element, no?
> 
> and the "commit" operation comes after genid bump, so we can't
> restrict that to "not active in next gen" or similar :-/
> 
> Can you use dead-bit instead?
> 
> Element has expired -> Mark element and the end-pair as dead,
> then reap all expired and dead nodes from commit callback.

This makes sense.

> Problem is what to do after reset-inerval support is added,
> because the newly-marked-dead elements could have a timeout
> refresh already pending, and I don't see how this can be handled.

Yes, refresh set element timeout semantics depends on what the timeout
says in the preparation phase. The same problem that is being
discussed in the other two emails in different thread.

We could annotate the current time at the beginning of the
transaction and use it to check if the element has expired, so set
element expiration stops being a moving target.
