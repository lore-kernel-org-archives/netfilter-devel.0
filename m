Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49477C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Mar 2022 22:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243229AbiCGWoD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Mar 2022 17:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343834AbiCGWoD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Mar 2022 17:44:03 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDE1136158
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2022 14:43:07 -0800 (PST)
Received: from netfilter.org (unknown [87.190.248.243])
        by mail.netfilter.org (Postfix) with ESMTPSA id 88474601DB;
        Mon,  7 Mar 2022 23:41:16 +0100 (CET)
Date:   Mon, 7 Mar 2022 23:43:03 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
        fw@strlen.de, ozsh@nvidia.com, paulb@nvidia.com
Subject: Re: [PATCH net-next 5/8] netfilter: introduce max count of hw
 offload 'add' workqueue tasks
Message-ID: <YiaKdytbtq5Nt6gg@salvia>
References: <20220222151003.2136934-1-vladbu@nvidia.com>
 <20220222151003.2136934-6-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220222151003.2136934-6-vladbu@nvidia.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 22, 2022 at 05:10:00PM +0200, Vlad Buslov wrote:
> To improve hardware offload debuggability extend struct netns_nftables with
> 'max_wq_add' counter and expose it to userspace as
> 'nf_flowtable_max_wq_add' sysctl entry. Verify that count_wq_add value is
> less than max_wq_add and don't schedule new flow table entry 'add' task to
> workqueue, if this is not the case.

For this toggle, I'm not sure what value I would select, this maximum
number of in-flight work objects might be a difficult guess for users.
This is disabled by default, but what reasonable limit could be set?

Moreover, there is also tc-police and ratelimit that could be combined
from the ruleset to throttle the number of entries that are created to
the flowtable, ie. packet is accepted but the tc ct action is skipped.
I agree this would not specifically restrict the number of in-flight
pending work though since this depends on how fast the worker empties
the queue.

My understanding is that the goal for this toggle is to tackle a
scenario where the network creates a pattern to create high load on
the workqueue (e.g. lots of small flows per second). In that case, it
is likely safer to use add an explicit ratelimit to skip the tc ct
action in case of stress, and probably easier to infer?

> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> ---
>  include/net/netns/nftables.h            | 1 +
>  net/netfilter/nf_conntrack_standalone.c | 9 +++++++++
>  net/netfilter/nf_flow_table_offload.c   | 9 ++++++++-
>  3 files changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
> index a971d986a75b..ce270803ef27 100644
> --- a/include/net/netns/nftables.h
> +++ b/include/net/netns/nftables.h
> @@ -9,6 +9,7 @@ struct netns_nftables {
>  	atomic_t		count_hw;
>  	int			max_hw;
>  	atomic_t		count_wq_add;
> +	int			max_wq_add;
>  };
>
>  #endif
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index fe2327823f7a..26e2b86eb060 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -622,6 +622,7 @@ enum nf_ct_sysctl_index {
>  	NF_SYSCTL_CT_COUNT_HW,
>  	NF_SYSCTL_CT_MAX_HW,
>  	NF_SYSCTL_CT_COUNT_WQ_ADD,
> +	NF_SYSCTL_CT_MAX_WQ_ADD,
>  #endif
>
>  	__NF_SYSCTL_CT_LAST_SYSCTL,
> @@ -998,6 +999,12 @@ static struct ctl_table nf_ct_sysctl_table[] = {
>  		.mode		= 0444,
>  		.proc_handler	= proc_dointvec,
>  	},
> +	[NF_SYSCTL_CT_MAX_WQ_ADD] = {
> +		.procname	= "nf_flowtable_max_wq_add",
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,
> +	},
>  #endif
>  	{}
>  };
> @@ -1139,6 +1146,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
>  	table[NF_SYSCTL_CT_COUNT_HW].data = &net->nft.count_hw;
>  	table[NF_SYSCTL_CT_MAX_HW].data = &net->nft.max_hw;
>  	table[NF_SYSCTL_CT_COUNT_WQ_ADD].data = &net->nft.count_wq_add;
> +	table[NF_SYSCTL_CT_MAX_WQ_ADD].data = &net->nft.max_wq_add;
>  #endif
>
>  	nf_conntrack_standalone_init_tcp_sysctl(net, table);
> @@ -1153,6 +1161,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
>  		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
>  #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
>  		table[NF_SYSCTL_CT_MAX_HW].mode = 0444;
> +		table[NF_SYSCTL_CT_MAX_WQ_ADD].mode = 0444;
>  #endif
>  	}
>
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index ffbcf0cfefeb..e29aa51696f5 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -1016,9 +1016,16 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
>  			 struct flow_offload *flow)
>  {
>  	struct net *net = read_pnet(&flowtable->net);
> +	int max_wq_add = net->nft.max_wq_add;
>  	struct flow_offload_work *offload;
> +	int count_wq_add;
> +
> +	count_wq_add = atomic_inc_return(&net->nft.count_wq_add);
> +	if (max_wq_add && count_wq_add > max_wq_add) {
> +		atomic_dec(&net->nft.count_wq_add);
> +		return;
> +	}
>
> -	atomic_inc(&net->nft.count_wq_add);
>  	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLACE);
>  	if (!offload) {
>  		atomic_dec(&net->nft.count_wq_add);
> --
> 2.31.1
>
