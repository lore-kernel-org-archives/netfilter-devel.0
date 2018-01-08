From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: nf_tables: delete table via table handle
Date: Mon, 8 Jan 2018 20:23:10 +0100
Message-ID: <20180108192310.eov3tu2t2hcznzgy@salvia>
References: <20180108175818.23100-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57818 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932638AbeAHTXQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jan 2018 14:23:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C0D9FE3A04
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 20:23:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B1D4E53CDC
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 20:23:13 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180108175818.23100-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 08, 2018 at 11:28:18PM +0530, Harsha Sharma wrote:
> This patch add code to delete table via unique table handle and table
> family.
> 
> Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
> ---
> Changes in v2:
>  - Remove nf_tables_afinfo_lookup_byhandle
>  - Change log message
> 
>  net/netfilter/nf_tables_api.c | 45 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index ba6065c39674..1f1f3be37034 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -400,6 +400,28 @@ static struct nft_table *nft_table_lookup(const struct nft_af_info *afi,
>  	return NULL;
>  }
>  
> +static struct nft_table *__nft_table_lookup_byhandle(const struct nft_af_info *afi,
> +						     u64 handle, u8 genmask)

Please, rename this __nft_table_lookup_byhandle to nft_table_lookup_byhandle.

> +{
> +	struct nft_table *table;
> +
> +	list_for_each_entry(table, &afi->tables, list) {
> +		if (handle == table->handle &&
> +		    nft_active_genmask(table, genmask))
> +			return table;
> +	}
> +	return NULL;
> +}
> +
> +static struct nft_table *nft_table_lookup_byhandle(const struct nft_af_info *afi,
> +						   const struct nlattr *nla,
> +						   u8 genmask)
> +{
> +	return __nft_table_lookup_byhandle(afi,
> +					   be64_to_cpu(nla_get_be64(nla)),
> +					   genmask);
> +}

So you can remove this function above.

> +
>  static struct nft_table *nf_tables_table_lookup(const struct nft_af_info *afi,
>  						const struct nlattr *nla,
>  						u8 genmask)
> @@ -416,6 +438,22 @@ static struct nft_table *nf_tables_table_lookup(const struct nft_af_info *afi,
>  	return ERR_PTR(-ENOENT);
>  }
>  
> +static struct nft_table *nf_tables_table_lookup_byhandle(const struct nft_af_info *afi,
> +							 const struct nlattr *nla,
> +							 u8 genmask)
> +{
> +	struct nft_table *table;
> +
> +	if (nla == NULL)
> +		return ERR_PTR(-EINVAL);
> +
> +	table = nft_table_lookup_byhandle(afi, nla, genmask);
> +	if (table != NULL)
> +		return table;
> +
> +	return ERR_PTR(-ENOENT);
> +}
> +
>  static inline u64 nf_tables_alloc_handle(struct nft_table *table)
>  {
>  	return ++table->hgenerator;
> @@ -893,14 +931,17 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
>  	struct nft_ctx ctx;
>  
>  	nft_ctx_init(&ctx, net, skb, nlh, NULL, NULL, NULL, nla);
> -	if (family == AF_UNSPEC || nla[NFTA_TABLE_NAME] == NULL)
> +	if (family == AF_UNSPEC || (nla[NFTA_TABLE_NAME] == NULL && nla[NFTA_TABLE_HANDLE] == NULL))

We have to break lines at 80 chars, so I suggest:

	if (family == AF_UNSPEC ||
            (!nla[NFTA_TABLE_NAME] && !nla[NFTA_TABLE_HANDLE]))

>  		return nft_flush(&ctx, family);
>  
>  	afi = nf_tables_afinfo_lookup(net, family, false);
>  	if (IS_ERR(afi))
>  		return PTR_ERR(afi);
> +	if (nla[NFTA_TABLE_HANDLE])
> +		table = nf_tables_table_lookup_byhandle(afi, nla[NFTA_TABLE_HANDLE], genmask);
> +	else
> +		table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME], genmask);
>  
> -	table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME], genmask);
>  	if (IS_ERR(table))
>  		return PTR_ERR(table);

Other than that, this looks good.

Once you send v3 for this, please, follow up with chain handles.

Thanks.
