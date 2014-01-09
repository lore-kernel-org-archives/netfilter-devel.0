From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 1/3] parsing: rework and generalize the
 build/parse system
Date: Thu, 9 Jan 2014 17:57:29 +0100
Message-ID: <20140109165729.GA15460@localhost>
References: <20140109111906.32565.65222.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50208 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbaAIQ5g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 11:57:36 -0500
Content-Disposition: inline
In-Reply-To: <20140109111906.32565.65222.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 09, 2014 at 12:19:06PM +0100, Arturo Borrero Gonzalez wrote:
> The intention behind this patch is to allow adding more input sources in the
> near future.

This looks more simple and easier to read which is what I needed,
thanks. Applied with minor glitches, see below.

> For this to happen without duplicating many code, we need to generalize
> the build/parse system.
> 
> The path flow is now as follow:
>  * API func: here we decide what kind of input we have.
> 	nft_table_parse()
> 
>  * Common function to decide what format to parse (JSON/XML).
> 	nft_table_do_parse()
> 
>  * Common function per format to order the build of the tree and launch the
>    parsing:
> 	nft_table_xml_parse()
> 	nft_table_json_parse()
> 
>  * Common function per format to build the tree (here more builders can be
>    easily implemented):
> 	nft_mxml_build_tree()
> 	nft_jansson_create_root()
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  0 files changed
> 
> diff --git a/src/chain.c b/src/chain.c
> index a4ddb06..a7a6d99 100644
> --- a/src/chain.c
> +++ b/src/chain.c
> @@ -591,14 +591,14 @@ err:
>  }
>  #endif
>  
> -static int nft_chain_json_parse(struct nft_chain *c, const char *json,
> -				struct nft_parse_err *err)
> +static int nft_chain_json_parse(struct nft_chain *c, const void *json,
> +				struct nft_parse_err *err, uint32_t buildsrc)

Comestical: I have added enum nft_parse_input, I think this improves
readability instead of buildsrc.
