From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Re: [PATCH -v2 4/6] locking, arch: Update spin_unlock_wait()
Date: Fri, 27 May 2016 15:34:13 -0400
Message-ID: <903f2076-9e24-afb7-0b17-e41457854907@mellanox.com>
References: <20160526141922.163198062@infradead.org>
 <20160526142354.293350777@infradead.org>
 <bff5e0b4-c572-cf4c-82fe-a672b8b5fb14@mellanox.com>
 <20160527090548.GZ3193@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<manfred@colorfullife.com>, <dave@stgolabs.net>,
	<paulmck@linux.vnet.ibm.com>, <will.deacon@arm.com>,
	<boqun.feng@gmail.com>, <Waiman.Long@hpe.com>, <tj@kernel.org>,
	<pablo@netfilter.org>, <kaber@trash.net>, <davem@davemloft.net>,
	<oleg@redhat.com>, <netfilter-devel@vger.kernel.org>,
	<sasha.levin@oracle.com>, <hofrat@osadl.org>, <rth@twiddle.net>,
	<vgupta@synopsys.com>, <linux@armlinux.org.uk>,
	<realmz6@gmail.com>, <rkuo@codeaurora.org>, <tony.luck@intel.com>,
	<james.hogan@imgtec.com>, <ralf@linux-mips.org>,
	<dhowells@redhat.com>, <jejb@parisc-linux.org>,
	<mpe@ellerman.id.au>, <schwidefsky@de.ibm.com>,
	<ysato@users.sourceforge.jp>, <chris@zankel.net>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-db3on0089.outbound.protection.outlook.com ([157.55.234.89]:29616
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753221AbcE0Tei (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 May 2016 15:34:38 -0400
In-Reply-To: <20160527090548.GZ3193@twins.programming.kicks-ass.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 5/27/2016 5:05 AM, Peter Zijlstra wrote:
> On Thu, May 26, 2016 at 05:10:36PM -0400, Chris Metcalf wrote:
>> On 5/26/2016 10:19 AM, Peter Zijlstra wrote:
>>> --- a/arch/tile/lib/spinlock_32.c
>>> +++ b/arch/tile/lib/spinlock_32.c
>>> @@ -72,10 +72,14 @@ void arch_spin_unlock_wait(arch_spinlock
>>>   	if (next == curr)
>>>   		return;
>>> +	smp_rmb();
>>> +
>>>   	/* Wait until the current locker has released the lock. */
>>>   	do {
>>>   		delay_backoff(iterations++);
>>>   	} while (READ_ONCE(lock->current_ticket) == curr);
>>> +
>>> +	smp_acquire__after_ctrl_dep();
>>>   }
>>>   EXPORT_SYMBOL(arch_spin_unlock_wait);
>>> --- a/arch/tile/lib/spinlock_64.c
>>> +++ b/arch/tile/lib/spinlock_64.c
>>> @@ -72,10 +72,14 @@ void arch_spin_unlock_wait(arch_spinlock
>>>   	if (arch_spin_next(val) == curr)
>>>   		return;
>>> +	smp_rmb();
>>> +
>>>   	/* Wait until the current locker has released the lock. */
>>>   	do {
>>>   		delay_backoff(iterations++);
>>>   	} while (arch_spin_current(READ_ONCE(lock->lock)) == curr);
>>> +
>>> +	smp_acquire__after_ctrl_dep();
>>>   }
>>>   EXPORT_SYMBOL(arch_spin_unlock_wait);
>> The smp_rmb() are unnecessary for tile.  We READ_ONCE next/curr from the
>> lock and compare them, so we know the load(s) are complete.  There's no
>> microarchitectural speculation going on so that's that.  Then we READ_ONCE
>> the next load on the lock from within the wait loop, so our load/load
>> ordering is guaranteed.
> Does TILE never speculate reads? Because in that case the control
> dependency already provides a full load->load,store barrier and you'd
> want smp_acquire__after_ctrl_dep() to be a barrier() instead of
> smp_rmb().

Yes, that's a good point.  I didn't look at the definition of smp_acquire__after_ctrl_dep(),
but it certainly sounds like that's exactly a compiler barrier for tile.  There is no load
speculation performed.  The only out-of-order stuff that happens is in the memory
subsystem: stores will become visible in arbitrary order, and loads will arrive in
arbitrary order, but as soon as the result of a load is used in any other kind of
instruction, the instruction issue will halt until the pending load(s) for the instruction
operands are available.

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com

