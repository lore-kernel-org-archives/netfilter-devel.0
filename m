Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF47C07545
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 19:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344291AbjJXTk6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 15:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234963AbjJXTk4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 15:40:56 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9657210DD
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 12:40:52 -0700 (PDT)
Received: from [78.30.35.151] (port=58708 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qvNGg-008gpR-D7; Tue, 24 Oct 2023 21:40:49 +0200
Date:   Tue, 24 Oct 2023 21:40:45 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
        fw@strlen.de, Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net] netfilter: flowtable: additional checks for outdated
 flows
Message-ID: <ZTgdvbb3Z8RrFWzJ@calendula>
References: <20231024171718.4080012-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231024171718.4080012-1-vladbu@nvidia.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Vlad,

On Tue, Oct 24, 2023 at 07:17:18PM +0200, Vlad Buslov wrote:
> Current nf_flow_is_outdated() implementation considers any flow table flow
> which state diverged from its underlying CT connection status for teardown
> which can be problematic in the following cases:
> 
> - Flow has never been offloaded to hardware in the first place either
> because flow table has hardware offload disabled (flag
> NF_FLOWTABLE_HW_OFFLOAD is not set) or because it is still pending on 'add'
> workqueue to be offloaded for the first time. The former is incorrect, the
> later generates excessive deletions and additions of flows.
> 
> - Flow is already pending to be updated on the workqueue. Tearing down such
> flows will also generate excessive removals from the flow table, especially
> on highly loaded system where the latency to re-offload a flow via 'add'
> workqueue can be quite high.
> 
> When considering a flow for teardown as outdated verify that it is both
> offloaded to hardware and doesn't have any pending updates.

Thanks.

I have posted an alternative patch to move the handling of
NF_FLOW_HW_ESTABLISHED, which is specific for sched/act_ct:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20231024193815.1987-1-pablo@netfilter.org/

it is a bit more code, but it makes it easier to understand for the
code reader that this bit is net/sched specific.

> Fixes: 41f2c7c342d3 ("net/sched: act_ct: Fix promotion of offloaded unreplied tuple")
> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> ---
>  net/netfilter/nf_flow_table_core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 1d34d700bd09..db404f89d3d7 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -319,6 +319,8 @@ EXPORT_SYMBOL_GPL(flow_offload_refresh);
>  static bool nf_flow_is_outdated(const struct flow_offload *flow)
>  {
>  	return test_bit(IPS_SEEN_REPLY_BIT, &flow->ct->status) &&
> +		test_bit(IPS_HW_OFFLOAD_BIT, &flow->ct->status) &&
> +		!test_bit(NF_FLOW_HW_PENDING, &flow->flags) &&
>  		!test_bit(NF_FLOW_HW_ESTABLISHED, &flow->flags);
>  }
>  
> -- 
> 2.39.2
> 
