From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: Add meta expression key for bridge
 interface name
Date: Tue, 25 Mar 2014 21:43:31 +0100
Message-ID: <20140325204331.GA3491@localhost>
References: <1395765587-5399-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50865 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbaCYUnj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:43:39 -0400
Content-Disposition: inline
In-Reply-To: <1395765587-5399-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Tomasz,

Thanks for looking into this, comments below.

On Tue, Mar 25, 2014 at 06:39:47PM +0200, Tomasz Bursztyka wrote:
> NFT_META_IBRIFNAME to get packet input bridge interface name
> NFT_META_OBRIFNAME to get packet output bridge interface name
> 
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
> ---
> 
> Hi Pablo,
> 
> Does that design sounds proper?
> I added the nft type right away in nft_meta.c
> to reuse as much as possible, only the evaluation is a bit specific.
> 
> I haven't tested yet, I will do the support of this meta key for nft tool
> accordingly.
> 
> Tomasz
> 
>  include/uapi/linux/netfilter/nf_tables.h |  4 ++
>  net/netfilter/nft_meta.c                 | 79 +++++++++++++++++++++++++++++++-
>  2 files changed, 81 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 83c985a..e3c98f9 100644
[...]
> @@ -304,8 +356,13 @@ nft_meta_select_ops(const struct nft_ctx *ctx,
>  	if (tb[NFTA_META_DREG] && tb[NFTA_META_SREG])
>  		return ERR_PTR(-EINVAL);
>  
> -	if (tb[NFTA_META_DREG])
> +	if (tb[NFTA_META_DREG]) {
> +#ifdef CONFIG_NF_TABLES_BRIDGE
> +		if (ctx->aif->family == NFPROTO_BRIDGE)
> +			return &nft_meta_bridge_get_ops;
> +#endif

I really think we have to use Patrick's new infrastructure that allows
us to add new expression flavours per family. It should just need a
couple of exported symbols in nft_meta.c that you can use from the new
net/bridge/netfilter/nft_meta.c file. We should avoid these ifdef
games.
