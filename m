From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 4/6] internal: add a selector for parsing ops
Date: Wed, 8 Jan 2014 00:29:19 +0100
Message-ID: <20140107232919.GD16894@localhost>
References: <20140107114518.12841.35778.stgit@nfdev.cica.es>
 <20140107114732.12841.11957.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35463 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbaAGX3i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:29:38 -0500
Content-Disposition: inline
In-Reply-To: <20140107114732.12841.11957.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 07, 2014 at 12:47:32PM +0100, Arturo Borrero Gonzalez wrote:
> This patch adds a selector for parsing operations.
> 
> The selector allows to reduce code duplication in case more than
> one parsing interface are used.

This needs a rework.

> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  0 files changed
> 
> diff --git a/src/chain.c b/src/chain.c
> index a4ddb06..fd56629 100644
> --- a/src/chain.c
> +++ b/src/chain.c
> @@ -592,13 +592,14 @@ err:
>  #endif
>  
>  static int nft_chain_json_parse(struct nft_chain *c, const char *json,
> -				struct nft_parse_err *err)
> +				struct nft_parse_err *err,
> +				const struct nft_parse_ops *ops)

You should pass a callback function instead, eg.

static int nft_chain_json_parse(struct nft_chain *c, const char *json,
				struct nft_parse_err *err,
                                json_t *(*jsonbuilder)(const void *input_data,
                                                       const char *treename,
                                                       struct nft_parse_err *e))
But I don't understand yet what you save (in terms of lines of code)
by using this aproach.
