Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EC3E8FDDA
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Oct 2023 08:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241637AbjJDIaJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Oct 2023 04:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241680AbjJDIaI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2023 04:30:08 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B08483
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2023 01:30:05 -0700 (PDT)
Received: from [78.30.34.192] (port=60208 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qnxGb-009ptZ-RN; Wed, 04 Oct 2023 10:30:03 +0200
Date:   Wed, 4 Oct 2023 10:30:01 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: update element timeout support [was Re: [PATCH nf 1/2]
 netfilter: nft_set_rbtree: move sync GC from insert path to
 set->ops->commit]
Message-ID: <ZR0iicz5dwog2rqw@calendula>
References: <20230930081038.GB23327@breakpoint.cc>
 <ZRnSGwk40jpUActD@calendula>
 <20231001210816.GA15564@breakpoint.cc>
 <ZRq6oP2/hns1qoaq@calendula>
 <20231002135838.GB30843@breakpoint.cc>
 <20231002142141.GA7339@breakpoint.cc>
 <ZRvPSw5PGFyt7S10@calendula>
 <20231003090410.GA446@breakpoint.cc>
 <ZRviE9t+xJBV73Di@calendula>
 <20231003182447.GB446@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231003182447.GB446@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 03, 2023 at 08:24:47PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Right, I think that will work.
> > > For rbtree, sync gc is kept in place, elements are not zapped,
> > > they get tagged as DEAD, including the end element.
> > > 
> > > Then from commit, do full scan and remove any and all elements
> > > that are flagged as DEAD or have expired.
> > 
> > Sounds good.
> > 
> > Would you follow this approach to fix the existing issue with the
> > rbtree on-demand GC in nf.git?
> 
> Actually, I don't see why its needed. With your proposal
> to make the "is_expired" check during transaction consistently based on
> a fixed tstamp, expiry during transaction becomes impossible.
> So we can keep immediate rb_erase around.

Makes sense.

> I suggest to take my proposal to erase, signal -EAGAIN to caller,
> then have caller retry.  Apply this to nf.git as a bug fix.
> 
> Then, I can take my patches that are mixed into the gc rework;
> split those up, and we take the "no more async rbtree gc" for nf-next.
> 
> Do you still spot a problem if we retain the on-insert node erase?

Apart from this unbound loop, which sooner or later will not hit
EAGAIN, no.

> To give some numbers (async gc disabled):
> 
> Insert 20k ranges into rbtree (takes ~4minutes).
> Wait until all have expired.
> Insert a single range: takes 250ms (entire tree has to be purged).
> 
> Don't think it will be any faster with dead-bit approach,
> we simply move cost to later in the transaction.
>
> The only nf.git "advantage" is that we typically won't have
> to zap the entire tree during transaction, but thats due to
> async gc and I'd rather remove it.
> 
> What do you think?

I am fine with this approach.

What it comes, will be redo in nf-next.
