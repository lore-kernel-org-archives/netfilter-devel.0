From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH] src: fix return code
Date: Fri, 11 Oct 2013 10:25:53 +0200
Message-ID: <20131011082552.GB3630@localhost>
References: <20131010211156.12209.65147.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41006 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913Ab3JKI0E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:26:04 -0400
Content-Disposition: inline
In-Reply-To: <20131010211156.12209.65147.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 10, 2013 at 11:11:56PM +0200, Arturo Borrero Gonzalez wrote:
> Exit with NFT_EXIT_FAILURE if something went wrong in the netlink zone.
> 
> Before this patch:
> 
> # nft list chain filter asd ; echo $?
> internal:0:0-0: Error: Could not find chain `asd' in table `filter': [...]
> 
> 0
> 
> After this patch:
> 
> # nft list chain filter asd ; echo $?
> internal:0:0-0: Error: Could not find chain `asd' in table `filter': [...]
> 
> 1
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  src/main.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/src/main.c b/src/main.c
> index 3ddcb71..9aa5f1b 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -222,7 +222,7 @@ int main(int argc, char * const *argv)
>  	char *buf = NULL, *filename = NULL;
>  	unsigned int len;
>  	bool interactive = false;
> -	int i, val;
> +	int i, val, rc = NFT_EXIT_FAILURE;
>  
>  	while (1) {
>  		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
> @@ -318,11 +318,12 @@ int main(int argc, char * const *argv)
>  		exit(NFT_EXIT_FAILURE);
>  	}
>  
> -	nft_run(scanner, &state, &msgs);
> +	if (nft_run(scanner, &state, &msgs) == 0)
> +		rc = NFT_EXIT_SUCCESS;

I prefer if you check for errors, the convention is to check for
errors, which should be the less frequent path. So assume
NFT_EXIT_SUCCESS by default.

>  out:
>  	scanner_destroy(scanner);
>  	erec_print_list(stdout, &msgs);
>  
>  	xfree(buf);
> -	return 0;
> +	exit(rc);

Please, replace this with 'return rc;'

>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
