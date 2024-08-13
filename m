Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E47219E81D
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2024 18:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723573927; cv=none; b=LWOP+4qIGoTpuNUArq9tBr6nWKbsuKSUr4mZEQb1sLRjX1TQZAqBJKp5zaSDBjmM4knBjMvlrbJZ3Q6tFs6nFaAa+mmOJXA82oczv5v76zLPF6l4aNXImqzeIuzBs52LZzg9IuGEjCWWOr5S2AkShor/dH6EiEldAx/HOP4hsW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723573927; c=relaxed/simple;
	bh=PP3BfSOVNwAfs9ZvlXKcvk4AGEqBj19dP4udOnvIdD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AZaDzENhIhpms4KzE1XolfBSwG3vkSBeMxetBm3pLiTdgXP2ztRKAHDbO4V7CLYW4RBfe0/ZT7Z8vV1qBWh2DrGeq8ip6a1wrCqs1h/493CeBj8GxcV4u/dlbc6DpbfjC47gfO+G306QM61nTA3vj5a/IthjRruEfhHjBs+C7I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sdwJO-0003nL-C5; Tue, 13 Aug 2024 20:32:02 +0200
Date: Tue, 13 Aug 2024 20:32:02 +0200
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, Eric Dumazet <edumazet@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [netfilter-core] [Q] The usage of xt_recseq.
Message-ID: <20240813183202.GA13864@breakpoint.cc>
References: <20240813140121.QvV8fMbm@linutronix.de>
 <20240813143719.GA5147@breakpoint.cc>
 <20240813152810.iBu4Tg20@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813152810.iBu4Tg20@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> > > Would it work to convert the counters to u64_stats_sync? On 32bit
> > > there would be a seqcount_t with preemption disabling during the
> > > update which means the xt_write_recseq_begin()/ xt_write_recseq_end()
> > > has to be limited the counter update only. On 64bit architectures there
> > > would be just the update. This means that number of packets and bytes
> > > might be "off" (the one got updated, the other not "yet") but I don't
> > > think that this is a problem here.
> > 
> > Unfortunately its not only about counters; local_bh_disable() is also
> > used to prevent messing up the chain jump stack.
> 
> Okay. But I could get rid of the counters/ seqcount and worry about the
> other things later on?

Unfortunately no, see xt_replace_table().  A seqcnt transition is seen
as "done" signal for releasing the ruleset.

See d3d40f237480 ("Revert "netfilter: x_tables: Switch synchronization to RCU"")
and its history.

First step would be to revert back to rcu and then replace
synchronize_rcu with call_rcu based release of the blob.

Or, just tag the x_tables traversers as incompatible with
CONFIG_PREEMPT_RT in Kconfig...

Its possible to build a kernel that can support iptables-nft
(iptables-over-nftables api) but not classic iptables, so the
problematic table traverse code isn't built.

> So jumpstack. This is exclusively used by ipt_do_table(). Not sure how a
> timer comes here but I goes any softirq (as in NAPI) would do the job
> without actually disabling BH.

Think eg. tcp retransmit timer kicking in while kernel executed ip
output path on behalf of write() on some socket.

We're in process context, inside ipt_do_table, local_bh_disable is
needed to delay sirq from coming in at wrong time due to pcpu jumpstack
area.

> Can this be easily transformed to the on-stack thingy that nft is using
> or is it completely different?

In first step, blob validation needs to be changed to validate that jump
depth can't exceed 16 (i.e. 64byte extra scratch space on stack for
storage of return addresses).

Then it could be updated. It will probably break some test cases but
I don't think there are real production rulesets that would fail to load
with a chainstack limit of 16.

> local_lock_nested_bh() would be the easiest to not upset anyone but this
> is using hand crafted per-CPU memory instead of alloc_percpu(). Can
> stacksize get extremely huge?

Classic iptables allows as many calls as there are jumps in the ruleset,
so theroretically they can be huge.
If that happens outside of test case scripts -- i do not think so.
