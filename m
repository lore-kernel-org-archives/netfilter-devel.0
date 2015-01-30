From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/9] nftables: reject NFT_SET_ELEM_INTERVAL_END flag for
 non-interval sets
Date: Fri, 30 Jan 2015 18:31:07 +0100
Message-ID: <20150130173107.GA9243@salvia>
References: <1422603994-5836-1-git-send-email-kaber@trash.net>
 <1422603994-5836-3-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, tgraf@suug.ch, davem@davemloft.net,
	David.Laight@ACULAB.COM, ying.xue@windriver.com,
	paulmck@linux.vnet.ibm.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60249 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbbA3R2H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Jan 2015 12:28:07 -0500
Content-Disposition: inline
In-Reply-To: <1422603994-5836-3-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

Unless you have any concern, I'm going to apply this and 8/9 to
nf-next, so you don't need to resend these two sanitization fixes.

Thanks.

On Fri, Jan 30, 2015 at 07:46:27AM +0000, Patrick McHardy wrote:
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> ---
>  net/netfilter/nf_tables_api.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 129a8da..92ba4a0 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -3112,6 +3112,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>  		elem.flags = ntohl(nla_get_be32(nla[NFTA_SET_ELEM_FLAGS]));
>  		if (elem.flags & ~NFT_SET_ELEM_INTERVAL_END)
>  			return -EINVAL;
> +		if (!(set->flags & NFT_SET_INTERVAL) &&
> +		    elem.flags & NFT_SET_ELEM_INTERVAL_END)
> +			return -EINVAL;
>  	}
>  
>  	if (set->flags & NFT_SET_MAP) {
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
