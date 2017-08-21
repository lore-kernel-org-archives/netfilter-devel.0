From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATH nft v2 15/18] libnftables: set max_errors to 1 in library
Date: Mon, 21 Aug 2017 10:37:46 +0200
Message-ID: <20170821083746.GI2982@salvia>
References: <20170819152420.22563-1-eric@regit.org>
 <20170819152420.22563-16-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:53267 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751088AbdHUIiN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 04:38:13 -0400
Content-Disposition: inline
In-Reply-To: <20170819152420.22563-16-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 19, 2017 at 05:24:17PM +0200, Eric Leblond wrote:
> As memory handling is defficient if we don't do so, we can't really
> use a non 1 value for the parameter in the library due to memory
> leak.
> 
> Also this is not a real issue as programmatically a user of the
> library should only encounter one error at a time.
> 
> This patch also introduces a function that can be used to modify
> the max_errors parameter. It is used in main to keep the existing
> behavior.
> 
> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  include/nftables/nftables.h | 1 +
>  src/libnftables.c           | 8 +++++++-
>  src/main.c                  | 1 +
>  3 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
> index 2ddb38a..f419884 100644
> --- a/include/nftables/nftables.h
> +++ b/include/nftables/nftables.h
> @@ -22,6 +22,7 @@ enum nftables_exit_codes {
>  };
>  
>  void nft_global_init(void);
> +int nft_global_set_max_errors(unsigned int errors);
>  void nft_global_deinit(void);
>  
>  struct nft_ctx *nft_context_new(void);
> diff --git a/src/libnftables.c b/src/libnftables.c
> index 61ed4e5..15345ae 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -25,7 +25,7 @@
>  #include <fcntl.h>
>  
>  
> -unsigned int max_errors = 10;
> +unsigned int max_errors = 1;

This is defeating all the work I've done - both in netlink and in
userspace - in the past to allow printing several errors in one go. So
you likely understand I'm reticent to take this as is :-)

I remember you mentioned there's a problem with memory in the parser.
I would help to fix this, I'd appreciate if you can describe the
problem so we can address it here.

Thanks!
