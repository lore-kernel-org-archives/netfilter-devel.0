From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/3] expr: masq: optional printing of flags attr
 in snprintf_default
Date: Fri, 3 Oct 2014 14:05:33 +0200
Message-ID: <20141003120533.GA10433@salvia>
References: <20141002115836.10972.3637.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, anayrey@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43493 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbaJCMER (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:04:17 -0400
Content-Disposition: inline
In-Reply-To: <20141002115836.10972.3637.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 02, 2014 at 01:58:36PM +0200, Arturo Borrero Gonzalez wrote:
> The flags attribute is optional. Thus we should print only if it
> was originally set.

Applied with nitpick.

> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  0 files changed
> 
> diff --git a/src/expr/masq.c b/src/expr/masq.c
> index 6a1c609..c8a6a8d 100644
> --- a/src/expr/masq.c
> +++ b/src/expr/masq.c
> @@ -169,8 +169,10 @@ static int nft_rule_expr_masq_snprintf_default(char *buf, size_t len,
>  {
>  	struct nft_expr_masq *masq = nft_expr_data(e);
>  
> -	return snprintf(buf, len, " flags %u ",
> -			 masq->flags);
> +	if (e->flags & (1 << NFT_EXPR_MASQ_FLAGS))
> +		return snprintf(buf, len, "flags %u", masq->flags);
                                                   ^
                                      missing space there.

Otherwise the output shows flags 0].

And change it to use %x. Hex is better for flags.
