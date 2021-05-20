Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89AF7C433ED
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 May 2021 22:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D6F461074
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 May 2021 22:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhETWwV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 May 2021 18:52:21 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49646 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbhETWwT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 May 2021 18:52:19 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6AA1A64197;
        Fri, 21 May 2021 00:50:00 +0200 (CEST)
Date:   Fri, 21 May 2021 00:50:54 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, dvyukov@google.com
Subject: Re: [PATCH nf,v2] netfilter: nftables: accept all dummy chain when
 table is dormant
Message-ID: <20210520225054.GA31069@salvia>
References: <20210519101402.45141-1-pablo@netfilter.org>
 <20210519121533.GC8317@breakpoint.cc>
 <20210519155633.GA3182@salvia>
 <20210519183404.GG8317@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210519183404.GG8317@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 19, 2021 at 08:34:04PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > Let's have a look a several possible scenarios:
> > 
> > Scenario A) batch containing two commands: dorm + wake up
> > 
> > From preparation phase.
> > 
> > - dorm: preparation phase sets the dormant flag (hooks are
> >         still registered).
> > - wake up: unset the dormant flag. This needs to skip hook
> >            registration, because they are already registered.
> >            (it needs a way to check that hooks are registered).
> > 
> > From commit phase.
> > 
> > - dorm: dormant flag is unset, no-op.
> > - wake-up: dormant flag is unset, no-op.
> > 
> > From abort phase (reversed), it undoes preparation phase.
> > 
> > - wake-up: set the dormant flag, unregister hooks.
> > - dorm: unset the dormant flag, register hooks (not possible)
> > 
> > Problems: Needs a function to check if hooks are present.
> >           abort phase needs to register hooks.
> 
> I agree that abort and/or commit phases cannot register hooks.
> 
> > Scenario B) batch containing two commands: wake up + dorm
> > 
> > From preparation phase.
> > 
> > - wake up: unset the dormant flag. This needs to register hooks.
> > - dorm: preparation phase sets the dormant flag (hooks are
> >         still registered).
> > 
> > From commit phase.
> > 
> > - wake-up: dormant flag is set, unregister hooks.
> > - dorm: dormant flag is set, unregister hooks (again).
> > 
> > From abort phase (reversed), it undoes preparation phase.
> > 
> > - dorm: unset the dormant flag, register hooks (not possible)
> > - wake-up: set dormant flag, unregister hooks.
> > 
> > Problems: commit phase needs try_unregister hook function.
> >           abort phase needs to unregister hooks.
> 
> ... but that is doable in the sense that unregister can't fail.

Right, but adding "unregister hooks" to the abort path breaks a
different scenario. This might unregister a hook that, because of a later
wake-up action, needs to stay there, because you cannot call register
a hook from the abort path, it's a bit of a whac-a-mole game.

> > I also tried looking at the transaction state instead of the dormant
> > flags, similar problems.
> > 
> > I also tried adding more internal flags to annotate context. I looked
> > at adding fields to nft_table to count for the number of pending hook
> > registration / unregistration. It's all tricky.
> 
> Ok, too bad.
> 
> > The patch I posted is addressing the issue by skipping hook
> > registration / unregistration for dormant flags updates.
> > 
> > What's your concern with the approach I'm proposing?
> 
> No concern, I did not understand the problem with hook register in
> abort/commit.
> 
> I also dislike that dormat tables now retrain the hook overhead, but
> I guess dormat tables are an exception and not the norm, so maybe
> unfounded concern.

You are right that this approach incurs in the hook evaluation penalty
from the packet path. But I don't think there's a need to optimize
this feature at this stage. If it turns out that this needs to be
optimized, maybe it should be possible to add a core feature to
disable hook while leaving in registered (ie. hook "dormant" state).

So I'm just inclined to keep it simple while making sure that any
possible (silly) robot-generated sequence with this toggle works fine.
