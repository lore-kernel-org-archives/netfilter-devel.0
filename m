From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: xt_nfacct: Use not operation instead
 of condition check
Date: Mon, 26 Sep 2016 17:17:56 +0200
Message-ID: <20160926151756.GA17426@breakpoint.cc>
References: <1474899184-30187-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49300 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S941489AbcIZPSJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Sep 2016 11:18:09 -0400
Content-Disposition: inline
In-Reply-To: <1474899184-30187-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

fgao@ikuai8.com <fgao@ikuai8.com> wrote:
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
> index cf32759..7abb5b5 100644
> --- a/net/netfilter/xt_nfacct.c
> +++ b/net/netfilter/xt_nfacct.c
> @@ -28,7 +28,7 @@ static bool nfacct_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  
>  	overquota = nfnl_acct_overquota(par->net, skb, info->nfacct);
>  
> -	return overquota == NFACCT_UNDERQUOTA ? false : true;
> +	return !(overquota == NFACCT_UNDERQUOTA);

I don't find one better than the other.  If you need to change
it for some reason consider

"return overquota != NFACCT_UNDERQUOTA"

instead of this strange negation.

But really, I think its fine as-is.
