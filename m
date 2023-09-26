Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8115E7E62E
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Sep 2023 12:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbjIZMOQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Sep 2023 08:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjIZMOP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2023 08:14:15 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235C5EB
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 05:14:08 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ql6x3-0002Yh-Lr; Tue, 26 Sep 2023 14:14:05 +0200
Date:   Tue, 26 Sep 2023 14:14:05 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH 2/5] netfilter: nf_tables: Add locking for
 NFT_MSG_GETRULE_RESET requests
Message-ID: <ZRLLDbVlYK5c9HX+@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20230923013807.11398-1-phil@nwl.cc>
 <20230923013807.11398-3-phil@nwl.cc>
 <20230923110437.GB22532@breakpoint.cc>
 <ZQ7+MF4aweUYmU7j@orbyte.nwl.cc>
 <20230923161813.GB19098@breakpoint.cc>
 <ZRFTx6pFYt2tZuSy@calendula>
 <20230925195317.GC22532@breakpoint.cc>
 <ZRKlszo1ra1EakD+@orbyte.nwl.cc>
 <ZRKt31Vs382Z31IO@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRKt31Vs382Z31IO@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 26, 2023 at 12:09:35PM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Tue, Sep 26, 2023 at 11:34:43AM +0200, Phil Sutter wrote:
> > On Mon, Sep 25, 2023 at 09:53:17PM +0200, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > On Sat, Sep 23, 2023 at 06:18:13PM +0200, Florian Westphal wrote:
> > > > > callback_that_might_reset()
> > > > > {
> > > > > 	try_module_get ...
> > > > > 	rcu_read_unlock()
> > > > > 	mutex_lock(net->commit_mutex)
> > > > > 	  dumper();
> > > > > 	mutex_unlock(net->commit_mutex)
> > > > > 	rcu_read_lock();
> > > > > 	module_put()
> > > > > }
> > > > >
> > > > > should do the trick.
> > > > 
> > > > Idiom above LGTM, *except for net->commit_mutex*. Please do not use
> > > > ->commit_mutex: This will stall ruleset updates for no reason, netlink
> > > > dump would grab and release such mutex for each netlink_recvmsg() call
> > > > and netlink dump side will always retry because of NLM_F_EINTR.
> > > 
> > > It will stall updates, but for good reason: we are making changes to the
> > > expressions state.
> > 
> > This also disqualifies the use of Pablo's suggested reset_lock, right?
> 
> Quick summary:
> 
> We are currently discussing if it makes sense to add a new lock or
> not. The commit_mutex stalls updates, but netlink dumps retrieves
> listings in chunks, that is, one recvmsg() call from userspace (to
> retrieve one list chunk) will grab the mutex then release it until the
> next recvmsg() call is done. Between these two calls an update is
> still possible. The question is if it is worth to stall an ongoing
> listing or updates.

Thanks for the summary. Assuming that a blocked commit will only be
postponed until after the current chunk was filled and is being
submitted to user space, I don't see how it would make a practical
difference for reset command if commit_mutex is used instead of
reset_lock (or a dedicated reset_mutex).

> There is the NLM_F_EINTR mechanism in place that tells that an
> interference has occured while keeping the listing lockless.
> 
> Unless I am missing anything, the goal is to fix two different
> processes that are listing at the same time, that is, two processes
> running a netlink dump at the same time that are resetting the
> stateful expressions in the ruleset.

Here's a simple repro I use to verify the locking approach (only rule
reset for now):

| set -e
| 
| RULESET='flush ruleset
| table t {
|       chain c {
|               counter packets 23 bytes 42
|       }
| }'
| 
| trap "$NFT list ruleset" EXIT
| for ((i = 0; i < 10000; i++)); do
|       echo "iter $i"
|       $NFT -f - <<< "$RULESET"
|       $NFT list ruleset | grep -q 'packets 23 bytes 42' >/dev/null
|       $NFT reset rules >/dev/null &
|       pid=$!
|       $NFT reset rules >/dev/null
|       wait $!
|       #$NFT list ruleset | grep 'packets'
|       $NFT list ruleset | grep -q 'packets 0 bytes 0' >/dev/null
| done

If the two calls clash, the rule will have huge counter values due to
underflow.
