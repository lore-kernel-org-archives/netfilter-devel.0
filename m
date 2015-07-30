From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: ip6t_REJECT: Log reject reason in
 reject_tg6()
Date: Thu, 30 Jul 2015 13:59:07 +0200
Message-ID: <20150730115907.GA7104@salvia>
References: <283e896df54b88cc7446fc2cde7a5df3.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: subashab@codeaurora.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54976 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbbG3LxT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jul 2015 07:53:19 -0400
Content-Disposition: inline
In-Reply-To: <283e896df54b88cc7446fc2cde7a5df3.squirrel@www.codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 30, 2015 at 02:34:13AM -0000, subashab@codeaurora.org wrote:
> The existing message is not very useful, so add the reject reason
> to help in debug.
> 
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> ---
>  net/ipv6/netfilter/ip6t_REJECT.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/netfilter/ip6t_REJECT.c
> b/net/ipv6/netfilter/ip6t_REJECT.c
> index 544b0a9..f956513 100644
> --- a/net/ipv6/netfilter/ip6t_REJECT.c
> +++ b/net/ipv6/netfilter/ip6t_REJECT.c
> @@ -42,7 +42,7 @@ reject_tg6(struct sk_buff *skb, const struct
> xt_action_param *par)
>  	const struct ip6t_reject_info *reject = par->targinfo;
>  	struct net *net = dev_net((par->in != NULL) ? par->in : par->out);
> 
> -	pr_debug("%s: medium point\n", __func__);
> +	pr_debug("%s: case %u\n", __func__, reject->with);

I'd suggest you send a patch to remove this debug message to get this
in sync with the IPv4 version of the REJECT target.

Thanks.
