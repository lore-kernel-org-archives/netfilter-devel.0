From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATH nft v2 08/18] libnftables: add missing variables to library
Date: Mon, 21 Aug 2017 10:27:22 +0200
Message-ID: <20170821082722.GF2982@salvia>
References: <20170819152420.22563-1-eric@regit.org>
 <20170819152420.22563-9-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:53189 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751941AbdHUI1u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 04:27:50 -0400
Content-Disposition: inline
In-Reply-To: <20170819152420.22563-9-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 19, 2017 at 05:24:10PM +0200, Eric Leblond wrote:
> This patch also avoids double definition of global vars.
> 
> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  src/libnftables.c | 2 ++
>  src/main.c        | 6 ------
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/src/libnftables.c b/src/libnftables.c
> index 446ec1e..28f9272 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -33,6 +33,8 @@ unsigned int handle_output;
>  unsigned int debug_level;
>  #endif
>  
> +const char *include_paths[INCLUDE_PATHS_MAX] = { DEFAULT_INCLUDE_PATH };

Would you send an initial patch to place this in nft_ctx?

Otherwise, we can probably tell Varsha - Outreachy to do this for you.

>  void nft_global_init(void)
>  {
>  	mark_table_init();
> diff --git a/src/main.c b/src/main.c
> index 9b4e450..7ab01b7 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -29,12 +29,6 @@
>  #include <iface.h>
>  #include <cli.h>
>  
> -unsigned int max_errors = 10;
> -#ifdef DEBUG
> -unsigned int debug_level;
> -#endif

These are being removed here, so I guess this is a leftover from
previous patch.

Anyway, I think these are candidates for the ctx object too, let me
have a look if I can send you a quick patch to sort out this.

> -const char *include_paths[INCLUDE_PATHS_MAX] = { DEFAULT_INCLUDE_PATH };
>  static unsigned int num_include_paths = 1;
>  
>  enum opt_vals {
> -- 
> 2.14.1
> 
