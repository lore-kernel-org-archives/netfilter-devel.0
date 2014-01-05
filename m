From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] netfilter: nft_hash: use set->maxelems to calculate
 number of buckets
Date: Sun, 5 Jan 2014 21:47:44 +0000
Message-ID: <20140105214744.GA18655@macbook.localnet>
References: <1388956728-6754-1-git-send-email-pablo@netfilter.org>
 <1388956728-6754-4-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47619 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaAEVrr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jan 2014 16:47:47 -0500
Content-Disposition: inline
In-Reply-To: <1388956728-6754-4-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 05, 2014 at 10:18:48PM +0100, Pablo Neira Ayuso wrote:
> Use set->maxelems to calculate the number of buckets that holds a
> load factor of 0.75.

This patch is perfectly fine of course.

> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nft_hash.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
> index f640c1c..99e4742 100644
> --- a/net/netfilter/nft_hash.c
> +++ b/net/netfilter/nft_hash.c
> @@ -169,9 +169,7 @@ static int nft_hash_init(const struct nft_set *set,
>  	}
>  
>  	/* Aim for a load factor of 0.75 */
> -	// FIXME: temporarily broken until we have set descriptions
> -	cnt = 100;
> -	cnt = cnt * 4 / 3;
> +	cnt = set->maxelems * 4 / 3;
>  
>  	priv->hash = kcalloc(cnt, sizeof(struct hlist_head), GFP_KERNEL);
>  	if (priv->hash == NULL)
> -- 
> 1.7.10.4
