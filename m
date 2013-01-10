From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/7] netfilter: nf_tables: move filter chain definition
 to layer 3 modules
Date: Thu, 10 Jan 2013 17:02:24 +0100
Message-ID: <20130110160156.GA2178@macbook.localnet>
References: <1357831721-10182-1-git-send-email-pablo@netfilter.org>
 <1357831721-10182-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, tomasz.bursztyka@linux.intel.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58037 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab3AJQCb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:02:31 -0500
Content-Disposition: inline
In-Reply-To: <1357831721-10182-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 10, 2013 at 04:28:36PM +0100, pablo@netfilter.org wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> This patch moves the definition of the filter_ipv4 and filter_ipv6
> default filter chains to where they belong.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/ipv4/netfilter/nf_tables_ipv4.c |   23 +++++++++++++++++++-
>  net/ipv6/netfilter/nf_tables_ipv6.c |   23 +++++++++++++++++++-
>  net/netfilter/nf_tables_api.c       |   41 -----------------------------------
>  3 files changed, 44 insertions(+), 43 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/nf_tables_ipv4.c b/net/ipv4/netfilter/nf_tables_ipv4.c
> index 8827539..a0ee4c2 100644
> --- a/net/ipv4/netfilter/nf_tables_ipv4.c
> +++ b/net/ipv4/netfilter/nf_tables_ipv4.c
> @@ -1,5 +1,6 @@
>  /*
>   * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
> + * Copyright (c) 2012-2013 Pablo Neira Ayuso <pablo@netfilter.org>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -70,14 +71,34 @@ static struct pernet_operations nf_tables_ipv4_net_ops = {
>  	.exit	= nf_tables_ipv4_exit_net,
>  };
>  
> +static struct nf_chain_type filter_ipv4 = {
> +	.family		= NFPROTO_IPV4,
> +	.name		= "filter",
> +	.type		= NFT_CHAIN_T_DEFAULT,
> +	.hook_mask	= (1 << NF_INET_LOCAL_IN) |
> +			  (1 << NF_INET_LOCAL_OUT) |
> +			  (1 << NF_INET_FORWARD) |
> +			  (1 << NF_INET_PRE_ROUTING) |
> +			  (1 << NF_INET_POST_ROUTING),
> +	.fn		= {
> +		[NF_INET_LOCAL_IN]	= nft_do_chain,
> +		[NF_INET_LOCAL_OUT]	= nft_do_chain,
> +		[NF_INET_FORWARD]	= nft_do_chain,
> +		[NF_INET_PRE_ROUTING]	= nft_do_chain,
> +		[NF_INET_POST_ROUTING]	= nft_do_chain,
> +	},
> +};

I'm still thinking about how to rework this, the chain types currently
break the LOCAL_OUT check for short SOCK_RAW packets and setting of
the transport layer header pointer before invoking nft_do_chain().
I'll also need some additional overloading for multi family tables,
so I think we need to rethink this scheme.

Feel free to apply your patch, but I'll probably will rework this very
soon anyway.
