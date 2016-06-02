From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v4 5/7] locking, arch: Update spin_unlock_wait()
Date: Thu, 2 Jun 2016 18:04:39 +0200
Message-ID: <20160602160439.GE3190@twins.programming.kicks-ass.net>
References: <20160602115157.249037373@infradead.org>
 <20160602115439.085385545@infradead.org>
 <20160602142440.GE30064@insomnia>
 <20160602144424.GV3193@twins.programming.kicks-ass.net>
 <20160602151107.GA23133@insomnia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com,
	Waiman.Long@hpe.com, tj@kernel.org, pablo@netfilter.org,
	kaber@trash.net, davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org, jejb@parisc-linux.org, chris@zankel.net,
	rth@twiddle.net, dhowells@redhat.com, schwidefsky@de.ibm.com,
	mpe@ellerman.id.au, ralf@linux-mips.org, linux@armlinux.org.uk,
	rkuo@codeaurora.org, vgupta@synopsys.com, james.hogan@imgtec.com,
	realmz6@gmail.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
	cmetcalf@mellanox.com
To: Boqun Feng <boqun.feng@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160602151107.GA23133@insomnia>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 02, 2016 at 11:11:07PM +0800, Boqun Feng wrote:
> On Thu, Jun 02, 2016 at 04:44:24PM +0200, Peter Zijlstra wrote:
> > Let me go ponder that some :/
> > 
> 
> An intial thought of the fix is making queued_spin_unlock_wait() an
> atomic-nop too:
> 
> static inline void queued_spin_unlock_wait(struct qspinlock *lock)
> {
> 	struct __qspinlock *l = (struct __qspinlock *)lock;
> 	
> 	while (!cmpxchg(&l->locked, 0, 0))
> 		cpu_relax();
> }
> 
> This could make queued_spin_unlock_wait() a WRITE, with a smp_mb()
> preceding it, it would act like a RELEASE, which can be paired with
> spin_lock().
> 
> Just food for thought. ;-)

Not sure that'll actually work. The qspinlock store is completely
unordered and not part of a ll/sc or anything like that.

Doing competing stores might even result in loosing it entirely.

But I think I got something.. Lemme go test it :-)
