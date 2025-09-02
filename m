Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB48275AFA
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 22:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756851698; cv=none; b=WFBN+zGUtG4SvA1W3PXcZNs/dW3FOr9kaRsWYKrs7Aub89K3h46Q69MjIbSkLkMnCw9/AqpchbHohRhiY3M/GqiFsSaxypADlVj7I1Pu7dcF5+X9PBsdigIupgwiuAEmoJko4knFW9GBjfxjROfyhPeuT9zcLmXr1pdGpS+x4Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756851698; c=relaxed/simple;
	bh=+L75w6KaFIDeoFU+/dWNm+EGyu/oNL0V8gzdkgYOka8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u1ESf5b+Z+y4HrDYAqKvgwrLRA/+natR0LLAlkUZXwfs5BUqL14VjMXS1Pz2xGkzqSe5m4V5eSs/bJNyhczYM4142gTGJFdr6FRirpkT8lTXS8qxJ8tuM6I4NRLl6EduHazEZURoAYxk0hhPK25ehXC/IW3Nq1pdIKdCge7V6mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EAAA76062E; Wed,  3 Sep 2025 00:21:33 +0200 (CEST)
Date: Wed, 3 Sep 2025 00:21:33 +0200
From: Florian Westphal <fw@strlen.de>
To: Nikolaos Gkarlis <nickgarlis@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v2] netfilter: nft_ct: reject ambiguous conntrack
 expressions in inet tables
Message-ID: <aLdt7XRHLBtgPlwA@strlen.de>
References: <CA+jwDRkVb-qQq-PeYSF5HtLqTi9TTydrQh_OQF7tijiQ=Rh6iA@mail.gmail.com>
 <20250902215433.75568-1-nickgarlis@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902215433.75568-1-nickgarlis@gmail.com>

Nikolaos Gkarlis <nickgarlis@gmail.com> wrote:
> The kernel allows netlink messages that use the legacy NFT_CT_SRC and
> NFT_CT_DST keys in inet tables without an accompanying nft_meta
> expression specifying NFT_META_NFPROTO. This results in ambiguous
> conntrack expressions that cannot be reliably evaluated during packet
> processing.
> 
> When that happens, the register size calculation defaults to IPv6 (16
> bytes) regardless of the actual packet family.
> 
> This causes two issues:
> 1. For IPv4 packets, only 4 bytes contain valid address data while 12
>    bytes contain uninitialized memory during comparison.

I don't think so, they are zeroed out, see nf_ct_get_tuple();
init_conntrack copies the entire thing so I don't see how stack garbage
can be placed in struct nf_conn and thus I don't see how registers can
contains crap.  Do they?  If yes, please provide a bit more information
on how this happens (e.g. kmsan report or similar).

> 2. nft userspace cannot properly display these rules ([invalid type]).

Thats a userspace bug; userspace that makes use of NFT_CT_SRC/DST must
provide the dependency.

This is not the kernels job, the kernel only must make sure that we
can't crash or otherwise leak hidden state (e.g. kernel memory
contents).

> The bug is not reproducible through standard nft commands, which use
> NFT_CT_SRC_IP(6) and NFT_CT_DST_IP(6) keys when NFT_META_NFPROTO is
> not defined.

Thats because not all kernel releases have NFT_CT_DST_IP(6), they were
added later.  Switching userspace will break compatibility with older
kernels.  That said, this key was added in v4.17 so we could change
nftables now to always use NFT_CT_DST_IP(6) instead and avoid adding
the NFPROTO implicit dep for this case.

> Fix by adding a pointer to the parent nft_rule in nft_expr, allowing
> iteration over preceding expressions to ensure that an nft_meta with
> NFT_META_NFPROTO has been defined.

But why?  As far as I can see nothing is broken.

We don't force dependencies for other expressions either, why make
an exception here?

I'm sorry that I did not mention this earlier; in v1 i assumed intent
was to zap unused code (but its still used by nft), hence i did not
mention the above.

> Adding a pointer from nft_expr to nft_rule may be controversial, but
> it was the only approach I could come up with that provides context
> about preceding expressions when validating an expression.

We should not force this unless not doing it causes crash or
other misbehaviour, such as leaking private kernel memory content.

>  struct nft_expr {
>  	const struct nft_expr_ops	*ops;
> +	const struct nft_rule *rule;
>  	unsigned char			data[]
>  		__attribute__((aligned(__alignof__(u64))));

Ouch, sorry, I think this is a non-starter, nft_expr
should be kept as small as possible.

That said, I don't see why its necessary to add this pointer here,
it could be provided via nft_ctx for example.
