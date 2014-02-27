From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH] netfilter: nft_hash: bug fixes and resizing
Date: Thu, 27 Feb 2014 07:47:46 -0800
Message-ID: <20140227154746.GA26756@thin>
References: <1393512980-28780-1-git-send-email-kaber@trash.net>
 <1393512980-28780-2-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	paulmck@linux.vnet.ibm.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:55915 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaB0Pr5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:47:57 -0500
Content-Disposition: inline
In-Reply-To: <1393512980-28780-2-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 27, 2014 at 02:56:20PM +0000, Patrick McHardy wrote:
> The hash set type is very broken and was never meant to be merged in this
> state. Missing RCU synchronization on element removal, leaking chain
> refcounts when used as a verdict map, races during lookups, a fixed table
> size are probably just some of the problems. Luckily it is currently
> never chosen by the kernel when the rbtree type is also available.
> 
> Rewrite it to be usable.
> 
> The new implementation supports automatic hash table resizing using RCU,
> based on Paul McKenney's and Josh Triplett's algorithm "Optimized Resizing
> For RCU-Protected Hash Tables" described in [1].
> 
> Resizing doesn't require a second list head in the elements, it works by
> chosing a hash function that remaps elements to a predictable set of buckets,
> only resizing by integral factors and
> 
> - during expansion: linking new buckets to the old bucket that contains
>   elements for any of the new buckets, thereby creating imprecise chains,
>   then incrementally seperating the elements until the new buckets only
>   contain elements that hash directly to them.
> 
> - during shrinking: linking the hash chains of all old buckets that hash
>   to the same new bucket to form a single chain.
> 
> Expansion requires at most the number of elements in the longest hash chain
> grace periods, shrinking requires a single grace period.
> 
> Due to the requirement of having hash chains/elements linked to multiple
> buckets during resizing, homemade single linked lists are used instead of
> the existing list helpers, that don't support this in a clean fashion.
> As a side effect, the amount of memory required per element is reduced by
> one pointer.
> 
> Expansion is triggered when the load factors exceeds 75%, shrinking when
> the load factor goes below 30%. Both operations are allowed to fail and
> will be retried on the next insertion or removal if their respective
> conditions still hold.

Since this hash table uses chaining, does it really make sense to expand
at 75% load?  You might just want to expand at 100%, which is even
easier to check for.  But that seems like a question for benchmarks to
answer.

> [1] http://dl.acm.org/citation.cfm?id=2002181.2002192
> 
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

This looks correct to me.  Thank you very much for this work!

One suggestion and one minor micro-optimization (unrelated to the
algorithm implementation) below.  With those changed:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> +	nft_hash_for_each_entry(he, he->next) {
> +		if (nft_hash_data(&he->key, ntbl->size, set->klen) != h)
> +			continue;
> +		next = he;
> +		break;
> +	}

> +		nft_hash_for_each_entry(he, tbl->buckets[h]) {
> +			if (nft_hash_data(&he->key, ntbl->size, set->klen) != i)
> +				continue;
> +			RCU_INIT_POINTER(ntbl->buckets[i], he);
> +			break;
> +		}

In both of these cases, you could reverse the sense of the if with
s/!=/==/, move the "statement; break;" into the if, and the continue
would become redundant.  (You then wouldn't even need the braces around
the loop body.)

Second, in the load-factor calculation:

> +	/* Expand table when exceeding 75% load */
> +	if (tbl->elements * 4 / 3 > tbl->size)
> +		nft_hash_tbl_expand(set, priv);

I just checked, and GCC ends up using an imul to implement this, due to
the division by 3.  I'd suggest rewriting it to:

if (tbl->elements > (tbl->size >> 2) * 3)

Dividing tbl->size by 4 first avoids the possibility of integer
overflow, and GCC translates the *3 into a single lea instruction.

(Also, do you need an NFT_HASH_MAX_SIZE here?)

Similar considerations apply to the calculation for shrinking.

- Josh Triplett
