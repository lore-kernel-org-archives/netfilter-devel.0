Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3A933509B;
	Sat, 22 Aug 2026 19:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787428351; cv=none; b=UpuQ79+FWof34L3aKkrP/I/ds2Xu89JoX9SQPe9UE28jQed+A/olN4Ktfh96YgCoB9LYXXq54+TGaNeQn42ArIO7ZLkdOs23TpCcbyK89j2zTk2U8hkQT/8RFzWAjiYdxw7LwxNia3MYKAyQcKTU0DHPqIq8x/G8GL8hZ8m3zp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787428351; c=relaxed/simple;
	bh=fbqjlq/oRv8id+yKRqwSGqwvTNNBwD+1Ik2oSTIEEd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJzcpI010vXM4KIMTf+UcC/LHAVIaFcAgmm7zNhCV7raJzv0mIKssqppXJusFEW+PGhSKo686gbzqOaS2kGs6il3FDpiGB4+KjD2UciLGkbG+4Lx1p7PJ1GG+dtnuYZzIl0qiSOC65jp0rRTNlco4vDNgGAgWPVf94/GnlvlEyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NZlAJ+0w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NZlAJ+0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879AA1F00A3A;
	Sat, 22 Aug 2026 19:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787428349;
	bh=1y/Ij/7CBNXG9SnFyyOZBy8FkjITm7Iy9qRrD7huDyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZlAJ+0w1b5DX27yxKcXkR6RY0ZytKR5mGCDDD6dGIoogokeK09OF01Ej0TQJZKzA
	 k2ATLmLmOBXpK18ReCAjqNN2CYRb/2qjH2AnZJzI97sK9D6fny9C5jAFlW416s/wup
	 IhxAZFWRVvQtr3imLG5vXz+98GQGxLn6QJW7hgS99BP8ZtADxJ0Yb6kM7VEIa+VADa
	 uoBpWffBPxI0vzrhBcXVceU9uVAPviK87aKmGhZpuosUJ34Bk4vRabxy2TEgY7chkg
	 M9X2G513NVh2+WHCUdukGit9im4Rvp1EDBMiArtZEfgjA0NSc5YedYfjwqmAyHZc7o
	 7UOC02c6Ecfjg==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: Re: [PATCH net 07/10] netfilter: nf_tables: skip double clone set expressions on element insert
Date: Sat, 22 Aug 2026 12:52:28 -0700
Message-ID: <20260822195228.2202729-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260821153833.245589-8-pablo@netfilter.org>
References: <20260821153833.245589-8-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
netfilter: nf_tables: skip double clone set expressions on element insert

This adds an override_exprs flag so that the dynset and newsetelem paths
borrow the set's expressions instead of cloning them when userspace does
not supply an override, and releases the expression array only when it
really is an override.  The same flag is now used to decide whether the
dynset expression override is dumped back to userspace.

> diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
> index ee9d3e7b1ecf1..fa4da694e92d8 100644
> --- a/net/netfilter/nft_dynset.c
> +++ b/net/netfilter/nft_dynset.c
> @@ -19,7 +19,8 @@ struct nft_dynset {
>  	u8				sreg_key;
>  	u8				sreg_data;
>  	bool				invert;
> -	bool				expr;
> +	bool				expr:1,
> +					override_exprs:1;
>  	u8				num_exprs;
>  	u64				timeout;
>  	struct nft_expr			*expr_array[NFT_SET_EXPR_MAX];

[ ... ]

> @@ -393,7 +398,7 @@ static int nft_dynset_dump(struct sk_buff *skb,
>  			 nf_jiffies64_to_msecs(priv->timeout),
>  			 NFTA_DYNSET_PAD))
>  		goto nla_put_failure;
> -	if (priv->set->num_exprs == 0) {
> +	if (priv->set->num_exprs == 0 || priv->override_exprs) {
>  		if (priv->num_exprs == 1) {
>  			if (nft_expr_dump(skb, NFTA_DYNSET_EXPR,
>  					  priv->expr_array[0], reset))

[Severity: Medium]
Can the message emitted by nft_dynset_dump() after this change be rejected
by nft_dynset_init() when it is replayed?

With the widened condition, a dynset attached to a set that owns
expressions (set->num_exprs > 0) now dumps its override.  For
priv->num_exprs > 1 that override is emitted as an NFTA_DYNSET_EXPRESSIONS
nest:

net/netfilter/nft_dynset.c:nft_dynset_dump() {
	...
	u32 flags = priv->invert ? NFT_DYNSET_F_INV : 0;
	...
	} else if (priv->num_exprs > 1) {
		struct nlattr *nest;

		nest = nla_nest_start_noflag(skb, NFTA_DYNSET_EXPRESSIONS);
	...
	if (nla_put_be32(skb, NFTA_DYNSET_FLAGS, htonl(flags)))
	...
}

The dumped NFTA_DYNSET_FLAGS is computed only from priv->invert, so
NFT_DYNSET_F_EXPR is never set, even though priv->expr records that
userspace passed it at creation time.  On the parse side the
NFTA_DYNSET_EXPRESSIONS branch requires that flag:

net/netfilter/nft_dynset.c:nft_dynset_init() {
	...
	} else if (tb[NFTA_DYNSET_EXPRESSIONS]) {
		...
		if (!priv->expr)
			return -EINVAL;
	...
}

So a rule with two override expressions on an NFT_SET_EVAL set that also
has two set expressions (for example counter plus quota) appears to be
dumped in a form that the kernel's own parser refuses with -EINVAL when the
netlink message is sent back (raw netlink echo, or libnftnl parse-then-build
restore paths).  Before this patch that configuration emitted no expression
attributes at all, so the replay was accepted and silently fell back to the
set's expressions.

The missing NFT_DYNSET_F_EXPR in the dump path predates this patch (it is
already reachable for priv->set->num_exprs == 0 with more than one
expression), but the new condition extends the asymmetry to
override-on-eval-set rules that used to round-trip.  Should
nft_dynset_dump() also report NFT_DYNSET_F_EXPR when priv->expr is set?
