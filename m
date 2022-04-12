Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71492C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Apr 2022 23:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiDLXsy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiDLXse (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 19:48:34 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 749CC16594
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2022 16:41:20 -0700 (PDT)
Date:   Wed, 13 Apr 2022 01:41:17 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables 0/9] nftables: add support for wildcard string
 as set keys
Message-ID: <YlYOHUwlic4fNzAD@salvia>
References: <20220409135832.17401-1-fw@strlen.de>
 <YlX6gfgq4SFPTU+B@salvia>
 <20220412224335.GB10279@breakpoint.cc>
 <YlYGXSrxnspdBzr5@salvia>
 <20220412233023.GF10279@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220412233023.GF10279@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 13, 2022 at 01:30:23AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Yes, but its like this also before my patch, there are several
> > > test failures on s390 with nft master.
> > 
> > Why is the listing being reordered?
> 
> No idea, I only saw that this reordering happens, i did not have time to
> investigate so far.
> 
> > > I will have a look, so far I only checked that my patch
> > > series does not cause any additional test failures, and the only
> > > reason why the new test fails is the output reorder on s390.
> > 
> > This is also related to the set description patchset that Phil posted,
> > correct?
> 
> No, I don't even know what patchset you are talking about.
> Is it because of failing pything tests because the debug output has
> endianess issues?  If so, not related.
> 
> > If you consider that adding remaining features is feasible,
> > incrementally should be fine.
> 
> Hmm, if there is a technical reason as to why it does not work,
> do you think we should hold it back?
> 
> It lookes like filter on "{ eth0, ppp* }" works fine as-is.

Then, good. Better than not working.

> I thought that something like "eth0-eth42" would also be doable,
> by treating both as 128bit bit-string.
> 
> Don't see what prevents "ppp* . 80" from working from a technical pov.
> 
> So, I *think* its fine to add the pure ifname set support now and
> add the rest incrementally.

OK, then move on.

Sorry, I read you cover letter and I thought there were pending
issues.
