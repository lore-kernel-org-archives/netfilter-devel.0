From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/2] src: add flag to add event wrapping in
 output functions
Date: Tue, 15 Apr 2014 15:44:31 +0200
Message-ID: <20140415134431.GA8927@localhost>
References: <20140415125030.2590.5501.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45548 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaDONok (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:44:40 -0400
Content-Disposition: inline
In-Reply-To: <20140415125030.2590.5501.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 15, 2014 at 02:50:30PM +0200, Arturo Borrero Gonzalez wrote:
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
> +			       nft_event_opentag(NFT_OUTPUT_FLAG_EVENTNEW,
> +						 type));
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +	} else if (flags & (1 << NFT_OUTPUT_FLAG_EVENTDEL)) {
> +		ret = snprintf(buf+offset, len, "%s",
> +			       nft_event_opentag(NFT_OUTPUT_FLAG_EVENTDEL,
> +						 type));
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +	}
> +
[...]
> +	if (flags & (1 << NFT_OUTPUT_FLAG_EVENTNEW)) {
> +		ret = snprintf(buf+offset, len, "%s",
> +			       nft_event_opentag(NFT_OUTPUT_FLAG_EVENTNEW,
> +						 type));
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +		noevent_flags &= ~(1 << NFT_OUTPUT_FLAG_EVENTNEW);
> +	} else if (flags & (1 << NFT_OUTPUT_FLAG_EVENTDEL)) {
> +		ret = snprintf(buf+offset, len, "%s",
> +			       nft_event_opentag(NFT_OUTPUT_FLAG_EVENTDEL,
> +						 type));
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +		noevent_flags &= ~(1 << NFT_OUTPUT_FLAG_EVENTDEL);
> +	}

This code looks very similar, you can encapsulate it in one function
to add the heading and the trailer.

Regarding the noevent_flags thing, which is the only different, you can do:

        unsigned int inner_flags &= ~NFT_OF_EVENT_ANY;

And use inner_flags to when you have nested calls (ie. like in ruleset.c).

The NFT_OF_EVENT_ANY mask should be something like:

enum ... {
        NFT_OF_EVENT_ANY        = (NFT_OF_EVENT_NEW | NFT_OF_EVENT_DEL)
};

Thanks.
