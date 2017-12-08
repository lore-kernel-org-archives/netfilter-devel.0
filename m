From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next RFC,v2 6/6] netfilter: nft_flow_offload: add ndo
 hooks for hardware offload
Date: Fri, 8 Dec 2017 11:18:36 +0100
Message-ID: <20171208101836.GH24449@breakpoint.cc>
References: <20171207124501.24325-1-pablo@netfilter.org>
 <20171207124501.24325-7-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, simon.horman@netronome.com,
        ronye@mellanox.com, jiri@mellanox.com, nbd@nbd.name,
        john@phrozen.org, kubakici@wp.pl, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50802 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751321AbdLHKUC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Dec 2017 05:20:02 -0500
Content-Disposition: inline
In-Reply-To: <20171207124501.24325-7-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> The software flow table garbage collector skips entries that resides in
> the hardware, so the hardware will be responsible for releasing this
> flow table entry too via flow_offload_dead(). In the next garbage
> collector run, this removes the entries both in the software and
> hardware flow table from user context.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> @Florian: I still owe you one here, you mentioned about inmediate schedule
> of the workqueue thread, and I need to revisit this, the quick patch I made
> is hitting splats when calling queue_delayed_work() from packet path, this
> may be my fault though.

OK. IIRC I had suggested to just use schedule_work() instead.
In most cases (assuming system is busy) the workqueue will already be
pending anyway.

> diff --git a/net/netfilter/nf_flow_table.c b/net/netfilter/nf_flow_table.c
> index ff27dad268c3..c578c3aec0e0 100644
> --- a/net/netfilter/nf_flow_table.c
> +++ b/net/netfilter/nf_flow_table.c
> @@ -212,6 +212,21 @@ int nf_flow_table_iterate(struct nf_flowtable *flow_table,
>  }
>  EXPORT_SYMBOL_GPL(nf_flow_table_iterate);
>  
> +static void flow_offload_hw_del(struct flow_offload *flow)
> +{
> +	struct net_device *indev;
> +	int ret, ifindex;
> +
> +	rtnl_lock();
> +	ifindex = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.iifidx;
> +	indev = __dev_get_by_index(&init_net, ifindex);

I think this should pass struct net * as arg to flow_offload_hw_del.

> +	if (WARN_ON(!indev))
> +		return;
> +
> +	ret = indev->netdev_ops->ndo_flow_offload(FLOW_OFFLOAD_DEL, flow);
> +	rtnl_unlock();
> +}

Please no rtnl lock unless absolutely needed.
Seems this could even avoid the mutex completely by using
dev_get_by_index + dev_put.

> +static int do_flow_offload(struct flow_offload *flow)
> +{
> +	struct net_device *indev;
> +	int ret, ifindex;
> +
> +	rtnl_lock();
> +	ifindex = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.iifidx;
> +	indev = __dev_get_by_index(&init_net, ifindex);

likewise.

> +#define FLOW_HW_WORK_TIMEOUT	msecs_to_jiffies(100)
> +
> +static struct delayed_work nft_flow_offload_dwork;

I would go with struct work and no delay at all.
