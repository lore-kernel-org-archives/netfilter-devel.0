Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE739C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 15:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7AEA239EB
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 15:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732610AbhAUPML (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 10:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732578AbhAUPLk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 10:11:40 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A82C061756
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Jan 2021 07:10:45 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1l2bbe-0003r7-R4; Thu, 21 Jan 2021 16:10:42 +0100
Date:   Thu, 21 Jan 2021 16:10:42 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 2/4] json: limit: set default burst to 5
Message-ID: <20210121151042.GS3158@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20210121135510.14941-1-fw@strlen.de>
 <20210121135510.14941-3-fw@strlen.de>
 <20210121144414.GQ3158@orbyte.nwl.cc>
 <20210121145759.GA4087@salvia>
 <20210121145934.GA4142@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121145934.GA4142@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Thu, Jan 21, 2021 at 03:59:34PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Jan 21, 2021 at 03:57:59PM +0100, Pablo Neira Ayuso wrote:
> > Hi Phil,
> > 
> > On Thu, Jan 21, 2021 at 03:44:14PM +0100, Phil Sutter wrote:
> > > Hi!
> > > 
> > > On Thu, Jan 21, 2021 at 02:55:08PM +0100, Florian Westphal wrote:
> > > > The tests fail because json printing omits a burst of 5 and
> > > > the parser treats that as 'burst 0'.
> > > 
> > > While this patch is correct in that it aligns json and bison parser
> > > behaviours, I think omitting burst value in JSON output is a bug by
> > > itself: We don't care about output length and users are supposed to
> > > parse (and thus filter) the information anyway, so there's no gain from
> > > omitting such info. I'll address this in a separate patch, though.
> > 
> > The listing of:
> > 
> > nft list ruleset
> > 
> > is already omitting this. Would you prefer this is also exposed there?
> 
> I mean, IIRC for json it makes sense to display every field (not omit
> anything), so my question is whether you think the native syntax
> should omit this or it's fine as it is.

You hit the bull's eye: I have a ticket about this behaviour already,
claiming that having a non-trivial default value and omitting it from
output is not a good idea. In practice, reporter created a limit
statement which doesn't work with default burst value (limit rate 1).

I'm not against omitting the burst, but it must not become a problem
then. So my idea to keep the benefits of both was to implement an "auto
burst value" which adjusts to the rate value. Do you think that's
feasible? Maybe something simple like 'burst = max(1, rate / 10)' (for
packets).

Cheers, Phil
