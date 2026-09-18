Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F3E3FCB3D;
	Fri, 18 Sep 2026 09:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789725092; cv=none; b=GUxRg2/ozGcoOxHOlOqm+Bbsy27uqZd2WbSpawt7IWquAOT2mzcmQ5A5DSg3ggCXnevYa2VbJp+cq9dwnXhymCSiVUbS/1ThFkN/8PdH3OJXk2J/lMH4yxFoc+hWwW4r8/LMsoXKE3/A6BIMYoTFZWMTG5S8eG1HIcgtNd1loME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789725092; c=relaxed/simple;
	bh=vtCfapWI5NXcSSkmMilrOl+Ac/EUHYBOY3iu9mjTt54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LUpiCBcudZnAFVR3pNaihf6IxH0ytsz47uCBU0KDmFLDRG0ivuBVS2ix1m/xDrTXJAhBmh84I2mkTN9exY+0TYcjBmKF8jkLDaNNCb0ZEjyzDH7/pZ9PyqEpeJvkUN9/swrPfYfONzGA31q6QXZmHz59B0GsYqaPiXCD5Ee6DmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 87B2560468; Fri, 18 Sep 2026 11:51:21 +0200 (CEST)
Date: Fri, 18 Sep 2026 11:51:21 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net 02/10] netfilter: nfnetlink_queue: hold nfnl mutex in
 event notifier
Message-ID: <aq0Fr087oC6MH4kQ@strlen.de>
References: <20260916231652.127456-3-pablo@netfilter.org>
 <20260918020409.3513342-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918020409.3513342-1-kuba@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> netfilter: nfnetlink_queue: hold nfnl mutex in event notifier
> 
> This takes the NFNL_SUBSYS_QUEUE mutex around the instance destroy loop in
> nfqnl_rcv_nl_event() so that the NETLINK_URELEASE notifier can no longer run
> in parallel with nfqnl_recv_config().  The stale comment in nfqnl_recv_config()
> is updated to describe the new serialization.

This fixes a unpriv netns root exploit.  At least I think so.  Its
simple enough to look at and should be small enough to backport.

The LLM report makes me wonder:

1. Does this patch not fix it?  If so, how does the reproducer need
to be changed to make it trigger KASAN/UaF again?  Doesn't say.

2. Does this add a regression?  Doesn't say.  Tests I have pass.

> > diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> > index c727668b0c5be..a3bc002800510 100644
> > --- a/net/netfilter/nfnetlink_queue.c
> > +++ b/net/netfilter/nfnetlink_queue.c
> > @@ -1593,6 +1593,7 @@ nfqnl_rcv_nl_event(struct notifier_block *this,
> >  	if (event == NETLINK_URELEASE && n->protocol == NETLINK_NETFILTER) {
> >  		int i;
> >  
> > +		nfnl_lock(NFNL_SUBSYS_QUEUE);
> >  		/* destroy all instances for this portid */
> >  		spin_lock(&q->instances_lock);
> >  		for (i = 0; i < INSTANCE_BUCKETS; i++) {
> 
> [Severity: Medium]
> This is a pre-existing issue, not something introduced here, but does waiting
> on the nfnl queue mutex here make it easier to destroy an instance that belongs
> to a different socket?

So what?

This is a 20 year old interface. NOONE, and I really mean, NO ONE, has
raised a bug report in all these years.

*WHAT* does a *SENSIBLE* userspace program need to do so that it ends up
in a bad state?

From where I'm standing, there is a crash bug that is fixed by
this patch without observable new regression.

Aside from not crashing, kernel should also not have to perform absurd
stunts to somehow make sense of whatever crap userspace is trying to do.

> The destroy loop in nfqnl_rcv_nl_event() picks victims by portid only:
> 
> 	hlist_for_each_entry_safe(inst, t2, head, hlist) {
> 		if (n->portid == inst->peer_portid)
> 			__instance_destroy(inst);
> 	}
> 
> and net/netlink/af_netlink.c:netlink_release() makes the portid reusable well
> before the notifier runs:
> 
> netlink_release()
> 	netlink_remove(sk);		/* portid is free for reuse here */
> 	sock_orphan(sk);
> 	...
> 	blocking_notifier_call_chain(&netlink_chain,
> 				     NETLINK_URELEASE, &n);
> 
> With the new nfnl_lock(NFNL_SUBSYS_QUEUE), the notifier now blocks for the
> whole duration of any NFQNL_MSG_CONFIG handling (including instance_create()
> and its sleeping rhashtable_init()), in any netns, since
> net/netfilter/nfnetlink.c:nfnl_lock() takes the single global
> table[NFNL_SUBSYS_QUEUE].mutex.  So this sequence looks possible:
> 
> thread 1: close() of a NETLINK_NETFILTER socket with portid X
> 	  netlink_remove() releases X, notifier is pending

This is normally done by some applications when they shut down as
part of SIGTERM for example. Others just exit().

> thread 2: binds portid X, sends NFQNL_CFG_CMD_BIND
> 	  nfnetlink_rcv_msg() -> nfqnl_recv_config() under the queue mutex
> 	  instance_create() links a fresh instance with peer_portid == X

Why would one try do that...?  Just... don't do that?
And I don't follow how this can work.  LLM clains thread 1 is now
blocked in nfnl_lock(NFNL_SUBSYS_QUEUE), which thread 2 holds.

Therefore, as thread 1 couldn't yet run the notifier, the old queue is
still registered... no?

> thread 1: notifier finally acquires the mutex, matches
> 	  inst->peer_portid == X and calls __instance_destroy() on the
> 	  brand new instance

> Can the ownership check that the new comment relies on detect this?
> 
> 	queue = instance_lookup(q, queue_num);
> 	if (queue && queue->peer_portid != NETLINK_CB(skb).portid) {
> 
> peer_portid matches in the recycled-portid case, so the check passes and the
> instance is still torn down by the older socket's notification.

Not following :-/

Even if that test passes, why does it not hit the 'return -EBUSY' in
NFQNL_CFG_CMD_BIND?

If it did not, then instance_lookup() did not return a result, i.e.
queue was already done?  Can't make sense of anything anymore.

> There is no memory safety problem, the instance is unlinked once and freed via
> queue_rcu_work().  The visible effect is that a live socket's queue silently
> disappears, its queued packets are flushed, packets hitting the NFQUEUE rule
> then fail with -ESRCH (dropped unless fail-open or bypass is set), and later
> CONFIG messages for that queue number return -ENODEV.  It requires
> CAP_NET_ADMIN in the netns and a concurrent close/bind, and no later commit in
> this series touches net/netfilter/nfnetlink_queue.c.

I have no idea how to sensibly change this patch to address this 'bug'.

And thats my main source of frustration with all the LLM walls we have
now in place.

A human telling me that I fucked up usually has the courtesy of providing
an alternative solution or a hint to get things move in the right
direction again.

Or even 'I don't like it because of problem XYZ but I don't have a better
idea either'.

LLM just says 'something is wrong, you figure out the details of fixing
this'.  I would like to make better patches, but I don't know how.
