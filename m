From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat PATCH] ebtables-compat: fix printing of
 extension
Date: Mon, 5 Jan 2015 12:22:05 +0100
Message-ID: <20150105112205.GA13174@salvia>
References: <20141226124952.16163.81787.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55121 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbbAELTZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:19:25 -0500
Content-Disposition: inline
In-Reply-To: <20141226124952.16163.81787.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 26, 2014 at 01:49:52PM +0100, Arturo Borrero Gonzalez wrote:
> This patch fix printing of ebt extensions:
> 
> % sudo ebtables-compat -L
> [...]
> Bridge chain: FORWARD, entries: 1, policy: ACCEPT
> --802_3-type 0x0012 -j ACCEPT
> [...]

Applied with minor glitches, thanks Arturo.

> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  iptables/nft-bridge.c |   23 +++++++----------------
>  iptables/nft-bridge.h |    4 ++++
>  iptables/nft-shared.c |   17 ++++++++++++++++-
>  3 files changed, 27 insertions(+), 17 deletions(-)
> 
> diff --git a/iptables/nft-bridge.h b/iptables/nft-bridge.h
> index fd8bc9f..fac172e 100644
> --- a/iptables/nft-bridge.h
> +++ b/iptables/nft-bridge.h
> @@ -15,6 +15,10 @@
>  /* Be backwards compatible, so don't use '+' in kernel */
>  #define IF_WILDCARD 1
>  
> +#ifndef ETH_ALEN
> +#define ETH_ALEN 6
> +#endif /* ETH_ALEN */

use header definitions whenever possible.

>  extern unsigned char eb_mac_type_unicast[ETH_ALEN];
>  extern unsigned char eb_msk_type_unicast[ETH_ALEN];
>  extern unsigned char eb_mac_type_multicast[ETH_ALEN];
> diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
> index 71c4476..0ba9742 100644
> --- a/iptables/nft-shared.c
> +++ b/iptables/nft-shared.c
> @@ -26,6 +26,7 @@
>  #include <libnftnl/expr.h>
>  
>  #include "nft-shared.h"
> +#include "nft-bridge.h"
>  #include "xshared.h"
>  #include "nft.h"
>  
> @@ -326,9 +327,23 @@ void nft_parse_match(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
>  	const char *mt_name = nft_rule_expr_get_str(e, NFT_EXPR_MT_NAME);
>  	const void *mt_info = nft_rule_expr_get(e, NFT_EXPR_MT_INFO, &mt_len);
>  	struct xtables_match *match;
> +	struct xtables_rule_match **matches;
>  	struct xt_entry_match *m;
>  
> -	match = xtables_find_match(mt_name, XTF_TRY_LOAD, &ctx->state.cs->matches);
> +	switch (ctx->family) {
> +	case NFPROTO_IPV4:
> +	case NFPROTO_IPV6:
> +		matches = &ctx->state.cs->matches;
> +		break;
> +	case NFPROTO_BRIDGE:
> +		matches = &ctx->state.cs_eb->matches;
> +		break;
> +	default:
> +		fprintf(stderr, "BUG: nft_parse_match() unhandled family\n");

exitted here in case of bug. BTW, a BUG() macro similar to nft would
be good to have, I guess we can replace several spots with it.
