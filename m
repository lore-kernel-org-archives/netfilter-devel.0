Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C7AE776C4
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Oct 2023 21:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjJBVKs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Oct 2023 17:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjJBVKs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2023 17:10:48 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD598E
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2023 14:10:45 -0700 (PDT)
Received: from [78.30.34.192] (port=36638 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qnQBc-00GKmM-2K; Mon, 02 Oct 2023 23:10:42 +0200
Date:   Mon, 2 Oct 2023 23:10:38 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: update element timeout support [was Re: [PATCH nf 1/2]
 netfilter: nft_set_rbtree: move sync GC from insert path to
 set->ops->commit]
Message-ID: <ZRsxzoZDf4ixrv6b@calendula>
References: <20230929164404.172081-1-pablo@netfilter.org>
 <ZRdOxs+i1EuC+zoS@calendula>
 <20230930081038.GB23327@breakpoint.cc>
 <ZRnSGwk40jpUActD@calendula>
 <20231001210816.GA15564@breakpoint.cc>
 <ZRq6oP2/hns1qoaq@calendula>
 <20231002135838.GB30843@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231002135838.GB30843@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 02, 2023 at 03:58:38PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sun, Oct 01, 2023 at 11:08:16PM +0200, Florian Westphal wrote:
> > > Element E1, times out in 1 hour
> > > Element E2, times out in 1 second
> > > Element E3, timed out (1 second ago, 3 minutes ago, doesn't matter).
> > > 
> > > Userspace batch to kernel:
> > > Update Element E1 to time out in 2 hours.
> > > Update Element E2 to time out in 1 hour.
> > > Update Element E3 to time out in 1 hour.
> > > 
> > > What is the expected outcome of this request?
> > > 
> > > Ignore E3 being reaped already and refresh the timeout (resurrection?)
> > 
> > No resurrection, the element might have counters, it already expired.
> 
> OK.
> 
> > > Ignore E3 being reaped already and ignore the request?
> > > Fail the transaction as E3 timed out already ("does not exist")?
> > 
> > Add a new E3. If NLM_F_EXCL is specified, then fail with "does not exist"
> 
> OK.

Actually not correct what I said in this case: NLM_F_EXCL means create
in newsetelem() path, then add new E3 always succeeds if there is a
timed out E3, regardless the flag.

No "does not exist" error is possible.

> > > Now, what about E2?  If transaction is large, it could become
> > > like E3 *during the transaction* unless we introduce some freezing
> > > mechanism.  Whats the expected outcome?
> > > 
> > > Whats the expected outcome if there is some other, unrelated
> > > failure? I assume we have to roll back all the timeout updates, right?
> > 
> > We annotate the new timeout in transaction object, then refresh the
> > timeout update in the commit phase.
> 
> OK, so as per "E3-example", you're saying that if E2 expires during
> the transaction, then if F_EXCL is given the transaction will fail while
> otherwise it will be re-added.

Please, revisit if the semantics look correct to you after my
correction on the NLM_F_EXCL flag.

> > > If so, why not temporarily make the timeouts effective right away
> > > and then roll back?
> > 
> > You mean, from the preparation phase? Then we need to undo what has
> > been done, in case of --check / abort path is exercised, this might
> > just create a bogus element listing.
> 
> True.  Am I correct that we can't implement the "expand" via
> del+add because of stateful objects?

I think it is not a good idea to expand a element that has already
expired. There might be another possible corner case:

Refresh element E1 with timeout X -> not expired yet
Element E1 expires
Refresh element E1 with timeout Y -> already expired, ENOENT.

This looks fine to me, this handling is possible because the timeout
is not updated from the preparation phase, only later in the commit
phase.

> I fear we will need to circle back to rbtree then, I'll followup
> there (wrt. on-demand gc).
>
> > No need for rollback if new timeout is store in the transaction
> > object, we just set the new timeout from _commit() step in the
> > NEWSETELEM case, which has to deal with updates. Other objects follow
> > a similar approach.
> 
> Got it.
