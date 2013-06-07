From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 2/2] Add implementation for to proof the JSON
 export function
Date: Fri, 7 Jun 2013 14:02:57 +0200
Message-ID: <20130607120257.GB6571@localhost>
References: <20130607091043.13002.66552.stgit@Ph0enix>
 <20130607091423.13002.25109.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38502 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab3FGMDZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:03:25 -0400
Content-Disposition: inline
In-Reply-To: <20130607091423.13002.25109.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Also applied, thanks.

On Fri, Jun 07, 2013 at 11:14:23AM +0200, Alvaro Neira wrote:
> 
> ---
>  examples/nft-table-get.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/examples/nft-table-get.c b/examples/nft-table-get.c
> index b113636..0d7746c 100644
> --- a/examples/nft-table-get.c
> +++ b/examples/nft-table-get.c
> @@ -59,6 +59,10 @@ int main(int argc, char *argv[])
>  		type = NFT_TABLE_O_XML;
>  		argv[argc-1] = NULL;
>  		argc--;
> +	}else if (strcmp(argv[argc-1], "json") == 0) {
> +		type = NFT_TABLE_O_JSON;
> +		argv[argc-1] = NULL;
> +		argc--;
>  	} else if (strcmp(argv[argc - 1], "default") == 0) {
>  		argc--;
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
