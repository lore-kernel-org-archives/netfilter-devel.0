From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/2] src: add flag to add event wrapping in
 output functions
Date: Tue, 15 Apr 2014 15:36:18 +0200
Message-ID: <20140415133618.GA8835@localhost>
References: <20140415125030.2590.5501.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44515 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaDONgZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:36:25 -0400
Content-Disposition: inline
In-Reply-To: <20140415125030.2590.5501.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 15, 2014 at 02:50:30PM +0200, Arturo Borrero Gonzalez wrote:
> This patch uses the flag option of each output function to print an
> event wrapper string in each object.
> 
> In order to use this functionality, the caller must pass a flag with either
> NFT_OUTPUT_FLAG_EVENTNEW or NFT_OUTPUT_FLAG_EVENTDEL activated.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  include/libnftnl/common.h |    5 +++
>  src/chain.c               |   37 ++++++++++++++++++++++---
>  src/internal.h            |    2 +
>  src/rule.c                |   43 ++++++++++++++++++++++++++---
>  src/ruleset.c             |   66 ++++++++++++++++++++++++++++++++++++++++-----
>  src/set.c                 |   42 +++++++++++++++++++++++++----
>  src/set_elem.c            |   37 ++++++++++++++++++++++---
>  src/table.c               |   36 +++++++++++++++++++++----
>  src/utils.c               |   45 +++++++++++++++++++++++++++++++
>  9 files changed, 280 insertions(+), 33 deletions(-)
> 
> diff --git a/include/libnftnl/common.h b/include/libnftnl/common.h
> index f0c20f0..f105c9a 100644
> --- a/include/libnftnl/common.h
> +++ b/include/libnftnl/common.h
> @@ -15,6 +15,11 @@ enum nft_output_type {
>  	NFT_OUTPUT_JSON,
>  };
>  
> +enum {
> +	NFT_OUTPUT_FLAG_EVENTNEW	= 0,
> +	NFT_OUTPUT_FLAG_EVENTDEL,
> +};

Please, change this to:

enum nft_output_flags {
        NFT_OF_EVENT_NEW        = (1 << 0),
        NFT_OF_EVENT_DEL        = (1 << 1),
};

So people don't need to use (1 << NFT_OUTPUT_FLAG_EVENTNEW) to pass
the flag to nft_*_snprintf from their applications.

> +
>  enum nft_parse_type {
>  	NFT_PARSE_NONE		= 0,
>  	NFT_PARSE_XML,
> diff --git a/src/chain.c b/src/chain.c
> index 472203e..87558a1 100644
> --- a/src/chain.c
> +++ b/src/chain.c
> @@ -924,17 +924,44 @@ static int nft_chain_snprintf_default(char *buf, size_t size,
>  int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *c,
>  		       uint32_t type, uint32_t flags)
>  {
> +	int ret, len = size, offset = 0;
> +
> +	if (flags & (1 << NFT_OUTPUT_FLAG_EVENTNEW)) {
> +		ret = snprintf(buf+offset, len, "%s",

Use this instead "%9s ".

So you can use [NEW] and [DELETE] tags and the plain text event output
gets aligned (and you don't need to trim DELETE to DEL anymore).
