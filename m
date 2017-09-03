From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/2] src: add flags fo nft_ctx_new
Date: Mon, 4 Sep 2017 00:33:09 +0200
Message-ID: <20170903223309.GA12383@salvia>
References: <20170903220356.20178-1-eric@regit.org>
 <20170903220356.20178-2-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:40732 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752984AbdICWdl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Sep 2017 18:33:41 -0400
Content-Disposition: inline
In-Reply-To: <20170903220356.20178-2-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 04, 2017 at 12:03:55AM +0200, Eric Leblond wrote:
> By adding flags to nft_ctx_new, we will have a minimum capabilities
> of changing the way the nft_ctx is created.
> 
> For now, this patch uses a simple value that allow the user to specify
> that he will handle netlink by himself.
> 
> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  include/nftables.h |  4 ++++
>  src/main.c         | 20 +++++++++++---------
>  2 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/include/nftables.h b/include/nftables.h
> index 5035567..7c4e93f 100644
> --- a/include/nftables.h
> +++ b/include/nftables.h
> @@ -49,8 +49,12 @@ struct nft_ctx {
>  	struct output_ctx	output;
>  	bool			check;
>  	struct nft_cache	cache;
> +	uint32_t		flags;
>  };
>  
> +#define NFT_CTX_CUSTOM_NETLINK	(1<<0)
> +#define NFT_CTX_DEFAULT		0

Better than flag, let's make this a type, ie. NFT_CTX_NETLINK is just 1.

OK?
