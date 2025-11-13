Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FBB301711;
	Thu, 13 Nov 2025 15:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763049304; cv=none; b=m75iEo3oKbDE+xklqYdU7zNNrKW4/yvJsCtqjs33TPXov6amy0FiCuGdNQm+ygFu7tPTIerA7UumgKEdhnLslK82F3AubeQqwCe5Y/ur5MDDJTW+lNjBW4C2OfTBeAksyvprdSa/LqBVgSdMJeW9TRnJyF0FyoYs1yJfLaUWKm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763049304; c=relaxed/simple;
	bh=EjXSmLiUdXFBXpX5/NEfOVUg7CczcI2HaegUvvuil2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oW3VjS1Tbd3BJv14CC0mwFZcJk58jTBzpA5y44+1CIVUrA30KIezpkP1jpo5R5QA+h9I+elNT0Avqac0t08lPfWC47s+Xz2UEIMSEmEfJHqtWogXQYlTBNENZ1ZTonVJkjSIjVYfDuVfFu+hSUcWqB3NRdhCJr1CZhRHMMDzdCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 621A86039D; Thu, 13 Nov 2025 16:55:00 +0100 (CET)
Date: Thu, 13 Nov 2025 16:55:00 +0100
From: Florian Westphal <fw@strlen.de>
To: Scott Mitchell <scott.k.mitch1@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] netfilter: nfnetlink_queue: optimize verdict lookup
 with hash table
Message-ID: <aRX_VP61EqRM-8z7@strlen.de>
References: <20251113153220.16961-1-scott_mitchell@apple.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113153220.16961-1-scott_mitchell@apple.com>

Scott Mitchell <scott.k.mitch1@gmail.com> wrote:
> +static int
> +nfqnl_hash_resize(struct nfqnl_instance *inst, u32 hash_size)
> +{
> +	struct hlist_head *new_hash, *old_hash;
> +	struct nf_queue_entry *entry;
> +	unsigned int h, hash_mask;
> +
> +	hash_size = nfqnl_normalize_hash_size(hash_size);
> +	if (hash_size == inst->queue_hash_size)
> +		return 0;
> +
> +	new_hash = kvcalloc(hash_size, sizeof(*new_hash), GFP_KERNEL_ACCOUNT);

This doesn't work, please re-test with LOCKDEP enabled before sending
next version.

> +	inst->queue_hash = kvcalloc(hash_size, sizeof(*inst->queue_hash),
> +				    GFP_KERNEL_ACCOUNT);

.. and this doesn't work either, we are holding rcu read lock and
the queue instance spinlock, so we cannot do a sleeping allocation.

That said, I don't see a compelling reason why rcu read lock is held
here, but resolving that needs prep work :-/

So there are only two choices:
1. add a prep patch that pushes the locks to where they are needed,
   the rebase this patch on top
2. use GFP_ATOMIC like in v1 and update comment to say that
   GFP_KERNEL_ACCOUNT would need more work to place allocations
   outside of the locks.
