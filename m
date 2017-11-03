From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC,WIP 2/5] netfilter: add software flow offload
 infrastructure
Date: Fri, 3 Nov 2017 21:32:49 +0100
Message-ID: <20171103203249.GA25602@breakpoint.cc>
References: <20171103152636.9967-1-pablo@netfilter.org>
 <20171103152636.9967-3-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37708 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750772AbdKCUdS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2017 16:33:18 -0400
Content-Disposition: inline
In-Reply-To: <20171103152636.9967-3-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> +static int __init nf_flow_offload_module_init(void)
> +{
> +	struct rhashtable_params params = flow_offload_rhash_params;
> +	struct nf_hook_ops flow_offload_hook = {
> +		.hook		= nf_flow_offload_hook,
> +		.pf		= NFPROTO_NETDEV,
> +		.hooknum	= NF_NETDEV_INGRESS,
> +		.priority	= -100,

Magic number.  Should this be documented in nft?

Alternatively we could reject NETDEV_INGRESS base chains from
userspace if prio < 0 to prevent userspace rules from messing
with this flow offlaod infrastructure.

I guess the rationale of using auto-builtin hook is to avoid
forcing users to configure this with nftables rules?

> +	rtnl_lock();
> +	for_each_netdev(&init_net, dev) {
> +		entry = kmalloc(sizeof(*entry), GFP_KERNEL);
> +		if (!entry) {
> +			rtnl_unlock();
> +			return -ENOMEM;

This would need error unwinding (Unregistering the already-registered
hooks).

> +		err = nf_register_net_hook(&init_net, &entry->ops);
> +		if (err < 0)
> +			return err;

And here as well.
