From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next PATCH v2] netfilter: nft_compat: add ebtables support
Date: Fri, 30 Jan 2015 19:00:45 +0100
Message-ID: <20150130180045.GA12255@salvia>
References: <20150129183432.12221.94390.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36347 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759733AbbA3R5s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Jan 2015 12:57:48 -0500
Content-Disposition: inline
In-Reply-To: <20150129183432.12221.94390.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 29, 2015 at 07:34:42PM +0100, Arturo Borrero Gonzalez wrote:
> This patch extends nft_compat to support ebtables extensions.
> 
> ebtables verdict codes are translated to the ones used by the nf_tables engine,
> so we can properly use ebtables target extensions from nft_compat.

Applied with minor nitpick, thanks Arturo.

> diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
> index 265e190..73ec6ef 100644
> --- a/net/netfilter/nft_compat.c
> +++ b/net/netfilter/nft_compat.c
> @@ -66,7 +68,7 @@ static void nft_target_eval(const struct nft_expr *expr,
>  	if (pkt->xt.hotdrop)
>  		ret = NF_DROP;
>  
> -	switch(ret) {
> +	switch (ret) {
>  	case XT_CONTINUE:
>  		data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
>  		break;
> @@ -74,6 +76,44 @@ static void nft_target_eval(const struct nft_expr *expr,
>  		data[NFT_REG_VERDICT].verdict = ret;
>  		break;
>  	}
> +
> +	return;

Removed this return, we don't need it.

> +}
