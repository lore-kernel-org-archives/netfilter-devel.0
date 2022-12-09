Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA9BBC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Dec 2022 15:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbiLIPXz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Dec 2022 10:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiLIPXw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Dec 2022 10:23:52 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 513A78C6BD
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2022 07:23:52 -0800 (PST)
Date:   Fri, 9 Dec 2022 16:23:49 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 1/7] ebtables: Implement --check command
Message-ID: <Y5NTBWT+YiM3o3qQ@salvia>
References: <20221201163916.30808-1-phil@nwl.cc>
 <20221201163916.30808-2-phil@nwl.cc>
 <Y5JZxolqr+dzWsgh@salvia>
 <Y5KENOfZGWxPU8au@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y5KENOfZGWxPU8au@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Dec 09, 2022 at 01:41:24AM +0100, Phil Sutter wrote:
> On Thu, Dec 08, 2022 at 10:40:22PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Dec 01, 2022 at 05:39:10PM +0100, Phil Sutter wrote:
> > > Sadly, '-C' is in use already for --change-counters (even though
> > > ebtables-nft does not implement this), so add a long-option only. It is
> > > needed for xlate testsuite in replay mode, which will use '--check'
> > > instead of '-C'.
> > 
> > Hm, yet another of those exotic deviations (from ip{6}tables) in
> > ebtables.
> > 
> > This -C is not supported by ebtables-nft, right? If so,
> > according to manpage, ebtables -C takes start_nr[:end_nr].
> > 
> > Maybe there is a chance to get this aligned with other ip{6}tables
> > tools by checking if optarg is available? Otherwise, really check the
> > ruleset?
> > 
> > BTW, I'm re-reading the ebtables manpage, not sure how this feature -C
> > was supposed to be used. Do you understand the usecase?
> 
> Yes, it's odd - so fits perfectly the rest of ebtables syntax. ;)
> 
> There are two ways to use it:
> 
> 1) ebtables -C <CHAIN> <RULENO> <PCNT> <BCNT>
> 2) ebtables -C <CHAIN> <PCNT> <BCNT> <RULESPEC>
> 
> So I could check if the two parameters following the chain name are
> numbers or not to distinguish between --change-counters and --check, but
> it's ugly and with ebtables-nft not supporting one of them makes things
> actually worse.
> 
> We need --check only for internal purposes, let's please just leave it
> like this - there are much more important things to work on.

OK, just an idea in case there is a need for getting ebtables more
aligned with other xtables userspace.
