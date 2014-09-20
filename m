From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft 3/3] src: add set optimization options
Date: Sat, 20 Sep 2014 13:45:05 +0200
Message-ID: <20140920114505.GB5825@acer.localdomain>
References: <1411064300-4433-1-git-send-email-arturo.borrero.glez@gmail.com>
 <1411064300-4433-3-git-send-email-arturo.borrero.glez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51345 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbaITLpH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Sep 2014 07:45:07 -0400
Content-Disposition: inline
In-Reply-To: <1411064300-4433-3-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 18, 2014 at 08:18:20PM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds options to choose set optimization mechanisms.
> 
> Two new statements are added to the set syntax, and they can be mixed:
> 
>  nft add set filter set1 { type ipv4_addr ; size 1024 ; }
>  nft add set filter set1 { type ipv4_addr ; policy memory ; }
>  nft add set filter set1 { type ipv4_addr ; policy performance ; }
>  nft add set filter set1 { type ipv4_addr ; policy memory ; size 1024 ; }
>  nft add set filter set1 { type ipv4_addr ; size 1024 ; policy memory ; }
>  nft add set filter set1 { type ipv4_addr ; policy performance ; size 1024 ; }
>  nft add set filter set1 { type ipv4_addr ; size 1024 ; policy performance ; }
> 
> Also valid for maps:
> 
>  nft add map filter map1 { type ipv4_addr : verdict ; policy performace ; }
>  [...]

I'd suggest to also add a global option which is the default unless
overridden by a specific set instantiation. Doesn't have to be done
in this patch however.

> @@ -1103,6 +1114,14 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
>  	}
>  	set->handle.set_id = ++set_id;
>  	nft_set_attr_set_u32(nls, NFT_SET_ATTR_ID, set->handle.set_id);
> +
> +	if (set->attr_flags & (1 << NFT_SET_ATTR_POLICY))
> +		nft_set_attr_set_u32(nls, NFT_SET_ATTR_POLICY, set->policy);
> +
> +	if (set->attr_flags & (1 << NFT_SET_ATTR_DESC_SIZE))
> +		nft_set_attr_set_u32(nls, NFT_SET_ATTR_DESC_SIZE,
> +				     set->desc.size);
> +

As in the kernel, the size definitely doesn't need an attribute, the policy
can be argued about.

> @@ -965,6 +975,7 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
>  				$1->init = $4;
>  				$$ = $1;
>  			}
> +			|	set_block	set_mechanism	stmt_seperator
>  			;
>  
>  set_flag_list		:	set_flag_list	COMMA		set_flag
> @@ -1018,6 +1029,26 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
>  				$1->init = $4;
>  				$$ = $1;
>  			}
> +			|	map_block	set_mechanism	stmt_seperator
> +			;
> +
> +set_mechanism		:	set_policy_spec
> +			{
> +				$<set>0->attr_flags |= (1 << NFT_SET_ATTR_POLICY);
> +				$<set>0->policy = $1;
> +			}
> +			|	set_size_spec
> +			{
> +				$<set>0->attr_flags |= (1 << NFT_SET_ATTR_DESC_SIZE);
> +				$<set>0->desc.size = $1;
> +			}
> +			;
> +
> +set_policy_spec		:	POLICY	PERFORMANCE	{ $$ = NFT_SET_POL_PERFORMANCE; }
> +			|	POLICY	MEMORY		{ $$ = NFT_SET_POL_MEMORY; }
> +			;
> +
> +set_size_spec		:	SIZE	NUM	{ $$ = $2; }

We usually have rules like this:

set_policy:		PERFORMANCE ...
			MEMORY

and the keyword POLICY one level above.
