Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 008B7E7B608
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Oct 2023 12:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242501AbjJDMsv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Oct 2023 08:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242482AbjJDMsu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2023 08:48:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35541BD
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2023 05:48:47 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qo1Iz-0001qs-3Y; Wed, 04 Oct 2023 14:48:45 +0200
Date:   Wed, 4 Oct 2023 14:48:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: do not refresh timeout when
 resetting element
Message-ID: <20231004124845.GA3974@breakpoint.cc>
References: <ZRw6B+28jT/uJxJP@orbyte.nwl.cc>
 <ZRxNnYWrsw0VXBNn@calendula>
 <ZRxU3+ZWP5JQVm3I@orbyte.nwl.cc>
 <ZRxXXr5H0grbSb9j@calendula>
 <ZRx1omPdNIq5UdRN@orbyte.nwl.cc>
 <ZR0b693BiY6KzD3k@calendula>
 <20231004080702.GD15013@breakpoint.cc>
 <ZR0hFIIqdTixdPi4@calendula>
 <20231004084623.GA9350@breakpoint.cc>
 <ZR0v54xJwllozQhR@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZR0v54xJwllozQhR@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Oct 04, 2023 at 10:46:23AM +0200, Florian Westphal wrote:
> > I don't think the dump paths were ever designed to munge existing
> > data.  For those parts that provide full/consistent serialization,
> > e.g. single rule is fetched, its fine.
> > 
> > But whenever we may yield in between successive partial dumps, its not.
> 
> Yes, netlink dumps do not provide atomic listing semantics, that is
> why there is the generation ID from userspace. I am trying to think of
> a way to achieve this from the kernel but I did not come with any so
> far.
>
> From userspace, it should be possible to keep a generation ID per
> object in the cache, so the cache becomes a collection of objects of
> different generations, then when listing, just take the objects that
> are still current. Or it should be possible to disambiguate this from
> userspace with the u64 handle, ie. keep stale objects around and merge
> them to new ones when fetching the counters.
> 
> But this is lots of work from userspace, and it might get more
> complicated if more transactions happen while retrying (see test
> script from Phil where transaction happens in an infinite loop).
>
> This is the other open issue we have been discussing lately :)

Right, there is an amalgamation of different issues, lets not get swamped
trying to solve everything at once :-)

I've collected a few patches and pushed them out to :testing.
Stresstest is still running but so far it looks good to me.

The updated audit selftest passes, as does Xins sctp test case.

I expect to do the PR in the next few hours or so.

I will followup on nf-next once upstream has pulled the PR
into net and did a net -> net-next merge, which might take a
while. Followup as in "send rebased patches that get rid of
the async gc in nft_set_rbtree".

Let me know if there is anything else I can help
with.

Phil, I know all of this sucks from your point of view,
this is also my fault, I did not pay too close attention
to the reset patches, and, to be clear, even if I would have
its likely I would have missed all of the implications
of reusing the dump infrastructure for this.

I have not applied Pablos patch to revert the "timeout reset"
because its relatively fresh compared to the other patches
in the batch (and the batch is already large enough).

But I do agree with having a separate facility for timeout
resets (timeout updates) would be better.

I also think we need to find a different strategy for the
dump-and-reset part when the reset could be interrupted
by a transaction.

ATM userspace would have to add a userspace lock like
iptables-legacy to prevent any generation id changes while
a "reset dump" is happening and I hope we can all agree that
this is something we definitely do not want :-)
