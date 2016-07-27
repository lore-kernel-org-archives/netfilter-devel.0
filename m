From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2] netfilter: nft_nth: match every n packets
Date: Thu, 28 Jul 2016 01:01:05 +0200
Message-ID: <20160727230105.GC2565@breakpoint.cc>
References: <20160727220053.GA26643@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35768 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1163603AbcG0XBI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Jul 2016 19:01:08 -0400
Content-Disposition: inline
In-Reply-To: <20160727220053.GA26643@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Laura Garcia Liebana <nevola@gmail.com> wrote:
> +struct nft_nth {
> +	enum nft_registers      dreg:8;
> +	u32			every;
> +	atomic_t		counter;
> +};
> +
> +static void nft_nth_eval(const struct nft_expr *expr,
> +			 struct nft_regs *regs,
> +			 const struct nft_pktinfo *pkt)
> +{
> +	struct nft_nth *nth = nft_expr_priv(expr);
> +	u32 nval, oval;
> +
> +	do {
> +		oval = atomic_read(&nth->counter);
> +		nval = (oval+1 < nth->every) ? oval+1 : 0;
> +	} while (atomic_cmpxchg(&nth->counter, oval, nval) != oval);
> +
> +	memcpy(&regs->data[nth->dreg], &nth->counter, sizeof(u32));

So this places current counter value in the dreg.

How exactly is this used by nftables?

AFAIU usespace will check if ->dreg is 0 or not, but does that make
sense?

Seems to me it would be more straightforward to not use a dreg at all
and just NFT_BREAK if nval != 0?

> +static int nft_nth_init(const struct nft_ctx *ctx,
> +			const struct nft_expr *expr,
> +			const struct nlattr * const tb[])
> +{
> +	struct nft_nth *nth = nft_expr_priv(expr);
> +
> +	nth->every = ntohl(nla_get_be32(tb[NFTA_NTH_EVERY]));

I think you have to check if tb[NFTA_NTH_EVERY] is not NULL first.

> +	nth->dreg = nft_parse_register(tb[NFTA_NTH_DREG]);

same here.

> +static const struct nft_expr_ops *
> +nft_nth_select_ops(const struct nft_ctx *ctx,
> +		   const struct nlattr * const tb[])
> +{
> +	if (!tb[NFTA_NTH_DREG] ||
> +	    !tb[NFTA_NTH_EVERY])
> +		return ERR_PTR(-EINVAL);
> +
> +	return &nft_nth_ops;
> +}

Oh, I see -- its already checked here.
But why does nth implement a select_ops in the first place?

Otherwise this looks good to me, except that I think we should consider
putting this in nft_meta.c instead of a new module.
