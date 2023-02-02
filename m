Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88ABDC61DA4
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Feb 2023 21:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjBBVcE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Feb 2023 16:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjBBVcD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Feb 2023 16:32:03 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E86C2712
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Feb 2023 13:32:02 -0800 (PST)
Date:   Thu, 2 Feb 2023 22:31:58 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v2] netfilter: nf_tables: Introduce
 NFTA_RULE_ACTUAL_EXPR
Message-ID: <Y9wrzkablavNnUXl@salvia>
References: <20221221142221.27211-1-phil@nwl.cc>
 <Y7/drsGvc8MkQiTY@orbyte.nwl.cc>
 <Y7/pzxvu2v4t4PgZ@salvia>
 <Y7/2843ObHqTDIFQ@orbyte.nwl.cc>
 <Y8fe9+XHbxYyD4LY@salvia>
 <Y8f4pNIcb2zH9QqZ@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y8f4pNIcb2zH9QqZ@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Wed, Jan 18, 2023 at 02:48:20PM +0100, Phil Sutter wrote:
[...]
> The crucial aspect of this implementation is to provide a compatible
> rule representation for old software which is not aware of it. This is
> only possible by dumping the compat representation in the well-known
> NFTA_RULE_EXPRESSIONS attribute.

OK, so NFTA_RULE_EXPRESSIONS contains the xt expressions.

Then, _ACTUAL_EXPR is taken if kernel supports it and these are
expressions that run from datapath, if present.

> This means what is contained in NFTA_RULE_EXPRESSIONS may not be what
> the kernel actually executes. To make this less scary, the kernel should
> dump the actual rule in a second attribute for the sake of verification
> in user space.
>
> While rule dumps are pretty much fixed given the above, there is
> flexibility when it comes to loading the rule:
> 
> A) Submit the compat representation as additional attribute
> 
> This was my initial approach, but Florian objected because the changing
> content of NFTA_RULE_EXPRESSIONS attribute may be confusing:

It is indeed.

> On input, NFTA_RULE_EXPRESSIONS contains the new rule representation, on
> output it contains the compat one. The extra attribute I introduced
> behaves identical, i.e. on input it holds the compat representation
> while on output it holds the new one.
> 
> B) Submit the new representation as additional attribute
> 
> This is the current approach: If the additional attribute is present,
> the kernel will use it to build the rule and leave NFTA_RULE_EXPRESSIONS
> alone (actually: store it for dumps). Otherwise it will "fall back" to
> using NFTA_RULE_EXPRESSIONS just as usual.
>
> When dumping, if a stored NFTA_RULE_EXPRESSIONS content is present, it
> will dump that as-is and serialize the active rule into an additional
> attribute. Otherwise the active rule will go into NFTA_RULE_EXPRESSIONS
> just as usual.

So this is not swapping things, right? Probably I am still getting
confused but the initial approach described in A.

When, dumping back to userspace, NFTA_RULE_EXPRESSIONS still stores
the xt compat representation and NFTA_RULE_ACTUAL_EXPRS the one that
runs from kernel datapath (if the kernel supports this attribute).

[...]
> I am swapping things around in libnftnl - it uses NFTA_RULE_ACTUAL_EXPRS
> if present and puts NFTA_RULE_EXPRESSIONS into a second list for
> verification only. In iptables, I parse both lists separately into
> iptables_command_state objects and compare them. If not identical,
> there's a bug.

Old kernels would simply discard the ACTUAL_ attribute. Maybe _ALT_
standing by alternative is a better name?

Sorry, this is a bit confusing but I understand something like this is
required as you explained during the NFWS.
