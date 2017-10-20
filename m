From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 6/7] libnftables: Provide an API for include path
 handling
Date: Fri, 20 Oct 2017 14:17:00 +0200
Message-ID: <20171020121700.GE4068@salvia>
References: <20171019081847.16171-1-phil@nwl.cc>
 <20171019081847.16171-7-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45598 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753343AbdJTMRE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 08:17:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 707D86926B
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 14:17:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 60144DA877
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 14:17:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171019081847.16171-7-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 19, 2017 at 10:18:46AM +0200, Phil Sutter wrote:
> In order to keep the API simple, remove INCLUDE_PATHS_MAX restraint and
> dynamically allocate nft_ctx field include_paths instead.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/nftables/nftables.h |  6 +++---
>  src/libnftables.c           | 34 ++++++++++++++++++++++++++++++++--
>  src/main.c                  |  9 ++++-----
>  src/scanner.l               |  4 +---
>  4 files changed, 40 insertions(+), 13 deletions(-)
> 
> diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
> index f0c9bbf3ba3fe..a752f20d74132 100644
> --- a/include/nftables/nftables.h
> +++ b/include/nftables/nftables.h
> @@ -17,8 +17,6 @@ struct nft_cache {
>  	uint32_t		seqnum;
>  };
>  
> -#define INCLUDE_PATHS_MAX	16
> -
>  struct output_ctx {
>  	unsigned int numeric;
>  	unsigned int stateless;
> @@ -30,7 +28,7 @@ struct output_ctx {
>  
>  struct nft_ctx {
>  	struct mnl_socket	*nf_sock;
> -	const char		*include_paths[INCLUDE_PATHS_MAX];
> +	char			**include_paths;
>  	unsigned int		num_include_paths;
>  	unsigned int		parser_max_errors;
>  	unsigned int		debug_mask;
> @@ -78,6 +76,8 @@ void nft_ctx_free(struct nft_ctx *ctx);
>  
>  FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp);
>  void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry);
> +int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path);
> +void nft_ctx_clear_include_paths(struct nft_ctx *ctx);
>  
>  void nft_ctx_flush_cache(struct nft_ctx *ctx);
>  
> diff --git a/src/libnftables.c b/src/libnftables.c
> index 817f537e32618..2f4275c9a0a94 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -6,10 +6,13 @@
>   * published by the Free Software Foundation.
>   *
>   */
> +#define _GNU_SOURCE
>  #include <erec.h>
>  #include <errno.h>
>  #include <mnl.h>
>  #include <parser.h>
> +#include <stdio.h>
> +#include <stdlib.h>
>  #include <string.h>
>  #include <utils.h>
>  #include <iface.h>
> @@ -122,6 +125,33 @@ static void nft_exit(void)
>  	mark_table_exit();
>  }
>  
> +int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path)

Do we want to accept runtime addition/removal of include paths?

I mean, I would just make it nft_ctx_set_include_path(), then add an
unsetter, so we simplify this.

Let me know if I'm overlooking anything, thanks.
