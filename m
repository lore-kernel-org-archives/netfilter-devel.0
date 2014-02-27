From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nft_hash: bug fixes and resizing
Date: Thu, 27 Feb 2014 16:06:15 +0000
Message-ID: <20140227160613.GA1399@macbook.localnet>
References: <1393512980-28780-1-git-send-email-kaber@trash.net>
 <1393512980-28780-2-git-send-email-kaber@trash.net>
 <20140227154746.GA26756@thin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	paulmck@linux.vnet.ibm.com
To: Josh Triplett <josh@joshtriplett.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58737 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaB0QGS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:06:18 -0500
Content-Disposition: inline
In-Reply-To: <20140227154746.GA26756@thin>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 27, 2014 at 07:47:46AM -0800, Josh Triplett wrote:
> On Thu, Feb 27, 2014 at 02:56:20PM +0000, Patrick McHardy wrote:
> > 
> > Expansion is triggered when the load factors exceeds 75%, shrinking when
> > the load factor goes below 30%. Both operations are allowed to fail and
> > will be retried on the next insertion or removal if their respective
> > conditions still hold.
> 
> Since this hash table uses chaining, does it really make sense to expand
> at 75% load?  You might just want to expand at 100%, which is even
> easier to check for.  But that seems like a question for benchmarks to
> answer.

Yeah, but the probability of collisions increase greatly as we approach 100%.
It can easily be changed of course.

> This looks correct to me.  Thank you very much for this work!

Thanks a lot for your review.

> One suggestion and one minor micro-optimization (unrelated to the
> algorithm implementation) below.  With those changed:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> > +	nft_hash_for_each_entry(he, he->next) {
> > +		if (nft_hash_data(&he->key, ntbl->size, set->klen) != h)
> > +			continue;
> > +		next = he;
> > +		break;
> > +	}
> 
> > +		nft_hash_for_each_entry(he, tbl->buckets[h]) {
> > +			if (nft_hash_data(&he->key, ntbl->size, set->klen) != i)
> > +				continue;
> > +			RCU_INIT_POINTER(ntbl->buckets[i], he);
> > +			break;
> > +		}
> 
> In both of these cases, you could reverse the sense of the if with
> s/!=/==/, move the "statement; break;" into the if, and the continue
> would become redundant.  (You then wouldn't even need the braces around
> the loop body.)

Yeah, but if possible I always try to write inner loops in the style of
"filter out everything uninteresting", "do something with the rest".
The main reason is do avoid deep indentation. I guess it doesn't matter
since for the compiler these should be equivalent.

> Second, in the load-factor calculation:
> 
> > +	/* Expand table when exceeding 75% load */
> > +	if (tbl->elements * 4 / 3 > tbl->size)
> > +		nft_hash_tbl_expand(set, priv);
> 
> I just checked, and GCC ends up using an imul to implement this, due to
> the division by 3.  I'd suggest rewriting it to:
> 
> if (tbl->elements > (tbl->size >> 2) * 3)
> 
> Dividing tbl->size by 4 first avoids the possibility of integer
> overflow, and GCC translates the *3 into a single lea instruction.

Thanks, I'll change that.

> (Also, do you need an NFT_HASH_MAX_SIZE here?)
> 
> Similar considerations apply to the calculation for shrinking.

I think we should be fine without a maximum. The size calculation for
memory allocation is done using 64 bits, so it won't overflow. If the
size gets too big, memory allocation will simply fail and we'll keep
the old table. However adding a vmalloc fallback should probably be
done, it will get into sizes where kmalloc might frequently fail quite
quickly.

Thanks again!
