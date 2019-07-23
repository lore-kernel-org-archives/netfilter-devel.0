Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44144C7618E
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 13:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18FF521734
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 13:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389860AbfGWNLq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 09:11:46 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48400 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728323AbfGWNLq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 09:11:46 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hpuZy-0007gJ-Mk; Tue, 23 Jul 2019 15:11:42 +0200
Date:   Tue, 23 Jul 2019 15:11:42 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 3/3] src: evaluate: return immediately if no op was
 requested
Message-ID: <20190723131142.GN22661@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20190721001406.23785-1-fw@strlen.de>
 <20190721001406.23785-4-fw@strlen.de>
 <20190721184901.n5ea7kpn246bddnb@salvia>
 <20190721185040.5ueush32pe7zta2k@breakpoint.cc>
 <20190722212556.gnxhgqlnrqt2epgg@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722212556.gnxhgqlnrqt2epgg@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 22, 2019 at 11:25:56PM +0200, Pablo Neira Ayuso wrote:
> On Sun, Jul 21, 2019 at 08:50:40PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Sun, Jul 21, 2019 at 02:14:07AM +0200, Florian Westphal wrote:
> > > > This makes nft behave like 0.9.0 -- the ruleset
> > > > 
> > > > flush ruleset
> > > > table inet filter {
> > > > }
> > > > table inet filter {
> > > >       chain test {
> > > >         counter
> > > >     }
> > > > }
> > > > 
> > > > loads again without generating an error message.
> > > > I've added a test case for this, without this it will create an error,
> > > > and with a checkout of the 'fixes' tag we get crash.
> > > > 
> > > > Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1351
> > > > Fixes: e5382c0d08e3c ("src: Support intra-transaction rule references")
> > > 
> > > This one is causing the cache corruption, right?
> > 
> > There is no cache corruption.  This patch makes us enter a code
> > path that we did not take before.
> 
> Sorry, I mean, this is a cache bug :-)
> 
> cache_flush() is cheating, it sets flags to CACHE_FULL, hence this
> enters this codepath we dit not take before. This propagates from the
> previous logic, as a workaround.
> 
> I made this patch, to skip the cache in case "flush ruleset" is
> requested.
> 
> This breaks testcases/transactions/0024rule_0, which is a recent test
> from Phil to check for intra-transaction references, I don't know yet
> what makes this code unhappy with my changes.
> 
> Phil, would you help me have a look at what assumption breaks? Thanks.

Sorry, I don't get it. What is happening in the first place? Florian
writes, a lookup happens in the wrong table and it seems
chain_evaluate() doesn't add the chain to cache. Yet I don't understand
why given patch fixes the problem.

Cheers, Phil
