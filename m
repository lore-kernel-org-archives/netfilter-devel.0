Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0843054E4;
	Thu, 23 Jul 2026 07:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784791987; cv=none; b=D/382WSoMkiVu7enOz6bQ2HjQb6p7uxa2R3IFOovth6euIkCjlRvAX6qB8Hj+QAm2FmV16t7KDR2tM1Pas3Gx/cc+XkbPTDrpif9JdI6G6z/ltrBkwJmAwYdkOsLvlKlygJx/JH4cYIY+czZNTEVztmQvYCxF5UBU4f9nd8+oIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784791987; c=relaxed/simple;
	bh=z88kpxOsECs9l4oqBFZzOKwluNP3d/NLkQvaOVLzbNw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=dkFNGsUX3X2Rdd0zDp0JkR2TP4fAEivqJfal17odYx2W0R0RuE+h/ycvfE+5lfwgYwecVmZbgTEu2O//MTuen4JikFvNjBsM95wgigoAKfn1Q3LN0PLUuJR9KGreIEVyI4WKxrLZpUpylqI0WOo6rNBwCgT2oDrcvg3sPFAS6R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=tpDWvC4+; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="tpDWvC4+"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4h5NBb1xtNzGFDSd;
	Thu, 23 Jul 2026 09:32:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1784791973; x=1786606374; bh=HefT0Bdgxr
	rPUweBq36PrXGzdVDS+bmFrL4j/Y/5O8w=; b=tpDWvC4+xkKzS5XBGBLZT6fKb/
	h3K0teIxCG5zg1NqgJfkKyjlefuaG5l65rXQRIhdCJMMoTepmUlwLfcyavz2pgX0
	hRojuXnJfx7f7/TzyiObKiPU8Zc8snfs2BpsRtP3EKuAvPZs0d82YWa/r1fwxUld
	kgsvOT715pfmFWtp4=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id heTxlvTmL4RU; Thu, 23 Jul 2026 09:32:53 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4h5NBW65M2zGFDSW;
	Thu, 23 Jul 2026 09:32:51 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 82CB034316E; Thu, 23 Jul 2026 09:32:51 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 813C634316D;
	Thu, 23 Jul 2026 09:32:51 +0200 (CEST)
Date: Thu, 23 Jul 2026 09:32:51 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: "Xiang Mei (Microsoft)" <xmei5@asu.edu>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
    Phil Sutter <phil@nwl.cc>, "David S . Miller" <davem@davemloft.net>, 
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
    Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
    Jozsef Kadlecsik <kadlec@netfilter.org>, netfilter-devel@vger.kernel.org, 
    coreteam@netfilter.org, netdev@vger.kernel.org, 
    linux-kernel@vger.kernel.org, AutonomousCodeSecurity@microsoft.com, 
    tgopinath@linux.microsoft.com, kys@microsoft.com
Subject: Re: [PATCH nf] netfilter: ipset: fix refcount race between list:set
 GC and swap
In-Reply-To: <20260722223832.3524006-1-xmei5@asu.edu>
Message-ID: <fd5dcd37-c4f8-94de-6fa2-01d30427f63e@blackhole.kfki.hu>
References: <20260722223832.3524006-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Wed, 22 Jul 2026, Xiang Mei (Microsoft) wrote:

> __ip_set_put_byindex() resolved the index to a set pointer under RCU,
> then took ip_set_ref_lock in __ip_set_put() to decrement set->ref.
> ip_set_swap() holds that same lock while swapping both the ip_set_list
> slots and the two sets' ref counters, so it can interleave between the
> dereference and the lock acquisition, leaving the caller to decrement a
> set whose reference already moved to the other index and hit
> BUG_ON(set->ref == 0). list_set_gc() reaches this from timer softirq,
> which the nfnl mutex does not serialize against swap: an expiring
> list:set member calls list_set_del() -> ip_set_put_byindex() while
> IPSET_CMD_SWAP runs on the referenced sets.
>
> Resolve the index and decrement under ip_set_ref_lock, as ip_set_swap()
> already does, keeping the refcount tied to the index rather than to a
> stale set pointer.
>
>  kernel BUG at net/netfilter/ipset/ip_set_core.c:685!
>  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>  RIP: 0010:ip_set_put_byindex (net/netfilter/ipset/ip_set_core.c:870)
>  Call Trace:
>   <IRQ>
>   list_set_del (net/netfilter/ipset/ip_set_list_set.c:159)
>   set_cleanup_entries (net/netfilter/ipset/ip_set_list_set.c:181)
>   list_set_gc (net/netfilter/ipset/ip_set_list_set.c:578)
>   call_timer_fn (kernel/time/timer.c:1748)
>   __run_timers (kernel/time/timer.c:1799 kernel/time/timer.c:2374)
>   run_timer_softirq (kernel/time/timer.c:2405)
>   </IRQ>
>  Kernel panic - not syncing: Fatal exception in interrupt
>
> Fixes: 9076aea76538 ("netfilter: ipset: Increase the number of maximal sets automatically")
> Reported-by: AutonomousCodeSecurity@microsoft.com
> Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Best regards,
Jozsef

> ---
> net/netfilter/ipset/ip_set_core.c | 19 +++++++++++++------
> 1 file changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index 6cfad152d7d1..16d33c3e28cf 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -679,11 +679,18 @@ __ip_set_get(struct ip_set *set)
> }
>
> static void
> -__ip_set_put(struct ip_set *set)
> +__ip_set_put_locked(struct ip_set *set)
> {
> -	write_lock_bh(&ip_set_ref_lock);
> +	lockdep_assert_held(&ip_set_ref_lock);
> 	BUG_ON(set->ref == 0);
> 	set->ref--;
> +}
> +
> +static void
> +__ip_set_put(struct ip_set *set)
> +{
> +	write_lock_bh(&ip_set_ref_lock);
> +	__ip_set_put_locked(set);
> 	write_unlock_bh(&ip_set_ref_lock);
> }
>
> @@ -854,11 +861,11 @@ __ip_set_put_byindex(struct ip_set_net *inst, ip_set_id_t index)
> {
> 	struct ip_set *set;
>
> -	rcu_read_lock();
> -	set = rcu_dereference(inst->ip_set_list)[index];
> +	write_lock_bh(&ip_set_ref_lock);
> +	set = ip_set(inst, index);
> 	if (set)
> -		__ip_set_put(set);
> -	rcu_read_unlock();
> +		__ip_set_put_locked(set);
> +	write_unlock_bh(&ip_set_ref_lock);
> }
>
> void
> -- 
> 2.43.0
>
>
>
