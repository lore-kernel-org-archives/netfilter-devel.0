Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F296CE7A89
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Sep 2023 09:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjIYJdZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Sep 2023 05:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233236AbjIYJdH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Sep 2023 05:33:07 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C6BFE
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Sep 2023 02:33:00 -0700 (PDT)
Received: from [78.30.34.192] (port=41490 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qkhxY-00FcHO-Lj; Mon, 25 Sep 2023 11:32:58 +0200
Date:   Mon, 25 Sep 2023 11:32:55 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH 2/5] netfilter: nf_tables: Add locking for
 NFT_MSG_GETRULE_RESET requests
Message-ID: <ZRFTx6pFYt2tZuSy@calendula>
References: <20230923013807.11398-1-phil@nwl.cc>
 <20230923013807.11398-3-phil@nwl.cc>
 <20230923110437.GB22532@breakpoint.cc>
 <ZQ7+MF4aweUYmU7j@orbyte.nwl.cc>
 <20230923161813.GB19098@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230923161813.GB19098@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Sep 23, 2023 at 06:18:13PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > Can you split that into another patch?
> > 
> > You mean the whole creation of nf_tables_getrule_single()? Because the
> > above change is only required due to the changed return type.
> 
> Yes, I was wondering if there is a way to convert the return type
> in a different patch.
> 
> If its too costly, don't bother.
> 
> > > Hmm. Stupid question.  Why do we need a spinlock to serialize?
> > > This is now a distinct function, so:
> > 
> > On Tue, Sep 05, 2023 at 11:11:07PM +0200, Phil Sutter wrote:
> > [...]
> > > I guess NFNL_CB_MUTEX is a no go because it locks down the whole
> > > subsystem, right?

NFNL_CB_MUTEX takes the global subsystem mutex, see
net/netfilter/nfnetlink.c

                case NFNL_CB_MUTEX:
                        rcu_read_unlock();
                        nfnl_lock(subsys_id);
                        ...

This does not help either for netlink dumps, because NFNL_CB_MUTEX
only guarantees that the first netlink dump chunk holds the mutex
while follow up calls to netlink_recvmsg() would be lockless.

Note, Florian updated nf_tables to use a per-netns mutex only.

> If thats really a concern. alernative would be to do same thing as
> nft_netlink_dump_start_rcu(), i.e. use _RCU as-is and then switch
> from rcu to module reference held, plus, in your case, the transaction
> mutex.
> 
> Actually I like that better because we already use this pattern and
> afaics all dumpers call rcu_read_lock for us; i.e.:
> 
> callback_that_might_reset()
> {
> 	try_module_get ...
> 	rcu_read_unlock()
> 	mutex_lock(net->commit_mutex)
> 	  dumper();
> 	mutex_unlock(net->commit_mutex)
> 	rcu_read_lock();
> 	module_put()
> }
>
> should do the trick.

Idiom above LGTM, *except for net->commit_mutex*. Please do not use
->commit_mutex: This will stall ruleset updates for no reason, netlink
dump would grab and release such mutex for each netlink_recvmsg() call
and netlink dump side will always retry because of NLM_F_EINTR.
