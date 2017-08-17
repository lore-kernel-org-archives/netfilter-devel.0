From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATH 03/16] libnftables: add nft_run_command_from_buffer
Date: Thu, 17 Aug 2017 11:21:48 +0200
Message-ID: <20170817092148.GU16375@orbyte.nwl.cc>
References: <20170816204310.3371-1-eric@regit.org>
 <20170816204310.3371-4-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:56047 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750939AbdHQJVu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2017 05:21:50 -0400
Content-Disposition: inline
In-Reply-To: <20170816204310.3371-4-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 16, 2017 at 10:42:57PM +0200, Eric Leblond wrote:
[...]
> diff --git a/src/libnftables.c b/src/libnftables.c
> index da1b231..9248741 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -7,7 +7,6 @@
>   *
>   */
>  
> -#include <nftables/nftables.h>
>  #include <string.h>
>  #include <errno.h>
>  #include <nftables.h>
> @@ -18,6 +17,8 @@
>  #include <libmnl/libmnl.h>
>  #include <mnl.h>
>  
> +#include <nftables/nftables.h>
> +
>  #include <unistd.h>
>  #include <fcntl.h>

Wat? :)

BTW, someone once told me "headers shouldn't include other headers",
though I sometimes doubt that was the whole truth. What do you think, is
"oh, you included our lib's header too early" a bug in the library or
the application?

[...]
> diff --git a/src/main.c b/src/main.c
> index 23af38e..f863dec 100644
[...]
> @@ -367,7 +362,7 @@ int main(int argc, char * const *argv)
>  			nft->output.handle++;
>  			break;
>  		case OPT_ECHO:
> -			nft.output.echo++;
> +			nft->output.echo++;

Rebase scars. :)

Cheers, Phil
