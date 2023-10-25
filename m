Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 311DEC25B6B
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 21:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjJYVAS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 17:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjJYVAR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 17:00:17 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D387412A
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2023 14:00:15 -0700 (PDT)
Received: from [78.30.35.151] (port=48338 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qvkz6-00Fr3D-4t; Wed, 25 Oct 2023 23:00:14 +0200
Date:   Wed, 25 Oct 2023 23:00:11 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v3 3/3] netfilter: nf_tables: Add locking for
 NFT_MSG_GETOBJ_RESET requests
Message-ID: <ZTmB2yBSAa1KVexW@calendula>
References: <20231025200828.5482-1-phil@nwl.cc>
 <20231025200828.5482-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231025200828.5482-4-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 25, 2023 at 10:08:28PM +0200, Phil Sutter wrote:
> Objects' dump callbacks are not concurrency-safe per-se with reset bit
> set. If two CPUs perform a reset at the same time, at least counter and
> quota objects suffer from value underrun.
> 
> Prevent this by introducing dedicated locking callbacks for nfnetlink
> and the asynchronous dump handling to serialize access.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  net/netfilter/nf_tables_api.c | 72 ++++++++++++++++++++++++++++-------
>  1 file changed, 59 insertions(+), 13 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 5f84bdd40c3f..245a2c5be082 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
[...]
> @@ -7832,16 +7876,18 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
>  		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
>  	}
>  
> -	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
> -		reset = true;
> +	if (!try_module_get(THIS_MODULE))
> +		return -EINVAL;

For netlink dump path, __netlink_dump_start() already grabs a
reference module this via c->module.

Why is this module reference needed for getting one object? This does
not follow netlink dump path, it creates the skb and it returns
inmediately.

> +	rcu_read_unlock();
> +	mutex_lock(&nft_net->commit_mutex);
> +	skb2 = nf_tables_getobj_single(portid, info, nla, true);
> +	mutex_unlock(&nft_net->commit_mutex);
> +	rcu_read_lock();
> +	module_put(THIS_MODULE);
>  
> -	skb2 = nf_tables_getobj_single(portid, info, nla, reset);
>  	if (IS_ERR(skb2))
>  		return PTR_ERR(skb2);
>  
> -	if (!reset)
> -		return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);

This is what gets added in 1/3 that goes away, I see.

> -
>  	buf = kasprintf(GFP_ATOMIC, "%.*s:%u",
>  			nla_len(nla[NFTA_OBJ_TABLE]),
>  			(char *)nla_data(nla[NFTA_OBJ_TABLE]),
> @@ -9128,7 +9174,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
>  		.policy		= nft_obj_policy,
>  	},
>  	[NFT_MSG_GETOBJ_RESET] = {
> -		.call		= nf_tables_getobj,
> +		.call		= nf_tables_getobj_reset,
>  		.type		= NFNL_CB_RCU,
>  		.attr_count	= NFTA_OBJ_MAX,
>  		.policy		= nft_obj_policy,
> -- 
> 2.41.0
> 
