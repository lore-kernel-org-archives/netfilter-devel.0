Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B29C7E784AC
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Oct 2023 13:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237593AbjJBN6p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Oct 2023 09:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237622AbjJBN6o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2023 09:58:44 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A81B0
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2023 06:58:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qnJRW-0001oQ-RQ; Mon, 02 Oct 2023 15:58:38 +0200
Date:   Mon, 2 Oct 2023 15:58:38 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: update element timeout support [was Re: [PATCH nf 1/2]
 netfilter: nft_set_rbtree: move sync GC from insert path to
 set->ops->commit]
Message-ID: <20231002135838.GB30843@breakpoint.cc>
References: <20230929164404.172081-1-pablo@netfilter.org>
 <ZRdOxs+i1EuC+zoS@calendula>
 <20230930081038.GB23327@breakpoint.cc>
 <ZRnSGwk40jpUActD@calendula>
 <20231001210816.GA15564@breakpoint.cc>
 <ZRq6oP2/hns1qoaq@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRq6oP2/hns1qoaq@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Oct 01, 2023 at 11:08:16PM +0200, Florian Westphal wrote:
> > Element E1, times out in 1 hour
> > Element E2, times out in 1 second
> > Element E3, timed out (1 second ago, 3 minutes ago, doesn't matter).
> > 
> > Userspace batch to kernel:
> > Update Element E1 to time out in 2 hours.
> > Update Element E2 to time out in 1 hour.
> > Update Element E3 to time out in 1 hour.
> > 
> > What is the expected outcome of this request?
> > 
> > Ignore E3 being reaped already and refresh the timeout (resurrection?)
> 
> No resurrection, the element might have counters, it already expired.

OK.

> > Ignore E3 being reaped already and ignore the request?
> > Fail the transaction as E3 timed out already ("does not exist")?
> 
> Add a new E3. If NLM_F_EXCL is specified, then fail with "does not exist"

OK.

> > Now, what about E2?  If transaction is large, it could become
> > like E3 *during the transaction* unless we introduce some freezing
> > mechanism.  Whats the expected outcome?
> > 
> > Whats the expected outcome if there is some other, unrelated
> > failure? I assume we have to roll back all the timeout updates, right?
> 
> We annotate the new timeout in transaction object, then refresh the
> timeout update in the commit phase.

OK, so as per "E3-example", you're saying that if E2 expires during
the transaction, then if F_EXCL is given the transaction will fail while
otherwise it will be re-added.

> > If so, why not temporarily make the timeouts effective right away
> > and then roll back?
> 
> You mean, from the preparation phase? Then we need to undo what has
> been done, in case of --check / abort path is exercised, this might
> just create a bogus element listing.

True.  Am I correct that we can't implement the "expand" via
del+add because of stateful objects?

I fear we will need to circle back to rbtree then, I'll followup
there (wrt. on-demand gc).

> No need for rollback if new timeout is store in the transaction
> object, we just set the new timeout from _commit() step in the
> NEWSETELEM case, which has to deal with updates. Other objects follow
> a similar approach.

Got it.
