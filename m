Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F2DC7EE2D
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 May 2023 15:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjEYPug (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 May 2023 11:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236063AbjEYPuT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 May 2023 11:50:19 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03C9C0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 May 2023 08:50:17 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1q2DEG-0006c9-Cz; Thu, 25 May 2023 17:50:16 +0200
Date:   Thu, 25 May 2023 17:50:16 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v1 0/6] nf_tables combo match
Message-ID: <20230525155016.GA25057@breakpoint.cc>
References: <20230525154024.222338-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525154024.222338-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi,
> 
> This patchset provides the combo match for payload and the iifname and
> oifname meta selector. The idea is to track and coalesce expressions in
> an internal special combo expression. This batch adds support to coalesce
> the following expressions:
> 
> 	payload + cmp
> 	payload + bitwise + cmp
> 	meta {iifname,oifname} + cmp

Interesting concept, thanks for exploring this.

> The coalesce happens when the ruleset blob is built, the expression
> tracking is done at rule level, ie. by iterating over the expressions
> that represent the rule. The expression tracking happens twice, once to
> calculate the ruleset blob (because the combo expression alters the
> expected rule data size) and then to build the ruleset blob.

This might be useful for other representation transformations, cf. the
pending 'remove register zeroing' patchset.

If that breaks 3rd party users we can now simply force the zeroing
from the internal ruleset representation.

> This batch replaces the existing approach which based on fast variants
> of the cmp and bitwise expressions, that are also removed.

I think its good to re-evaluate the eval loop from time to time
and axe whats not needed anymore.

> This approach is an alternative to the register track & reduce approach,
> which so far works at chain level. Such approach requires descending the
> tree of chains and tracking registers from base to leaf chains, this
> becomes more complicated with dynamic ruleset, but it could be useful
> for static rulesets, such approach also requires significant updates in
> userspace. Therefore, I'm inclined towards this more simple solution.

I like this approach.

> One question with this update is whether removing the fast bitwise and
> cmp variants slows down other (non-coalesced) expressions. The results
> I collected with a simple ruleset to test worst case scenario like this:
> 
> 	-m state --state ESTABLISHED -j DROP
> 	... 99 times more
> 	-m state --state NEW -j DROP  [ <- this is the matching rule ]

Oh, I was about to ask if you're using an out-of-tree version but
then I saw you picked this to test *absence* of any cmp/bitwise.

> shows 301 Mb/s without this patchset vs 412 Mb/s with this patchset,

Did not expect such a big difference.

> that it, results are better with this patchset while the payload and
> meta expression that are coalesced show much better numbers.
> 
> I'm collecting more detailed numbers, I will post them soon.

Excellent, thanks!  I think this is a good appraoch, I will review
patches in more detail soon.
