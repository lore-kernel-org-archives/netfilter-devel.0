From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 3/3] locking,netfilter: Fix nf_conntrack_lock()
Date: Thu, 26 May 2016 15:54:06 +0200
Message-ID: <20160526135406.GK3192@twins.programming.kicks-ass.net>
References: <20160524142723.178148277@infradead.org>
 <20160524143649.673861121@infradead.org>
 <3e1671fc-be0f-bc95-4fbb-6bfc56e6c15b@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	dave@stgolabs.net, paulmck@linux.vnet.ibm.com, will.deacon@arm.com,
	boqun.feng@gmail.com, Waiman.Long@hpe.com, tj@kernel.org,
	pablo@netfilter.org, kaber@trash.net, davem@davemloft.net,
	oleg@redhat.com, netfilter-devel@vger.kernel.org,
	sasha.levin@oracle.com, hofrat@osadl.org
To: Manfred Spraul <manfred@colorfullife.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3e1671fc-be0f-bc95-4fbb-6bfc56e6c15b@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, May 24, 2016 at 10:41:43PM +0200, Manfred Spraul wrote:
> >--- a/net/netfilter/nf_conntrack_core.c
> >+++ b/net/netfilter/nf_conntrack_core.c
> >@@ -74,7 +74,18 @@ void nf_conntrack_lock(spinlock_t *lock)
> >  	spin_lock(lock);
> >  	while (unlikely(nf_conntrack_locks_all)) {
> >  		spin_unlock(lock);
> >+		/*
> >+		 * Order the nf_contrack_locks_all load vs the spin_unlock_wait()
> >+		 * loads below, to ensure locks_all is indeed held.
> >+		 */
> >+		smp_rmb(); /* spin_lock(locks_all) */
> >  		spin_unlock_wait(&nf_conntrack_locks_all_lock);

> I don't understand the comment, and I don't understand why the smp_rmb() is
> required: What do you want to protect against?

I order against the spin_unlock_wait() load of
nf_conntrack_locks_all_lock being done _before_ the
nf_conntrack_locks_all load.

This is possible because the spin_unlock() in between will stop the
nf_conntrack_locks_all load from falling down, but it doesn't stop the
&nf_conntrack_locks_all_lock lock from being done early.

Inverting these two loads could result in not waiting when we should.


	nf_conntrack_all_lock()		nf_conntrack_lock()

					  [L] all_locks == unlocked
	  [S] spin_lock(&all_lock);
	  [S] all = true;
					  [L] all == true

And we'll not wait for the current all_lock section to finish.
Resulting in an all_lock and lock section at the same time.
