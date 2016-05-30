From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v2 4/6] locking, arch: Update spin_unlock_wait()
Date: Mon, 30 May 2016 11:25:20 +0200
Message-ID: <20160530092520.GQ3192@twins.programming.kicks-ass.net>
References: <20160526141922.163198062@infradead.org>
 <20160526142354.293350777@infradead.org>
 <bff5e0b4-c572-cf4c-82fe-a672b8b5fb14@mellanox.com>
 <20160527090548.GZ3193@twins.programming.kicks-ass.net>
 <903f2076-9e24-afb7-0b17-e41457854907@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com,
	boqun.feng@gmail.com, Waiman.Long@hpe.com, tj@kernel.org,
	pablo@netfilter.org, kaber@trash.net, davem@davemloft.net,
	oleg@redhat.com, netfilter-devel@vger.kernel.org,
	sasha.levin@oracle.com, hofrat@osadl.org, rth@twiddle.net,
	vgupta@synopsys.com, linux@armlinux.org.uk, realmz6@gmail.com,
	rkuo@codeaurora.org, tony.luck@intel.com, james.hogan@imgtec.com,
	ralf@linux-mips.org, dhowells@redhat.com, jejb@parisc-linux.org,
	mpe@ellerman.id.au, schwidefsky@de.ibm.com,
	ysato@users.sourceforge.jp, chris@zankel.net
To: Chris Metcalf <cmetcalf@mellanox.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <903f2076-9e24-afb7-0b17-e41457854907@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, May 27, 2016 at 03:34:13PM -0400, Chris Metcalf wrote:

> >Does TILE never speculate reads? Because in that case the control
> >dependency already provides a full load->load,store barrier and you'd
> >want smp_acquire__after_ctrl_dep() to be a barrier() instead of
> >smp_rmb().
> 
> Yes, that's a good point.  I didn't look at the definition of smp_acquire__after_ctrl_dep(),
> but it certainly sounds like that's exactly a compiler barrier for tile.  There is no load
> speculation performed.  The only out-of-order stuff that happens is in the memory
> subsystem: stores will become visible in arbitrary order, and loads will arrive in
> arbitrary order, but as soon as the result of a load is used in any other kind of
> instruction, the instruction issue will halt until the pending load(s) for the instruction
> operands are available.

OK; for now I'll just put in barrier() and a big comment, I'll look at
making smp_acquire__after_ctrl_dep() a proper (per arch) barrier later.
There's a little header head-ache involved.
