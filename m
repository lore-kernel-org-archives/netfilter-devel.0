Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DB2CE7A88
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Sep 2023 16:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjIWQSW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Sep 2023 12:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjIWQSW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Sep 2023 12:18:22 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86AF92
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Sep 2023 09:18:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qk5Kf-0004Gn-5l; Sat, 23 Sep 2023 18:18:13 +0200
Date:   Sat, 23 Sep 2023 18:18:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH 2/5] netfilter: nf_tables: Add locking for
 NFT_MSG_GETRULE_RESET requests
Message-ID: <20230923161813.GB19098@breakpoint.cc>
References: <20230923013807.11398-1-phil@nwl.cc>
 <20230923013807.11398-3-phil@nwl.cc>
 <20230923110437.GB22532@breakpoint.cc>
 <ZQ7+MF4aweUYmU7j@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQ7+MF4aweUYmU7j@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> > Can you split that into another patch?
> 
> You mean the whole creation of nf_tables_getrule_single()? Because the
> above change is only required due to the changed return type.

Yes, I was wondering if there is a way to convert the return type
in a different patch.

If its too costly, don't bother.

> > Hmm. Stupid question.  Why do we need a spinlock to serialize?
> > This is now a distinct function, so:
> 
> On Tue, Sep 05, 2023 at 11:11:07PM +0200, Phil Sutter wrote:
> [...]
> > I guess NFNL_CB_MUTEX is a no go because it locks down the whole
> > subsystem, right?
> But he didn't get a reply. :(

Sorry, missed that :-(

If thats really a concern. alernative would be to do same thing as
nft_netlink_dump_start_rcu(), i.e. use _RCU as-is and then switch
from rcu to module reference held, plus, in your case, the transaction
mutex.

Actually I like that better because we already use this pattern and
afaics all dumpers call rcu_read_lock for us; i.e.:

callback_that_might_reset()
{
	try_module_get ...
	rcu_read_unlock()
	mutex_lock(net->commit_mutex)
	  dumper();
	mutex_unlock(net->commit_mutex)
	rcu_read_lock();
	module_put()
}

should do the trick.

> What is the relation to this being a distinct function? Can't one have
> the same callback function once with type CB_RCU and once as CB_MUTEX?
> nfnetlink doesn't seem to care.

You can but you need conditional locking in that case.
