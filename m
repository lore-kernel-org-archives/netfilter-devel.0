Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A16C61DA4
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Feb 2023 16:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbjBCQVe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Feb 2023 11:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjBCQVe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Feb 2023 11:21:34 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89291A641F
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Feb 2023 08:21:32 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pNyob-0007PH-N0; Fri, 03 Feb 2023 17:21:29 +0100
Date:   Fri, 3 Feb 2023 17:21:29 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v2] netfilter: nf_tables: Introduce
 NFTA_RULE_ACTUAL_EXPR
Message-ID: <Y900iRzf2q8xnXyv@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20221221142221.27211-1-phil@nwl.cc>
 <Y7/drsGvc8MkQiTY@orbyte.nwl.cc>
 <Y7/pzxvu2v4t4PgZ@salvia>
 <Y7/2843ObHqTDIFQ@orbyte.nwl.cc>
 <Y8fe9+XHbxYyD4LY@salvia>
 <Y8f4pNIcb2zH9QqZ@orbyte.nwl.cc>
 <Y9wrzkablavNnUXl@salvia>
 <Y90QrjOONoZmcCZL@orbyte.nwl.cc>
 <Y90o8eq3egHbtC3Z@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y90o8eq3egHbtC3Z@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 03, 2023 at 04:32:01PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Feb 03, 2023 at 02:48:30PM +0100, Phil Sutter wrote:
> > On Thu, Feb 02, 2023 at 10:31:58PM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Jan 18, 2023 at 02:48:20PM +0100, Phil Sutter wrote:
> > > [...]
> > > > The crucial aspect of this implementation is to provide a compatible
> > > > rule representation for old software which is not aware of it. This is
> > > > only possible by dumping the compat representation in the well-known
> > > > NFTA_RULE_EXPRESSIONS attribute.
> > > 
> > > OK, so NFTA_RULE_EXPRESSIONS contains the xt expressions.
> > > 
> > > Then, _ACTUAL_EXPR is taken if kernel supports it and these are
> > > expressions that run from datapath, if present.
> > 
> > Yes, this is indeed somewhat of a downside of this approach: a kernel
> > which doesn't support the new attribute will use the compatible version
> > of the rule instead of the improved one. But apart from that, everything
> > just works.
> 
> For old kernels, this behaviour is expected.
> 
> [...]
> > > > B) Submit the new representation as additional attribute
> > > > 
> > > > This is the current approach: If the additional attribute is present,
> > > > the kernel will use it to build the rule and leave NFTA_RULE_EXPRESSIONS
> > > > alone (actually: store it for dumps). Otherwise it will "fall back" to
> > > > using NFTA_RULE_EXPRESSIONS just as usual.
> > > >
> > > > When dumping, if a stored NFTA_RULE_EXPRESSIONS content is present, it
> > > > will dump that as-is and serialize the active rule into an additional
> > > > attribute. Otherwise the active rule will go into NFTA_RULE_EXPRESSIONS
> > > > just as usual.
> > > 
> > > So this is not swapping things, right? Probably I am still getting
> > > confused but the initial approach described in A.
> > 
> > No swap: The kernel will dump in NFTA_RULE_EXPRESSIONS exactly what it
> > got in that attribute, same for the new one.
> 
> Good.
> 
> > > When, dumping back to userspace, NFTA_RULE_EXPRESSIONS still stores
> > > the xt compat representation and NFTA_RULE_ACTUAL_EXPRS the one that
> > > runs from kernel datapath (if the kernel supports this attribute).
> > 
> > Yes, exactly. And old user space or nft will put the "new"
> > representation into NFTA_RULE_EXPRESSIONS, not attach
> > NFTA_RULE_ACTUAL_EXPRS and thus the kernel will use the former in its
> > data path.
> 
> That is:
> 
> = New kernels / new userspace =
> 
> - NFTA_RULE_EXPRESSIONS is used if no NFTA_RULE_ACTUAL_EXPRS is provided.
> - if NFTA_RULE_ACTUAL_EXPRS is provided, then it is used.
> 
> = New kernels / old userspace =
> 
> - NFTA_RULE_EXPRESSIONS is always used.
> 
> = Old kernels / new userspace =
> 
> - NFTA_RULE_EXPRESSIONS is always used, NFTA_RULE_ACTUAL_EXPRS is ignored.

Correct.

> > > [...]
> > > > I am swapping things around in libnftnl - it uses NFTA_RULE_ACTUAL_EXPRS
> > > > if present and puts NFTA_RULE_EXPRESSIONS into a second list for
> > > > verification only. In iptables, I parse both lists separately into
> > > > iptables_command_state objects and compare them. If not identical,
> > > > there's a bug.
> > > 
> > > Old kernels would simply discard the ACTUAL_ attribute. Maybe _ALT_
> > > standing by alternative is a better name?
> > 
> > Fine with me! "ACTUAL" was suggested by Florian, probably to point out
> > that it's what should take precedence if present. In my understanding,
> > "ALT" means "as good as".
> 
> From old kernel perspective, this is an alternative representation (it
> can be ignored).  From new kernel perspective, it is actual.
> 
> > > Sorry, this is a bit confusing but I understand something like this is
> > > required as you explained during the NFWS.
> > 
> > Thanks. Irrespective of the "crazy container people" mixing iptables
> > versions and variants like mad, I believe it will allow us to make more
> > drastic changes in future.
> 
> Thanks for explaining. This will be also more work from userspace to
> make sure both are consistent.
> 
> A user could abuse this API to add something completely different to
> NFTA_RULE_EXPRESSIONS while providing NFTA_RULE_ACTUAL_EXPRS.

I plan to make iptables-nft prefer ACTUAL when fetching rules. Comparing
against EXPRESSIONS is as easy as comparing two rules, but useful rather
as debug-option for sanity checks. The "evil admin" case you mention is
relevant with old user space, which obviously can't do any verification.

> I also wonder if this might cause problems with nftables and implicit
> sets, they are bound to one single lookup expression that, when gone,
> the set is released. Now you will have two expressions pointing to an
> implicit set. Same thing with implicit chains. This might get tricky
> with the transaction interface.

While indeed two lookup expressions will refer to the same anonymous
set, only one of those expressions will ever be in use. There's no way
the kernel would switch between rule variants (or use both at the same
time).

> iptables is rather simple representation (no sets), but nftables is
> more expressive.

That's not true, at least ebtables' among match is implemented using
sets. :)

Cheers, Phil
