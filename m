Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CACDC77B73
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Apr 2023 11:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243459AbjD0LdR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Apr 2023 07:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243152AbjD0LdR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Apr 2023 07:33:17 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF154ECB
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Apr 2023 04:33:15 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1przs9-0003wv-EW; Thu, 27 Apr 2023 13:33:13 +0200
Date:   Thu, 27 Apr 2023 13:33:13 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v2] netfilter: nf_tables: Introduce
 NFTA_RULE_ACTUAL_EXPR
Message-ID: <ZEpdebCsg5JVYCU2@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <Y97HaXaEtIlFUQSJ@orbyte.nwl.cc>
 <Y+DN2miPlSlBAIaj@salvia>
 <Y+IrUPyJi/GE6Cbk@salvia>
 <Y+Iudd7MODhgjrgz@orbyte.nwl.cc>
 <Y+4LoOjaT1RU6I1r@orbyte.nwl.cc>
 <Y+4Tmv3H24XTiEhK@salvia>
 <Y+4cBvcq7tH2Iw2t@orbyte.nwl.cc>
 <ZEmCdMVboNu6dKiL@calendula>
 <ZEpVGpY3QzUwAMia@orbyte.nwl.cc>
 <ZEpWIxsipUoH489w@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEpWIxsipUoH489w@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 27, 2023 at 01:01:55PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 27, 2023 at 12:57:30PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Wed, Apr 26, 2023 at 09:58:44PM +0200, Pablo Neira Ayuso wrote:
> > [...]
> > > My proposal:
> > 
> > Thanks for returning to this. Your approach requires to define a minimum
> > version from which on forward-compat is guaranteed. I was trying to
> > avoid this requirement though so things would work for "unknown user
> > space".
> 
> You also require a kernel that supports your approach.

Sure. But in the described use-case, anything but old user space (i.e.,
container content) is under control.

> > Currently, the only offending extension is ebt_among since it doesn't
> > exist (and never did) in non-native form. If I implement among extension
> > parsing (even in non-functional form), my original approach would work.
> > This also means having a minimum version for full compat, but it affects
> > ebtables (actually, use of ebt_among) only.
> 
> Yes, but this is fully user data, kernel really does not need to do
> anything with this alternative representation, which is what I do not
> like from you proposal.

OK.

> I really think userdata is the place to deal with this.

Having to touch old user space is not a good solution for the given
use-case. If kernel modification is a no-go, I'd rather introduce a
"compat mode" in iptables-nft which causes rule creation in the most
compatible form. This might impact run-time performance but is much
simpler to implement and maintain.

Cheers, Phil
