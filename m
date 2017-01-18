From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/1] netfilter: nf_tables: Eliminate duplicated
 codes in nf_tables_table_enable
Date: Wed, 18 Jan 2017 20:55:52 +0100
Message-ID: <20170118195552.GA14768@salvia>
References: <1484023359-30227-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36888 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751970AbdART4v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 14:56:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6D0FF13C0D3
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 20:55:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4111A356A
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 20:55:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 583B7A7DB0
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 20:55:53 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1484023359-30227-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 10, 2017 at 12:42:39PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> When something failed in nf_tables_table_enable, it would unregister
> the chains. But the rollback codes are same as nf_tables_table_disable
> almostly, except there is one counter check.
> Now create one wrapper function to eliminate the duplicated codes.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  net/netfilter/nf_tables_api.c | 47 ++++++++++++++++++++++---------------------
>  1 file changed, 24 insertions(+), 23 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index a019a87..28a0bd7 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -576,6 +576,27 @@ static int nf_tables_gettable(struct net *net, struct sock *nlsk,
>  	return err;
>  }
>  
> +static void _nf_tables_table_disable(struct net *net,
> +				     const struct nft_af_info *afi,
> +				     struct nft_table *table,
> +				     u32 cnt)
> +{
> +	struct nft_chain *chain;
> +
> +	list_for_each_entry(chain, &table->chains, list) {
> +		if (!nft_is_active_next(net, chain))
> +			continue;
> +		if (!(chain->flags & NFT_BASE_CHAIN))
> +			continue;
> +
> +		if (cnt-- == 0)
> +			break;
> +
> +		nf_unregister_net_hooks(net, nft_base_chain(chain)->ops,
> +					afi->nops);
> +	}
> +}
> +
>  static int nf_tables_table_enable(struct net *net,
>  				  const struct nft_af_info *afi,
>  				  struct nft_table *table)
> @@ -598,18 +619,8 @@ static int nf_tables_table_enable(struct net *net,
>  	}
>  	return 0;
>  err:
> -	list_for_each_entry(chain, &table->chains, list) {
> -		if (!nft_is_active_next(net, chain))
> -			continue;
> -		if (!(chain->flags & NFT_BASE_CHAIN))
> -			continue;
> -
> -		if (i-- <= 0)
> -			break;
> -
> -		nf_unregister_net_hooks(net, nft_base_chain(chain)->ops,
> -					afi->nops);
> -	}
> +	if (i)
> +		_nf_tables_table_disable(net, afi, table, i);
>  	return err;
>  }
>  
> @@ -617,17 +628,7 @@ static void nf_tables_table_disable(struct net *net,
>  				    const struct nft_af_info *afi,
>  				    struct nft_table *table)
>  {
> -	struct nft_chain *chain;
> -
> -	list_for_each_entry(chain, &table->chains, list) {
> -		if (!nft_is_active_next(net, chain))
> -			continue;
> -		if (!(chain->flags & NFT_BASE_CHAIN))
> -			continue;
> -
> -		nf_unregister_net_hooks(net, nft_base_chain(chain)->ops,
> -					afi->nops);
> -	}
> +	_nf_tables_table_disable(net, afi, table, U32_MAX);
                                                  ^^^^^^^
While I think it's good to consolidate code, I don't like this.

Probably better something like this?

+static void nft_table_disable(struct net *net,
+                              const struct nft_af_info *afi,
+			       struct nft_table *table, int cnt)
+{
+	struct nft_chain *chain;
+
+	list_for_each_entry(chain, &table->chains, list) {
+		if (!nft_is_active_next(net, chain))
+			continue;
+		if (!(chain->flags & NFT_BASE_CHAIN))
+			continue;
+
+		nf_unregister_net_hooks(net, nft_base_chain(chain)->ops,
+					afi->nops);
+		if (cnt && --cnt == 0)
+			break;
+
+	}
+}

So you call:

        nft_table_disable(net, afi, table, 0);
