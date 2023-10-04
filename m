Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A6FE8FDDB
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Oct 2023 08:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241715AbjJDIqb convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Oct 2023 04:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241879AbjJDIqa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2023 04:46:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5510DC1
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2023 01:46:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qnxWR-0000CZ-OA; Wed, 04 Oct 2023 10:46:23 +0200
Date:   Wed, 4 Oct 2023 10:46:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: do not refresh timeout when
 resetting element
Message-ID: <20231004084623.GA9350@breakpoint.cc>
References: <ZRtKbZmqr4uZRT9Y@orbyte.nwl.cc>
 <ZRvG5vesKHRyUvzx@calendula>
 <ZRw6B+28jT/uJxJP@orbyte.nwl.cc>
 <ZRxNnYWrsw0VXBNn@calendula>
 <ZRxU3+ZWP5JQVm3I@orbyte.nwl.cc>
 <ZRxXXr5H0grbSb9j@calendula>
 <ZRx1omPdNIq5UdRN@orbyte.nwl.cc>
 <ZR0b693BiY6KzD3k@calendula>
 <20231004080702.GD15013@breakpoint.cc>
 <ZR0hFIIqdTixdPi4@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <ZR0hFIIqdTixdPi4@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Oct 04, 2023 at 10:07:02AM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > We will soon need NFT_MSG_GETRULE_RESET_NO_TIMEOUT to undo this combo
> > > command semantics, from userspace this will require some sort of 'nft
> > > reset table x notimeout' syntax.
> > 
> > NFT_MSG_GETRULE_RESET_NO_TIMEOUT sounds super ugly :/
> > 
> > Do you think we can add a flags attr that describes which parts
> > to reset?
> 
> Sure. This will require one attribute for each object type, also
> reject it where it does not make sense.
> 
> > No flags attr would reset everything.
> 
> Refreshing timers is a bad default behaviour.

Looking at the "evolution" of the reset command in nftables.git
I agree.  "reset counters" etc. was rather specific as to what
is reset.

> And how does this mix with the set element timeout model from
> transaction? Now timers becomes a "moving target" again with this
> refresh? Oh, this will drag commit_mutex to netlink dump path to avoid
> that.

The lock is needed to prevent *two* reset calls messing up the
interal object state, e.g. quota or counters.

We will need *some* type of lock for the commands where
the reset logic is handled via dump path.

At this point I think we should consider reverting ALL
reset changes that use the dump path, because we also have
the consistency issue:

Cpu 1: nft list ruleset
Cpu 2: nft reset ruleset
Cpu 3: transaction, seq is bumped

AFAIU Cpu2 will restart dump due to interrupt, so the listing
will be consistent but will, on retry -- show counters zeroed
in previous, inconsitent and suppressed dump.

So I think the reset logic should be reworked to walk the rules
and use the transaction infra to reset everything manually.
I think we can optimize by letting userspace skip rules that
lack a stateful object that cannot be reset.

I don't think the dump paths were ever designed to munge existing
data.  For those parts that provide full/consistent serialization,
e.g. single rule is fetched, its fine.

But whenever we may yield in between successive partial dumps, its not.

> For counters, this is to collect stats while leaving remaining things
> as is. Refreshing timers make no sense to me.

Looking at the history, I agree... for something like "reset counters"
its clear what should happen.

> For quota, this is to fetch the consumed quota and restart it, it
> might make sense to refresh the timer, but transaction sounds like a
> better path for this usecase?

See above, I agree.
