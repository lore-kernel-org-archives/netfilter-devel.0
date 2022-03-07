Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36658C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Mar 2022 21:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239311AbiCGVsy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Mar 2022 16:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343888AbiCGVsl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Mar 2022 16:48:41 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 579F4BC7
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2022 13:47:45 -0800 (PST)
Received: from netfilter.org (unknown [87.190.248.243])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4B3966019B;
        Mon,  7 Mar 2022 22:45:53 +0100 (CET)
Date:   Mon, 7 Mar 2022 22:47:41 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
        fw@strlen.de, ozsh@nvidia.com, paulb@nvidia.com
Subject: Re: [PATCH net-next 2/8] netfilter: introduce total count of hw
 offloaded flow table entries
Message-ID: <YiZ9fQ8oMSOn5Su2@salvia>
References: <20220222151003.2136934-1-vladbu@nvidia.com>
 <20220222151003.2136934-3-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220222151003.2136934-3-vladbu@nvidia.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 22, 2022 at 05:09:57PM +0200, Vlad Buslov wrote:
> To improve hardware offload debuggability and allow capping total amount of
> offloaded entries in following patch extend struct netns_nftables with
> 'count_hw' counter and expose it to userspace as 'nf_flowtable_count_hw'
> sysctl entry. Increment the counter together with setting NF_FLOW_HW flag
> when scheduling offload add task on workqueue and decrement it after
> successfully scheduling offload del task.
> 
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> ---
>  include/net/netns/nftables.h            |  1 +
>  net/netfilter/nf_conntrack_standalone.c | 12 ++++++++++++
>  net/netfilter/nf_flow_table_core.c      | 12 ++++++++++--
>  3 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
> index 8c77832d0240..262b8b3213cb 100644
> --- a/include/net/netns/nftables.h
> +++ b/include/net/netns/nftables.h
> @@ -6,6 +6,7 @@
>  
>  struct netns_nftables {
>  	u8			gencursor;
> +	atomic_t		count_hw;
>  };
>  
>  #endif
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 3e1afd10a9b6..8cd55d502ffd 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -618,6 +618,9 @@ enum nf_ct_sysctl_index {
>  #ifdef CONFIG_LWTUNNEL
>  	NF_SYSCTL_CT_LWTUNNEL,
>  #endif
> +#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
> +	NF_SYSCTL_CT_COUNT_HW,
> +#endif
>  
>  	__NF_SYSCTL_CT_LAST_SYSCTL,
>  };
> @@ -973,6 +976,14 @@ static struct ctl_table nf_ct_sysctl_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= nf_hooks_lwtunnel_sysctl_handler,
>  	},
> +#endif
> +#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
> +	[NF_SYSCTL_CT_COUNT_HW] = {
> +		.procname	= "nf_flowtable_count_hw",
> +		.maxlen		= sizeof(int),
> +		.mode		= 0444,
> +		.proc_handler	= proc_dointvec,
> +	},
>  #endif
>  	{}
>  };
> @@ -1111,6 +1122,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
>  	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_STREAM].data = &un->timeouts[UDP_CT_REPLIED];
>  #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
>  	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD].data = &un->offload_timeout;
> +	table[NF_SYSCTL_CT_COUNT_HW].data = &net->nft.count_hw;
>  #endif
>  
>  	nf_conntrack_standalone_init_tcp_sysctl(net, table);
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index b90eca7a2f22..9f2b68bc6f80 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -315,6 +315,9 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
>  	nf_ct_offload_timeout(flow->ct);
>  
>  	if (nf_flowtable_hw_offload(flow_table)) {
> +		struct net *net = read_pnet(&flow_table->net);
> +
> +		atomic_inc(&net->nft.count_hw);
>  		__set_bit(NF_FLOW_HW, &flow->flags);
>  		nf_flow_offload_add(flow_table, flow);

Better increment this new counter from flow_offload_work_add()? There
is offload->flowtable->net, you could use it from there to bump the
counter once this is placed in hardware (by when IPS_HW_OFFLOAD_BIT is
set on).

That also moves the atomic would be away from the packet path.

>  	}
> @@ -462,10 +465,15 @@ static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
>  
>  	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
>  		if (test_bit(NF_FLOW_HW, &flow->flags)) {
> -			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
> +			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags)) {
> +				struct net *net = read_pnet(&flow_table->net);
> +
>  				nf_flow_offload_del(flow_table, flow);
> -			else if (test_bit(NF_FLOW_HW_DEAD, &flow->flags))
> +				if (test_bit(NF_FLOW_HW_DYING, &flow->flags))
> +					atomic_dec(&net->nft.count_hw);

Same with this, I'd suggest to decrement it from flow_offload_work_del().

> +			} else if (test_bit(NF_FLOW_HW_DEAD, &flow->flags)) {
>  				flow_offload_del(flow_table, flow);
> +			}
>  		} else {
>  			flow_offload_del(flow_table, flow);
>  		}
> -- 
> 2.31.1
> 
