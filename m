From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft RFC PATCH 3/6] netlink: add netlink_delinearize_set() func
Date: Tue, 18 Feb 2014 01:56:41 +0000
Message-ID: <20140218015641.GF12893@macbook.localnet>
References: <20140217231654.19943.18736.stgit@nfdev.cica.es>
 <20140217231822.19943.3523.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54781 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaBRB4p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 20:56:45 -0500
Content-Disposition: inline
In-Reply-To: <20140217231822.19943.3523.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 18, 2014 at 12:18:22AM +0100, Arturo Borrero Gonzalez wrote:
> Let's factorize this code, so it can be reused.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  include/netlink.h         |    4 ++++
>  src/netlink.c             |   22 ++--------------------
>  src/netlink_delinearize.c |   27 +++++++++++++++++++++++++++
>  3 files changed, 33 insertions(+), 20 deletions(-)
> 
> diff --git a/include/netlink.h b/include/netlink.h
> index 4e3f8aa..13d01f0 100644
> --- a/include/netlink.h
> +++ b/include/netlink.h
> @@ -70,6 +70,10 @@ extern int netlink_linearize_rule(struct netlink_ctx *ctx,
>  extern struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
>  					     const struct nft_rule *r);
>  
> +extern const struct datatype *dtype_map_from_kernel(enum nft_data_types type);
> +
> +extern struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
> +					   struct nft_set *nls);

Actually delinarization so far refers to the act of converting a linear
instruction stream into an abstract syntax tree. This is not really a
good term for sets, which are still pretty much linear.

I don't have a good suggestion right now though.
