Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01FCBC61D97
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 11:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343693AbjKVLbI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 06:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343646AbjKVLbH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 06:31:07 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF54D8
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 03:31:03 -0800 (PST)
Received: from [78.30.43.141] (port=35328 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r5lRa-00CR1Z-6x; Wed, 22 Nov 2023 12:31:00 +0100
Date:   Wed, 22 Nov 2023 12:30:57 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Thomas Haller <thaller@redhat.com>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Fix sets/reset_command_0 for current
 kernels
Message-ID: <ZV3mcc4otdRS0gL3@calendula>
References: <20231102150342.3543-1-phil@nwl.cc>
 <08a7ddd943c17548bbe4a72d6c0aae3110b0d39e.camel@redhat.com>
 <ZUPXGnrqVajvEryb@orbyte.nwl.cc>
 <ZUQHXkoa+Nr6byb/@calendula>
 <ZUoTmq8cwj+A9WO+@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZUoTmq8cwj+A9WO+@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

Picking up on this because I still see:

W: [FAILED]     331/389 testcases/sets/reset_command_0

here, maybe you can merge this change now? 6.5.x -stable will also
enter EoL in one more.

More comments below regarding your open questions.

On Tue, Nov 07, 2023 at 11:38:18AM +0100, Phil Sutter wrote:
> On Thu, Nov 02, 2023 at 09:32:30PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Nov 02, 2023 at 06:06:34PM +0100, Phil Sutter wrote:
> > > On Thu, Nov 02, 2023 at 04:29:34PM +0100, Thomas Haller wrote:
> > > > On Thu, 2023-11-02 at 16:03 +0100, Phil Sutter wrote:
> > > > >  
> > > > > +# Note: Element expiry is no longer reset since kernel commit
> > > > > 4c90bba60c26
> > > > > +# ("netfilter: nf_tables: do not refresh timeout when resetting
> > > > > element"),
> > > > > +# the respective parts of the test have therefore been commented
> > > > > out.
> > > > 
> > > > Hi Phil,
> > > > 
> > > > do you expect that the old behavior ever comes back?
> > > 
> > > A recent nfbz comment[1] from Pablo made me doubt the decision is final,
> > > though I may have misread it.
> > 
> > I hesitate on changing --stateless behaviour, but I don't find a
> > usecase for this option all alone unless it is combined with --terse,
> > to store an initial ruleset skeleton with no elements and no states.
> > Sets with timeout likely contain elements that get dynamically added
> > either via control plane or packet path based on some heuristics.
> 
> Unrelated to the expires vs. reset question, I wonder if one should
> treat set elements with timeout as state themselves. If one leaves the
> ruleset alone for long enough, they all will eventually vanish. So one
> may argue the ruleset in its stateless form does not have elements in a
> set with defined timeout.

The only usecase I can find for --stateless is diff'ing outputs
between two delta in time, to see what new elements are added and what
are gone. So I inclined to leave --stateless as is now.

> > > > Why keep the old checks (commented out)? Maybe drop them? We can get it
> > > > from git history.
> > > 
> > > Should the change be permanent, one should change the tests to assert
> > > the opposite, namely that expires values are unaffected by the reset.
> > 
> > I think it is fine as it is now in the kernel. I have posted patches
> > to allow to update element timeouts via transaction, which looks more
> > flexible and run through the transaction path. As for counter and
> > quota, users likely only want to either: 1) restore a previous state
> > (after reboot) or 2) dump-and-reset counters for stats collection
> > (e.g. fetch counters at the end of the day).
> 
> I still doubt there's a use-case to do (1) or (2) in sets with
> temporary elements.

For the reboot case, restoring temporary elements (which were added
via datapath) might make sense to me.

But there are limitations: connlimit is one of them because the
internal state of this datastructure gets losts between reboots.
