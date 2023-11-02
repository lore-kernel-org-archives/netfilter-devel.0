Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26E5C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 20:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344899AbjKBUck (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 16:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345854AbjKBUcj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 16:32:39 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101C6193
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 13:32:35 -0700 (PDT)
Received: from [78.30.35.151] (port=50386 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qyeMh-00AuWt-Bf; Thu, 02 Nov 2023 21:32:33 +0100
Date:   Thu, 2 Nov 2023 21:32:30 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Thomas Haller <thaller@redhat.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Fix sets/reset_command_0 for current
 kernels
Message-ID: <ZUQHXkoa+Nr6byb/@calendula>
References: <20231102150342.3543-1-phil@nwl.cc>
 <08a7ddd943c17548bbe4a72d6c0aae3110b0d39e.camel@redhat.com>
 <ZUPXGnrqVajvEryb@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZUPXGnrqVajvEryb@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 02, 2023 at 06:06:34PM +0100, Phil Sutter wrote:
> On Thu, Nov 02, 2023 at 04:29:34PM +0100, Thomas Haller wrote:
> > On Thu, 2023-11-02 at 16:03 +0100, Phil Sutter wrote:
> > >  
> > > +# Note: Element expiry is no longer reset since kernel commit
> > > 4c90bba60c26
> > > +# ("netfilter: nf_tables: do not refresh timeout when resetting
> > > element"),
> > > +# the respective parts of the test have therefore been commented
> > > out.
> > 
> > Hi Phil,
> > 
> > do you expect that the old behavior ever comes back?
> 
> A recent nfbz comment[1] from Pablo made me doubt the decision is final,
> though I may have misread it.

I hesitate on changing --stateless behaviour, but I don't find a
usecase for this option all alone unless it is combined with --terse,
to store an initial ruleset skeleton with no elements and no states.
Sets with timeout likely contain elements that get dynamically added
either via control plane or packet path based on some heuristics.

> > Why keep the old checks (commented out)? Maybe drop them? We can get it
> > from git history.
> 
> Should the change be permanent, one should change the tests to assert
> the opposite, namely that expires values are unaffected by the reset.

I think it is fine as it is now in the kernel. I have posted patches
to allow to update element timeouts via transaction, which looks more
flexible and run through the transaction path. As for counter and
quota, users likely only want to either: 1) restore a previous state
(after reboot) or 2) dump-and-reset counters for stats collection
(e.g. fetch counters at the end of the day).
