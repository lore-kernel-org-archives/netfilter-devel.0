From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATH 06/16] libnftables: add missing variable to library
Date: Thu, 17 Aug 2017 11:35:02 +0200
Message-ID: <20170817093502.GV16375@orbyte.nwl.cc>
References: <20170816204310.3371-1-eric@regit.org>
 <20170816204310.3371-7-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:51011 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751173AbdHQJfD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2017 05:35:03 -0400
Content-Disposition: inline
In-Reply-To: <20170816204310.3371-7-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 16, 2017 at 10:43:00PM +0200, Eric Leblond wrote:
> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  src/libnftables.c | 2 ++
>  src/main.c        | 1 -
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/src/libnftables.c b/src/libnftables.c
> index 6599248..6d4aceb 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -33,6 +33,8 @@ unsigned int handle_output;
>  unsigned int debug_level;
>  #endif
>  
> +const char *include_paths[INCLUDE_PATHS_MAX] = { DEFAULT_INCLUDE_PATH };
> +

I guess this belongs into nft_ctx as well.

Cheers, Phil
