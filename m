Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01772CD80CD
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 13:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjJJNSF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 09:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjJJNSE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 09:18:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C13AF
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2023 06:18:02 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qqCca-0003HD-ND; Tue, 10 Oct 2023 15:18:00 +0200
Date:   Tue, 10 Oct 2023 15:18:00 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: do not refresh timeout when
 resetting element
Message-ID: <ZSVPCIMbH9zj22an@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <ZRxNnYWrsw0VXBNn@calendula>
 <ZRxU3+ZWP5JQVm3I@orbyte.nwl.cc>
 <ZRxXXr5H0grbSb9j@calendula>
 <ZRx1omPdNIq5UdRN@orbyte.nwl.cc>
 <ZR0b693BiY6KzD3k@calendula>
 <20231004080702.GD15013@breakpoint.cc>
 <ZR0hFIIqdTixdPi4@calendula>
 <20231004084623.GA9350@breakpoint.cc>
 <ZR0v54xJwllozQhR@calendula>
 <20231004124845.GA3974@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004124845.GA3974@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 04, 2023 at 02:48:45PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Oct 04, 2023 at 10:46:23AM +0200, Florian Westphal wrote:
> > > I don't think the dump paths were ever designed to munge existing
> > > data.  For those parts that provide full/consistent serialization,
> > > e.g. single rule is fetched, its fine.
> > > 
> > > But whenever we may yield in between successive partial dumps, its not.
> > 
> > Yes, netlink dumps do not provide atomic listing semantics, that is
> > why there is the generation ID from userspace. I am trying to think of
> > a way to achieve this from the kernel but I did not come with any so
> > far.
> >
> > From userspace, it should be possible to keep a generation ID per
> > object in the cache, so the cache becomes a collection of objects of
> > different generations, then when listing, just take the objects that
> > are still current. Or it should be possible to disambiguate this from
> > userspace with the u64 handle, ie. keep stale objects around and merge
> > them to new ones when fetching the counters.
> > 
> > But this is lots of work from userspace, and it might get more
> > complicated if more transactions happen while retrying (see test
> > script from Phil where transaction happens in an infinite loop).
> >
> > This is the other open issue we have been discussing lately :)
> 
> Right, there is an amalgamation of different issues, lets not get swamped
> trying to solve everything at once :-)
> 
> I've collected a few patches and pushed them out to :testing.
> Stresstest is still running but so far it looks good to me.
> 
> The updated audit selftest passes, as does Xins sctp test case.
> 
> I expect to do the PR in the next few hours or so.
> 
> I will followup on nf-next once upstream has pulled the PR
> into net and did a net -> net-next merge, which might take a
> while. Followup as in "send rebased patches that get rid of
> the async gc in nft_set_rbtree".
> 
> Let me know if there is anything else I can help
> with.
> 
> Phil, I know all of this sucks from your point of view,
> this is also my fault, I did not pay too close attention
> to the reset patches, and, to be clear, even if I would have
> its likely I would have missed all of the implications
> of reusing the dump infrastructure for this.
> 
> I have not applied Pablos patch to revert the "timeout reset"
> because its relatively fresh compared to the other patches
> in the batch (and the batch is already large enough).
> 
> But I do agree with having a separate facility for timeout
> resets (timeout updates) would be better.

I still think they are orthogonal in practice (even though they
"clash"):

Dynamic sets use a timeout as they are populated from packet path and
may grow exceedingly large over time. Manual intervention means deleting
elements (which "resets" them) or adding ones (as an alternative to
packet path).

Would non-dynamic sets use both a timeout and other state? I can't
imagine a use-case for this.

> I also think we need to find a different strategy for the
> dump-and-reset part when the reset could be interrupted
> by a transaction.
> 
> ATM userspace would have to add a userspace lock like
> iptables-legacy to prevent any generation id changes while
> a "reset dump" is happening and I hope we can all agree that
> this is something we definitely do not want :-)

I suggest to communicate the situation (for now) and make 'reset rule'
return the rule to user space so the non-plural reset commands (apart
from 'reset set') become reliable alternatives for those depending upon
it.

Setting expectations straight is still the easiest fix to both the
inconsistency problem and the "resets also timeouts" problem. In the
latter case, this should be fine already as nft(8) explicitly states
"resets timeout or other state" when describing 'reset element' and
'reset set'.

Then, consistent output for plural reset commands becomes a missing
feature one may add or not. Reset with or without timeout requires a
use-case (see above). The only real bug left is the concurrent reset
messing up values.

Cheers, Phil
