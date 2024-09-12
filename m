Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234771AE053
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 14:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726152046; cv=none; b=OxgN3BYKus97LUmk4kTmVfXe5DFtZbCJBgYTkvWMqaIFN5Lp5Qub63FUEDW5WSGJWvX0sUmKI7k67nw8hPKzvCvcLz8qki0AFZOlMkgSWaeSr5plIZ6VaeVGNoi6u6OPQa4obLWGOUn7Dnje0HiLDw5goo0aRxg8ai4gWO4zAEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726152046; c=relaxed/simple;
	bh=6hzdGSuaOh8yNCezKSKHv/4+CrYseex+pVdAI4U6PJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k55VrIT5doayp+cu0NWIMAbR1DEgnc+dUPD9iGhC9iKnq2BVn5a1+FtPS4IT/9j+ZxFijN8gU3spq17LiMAo0auOyPx03vcQqaj2fBu+EhOo19S1edB8RzoNeOARBAAg3lvjPJUvNKPxdiSRAex87+yv3l+V/SJ+WlrMnKrXDhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sokzx-0002Lp-53; Thu, 12 Sep 2024 16:40:41 +0200
Date: Thu, 12 Sep 2024 16:40:41 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 11/16] netfilter: nf_tables: chain: Respect
 NETDEV_REGISTER events
Message-ID: <20240912144041.GE2892@breakpoint.cc>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-12-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240912122148.12159-12-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> Hook into new devices if their name matches the hook spec.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  net/netfilter/nft_chain_filter.c | 40 +++++++++++++++++++++++++-------
>  1 file changed, 32 insertions(+), 8 deletions(-)
> 
> diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
> index 2507e3beac5c..ec44c27a9d91 100644
> --- a/net/netfilter/nft_chain_filter.c
> +++ b/net/netfilter/nft_chain_filter.c
> @@ -326,14 +326,37 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
>  	struct nft_hook *hook;
>  
>  	list_for_each_entry(hook, &basechain->hook_list, list) {
> -		ops = nft_hook_find_ops(hook, dev);
> -		if (!ops)
> -			continue;
> +		switch (event) {
> +		case NETDEV_UNREGISTER:
> +			ops = nft_hook_find_ops(hook, dev);
> +			if (!ops)
> +				continue;
>  
> -		if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT))
> -			nf_unregister_net_hook(ctx->net, ops);
> -		list_del(&ops->list);
> -		kfree(ops);
> +			if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT))
> +				nf_unregister_net_hook(ctx->net, ops);
> +			list_del(&ops->list);
> +			kfree(ops);

This needs to use kfree_rcu() + list_del_rcu, nf_unregister_net_hook
only stops new packets from executing for dev, it doesn't stop new
packets.

Or is this guaranteed by UNREGISTER event already?
If so, please add a comment.

> +			break;
> +		case NETDEV_REGISTER:
> +			if (strcmp(hook->ifname, dev->name))
> +				continue;
> +			ops = kzalloc(sizeof(struct nf_hook_ops),
> +				      GFP_KERNEL_ACCOUNT);

ops = kmemdup(&basechain->ops, .. ?

> +			if (ops) {
> +				memcpy(ops, &basechain->ops, sizeof(*ops));
> +				ops->dev = dev;
> +			}
> +			if (ops &&
> +			    (ctx->chain->table->flags & NFT_TABLE_F_DORMANT ||
> +			     !nf_register_net_hook(dev_net(dev), ops))) {
> +				list_add_tail(&ops->list, &hook->ops_list);
> +				break;
> +			}
> +			printk(KERN_ERR "chain %s: Can't hook into device %s\n",
> +			       ctx->chain->name, dev->name);

I think its better to -ENOMEM and veto the netdevice register request in this case.

I also think this needs extra handling for NETDEV_CHANGENAME rather than
the 'treat as UNREG+REG' trick.

Else we may unregister and then fail to re-register which leaves the
device without the registered hook op.
