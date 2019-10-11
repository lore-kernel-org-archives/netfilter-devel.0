Return-Path: <SRS0=pLNN=YE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB97DC47404
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Oct 2019 11:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1936214E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Oct 2019 11:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfJKLYy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Oct 2019 07:24:54 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:55260 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727226AbfJKLYy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Oct 2019 07:24:54 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iIt2S-0004b9-5n; Fri, 11 Oct 2019 13:24:52 +0200
Date:   Fri, 11 Oct 2019 13:24:52 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v3 04/11] nft-cache: Introduce cache levels
Message-ID: <20191011112452.GS12661@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011102052.77s5ujrdb3ficddo@salvia>
 <20191011092823.dfzjjxmmgqx63eae@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, Oct 11, 2019 at 11:28:23AM +0200, Pablo Neira Ayuso wrote:
[...]
> You could also just parse the ruleset twice in userspace, once to
> calculate the cache you need and another to actually create the
> transaction batch and push it into the kernel. That's a bit poor man
> approach, but it might work. You would need to invoke
> xtables_restore_parse() twice.

The problem with parsing twice is having to cache input which may be
huge for xtables-restore.

On Fri, Oct 11, 2019 at 12:20:52PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Oct 11, 2019 at 12:09:11AM +0200, Phil Sutter wrote:
> [...]
> > Maybe we could go with a simpler solution for now, which is to check
> > kernel genid again and drop the local cache if it differs from what's
> > stored. If it doesn't, the current cache is still up to date and we may
> > just fetch what's missing. Or does that leave room for a race condition?
> 
> My concern with this approach is that, in the dynamic ruleset update
> scenarios, assuming very frequent updates, you might lose race when
> building the cache in stages. Hence, forcing you to restart from
> scratch in the middle of the transaction handling.

In a very busy environment there's always trouble, simply because we
can't atomically fetch ruleset from kernel and adjust and submit our
batch. Dealing with that means we're back at xtables-lock.

> I prefer to calculate the cache that is needed in one go by analyzing
> the batch, it's simpler. Note that we might lose race still since
> kernel might tell us we're working on an obsolete generation number ID
> cache, forcing us to restart.

My idea for conditional cache reset is based on the assumption that
conflicts are rare and we want to optimize for non-conflict case. So
core logic would be:

1) fetch kernel genid into genid_start
2) if cache level > NFT_CL_NONE and cache genid != genid_start:
   2a) drop local caches
   2b) set cache level to NFT_CL_NONE
3) call cache fetchers based on cache level and desired level
4) fetch kernel genid into genid_end
5) if genid_start != genid_end goto 1

So this is basically the old algorithm but with (2) added. What do you
think?

Thanks, Phil
