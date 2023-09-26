Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA62E7D270
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Sep 2023 09:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbjIZJev (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Sep 2023 05:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234297AbjIZJev (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2023 05:34:51 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E76CEB
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 02:34:45 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ql4Sp-0000gU-43; Tue, 26 Sep 2023 11:34:43 +0200
Date:   Tue, 26 Sep 2023 11:34:43 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH 2/5] netfilter: nf_tables: Add locking for
 NFT_MSG_GETRULE_RESET requests
Message-ID: <ZRKlszo1ra1EakD+@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230923013807.11398-1-phil@nwl.cc>
 <20230923013807.11398-3-phil@nwl.cc>
 <20230923110437.GB22532@breakpoint.cc>
 <ZQ7+MF4aweUYmU7j@orbyte.nwl.cc>
 <20230923161813.GB19098@breakpoint.cc>
 <ZRFTx6pFYt2tZuSy@calendula>
 <20230925195317.GC22532@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230925195317.GC22532@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 25, 2023 at 09:53:17PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sat, Sep 23, 2023 at 06:18:13PM +0200, Florian Westphal wrote:
> > > callback_that_might_reset()
> > > {
> > > 	try_module_get ...
> > > 	rcu_read_unlock()
> > > 	mutex_lock(net->commit_mutex)
> > > 	  dumper();
> > > 	mutex_unlock(net->commit_mutex)
> > > 	rcu_read_lock();
> > > 	module_put()
> > > }
> > >
> > > should do the trick.
> > 
> > Idiom above LGTM, *except for net->commit_mutex*. Please do not use
> > ->commit_mutex: This will stall ruleset updates for no reason, netlink
> > dump would grab and release such mutex for each netlink_recvmsg() call
> > and netlink dump side will always retry because of NLM_F_EINTR.
> 
> It will stall updates, but for good reason: we are making changes to the
> expressions state.

This also disqualifies the use of Pablo's suggested reset_lock, right?

Cheers, Phil
