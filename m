From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] netfilter: nft_hash: bug fixes and resizing
Date: Fri, 7 Mar 2014 11:49:02 +0100
Message-ID: <20140307104902.GA12188@localhost>
References: <1393946511-28174-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, josh@joshtriplett.org,
	paulmck@linux.vnet.ibm.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47373 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbaCGKtH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:49:07 -0500
Content-Disposition: inline
In-Reply-To: <1393946511-28174-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 04, 2014 at 04:21:51PM +0100, Patrick McHardy wrote:
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

Applied, thanks Patrick.
