Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA628ECE58E
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 17:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BCCD2089C
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 17:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440557AbfJQRG3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 13:06:29 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:42024 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436550AbfJQRG3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 13:06:29 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iL9EK-00085Z-2w; Thu, 17 Oct 2019 19:06:28 +0200
Date:   Thu, 17 Oct 2019 19:06:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v4 0/8] Improve iptables-nft performance with
 large rulesets
Message-ID: <20191017170628.GN12661@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191015114152.25254-1-phil@nwl.cc>
 <20191017090332.erwubv7pzxbbowjg@salvia>
 <20191017100816.plzn3tugcu2j2rpl@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017100816.plzn3tugcu2j2rpl@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 17, 2019 at 12:08:16PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 17, 2019 at 11:03:32AM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Oct 15, 2019 at 01:41:44PM +0200, Phil Sutter wrote:
> > > Fourth try at caching optimizations implementation.
> > > 
> > > Changes since v3:
> > > 
> > > * Rebase onto current master after pushing the accepted initial three
> > >   patches.
> > > * Avoid cache inconsistency in __nft_build_cache() if kernel ruleset
> > >   changed since last call.
> > 
> > I still hesitate with this cache approach.
> > 
> > Can this deal with this scenario? Say you have a ruleset composed on N
> > rules.
> > 
> > * Rule 1..M starts using generation X for the evaluation, they pass
> >   OK.
> > 
> > * Generation is bumped.
> > 
> > * Rule M..N is evaluated with a diferent cache.
> > 
> > So the ruleset evaluation is inconsistent itself since it is based on
> > different caches for each rule in the batch.
> 
> It might be that rule M fails because a user-defined chain is not
> found anymore, error reporting will not be consistent on races, and
> who knows what else.
> 
> Anyway, if you want to go for this approach, merge it upstream and
> let's test how it goes... this batch looks much better indeed than v1,
> so push it out.

Yes, let's please give it a try. Fingers crossed, but if it blows up
I'll either fix it or revert it myself. :)

Pushed the whole series with your ACKs added.

Thanks, Phil
