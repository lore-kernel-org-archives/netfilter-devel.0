From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH v2 4/6] netlink: add netlink_delinearize_chain() func
Date: Wed, 26 Feb 2014 17:49:35 +0100
Message-ID: <20140226164935.GB22731@localhost>
References: <20140226160918.18974.64532.stgit@nfdev.cica.es>
 <20140226161005.18974.74871.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57969 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbaBZQtl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:49:41 -0500
Content-Disposition: inline
In-Reply-To: <20140226161005.18974.74871.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 26, 2014 at 05:10:05PM +0100, Arturo Borrero Gonzalez wrote:
> Let's make this code reusable.
> 
> Also, this patch fixes a hidden bug: the table in the chain's handle was being
> set to the chain name.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  src/netlink.c |   48 ++++++++++++++++++++++--------------------------
>  1 file changed, 22 insertions(+), 26 deletions(-)
> 
> diff --git a/src/netlink.c b/src/netlink.c
> index 74372bf..d2a7804 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -496,25 +496,16 @@ int netlink_delete_chain(struct netlink_ctx *ctx, const struct handle *h,
>  	return err;
>  }
>  
> -static int list_chain_cb(struct nft_chain *nlc, void *arg)
> +static struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
> +					       struct nft_chain *nlc)
>  {
> -	struct netlink_ctx *ctx = arg;
> -	const struct handle *h = ctx->data;
>  	struct chain *chain;
>  
> -	if ((h->family != nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY)) ||
> -	    strcmp(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TABLE), h->table) != 0)
> -		return 0;
> -
> -	if (h->chain &&
> -	    strcmp(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME), h->chain) != 0)
> -		return 0;
> -
>  	chain = chain_alloc(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME));
>  	chain->handle.family =
>  		nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY);
>  	chain->handle.table  =
> -		xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME));
> +		xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TABLE));

Would be good to have a separated fix for this. This can come as the
first patch of the stack.

>  	chain->handle.handle =
>  		nft_chain_attr_get_u64(nlc, NFT_CHAIN_ATTR_HANDLE);
>  
> @@ -531,6 +522,24 @@ static int list_chain_cb(struct nft_chain *nlc, void *arg)
>  	}
>  	list_add_tail(&chain->list, &ctx->list);
>  
> +	return chain;
> +}
> +
> +static int list_chain_cb(struct nft_chain *nlc, void *arg)
> +{
> +	struct netlink_ctx *ctx = arg;
> +	const struct handle *h = ctx->data;
> +	const char *table = nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TABLE);
> +	const char *name = nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME);
> +
> +	if ((h->family != nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY)) ||
> +	    strcmp(table, h->table) != 0)
> +		return 0;
> +
> +	if (h->chain && strcmp(name, h->chain) != 0)
> +		return 0;
> +
> +	netlink_delinearize_chain(ctx, nlc);
>  	return 0;
>  }
>  
> @@ -570,25 +579,12 @@ int netlink_get_chain(struct netlink_ctx *ctx, const struct handle *h,
>  		      const struct location *loc)
>  {
>  	struct nft_chain *nlc;
> -	struct chain *chain;
>  	int err;
>  
>  	nlc = alloc_nft_chain(h);
>  	err = mnl_nft_chain_get(nf_sock, nlc, 0);
>  
> -	chain = chain_alloc(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME));
> -	chain->handle.family = nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY);
> -	chain->handle.table  = xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TABLE));
> -	chain->handle.handle = nft_chain_attr_get_u64(nlc, NFT_CHAIN_ATTR_HANDLE);
> -	if (nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_TYPE) &&
> -	    nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_HOOKNUM) &&
> -	    nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_PRIO)) {
> -		chain->hooknum       = nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM);
> -		chain->priority      = nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_PRIO);
> -		chain->type          = xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TYPE));
> -	}
> -	list_add_tail(&chain->list, &ctx->list);
> -
> +	netlink_delinearize_chain(ctx, nlc);
>  	nft_chain_free(nlc);
>  
>  	if (err < 0)
> 
