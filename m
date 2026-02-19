Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB403093C7;
	Thu, 19 Feb 2026 15:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771514247; cv=none; b=dHMXVMrR0sPwwUg3znYHxZHqiRr6602AVLbtu5Vmb4Yz38uABsI8v5lyAbDUbEcVUMJGdnPRAMC3kbV0WDdmFWpxlmFSH/6hviUDLjB8HSXoxl6GYM+OtGlwiTj4KuF/bWno7xANJOXc2Ie8jOSI3/EA5LCheCD68PifT3j4CoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771514247; c=relaxed/simple;
	bh=b9RQPVQ5oD2+Bjr8jIIXQ1dZ7RNrldg5dBlsqD41uV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HHgtHDB5TxcVv/8HEdhs32oBHS5Hd+sQVeOt82qpWfoAJEqYt5vEoZGqlz3YD7mmaD0YSq8DzxU4ohEh3/BtkHBHplLvYFIVSjr9nr6ly78Mk0TdNJlGBgGzRwmPMf/SEANnjKybh8n1wYi54cnI6ePRfQ1hBq/Cc0uZncE6fQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6BBD360345; Thu, 19 Feb 2026 16:17:23 +0100 (CET)
Date: Thu, 19 Feb 2026 16:17:19 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: syzbot <syzbot+4924a0edc148e8b4b342@syzkaller.appspotmail.com>,
	coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pabeni@redhat.com, phil@nwl.cc, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] WARNING in nft_map_deactivate
Message-ID: <aZcpf7Bek9mokzU0@strlen.de>
References: <6996dd95.050a0220.21cd75.010c.GAE@google.com>
 <aZcBeD8NCE5k7zeC@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZcBeD8NCE5k7zeC@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This is an interval set allocating a new array that is allocated with
> GFP_KERNEL (rbtree/pipapo follow a similar approach), I suspect fault
> injection is making this memory allocation fail.
> 
> Then, this WARN_ON_ONCE below triggers:
> 
> static void nft_map_deactivate(const struct nft_ctx *ctx, struct nft_set *set)
> {               
>         struct nft_set_iter iter = {
>                 .genmask        = nft_genmask_next(ctx->net),
>                 .type           = NFT_ITER_UPDATE,
>                 .fn             = nft_mapelem_deactivate,
>         };
>         
>         set->ops->walk(ctx, set, &iter);
>         WARN_ON_ONCE(iter.err);
> 
> For the traceback below, it should be possible to add NFT_ITER_RELEASE
> to skip the allocation.

Agreed.

> But there are other paths where this can happen too, I am looking into
> making these nft_map_activate/nft_map_deactivate function never fail
> in the second stage, this is the idea:
> 
> - For anonymous sets, the allocation (clone) can be skipped since they
>   are immutable.

Right, there is no need to clone anon sets.

> - For non-anonymous sets, add a .clone interface to nft_set_ops so
>   the clone is not done from the 

Yes, that would help.  However, I'm not sure its needed.
For 2nd stage that cannot fail, all inserts/deletes already completed,
i.e. there is already a clone present that is re-used, no new clone
happens.

The only exception that I can see is the "release" case you mention.
In that case, we had no delete or add, so the clone pointer is NULL.

With a new iter type we could detect this and just re-use the live
copy instead of making an unnecessary copy.

Or did I miss something?
