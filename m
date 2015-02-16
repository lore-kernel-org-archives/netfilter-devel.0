From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] ruleset: fix crash if we free sets included in
 the set_list
Date: Mon, 16 Feb 2015 23:03:21 +0100
Message-ID: <20150216220321.GA29084@salvia>
References: <1424115135-32323-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51794 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbbBPWAO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2015 17:00:14 -0500
Content-Disposition: inline
In-Reply-To: <1424115135-32323-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 16, 2015 at 08:32:14PM +0100, Alvaro Neira Ayuso wrote:
> When we parse a ruleset which has a rule using a set. First step is parse the
> set, set up an id and add it to a set list. Later, we use this set list to find
> the set associated to the rule and we set up the set id to the expression
> (lookup expression) of the rule.
> 
> The problem is if we return this set using the function
> nft_ruleset_parse_file_cb and we free this set. We have a crash when we try to
> iterate in the set list.
> 
> This patch solves it, creating and copying the set to another and adding the new
> copy to the set list.

OK, you're actually 'cloning' the object and adding it to a list.

More comments below.

> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  src/ruleset.c |   25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/src/ruleset.c b/src/ruleset.c
> index 89ea344..0b6e0e0 100644
> --- a/src/ruleset.c
> +++ b/src/ruleset.c
> @@ -308,12 +308,33 @@ err:
>  	return -1;
>  }
>  
> +static int nft_ruleset_add_set(struct nft_parse_ctx *ctx, struct nft_set *set)
> +{
> +	struct nft_set *newset;
> +	const char *set_name;
> +	int set_id;
> +
> +	newset = nft_set_alloc();
> +	if (newset == NULL)
> +		return -1;
> +
> +	set_name = nft_set_attr_get_str(set, NFT_SET_ATTR_NAME);
> +	nft_set_attr_set_str(newset, NFT_SET_ATTR_NAME, set_name);
> +
> +	set_id = ctx->set_id++;
> +	nft_set_attr_set_u32(set, NFT_SET_ATTR_ID, set_id);
> +	nft_set_attr_set_u32(newset, NFT_SET_ATTR_ID, set_id);
> +

Please, add to src/set.c:

        struct nft_set *nft_set_clone(const struct nft_set *set)

and use it from here. No need to expose it yet in the API yet.

The set ID allocation is a different operation that should happen
before calling the new nft_set_clone(...).

> +	nft_set_list_add_tail(newset, ctx->set_list);
> +	return 0;
> +}
> +
>  static int nft_ruleset_parse_set(struct nft_parse_ctx *ctx,
>  				 struct nft_set *set, uint32_t type,
>  				 struct nft_parse_err *err)
>  {
> -	nft_set_attr_set_u32(set, NFT_SET_ATTR_ID, ctx->set_id++);
> -	nft_set_list_add_tail(set, ctx->set_list);
> +	if (nft_ruleset_add_set(ctx, set) < 0)
> +		goto err;
>  
>  	nft_ruleset_ctx_set_u32(ctx, NFT_RULESET_CTX_TYPE, type);
>  	nft_ruleset_ctx_set(ctx, NFT_RULESET_CTX_SET, set);
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
