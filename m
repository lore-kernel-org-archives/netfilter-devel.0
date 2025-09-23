Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E80026B2C8
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2025 16:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758645277; cv=none; b=uWXOxjLD0aU0IhEe8wqbV8Z92GQiqQuD35X8BlPCPmbPyQJ/YU9sVZaB7yFfBuQo4d3o0fPvA0g9zOz/3wZzqalsmXVMKKJ4g8UfD8lnOazeo7a+3s5wj/sd2XCRcGHj7G2PvmrLX4gV3neH44KVAalrDh3ncOFnqtNrwZ3RFko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758645277; c=relaxed/simple;
	bh=C1S0iBx0Ky6AC/BEtcB13EWEKziIgw8Xg+uPnoCqw+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T+2uSWkByCVg8YL1sM+FJrbaBcG5MSOrlxorExOpxB6J2C5eB6NSCniJTT936vgzRnUIqwxTbY4QRxgs0mjA4mJ+JPYDYQTMlkRqvC74ux0DIOqP9o6CWQm6hkEWBhh74U9AkIzYufUN+pnEHqxyWveB9ycejJYlm8MSZJSJ9bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1A335618CB; Tue, 23 Sep 2025 18:34:32 +0200 (CEST)
Date: Tue, 23 Sep 2025 18:34:31 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org
Subject: Re: [PATCH RFC nf-next] netfilter: nf_tables: add math expression
 support
Message-ID: <aNLMF2CdcCKWi4cI@strlen.de>
References: <20250923152452.3618-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923152452.3618-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> Historically, users have requested support for increasing and decreasing
> TTL value in nftables in order to migrate from iptables.

Right.

> In addition, it takes into account the byteorder of the value
> stored in the source register, so there is no need to do a byteorder
> conversion before and after the math expression.

Why?  Any particular reason for this?

I would have expected to have ntf insert the needed byteorder
conversions.

> The math expression intends to be flexible enough in case it needs to be
> extended in the future, e.g implement bitfields operations. For this
> reason, the length of the data is indicated in bits instead of bytes.

Not so sure.  We already have nft_bitwise. Or what bitfield operations
are you considering?

You mean 'add' to a non-byte part, like e.g. as in iph->ihl?

> Payload set operations sometimes need 16 bits for checksum
> recalculation. Even it is a 8 bit operation, 16 bits are loaded in the
> source register. Handle such cases applying a bitmask when operating
> with 8 bits length.
> 
> As a last detail, nft_math prevents overflow of the field. If the value
> is already at its limit, do nothing.

Should it set NFT_BREAK?

> table mangle inet flags 0 use 1 handle 5
> inet mangle output use 1 type filter hook output prio 0 policy accept packets 0 bytes 0 flags 1
> inet mangle output 2
>   [ payload load 2b @ network header + 8 => reg 1 ]
>   [ math math 8 bits host reg 1 + 1 => 1]
>   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]

Thanks for including these examples.
You can drop the 'math' from the snprintf callback in libnftnl to avoid
this 'math math'.

I assume this says 'host' because its limited to 8 bits?

> +	/* For payload set if checksum needs to be adjusted 16 bits are stored
> +	 * in the source register instead of 8. Therefore, use a bitmask to
> +	 * operate with the less significant byte. */

I don't think this works.  You don't know if the add should be done
on the less significant byte order the MSB one.

(If you do... how?)

AFAICS you need to add support for a displacement
offset inside the register to support this (or I should write:
work-around-align-fetch-mangling ...)

> +static int nft_math_init(const struct nft_ctx *ctx,
> +			 const struct nft_expr *expr,
> +			 const struct nlattr * const tb[])
> +{
> +	struct nft_math *priv = nft_expr_priv(expr);
> +	int err;
> +
> +	if (tb[NFTA_MATH_SREG] == NULL ||
> +	    tb[NFTA_MATH_DREG] == NULL ||
> +	    tb[NFTA_MATH_LEN] == NULL ||
> +	    tb[NFTA_MATH_OP] == NULL ||
> +	    tb[NFTA_MATH_BYTEORDER] == NULL)
> +		return -EINVAL;

> +	priv->op = nla_get_u8(tb[NFTA_MATH_OP]);

Can you make it NLA_U32?  NLA_U8 doesn't buy anything except
limiting us to 255 supported options (i don't see a use case
for ever having so many, but if we ever have we don't need new OP32
attribute).

I wonder if we really want this as a module, it seems rather small.

I would also be open to just extending bitwise expression with this
inc/dec, both bitwise & math expr do register manipulations.
