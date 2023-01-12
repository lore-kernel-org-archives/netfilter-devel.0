Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B5CC54EBC
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Jan 2023 12:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbjALMI2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Jan 2023 07:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbjALMHi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2023 07:07:38 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E54ED2EF
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2023 04:03:02 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pFwIN-0005Ey-BL; Thu, 12 Jan 2023 13:03:00 +0100
Date:   Thu, 12 Jan 2023 13:02:59 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v2] netfilter: nf_tables: Introduce
 NFTA_RULE_ACTUAL_EXPR
Message-ID: <Y7/2843ObHqTDIFQ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20221221142221.27211-1-phil@nwl.cc>
 <Y7/drsGvc8MkQiTY@orbyte.nwl.cc>
 <Y7/pzxvu2v4t4PgZ@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7/pzxvu2v4t4PgZ@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 12, 2023 at 12:06:55PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Jan 12, 2023 at 11:15:10AM +0100, Phil Sutter wrote:
> > Bump?
> > 
> > On Wed, Dec 21, 2022 at 03:22:21PM +0100, Phil Sutter wrote:
> > > Allow for user space to provide an improved variant of the rule for
> > > actual use. The variant in NFTA_RULE_EXPRESSIONS may provide maximum
> > > compatibility for old user space tools (e.g. in outdated containers).
> > > 
> > > The new attribute is also dumped back to user space, e.g. for comparison
> > > against the compatible variant.
> > > 
> > > While being at it, improve nft_rule_policy for NFTA_RULE_EXPRESSIONS.
> 
> Could you split this in two patches?

Separate the nft_rule_policy_change? Sure!

> I still don't see how this is improving the situation for the scenario
> you describe, if you could extend a bit on how you plan to use this
> I'd appreciate.

I can send you my WiP libnftnl and iptables patches if that helps.

The approach this patch follows is pretty simple, though: The kernel
will accept NFTA_RULE_ACTUAL_EXPR to override NFTA_RULE_EXPRESSIONS for
use in the live ruleset.  When fetching the ruleset, old user space will
ignore NFTA_RULE_ACTUAL_EXPR, so new user space may submit a compatible
variant of the rule in NFTA_RULE_EXPRESSIONS and a modern variant in
NFTA_RULE_ACTUAL_EXPR.

In iptables, when converting a rule from iptables_command_state into
nftnl expressions, I insert all expressions into both
NFTA_RULE_EXPRESSIONS and NFTA_RULE_ACTUAL_EXPR unless an extension does
fancy stuff (e.g. was converted into native expressions).

My test piece is limit match which had to be converted once (see commit
5de8dcf75941c for details): I add the native expressions to
NFTA_RULE_ACTUAL_EXPR and create a compat "match" expression for
NFTA_RULE_EXPRESSIONS only.

The kernel will use the native expressions in the ruleset, dumps will
contain the compat "match" expression instead.

Cheers, Phil
