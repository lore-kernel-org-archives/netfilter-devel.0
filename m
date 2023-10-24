Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B8D7C07545
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 20:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344259AbjJXUIB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 16:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344312AbjJXUIA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 16:08:00 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB89A2
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 13:07:58 -0700 (PDT)
Received: from [78.30.35.151] (port=58738 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qvNgv-008nMJ-S1; Tue, 24 Oct 2023 22:07:56 +0200
Date:   Tue, 24 Oct 2023 22:07:53 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
        fw@strlen.de, Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net] netfilter: flowtable: additional checks for outdated
 flows
Message-ID: <ZTgkGTiGbbcHcFWN@calendula>
References: <20231024171718.4080012-1-vladbu@nvidia.com>
 <ZTgdvbb3Z8RrFWzJ@calendula>
 <87pm13pzny.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87pm13pzny.fsf@nvidia.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 24, 2023 at 10:45:31PM +0300, Vlad Buslov wrote:
> On Tue 24 Oct 2023 at 21:40, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi Vlad,
> >
> > On Tue, Oct 24, 2023 at 07:17:18PM +0200, Vlad Buslov wrote:
> >> Current nf_flow_is_outdated() implementation considers any flow table flow
> >> which state diverged from its underlying CT connection status for teardown
> >> which can be problematic in the following cases:
> >> 
> >> - Flow has never been offloaded to hardware in the first place either
> >> because flow table has hardware offload disabled (flag
> >> NF_FLOWTABLE_HW_OFFLOAD is not set) or because it is still pending on 'add'
> >> workqueue to be offloaded for the first time. The former is incorrect, the
> >> later generates excessive deletions and additions of flows.
> >> 
> >> - Flow is already pending to be updated on the workqueue. Tearing down such
> >> flows will also generate excessive removals from the flow table, especially
> >> on highly loaded system where the latency to re-offload a flow via 'add'
> >> workqueue can be quite high.
> >> 
> >> When considering a flow for teardown as outdated verify that it is both
> >> offloaded to hardware and doesn't have any pending updates.
> >
> > Thanks.
> >
> > I have posted an alternative patch to move the handling of
> > NF_FLOW_HW_ESTABLISHED, which is specific for sched/act_ct:
> >
> > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20231024193815.1987-1-pablo@netfilter.org/
> >
> > it is a bit more code, but it makes it easier to understand for the
> > code reader that this bit is net/sched specific.
> >
> 
> Thanks for refactoring this, I agree that separating the act_ct-specific
> check makes it more obvious.
> 
> How would you prefer to solve the conflict with my fix? Should I wait
> for your patch to be accepted to net, rebase my fix on top and submit
> V2? Or you can incorporate the checks from my fix together with my
> signoff and submit it as a single change?

Rebased here as per your request:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20231024200243.50784-1-pablo@netfilter.org/

I took the freedom to take your Signed-off-by: and Paul's Reviewed-by:
which is not the best way to go, but please acknowledge this is fine
in this exceptional case.

We can handle this via nf.git tree, there were no plans to send a PR
to netdev, but I think these fixes are worth to (try to) get them
there in time for the 6.6 release.

Thanks.
