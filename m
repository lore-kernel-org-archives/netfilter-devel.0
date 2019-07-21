Return-Path: <SRS0=p03Y=VS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D277AC76191
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 18:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8E952084C
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 18:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfGUSum (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Jul 2019 14:50:42 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:50150 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbfGUSum (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Jul 2019 14:50:42 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hpGuu-0006IZ-Tg; Sun, 21 Jul 2019 20:50:40 +0200
Date:   Sun, 21 Jul 2019 20:50:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 3/3] src: evaluate: return immediately if no op was
 requested
Message-ID: <20190721185040.5ueush32pe7zta2k@breakpoint.cc>
References: <20190721001406.23785-1-fw@strlen.de>
 <20190721001406.23785-4-fw@strlen.de>
 <20190721184901.n5ea7kpn246bddnb@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190721184901.n5ea7kpn246bddnb@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Jul 21, 2019 at 02:14:07AM +0200, Florian Westphal wrote:
> > This makes nft behave like 0.9.0 -- the ruleset
> > 
> > flush ruleset
> > table inet filter {
> > }
> > table inet filter {
> >       chain test {
> >         counter
> >     }
> > }
> > 
> > loads again without generating an error message.
> > I've added a test case for this, without this it will create an error,
> > and with a checkout of the 'fixes' tag we get crash.
> > 
> > Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1351
> > Fixes: e5382c0d08e3c ("src: Support intra-transaction rule references")
> 
> This one is causing the cache corruption, right?

There is no cache corruption.  This patch makes us enter a code
path that we did not take before.

