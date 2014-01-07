From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 3/6] internal: rework parsing symbol logic
Date: Wed, 8 Jan 2014 00:18:13 +0100
Message-ID: <20140107231813.GC16894@localhost>
References: <20140107114518.12841.35778.stgit@nfdev.cica.es>
 <20140107114726.12841.59406.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34565 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbaAGXSd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:18:33 -0500
Content-Disposition: inline
In-Reply-To: <20140107114726.12841.59406.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 07, 2014 at 12:47:27PM +0100, Arturo Borrero Gonzalez wrote:
> Rework parsing symbols logic, so we get a cleaner file.
> 
> Also, this allows us to use XML(libmxml)/JSON(libjannson) internal datatypes
> without fear.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  0 files changed
> 
> diff --git a/src/internal.h b/src/internal.h
> index 5fef6d6..83cb4e8 100644
> --- a/src/internal.h
> +++ b/src/internal.h
> @@ -40,6 +40,10 @@ struct nft_parse_err {
>  
>  #ifdef XML_PARSING
>  #include <mxml.h>
> +#else
> +#define mxml_node_t void
> +#endif /* XML_PARSING */

I failed to see the benefit of this patch.

> +
>  #define NFT_XML_MAND 0
>  #define NFT_XML_OPT (1 << 0)
>  mxml_node_t *nft_mxml_build_tree(const char *xml, const char *treename,
> @@ -78,10 +82,13 @@ int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r,
>  struct nft_set;
>  int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s,
>  		       struct nft_parse_err *err);
> -#endif

We don't save any ifdef.
