Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF2FC77B73
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 May 2023 09:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbjEaJvr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 May 2023 05:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbjEaJvq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 May 2023 05:51:46 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3499BD9
        for <netfilter-devel@vger.kernel.org>; Wed, 31 May 2023 02:51:45 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1q4IUY-0006mX-FM; Wed, 31 May 2023 11:51:42 +0200
Date:   Wed, 31 May 2023 11:51:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 2/3] netfilter: nf_tables: validate register
 loads never access unitialised registers
Message-ID: <20230531095142.GA26696@breakpoint.cc>
References: <20230505111656.32238-1-fw@strlen.de>
 <20230505111656.32238-3-fw@strlen.de>
 <ZHaLnEMlaGG0mwUs@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHaLnEMlaGG0mwUs@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >     rule 1: reg2 := meta load iif, reg2  == 1 jump ...
> >     rule 2: reg2 == 2 jump ...   // read access with no store in this rule
> > 
> > ... after this change this is rejected.
> 
> We can probably achieve the same effect by recovering the runtime
> register tracking patches I posted. It should be possible to add
> unlikely() to the branch that checks for uninitialized data in source
> register, that is missing in this patch:
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230505153130.2385-6-pablo@netfilter.org/
> 
> such patch also equires these patches to add the helpers to load and
> store:
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230505153130.2385-3-pablo@netfilter.org/
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230505153130.2385-4-pablo@netfilter.org/
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230505153130.2385-5-pablo@netfilter.org/
> 
> I think those helpers to load and store on registers should have been
> there since the beginning instead of opencoding operations on the
> registers. I am going to collect some numbers with these patches
> including unlikely() to the _load() checks. I fear I might have
> introduced some subtle bug, I remember these patches are passing
> selftests fine, but I am not sure we have enough of these selftests.

Thanks, I agree that we will need runtime checking because control plane
is too complex due to stores becoming unreliable (NFT_BREAK
encountered) if we want to do this load suppression.

I get the impression that we're overthinking this, we really
should not bother too much with speeding up iptables-style linear
rulesets.

I'm only concerned with speeding up compact rulesets that use
sets/maps wherever possible.

I think for those getting rid of the memset() will help more
than eliding a couple of reloads.

> 1) what level should register tracking happen at? rule, chain or from
>    basechain to leaf chains (to ensure that we retain the freedom to
>    make more transformation from userspace, eg. static flag for ruleset
>    that never change to omit redundant operations in the generated
>    bytecode). Your patch selects rule level. Chain level will lose
>    context when jumping/going to another chain. Inspecting from
>    basechain to leaf chains will be expensive in dynamic rulesets.

Right.  I used rule level because its easy to do but as you say,
it prevents userspace from ever making a "clever" ruleset that
performs any sort of preload (without kernel update).

> 2) combo expressions omit the register store operation, the tracking
>    infrastructure would need to distinguish between two situations:
>    register data has been omitted or register data is missing because
>    userspace provides bytecode that tries to read uninitialized
>    registers.
> 
> While I agree control plane is ideal for this, because it allows to
> reject a ruleset that reads on uninitialized register data, checking
> at rule/chain level cripples expressiveness in a way that it will not
> be easy to revert in the future if we want to change direction.
> 
> > Neither nftables nor iptables-nft generate such rules, each rule is
> > always standalone.
> 
> That is true these days indeed. I like your approach because it is
> simple. But my concern is that this limits expressiveness.

Lets wait for your test with runtime checking, so we have some data
on how much of a slowdown that gives.

But I'd like to see some proof that a *good* ruleset has many
redundant loads where such cross-rule load elimination can add a
benefit in the first place.  Else doing runtime validation makes no
sense.

What I can think of is to allow this patch in,
i.e. rule level enforcement, and then follow a approach similar to what
you already proposed earlier: A per-chain prefetch stage.

This would mean instead of

chain [ rule [ expr, expr, expr ]] [ rule [ expr , expr ]] ..

we'd have
chain prefetch [ expr, expr ] [ rule ... ]

The prefetch is limited to selected meta and payload operations.
Failure means entire chain is bypassed.

Any sort of jump invalidates the prefetch.

So, this patch would be later relaxed to pre-init
the "prefetch" registers as "initialised", so following is legal:

prefetch: reg3: meta l4roto, reg4: meta load iif
rule 1: reg2 := ip saddr, lookup(reg2 . reg3 .reg 4) accept
rule 2: reg3 == icmp accept ...  // no longer rejected as uninitialized
rule 3: reg4 == "eth*" jump ...
rule 4: reg3 == icmp accept ...  // fails --> prefetch lost
rule 4: reg2 := ip saddr ...  // fails --> prefetch overwritten

Yet another idea: Introduce internal shadow registers:
Prefetch to reg1, reg2, reg3 will auto-store those *also*
to *pfr1*, *pfr2, and so on.

This would allow register content recovery after each jump:
reg1 = pfr1
reg2 = pfr2

and so on.

But again, I think this is the wrong approach and we should not
bother with load elimination or anything else that will complicate
the data path.

Combo match approach is good because it doesn't have that issue.
