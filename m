From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 1/3] locking: Introduce smp_acquire__after_ctrl_dep
Date: Tue, 7 Jun 2016 06:06:28 -0700
Message-ID: <20160607130628.GN5506@linux.vnet.ibm.com>
References: <57514B6E.6010001@synopsys.com>
 <20160603093834.GI3190@twins.programming.kicks-ass.net>
 <20160603120827.GT5231@linux.vnet.ibm.com>
 <20160603122310.GM3190@twins.programming.kicks-ass.net>
 <20160603133238.GV5231@linux.vnet.ibm.com>
 <20160603134552.GL9915@arm.com>
 <20160604152929.GZ5231@linux.vnet.ibm.com>
 <20160606172824.GA10383@linux.vnet.ibm.com>
 <20160607071508.GL30909@twins.programming.kicks-ass.net>
 <c8b77029-7652-04e7-efaa-693206b7ec62@stressinduktion.org>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will.deacon@arm.com>,
	Vineet Gupta <Vineet.Gupta1@synopsys.com>,
	Waiman Long <waiman.long@hpe.com>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net, boqun.feng@gmail.com,
	tj@kernel.org, pablo@netfilter.org, kaber@trash.net,
	davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c8b77029-7652-04e7-efaa-693206b7ec62@stressinduktion.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 07, 2016 at 02:41:44PM +0200, Hannes Frederic Sowa wrote:
> On 07.06.2016 09:15, Peter Zijlstra wrote:
> >>
> >> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> >> index 147ae8ec836f..a4d0a99de04d 100644
> >> --- a/Documentation/memory-barriers.txt
> >> +++ b/Documentation/memory-barriers.txt
> >> @@ -806,6 +806,41 @@ out-guess your code.  More generally, although READ_ONCE() does force
> >>  the compiler to actually emit code for a given load, it does not force
> >>  the compiler to use the results.
> >>  
> >> +In addition, control dependencies apply only to the then-clause and
> >> +else-clause of the if-statement in question.  In particular, it does
> >> +not necessarily apply to code following the if-statement:
> >> +
> >> +	q = READ_ONCE(a);
> >> +	if (q) {
> >> +		WRITE_ONCE(b, p);
> >> +	} else {
> >> +		WRITE_ONCE(b, r);
> >> +	}
> >> +	WRITE_ONCE(c, 1);  /* BUG: No ordering against the read from "a". */
> >> +
> >> +It is tempting to argue that there in fact is ordering because the
> >> +compiler cannot reorder volatile accesses and also cannot reorder
> >> +the writes to "b" with the condition.  Unfortunately for this line
> >> +of reasoning, the compiler might compile the two writes to "b" as
> >> +conditional-move instructions, as in this fanciful pseudo-assembly
> >> +language:
> 
> I wonder if we already guarantee by kernel compiler settings that this
> behavior is not allowed by at least gcc.
> 
> We unconditionally set --param allow-store-data-races=0 which should
> actually prevent gcc from generating such conditional stores.
> 
> Am I seeing this correct here?

In this case, the store to "c" is unconditional, so pulling it forward
would not generate a data race.  However, the compiler is still prohibited
from pulling it forward because it is not allowed to reorder volatile
references.  So, yes, the compiler cannot reorder, but for a different
reason.

Some CPUs, on the other hand, can do this reordering, as Will Deacon
pointed out earlier in this thread.

							Thanx, Paul
