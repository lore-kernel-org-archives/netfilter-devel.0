Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 560C5C61D97
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 13:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344032AbjKVNf3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 08:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343881AbjKVNf2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 08:35:28 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC458D40
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 05:35:24 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1r5nNy-0005z7-98; Wed, 22 Nov 2023 14:35:22 +0100
Date:   Wed, 22 Nov 2023 14:35:22 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Thomas Haller <thaller@redhat.com>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Fix sets/reset_command_0 for current
 kernels
Message-ID: <ZV4DmmW7+oceP4jo@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Thomas Haller <thaller@redhat.com>, netfilter-devel@vger.kernel.org
References: <20231102150342.3543-1-phil@nwl.cc>
 <08a7ddd943c17548bbe4a72d6c0aae3110b0d39e.camel@redhat.com>
 <ZUPXGnrqVajvEryb@orbyte.nwl.cc>
 <ZUQHXkoa+Nr6byb/@calendula>
 <ZUoTmq8cwj+A9WO+@orbyte.nwl.cc>
 <ZV3mcc4otdRS0gL3@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZV3mcc4otdRS0gL3@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Nov 22, 2023 at 12:30:57PM +0100, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> Picking up on this because I still see:
> 
> W: [FAILED]     331/389 testcases/sets/reset_command_0
> 
> here, maybe you can merge this change now? 6.5.x -stable will also
> enter EoL in one more.

There is a v2 of this patch adding an explicit check for expiry to not
change upon element reset. Are you fine with that? For reference, its
message ID is 20231102175754.15020-1-phil@nwl.cc.

> More comments below regarding your open questions.
> 
> On Tue, Nov 07, 2023 at 11:38:18AM +0100, Phil Sutter wrote:
> > On Thu, Nov 02, 2023 at 09:32:30PM +0100, Pablo Neira Ayuso wrote:
> > > On Thu, Nov 02, 2023 at 06:06:34PM +0100, Phil Sutter wrote:
> > > > On Thu, Nov 02, 2023 at 04:29:34PM +0100, Thomas Haller wrote:
> > > > > On Thu, 2023-11-02 at 16:03 +0100, Phil Sutter wrote:
> > > > > >  
> > > > > > +# Note: Element expiry is no longer reset since kernel commit
> > > > > > 4c90bba60c26
> > > > > > +# ("netfilter: nf_tables: do not refresh timeout when resetting
> > > > > > element"),
> > > > > > +# the respective parts of the test have therefore been commented
> > > > > > out.
> > > > > 
> > > > > Hi Phil,
> > > > > 
> > > > > do you expect that the old behavior ever comes back?
> > > > 
> > > > A recent nfbz comment[1] from Pablo made me doubt the decision is final,
> > > > though I may have misread it.
> > > 
> > > I hesitate on changing --stateless behaviour, but I don't find a
> > > usecase for this option all alone unless it is combined with --terse,
> > > to store an initial ruleset skeleton with no elements and no states.
> > > Sets with timeout likely contain elements that get dynamically added
> > > either via control plane or packet path based on some heuristics.
> > 
> > Unrelated to the expires vs. reset question, I wonder if one should
> > treat set elements with timeout as state themselves. If one leaves the
> > ruleset alone for long enough, they all will eventually vanish. So one
> > may argue the ruleset in its stateless form does not have elements in a
> > set with defined timeout.
> 
> The only usecase I can find for --stateless is diff'ing outputs
> between two delta in time, to see what new elements are added and what
> are gone. So I inclined to leave --stateless as is now.

I see --stateless as a way to dump the ruleset in its basic form for a
fresh start with zeroed counters, etc. Hence why I wondered if it should
omit expiring elements as those are usually added by packet path or at
least explicitly after loading the ruleset itself.

> > > > > Why keep the old checks (commented out)? Maybe drop them? We can get it
> > > > > from git history.
> > > > 
> > > > Should the change be permanent, one should change the tests to assert
> > > > the opposite, namely that expires values are unaffected by the reset.
> > > 
> > > I think it is fine as it is now in the kernel. I have posted patches
> > > to allow to update element timeouts via transaction, which looks more
> > > flexible and run through the transaction path. As for counter and
> > > quota, users likely only want to either: 1) restore a previous state
> > > (after reboot) or 2) dump-and-reset counters for stats collection
> > > (e.g. fetch counters at the end of the day).
> > 
> > I still doubt there's a use-case to do (1) or (2) in sets with
> > temporary elements.
> 
> For the reboot case, restoring temporary elements (which were added
> via datapath) might make sense to me.
> 
> But there are limitations: connlimit is one of them because the
> internal state of this datastructure gets losts between reboots.

Cheers, Phil
