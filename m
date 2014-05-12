From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] utils: fix buffer reallocation of nft_fprinft()
Date: Mon, 12 May 2014 17:54:57 +0200
Message-ID: <20140512155457.GB12698@localhost>
References: <20140509164547.7057.94412.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42831 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbaELPzG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 11:55:06 -0400
Content-Disposition: inline
In-Reply-To: <20140509164547.7057.94412.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Fri, May 09, 2014 at 06:45:47PM +0200, Arturo Borrero Gonzalez wrote:
> When _snprintf() reports it would print n characters, that n doesn't include
> the trailing \0 that snprintf adds.
> 
> Thus, we need to [re]allocate n+1 characters.
> 
> While at it, change the reallocation trigger. If the length of the buffer we
> used is equals to the expanded string length, the output has been truncated.
> In other words, if ret == bufsiz, then the trailing \0 is missing.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  src/utils.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/src/utils.c b/src/utils.c
> index 18917f5..b8094aa 100644
> --- a/src/utils.c
> +++ b/src/utils.c
> @@ -195,12 +195,13 @@ int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags,
>  	int ret;
>  
>  	ret = snprintf_cb(buf, bufsiz, obj, type, flags);

I think we should also check here if snprintf returns -1 now that you
have fixed the SNPRINTF_ macro.

> -	if (ret > NFT_SNPRINTF_BUFSIZ) {
> -		buf = calloc(1, ret);
> +	if (ret >= NFT_SNPRINTF_BUFSIZ) {
> +		bufsiz = ret + 1;
> +
> +		buf = calloc(1, bufsiz);

You can use malloc instead. Just make sure that the string is always
nul-terminated before printing, something like:

                bufsiz = ret + 1;
                buf = malloc(1, bufsiz);
                if (buf == NULL)
                        return -1;

                ret = snprintf(...
                if (ret < 0)
                        ...
        }

        buf[ret] = '\0';
        ... = fprintf(...

Thanks.
