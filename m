From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nft_rbtree: fix chain use underflow with
 intervals and map
Date: Thu, 6 Feb 2014 16:08:57 +0000
Message-ID: <20140206160857.GA24151@macbook.localnet>
References: <1391702434-4103-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35440 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaBFQJC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:09:02 -0500
Content-Disposition: inline
In-Reply-To: <1391702434-4103-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 06, 2014 at 05:00:34PM +0100, Pablo Neira Ayuso wrote:
> If you add a rule using intervals+map that introduces a loop, the
> error path of the rbtree set decrements the chain refcount for each
> side of the interval, leading to a chain use counter underflow.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nft_rbtree.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
> index ca0c1b2..b18e88b 100644
> --- a/net/netfilter/nft_rbtree.c
> +++ b/net/netfilter/nft_rbtree.c
> @@ -69,8 +69,10 @@ static void nft_rbtree_elem_destroy(const struct nft_set *set,
>  				    struct nft_rbtree_elem *rbe)
>  {
>  	nft_data_uninit(&rbe->key, NFT_DATA_VALUE);
> -	if (set->flags & NFT_SET_MAP)
> +	if (set->flags & NFT_SET_MAP &&
> +	    !(rbe->flags & NFT_SET_ELEM_INTERVAL_END))
>  		nft_data_uninit(rbe->data, set->dtype);
> +

That can't be correct. The NFT_SET_ELEM_INTERVAL_END can at the same
time begin a new interval, so this code is supposed to be like this.
There can also only be a chain reference here if we took one before
during initialization.

Please provide a test case so I can try myself.
