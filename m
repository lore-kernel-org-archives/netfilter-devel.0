Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 425EEE732D0
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 20:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbjI1UHz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 16:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjI1UHz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 16:07:55 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CF8180
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 13:07:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qlxId-0007Th-8z; Thu, 28 Sep 2023 22:07:51 +0200
Date:   Thu, 28 Sep 2023 22:07:51 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2 8/8] netfilter: nf_tables: Add locking for
 NFT_MSG_GETSETELEM_RESET requests
Message-ID: <20230928200751.GA28176@breakpoint.cc>
References: <20230928165244.7168-1-phil@nwl.cc>
 <20230928165244.7168-9-phil@nwl.cc>
 <20230928174630.GD19098@breakpoint.cc>
 <ZRXKWuGAE1snXkaK@calendula>
 <20230928185745.GE19098@breakpoint.cc>
 <ZRXOIrxtu5JPN4jA@calendula>
 <20230928192127.GH19098@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230928192127.GH19098@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > I'd say its semantically the same thing, we alter state.
> > > 
> > > We even emit audit records to tell userspace that there is state
> > > change.
> > 
> > This is a netlink event, how does the mutex help in that regard?
> 
> It will prevent two concurrent 'reset dumps' from messing
> up internal state of counters, quota, etc.
> > > Also, are you sure spinlock is appropriate here?
> > > 
> > > For full-ruleset resets we might be doing quite some
> > > traverals.
> > 
> > I said several times, we grab and release this for each
> > netlink_recvmsg(), commit_mutex helps us in no way to fix the "two
> > concurrent dump-and-reset problem".
> 
> It does, any lock prevents the 'concurrent reset problem'.

Reading Jozsefs email:

The locking prevents problems with concurrent resets,
but not concurrent modifcation with one (or more) resets.

Phil, what is the intention with the reset?
If the idea is to atomically reset AND list everything
(old values are shown) then yes, this approach doesn't work
either and something ipset-alike has to be done, i.e.
completely preventing any new transaction while a reset
"dump" is in progress.

Pablo, do you think we should combine this with the
ealier-discussed "perpetual dump restart" problem?

Userspace could request 'stable' dump that locks
out writers for the entire duration, and kernel could
force it automatically for resets.

I don't really like it though because misbehaving userspace
can lock out writers.
