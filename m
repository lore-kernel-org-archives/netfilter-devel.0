From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v3 7/8] locking: Move smp_cond_load_acquire() and
 friends into asm-generic/barrier.h
Date: Wed, 1 Jun 2016 14:45:41 +0200
Message-ID: <20160601124541.GS3190@twins.programming.kicks-ass.net>
References: <20160531094134.606249808@infradead.org>
 <20160531094844.282806055@infradead.org>
 <574DED82.9080200@hpe.com>
 <20160601093158.GN3190@twins.programming.kicks-ass.net>
 <20160601120009.GB355@arm.com>
 <20160601120654.GR3190@twins.programming.kicks-ass.net>
 <20160601121333.GC355@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Waiman Long <waiman.long@hpe.com>, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, manfred@colorfullife.com,
	dave@stgolabs.net, paulmck@linux.vnet.ibm.com,
	boqun.feng@gmail.com, tj@kernel.org, pablo@netfilter.org,
	kaber@trash.net, davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org
To: Will Deacon <will.deacon@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160601121333.GC355@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jun 01, 2016 at 01:13:33PM +0100, Will Deacon wrote:
> On Wed, Jun 01, 2016 at 02:06:54PM +0200, Peter Zijlstra wrote:

> > Works for me; but that would loose using cmpwait() for
> > !smp_cond_load_acquire() spins, you fine with that?
> > 
> > The two conversions in the patch were both !acquire spins.
> 
> Maybe we could go the whole hog and add smp_cond_load_relaxed?

What about say the cmpxchg loops in queued_write_lock_slowpath()
? Would that be something you'd like to use wfe for?

Writing those in smp_cond_load_{acquire,relaxed)() is somewhat possible
but quite ugleh.
