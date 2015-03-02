From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] mxml: test if the root node name is initialized
 before to compare it.
Date: Tue, 3 Mar 2015 00:35:04 +0100
Message-ID: <20150302233504.GA5166@salvia>
References: <1425326318-22936-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53540 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbbCBXbb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 18:31:31 -0500
Content-Disposition: inline
In-Reply-To: <1425326318-22936-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 02, 2015 at 08:58:38PM +0100, Alvaro Neira Ayuso wrote:
> If the root node name is not correctly initialized, we have a crash.

Under what circunstances may tree->value.opaque be NULL?

> ---
>  src/mxml.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/src/mxml.c b/src/mxml.c
> index 0001ba0..b68f86f 100644
> --- a/src/mxml.c
> +++ b/src/mxml.c
> @@ -43,7 +43,8 @@ mxml_node_t *nft_mxml_build_tree(const void *data, const char *treename,
>  		goto err;
>  	}
>  
> -	if (strcmp(tree->value.opaque, treename) == 0)
> +	if (tree->value.opaque != NULL &&
> +	    strcmp(tree->value.opaque, treename) == 0)
>  		return tree;
>  
>  	err->error = NFT_PARSE_EMISSINGNODE;
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
