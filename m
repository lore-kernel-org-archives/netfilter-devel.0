Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD39E7E635
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Sep 2023 13:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbjIZN70 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Sep 2023 09:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234828AbjIZN70 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2023 09:59:26 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3033FC
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 06:59:18 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ql8ap-0003Sp-Us; Tue, 26 Sep 2023 15:59:16 +0200
Date:   Tue, 26 Sep 2023 15:59:15 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH 2/5] netfilter: nf_tables: Add locking for
 NFT_MSG_GETRULE_RESET requests
Message-ID: <ZRLjs5Rv91mJWbC0@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20230923013807.11398-3-phil@nwl.cc>
 <20230923110437.GB22532@breakpoint.cc>
 <ZQ7+MF4aweUYmU7j@orbyte.nwl.cc>
 <20230923161813.GB19098@breakpoint.cc>
 <ZRFTx6pFYt2tZuSy@calendula>
 <20230925195317.GC22532@breakpoint.cc>
 <ZRKlszo1ra1EakD+@orbyte.nwl.cc>
 <ZRKt31Vs382Z31IO@calendula>
 <ZRLLDbVlYK5c9HX+@orbyte.nwl.cc>
 <ZRLd8MxWZMt3O/Yh@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRLd8MxWZMt3O/Yh@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 26, 2023 at 03:34:40PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Sep 26, 2023 at 02:14:05PM +0200, Phil Sutter wrote:
> > On Tue, Sep 26, 2023 at 12:09:35PM +0200, Pablo Neira Ayuso wrote:
> > > Hi Phil,
> > > 
> > > On Tue, Sep 26, 2023 at 11:34:43AM +0200, Phil Sutter wrote:
> > > > On Mon, Sep 25, 2023 at 09:53:17PM +0200, Florian Westphal wrote:
> > > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > > On Sat, Sep 23, 2023 at 06:18:13PM +0200, Florian Westphal wrote:
> > > > > > > callback_that_might_reset()
> > > > > > > {
> > > > > > > 	try_module_get ...
> > > > > > > 	rcu_read_unlock()
> > > > > > > 	mutex_lock(net->commit_mutex)
> > > > > > > 	  dumper();
> > > > > > > 	mutex_unlock(net->commit_mutex)
> > > > > > > 	rcu_read_lock();
> > > > > > > 	module_put()
> > > > > > > }
> > > > > > >
> > > > > > > should do the trick.
> > > > > > 
> > > > > > Idiom above LGTM, *except for net->commit_mutex*. Please do not use
> > > > > > ->commit_mutex: This will stall ruleset updates for no reason, netlink
> > > > > > dump would grab and release such mutex for each netlink_recvmsg() call
> > > > > > and netlink dump side will always retry because of NLM_F_EINTR.
> > > > > 
> > > > > It will stall updates, but for good reason: we are making changes to the
> > > > > expressions state.
> > > > 
> > > > This also disqualifies the use of Pablo's suggested reset_lock, right?
> > > 
> > > Quick summary:
> > > 
> > > We are currently discussing if it makes sense to add a new lock or
> > > not. The commit_mutex stalls updates, but netlink dumps retrieves
> > > listings in chunks, that is, one recvmsg() call from userspace (to
> > > retrieve one list chunk) will grab the mutex then release it until the
> > > next recvmsg() call is done. Between these two calls an update is
> > > still possible. The question is if it is worth to stall an ongoing
> > > listing or updates.
> > 
> > Thanks for the summary. Assuming that a blocked commit will only be
> > postponed until after the current chunk was filled and is being
> > submitted to user space, I don't see how it would make a practical
> > difference for reset command if commit_mutex is used instead of
> > reset_lock (or a dedicated reset_mutex).
> 
> If the problem we are addressing is two processes listing the ruleset
> that concur to reset stateful expressions, then there is no difference.
> However, this is stalling writers and I don't think we need this
> according to the problem description.

ACK. Maybe Florian has a case in mind which requires to serialize reset
and commit?

> Another point to consider is how likely this list-and-reset happens.
> If it is unlikely, then commit_mutex should be fine. But if we expect
> a process polling to fetch counters very often, this will introduce an
> unnecessary interference with writers. In a very dynamic deployment,
> with frequent transaction updates, that might stall transactions for
> no reason.

I wonder if hardcore 'reset the rules fetching counters' users care
about performance of ruleset changes at the same time. Maybe we
shouldn't care until someone complains?

> Please, note that using commit_mutex will *not* fix either that
> userspace has to properly deal with NLM_F_EINTR, and I am 100% sure
> you told me last time when you submitted this that you would prefer to
> fix that once you get a ticket^H^H^H^H^H^H complain from someone else.
> Oh, and I accepted that deal.

Sorry, I don't recall. What did I promise to fix once someone complains?
NLM_F_EINTR handling in user space for reset commands? Is it broken??

> Honestly, we already have things to improve in other fronts, such
> speeding up set updates and reducing userspace memory consumption,
> much of this is userspace work.

I totally agree. And I didn't make the call for locking reset requests,
I'm just trying to answer it since it's my code that's broken in that
regard.

> > > There is the NLM_F_EINTR mechanism in place that tells that an
> > > interference has occured while keeping the listing lockless.
> > > 
> > > Unless I am missing anything, the goal is to fix two different
> > > processes that are listing at the same time, that is, two processes
> > > running a netlink dump at the same time that are resetting the
> > > stateful expressions in the ruleset.
> > 
> > Here's a simple repro I use to verify the locking approach (only rule
> > reset for now):
> > 
> > | set -e
> > | 
> > | RULESET='flush ruleset
> > | table t {
> > |       chain c {
> > |               counter packets 23 bytes 42
> > |       }
> > | }'
> > | 
> > | trap "$NFT list ruleset" EXIT
> > | for ((i = 0; i < 10000; i++)); do
> > |       echo "iter $i"
> > |       $NFT -f - <<< "$RULESET"
> > |       $NFT list ruleset | grep -q 'packets 23 bytes 42' >/dev/null
> > |       $NFT reset rules >/dev/null &
> > |       pid=$!
> > |       $NFT reset rules >/dev/null
> > |       wait $!
> > |       #$NFT list ruleset | grep 'packets'
> > |       $NFT list ruleset | grep -q 'packets 0 bytes 0' >/dev/null
> > | done
> > 
> > If the two calls clash, the rule will have huge counter values due to
> > underflow.
> 
> Can you give a try with the reset_lock spinlock approach with this
> script that exercises worst case?

It passes with this series applied. It just takes long to finish (due to
10k retries). If it triggers, it usually does within ~100 tries. But it
depends, and I don't know how to increase the chances. Otherwise I would
have put this in a kselftest.

Cheers, Phil
