From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nft_redir: fix sparse warnings: cast to
 restricted __be32
Date: Wed, 12 Nov 2014 12:56:51 +0100
Message-ID: <20141112115651.GA32330@salvia>
References: <20141112111039.323.26439.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53365 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaKLLy6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:54:58 -0500
Content-Disposition: inline
In-Reply-To: <20141112111039.323.26439.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 12, 2014 at 12:10:39PM +0100, Arturo Borrero Gonzalez wrote:
> This patch fixes some sparse warnings:
> 
> net/netfilter/nft_redir.c:39:26: sparse: incorrect type in assignment (different base types)
> net/netfilter/nft_redir.c:39:26:    expected unsigned int [unsigned] [usertype] nla_be32
> net/netfilter/nft_redir.c:39:26:    got restricted __be32
> net/netfilter/nft_redir.c:40:40: sparse: cast to restricted __be32
> net/netfilter/nft_redir.c:40:40: sparse: cast to restricted __be32
> net/netfilter/nft_redir.c:40:40: sparse: cast to restricted __be32
> net/netfilter/nft_redir.c:40:40: sparse: cast to restricted __be32
> net/netfilter/nft_redir.c:40:40: sparse: cast to restricted __be32
> net/netfilter/nft_redir.c:40:40: sparse: cast to restricted __be32
> net/netfilter/nft_redir.c:46:34: sparse: incorrect type in assignment (different base types)
> net/netfilter/nft_redir.c:46:34:    expected unsigned int [unsigned] [usertype] nla_be32
> net/netfilter/nft_redir.c:46:34:    got restricted __be32
> net/netfilter/nft_redir.c:47:48: sparse: cast to restricted __be32
> net/netfilter/nft_redir.c:47:48: sparse: cast to restricted __be32
> net/netfilter/nft_redir.c:47:48: sparse: cast to restricted __be32
> net/netfilter/nft_redir.c:47:48: sparse: cast to restricted __be32
> net/netfilter/nft_redir.c:47:48: sparse: cast to restricted __be32
> net/netfilter/nft_redir.c:47:48: sparse: cast to restricted __be32
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  net/netfilter/nft_redir.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
> index e27b4e3..dd2aa78 100644
> --- a/net/netfilter/nft_redir.c
> +++ b/net/netfilter/nft_redir.c
> @@ -28,7 +28,7 @@ int nft_redir_init(const struct nft_ctx *ctx,
>  		   const struct nlattr * const tb[])
>  {
>  	struct nft_redir *priv = nft_expr_priv(expr);
> -	u32 nla_be32;
> +	__be32 nla_be32;

Thanks Arturo.

I already sent a patch, I prefer to get rid of this variable for
consistency with other nft nat-like expressions.
