From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v3 7/8] locking: Move smp_cond_load_acquire() and
 friends into asm-generic/barrier.h
Date: Wed, 1 Jun 2016 14:06:54 +0200
Message-ID: <20160601120654.GR3190@twins.programming.kicks-ass.net>
References: <20160531094134.606249808@infradead.org>
 <20160531094844.282806055@infradead.org>
 <574DED82.9080200@hpe.com>
 <20160601093158.GN3190@twins.programming.kicks-ass.net>
 <20160601120009.GB355@arm.com>
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
In-Reply-To: <20160601120009.GB355@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jun 01, 2016 at 01:00:10PM +0100, Will Deacon wrote:
> On Wed, Jun 01, 2016 at 11:31:58AM +0200, Peter Zijlstra wrote:
> > Will, since ARM64 seems to want to use this, does the below make sense
> > to you?
> 
> Not especially -- I was going to override smp_cond_load_acquire anyway
> because I want to build it using cmpwait_acquire and get rid of the
> smp_acquire__after_ctrl_dep trick, which is likely slower on arm64.
> 
> So I'd be happier nuking cmpwait from the generic interfaces and using
> smp_cond_load_acquire everywhere, if that's possible.

Works for me; but that would loose using cmpwait() for
!smp_cond_load_acquire() spins, you fine with that?

The two conversions in the patch were both !acquire spins.
