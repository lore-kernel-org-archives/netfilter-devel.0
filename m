From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: delete table via table handle
Date: Sun, 7 Jan 2018 00:02:45 +0100
Message-ID: <20180106230245.ipgffikudoff3hus@salvia>
References: <20180106183015.11557-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38652 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751377AbeAFXCv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Jan 2018 18:02:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 35089C1061
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Jan 2018 00:02:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 22AA6DA861
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Jan 2018 00:02:50 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180106183015.11557-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 07, 2018 at 12:00:15AM +0530, Harsha Sharma wrote:
> This patch add code to delete table via unique table handle.
> 
> Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
> ---
>  net/netfilter/nf_tables_api.c | 99 ++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 92 insertions(+), 7 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index dabdd2ed66c8..3b1c879fdf61 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -73,6 +73,24 @@ static struct nft_af_info *nft_afinfo_lookup(struct net *net, int family)
>  	return NULL;
>  }
>  
> +static struct nft_af_info *nft_afinfo_lookup_byhandle(struct net *net,
> +						      u64 handle)
> +{
> +	struct nft_af_info *afi;
> +	struct nft_table *table;
> +	int table_handle_check_flag = 0;
> +
> +	list_for_each_entry(afi, &net->nft.af_info, list) {
> +		list_for_each_entry(table, &afi->tables, list) {
> +			if (table->handle == handle)
> +				table_handle_check_flag = 1;

Use:
                                return table;

instead.

> +		}
> +		if (table_handle_check_flag)
> +			return afi;
> +	}
> +	return NULL;
> +}
> +
>  static struct nft_af_info *
>  nf_tables_afinfo_lookup(struct net *net, int family, bool autoload)
>  {
> @@ -94,6 +112,27 @@ nf_tables_afinfo_lookup(struct net *net, int family, bool autoload)
>  	return ERR_PTR(-EAFNOSUPPORT);
>  }
>  
> +static struct nft_af_info *
> +nf_tables_afinfo_lookup_byhandle(struct net *net, u64 handle, bool autoload)
> +{
> +	struct nft_af_info *afi;
> +
> +	afi = nft_afinfo_lookup_byhandle(net, handle);
> +	if (afi != NULL)
> +		return afi;
> +#ifdef CONFIG_MODULES
> +	if (autoload) {
> +		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
> +		request_module("nft-afinfo");
> +		nfnl_lock(NFNL_SUBSYS_NFTABLES);
> +		afi = nft_afinfo_lookup_byhandle(net, handle);
> +		if (afi != NULL)
> +			return ERR_PTR(-EAGAIN);
> +	}
> +#endif
> +	return ERR_PTR(-EAFNOSUPPORT);
> +}

I don't think you need this new nf_tables_afinfo_lookup_byhandle()
function. The handle parameter is never used. That will simplify your
patchset.

> +
>  static void nft_ctx_init(struct nft_ctx *ctx,
>  			 struct net *net,
>  			 const struct sk_buff *skb,
> @@ -107,7 +146,7 @@ static void nft_ctx_init(struct nft_ctx *ctx,
>  	ctx->afi	= afi;
>  	ctx->table	= table;
>  	ctx->chain	= chain;
> -	ctx->nla   	= nla;
> +	ctx->nla	= nla;
>  	ctx->portid	= NETLINK_CB(skb).portid;
>  	ctx->report	= nlmsg_report(nlh);
>  	ctx->seq	= nlh->nlmsg_seq;
> @@ -367,6 +406,28 @@ static struct nft_table *nft_table_lookup(const struct nft_af_info *afi,
>  	return NULL;
>  }
>  
> +static struct nft_table *__nft_table_lookup_byhandle(const struct nft_af_info *afi,
> +						     u64 handle, u8 genmask)
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
> +
>  static struct nft_table *nf_tables_table_lookup(const struct nft_af_info *afi,
>  						const struct nlattr *nla,
>  						u8 genmask)
> @@ -383,6 +444,22 @@ static struct nft_table *nf_tables_table_lookup(const struct nft_af_info *afi,
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
> @@ -854,14 +931,22 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
>  	struct nft_ctx ctx;
>  
>  	nft_ctx_init(&ctx, net, skb, nlh, NULL, NULL, NULL, nla);
> -	if (family == AF_UNSPEC || nla[NFTA_TABLE_NAME] == NULL)
> +	if (nla[NFTA_TABLE_HANDLE]) {
> +		afi = nf_tables_afinfo_lookup_byhandle(net, be64_to_cpu(nla_get_be64(nla[NFTA_TABLE_HANDLE])), false);
> +		if (IS_ERR(afi))
> +			return PTR_ERR(afi);
> +		else
> +			table = nf_tables_table_lookup_byhandle(afi, nla[NFTA_TABLE_HANDLE], genmask);
> +	} else if (family == AF_UNSPEC || nla[NFTA_TABLE_NAME] == NULL) {
>  		return nft_flush(&ctx, family);
> +	} else {
>  
> -	afi = nf_tables_afinfo_lookup(net, family, false);
> -	if (IS_ERR(afi))
> -		return PTR_ERR(afi);
> -
> -	table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME], genmask);
> +		afi = nf_tables_afinfo_lookup(net, family, false);
> +		if (IS_ERR(afi))
> +			return PTR_ERR(afi);
> +		else
> +			table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME], genmask);
> +	}
>  	if (IS_ERR(table))
>  		return PTR_ERR(table);
>  
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
