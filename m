From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH 2/4] netfilter: ip6t_NPT: Use csum_partial().
Date: Fri, 15 Mar 2013 12:52:59 +0100
Message-ID: <20130315115259.GA9550@localhost>
References: <51042240.1020606@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, jm@dilly.me, fw@strlen.de
To: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35101 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab3COLxG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Mar 2013 07:53:06 -0400
Content-Disposition: inline
In-Reply-To: <51042240.1020606@linux-ipv6.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have applied a port to current of this patch. At the time it was
posted, the merge window was closed IIRC.

Thanks.

On Sun, Jan 27, 2013 at 03:36:48AM +0900, YOSHIFUJI Hideaki wrote:
> Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
> ---
>  net/ipv6/netfilter/ip6t_NPT.c |   11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/net/ipv6/netfilter/ip6t_NPT.c b/net/ipv6/netfilter/ip6t_NPT.c
> index 3ff281b..b1bf3ed 100644
> --- a/net/ipv6/netfilter/ip6t_NPT.c
> +++ b/net/ipv6/netfilter/ip6t_NPT.c
> @@ -17,18 +17,13 @@
>  static int ip6t_npt_checkentry(const struct xt_tgchk_param *par)
>  {
>  	struct ip6t_npt_tginfo *npt = par->targinfo;
> -	__wsum src_sum = 0, dst_sum = 0;
> -	unsigned int i;
> +	__wsum src_sum, dst_sum;
>  
>  	if (npt->src_pfx_len > 64 || npt->dst_pfx_len > 64)
>  		return -EINVAL;
>  
> -	for (i = 0; i < ARRAY_SIZE(npt->src_pfx.in6.s6_addr16); i++) {
> -		src_sum = csum_add(src_sum,
> -				(__force __wsum)npt->src_pfx.in6.s6_addr16[i]);
> -		dst_sum = csum_add(dst_sum,
> -				(__force __wsum)npt->dst_pfx.in6.s6_addr16[i]);
> -	}
> +	src_sum = csum_partial(&npt->src_pfx.in6, sizeof(npt->src_pfx.in6), 0);
> +	dst_sum = csum_partial(&npt->dst_pfx.in6, sizeof(npt->dst_pfx.in6), 0);
>  
>  	npt->adjustment = csum_fold(csum_sub(src_sum, dst_sum));
>  	return 0;
> -- 
> 1.7.9.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
