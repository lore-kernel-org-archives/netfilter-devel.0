From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [xtables-arptables PATCH v2 5/5] nft: replace args.family
Date: Wed, 24 Jul 2013 10:58:08 +0200
Message-ID: <20130724085808.GD16434@localhost>
References: <20130723161017.10040.6256.stgit@localhost>
 <20130723161316.10040.78293.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56463 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab3GXI6N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:58:13 -0400
Content-Disposition: inline
In-Reply-To: <20130723161316.10040.78293.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 23, 2013 at 06:13:45PM +0200, Giuseppe Longo wrote:
> Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
> ---
>  iptables/xtables.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/iptables/xtables.c b/iptables/xtables.c
> index d4b8709..d1b04cb 100644
> --- a/iptables/xtables.c
> +++ b/iptables/xtables.c
> @@ -1096,7 +1096,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
>  	if (h->family == AF_UNSPEC)
>  		h->family = args.family;
>  
> -	h->ops = nft_family_ops_lookup(args.family);
> +	h->ops = nft_family_ops_lookup(h->family);

Due to lack of patch description, I don't know if you're trying to
address a bug or this is just a simple cleanup.

>  	if (h->ops == NULL)
>  		xtables_error(PARAMETER_PROBLEM, "Unknown family");
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
