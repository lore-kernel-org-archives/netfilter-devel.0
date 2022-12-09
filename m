Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D88C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Dec 2022 00:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiLIAl1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 19:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLIAl0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 19:41:26 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB28C950FE
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 16:41:25 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p3RS8-00038U-BY; Fri, 09 Dec 2022 01:41:24 +0100
Date:   Fri, 9 Dec 2022 01:41:24 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 1/7] ebtables: Implement --check command
Message-ID: <Y5KENOfZGWxPU8au@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20221201163916.30808-1-phil@nwl.cc>
 <20221201163916.30808-2-phil@nwl.cc>
 <Y5JZxolqr+dzWsgh@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5JZxolqr+dzWsgh@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 08, 2022 at 10:40:22PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Dec 01, 2022 at 05:39:10PM +0100, Phil Sutter wrote:
> > Sadly, '-C' is in use already for --change-counters (even though
> > ebtables-nft does not implement this), so add a long-option only. It is
> > needed for xlate testsuite in replay mode, which will use '--check'
> > instead of '-C'.
> 
> Hm, yet another of those exotic deviations (from ip{6}tables) in
> ebtables.
> 
> This -C is not supported by ebtables-nft, right? If so,
> according to manpage, ebtables -C takes start_nr[:end_nr].
> 
> Maybe there is a chance to get this aligned with other ip{6}tables
> tools by checking if optarg is available? Otherwise, really check the
> ruleset?
> 
> BTW, I'm re-reading the ebtables manpage, not sure how this feature -C
> was supposed to be used. Do you understand the usecase?

Yes, it's odd - so fits perfectly the rest of ebtables syntax. ;)

There are two ways to use it:

1) ebtables -C <CHAIN> <RULENO> <PCNT> <BCNT>
2) ebtables -C <CHAIN> <PCNT> <BCNT> <RULESPEC>

So I could check if the two parameters following the chain name are
numbers or not to distinguish between --change-counters and --check, but
it's ugly and with ebtables-nft not supporting one of them makes things
actually worse.

We need --check only for internal purposes, let's please just leave it
like this - there are much more important things to work on.

Cheers, Phil
