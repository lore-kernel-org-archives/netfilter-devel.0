Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14086C38147
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Jan 2023 14:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjAROJG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Jan 2023 09:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjAROIn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2023 09:08:43 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF9059576
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2023 05:48:23 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pI8nc-0000Ct-Ln; Wed, 18 Jan 2023 14:48:20 +0100
Date:   Wed, 18 Jan 2023 14:48:20 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v2] netfilter: nf_tables: Introduce
 NFTA_RULE_ACTUAL_EXPR
Message-ID: <Y8f4pNIcb2zH9QqZ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20221221142221.27211-1-phil@nwl.cc>
 <Y7/drsGvc8MkQiTY@orbyte.nwl.cc>
 <Y7/pzxvu2v4t4PgZ@salvia>
 <Y7/2843ObHqTDIFQ@orbyte.nwl.cc>
 <Y8fe9+XHbxYyD4LY@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8fe9+XHbxYyD4LY@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jan 18, 2023 at 12:58:47PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Jan 12, 2023 at 01:02:59PM +0100, Phil Sutter wrote:
> > On Thu, Jan 12, 2023 at 12:06:55PM +0100, Pablo Neira Ayuso wrote:
> > > On Thu, Jan 12, 2023 at 11:15:10AM +0100, Phil Sutter wrote:
> > > > Bump?
> > > > 
> > > > On Wed, Dec 21, 2022 at 03:22:21PM +0100, Phil Sutter wrote:
> > > > > Allow for user space to provide an improved variant of the rule for
> > > > > actual use. The variant in NFTA_RULE_EXPRESSIONS may provide maximum
> > > > > compatibility for old user space tools (e.g. in outdated containers).
> > > > > 
> > > > > The new attribute is also dumped back to user space, e.g. for comparison
> > > > > against the compatible variant.
> > > > > 
> > > > > While being at it, improve nft_rule_policy for NFTA_RULE_EXPRESSIONS.
> > > 
> > > Could you split this in two patches?
> > 
> > Separate the nft_rule_policy_change? Sure!
> 
> Thanks.
> 
> > > I still don't see how this is improving the situation for the scenario
> > > you describe, if you could extend a bit on how you plan to use this
> > > I'd appreciate.
> > 
> > I can send you my WiP libnftnl and iptables patches if that helps.
> > 
> > The approach this patch follows is pretty simple, though: The kernel
> > will accept NFTA_RULE_ACTUAL_EXPR to override NFTA_RULE_EXPRESSIONS for
> > use in the live ruleset.  When fetching the ruleset, old user space will
> > ignore NFTA_RULE_ACTUAL_EXPR, so new user space may submit a compatible
> > variant of the rule in NFTA_RULE_EXPRESSIONS and a modern variant in
> > NFTA_RULE_ACTUAL_EXPR.
> 
> so _ACTUAL_EXPR is the modern representation, and _RULE_EXPRESSIONS
> the old one?
> 
> Maybe the opposite is better? I mean, no changes in the
> NFTA_RULE_EXPRESSIONS semantics, these are always the expressions that
> run in the datapath, and the alternative expression representation is
> just for backward compatibility?
> 
> Maybe all this can be handled from _USERDATA? I mean, to add the
> netlink representation there?

The crucial aspect of this implementation is to provide a compatible
rule representation for old software which is not aware of it. This is
only possible by dumping the compat representation in the well-known
NFTA_RULE_EXPRESSIONS attribute.

This means what is contained in NFTA_RULE_EXPRESSIONS may not be what
the kernel actually executes. To make this less scary, the kernel should
dump the actual rule in a second attribute for the sake of verification
in user space.

While rule dumps are pretty much fixed given the above, there is
flexibility when it comes to loading the rule:

A) Submit the compat representation as additional attribute

This was my initial approach, but Florian objected because the changing
content of NFTA_RULE_EXPRESSIONS attribute may be confusing:

On input, NFTA_RULE_EXPRESSIONS contains the new rule representation, on
output it contains the compat one. The extra attribute I introduced
behaves identical, i.e. on input it holds the compat representation
while on output it holds the new one.

B) Submit the new representation as additional attribute

This is the current approach: If the additional attribute is present,
the kernel will use it to build the rule and leave NFTA_RULE_EXPRESSIONS
alone (actually: store it for dumps). Otherwise it will "fall back" to
using NFTA_RULE_EXPRESSIONS just as usual.

When dumping, if a stored NFTA_RULE_EXPRESSIONS content is present, it
will dump that as-is and serialize the active rule into an additional
attribute. Otherwise the active rule will go into NFTA_RULE_EXPRESSIONS
just as usual.

> > In iptables, when converting a rule from iptables_command_state into
> > nftnl expressions, I insert all expressions into both
> > NFTA_RULE_EXPRESSIONS and NFTA_RULE_ACTUAL_EXPR unless an extension does
> > fancy stuff (e.g. was converted into native expressions).
> 
> So NFTA_RULE_EXPRESSIONS contains xt compat expression or is it
> ACTUAL_EXPR?
> 
> Probably you can just add NFTA_RULE_COMPAT_EXPRS? This new attribute
> provides a pure xt compat representation? _ACTUAL concept gets me
> confused.

See above. I hope it clarifies things.

> > My test piece is limit match which had to be converted once (see commit
> > 5de8dcf75941c for details): I add the native expressions to
> > NFTA_RULE_ACTUAL_EXPR and create a compat "match" expression for
> > NFTA_RULE_EXPRESSIONS only.
> 
> What gets me confused is what the kernel actually uses from the
> datapath.
> 
> > The kernel will use the native expressions in the ruleset, dumps will
> > contain the compat "match" expression instead.
> 
> Both representations should be dumped, right? In my mind, userspace
> just falls back to my proposed NFTA_RULE_COMPAT_EXPRS in case it
> cannot decode NFTA_RULE_EXPRESSIONS.

I am swapping things around in libnftnl - it uses NFTA_RULE_ACTUAL_EXPRS
if present and puts NFTA_RULE_EXPRESSIONS into a second list for
verification only. In iptables, I parse both lists separately into
iptables_command_state objects and compare them. If not identical,
there's a bug.

> Sorry for taking a while to come back here.

No problem.

Cheers, Phil
