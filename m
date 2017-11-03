From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC,WIP 5/5] netfilter: nft_flow_offload: add ndo hooks
 for hardware offload
Date: Fri, 3 Nov 2017 21:56:10 +0100
Message-ID: <20171103205610.GA31088@breakpoint.cc>
References: <20171103152636.9967-1-pablo@netfilter.org>
 <20171103152636.9967-6-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37742 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750772AbdKCU4j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2017 16:56:39 -0400
Content-Disposition: inline
In-Reply-To: <20171103152636.9967-6-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> +static void flow_offload_work(struct work_struct *work)
> +{
> +	struct flow_hw_offload *offload, *next;
> +
> +	spin_lock_bh(&flow_hw_offload_lock);
> +	list_for_each_entry_safe(offload, next, &flow_hw_offload_pending_list, list) {
> +		do_flow_offload(offload->flow);

This should not offload flows that already have DYING bit set.

> +		nf_conntrack_put(&offload->ct->ct_general);
> +		list_del(&offload->list);
> +		kfree(offload);
> +	}
> +	spin_unlock_bh(&flow_hw_offload_lock);
> +
> +	queue_delayed_work(system_power_efficient_wq, &nft_flow_offload_dwork, HZ);
> +}

Missed this on first round, 1 second is quite large.

[..]

>  static int nft_flow_route(const struct nft_pktinfo *pkt,
>  			  const struct nf_conn *ct,
>  			  union flow_gateway *orig_gw,
> @@ -211,6 +290,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>  	union flow_gateway orig_gateway, reply_gateway;
>  	struct net_device *outdev = pkt->xt.state->out;
>  	struct net_device *indev = pkt->xt.state->in;
> +	struct flow_hw_offload *offload;
>  	enum ip_conntrack_info ctinfo;
>  	struct flow_offload *flow;
>  	struct nf_conn *ct;
> @@ -250,6 +330,21 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>  	if (ret < 0)
>  		goto err2;
>  
> +	if (!indev->netdev_ops->ndo_flow_add)
> +		return;
> +
> +	offload = kmalloc(sizeof(struct flow_hw_offload), GFP_ATOMIC);
> +	if (!offload)
> +		return;
> +
> +	nf_conntrack_get(&ct->ct_general);
> +	offload->ct = ct;
> +	offload->flow = flow;
> +
> +	spin_lock_bh(&flow_hw_offload_lock);
> +	list_add_tail(&offload->list, &flow_hw_offload_pending_list);
> +	spin_unlock_bh(&flow_hw_offload_lock);
> +
>  	return;

So this aims for lazy offloading (up to 1 second delay).
Is this intentional, e.g. to avoid offloading short-lived 'RR' flows?

I would have expected this to schedule the workqueue here, and not use
delayed wq at all (i.e., also no self-rescheduling from
flow_offload_work()).
