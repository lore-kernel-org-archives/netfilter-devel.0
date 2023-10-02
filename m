Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C60E784AC
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Oct 2023 12:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236982AbjJBMmU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Oct 2023 08:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjJBMmT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2023 08:42:19 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3E1A6
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2023 05:42:14 -0700 (PDT)
Received: from [78.30.34.192] (port=53314 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qnIFV-00Dl3m-Pt; Mon, 02 Oct 2023 14:42:11 +0200
Date:   Mon, 2 Oct 2023 14:42:08 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: update element timeout support [was Re: [PATCH nf 1/2] netfilter:
 nft_set_rbtree: move sync GC from insert path to set->ops->commit]
Message-ID: <ZRq6oP2/hns1qoaq@calendula>
References: <20230929164404.172081-1-pablo@netfilter.org>
 <ZRdOxs+i1EuC+zoS@calendula>
 <20230930081038.GB23327@breakpoint.cc>
 <ZRnSGwk40jpUActD@calendula>
 <20231001210816.GA15564@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231001210816.GA15564@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Oct 01, 2023 at 11:08:16PM +0200, Florian Westphal wrote:
> Not convinced. In particular, I don't understand what this has to do
> with async vs. sync gc.  To me this depends how we want to handle
> elements that have expired or expire during transaction.
> 
> Example:
> 
> Element E1, times out in 1 hour
> Element E2, times out in 1 second
> Element E3, timed out (1 second ago, 3 minutes ago, doesn't matter).
> 
> Userspace batch to kernel:
> Update Element E1 to time out in 2 hours.
> Update Element E2 to time out in 1 hour.
> Update Element E3 to time out in 1 hour.
> 
> What is the expected outcome of this request?
> 
> Ignore E3 being reaped already and refresh the timeout (resurrection?)

No resurrection, the element might have counters, it already expired.

> Ignore E3 being reaped already and ignore the request?
> Fail the transaction as E3 timed out already ("does not exist")?

Add a new E3. If NLM_F_EXCL is specified, then fail with "does not exist"

> Now, what about E2?  If transaction is large, it could become
> like E3 *during the transaction* unless we introduce some freezing
> mechanism.  Whats the expected outcome?
> 
> Whats the expected outcome if there is some other, unrelated
> failure? I assume we have to roll back all the timeout updates, right?

We annotate the new timeout in transaction object, then refresh the
timeout update in the commit phase.

> If so, why not temporarily make the timeouts effective right away
> and then roll back?

You mean, from the preparation phase? Then we need to undo what has
been done, in case of --check / abort path is exercised, this might
just create a bogus element listing.

> What if userspace asks to *shrink* timeouts? Same scenario:
> 
> Update Element E1 to time out in 1 second
> Update Element E2 to time out in 1 second
> Update Element E3 to time out in 1 second
> 
> We could say 'not supported' of course, would avoid the
> rollback headache, because in this case long transaction
> gc would definitely start to pick some of those elements
> up for reaping...

No need for rollback if new timeout is store in the transaction
object, we just set the new timeout from _commit() step in the
NEWSETELEM case, which has to deal with updates. Other objects follow
a similar approach.
