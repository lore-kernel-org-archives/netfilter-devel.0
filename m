From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATH 10/16] libnftables: get rid of printf
Date: Thu, 17 Aug 2017 12:01:11 +0200
Message-ID: <20170817100111.GX16375@orbyte.nwl.cc>
References: <20170816204310.3371-1-eric@regit.org>
 <20170816204310.3371-11-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:36607 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750857AbdHQKBM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2017 06:01:12 -0400
Content-Disposition: inline
In-Reply-To: <20170816204310.3371-11-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 16, 2017 at 10:43:04PM +0200, Eric Leblond wrote:
[...]
> diff --git a/include/nftables.h b/include/nftables.h
> index 348fbb0..ddff5d8 100644
> --- a/include/nftables.h
> +++ b/include/nftables.h
> @@ -30,6 +30,8 @@ struct output_ctx {
>  	unsigned int ip2name;
>  	unsigned int handle;
>  	unsigned int echo;
> +	void *ctx;
> +	int (*print)(void *ctx, const char *format, ...);
>  };

My compiler says:

| libnftables.c: In function 'nft_context_new':
| libnftables.c:113:20: warning: assignment left-hand side might be a candidate for a format attribute [-Wsuggest-attribute=format]
|   ctx->output.print = nft_print;
|                     ^

Not really a warning IMO, though.

Abstracting the topic a bit, maybe all these foo_print() callbacks
should die eventually and be replaced by formatters for different output
types, similar to nftnl_foo_snprintf() functions. Maybe the whole output
formatting actually even belongs to the application and libnftables has
to provide a way to extract object information. Not sure how much
knowlege the application should (need to) have about internal data
structures like e.g., struct table or struct expr.

Cheers, Phil
