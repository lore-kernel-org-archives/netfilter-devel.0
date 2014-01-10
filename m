From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH libnftables] Add support for ct set
Date: Fri, 10 Jan 2014 13:14:06 +0000
Message-ID: <20140110131406.GA8088@macbook.localnet>
References: <1389359425-6837-1-git-send-email-kristian.evensen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59115 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaAJNOL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:14:11 -0500
Content-Disposition: inline
In-Reply-To: <1389359425-6837-1-git-send-email-kristian.evensen@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 10, 2014 at 02:10:25PM +0100, Kristian Evensen wrote:
>  #define NFTA_CT_MAX		(__NFTA_CT_MAX - 1)
> diff --git a/src/expr/ct.c b/src/expr/ct.c
> index 46e3cef..02a073e 100644
> --- a/src/expr/ct.c
> +++ b/src/expr/ct.c
> @@ -24,7 +24,8 @@
>  
>  struct nft_expr_ct {
>  	enum nft_ct_keys        key;
> -	uint32_t		dreg;	/* enum nft_registers */
> +	enum nft_registers	dreg;
> +	enum nft_registers	sreg;
>  	uint8_t			dir;
>  };


nftables uses statements for things that don't return a value. I think
it would make sense to keep this consistent. An "set" expression (aka
statement) can never be used in a match, so its something fundamentally
different than an expression.
