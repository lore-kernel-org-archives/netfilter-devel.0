From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [xtables-arptables PATCH v2 2/5] nft: search builtin tables via
 nft_handle tables pointer
Date: Wed, 24 Jul 2013 10:51:18 +0200
Message-ID: <20130724085118.GB16434@localhost>
References: <20130723161017.10040.6256.stgit@localhost>
 <20130723161226.10040.34058.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54761 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab3GXIvW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:51:22 -0400
Content-Disposition: inline
In-Reply-To: <20130723161226.10040.34058.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 23, 2013 at 06:12:29PM +0200, Giuseppe Longo wrote:
>

Again missing description.

>
> Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
> ---
>  iptables/nft.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/iptables/nft.c b/iptables/nft.c
> index f6dccff..07ca0f1 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -288,20 +288,21 @@ nft_chain_builtin_add(struct nft_handle *h, struct builtin_table *table,
>  }
>  
>  /* find if built-in table already exists */
> -static struct builtin_table *nft_table_builtin_find(const char *table)
> +static struct builtin_table *
> +nft_table_builtin_find(struct nft_handle *h, const char *table)
>  {
>  	int i;
>  	bool found = false;
>  
>  	for (i=0; i<TABLES_MAX; i++) {
> -		if (strcmp(tables[i].name, table) != 0)
> +		if (strcmp(h->tables[i].name, table) != 0)
>  			continue;
>  
>  		found = true;
>  		break;
>  	}
>  
> -	return found ? &tables[i] : NULL;
> +	return found ? &h->tables[i] : NULL;
>  }
>  
>  /* find if built-in chain already exists */
> @@ -349,7 +350,7 @@ nft_chain_builtin_init(struct nft_handle *h, const char *table,
>  	int ret = 0;
>  	struct builtin_table *t;
>  
> -	t = nft_table_builtin_find(table);
> +	t = nft_table_builtin_find(h, table);
>  	if (t == NULL) {
>  		ret = -1;
>  		goto out;
> @@ -424,7 +425,7 @@ int nft_table_set_dormant(struct nft_handle *h, const char *table)
>  	int ret = 0, i;
>  	struct builtin_table *t;
>  
> -	t = nft_table_builtin_find(table);
> +	t = nft_table_builtin_find(h, table);
>  	if (t == NULL) {
>  		ret = -1;
>  		goto out;
> @@ -485,7 +486,7 @@ __nft_chain_set(struct nft_handle *h, const char *table,
>  	struct builtin_chain *_c;
>  	int ret;
>  
> -	_t = nft_table_builtin_find(table);
> +	_t = nft_table_builtin_find(h, table);
>  	/* if this built-in table does not exists, create it */
>  	if (_t != NULL)
>  		nft_table_builtin_add(h, _t, false);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
