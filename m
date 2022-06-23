Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCD9C43334
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 16:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiFWQQj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 12:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiFWQQi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 12:16:38 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A732FE70
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 09:16:37 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1o4PVT-0008TB-GP; Thu, 23 Jun 2022 18:16:35 +0200
Date:   Thu, 23 Jun 2022 18:16:35 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: large set overlap and automerge
Message-ID: <YrSR40fBT93YMwsm@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220616093541.277164-1-pablo@netfilter.org>
 <YrSN+A2I2stpx2z/@orbyte.nwl.cc>
 <YrSRWQ8uz+sTPdXs@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrSRWQ8uz+sTPdXs@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 23, 2022 at 06:14:17PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 23, 2022 at 05:59:52PM +0200, Phil Sutter wrote:
> > On Thu, Jun 16, 2022 at 11:35:41AM +0200, Pablo Neira Ayuso wrote:
> > > Add a test to validate set overlap and automerge for large set. This
> > > test runs nft -f twice to cover for set reload without flush.
> > 
> > I had this in mind as well, but didn't like to hard-code any thresholds.
> > Your test is useful only for manual result review and will always pass,
> > therefore will only increase testsuite run time without any benefit.
> 
> Yes, I run them manually often and it won't work for a robot, unless
> time is printed somewhere and the robot identifies an anomaly there.
> 
> I can remove it if you like.

Just don't push it? :)
