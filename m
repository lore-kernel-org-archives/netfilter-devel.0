From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 1/3] locking: Introduce smp_acquire__after_ctrl_dep
Date: Tue, 7 Jun 2016 08:23:15 -0700
Message-ID: <20160607152315.GC3723@linux.vnet.ibm.com>
References: <20160603120827.GT5231@linux.vnet.ibm.com>
 <20160603122310.GM3190@twins.programming.kicks-ass.net>
 <20160603133238.GV5231@linux.vnet.ibm.com>
 <20160603134552.GL9915@arm.com>
 <20160604152929.GZ5231@linux.vnet.ibm.com>
 <20160606172824.GA10383@linux.vnet.ibm.com>
 <20160607071508.GL30909@twins.programming.kicks-ass.net>
 <c8b77029-7652-04e7-efaa-693206b7ec62@stressinduktion.org>
 <20160607130628.GN5506@linux.vnet.ibm.com>
 <3ff80c55-4522-78b2-d280-9a91a462230e@stressinduktion.org>
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
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:49878 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161448AbcFGPX0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2016 11:23:26 -0400
Received: from localhost
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
	Tue, 7 Jun 2016 09:23:19 -0600
Content-Disposition: inline
In-Reply-To: <3ff80c55-4522-78b2-d280-9a91a462230e@stressinduktion.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 07, 2016 at 04:59:02PM +0200, Hannes Frederic Sowa wrote:
> On 07.06.2016 15:06, Paul E. McKenney wrote:
> > On Tue, Jun 07, 2016 at 02:41:44PM +0200, Hannes Frederic Sowa wrote:
> >> On 07.06.2016 09:15, Peter Zijlstra wrote:
> >>>>
> >>>> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> >>>> index 147ae8ec836f..a4d0a99de04d 100644
> >>>> --- a/Documentation/memory-barriers.txt
> >>>> +++ b/Documentation/memory-barriers.txt
> >>>> @@ -806,6 +806,41 @@ out-guess your code.  More generally, although READ_ONCE() does force
> >>>>  the compiler to actually emit code for a given load, it does not force
> >>>>  the compiler to use the results.
> >>>>  
> >>>> +In addition, control dependencies apply only to the then-clause and
> >>>> +else-clause of the if-statement in question.  In particular, it does
> >>>> +not necessarily apply to code following the if-statement:
> >>>> +
> >>>> +	q = READ_ONCE(a);
> >>>> +	if (q) {
> >>>> +		WRITE_ONCE(b, p);
> >>>> +	} else {
> >>>> +		WRITE_ONCE(b, r);
> >>>> +	}
> >>>> +	WRITE_ONCE(c, 1);  /* BUG: No ordering against the read from "a". */
> >>>> +
> >>>> +It is tempting to argue that there in fact is ordering because the
> >>>> +compiler cannot reorder volatile accesses and also cannot reorder
> >>>> +the writes to "b" with the condition.  Unfortunately for this line
> >>>> +of reasoning, the compiler might compile the two writes to "b" as
> >>>> +conditional-move instructions, as in this fanciful pseudo-assembly
> >>>> +language:
> >>
> >> I wonder if we already guarantee by kernel compiler settings that this
> >> behavior is not allowed by at least gcc.
> >>
> >> We unconditionally set --param allow-store-data-races=0 which should
> >> actually prevent gcc from generating such conditional stores.
> >>
> >> Am I seeing this correct here?
> > 
> > In this case, the store to "c" is unconditional, so pulling it forward
> > would not generate a data race.  However, the compiler is still prohibited
> > from pulling it forward because it is not allowed to reorder volatile
> > references.  So, yes, the compiler cannot reorder, but for a different
> > reason.
> > 
> > Some CPUs, on the other hand, can do this reordering, as Will Deacon
> > pointed out earlier in this thread.
> 
> Sorry, to follow-up again on this. Will Deacon's comments were about
> conditional-move instructions, which this compiler-option would prevent,
> as far as I can see it.

According to this email thread, I believe that this works the other
way around:

http://thread.gmane.org/gmane.linux.kernel/1721993

That parameter prevents the compiler from converting a conditional
store into an unconditional store, which would be really problematic.
Give the current kernel build, I believe that the compiler really is
within its rights to use conditional-move instructions as shown above.
But I again must defer to Will Deacon on the details.

Or am I misinterpreting that email thread?

>                         Thus I couldn't follow your answer completely:
> 
> The writes to b would be non-conditional-moves with a control dependency
> from a and and edge down to the write to c, which obviously is
> non-conditional. As such in terms of dependency ordering, we would have
> the control dependency always, thus couldn't we assume that in a current
> kernel we always have a load(a)->store(c) requirement?

I agree that if the compiler uses the normal comparisons and conditional
branches, and if the hardware is not excessively clever (bad bet, by the
way, long term), then the load from "a" should not be reordered with
the store to "c".

> Is there something else than conditional move instructions that could
> come to play here? Obviously a much smarter CPU could evaluate all the
> jumps and come to the conclusion that the write to c is never depending
> on the load from a, but is this implemented somewhere in hardware?

I don't know of any hardware that does that, but given that conditional
moves are supported by some weakly ordered hardware, it looks to me
that we are stuck with the possibility of "a"-"c" reordering.

							Thanx, Paul

