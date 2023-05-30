Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D56F2C7EE23
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 May 2023 23:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbjE3Xtx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 May 2023 19:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjE3Xtx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 May 2023 19:49:53 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3AEFFB2
        for <netfilter-devel@vger.kernel.org>; Tue, 30 May 2023 16:49:51 -0700 (PDT)
Date:   Wed, 31 May 2023 01:49:48 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 2/3] netfilter: nf_tables: validate register
 loads never access unitialised registers
Message-ID: <ZHaLnEMlaGG0mwUs@calendula>
References: <20230505111656.32238-1-fw@strlen.de>
 <20230505111656.32238-3-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230505111656.32238-3-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Fri, May 05, 2023 at 01:16:55PM +0200, Florian Westphal wrote:
> Reject rules where a load occurs from a register that has not seen a
> store early in the same rule.
> 
> commit 4c905f6740a3 ("netfilter: nf_tables: initialize registers in nft_do_chain()")
> had to add a unconditional memset to the nftables register space to
> avoid leaking stack information to userspace.
> 
> This memset shows up in benchmarks.  After this change, this commit
> can be reverted again.
> 
> Note that this breaks userspace compatibility, because theoretically
> you can do
> 
>     rule 1: reg2 := meta load iif, reg2  == 1 jump ...
>     rule 2: reg2 == 2 jump ...   // read access with no store in this rule
> 
> ... after this change this is rejected.

We can probably achieve the same effect by recovering the runtime
register tracking patches I posted. It should be possible to add
unlikely() to the branch that checks for uninitialized data in source
register, that is missing in this patch:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230505153130.2385-6-pablo@netfilter.org/

such patch also equires these patches to add the helpers to load and
store:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230505153130.2385-3-pablo@netfilter.org/
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230505153130.2385-4-pablo@netfilter.org/
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230505153130.2385-5-pablo@netfilter.org/

I think those helpers to load and store on registers should have been
there since the beginning instead of opencoding operations on the
registers. I am going to collect some numbers with these patches
including unlikely() to the _load() checks. I fear I might have
introduced some subtle bug, I remember these patches are passing
selftests fine, but I am not sure we have enough of these selftests.

As you suggested, I also considered using the new track infrastructure
(the one I posted to achieve the combo expressions) to detect a read
to uninitialized registers from control plane, but it gets complicated
again because:

1) what level should register tracking happen at? rule, chain or from
   basechain to leaf chains (to ensure that we retain the freedom to
   make more transformation from userspace, eg. static flag for ruleset
   that never change to omit redundant operations in the generated
   bytecode). Your patch selects rule level. Chain level will lose
   context when jumping/going to another chain. Inspecting from
   basechain to leaf chains will be expensive in dynamic rulesets.

2) combo expressions omit the register store operation, the tracking
   infrastructure would need to distinguish between two situations:
   register data has been omitted or register data is missing because
   userspace provides bytecode that tries to read uninitialized
   registers.

While I agree control plane is ideal for this, because it allows to
reject a ruleset that reads on uninitialized register data, checking
at rule/chain level cripples expressiveness in a way that it will not
be easy to revert in the future if we want to change direction.

> Neither nftables nor iptables-nft generate such rules, each rule is
> always standalone.

That is true these days indeed. I like your approach because it is
simple. But my concern is that this limits expressiveness.

Thanks.
