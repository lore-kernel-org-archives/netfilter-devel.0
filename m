Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85546E7F156
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 11:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjI2LZI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 07:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjI2LZH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 07:25:07 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2291B7
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 04:25:04 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qmBcE-00088R-Qk; Fri, 29 Sep 2023 13:25:02 +0200
Date:   Fri, 29 Sep 2023 13:25:02 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2 8/8] netfilter: nf_tables: Add locking for
 NFT_MSG_GETSETELEM_RESET requests
Message-ID: <ZRa0Dmyyk2HpABoP@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230928165244.7168-1-phil@nwl.cc>
 <20230928165244.7168-9-phil@nwl.cc>
 <20230928174630.GD19098@breakpoint.cc>
 <ZRXKWuGAE1snXkaK@calendula>
 <20230928185745.GE19098@breakpoint.cc>
 <ZRXOIrxtu5JPN4jA@calendula>
 <20230928192127.GH19098@breakpoint.cc>
 <20230928200751.GA28176@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230928200751.GA28176@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 28, 2023 at 10:07:51PM +0200, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > I'd say its semantically the same thing, we alter state.
> > > > 
> > > > We even emit audit records to tell userspace that there is state
> > > > change.
> > > 
> > > This is a netlink event, how does the mutex help in that regard?
> > 
> > It will prevent two concurrent 'reset dumps' from messing
> > up internal state of counters, quota, etc.
> > > > Also, are you sure spinlock is appropriate here?
> > > > 
> > > > For full-ruleset resets we might be doing quite some
> > > > traverals.
> > > 
> > > I said several times, we grab and release this for each
> > > netlink_recvmsg(), commit_mutex helps us in no way to fix the "two
> > > concurrent dump-and-reset problem".
> > 
> > It does, any lock prevents the 'concurrent reset problem'.
> 
> Reading Jozsefs email:
> 
> The locking prevents problems with concurrent resets,
> but not concurrent modifcation with one (or more) resets.
> 
> Phil, what is the intention with the reset?
> If the idea is to atomically reset AND list everything
> (old values are shown) then yes, this approach doesn't work
> either and something ipset-alike has to be done, i.e.
> completely preventing any new transaction while a reset
> "dump" is in progress.

Sure, the functionality is to fetch old values while resetting so they
are not lost (and may be used for accounting, etc.). The question is
what we want to guarantee. There's still the non-dump path, so if
someone wants transactional safety they could still reset rules
individually.

The whole "what if my other hand pulls the trigger while I'm still
drawing the gun" scenario is a bit too academic for my taste. ;)

> Pablo, do you think we should combine this with the
> ealier-discussed "perpetual dump restart" problem?
> 
> Userspace could request 'stable' dump that locks
> out writers for the entire duration, and kernel could
> force it automatically for resets.
> 
> I don't really like it though because misbehaving userspace
> can lock out writers.

Make them inactive and free only after the dump is done? IIUC,
nft_active_genmask() will return true again though after the second
update, right?

Cheers, Phil
