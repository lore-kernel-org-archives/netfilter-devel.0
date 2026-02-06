Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2FE1990A7;
	Fri,  6 Feb 2026 02:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770343696; cv=none; b=IY27zEqYyWggGB75EL+2rBhUXYbj5f4/XAozk4S+cjhVMBytBSMvZUoT8IbrZmcqfWbyLWfASUWXXtYV4ayxminvb33aWuw3kHun9KY9iw4AN/wE4YMvBge+kZ67gVBCxqAJkt8jNvV5kY4k/OLJBWMQ1iE2u4zvcLTzhKgjB5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770343696; c=relaxed/simple;
	bh=/rKRkbScWckj9RO40V42ra4DzNR6+Pt+f9DCZrmAymo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9AQ/4ePp0OoZxZ6YIJ3curqpK8RO6UKLxR+c1XRWvQO6IEEXlUdnJ4c75V8Ph2RWP0DlqTg0AnEivNHtOJyRkMdORWa1S+TM4Re9wG8dllbisGqhdJzIeALrp7xze/mATFH0wT9nG24n3cIbTzHc7KdJNA3WQpJf1NQ8u6HvN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XEgzCZpS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XEgzCZpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0324BC4CEF7;
	Fri,  6 Feb 2026 02:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770343696;
	bh=/rKRkbScWckj9RO40V42ra4DzNR6+Pt+f9DCZrmAymo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XEgzCZpSkn6S0y4Uu4/2lUcLMx55O+FsBqS0ASiqi1jQmIpCrH8VX8nR32YFuEEfW
	 uy70aXQJlpfQnmzo/TSy90SxXq7RR5fki40//NQZE28rdfAg2S8Z3dWptVr7a3TP7T
	 hKqxeWuuEDYO7x2od54QbI+HZ5mLHUs7afg9603/q5y/JG3u0imqHemQI4A6+f63Wu
	 z8PGx3kTtKT9Y1Ya95ZFI5dxjXAs4ax4igF05h1TbqfS1ZQLO6E9NcnWS2nRGShCj+
	 WRXtbJGLZJ13QJg09YCkQGbh8zyMOdruRQNwA0dlSa6eYuFaR5o3sgnQNk7tkCnQSN
	 uWq3JeSAEvSVw==
From: Jakub Kicinski <kuba@kernel.org>
To: fw@strlen.de
Cc: Jakub Kicinski <kuba@kernel.org>,
	edumazet@google.com,
	davem@davemloft.net,
	pablo@netfilter.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [net-next,08/11] netfilter: nft_set_rbtree: check for partial overlaps in anonymous sets
Date: Thu,  5 Feb 2026 18:08:14 -0800
Message-ID: <20260206020814.3174481-1-kuba@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260205110905.26629-9-fw@strlen.de>
References: <20260205110905.26629-9-fw@strlen.de>
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
netfilter: nft_set_rbtree: check for partial overlaps in anonymous sets

Userspace provides an optimized representation in case intervals are
adjacent, where the end element is omitted. The existing partial overlap
detection logic skips anonymous set checks on start elements for this
reason. However, it is possible to add intervals that overlap to this
anonymous where two start elements with the same, eg. A-B, A-C where C < B.
This patch restores the check on overlapping start elements to report an
overlap.

> diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> --- a/net/netfilter/nft_set_rbtree.c
> +++ b/net/netfilter/nft_set_rbtree.c
> @@ -251,11 +251,22 @@ static bool nft_rbtree_update_first(const struct nft_set *set,
>  	return false;
>  }
>
> +static struct nft_rbtree_elem *nft_rbtree_prev_active(struct nft_rbtree_elem *rbe)
> +{
> +	struct rb_node *node;
> +
> +	node = rb_prev(&rbe->node);
> +	if (!node)
> +		return NULL;
> +
> +	return rb_entry(node, struct nft_rbtree_elem, node);
> +}
> +

Does nft_rbtree_prev_active() need to check whether the element is
actually active? The function name suggests it should return only active
elements, but it doesn't call nft_set_elem_active() to filter inactive ones.

Looking at the main overlap detection loop in __nft_rbtree_insert()
(lines 311-378), elements are filtered explicitly with 'if
(!nft_set_elem_active(&rbe->ext, genmask)) continue;' to ensure overlap
detection only considers elements that will be active after the commit.

However, when nft_rbtree_prev_active() is called at line 416, it returns
the previous element without checking if it's active. If this element is
inactive (being deleted in the current transaction), should it still affect
overlap detection?

The similar code pattern in nft_rbtree_gc_elem() shows explicit active
checking:

    while (prev) {
        rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
        if (nft_rbtree_interval_end(rbe_prev) &&
            nft_set_elem_active(&rbe_prev->ext, NFT_GENMASK_ANY))
            break;
        prev = rb_prev(prev);
    }

Could an inactive end interval element incorrectly trigger the overlap
check at line 417-418, causing a valid insertion to be rejected with
-ENOTEMPTY during a transaction where an old end element is being deleted
and a new start element is being inserted?

>  static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
>  			       struct nft_rbtree_elem *new,
>  			       struct nft_elem_priv **elem_priv)
>  {
> -	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL;
> +	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL, *rbe_prev;
>  	struct rb_node *node, *next, *parent, **p, *first = NULL;
>  	struct nft_rbtree *priv = nft_set_priv(set);
>  	u8 cur_genmask = nft_genmask_cur(net);

[ ... ]

>  	/* - new start element with existing closest, less or equal key value
>  	 *   being a start element: partial overlap, reported as -ENOTEMPTY.
>  	 *   Anonymous sets allow for two consecutive start element since they
> -	 *   are constant, skip them to avoid bogus overlap reports.
> +	 *   are constant, but validate that this new start element does not
> +	 *   sit in between an existing new and end elements: partial overlap,

This isn't a bug, but the phrase 'existing new and end elements' is
confusing. Should this say 'existing start and end elements' or 'existing
interval's start and end elements'?

> +	 *   reported as -ENOTEMPTY.
>  	 */
> -	if (!nft_set_is_anonymous(set) && rbe_le &&
> -	    nft_rbtree_interval_start(rbe_le) && nft_rbtree_interval_start(new))
> -		return -ENOTEMPTY;
> +	if (rbe_le &&
> +	    nft_rbtree_interval_start(rbe_le) && nft_rbtree_interval_start(new)) {
> +		if (!nft_set_is_anonymous(set))
> +			return -ENOTEMPTY;
> +
> +		rbe_prev = nft_rbtree_prev_active(rbe_le);
> +		if (rbe_prev && nft_rbtree_interval_end(rbe_prev))
> +			return -ENOTEMPTY;
> +	}

The Fixes tag references commit 7c84d41416d8, but wasn't the anonymous set
exception logic ('!nft_set_is_anonymous(set) && rbe_le && ...') actually
introduced by commit c9e6978e2725 ("netfilter: nft_set_rbtree: Switch to
node list walk for overlap detection")? That commit added the check being
modified here. While 7c84d41416d8 introduced the initial overlap detection,
c9e6978e2725 rewrote the logic and added the anonymous set exception that
turned out to be incorrect.
