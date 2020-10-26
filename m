Return-Path: <SRS0=LVSz=EB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14073C4363A
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Oct 2020 16:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0D2B2224A
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Oct 2020 16:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1785997AbgJZQbE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Oct 2020 12:31:04 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:57856 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1738342AbgJZQbE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Oct 2020 12:31:04 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kX5Og-00070Z-Ij; Mon, 26 Oct 2020 17:31:02 +0100
Date:   Mon, 26 Oct 2020 17:31:02 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 3/3] nft: Fix for concurrent noflush restore
 calls
Message-ID: <20201026163102.GB5098@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20201005144858.11578-1-phil@nwl.cc>
 <20201005144858.11578-4-phil@nwl.cc>
 <20201012125450.GA26934@salvia>
 <20201013100803.GW13016@orbyte.nwl.cc>
 <20201013101502.GA29142@salvia>
 <20201014094640.GA13016@orbyte.nwl.cc>
 <20201016152850.GA1416@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016152850.GA1416@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 16, 2020 at 05:28:50PM +0200, Pablo Neira Ayuso wrote:
[...]
> Makes sense. Thanks a lot for explaining. Probably you can include
> this in the commit description for the record.
> 
> > I realize the test case is not quite effective, ruleset should be
> > emptied upon each iteration of concurrent restore job startup.
> 
> Please, update the test and revamp.

I pushed the commit already when you wrote "LGTM" in your first reply,
sorry. Yet to cover for the above, I just submitted a patch which adds a
bit of documentation to the test case (apart from improving its
effectiveness).

Cheers, Phil
