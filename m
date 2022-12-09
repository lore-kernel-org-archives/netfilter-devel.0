Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A859AC4167B
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Dec 2022 00:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiLIAPr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 19:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiLIAPB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 19:15:01 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1376892316
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 16:14:52 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p3R2Q-0002qE-Gg; Fri, 09 Dec 2022 01:14:50 +0100
Date:   Fri, 9 Dec 2022 01:14:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH 1/4] xt: Delay libxtables access until translation
Message-ID: <Y5J9+hCSYPWYTl0N@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20221124165641.26921-1-phil@nwl.cc>
 <20221124165641.26921-2-phil@nwl.cc>
 <Y5JVPqq30gcoYT9X@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5JVPqq30gcoYT9X@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,


On Thu, Dec 08, 2022 at 10:21:02PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 24, 2022 at 05:56:38PM +0100, Phil Sutter wrote:
> > There is no point in spending efforts setting up the xt match/target
> > when it is not printed afterwards. So just store the statement data from
> > libnftnl in struct xt_stmt and perform the extension lookup from
> > xt_stmt_xlate() instead.
> 
> There is nft -i and nft monitor which keep a ruleset cache. Both are
> sort of incomplete: nft -i resorts to cleaning up the cache based on
> the generation number and nft monitor still needs to be updated to
> keep track of incremental ruleset updates via netlink events. Sooner
> or later these two will get better support for incremental ruleset
> updates.
> 
> I mean, in those two cases, every call to print the translation will
> trigger the allocation of the xt structures, fill them and then call
> .xlate. I agree it is a bit more work, I guess this won't case any
> noticeable penalty, but it might be work that needs to be done over
> and over again when ruleset uses xt match / target.

So you're saying the overhead when printing a rule might be more
significant than when fetching it. I doubt this simply because the same
rule is usually printed at most once and there are multiple other
commands requiring a rule cache.

IMO we may also just leave the code as-is and wait for someone to
complain about bad performance with rulesets containing many compat
expressions. Depending on the actual report, we may also follow a hybrid
approach and do the match/target lookup only when needed and cache it
for later use.

My patch made most sense with an nft in mind which does not need xtables
support for saving/restoring compat expressions. Users depending on this
for whatever reason will execute the xlate code path in any case now.

Cheers, Phil
