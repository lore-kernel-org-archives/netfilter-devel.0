Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C09FA372A
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 10:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D093A2089C
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 10:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389582AbfJQKgv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 06:36:51 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:41368 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727268AbfJQKgv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 06:36:51 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iL39F-0003VB-9p; Thu, 17 Oct 2019 12:36:49 +0200
Date:   Thu, 17 Oct 2019 12:36:49 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 2/4] Revert "monitor: fix double cache update with
 --echo"
Message-ID: <20191017103649.GH12661@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191016230322.24432-1-phil@nwl.cc>
 <20191016230322.24432-3-phil@nwl.cc>
 <20191017085549.zm4jcz23q6vceful@salvia>
 <20191017090738.2wey6j4mfzelgse2@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017090738.2wey6j4mfzelgse2@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Thu, Oct 17, 2019 at 11:07:38AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 17, 2019 at 10:55:49AM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Oct 17, 2019 at 01:03:20AM +0200, Phil Sutter wrote:
> > > This reverts commit 9b032cd6477b847f48dc8454f0e73935e9f48754.
> > >
> > > While it is true that a cache exists, we still need to capture new sets
> > > and their elements if they are anonymous. This is because the name
> > > changes and rules will refer to them by name.
> 
> Please, tell me how I can reproduce this here with a simple snippet
> and I will have a look. Thanks!

Just run tests/monitor testsuite, echo testing simple.t will fail.
Alternatively, add a rule with anonymous set like so:
| # nft --echo add rule inet t c tcp dport '{ 22, 80 }'

> > > Given that there is no easy way to identify the anonymous set in cache
> > > (kernel doesn't (and shouldn't) dump SET_ID value) to update its name,
> > > just go with cache updates. Assuming that echo option is typically used
> > > for single commands, there is not much cache updating happening anyway.
> > 
> > This was fixing a real bug, if this is breaking anything, then I think
> > we are not getting to the root cause.
> > 
> > But reverting it does not make things any better.

With all respect, this wasn't obvious. There is no test case covering
it, commit message reads like it is an optimization (apart from the
subject containing 'fix').

Also, I tried to find a real solution (assuming that I'm merely supposed
to avoid pointless cache insertion) but ended up with code updating cache
for "no cache needed" case for anonymous sets and their elements. I
didn't revert out of laziness but because I deemed anything else not
feasible, after having tried two alternatives already.

Cheers, Phil
