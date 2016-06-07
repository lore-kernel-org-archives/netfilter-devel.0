From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [RFC][PATCH 1/3] locking: Introduce smp_acquire__after_ctrl_dep
Date: Tue, 7 Jun 2016 14:41:44 +0200
Message-ID: <c8b77029-7652-04e7-efaa-693206b7ec62@stressinduktion.org>
References: <5745C2CA.4040003@hpe.com>
 <20160525155747.GE3789@linux.vnet.ibm.com> <57514B6E.6010001@synopsys.com>
 <20160603093834.GI3190@twins.programming.kicks-ass.net>
 <20160603120827.GT5231@linux.vnet.ibm.com>
 <20160603122310.GM3190@twins.programming.kicks-ass.net>
 <20160603133238.GV5231@linux.vnet.ibm.com> <20160603134552.GL9915@arm.com>
 <20160604152929.GZ5231@linux.vnet.ibm.com>
 <20160606172824.GA10383@linux.vnet.ibm.com>
 <20160607071508.GL30909@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Will Deacon <will.deacon@arm.com>,
	Vineet Gupta <Vineet.Gupta1@synopsys.com>,
	Waiman Long <waiman.long@hpe.com>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net, boqun.feng@gmail.com,
	tj@kernel.org, pablo@netfilter.org, kaber@trash.net,
	davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org
To: Peter Zijlstra <peterz@infradead.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160607071508.GL30909@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 07.06.2016 09:15, Peter Zijlstra wrote:
>>
>> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
>> index 147ae8ec836f..a4d0a99de04d 100644
>> --- a/Documentation/memory-barriers.txt
>> +++ b/Documentation/memory-barriers.txt
>> @@ -806,6 +806,41 @@ out-guess your code.  More generally, although READ_ONCE() does force
>>  the compiler to actually emit code for a given load, it does not force
>>  the compiler to use the results.
>>  
>> +In addition, control dependencies apply only to the then-clause and
>> +else-clause of the if-statement in question.  In particular, it does
>> +not necessarily apply to code following the if-statement:
>> +
>> +	q = READ_ONCE(a);
>> +	if (q) {
>> +		WRITE_ONCE(b, p);
>> +	} else {
>> +		WRITE_ONCE(b, r);
>> +	}
>> +	WRITE_ONCE(c, 1);  /* BUG: No ordering against the read from "a". */
>> +
>> +It is tempting to argue that there in fact is ordering because the
>> +compiler cannot reorder volatile accesses and also cannot reorder
>> +the writes to "b" with the condition.  Unfortunately for this line
>> +of reasoning, the compiler might compile the two writes to "b" as
>> +conditional-move instructions, as in this fanciful pseudo-assembly
>> +language:

I wonder if we already guarantee by kernel compiler settings that this
behavior is not allowed by at least gcc.

We unconditionally set --param allow-store-data-races=0 which should
actually prevent gcc from generating such conditional stores.

Am I seeing this correct here?

Thanks,
Hannes
