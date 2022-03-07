Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1557BC433FE
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Mar 2022 22:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244498AbiCGWO3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Mar 2022 17:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240686AbiCGWO0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Mar 2022 17:14:26 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 46BA55622C
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2022 14:13:31 -0800 (PST)
Received: from netfilter.org (unknown [87.190.248.243])
        by mail.netfilter.org (Postfix) with ESMTPSA id 14F3F63001;
        Mon,  7 Mar 2022 23:11:39 +0100 (CET)
Date:   Mon, 7 Mar 2022 23:13:26 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
        fw@strlen.de, ozsh@nvidia.com, paulb@nvidia.com
Subject: Re: [PATCH net-next 3/8] netfilter: introduce max count of hw
 offloaded flow table entries
Message-ID: <YiaDhju4TNFtLJSE@salvia>
References: <20220222151003.2136934-1-vladbu@nvidia.com>
 <20220222151003.2136934-4-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220222151003.2136934-4-vladbu@nvidia.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 22, 2022 at 05:09:58PM +0200, Vlad Buslov wrote:
> To improve hardware offload debuggability extend struct netns_nftables with
> 'max_hw' counter and expose it to userspace as 'nf_flowtable_max_hw' sysctl
> entry. Verify that count_hw value is less than max_hw and don't offload new
> flow table entry to hardware, if this is not the case. Flows that were not
> offloaded due to count_hw being larger than set maximum can still be
> offloaded via refresh function. Mark such flows with NF_FLOW_HW bit and
> only count them once by checking that the bit was previously not set.

Fine with me. Keep in mind there is also an implicit cap with the
maximum number of conntrack entries (nf_conntrack_max).

> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> ---
>  include/net/netns/nftables.h            |  1 +
>  net/netfilter/nf_conntrack_standalone.c | 11 +++++++++++
>  net/netfilter/nf_flow_table_core.c      | 25 +++++++++++++++++++++++--
>  3 files changed, 35 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
> index 262b8b3213cb..5677f21fdd4c 100644
> --- a/include/net/netns/nftables.h
> +++ b/include/net/netns/nftables.h
> @@ -7,6 +7,7 @@
>  struct netns_nftables {
>  	u8			gencursor;
>  	atomic_t		count_hw;
> +	int			max_hw;
>  };
>  
>  #endif
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 8cd55d502ffd..af0dea471119 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -620,6 +620,7 @@ enum nf_ct_sysctl_index {
>  #endif
>  #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
>  	NF_SYSCTL_CT_COUNT_HW,
> +	NF_SYSCTL_CT_MAX_HW,
>  #endif
>  
>  	__NF_SYSCTL_CT_LAST_SYSCTL,
> @@ -984,6 +985,12 @@ static struct ctl_table nf_ct_sysctl_table[] = {
>  		.mode		= 0444,
>  		.proc_handler	= proc_dointvec,
>  	},
> +	[NF_SYSCTL_CT_MAX_HW] = {
> +		.procname	= "nf_flowtable_max_hw",
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,
> +	},
>  #endif
>  	{}
>  };
> @@ -1123,6 +1130,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
>  #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
>  	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD].data = &un->offload_timeout;
>  	table[NF_SYSCTL_CT_COUNT_HW].data = &net->nft.count_hw;
> +	table[NF_SYSCTL_CT_MAX_HW].data = &net->nft.max_hw;
>  #endif
>  
>  	nf_conntrack_standalone_init_tcp_sysctl(net, table);
> @@ -1135,6 +1143,9 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
>  		table[NF_SYSCTL_CT_MAX].mode = 0444;
>  		table[NF_SYSCTL_CT_EXPECT_MAX].mode = 0444;
>  		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
> +#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
> +		table[NF_SYSCTL_CT_MAX_HW].mode = 0444;
> +#endif
>  	}
>  
>  	cnet->sysctl_header = register_net_sysctl(net, "net/netfilter", table);
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 9f2b68bc6f80..2631bd0ae9ae 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -290,6 +290,20 @@ unsigned long flow_offload_get_timeout(struct flow_offload *flow)
>  	return timeout;
>  }
>  
> +static bool flow_offload_inc_count_hw(struct nf_flowtable *flow_table)
> +{
> +	struct net *net = read_pnet(&flow_table->net);
> +	int max_hw = net->nft.max_hw, count_hw;
> +
> +	count_hw = atomic_inc_return(&net->nft.count_hw);
> +	if (max_hw && count_hw > max_hw) {
> +		atomic_dec(&net->nft.count_hw);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>  int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
>  {
>  	int err;
> @@ -315,9 +329,9 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
>  	nf_ct_offload_timeout(flow->ct);
>  
>  	if (nf_flowtable_hw_offload(flow_table)) {
> -		struct net *net = read_pnet(&flow_table->net);
> +		if (!flow_offload_inc_count_hw(flow_table))
> +			return 0;

Maybe, here something like:

                if (atomic_read(count_hw) > max_hw)
                        return 0;

to catch for early overlimit.

Then, use the logic I suggested for patch 2/8, ie. increment/decrement
this counter from the work handlers?

> -		atomic_inc(&net->nft.count_hw);
>  		__set_bit(NF_FLOW_HW, &flow->flags);
>  		nf_flow_offload_add(flow_table, flow);
>  	}
> @@ -329,6 +343,7 @@ EXPORT_SYMBOL_GPL(flow_offload_add);
>  void flow_offload_refresh(struct nf_flowtable *flow_table,
>  			  struct flow_offload *flow)
>  {
> +	struct net *net = read_pnet(&flow_table->net);
>  	u32 timeout;
>  
>  	timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
> @@ -338,6 +353,12 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
>  	if (likely(!nf_flowtable_hw_offload(flow_table)))
>  		return;
>  
> +	if (!flow_offload_inc_count_hw(flow_table))

This is packet path, better avoid this atomic operation if possible.

> +		return;
> +	/* only count each flow once when setting NF_FLOW_HW bit */
> +	if (test_and_set_bit(NF_FLOW_HW, &flow->flags))
> +		atomic_dec(&net->nft.count_hw);
> +
>  	nf_flow_offload_add(flow_table, flow);
>  }
>  EXPORT_SYMBOL_GPL(flow_offload_refresh);
> -- 
> 2.31.1
> 
