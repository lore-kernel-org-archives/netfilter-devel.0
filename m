Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C71EC32793
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Jan 2023 12:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjARMgX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Jan 2023 07:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjARMfA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2023 07:35:00 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39E914616D
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2023 03:58:50 -0800 (PST)
Date:   Wed, 18 Jan 2023 12:58:47 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v2] netfilter: nf_tables: Introduce
 NFTA_RULE_ACTUAL_EXPR
Message-ID: <Y8fe9+XHbxYyD4LY@salvia>
References: <20221221142221.27211-1-phil@nwl.cc>
 <Y7/drsGvc8MkQiTY@orbyte.nwl.cc>
 <Y7/pzxvu2v4t4PgZ@salvia>
 <Y7/2843ObHqTDIFQ@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y7/2843ObHqTDIFQ@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 12, 2023 at 01:02:59PM +0100, Phil Sutter wrote:
> On Thu, Jan 12, 2023 at 12:06:55PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Jan 12, 2023 at 11:15:10AM +0100, Phil Sutter wrote:
> > > Bump?
> > > 
> > > On Wed, Dec 21, 2022 at 03:22:21PM +0100, Phil Sutter wrote:
> > > > Allow for user space to provide an improved variant of the rule for
> > > > actual use. The variant in NFTA_RULE_EXPRESSIONS may provide maximum
> > > > compatibility for old user space tools (e.g. in outdated containers).
> > > > 
> > > > The new attribute is also dumped back to user space, e.g. for comparison
> > > > against the compatible variant.
> > > > 
> > > > While being at it, improve nft_rule_policy for NFTA_RULE_EXPRESSIONS.
> > 
> > Could you split this in two patches?
> 
> Separate the nft_rule_policy_change? Sure!

Thanks.

> > I still don't see how this is improving the situation for the scenario
> > you describe, if you could extend a bit on how you plan to use this
> > I'd appreciate.
> 
> I can send you my WiP libnftnl and iptables patches if that helps.
> 
> The approach this patch follows is pretty simple, though: The kernel
> will accept NFTA_RULE_ACTUAL_EXPR to override NFTA_RULE_EXPRESSIONS for
> use in the live ruleset.  When fetching the ruleset, old user space will
> ignore NFTA_RULE_ACTUAL_EXPR, so new user space may submit a compatible
> variant of the rule in NFTA_RULE_EXPRESSIONS and a modern variant in
> NFTA_RULE_ACTUAL_EXPR.

so _ACTUAL_EXPR is the modern representation, and _RULE_EXPRESSIONS
the old one?

Maybe the opposite is better? I mean, no changes in the
NFTA_RULE_EXPRESSIONS semantics, these are always the expressions that
run in the datapath, and the alternative expression representation is
just for backward compatibility?

Maybe all this can be handled from _USERDATA? I mean, to add the
netlink representation there?

> In iptables, when converting a rule from iptables_command_state into
> nftnl expressions, I insert all expressions into both
> NFTA_RULE_EXPRESSIONS and NFTA_RULE_ACTUAL_EXPR unless an extension does
> fancy stuff (e.g. was converted into native expressions).

So NFTA_RULE_EXPRESSIONS contains xt compat expression or is it
ACTUAL_EXPR?

Probably you can just add NFTA_RULE_COMPAT_EXPRS? This new attribute
provides a pure xt compat representation? _ACTUAL concept gets me
confused.

> My test piece is limit match which had to be converted once (see commit
> 5de8dcf75941c for details): I add the native expressions to
> NFTA_RULE_ACTUAL_EXPR and create a compat "match" expression for
> NFTA_RULE_EXPRESSIONS only.

What gets me confused is what the kernel actually uses from the
datapath.

> The kernel will use the native expressions in the ruleset, dumps will
> contain the compat "match" expression instead.

Both representations should be dumped, right? In my mind, userspace
just falls back to my proposed NFTA_RULE_COMPAT_EXPRS in case it
cannot decode NFTA_RULE_EXPRESSIONS.

Sorry for taking a while to come back here.
