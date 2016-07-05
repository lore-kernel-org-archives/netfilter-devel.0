From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH] netfilter: physdev: physdev-is-out should not work with
 OUTPUT chain
Date: Tue, 5 Jul 2016 18:00:12 -0300
Message-ID: <20160705210012.GA9599@localhost.localdomain>
References: <1467723336-27953-1-git-send-email-liuhangbin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Hangbin Liu <liuhangbin@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbcGEVAQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2016 17:00:16 -0400
Content-Disposition: inline
In-Reply-To: <1467723336-27953-1-git-send-email-liuhangbin@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 05, 2016 at 08:55:36PM +0800, Hangbin Liu wrote:
> physdev_mt() will check skb->nf_bridge first, which was alloced in
> br_nf_pre_routing. So if we want to use --physdev-out and physdev-is-out,
> we need to match it in FORWARD or POSTROUTING chain. physdev_mt_check()
> only checked physdev-out and missed physdev-is-out. Fix it and update the
> debug message to make it clearer.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Reviewed-by: Marcelo R Leitner <marcelo.leitner@gmail.com>

> ---
>  net/netfilter/xt_physdev.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
> index 1caaccb..e5f1898 100644
> --- a/net/netfilter/xt_physdev.c
> +++ b/net/netfilter/xt_physdev.c
> @@ -102,14 +102,14 @@ static int physdev_mt_check(const struct xt_mtchk_param *par)
>  	if (!(info->bitmask & XT_PHYSDEV_OP_MASK) ||
>  	    info->bitmask & ~XT_PHYSDEV_OP_MASK)
>  		return -EINVAL;
> -	if (info->bitmask & XT_PHYSDEV_OP_OUT &&
> +	if (info->bitmask & (XT_PHYSDEV_OP_OUT | XT_PHYSDEV_OP_ISOUT) &&
>  	    (!(info->bitmask & XT_PHYSDEV_OP_BRIDGED) ||
>  	     info->invert & XT_PHYSDEV_OP_BRIDGED) &&
>  	    par->hook_mask & ((1 << NF_INET_LOCAL_OUT) |
>  	    (1 << NF_INET_FORWARD) | (1 << NF_INET_POST_ROUTING))) {
> -		pr_info("using --physdev-out in the OUTPUT, FORWARD and "
> -			"POSTROUTING chains for non-bridged traffic is not "
> -			"supported anymore.\n");
> +		pr_info("using --physdev-out and --physdev-is-out are only"
> +			"supported in the FORWARD and POSTROUTING chains with"
> +			"bridged traffic.\n");
>  		if (par->hook_mask & (1 << NF_INET_LOCAL_OUT))
>  			return -EINVAL;
>  	}
> -- 
> 2.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
