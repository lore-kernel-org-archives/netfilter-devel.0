From: Waiman Long <waiman.long@hpe.com>
Subject: Re: [PATCH -v3 7/8] locking: Move smp_cond_load_acquire() and friends
 into asm-generic/barrier.h
Date: Wed, 1 Jun 2016 12:53:58 -0400
Message-ID: <574F1326.5000207@hpe.com>
References: <20160531094134.606249808@infradead.org> <20160531094844.282806055@infradead.org> <574DED82.9080200@hpe.com> <20160601093158.GN3190@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<manfred@colorfullife.com>, <dave@stgolabs.net>,
	<paulmck@linux.vnet.ibm.com>, <will.deacon@arm.com>,
	<boqun.feng@gmail.com>, <tj@kernel.org>, <pablo@netfilter.org>,
	<kaber@trash.net>, <davem@davemloft.net>, <oleg@redhat.com>,
	<netfilter-devel@vger.kernel.org>, <sasha.levin@oracle.com>,
	<hofrat@osadl.org>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160601093158.GN3190@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 06/01/2016 05:31 AM, Peter Zijlstra wrote:
> On Tue, May 31, 2016 at 04:01:06PM -0400, Waiman Long wrote:
>> You are doing two READ_ONCE's in the smp_cond_load_acquire loop. Can we
>> change it to do just one READ_ONCE, like
>>
>> --- a/include/asm-generic/barrier.h
>> +++ b/include/asm-generic/barrier.h
>> @@ -229,12 +229,18 @@ do {
>>    * value; some architectures can do this in hardware.
>>    */
>>   #ifndef cmpwait
>> +#define cmpwait(ptr, val) ({                                   \
>>          typeof (ptr) __ptr = (ptr);                             \
>> +       typeof (val) __old = (val);                             \
>> +       typeof (val) __new;                                     \
>> +       for (;;) {                                              \
>> +               __new = READ_ONCE(*__ptr);                      \
>> +               if (__new != __old)                             \
>> +                       break;                                  \
>>                  cpu_relax();                                    \
>> +       }                                                       \
>> +       __new;                                                  \
>> +})
>>   #endif
>>
>>   /**
>> @@ -251,12 +257,11 @@ do {
>>   #ifndef smp_cond_load_acquire
>>   #define smp_cond_load_acquire(ptr, cond_expr) ({               \
>>          typeof(ptr) __PTR = (ptr);                              \
>> +       typeof(*ptr) VAL = READ_ONCE(*__PTR);                   \
>>          for (;;) {                                              \
>>                  if (cond_expr)                                  \
>>                          break;                                  \
>> +               VAL = cmpwait(__PTR, VAL);                      \
>>          }                                                       \
>>          smp_acquire__after_ctrl_dep();                          \
>>          VAL;                                                    \
> Yes, that generates slightly better code, but now that you made me look
> at it, I think we need to kill the cmpwait() in the generic version and
> only keep it for arch versions.
>
> /me ponders...
>
> So cmpwait() as implemented here has strict semantics; but arch
> implementations as previously proposed have less strict semantics; and
> the use here follows that less strict variant.
>
> The difference being that the arch implementations of cmpwait can have
> false positives (ie. return early, without a changed value)
> smp_cond_load_acquire() can deal with these false positives seeing how
> its in a loop and does its own (more specific) comparison.
>
> Exposing cmpwait(), with the documented semantics, means that arch
> versions need an additional loop inside to match these strict semantics,
> or we need to weaken the cmpwait() semantics, at which point I'm not
> entirely sure its worth keeping as a generic primitive...
>
> Hmm, so if we can find a use for the weaker cmpwait() outside of
> smp_cond_load_acquire() I think we can make a case for keeping it, and
> looking at qspinlock.h there's two sites we can replace cpu_relax() with
> it.
>
> Will, since ARM64 seems to want to use this, does the below make sense
> to you?
>
> ---
>   include/asm-generic/barrier.h | 15 ++++++---------
>   kernel/locking/qspinlock.c    |  4 ++--
>   2 files changed, 8 insertions(+), 11 deletions(-)
>
> diff --git a/include/asm-generic/barrier.h b/include/asm-generic/barrier.h
> index be9222b10d17..05feda5c22e6 100644
> --- a/include/asm-generic/barrier.h
> +++ b/include/asm-generic/barrier.h
> @@ -221,20 +221,17 @@ do {									\
>   #endif
>
>   /**
> - * cmpwait - compare and wait for a variable to change
> + * cmpwait - compare and wait for a variable to 'change'
>    * @ptr: pointer to the variable to wait on
>    * @val: the value it should change from
>    *
> - * A simple constuct that waits for a variable to change from a known
> - * value; some architectures can do this in hardware.
> + * A 'better' cpu_relax(), some architectures can avoid polling and have event
> + * based wakeups on variables. Such constructs allow false positives on the
> + * 'change' and can return early. Therefore this reduces to cpu_relax()
> + * without hardware assist.
>    */
>   #ifndef cmpwait
> -#define cmpwait(ptr, val) do {					\
> -	typeof (ptr) __ptr = (ptr);				\
> -	typeof (val) __val = (val);				\
> -	while (READ_ONCE(*__ptr) == __val)			\
> -		cpu_relax();					\
> -} while (0)
> +#define cmpwait(ptr, val)	cpu_relax()
>   #endif
>
>   /**
> diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
> index e98e5bf679e9..60a811d56406 100644
> --- a/kernel/locking/qspinlock.c
> +++ b/kernel/locking/qspinlock.c
> @@ -311,7 +311,7 @@ void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
>   	 */
>   	if (val == _Q_PENDING_VAL) {
>   		while ((val = atomic_read(&lock->val)) == _Q_PENDING_VAL)
> -			cpu_relax();
> +			cmpwait(&lock->val.counter, _Q_PENDING_VAL);
>   	}
>
>   	/*
> @@ -481,7 +481,7 @@ void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
>   	 */
>   	if (!next) {
>   		while (!(next = READ_ONCE(node->next)))
> -			cpu_relax();
> +			cmpwait(&node->next, NULL);
>   	}
>
>   	arch_mcs_spin_unlock_contended(&next->locked);

I think it is a good idea to consider cmpwait as a fancier version of 
cpu_relax(). It can certainly get used in a lot more places.

Cheers,
Longman
