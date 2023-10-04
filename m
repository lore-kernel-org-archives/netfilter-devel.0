Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99BF7E7B5E1
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Oct 2023 09:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241782AbjJDJ1O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Oct 2023 05:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbjJDJ1N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2023 05:27:13 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC3F9E
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2023 02:27:08 -0700 (PDT)
Received: from [78.30.34.192] (port=37582 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qny9o-00A9AN-HK; Wed, 04 Oct 2023 11:27:06 +0200
Date:   Wed, 4 Oct 2023 11:27:03 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: do not refresh timeout when
 resetting element
Message-ID: <ZR0v54xJwllozQhR@calendula>
References: <ZRvG5vesKHRyUvzx@calendula>
 <ZRw6B+28jT/uJxJP@orbyte.nwl.cc>
 <ZRxNnYWrsw0VXBNn@calendula>
 <ZRxU3+ZWP5JQVm3I@orbyte.nwl.cc>
 <ZRxXXr5H0grbSb9j@calendula>
 <ZRx1omPdNIq5UdRN@orbyte.nwl.cc>
 <ZR0b693BiY6KzD3k@calendula>
 <20231004080702.GD15013@breakpoint.cc>
 <ZR0hFIIqdTixdPi4@calendula>
 <20231004084623.GA9350@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231004084623.GA9350@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 04, 2023 at 10:46:23AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Oct 04, 2023 at 10:07:02AM +0200, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > We will soon need NFT_MSG_GETRULE_RESET_NO_TIMEOUT to undo this combo
> > > > command semantics, from userspace this will require some sort of 'nft
> > > > reset table x notimeout' syntax.
> > > 
> > > NFT_MSG_GETRULE_RESET_NO_TIMEOUT sounds super ugly :/
> > > 
> > > Do you think we can add a flags attr that describes which parts
> > > to reset?
> > 
> > Sure. This will require one attribute for each object type, also
> > reject it where it does not make sense.
> > 
> > > No flags attr would reset everything.
> > 
> > Refreshing timers is a bad default behaviour.
> 
> Looking at the "evolution" of the reset command in nftables.git
> I agree.  "reset counters" etc. was rather specific as to what
> is reset.
> 
> > And how does this mix with the set element timeout model from
> > transaction? Now timers becomes a "moving target" again with this
> > refresh? Oh, this will drag commit_mutex to netlink dump path to avoid
> > that.
> 
> The lock is needed to prevent *two* reset calls messing up the
> interal object state, e.g. quota or counters.

Agreed, no question there is a need for a lock from that path, the
discussion so far has been what type of lock, whether reset_spinlock
or commit_mutex.

reset_spinlock just makes sure that:

Cpu 1: nft list ruleset
Cpu 2: nft reset ruleset

do not show negative counters, as Phil reported with a test script.

commit_mutex just mitigates this issue, for reason see my reply below.

> We will need *some* type of lock for the commands where
> the reset logic is handled via dump path.
> 
> At this point I think we should consider reverting ALL
> reset changes that use the dump path, because we also have
> the consistency issue:
> 
> Cpu 1: nft list ruleset
> Cpu 2: nft reset ruleset
> Cpu 3: transaction, seq is bumped
> 
> AFAIU Cpu2 will restart dump due to interrupt, so the listing
> will be consistent but will, on retry -- show counters zeroed
> in previous, inconsitent and suppressed dump.
>
> So I think the reset logic should be reworked to walk the rules
> and use the transaction infra to reset everything manually.
> I think we can optimize by letting userspace skip rules that
> lack a stateful object that cannot be reset.
> 
> I don't think the dump paths were ever designed to munge existing
> data.  For those parts that provide full/consistent serialization,
> e.g. single rule is fetched, its fine.
> 
> But whenever we may yield in between successive partial dumps, its not.

Yes, netlink dumps do not provide atomic listing semantics, that is
why there is the generation ID from userspace. I am trying to think of
a way to achieve this from the kernel but I did not come with any so
far.

From userspace, it should be possible to keep a generation ID per
object in the cache, so the cache becomes a collection of objects of
different generations, then when listing, just take the objects that
are still current. Or it should be possible to disambiguate this from
userspace with the u64 handle, ie. keep stale objects around and merge
them to new ones when fetching the counters.

But this is lots of work from userspace, and it might get more
complicated if more transactions happen while retrying (see test
script from Phil where transaction happens in an infinite loop).

This is the other open issue we have been discussing lately :)

> > For counters, this is to collect stats while leaving remaining things
> > as is. Refreshing timers make no sense to me.
> 
> Looking at the history, I agree... for something like "reset counters"
> its clear what should happen.
> 
> > For quota, this is to fetch the consumed quota and restart it, it
> > might make sense to refresh the timer, but transaction sounds like a
> > better path for this usecase?
> 
> See above, I agree.
