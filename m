From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATH 02/16] libnftables: add context new and free
Date: Thu, 17 Aug 2017 11:04:29 +0200
Message-ID: <20170817090429.GT16375@orbyte.nwl.cc>
References: <20170816204310.3371-1-eric@regit.org>
 <20170816204310.3371-3-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:40143 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751552AbdHQJEb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2017 05:04:31 -0400
Content-Disposition: inline
In-Reply-To: <20170816204310.3371-3-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 16, 2017 at 10:42:56PM +0200, Eric Leblond wrote:
[...]
> diff --git a/src/libnftables.c b/src/libnftables.c
> index 215179a..da1b231 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -51,3 +51,23 @@ void nft_global_deinit(void)
>  	realm_table_meta_exit();
>  	mark_table_exit();
>  }
> +
> +struct nft_ctx *nft_context_new(void)
> +{
> +	struct nft_ctx *ctx = NULL;
> +	ctx = malloc(sizeof(struct nft_ctx));

Use calloc() here to avoid having garbage in 'output' and 'check'
fields.

> +	if (ctx == NULL)
> +		return NULL;
> +	ctx->nf_sock = netlink_open_sock();
> +
> +	return ctx;
> +}

Cheers, Phil
