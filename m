From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/4 v2] src: add command tag in json/xml export
 support
Date: Fri, 30 Jan 2015 19:36:38 +0100
Message-ID: <20150130183638.GA22598@salvia>
References: <1422628525-28109-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43409 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbbA3Sdd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Jan 2015 13:33:33 -0500
Content-Disposition: inline
In-Reply-To: <1422628525-28109-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 30, 2015 at 03:35:22PM +0100, Alvaro Neira Ayuso wrote:
> diff --git a/src/chain.c b/src/chain.c
> index 26ad14d..7eb8923 100644
> --- a/src/chain.c
> +++ b/src/chain.c
> @@ -847,12 +847,12 @@ static int nft_chain_snprintf_default(char *buf, size_t size,
>  	return offset;
>  }
>  
> -int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *c,
> -		       uint32_t type, uint32_t flags)
> +int nft_chain_cmd_snprintf(char *buf, size_t size, struct nft_chain *c,
> +			   uint32_t cmd, uint32_t type, uint32_t flags)
>  {
>  	int ret, len = size, offset = 0;
>  
> -	ret = nft_event_header_snprintf(buf+offset, len, type, flags);
> +	ret = nft_cmd_header_snprintf(buf + offset, len, cmd, type, flags);
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
>  	switch (type) {
> @@ -869,15 +869,26 @@ int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *c,
>  
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
> -	ret = nft_event_footer_snprintf(buf+offset, len, type, flags);
> +	ret = nft_cmd_footer_snprintf(buf + offset, len, cmd, type, flags);
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
>  	return offset;
>  }
>  EXPORT_SYMBOL(nft_chain_snprintf);

This EXPORT_SYMBOL should be nft_chain_cmd_snprintf.

You also have to update the .map file otherwise this new functions
will not be visible to client of this library.

Add to src/libnftnl.map:

        LIBNFTNL_1.2.0 {
          nft_chin_cmd_snprintf;
          ...
        } LIBNFTNL_1.2;
