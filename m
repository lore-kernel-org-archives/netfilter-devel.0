From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables - PATCH] nft: A non valid if index should not
 be handled
Date: Fri, 19 Jul 2013 14:41:53 +0200
Message-ID: <20130719124153.GA30763@localhost>
References: <1374236914-14401-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47357 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab3GSMl6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:41:58 -0400
Content-Disposition: inline
In-Reply-To: <1374236914-14401-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Tomasz,

On Fri, Jul 19, 2013 at 03:28:34PM +0300, Tomasz Bursztyka wrote:
> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
> ---
>  iptables/nft-shared.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
> index c0ee4c8..5762952 100644
> --- a/iptables/nft-shared.c
> +++ b/iptables/nft-shared.c
> @@ -226,18 +226,16 @@ void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
>  		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
>  			*invflags |= IPT_INV_VIA_IN;
>  
> -		if_indextoname(value, iniface);
> -
> -		memset(iniface_mask, 0xff, strlen(iniface)+1);
> +		if (if_indextoname(value, iniface) != NULL)
> +			memset(iniface_mask, 0xff, strlen(iniface)+1);

We have to convert iptables-nftables to use NFT_META_IIFNAME instead
of NFT_META_IIF to make it behave like iptables. This was somewhere in
my list of pending things.

Would you have a look at that?

Thanks.

>  		break;
>  	case NFT_META_OIF:
>  		value = nft_rule_expr_get_u32(e, NFT_EXPR_CMP_DATA);
>  		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
>  			*invflags |= IPT_INV_VIA_OUT;
>  
> -		if_indextoname(value, outiface);
> -
> -		memset(outiface_mask, 0xff, strlen(outiface)+1);
> +		if (if_indextoname(value, outiface) != NULL)
> +			memset(outiface_mask, 0xff, strlen(outiface)+1);
>  		break;
>  	case NFT_META_IIFNAME:
>  		ifname = nft_rule_expr_get(e, NFT_EXPR_CMP_DATA, &len);
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
