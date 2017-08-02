From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v3 3/4] Implement --echo option
Date: Wed, 2 Aug 2017 14:37:45 +0200
Message-ID: <20170802123744.GC16003@salvia>
References: <20170728115548.5171-1-phil@nwl.cc>
 <20170728115548.5171-4-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:51574 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdHBMiJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2017 08:38:09 -0400
Content-Disposition: inline
In-Reply-To: <20170728115548.5171-4-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 28, 2017 at 01:55:47PM +0200, Phil Sutter wrote:
[...]
> diff --git a/src/netlink.c b/src/netlink.c
> index f13dfd3f9a021..35b52a3344f87 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -465,11 +465,11 @@ int netlink_replace_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
>  			       const struct location *loc)
>  {
>  	struct nftnl_rule *nlr;
> -	int err;
> +	int err, flags = ctx->octx->echo ? NLM_F_ECHO : 0;
>  
>  	nlr = alloc_nftnl_rule(&rule->handle);
>  	netlink_linearize_rule(ctx, nlr, rule);
> -	err = mnl_nft_rule_batch_replace(nlr, ctx->batch, 0, ctx->seqnum);
> +	err = mnl_nft_rule_batch_replace(nlr, ctx->batch, flags, ctx->seqnum);
>  	nftnl_rule_free(nlr);
>  
>  	if (err < 0)
> @@ -2087,6 +2087,8 @@ static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
>  				printf("update table ");
>  			else
>  				printf("add table ");
> +		} else if (type == -1) {
> +			printf("table ");

Why do we need this '-1' case? Same question for other objects.

Thanks!
