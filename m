Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70EF38002F
	for <netfilter-devel@vger.kernel.org>; Tue, 14 May 2024 11:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686510; cv=none; b=abX2EgUQytZsFKEZ76iAWJhyyN3hmHhQdueyS+rqOcnYGE5qFzHUsHwWp7CrM5qRvQV18HLRCk+bXkEwu8jyALbCBzGrUshHieXjHZE5J9u8c80DzURnZ/SfNaUvTtcv48fHLOnfAxuvhWI/5rDc9OhwsPb7hhfqWlb2rJIX9HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686510; c=relaxed/simple;
	bh=nL9F6aDy61vWiqMet7huJJL2cBnVym6ZyVehnoMWjLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sAcltblVeOWxn99M0K3kp3ba9YnD1s5fxufIP0YcU6rQXnNB7LSsEGEDM7lgxtMm5HmKxSz1ADF/ZL7toRqNmTX2Jb2PeVMPPoXXWl06D+92Uuzggw2kc/fIodlM+QvIzuQ1fwBX08Kb8i7WU2/Qngp84/xCGaarDr2g4apB2e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Tue, 14 May 2024 13:34:57 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Yi Chen <yiche@redhat.com>
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: fix rcu splat on program
 exit
Message-ID: <ZkNMYQ1u2zJhlviL@calendula>
References: <20240514103133.2784-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240514103133.2784-1-fw@strlen.de>

Hi Florian,

On Tue, May 14, 2024 at 12:31:30PM +0200, Florian Westphal wrote:
> If userspace program exits while the queue its subscribed to has packets
> available we get following (harmless) RCU splat:
> 
>  net/netfilter/nfnetlink_queue.c:261 suspicious rcu_dereference_check() usage!
>  other info that might help us debug this:
>  rcu_scheduler_active = 2, debug_locks = 1
>  2 locks held by swapper/0/0:
>   #0: (rcu_callback){....}-{0:0}, at: rcu_core
>   #1: (&inst->lock){+.-.}-{3:3}, at: instance_destroy_rcu
>  [..] Call Trace:
>   lockdep_rcu_suspicious+0x1ab/0x250
>   nfqnl_reinject+0x5d3/0xfb0
>   instance_destroy_rcu+0x1b5/0x220
>   rcu_core+0xe32 [..]
> 
> This is harmless because the incorrectly-obtained pointer will not be
> dereferenced in case nfqnl_reinject is called with NF_DROP verdict.
> 
> Fix this by open-coding skb+entry release without going through
> nfqnl_reinject().  kfree_skb+release_ref is exactly what nfql_reinject
> ends up doing when called with NF_DROP, except that it also does a
> truckload of other things that are irrelevant for DROP.
> 
> A similar warning can be triggered by flushing the ruleset while
> packets are being reinjected.
> 
> This is harmless as well, the WARN_ON_ONCE() should be removed.
> 
> Reported-by: Yi Chen <yiche@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Due to MR cloed this patch is actually vs nf-next tree.
>  It will also conflict with the pending sctp checksum patch
>  from Antonio Ojea (nft_queue.sh), I can resend if needed once
>  Antonios patch is applied (conflict resulution is simple: use
>  both changes).

I can route this through nf.git and deal with conflict resolution if
you prefer it that way.

Thanks.
