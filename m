From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 1/3] locking: Introduce smp_acquire__after_ctrl_dep
Date: Tue, 7 Jun 2016 11:44:09 -0700
Message-ID: <20160607184409.GG3723@linux.vnet.ibm.com>
References: <20160603133238.GV5231@linux.vnet.ibm.com>
 <20160603134552.GL9915@arm.com>
 <20160604152929.GZ5231@linux.vnet.ibm.com>
 <20160606172824.GA10383@linux.vnet.ibm.com>
 <20160607071508.GL30909@twins.programming.kicks-ass.net>
 <c8b77029-7652-04e7-efaa-693206b7ec62@stressinduktion.org>
 <20160607130628.GN5506@linux.vnet.ibm.com>
 <3ff80c55-4522-78b2-d280-9a91a462230e@stressinduktion.org>
 <20160607152315.GC3723@linux.vnet.ibm.com>
 <20160607174853.GJ30154@twins.programming.kicks-ass.net>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Will Deacon <will.deacon@arm.com>,
	Vineet Gupta <Vineet.Gupta1@synopsys.com>,
	Waiman Long <waiman.long@hpe.com>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net, boqun.feng@gmail.com,
	tj@kernel.org, pablo@netfilter.org, kaber@trash.net,
	davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160607174853.GJ30154@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 07, 2016 at 07:48:53PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 07, 2016 at 08:23:15AM -0700, Paul E. McKenney wrote:
> > and if the hardware is not excessively clever (bad bet, by the
> > way, long term),
> 
> This ^
> 
> > > Is there something else than conditional move instructions that could
> > > come to play here? Obviously a much smarter CPU could evaluate all the
> > > jumps and come to the conclusion that the write to c is never depending
> > > on the load from a, but is this implemented somewhere in hardware?
> > 
> > I don't know of any hardware that does that, but given that conditional
> > moves are supported by some weakly ordered hardware, it looks to me
> > that we are stuck with the possibility of "a"-"c" reordering.
> 
> Is why I'm scared of relying on the non-condition.
> 
> The if and else branches are obviously dependent on the completion of
> the load; anything after that, not so much.
> 
> You could construct an argument against this program order speculation
> based on interrupts, which should not observe the stores out of order
> etc.. but if the hardware is that clever, it can also abort the entire
> speculation on interrupt (much like hardware transactions already can).
> 
> So even if today no hardware is this clever (and that isn't proven)
> there's nothing saying it will not ever be.
> 
> This is why I really do not want to advertise and or rely on this
> behaviour.

What Peter said!  ;-)

							Thanx, Paul
