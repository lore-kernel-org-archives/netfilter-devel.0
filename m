From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next] netfilter: ip6t_REJECT: check for IP6T_F_PROTO
Date: Sat, 21 Mar 2015 19:38:58 +0000
Message-ID: <20150321193857.GC16593@acer.localdomain>
References: <1426966210-13583-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47835 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbbCUTjC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Mar 2015 15:39:02 -0400
Content-Disposition: inline
In-Reply-To: <1426966210-13583-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21.03, Pablo Neira Ayuso wrote:
> Make sure IP6T_F_PROTO is set to enforce layer 4 protocol matching from
> the ip6_tables core.
> 
> Suggested-by: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Looks good, thanks!

> ---
>  net/ipv6/netfilter/ip6t_REJECT.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
> index 544b0a9..12331ef 100644
> --- a/net/ipv6/netfilter/ip6t_REJECT.c
> +++ b/net/ipv6/netfilter/ip6t_REJECT.c
> @@ -83,7 +83,8 @@ static int reject_tg6_check(const struct xt_tgchk_param *par)
>  		return -EINVAL;
>  	} else if (rejinfo->with == IP6T_TCP_RESET) {
>  		/* Must specify that it's a TCP packet */
> -		if (e->ipv6.proto != IPPROTO_TCP ||
> +		if (!(e->ipv6.flags & IP6T_F_PROTO) ||
> +		    e->ipv6.proto != IPPROTO_TCP ||
>  		    (e->ipv6.invflags & XT_INV_PROTO)) {
>  			pr_info("TCP_RESET illegal for non-tcp\n");
>  			return -EINVAL;
> -- 
> 1.7.10.4
> 
