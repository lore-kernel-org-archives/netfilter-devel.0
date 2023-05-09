Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E65C7EE22
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 May 2023 10:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234560AbjEIKXe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 May 2023 06:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjEIKXd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 May 2023 06:23:33 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01A22702
        for <netfilter-devel@vger.kernel.org>; Tue,  9 May 2023 03:23:31 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pwKVG-0004Wl-HK; Tue, 09 May 2023 12:23:30 +0200
Date:   Tue, 9 May 2023 12:23:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 00/11 nf-next,v1] track, reduce and prefetch expression
Message-ID: <20230509102330.GB14758@breakpoint.cc>
References: <20230505153130.2385-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505153130.2385-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This is v1 of a revamp of the track and reduce infrastructure. This is
> targeted at linear rulesets which perform reiterative checks on the same
> selectors, such as iptables-nft.
> 
> In this iteration, userspace specifies what expressions should be
> prefetched by the kernel in the context of a given chain. The prefetch
> operation in inconditional and it happens before the chain evaluation.
> This prefetch operation is also subject to NFT_BREAK, therefore,
> register tracking is also performed in runtime. The prefetched
> expressions are specified via NFTA_CHAIN_EXPRESSION. Userspace might
> decide to opt-out, ie. prefetch nothing at all.

Did you consider to change this so that if any of the prefetches fail
the entire chain evaluation stops right then and there?

I'd imagine that userspace would be conservative in what to
prefetch, so candidates would be

ip saddr/daddr, protocol, meta iifname/iif/oifname/oif and so on.

I'm not sure its really needed to add the extra runtime tracking.

Or did you expect userspace to also ask for prefetch for say, vlan tags
where we have to cope with 'partial' ruleset matches?

Alternatively the prefetches could be restricted to the network header in
which case they'd never fail and eval loop could always rely on the
registers to be valid.

Would simplify the implementation.  Just asking/wondering.

The only problem I see is with payload mangling, e.g.

'ip daddr set 1.2.3.4' or similar, but I guess the onus is on
userspace to not ask for a prefetch in this case?

> Userspace deals with allocating the registers, so it has to carefully
> select the register that already contains the prefetched expression (if
> available). Based on this, the kernel reduces the expressions when the
> ruleset blob is built, in case the register already contains the
> expression data, based on the register tracking information that is
> loaded via NFTA_CHAIN_EXPRESSION for expression to be prefetched. The
> reduction is not done from userspace to allow for incremental ruleset
> updates.

OK.

> Currently returning from jump to chain also restores prefetched
> registers when coming back to parent chain.

Ouch :)

I had hoped we don't have to increment jumpstack usage again.

Is there a way to avoid this?
For example by either requiring that the prefetched registers
are not scribbled over or by re-running the 'prefetch' on jump
returns?

> Several things can probably be simplified, and I might need to rebase on
> top of Florian's batch posted today. More runtime tests would be also
> convenient, selftests/netfilter seem to run fine on my side and it already
> helped me catch a few bugs.
> 
> Another idea: The prefetch infrastructure also allows to conditionally
> run the packet parser that sets up nft_pktinfo based on requirements via
> a new internal expression, according to the expression requirements that
> can be described via struct nft_expr_ops (this is not done in this
> batch), this is also relevant to skip IPv6 transport protocol parser if
> user does not need it.

Nice, thanks Pablo!
