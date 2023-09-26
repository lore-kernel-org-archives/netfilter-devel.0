Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D8B7E7D271
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Sep 2023 10:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbjIZKJr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Sep 2023 06:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234375AbjIZKJr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2023 06:09:47 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D4197
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 03:09:40 -0700 (PDT)
Received: from [78.30.34.192] (port=44234 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1ql50a-004l8T-HZ; Tue, 26 Sep 2023 12:09:38 +0200
Date:   Tue, 26 Sep 2023 12:09:35 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH 2/5] netfilter: nf_tables: Add locking for
 NFT_MSG_GETRULE_RESET requests
Message-ID: <ZRKt31Vs382Z31IO@calendula>
References: <20230923013807.11398-1-phil@nwl.cc>
 <20230923013807.11398-3-phil@nwl.cc>
 <20230923110437.GB22532@breakpoint.cc>
 <ZQ7+MF4aweUYmU7j@orbyte.nwl.cc>
 <20230923161813.GB19098@breakpoint.cc>
 <ZRFTx6pFYt2tZuSy@calendula>
 <20230925195317.GC22532@breakpoint.cc>
 <ZRKlszo1ra1EakD+@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZRKlszo1ra1EakD+@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Tue, Sep 26, 2023 at 11:34:43AM +0200, Phil Sutter wrote:
> On Mon, Sep 25, 2023 at 09:53:17PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Sat, Sep 23, 2023 at 06:18:13PM +0200, Florian Westphal wrote:
> > > > callback_that_might_reset()
> > > > {
> > > > 	try_module_get ...
> > > > 	rcu_read_unlock()
> > > > 	mutex_lock(net->commit_mutex)
> > > > 	  dumper();
> > > > 	mutex_unlock(net->commit_mutex)
> > > > 	rcu_read_lock();
> > > > 	module_put()
> > > > }
> > > >
> > > > should do the trick.
> > > 
> > > Idiom above LGTM, *except for net->commit_mutex*. Please do not use
> > > ->commit_mutex: This will stall ruleset updates for no reason, netlink
> > > dump would grab and release such mutex for each netlink_recvmsg() call
> > > and netlink dump side will always retry because of NLM_F_EINTR.
> > 
> > It will stall updates, but for good reason: we are making changes to the
> > expressions state.
> 
> This also disqualifies the use of Pablo's suggested reset_lock, right?

Quick summary:

We are currently discussing if it makes sense to add a new lock or
not. The commit_mutex stalls updates, but netlink dumps retrieves
listings in chunks, that is, one recvmsg() call from userspace (to
retrieve one list chunk) will grab the mutex then release it until the
next recvmsg() call is done. Between these two calls an update is
still possible. The question is if it is worth to stall an ongoing
listing or updates.

There is the NLM_F_EINTR mechanism in place that tells that an
interference has occured while keeping the listing lockless.

Unless I am missing anything, the goal is to fix two different
processes that are listing at the same time, that is, two processes
running a netlink dump at the same time that are resetting the
stateful expressions in the ruleset.
