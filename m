From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] internal: fix SNPRINTF_BUFFER_SIZE macro
Date: Mon, 12 May 2014 17:37:14 +0200
Message-ID: <20140512153714.GA12698@localhost>
References: <20140509115806.2467.11788.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40955 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbaELPhZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 11:37:25 -0400
Content-Disposition: inline
In-Reply-To: <20140509115806.2467.11788.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 09, 2014 at 01:58:06PM +0200, Arturo Borrero Gonzalez wrote:
> We need to store in 'offset' the complete amount of characters as returned
> from _snprintf. The value means how many characters long needs the buffer to be
> in order to store the corresponding string expansion.
> 
> Before this patch, in cases where the buffer is smaller than the
> expansion, then ret > len, and therefore ret = len.
> So when incrementing offset, we do it with a wrong value.
> 
> All previous versions of libnftnl are unable to handle this situations: small
> buffers (or long string expansion).
> 
> BTW, if a caller must reallocate a buffer to the returned value of snprintf, it
> should be ret + 1.

Thanks for looking into this.

> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  src/internal.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/internal.h b/src/internal.h
> index 6595e70..43d61ca 100644
> --- a/src/internal.h
> +++ b/src/internal.h
> @@ -184,9 +184,9 @@ struct nft_set_elem {
>  
>  #define SNPRINTF_BUFFER_SIZE(ret, size, len, offset)	\

We should also check if (ret < 0) here in first place, in that case
return ret.

>  	size += ret;					\

You have to move this line above where offset += len was previously.

> +	offset += ret;					\
>  	if (ret > len)					\
>  		ret = len;				\
> -	offset += ret;					\
>  	len -= ret;

After those changes, this macro looks good to me.
