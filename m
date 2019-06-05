Return-Path: <SRS0=tNyb=UE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCFDAC28CC5
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 19:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4EAA206BB
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 19:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfFETZc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jun 2019 15:25:32 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:59278 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbfFETYb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 15:24:31 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hYbWP-0008I2-Ci; Wed, 05 Jun 2019 21:24:29 +0200
Date:   Wed, 5 Jun 2019 21:24:29 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nft PATCH v5 00/10] Cache update fix && intra-transaction rule
 references
Message-ID: <20190605192429.GX31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
References: <20190604173158.1184-1-phil@nwl.cc>
 <20190605170541.g4mhpsn7k72qyeso@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605170541.g4mhpsn7k72qyeso@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Jun 05, 2019 at 07:05:41PM +0200, Pablo Neira Ayuso wrote:
> Thanks a lot for working on this, I have a few comments.
> 
> On Tue, Jun 04, 2019 at 07:31:48PM +0200, Phil Sutter wrote:
> > Next round of combined cache update fix and intra-transaction rule
> > reference support.
> 
> Patch 1 looks good.
> 
> > Patch 2 is new, it avoids accidential cache updates when committing a
> > transaction containing flush ruleset command and kernel ruleset has
> > changed meanwhile.
> 
> Patch 2: Could you provide an example scenario for this new patch?

Given the sample nft input:

| flush ruleset
| add table t
| add chain t c
| ...

First command causes call of cache_flush(), which updates cache->genid
from kernel. Third command causes call to cache_update(). If in between
these two another process has committed a change to kernel, kernel's
genid has bumped and cache_update() will populate the cache because
cache_is_updated() returns false.

From the top of my head I don't see where these stray cache entries
would lead to spurious errors but it is clearly false behaviour in cache
update logic.

> > Patch 3 is also new: If a transaction fails in kernel, local cache is
> > incorrect - drop it.
> 
> Patch 3 looks good!
> 
> Regarding patches 4, 5 and 6. I think we can skip them if we follow
> the approach described by [1], given there is only one single
> cache_update() call after that patchset, we don't need to do the
> "Restore local entries after cache update" logic.
> 
> [1] https://marc.info/?l=netfilter-devel&m=155975322308042&w=2

The question is how we want to treat rule reference by index if cache is
outdated. We could be nice and recalculate the rule reference which
would require to rebuild the cache including own additions. We could
also just refer to the warning in nft.8 and do nothing about it. :)

> > Patch 9 is a new requirement for patch 10 due to relocation of new
> > functions.
> > 
> > Patch 10 was changed, changelog included.
> 
> Patch 10 looks fine. However, as said, I would like to avoid the patch
> dependencies 4, 5 and 6, they are adding more cache_update() calls and
> I think we should go in the opposite direction to end up with a more
> simple approach.

OK, so how to proceed from here? I see you've based your patch series
upon an earlier version of mine. If you provide me with a clean version,
I could apply the index reference stuff on top. Or something else?

Cheers, Phil
