Return-Path: <SRS0=zc7w=DV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1766C43457
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 09:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E20C20757
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 09:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgJNJqn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Oct 2020 05:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728087AbgJNJqn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Oct 2020 05:46:43 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220CFC0613D2
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2020 02:46:43 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kSdMm-0006r9-Am; Wed, 14 Oct 2020 11:46:40 +0200
Date:   Wed, 14 Oct 2020 11:46:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 3/3] nft: Fix for concurrent noflush restore
 calls
Message-ID: <20201014094640.GA13016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20201005144858.11578-1-phil@nwl.cc>
 <20201005144858.11578-4-phil@nwl.cc>
 <20201012125450.GA26934@salvia>
 <20201013100803.GW13016@orbyte.nwl.cc>
 <20201013101502.GA29142@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013101502.GA29142@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 13, 2020 at 12:15:02PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 13, 2020 at 12:08:03PM +0200, Phil Sutter wrote:
> [...]
> > On Mon, Oct 12, 2020 at 02:54:50PM +0200, Pablo Neira Ayuso wrote:
> > [...]
> > > Patch LGTM, thanks Phil.
> > > 
> > > What I don't clearly see yet is what scenario is triggering the bug in
> > > the existing code, if you don't mind to explain.
> > 
> > See the test case attached to the patch: An other iptables-restore
> > process may add references (i.e., jumps) to a chain the own
> > iptables-restore process wants to delete. This should not be a problem
> > because these references are added to a chain that is being flushed by
> > the own process as well. But if that chain doesn't exist while the own
> > process fetches kernel's ruleset, this flush job is not created.
> 
> Let me rephrase this:
> 
> 1) process A fetches the ruleset, finds no chain C (no flush job then)
> 2) process B adds new chain C, flush job is present
> 3) process B adds the ruleset
> 4) process A appends rules to the existing chain C (because there is
>    no flush job)
> 
> Is this the scenario? If so, I wonder why the generation ID is not
> helping to refresh and retry.

Not quite, let me try to put this more clearly:

* Dump A:
  | *filter
  | :FOO - [0:0] # flush chain FOO
  | -X BAR       # remove chain BAR
  | COMMIT

* Dump B:
  | *filter
  | -A FOO -j BAR # reference BAR from a rule in FOO
  | COMMIT

* Kernel ruleset:
  | *filter
  | :BAR - [0:0]
  | COMMIT

* Process A:
  * read dump A
  * fetch cache

* Process B:
  * read dump B
  * fetch ruleset
  * commit to kernel

* Process A:
  * skip flush chain FOO job: not present
  * add delete chain BAR job: chain exists
  * commit fails (genid outdated)
  * refresh transaction:
    * delete chain BAR job remains active
    * genid updated
  * commit fails: can't remove chain BAR: EBUSY

I realize the test case is not quite effective, ruleset should be
emptied upon each iteration of concurrent restore job startup.

Cheers, Phil
