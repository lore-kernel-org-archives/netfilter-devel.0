Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC1B217701
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 15:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747841583; cv=none; b=JanWjRCtSSc0njMoXGEsxutQ16s80iLHjBxSPcDIEUOLreUWsy3D/yGpFCF9Uiqjj/2ayX1/9/xgmi0xDu6J/f95tO8Jq1xHFD73ZjvLg1qg+emYx4J4p5mp/lfrJxwUYl57SLQxymmaIxP0RgbACyW52DrZpC6tvMUnygdiL7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747841583; c=relaxed/simple;
	bh=U8pC1FYj95nU9fHIpbK9WJG0UgirhMrn1lagYOhFSrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MHDZ/qSgXI61boX0TK/KN5oBKY/HHDdYITUKII2lroHDEIplsKttDIS6iVHlApoNeT0rCiYoxTkay3HORs4aoSpBJHEYrXpL6os/CUzHpdqKHWCOm0pl9QDQztDg6f9v9mTJaxMzK+qzbLIV43KGXv6tsYf7+xNKeyR3IjOp/J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gVOS/jEP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gVOS/jEP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=n21vua7Ql02vud2JYxrnomGHHRlpL7iLtBfpfatY92U=; b=gVOS/jEPvO7J4m17XKgTgwRIvG
	G0yyU87YrNAlXtT5dnjqc9037M4SYcAPnOg2JuGq5Eui226bUtThV0gMUy1EfWJ7VmcaNC/opRdWT
	b8v2JymBIsbPOjaoIrM2NyFFxsJO/E87DiThLrLFKbktePNu5uBxTCQjgh9v7rKLRmXh137taQFgp
	pNYUOHN2rPf8vqlXbt60dGqaCrpUKFDe8J32W8YWkj6c1RgNzQx3qmbSHl7X7A+zYjEXfLbtBLfbA
	VR7kWuKd3daWPqs8kh5wluOgGuDTIBse5rkZGMT84GcOOh6zGyFU57UuF9miHevpXIdcVrtbc+fMb
	p+jUaMlQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHlRB-0000000024E-3WeT;
	Wed, 21 May 2025 17:32:57 +0200
Date: Wed, 21 May 2025 17:32:57 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v6 00/12] Dynamic hook interface binding part 2
Message-ID: <aC3yKSl3u4_zNc4b@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
References: <20250415154440.22371-1-phil@nwl.cc>
 <aC0B8ZSp8qNzbPqR@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC0B8ZSp8qNzbPqR@calendula>

Hi Pablo,

On Wed, May 21, 2025 at 12:28:01AM +0200, Pablo Neira Ayuso wrote:
> This looks very good, I still have a few comments, related to three
> patches:
> 
> == netfilter: nf_tables: Have a list of nf_hook_ops in nft_hook
> 
> 1) There's a possible inconsistent use of list_for_each_entry{_safe}
>    while calling nf_unregister_net_hook().
> 
>  static void nft_netdev_unregister_hooks(struct net *net,
>                                         struct list_head *hook_list,
>                                         bool release_netdev)
>  {
> +       struct nf_hook_ops *ops, *nextops;
>         struct nft_hook *hook, *next;
> 
>         list_for_each_entry_safe(hook, next, hook_list, list) {
> -               nf_unregister_net_hook(net, &hook->ops);
> +               list_for_each_entry_safe(ops, nextops, &hook->ops_list, list) <--- HERE
> +                       nf_unregister_net_hook(net, ops);
> 
> [...]
> 
> @@ -2923,8 +2962,10 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
>  err_hooks:
>         if (nla[NFTA_CHAIN_HOOK]) {
>                 list_for_each_entry_safe(h, next, &hook.list, list) {
> -                       if (unregister)
> -                               nf_unregister_net_hook(ctx->net, &h->ops);
> +                       if (unregister) {
> +                               list_for_each_entry(ops, &h->ops_list, list)   <--- HERE
> +                                       nf_unregister_net_hook(ctx->net, ops);
> 
> Which one should be adjusted? I think _safe can be removed?

Oh, right. Yes, the _save is pointless since no items are removed inside
the loop.

> Maybe add nf_unregister_net_hook_list() helper? It helps to avoid
> future similar issues.

ACK, will do!

> 2) I wonder if nft_hook_find_ops()  will need a hashtable sooner or
>    later. With the wildcard, the number of devices could be significantly
>    large in this list lookup.

Maybe, yes. Is it useful to have a single flowtable for all virtual
functions (e.g.) on a hypervisor? Or would one rather have distinct
flowtables for each VM/container?

> @@ -9611,9 +9666,12 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
>  struct nf_hook_ops *nft_hook_find_ops(const struct nft_hook *hook,
>                                       const struct net_device *dev)
>  {
> -       if (hook->ops.dev == dev)
> -               return (struct nf_hook_ops *)&hook->ops;
> +       struct nf_hook_ops *ops;
> 
> +       list_for_each_entry(ops, &hook->ops_list, list) {
> +               if (ops->dev == dev)
> +                       return ops;
> +       }
>         return NULL;
>  }

Callers are:

- nft_{flowtable,netdev}_event(): Interface is added or removed
- nft_flow_offload_eval(): New flow being offloaded
- nft_offload_netdev_event(): Interface is removed

All these are "slow path" at least. I could try building a test case to
see how performance scales, but since we hit the function just once for
each new connection, I guess it's hard to get significant data out of
it.

> 3) Maybe move struct rcu_head at the end of struct nf_hook_ops?
> 
>  struct nf_hook_ops {
> +       struct list_head        list;
> +       struct rcu_head         rcu; <--- move it at the end of this struct?
> 
>    This is a control plane object, but still it is common to place
>    this at the end. But not a deal breaker.

I tried to copy struct nft_hook in that regard which has the rcu_head
right after the list_heads. AIUI, both these types are "handles" to
carry the object around, having the actual payload follow them feels
more natural to me. If you prefer the "append new fields" approach, fine
with me though!

> 4) nft_netdev_event() is missing a break; I think it is an overlook?
> 
> diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
> index 783e4b5ef3e0..bac5aa8970a4 100644
> --- a/net/netfilter/nft_chain_filter.c
> +++ b/net/netfilter/nft_chain_filter.c
> @@ -332,9 +332,8 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
>                 if (!(basechain->chain.table->flags & NFT_TABLE_F_DORMANT))
>                         nf_unregister_net_hook(dev_net(dev), ops);
> 
> -               list_del_rcu(&hook->list);
> -               kfree_rcu(hook, rcu);
> -               break;    <------------------------- this is gone!
> +               list_del_rcu(&ops->list);
> +               kfree_rcu(ops, rcu);
>         }
>  }
> 
> but I can still see break; in the flowtable event handler.
> 
> So nft_netdev_event() shows no break;
> But nft_flowtable_event() still has a break;

I recall being undecided about this. A relevant difference between
netdev chains and flowtables is that a device may have multiple netdev
chain hooks but only a single flowtable one[1]. This might have confused
me, because the break above effectively means "stop searching for a
matching hook in this chain if one was found for the given interface
already". Since neither chains nor flowtables allow for overlapping
hooks (e.g. { eth1*, eth11 }), a given device matches at most a single
hook. I'll adjust the series to keep this break, then. Thanks!

> == Support wildcard netdev hook specs
> 
> Nitpick: the err_ops_alloc: tag takes me to nft_netdev_hook_free(hook);
> maybe better rename it to err_hook_free: ? Because currently
> err_ops_alloc takes me to nft_netdev_hook_free(hook);
> 
> @@ -2323,7 +2323,7 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
> 
>         err = nla_strscpy(hook->ifname, attr, IFNAMSIZ);
>         if (err < 0)
> -               goto err_hook_dev;
> +               goto err_ops_alloc;
> 
> but takes you to free the hook:
> 
> -err_hook_dev:
> -       kfree(hook);
> +err_ops_alloc:
> +       nft_netdev_hook_free(hook);

Oh yes, this is a mess. Also, the err_hook_alloc tag is pointless as it
leads to an immediate return.

> == netfilter: nf_tables: Add "notications" <-- typo: "notifications"
> 
> I suggest you add a new NFNLGRP_NFT_DEV group for these notifications,
> so NFNLGRP_NFTABLES is only used for control plane updates via
> nfnetlink API. In this case, these events are triggered by rtnetlink
> when a new device is registered and it matches the existing an
> existing device if I understood the rationale.

Yes, MSG_NEWDEV and MSG_DELDEV are triggered if a new device matches a
hook or if a hooked device is removed (or renamed, so the hook won't
match anymore).

Having a distinct NFNLGRP for them requires a new 'nft monitor' mode,
right? So we can't have a single monitor process for ruleset changes and
these device events. Should not be a problem, though.

Thanks, Phil

[1] nft_register_flowtable_net_hooks() searches for a matching hook in
    other flowtables of the same table.
