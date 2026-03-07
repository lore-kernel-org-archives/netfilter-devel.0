Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A290309EF2
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Mar 2026 09:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772874452; cv=none; b=R0VBRSBXGJdHwS0QjNDQK8J+p5sgoB0b4y+doq8SdozmFBSCP2fEjGB1IjxDv03gJQybKr4TOoBS0IwOwW2No53n9UFkF4kGmBotWrP4L0eSiiqg+s4yBnwGgBe0G77cINSrk5Ikn3cBkQOGfZTnSTNXdpbahN6w3W2jn+Fxq2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772874452; c=relaxed/simple;
	bh=rKFBf4ckjppgpn7NKChM0xU0B0atUiplHbgAu9Gx+R0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=frGfd9PMw8Ogb6u6KYmhp7WlcCpDwRnOiu4VPt6WKnFT2WNVmwk4gjQxe/HknB9VRSl4x4n73rjxir8gzsTMeiam6jIbcIWf+ZevqPosgZy/1vAsfapnSLupWffGHnzcWfD3CFt3JorJvUJl42L5qkpgFUpLUBg0f2LJShQgnOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9AFEE60470; Sat, 07 Mar 2026 10:07:22 +0100 (CET)
Date: Sat, 7 Mar 2026 10:07:12 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, carges@cloudflare.com
Subject: Re: [PATCH nf,v2] netfilter: nft_set_rbtree: allocate same array
 size on updates
Message-ID: <aavqwA_H032EaiRg@strlen.de>
References: <20260307001124.2897063-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260307001124.2897063-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> v2: fix crash with new sets, reported by Florian.
> 
>  net/netfilter/nft_set_rbtree.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> index 853ff30a208c..bdcea649467f 100644
> --- a/net/netfilter/nft_set_rbtree.c
> +++ b/net/netfilter/nft_set_rbtree.c
> @@ -646,7 +646,12 @@ static int nft_array_may_resize(const struct nft_set *set)
>  	struct nft_array *array;
>  
>  	if (!priv->array_next) {
> -		array = nft_array_alloc(nelems + NFT_ARRAY_EXTRA_SIZE);
> +		if (priv->array)
> +			new_max_intervals = priv->array->max_intervals;
> +		else
> +			new_max_intervals = NFT_ARRAY_EXTRA_SIZE;
> +
> +		array = nft_array_alloc(new_max_intervals);
>  		if (!array)
>  			return -ENOMEM;
>  

I wonder if rbtree code should try harder to compact memory.

We can't defer allocation to commit hook because commit hook can't fail.
But its the only location where we know the exact memory size needed:

1. To-be-removed elements have been unlinked from the tree
2. Expired elements have been unlinked too

So, after the tree walk, num_intervals is the actual needed count and
no longer a worst-case estimate.

What if this would check num_intervals vs.
priv->array_next->num_intervals, and, if the difference is say, more
than 10% or more than 1 page of memory, try to allocate a better size?

If the allocation fails, too bad, use the existing one.
If it works, copy the elements over, free the larger allocation and
use the "better fit".

netlink has similar approach via netlink_trim() to avoid stuffing
large allocations into socket queues.

An even better way would be to just kvrealloc() but in the vmalloc case
this code path doesn't shrink the VM area in case new requested size
is smaller than the existing one, so that would require work on mm side
first.

One issue is that if you have a large rbtree, and the userspace pattern
is:

"flush set t s; add element t s { $huge }" then rbtree will roughly have
double the memory size that it would actually need: it will
first allocate the existing element size, then continue to realloc to
accomodate the new incoming elements, but, since the flush only takes
effect post-commit, can't account for the reduced size post-commit.
