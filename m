Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE62C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Nov 2022 11:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235322AbiKRLqs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Nov 2022 06:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiKRLqr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Nov 2022 06:46:47 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478F512AF1
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Nov 2022 03:46:46 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ovzpT-00027X-Cy; Fri, 18 Nov 2022 12:46:43 +0100
Date:   Fri, 18 Nov 2022 12:46:43 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 0/4] xt: Implement dump and restore support
Message-ID: <20221118114643.GD15714@breakpoint.cc>
References: <20221117174546.21715-1-phil@nwl.cc>
 <20221117211347.GB15714@breakpoint.cc>
 <Y3dUxJZ6J4mg/KNh@orbyte.nwl.cc>
 <Y3daXmuU0Nsyeij6@salvia>
 <Y3dhhVpfoA73W3kA@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3dhhVpfoA73W3kA@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> On Fri, Nov 18, 2022 at 11:11:42AM +0100, Pablo Neira Ayuso wrote:
> > Merging threads.
> > 
> > On Fri, Nov 18, 2022 at 10:55:04AM +0100, Phil Sutter wrote:
> > [...]
> > > > I think this more or less a summary of what we discussed in the NFWS.
> > >
> > > Pablo, I think you're mixing up two things here:
> > >
> > > This "support dump and load of compat expression" feature is to sanitize
> > > the current situation with up to date iptables and nftables.
> > 
> > OK, then the problem we discuss is mixing iptables-nft and nftables.
> > 
> > On Fri, Nov 18, 2022 at 10:47:48AM +0100, Phil Sutter wrote:
> > [...]
> > > > At this time I'd rather like a time machine to prevent nft_compat.c from
> > > > getting merged :-(
> > >
> > > If you do, please convince Pablo to not push iptables commit 384958620a.
> > > I think it opened the can of worms we're trying to confine here.
> > 
> > It could be worst, if iptables-nft would not be in place, then old
> > iptables-legacy and new nftables rules would have no visibility each
> > other.
> > 
> > With iptables-nft we have a way to move forward:
> > 
> > - Replace nft_compat by native expressions from iptables-nft.
> > - Extend iptables-nft to understand more complex expressions, worst
> >   case dump a native representation.
> > 
> > Why don't we just move ahead this path instead of spinning around the
> > compat layer? This only requires userspace updates on iptables-nft.
> 
> Sure! I'm just picking low hanging fruits first. With even translation
> support being still incomplete, I fear it will take a while until the
> tools are fluent enough for this to not matter anymore. And then there's
> still nftables without libxtables support.

Then perhaps its better to do following path:
1. Try ->xlate(), if that fails, then print a 'breaking' format?

As far as I understand the problem is the "# comment" - type syntax that
makes nft just skip the incomplete rule, so perhaps just use invalid
format?

Example:

counter packets 0 bytes 0 # name foo interval 250.0ms ewmalog 500.0ms
Instead make this something like
counter packets 0 bytes 0 nft_compat [ RATEEST name foo interval 250.0ms ewmalog 500.0ms ] # unsupported iptables-nft rule

?

I'd like to avoid exposure in the frontend with compatible-restore-approach if possible.
