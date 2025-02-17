Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37617224882;
	Mon, 17 Feb 2025 15:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739806555; cv=none; b=J64leKSoHcbQjiMUTZjbQUZ+oxraYOOB61VIcXQBSWXYQ8eQYJkYnU/RiyG6fvzlyyjivhal3FMuBwFGQWyWljeukbSUES1AYwCqzDuylyePQLpTfQl7TXAagVEItY+odN4xEZ89QAODHqHP6VdYT5QG9f6KSoMJAAwaneQJO7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739806555; c=relaxed/simple;
	bh=CslOwEGcoHCDIc3lDU7/yIqxpIhayI/qjaLq+AXFNVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wj0sb06KFlX2/yT9a6ltYLjxB8wmQDqgXBUiX4LBRBD0oY1X/fOA9vmJWTXfb+dYghxT7A2X11lBc8aX5hukbi/g4DhuuPNNQ7OJxQYMd7yC+ISOcD7ZKPnvcaqpQcYIgY8IWujzGK9iKqdIlc3X7AOJk2tD8W9zJ9iUlcC/ZzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tk39w-0005Fs-66; Mon, 17 Feb 2025 16:35:48 +0100
Date: Mon, 17 Feb 2025 16:35:48 +0100
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 1/3] netfilter: Make xt_table::private RCU
 protected.
Message-ID: <20250217153548.GB16351@breakpoint.cc>
References: <20250216125135.3037967-1-bigeasy@linutronix.de>
 <20250216125135.3037967-2-bigeasy@linutronix.de>
 <20250217140538.GA16351@breakpoint.cc>
 <20250217145754.KVUio79e@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250217145754.KVUio79e@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> > > This can also be achieved with RCU: Each reader of the private pointer
> > > will be with in an RCU read section. The new pointer will be published
> > > with rcu_assign_pointer() and synchronize_rcu() is used to wait until
> > > each reader left its critical section.
> > 
> > Note we had this before and it was reverted in
> > d3d40f237480 ("Revert "netfilter: x_tables: Switch synchronization to RCU"")
> > 
> > I'm not saying its wrong, but I think you need a plan b when the same
> > complaints wrt table replace slowdown come in.
> > 
> > And unfortunately I can't find a solution for this, unless we keep
> > either the existing wait-scheme for counters sake or we accept
> > that some counter update might be lost between copy to userland and
> > destruction (it would need to use rcu_work or similar, the xt
> > target/module destroy callbacks can sleep).
> 
> Urgh. Is this fast & frequent update a real-world thing or a benchmark
> of some sort? I mean adding rule after rule is possible but…

No idea, its certainly bad design (iptables-restore exists for a
reason).

> I used here synchronize_rcu() and there is also
> synchronize_rcu_expedited() but I do hate it. With everything.

Agreed.

> What are the counters used in userland for? I've seen that they are
> copied but did not understood why.
>   iptables-legacy -A INPUT -j ACCEPT
> ends up in xt_replace_table() but iptables-nft doesn't. Different
> interface, better design? Or I just used legacy and now it is considered
> as the only?

iptables-nft uses the nftables netlink API, I don't think it suffers
from the preempt_rt issues you're resolving in the setsockopt api.

It won't go anywhere near xt_replace_table and it doesn't use the
xtables binary format on the user/kernel api side.

> I see two invocations on iptables-legacy-restore.
> 
> But the question remains: Why copy counters after replacing the rule
> set?

Good question.  What I can gather from
https://git.netfilter.org/iptables/tree/libiptc/libiptc.c#n2597

After replace we get copy of the old counters, depending on mode
we can force-update counters post-replace in kernel, via

	ret = setsockopt(handle->sockfd, TC_IPPROTO, SO_SET_ADD_COUNTERS,
			 newcounters, counterlen);

I suspect this is whats used by 'iptables -L -v -Z INPUT'.
But I don't know if anyone uses this in practice.

Maybe Pablo remembers the details, this is ancient code by kernel
standards.

I think we might get away with losing counters on the update
side, i.e. rcu_update_pointer() so new CPUs won't find the old
binary blob, copy the counters, then defer destruction via rcu_work
or similar and accept that the counters might have marginally
changed after the copy to userland and before last cpu left its
rcu critical section.
