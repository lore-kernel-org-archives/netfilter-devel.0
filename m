Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C7D2F28
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 03:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709781906; cv=none; b=ktag1OmQVWY6MQKaJlYyGm1veixMCZK4aBAIhP4HTk6jCwLTu9INg7o9MO3xGFZWXXpexz0Yb1Lra2vyIkUstxsSuIZZYnAW2V3RDsbm1F2g1/szAvDBA6hxxUA5EysyA4t4cH9nuniwsHcpI6xJTzx0fyo97SKH8iWN7eR5Ty4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709781906; c=relaxed/simple;
	bh=AlcELAzkHADAfCrpsrI5n01Quf3d4mrW6Hus46BoVvM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tr2jjTpFW89WiKa3vqZf65isB4wVRvPOTHeLt2XR9HwQbiwN/T0ykulyq/WPSsKzTm1Dx18s8S59hkRIe6QImMVzJqDJ0zsPhxbSUirEPnSAtFvM40drM/LShNeQOaE9dUdLh4gvklA0OUjymrFTOolFhkwfV9JM/r4abXsJ+KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.33.11] (port=38164 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1ri4NN-00GMMe-PP
	for netfilter-devel@vger.kernel.org; Thu, 07 Mar 2024 04:25:00 +0100
Date: Thu, 7 Mar 2024 04:24:56 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: skip netdev hook unregistration
 if table is dormant
Message-ID: <ZekziOWvEZsWT5HC@calendula>
References: <20240307022407.149801-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240307022407.149801-1-pablo@netfilter.org>
X-Spam-Score: -1.9 (-)

On Thu, Mar 07, 2024 at 03:24:07AM +0100, Pablo Neira Ayuso wrote:
> Skip hook unregistration when adding or deleting devices from an
> existing netdev basechain. Otherwise, commit/abort path try to
> unregister hooks which not enabled.

This patch needs a v2. Interaction with dormant flag and netdev hooks
need a closer look.

> Fixes: 7d937b107108 ("netfilter: nf_tables: support for deleting devices in an existing netdev chain")
> Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 1683dc196b59..59d1b3dbd6a7 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -10174,9 +10174,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  			if (nft_trans_chain_update(trans)) {
>  				nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN,
>  						       &nft_trans_chain_hooks(trans));
> -				nft_netdev_unregister_hooks(net,
> -							    &nft_trans_chain_hooks(trans),
> -							    true);
> +				if (!(trans->ctx.table->flags & NFT_TABLE_F_DORMANT)) {
> +					nft_netdev_unregister_hooks(net,
> +								    &nft_trans_chain_hooks(trans),
> +								    true);
> +				}
>  			} else {
>  				nft_chain_del(trans->ctx.chain);
>  				nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN,
> @@ -10448,9 +10450,11 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
>  			break;
>  		case NFT_MSG_NEWCHAIN:
>  			if (nft_trans_chain_update(trans)) {
> -				nft_netdev_unregister_hooks(net,
> -							    &nft_trans_chain_hooks(trans),
> -							    true);
> +				if (!(trans->ctx.table->flags & NFT_TABLE_F_DORMANT)) {
> +					nft_netdev_unregister_hooks(net,
> +								    &nft_trans_chain_hooks(trans),
> +								    true);
> +				}
>  				free_percpu(nft_trans_chain_stats(trans));
>  				kfree(nft_trans_chain_name(trans));
>  				nft_trans_destroy(trans);
> -- 
> 2.30.2
> 
> 
