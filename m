From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 1/3] locking: Introduce smp_acquire__after_ctrl_dep
Date: Tue, 7 Jun 2016 09:15:08 +0200
Message-ID: <20160607071508.GL30909@twins.programming.kicks-ass.net>
References: <5745C2CA.4040003@hpe.com>
 <20160525155747.GE3789@linux.vnet.ibm.com>
 <57514B6E.6010001@synopsys.com>
 <20160603093834.GI3190@twins.programming.kicks-ass.net>
 <20160603120827.GT5231@linux.vnet.ibm.com>
 <20160603122310.GM3190@twins.programming.kicks-ass.net>
 <20160603133238.GV5231@linux.vnet.ibm.com>
 <20160603134552.GL9915@arm.com>
 <20160604152929.GZ5231@linux.vnet.ibm.com>
 <20160606172824.GA10383@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Will Deacon <will.deacon@arm.com>,
	Vineet Gupta <Vineet.Gupta1@synopsys.com>,
	Waiman Long <waiman.long@hpe.com>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net, boqun.feng@gmail.com,
	tj@kernel.org, pablo@netfilter.org, kaber@trash.net,
	davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34716 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbcFGHPY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2016 03:15:24 -0400
Content-Disposition: inline
In-Reply-To: <20160606172824.GA10383@linux.vnet.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 06, 2016 at 10:28:24AM -0700, Paul E. McKenney wrote:
> commit 43672d15aeb69b1a196c06cbc071cbade8d247fd
> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Date:   Mon Jun 6 10:19:42 2016 -0700
> 
>     documentation: Clarify limited control-dependency scope
>     
>     Nothing in the control-dependencies section of memory-barriers.txt
>     says that control dependencies don't extend beyond the end of the
>     if-statement containing the control dependency.  Worse yet, in many
>     situations, they do extend beyond that if-statement.  In particular,
>     the compiler cannot destroy the control dependency given proper use of
>     READ_ONCE() and WRITE_ONCE().  However, a weakly ordered system having
>     a conditional-move instruction provides the control-dependency guarantee
>     only to code within the scope of the if-statement itself.
>     
>     This commit therefore adds words and an example demonstrating this
>     limitation of control dependencies.
>     
>     Reported-by: Will Deacon <will.deacon@arm.com>
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

> 
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index 147ae8ec836f..a4d0a99de04d 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -806,6 +806,41 @@ out-guess your code.  More generally, although READ_ONCE() does force
>  the compiler to actually emit code for a given load, it does not force
>  the compiler to use the results.
>  
> +In addition, control dependencies apply only to the then-clause and
> +else-clause of the if-statement in question.  In particular, it does
> +not necessarily apply to code following the if-statement:
> +
> +	q = READ_ONCE(a);
> +	if (q) {
> +		WRITE_ONCE(b, p);
> +	} else {
> +		WRITE_ONCE(b, r);
> +	}
> +	WRITE_ONCE(c, 1);  /* BUG: No ordering against the read from "a". */
> +
> +It is tempting to argue that there in fact is ordering because the
> +compiler cannot reorder volatile accesses and also cannot reorder
> +the writes to "b" with the condition.  Unfortunately for this line
> +of reasoning, the compiler might compile the two writes to "b" as
> +conditional-move instructions, as in this fanciful pseudo-assembly
> +language:
> +
> +	ld r1,a
> +	ld r2,p
> +	ld r3,r
> +	cmp r1,$0
> +	cmov,ne r4,r2
> +	cmov,eq r4,r3
> +	st r4,b
> +	st $1,c
> +
> +A weakly ordered CPU would have no dependency of any sort between the load
> +from "a" and the store to "c".  The control dependencies would extend
> +only to the pair of cmov instructions and the store depending on them.
> +In short, control dependencies apply only to the stores in the then-clause
> +and else-clause of the if-statement in question (including functions
> +invoked by those two clauses), not to code following that if-statement.
> +
>  Finally, control dependencies do -not- provide transitivity.  This is
>  demonstrated by two related examples, with the initial values of
>  x and y both being zero:
> @@ -869,6 +904,12 @@ In summary:
>        atomic{,64}_read() can help to preserve your control dependency.
>        Please see the COMPILER BARRIER section for more information.
>  
> +  (*) Control dependencies apply only to the then-clause and else-clause
> +      of the if-statement containing the control dependency, including
> +      any functions that these two clauses call.  Control dependencies
> +      do -not- apply to code following the if-statement containing the
> +      control dependency.
> +
>    (*) Control dependencies pair normally with other types of barriers.
>  
>    (*) Control dependencies do -not- provide transitivity.  If you
> 
