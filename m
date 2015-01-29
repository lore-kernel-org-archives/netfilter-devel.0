From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next PATCH] netfilter: nft_compat: translate ebtables
 verdicts
Date: Thu, 29 Jan 2015 18:17:05 +0100
Message-ID: <20150129171705.GB3595@salvia>
References: <20150129164559.23327.66398.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41912 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbbA2ROB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Jan 2015 12:14:01 -0500
Content-Disposition: inline
In-Reply-To: <20150129164559.23327.66398.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 29, 2015 at 05:45:59PM +0100, Arturo Borrero Gonzalez wrote:
> Translate ebtables verdict to the ones used by the nf_tables engine,
> so we can properly use ebtables target extensions from nft_compat.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  net/netfilter/nft_compat.c |   67 ++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 61 insertions(+), 6 deletions(-)
> 
> diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
> index 7f90d06..8ac7238 100644
> --- a/net/netfilter/nft_compat.c
> +++ b/net/netfilter/nft_compat.c
> @@ -52,9 +52,8 @@ nft_compat_set_par(struct xt_action_param *par, void *xt, const void *xt_info)
>  	par->hotdrop	= false;
>  }
>  
> -static void nft_target_eval(const struct nft_expr *expr,
> -			    struct nft_data data[NFT_REG_MAX + 1],
> -			    const struct nft_pktinfo *pkt)
> +static int nft_target_eval_call(const struct nft_expr *expr,
> +				const struct nft_pktinfo *pkt)

Not sure it's worth the factorization, this code is rather small. I'd
suggest you just add nft_target_eval_bridge() as a copy of the
original _eval function.  Rename the original nft_target_eval() to
nft_target_eval_xt().
