Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 404A8E7545C
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Oct 2023 18:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjJCSYw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Oct 2023 14:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjJCSYv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Oct 2023 14:24:51 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23D8B4
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Oct 2023 11:24:48 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qnk4d-0003tg-0t; Tue, 03 Oct 2023 20:24:47 +0200
Date:   Tue, 3 Oct 2023 20:24:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: update element timeout support [was Re: [PATCH nf 1/2]
 netfilter: nft_set_rbtree: move sync GC from insert path to
 set->ops->commit]
Message-ID: <20231003182447.GB446@breakpoint.cc>
References: <ZRdOxs+i1EuC+zoS@calendula>
 <20230930081038.GB23327@breakpoint.cc>
 <ZRnSGwk40jpUActD@calendula>
 <20231001210816.GA15564@breakpoint.cc>
 <ZRq6oP2/hns1qoaq@calendula>
 <20231002135838.GB30843@breakpoint.cc>
 <20231002142141.GA7339@breakpoint.cc>
 <ZRvPSw5PGFyt7S10@calendula>
 <20231003090410.GA446@breakpoint.cc>
 <ZRviE9t+xJBV73Di@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRviE9t+xJBV73Di@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Right, I think that will work.
> > For rbtree, sync gc is kept in place, elements are not zapped,
> > they get tagged as DEAD, including the end element.
> > 
> > Then from commit, do full scan and remove any and all elements
> > that are flagged as DEAD or have expired.
> 
> Sounds good.
> 
> Would you follow this approach to fix the existing issue with the
> rbtree on-demand GC in nf.git?

Actually, I don't see why its needed. With your proposal
to make the "is_expired" check during transaction consistently based on
a fixed tstamp, expiry during transaction becomes impossible.
So we can keep immediate rb_erase around.

I suggest to take my proposal to erase, signal -EAGAIN to caller,
then have caller retry.  Apply this to nf.git as a bug fix.

Then, I can take my patches that are mixed into the gc rework;
split those up, and we take the "no more async rbtree gc" for nf-next.

Do you still spot a problem if we retain the on-insert node erase?

To give some numbers (async gc disabled):

Insert 20k ranges into rbtree (takes ~4minutes).
Wait until all have expired.
Insert a single range: takes 250ms (entire tree has to be purged).

Don't think it will be any faster with dead-bit approach,
we simply move cost to later in the transaction.

The only nf.git "advantage" is that we typically won't have
to zap the entire tree during transaction, but thats due to
async gc and I'd rather remove it.

What do you think?
