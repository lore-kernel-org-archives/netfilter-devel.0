Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF68C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Feb 2022 11:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiBILw0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Feb 2022 06:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiBILwZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Feb 2022 06:52:25 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 916ACE18DD69
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Feb 2022 02:43:16 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6E6DB601B3;
        Wed,  9 Feb 2022 11:43:05 +0100 (CET)
Date:   Wed, 9 Feb 2022 11:43:13 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: ctnetlink: use dump structure instead
 of raw args
Message-ID: <YgOawS6I8ldRk72Z@salvia>
References: <20220204121145.3471-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220204121145.3471-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 04, 2022 at 01:11:45PM +0100, Florian Westphal wrote:
> netlink_dump structure has a union of 'long args[6]' and a context
> buffer as scratch space.
> 
> Convert ctnetlink to use a structure, its easier to read than the
> raw 'args' usage which comes with no type checks and no readable names.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_conntrack_netlink.c | 36 ++++++++++++++++++----------
>  1 file changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index ac438370f94a..3d9f9ee50294 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -58,6 +58,12 @@
>  
>  MODULE_LICENSE("GPL");
>  
> +struct ctnetlink_list_dump_ctx {
> +	struct nf_conn *last;
> +	unsigned int cpu;
> +	bool done;
> +};
> +
>  static int ctnetlink_dump_tuples_proto(struct sk_buff *skb,
>  				const struct nf_conntrack_tuple *tuple,
>  				const struct nf_conntrack_l4proto *l4proto)
> @@ -1694,14 +1700,18 @@ static int ctnetlink_get_conntrack(struct sk_buff *skb,
>  
>  static int ctnetlink_done_list(struct netlink_callback *cb)
>  {
> -	if (cb->args[1])
> -		nf_ct_put((struct nf_conn *)cb->args[1]);
> +	struct ctnetlink_list_dump_ctx *ctx = (void *)cb->ctx;

Where is cb->ctx initialized?

> +	if (ctx->last)
> +		nf_ct_put(ctx->last);
> +
>  	return 0;
>  }
>  
>  static int
>  ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying)
>  {
> +	struct ctnetlink_list_dump_ctx *ctx = (void *)cb->ctx;
>  	struct nf_conn *ct, *last;
>  	struct nf_conntrack_tuple_hash *h;
>  	struct hlist_nulls_node *n;
> @@ -1712,12 +1722,12 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
>  	struct hlist_nulls_head *list;
>  	struct net *net = sock_net(skb->sk);
>  
> -	if (cb->args[2])
> +	if (ctx->done)
>  		return 0;
>  
> -	last = (struct nf_conn *)cb->args[1];
> +	last = ctx->last;
>  
> -	for (cpu = cb->args[0]; cpu < nr_cpu_ids; cpu++) {
> +	for (cpu = ctx->cpu; cpu < nr_cpu_ids; cpu++) {
>  		struct ct_pcpu *pcpu;
>  
>  		if (!cpu_possible(cpu))
> @@ -1731,10 +1741,10 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
>  			ct = nf_ct_tuplehash_to_ctrack(h);
>  			if (l3proto && nf_ct_l3num(ct) != l3proto)
>  				continue;
> -			if (cb->args[1]) {
> +			if (ctx->last) {
>  				if (ct != last)
>  					continue;
> -				cb->args[1] = 0;
> +				ctx->last = NULL;
>  			}
>  
>  			/* We can't dump extension info for the unconfirmed
> @@ -1751,19 +1761,19 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
>  			if (res < 0) {
>  				if (!refcount_inc_not_zero(&ct->ct_general.use))
>  					continue;
> -				cb->args[0] = cpu;
> -				cb->args[1] = (unsigned long)ct;
> +				ctx->cpu = cpu;
> +				ctx->last = ct;
>  				spin_unlock_bh(&pcpu->lock);
>  				goto out;
>  			}
>  		}
> -		if (cb->args[1]) {
> -			cb->args[1] = 0;
> +		if (ctx->last) {
> +			ctx->last = NULL;
>  			goto restart;
>  		}
>  		spin_unlock_bh(&pcpu->lock);
>  	}
> -	cb->args[2] = 1;
> +	ctx->done = true;
>  out:
>  	if (last)
>  		nf_ct_put(last);
> @@ -3877,6 +3887,8 @@ static int __init ctnetlink_init(void)
>  {
>  	int ret;
>  
> +	BUILD_BUG_ON(sizeof(struct ctnetlink_list_dump_ctx) > sizeof_field(struct netlink_callback, ctx));
> +
>  	ret = nfnetlink_subsys_register(&ctnl_subsys);
>  	if (ret < 0) {
>  		pr_err("ctnetlink_init: cannot register with nfnetlink.\n");
> -- 
> 2.34.1
> 
