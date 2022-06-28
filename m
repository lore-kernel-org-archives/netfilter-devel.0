Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7703C43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jun 2022 17:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbiF1RDj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 13:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbiF1RC6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 13:02:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D51EE1D2
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jun 2022 10:02:57 -0700 (PDT)
Date:   Tue, 28 Jun 2022 19:02:55 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Radim Hrazdil <rhrazdil@redhat.com>
Subject: Re: [PATCH nf] netfilter: br_netfilter: do not skip all hooks with 0
 priority
Message-ID: <Yrs0P/27g1BFda9c@salvia>
References: <20220621162603.4094-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220621162603.4094-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 21, 2022 at 06:26:03PM +0200, Florian Westphal wrote:
> When br_netfilter module is loaded, skbs may be diverted to the
> ipv4/ipv6 hooks, just like as if we were routing.
> 
> Unfortunately, bridge filter hooks with priority 0 may be skipped
> in this case.
> 
> Example:
> 1. an nftables bridge ruleset is loaded, with a prerouting
>    hook that has priority 0.
> 2. interface is added to the bridge.
> 3. no tcp packet is ever seen by the bridge prerouting hook.
> 4. flush the ruleset
> 5. load the bridge ruleset again.
> 6. tcp packets are processed as expected.
> 
> After 1) the only registered hook is the bridge prerouting hook, but its
> not called yet because the bridge hasn't been brought up yet.
> 
> After 2), hook order is:
>    0 br_nf_pre_routing // br_netfilter internal hook
>    0 chain bridge f prerouting // nftables bridge ruleset
> 
> The packet is diverted to br_nf_pre_routing.
> If call-iptables is off, the nftables bridge ruleset is called as expected.
> 
> But if its enabled, br_nf_hook_thresh() will skip it because it assumes
> that all 0-priority hooks had been called previously in bridge context.
> 
> To avoid this, check for the br_nf_pre_routing hook itself, we need to
> resume directly after it, even if this hook has a priority of 0.
> 
> Unfortunately, this still results in different packet flow.
> With this fix, the eval order after in 3) is:
> 1. br_nf_pre_routing
> 2. ip(6)tables (if enabled)
> 3. nftables bridge
> 
> but after 5 its the much saner:
> 1. nftables bridge
> 2. br_nf_pre_routing
> 3. ip(6)tables (if enabled)
> 
> Unfortunately I don't see a solution here:
> It would be possible to move br_nf_pre_routing to a higher priority
> so that it will be called later in the pipeline, but this also impacts
> ebtables evaluation order, and would still result in this very ordering
> problem for all nftables-bridge hooks with the same priority as the
> br_nf_pre_routing one.
> 
> Searching back through the git history I don't think this has
> ever behaved in any other way, hence, no fixes-tag.

Applied to nf, thanks
