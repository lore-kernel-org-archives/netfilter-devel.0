From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf] netfilter: nft_compat: set IP6T_F_PROTO flag if
 protocol is set
Date: Sat, 21 Mar 2015 18:45:09 +0000
Message-ID: <20150321184509.GB16593@acer.localdomain>
References: <1426963018-6838-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47561 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbbCUSpO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Mar 2015 14:45:14 -0400
Content-Disposition: inline
In-Reply-To: <1426963018-6838-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21.03, Pablo Neira Ayuso wrote:
> ip6tables extensions check for this flag to restrict match/target to a
> given protocol. Without this flag set, SYNPROXY6 returns an error.

That looks like the correct solution to me, thanks!

I guess we should also fix all the ip6_tables extensions that think
they're matching on the L4 protocol but are actually not enforcing
this.

> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nft_compat.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
> index 213584c..65f3e2b 100644
> --- a/net/netfilter/nft_compat.c
> +++ b/net/netfilter/nft_compat.c
> @@ -133,6 +133,9 @@ nft_target_set_tgchk_param(struct xt_tgchk_param *par,
>  		entry->e4.ip.invflags = inv ? IPT_INV_PROTO : 0;
>  		break;
>  	case AF_INET6:
> +		if (proto)
> +			entry->e6.ipv6.flags |= IP6T_F_PROTO;
> +
>  		entry->e6.ipv6.proto = proto;
>  		entry->e6.ipv6.invflags = inv ? IP6T_INV_PROTO : 0;
>  		break;
> @@ -344,6 +347,9 @@ nft_match_set_mtchk_param(struct xt_mtchk_param *par, const struct nft_ctx *ctx,
>  		entry->e4.ip.invflags = inv ? IPT_INV_PROTO : 0;
>  		break;
>  	case AF_INET6:
> +		if (proto)
> +			entry->e6.ipv6.flags |= IP6T_F_PROTO;
> +
>  		entry->e6.ipv6.proto = proto;
>  		entry->e6.ipv6.invflags = inv ? IP6T_INV_PROTO : 0;
>  		break;
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
