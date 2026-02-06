Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3305E1990A7;
	Fri,  6 Feb 2026 02:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770343698; cv=none; b=o/IkIWe9nmjqK/knh3lkCt85o8OESJn7HafiT3X/ePqIQ9MdxJ9yXYBE0R5a71gDq7sZ/8+XZqRS8v+Sv7AFhGvwuXjGrJzqebNOtmAT6nvezrTVESDM6D2qVOADJKYbr000MJ39Zp6jX+1ee3aV6vZo9WZlzcerO3X/e8VrJwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770343698; c=relaxed/simple;
	bh=NNqNSBIEKaMhKPJVnthPKVvyYmlG3Jj11Yy7qbSoS8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhZVX7n5/Ub41hs56+Tx1xMLw8WCvCjeZBwGZR3ZwDJqhO7Oer07pa1CM57QiSbsEe+dkZ8kR9FC8WzoPphWbe18MxH0WkNY7Gh8Li/CEb+BseuX9j717kMyS7N7lSW5QZYQosIHieRSSBaYl+XAcmbKQYooRJrpq+/rpZhfdv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hgbaSie3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hgbaSie3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A320CC4AF0B;
	Fri,  6 Feb 2026 02:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770343698;
	bh=NNqNSBIEKaMhKPJVnthPKVvyYmlG3Jj11Yy7qbSoS8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgbaSie38RQZC+cVHJoASO7MDtUEFKqKAwRxFH5bymn+9YMTCkDtonzqGjBOLmCbV
	 b/7o7ewf8+fc6L66OevFOHoJc13C0VdTyyMGXgjYGbxYo4kOl3UPOq04cy5i8Yvpqg
	 97Jt/nyIGu0GjwiXyeJ/SYxl3kVupDJnlz1lmEpHgdxCna1OLXMQggJ+ZNhQll/PMb
	 40hOr0kg9f7gyvVcyUqSszxYh1bl33OMO5u/iaefqVD29VnpB/kW2fizntM6EIsewB
	 3Ilah4WNYP6O6JN+61a7aqvFdyoJeBF9heu+i4UfJjG/fLl+SfFads5nXBoh8leuHM
	 bhjeFdBMkaVaw==
From: Jakub Kicinski <kuba@kernel.org>
To: fw@strlen.de
Cc: Jakub Kicinski <kuba@kernel.org>,
	edumazet@google.com,
	davem@davemloft.net,
	pablo@netfilter.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [net-next,10/11] netfilter: nft_set_rbtree: validate open interval overlap
Date: Thu,  5 Feb 2026 18:08:16 -0800
Message-ID: <20260206020816.3174524-1-kuba@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260205110905.26629-11-fw@strlen.de>
References: <20260205110905.26629-11-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.

For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
---
netfilter: nft_set_rbtree: validate open interval overlap

This patch adds validation for open interval overlaps in the nft_set_rbtree
implementation. It introduces a flag field to struct nft_set_elem to track
when processing the last element in add/delete commands, using this in
combination with a start element cookie to detect partial overlaps.

Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")

> diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> --- a/net/netfilter/nft_set_rbtree.c
> +++ b/net/netfilter/nft_set_rbtree.c

[ ... ]

> @@ -459,7 +477,26 @@
>  	if (rbe_ge && !nft_rbtree_cmp(set, new, rbe_ge) &&
>  	    nft_rbtree_interval_start(rbe_ge) == nft_rbtree_interval_start(new)) {
>  		*elem_priv = &rbe_ge->priv;
> -		nft_rbtree_set_start_cookie(priv, rbe_ge);
> +
> +		/* - Corner case: new start element of open interval (which
> +		 *   comes as last element in the batch) overlaps the start of
> +		 *   an existing interval with an end element: partial overlap.
> +		 */
> +		node = rb_first(&priv->root);
> +		rbe = __nft_rbtree_next_active(node, genmask);
> +		if (nft_rbtree_interval_end(rbe)) {
> +			rbe = nft_rbtree_next_active(rbe, genmask);
> +			if (nft_rbtree_interval_start(rbe) &&
                            ^^^

Can nft_rbtree_next_active() return NULL here? Looking at the code, if the
tree contains only a null interval end marker, nft_rbtree_next_active()
would return NULL when there are no more active elements. The subsequent
call to nft_rbtree_interval_start(rbe) would then dereference NULL.

Would it be safer to add a NULL check before accessing rbe?

> +			    !nft_rbtree_cmp(set, new, rbe)) {
> +				if (last)
> +					return -ENOTEMPTY;
> +
> +				/* Maybe open interval? */
> +				open_interval = NFT_RBTREE_OPEN_INTERVAL;
> +			}
> +		}
> +		nft_rbtree_set_start_cookie_open(priv, rbe_ge, open_interval);
> +
>  		return -EEXIST;
>  	}
