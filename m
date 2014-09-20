From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf_tables 1/3] netfilter: nf_tables: store and dump sets
 mechanism options
Date: Sat, 20 Sep 2014 13:39:19 +0200
Message-ID: <20140920113919.GA5825@acer.localdomain>
References: <1411064300-4433-1-git-send-email-arturo.borrero.glez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51305 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbaITLj2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Sep 2014 07:39:28 -0400
Content-Disposition: inline
In-Reply-To: <1411064300-4433-1-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 18, 2014 at 08:18:18PM +0200, Arturo Borrero Gonzalez wrote:
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -231,6 +231,14 @@ struct nft_set_ops {
>  int nft_register_set(struct nft_set_ops *ops);
>  void nft_unregister_set(struct nft_set_ops *ops);
>  
> +/* internal flags to know which attributes were originally set
> + * from userspace.
> + */
> +enum nft_set_attr {
> +	NFT_SET_ATTR_POLICY	= 0x1,
> +	NFT_SET_ATTR_DESC_SIZE	= 0x2,
> +};

We don't need the size, any value != 0 is set by userspace. I'm unsure
about the policy, we don't really *need* to dump if it is the default,
and otherwise its obvious that it originated from userspace.

> @@ -241,6 +249,8 @@ void nft_unregister_set(struct nft_set_ops *ops);
>   * 	@dtype: data type (verdict or numeric type defined by userspace)
>   * 	@size: maximum set size
>   * 	@nelems: number of elements
> + *	@attr_flags: (enum nft_set_flags)
> + *	@policy: (enum nft_set_policies)
>   * 	@ops: set ops
>   * 	@flags: set flags
>   * 	@klen: key length
> @@ -255,6 +265,8 @@ struct nft_set {
>  	u32				dtype;
>  	u32				size;
>  	u32				nelems;
> +	u16				attr_flags;
> +	u32				policy;

These are way to big and introduce holes in the structure.

>  	/* runtime data below here */
>  	const struct nft_set_ops	*ops ____cacheline_aligned;
>  	u16				flags;
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 8237460..d1c3f3e 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2342,13 +2342,24 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
>  			goto nla_put_failure;
>  	}
>  
> -	desc = nla_nest_start(skb, NFTA_SET_DESC);
> -	if (desc == NULL)
> -		goto nla_put_failure;
> -	if (set->size &&
> -	    nla_put_be32(skb, NFTA_SET_DESC_SIZE, htonl(set->size)))
> -		goto nla_put_failure;
> -	nla_nest_end(skb, desc);
> +	/* dump policy and desc info only if they were explicitly set */
> +	if (set->attr_flags & (1 << NFT_SET_ATTR_POLICY)) {
> +		if (nla_put_be32(skb, NFTA_SET_POLICY, htonl(set->policy)))
> +			goto nla_put_failure;
> +	}
> +
> +	if (set->attr_flags & (1 << NFT_SET_ATTR_DESC_SIZE)) {
> +		desc = nla_nest_start(skb, NFTA_SET_DESC);
> +		if (desc == NULL)
> +			goto nla_put_failure;
> +
> +		if (set->size &&
> +		    nla_put_be32(skb, NFTA_SET_DESC_SIZE, htonl(set->size))) {
> +			goto nla_put_failure;
> +		}
> +
> +		nla_nest_end(skb, desc);
> +	}

As mentioned earlier, dumping the parameters is not necessary for sets
with NFT_SET_CONSTANT as they have been determined automatically. 
