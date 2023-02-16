Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D3AC64ED6
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Feb 2023 12:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjBPMFa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Feb 2023 07:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBPMFa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Feb 2023 07:05:30 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F3759C7
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Feb 2023 04:05:28 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pSd0w-00029z-41; Thu, 16 Feb 2023 13:05:26 +0100
Date:   Thu, 16 Feb 2023 13:05:26 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v2] netfilter: nf_tables: Introduce
 NFTA_RULE_ACTUAL_EXPR
Message-ID: <Y+4cBvcq7tH2Iw2t@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <Y90QrjOONoZmcCZL@orbyte.nwl.cc>
 <Y90o8eq3egHbtC3Z@salvia>
 <Y900iRzf2q8xnXyv@orbyte.nwl.cc>
 <Y94oUYqArYqhkmOX@salvia>
 <Y97HaXaEtIlFUQSJ@orbyte.nwl.cc>
 <Y+DN2miPlSlBAIaj@salvia>
 <Y+IrUPyJi/GE6Cbk@salvia>
 <Y+Iudd7MODhgjrgz@orbyte.nwl.cc>
 <Y+4LoOjaT1RU6I1r@orbyte.nwl.cc>
 <Y+4Tmv3H24XTiEhK@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+4Tmv3H24XTiEhK@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Feb 16, 2023 at 12:29:30PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Feb 16, 2023 at 11:55:28AM +0100, Phil Sutter wrote:
> > On Tue, Feb 07, 2023 at 11:56:53AM +0100, Phil Sutter wrote:
> > [...]
> > > Yes, please! I'll finish user space this week. :)
> > 
> > Famous last words. :(
> > 
> > I realized anonymous sets are indeed a problem, and I'm not sure how it
> > could be solved. I missed the fact that with lookup expressions one has
> > to run the init() callback to convert their per-batch set ID into the
> > kernel-defined set name. So the simple "copy and return nla" approach is
> > not sufficient.
> > 
> > Initializing all of the dump-only expressions though causes other
> > unwanted side-effects, like e.g. duplicated chain use-counters.
> > 
> > One could ban lookup from being used in dump-only expressions. Right
> > now, only ebtables' among match requires it.
> > 
> > To still allow for ebtables-nft to use the compat interface, among match
> > could be rewritten to use the legacy extension in-kernel. This doesn't
> > solve the original problem though, because old ebtables-nft versions
> > can't parse a match expression containing among extension.
> > 
> > Another option that might work is to parse the dump-only expressions in
> > nf_tables_newrule(), dump them into an skb, drop them again and extract
> > the skb's buffer for later.
> > 
> > Do you have a better idea perhaps? I'm a bit clueless how to proceed
> > further right now. :(
> 
> I'll drop the patch from nf-next and we take more time to think how to
> solve this.

ACK!

> This problem is interesting, but it is difficult!

Yes, it is. Maybe a feasible solution is to scan through the dump-only
expression nla and update any lookup ones manually. Pretty ugly though,
because it breaks the attribute encapsulation in expressions.

> Does this work for you?

Yes, thanks!

Cheers, Phil
