Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F361C433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 15:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E566B60FE6
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 15:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354986AbhESP55 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 May 2021 11:57:57 -0400
Received: from mail.netfilter.org ([217.70.188.207]:46170 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355003AbhESP55 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 May 2021 11:57:57 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 41A886417D;
        Wed, 19 May 2021 17:55:41 +0200 (CEST)
Date:   Wed, 19 May 2021 17:56:33 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, dvyukov@google.com
Subject: Re: [PATCH nf,v2] netfilter: nftables: accept all dummy chain when
 table is dormant
Message-ID: <20210519155633.GA3182@salvia>
References: <20210519101402.45141-1-pablo@netfilter.org>
 <20210519121533.GC8317@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210519121533.GC8317@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 19, 2021 at 02:15:33PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > The dormant flag need to be updated from the preparation phase,
> > otherwise, two consecutive requests to dorm a table in the same batch
> > might try to remove the same hooks twice, resulting in the following
> > warning:
> > 
> >  hook not found, pf 3 num 0
> >  WARNING: CPU: 0 PID: 334 at net/netfilter/core.c:480 __nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
> >  Modules linked in:
> >  CPU: 0 PID: 334 Comm: kworker/u4:5 Not tainted 5.12.0-syzkaller #0
> >  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> >  Workqueue: netns cleanup_net
> >  RIP: 0010:__nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
> > 
> > This patch is a partial revert of 0ce7cf4127f1 ("netfilter: nftables:
> > update table flags from the commit phase") to restore the previous
> > behaviour, which updates the dormant flag from the preparation phase
> > to address this issue.
> > 
> > However, there is still another problem: A batch containing a series of
> > dorm-wakeup-dorm table and vice-versa also trigger the warning above
> > since hook unregistration happens from the preparation phase, while hook
> > registration occurs from the commit phase.
> 
> You could add nf_unregister_net_hook_try() or somesuch that elides
> the WARN().

Let me elaborate a bit more the problem here.

The hook registration happens from the preparation phase (because it
might fail for several reasons) and hook unregistration happens from
the commit phase (because registration from the abort phase is not
possible, since registration might fail). Hence, nf_register_net_hook()
cannot be called from the commit and abort phases, only from the
preparation phase.

I'm assuming that looking at dormant flags from commit/abort phase
to decide what to do.

Let's have a look a several possible scenarios:

Scenario A) batch containing two commands: dorm + wake up

From preparation phase.

- dorm: preparation phase sets the dormant flag (hooks are
        still registered).
- wake up: unset the dormant flag. This needs to skip hook
           registration, because they are already registered.
           (it needs a way to check that hooks are registered).

From commit phase.

- dorm: dormant flag is unset, no-op.
- wake-up: dormant flag is unset, no-op.

From abort phase (reversed), it undoes preparation phase.

- wake-up: set the dormant flag, unregister hooks.
- dorm: unset the dormant flag, register hooks (not possible)

Problems: Needs a function to check if hooks are present.
          abort phase needs to register hooks.

Scenario B) batch containing two commands: wake up + dorm

From preparation phase.

- wake up: unset the dormant flag. This needs to register hooks.
- dorm: preparation phase sets the dormant flag (hooks are
        still registered).

From commit phase.

- wake-up: dormant flag is set, unregister hooks.
- dorm: dormant flag is set, unregister hooks (again).

From abort phase (reversed), it undoes preparation phase.

- dorm: unset the dormant flag, register hooks (not possible)
- wake-up: set dormant flag, unregister hooks.

Problems: commit phase needs try_unregister hook function.
          abort phase needs to unregister hooks.

I can also describe dorm + wake up + dorm, and wake up + dorm + wake
up scenarios.

I also tried looking at the transaction state instead of the dormant
flags, similar problems.

I also tried adding more internal flags to annotate context. I looked
at adding fields to nft_table to count for the number of pending hook
registration / unregistration. It's all tricky.

The patch I posted is addressing the issue by skipping hook
registration / unregistration for dormant flags updates.

What's your concern with the approach I'm proposing?
