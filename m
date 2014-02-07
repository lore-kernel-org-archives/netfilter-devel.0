From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_tables: fix loop checking with set element
 data
Date: Fri, 7 Feb 2014 15:47:34 +0000
Message-ID: <20140207154720.GA23148@macbook.localnet>
References: <1391786631-4070-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45412 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaBGPri (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Feb 2014 10:47:38 -0500
Content-Disposition: inline
In-Reply-To: <1391786631-4070-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 07, 2014 at 04:23:51PM +0100, Pablo Neira Ayuso wrote:
> This patch fixes two bugs:
> 
> * Restrict the validation to verdict maps only, since struct nft_data
>   is declared as a union, data[0] may contain the values -3 or -4 which
>   match with NFT_JUMP and NFT_GOTO. I think this will result in crash
>   while performing the chain loop validation.
> 
> * Access to uninitialized data for end interval elements. The element
>   data part is uninitialized in interval end elements.
> 

That's not necessary. The function is only invoked for NFT_DATA_VERDICT.


> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index d0c790e3e..522becb 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2998,6 +2998,11 @@ static int nf_tables_loop_check_setelem(const struct nft_ctx *ctx,
>  					const struct nft_set_iter *iter,
>  					const struct nft_set_elem *elem)
>  {
> +	if (!(set->flags & NFT_SET_MAP) ||
> +	    set->dtype != NFT_DATA_VERDICT ||
> +	    elem->flags & NFT_SET_ELEM_INTERVAL_END)
> +		return 0;
> +
>  	switch (elem->data.verdict) {
>  	case NFT_JUMP:
>  	case NFT_GOTO:
> -- 
> 1.7.10.4
