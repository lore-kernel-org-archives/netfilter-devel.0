From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 1/3] locking: Introduce smp_acquire__after_ctrl_dep
Date: Tue, 7 Jun 2016 11:54:11 -0700
Message-ID: <20160607185411.GI3723@linux.vnet.ibm.com>
References: <20160603133238.GV5231@linux.vnet.ibm.com>
 <20160603134552.GL9915@arm.com>
 <20160604152929.GZ5231@linux.vnet.ibm.com>
 <20160606172824.GA10383@linux.vnet.ibm.com>
 <20160607071508.GL30909@twins.programming.kicks-ass.net>
 <c8b77029-7652-04e7-efaa-693206b7ec62@stressinduktion.org>
 <20160607130628.GN5506@linux.vnet.ibm.com>
 <3ff80c55-4522-78b2-d280-9a91a462230e@stressinduktion.org>
 <20160607152315.GC3723@linux.vnet.ibm.com>
 <20160607180106.GD20477@arm.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Vineet Gupta <Vineet.Gupta1@synopsys.com>,
	Waiman Long <waiman.long@hpe.com>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net, boqun.feng@gmail.com,
	tj@kernel.org, pablo@netfilter.org, kaber@trash.net,
	davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org
To: Will Deacon <will.deacon@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160607180106.GD20477@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 07, 2016 at 07:01:07PM +0100, Will Deacon wrote:
> On Tue, Jun 07, 2016 at 08:23:15AM -0700, Paul E. McKenney wrote:
> > On Tue, Jun 07, 2016 at 04:59:02PM +0200, Hannes Frederic Sowa wrote:
> > > Sorry, to follow-up again on this. Will Deacon's comments were about
> > > conditional-move instructions, which this compiler-option would prevent,
> > > as far as I can see it.
> > 
> > According to this email thread, I believe that this works the other
> > way around:
> > 
> > http://thread.gmane.org/gmane.linux.kernel/1721993
> > 
> > That parameter prevents the compiler from converting a conditional
> > store into an unconditional store, which would be really problematic.
> > Give the current kernel build, I believe that the compiler really is
> > within its rights to use conditional-move instructions as shown above.
> > But I again must defer to Will Deacon on the details.
> 
> A multi_v7_defconfig build of mainline certainly spits out conditional
> store instructions, but I have no idea whether these correspond to
> WRITE_ONCE or not:
> 
> $ objdump -d vmlinux | grep 'str\(eq\|ne\)' | wc -l
> 7326
> 
> At the end of the day, the ARM architecture says you can't rely on this
> being ordered and I can see it happening in practice in the face of
> conditional stores.

Thank you for the information, Will!

							Thanx, Paul
