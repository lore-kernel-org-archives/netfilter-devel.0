From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/5] netfilter: nft_reject: split up reject module into
 IPv4 and IPv6 specifc parts
Date: Thu, 6 Feb 2014 04:53:08 +0000
Message-ID: <20140206045307.GA21526@macbook.localnet>
References: <1391612619-30347-1-git-send-email-kaber@trash.net>
 <1391612619-30347-5-git-send-email-kaber@trash.net>
 <20140205232657.GD5674@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63036 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaBFExN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 23:53:13 -0500
Content-Disposition: inline
In-Reply-To: <20140205232657.GD5674@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 06, 2014 at 12:26:57AM +0100, Pablo Neira Ayuso wrote:
> On Wed, Feb 05, 2014 at 03:03:38PM +0000, Patrick McHardy wrote:
> > Currently the nft_reject module depends on symbols from ipv6. This is
> > wrong since no generic module should force IPv6 support to be loaded.
> > Split up the module into AF-specific and a generic part.
> 
> Applied, thanks. I have included this chunk which was missing:

Oops, sorry.

> 
> --- /dev/null
> +++ b/include/net/netfilter/nft_reject.h
> @@ -0,0 +1,18 @@
> +#ifndef _NFT_REJECT_H_
> +#define _NFT_REJECT_H_
> +
> +struct nft_reject {
> +       enum nft_reject_types   type:8;
> +       u8                      icmp_code;
> +       u8                      family;

Family is actually not needed anymore.

> +};
> +
> +extern const struct nla_policy nft_reject_policy[];
> +
> +int nft_reject_init(const struct nft_ctx *ctx,
> +                   const struct nft_expr *expr,
> +                   const struct nlattr * const tb[]);
> +
> +int nft_reject_dump(struct sk_buff *skb, const struct nft_expr *expr);
> +
> +#endif
