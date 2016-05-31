From: Waiman Long <waiman.long@hpe.com>
Subject: Re: [PATCH -v3 7/8] locking: Move smp_cond_load_acquire() and friends
 into asm-generic/barrier.h
Date: Tue, 31 May 2016 16:01:06 -0400
Message-ID: <574DED82.9080200@hpe.com>
References: <20160531094134.606249808@infradead.org> <20160531094844.282806055@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
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
In-Reply-To: <20160531094844.282806055@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 05/31/2016 05:41 AM, Peter Zijlstra wrote:
> Since all asm/barrier.h should/must include asm-generic/barrier.h the
> latter is a good place for generic infrastructure like this.
>
> This also allows archs to override the new
> smp_acquire__after_ctrl_dep().
>
> Signed-off-by: Peter Zijlstra (Intel)<peterz@infradead.org>
>
> --- a/include/asm-generic/barrier.h
> +++ b/include/asm-generic/barrier.h
> @@ -194,7 +194,7 @@ do {									\
>   })
>   #endif
>
> -#endif
> +#endif	/* CONFIG_SMP */
>
>   /* Barriers for virtual machine guests when talking to an SMP host */
>   #define virt_mb() __smp_mb()
> @@ -207,5 +207,61 @@ do {									\
>   #define virt_store_release(p, v) __smp_store_release(p, v)
>   #define virt_load_acquire(p) __smp_load_acquire(p)
>
> +/**
> + * smp_acquire__after_ctrl_dep() - Provide ACQUIRE ordering after a control dependency
> + *
> + * A control dependency provides a LOAD->STORE order, the additional RMB
> + * provides LOAD->LOAD order, together they provide LOAD->{LOAD,STORE} order,
> + * aka. (load)-ACQUIRE.
> + *
> + * Architectures that do not do load speculation can have this be barrier().
> + */
> +#ifndef smp_acquire__after_ctrl_dep
> +#define smp_acquire__after_ctrl_dep()		smp_rmb()
> +#endif
> +
> +/**
> + * cmpwait - compare and wait for a variable to change
> + * @ptr: pointer to the variable to wait on
> + * @val: the value it should change from
> + *
> + * A simple constuct that waits for a variable to change from a known
> + * value; some architectures can do this in hardware.
> + */
> +#ifndef cmpwait
> +#define cmpwait(ptr, val) do {					\
> +	typeof (ptr) __ptr = (ptr);				\
> +	typeof (val) __val = (val);				\
> +	while (READ_ONCE(*__ptr) == __val)			\
> +		cpu_relax();					\
> +} while (0)
> +#endif
> +
> +/**
> + * smp_cond_load_acquire() - (Spin) wait for cond with ACQUIRE ordering
> + * @ptr: pointer to the variable to wait on
> + * @cond: boolean expression to wait for
> + *
> + * Equivalent to using smp_load_acquire() on the condition variable but employs
> + * the control dependency of the wait to reduce the barrier on many platforms.
> + *
> + * Due to C lacking lambda expressions we load the value of *ptr into a
> + * pre-named variable @VAL to be used in @cond.
> + */
> +#ifndef smp_cond_load_acquire
> +#define smp_cond_load_acquire(ptr, cond_expr) ({		\
> +	typeof(ptr) __PTR = (ptr);				\
> +	typeof(*ptr) VAL;					\
> +	for (;;) {						\
> +		VAL = READ_ONCE(*__PTR);			\
> +		if (cond_expr)					\
> +			break;					\
> +		cmpwait(__PTR, VAL);				\
> +	}							\
> +	smp_acquire__after_ctrl_dep();				\
> +	VAL;							\
> +})
> +#endif
>

You are doing two READ_ONCE's in the smp_cond_load_acquire loop. Can we 
change it to do just one READ_ONCE, like

--- a/include/asm-generic/barrier.h
+++ b/include/asm-generic/barrier.h
@@ -229,12 +229,18 @@ do {
   * value; some architectures can do this in hardware.
   */
  #ifndef cmpwait
-#define cmpwait(ptr, val) do {                                 \
+#define cmpwait(ptr, val) ({                                   \
         typeof (ptr) __ptr = (ptr);                             \
-       typeof (val) __val = (val);                             \
-       while (READ_ONCE(*__ptr) == __val)                      \
+       typeof (val) __old = (val);                             \
+       typeof (val) __new;                                     \
+       for (;;) {                                              \
+               __new = READ_ONCE(*__ptr);                      \
+               if (__new != __old)                             \
+                       break;                                  \
                 cpu_relax();                                    \
-} while (0)
+       }                                                       \
+       __new;                                                  \
+})
  #endif

  /**
@@ -251,12 +257,11 @@ do {
  #ifndef smp_cond_load_acquire
  #define smp_cond_load_acquire(ptr, cond_expr) ({               \
         typeof(ptr) __PTR = (ptr);                              \
-       typeof(*ptr) VAL;                                       \
+       typeof(*ptr) VAL = READ_ONCE(*__PTR);                   \
         for (;;) {                                              \
-               VAL = READ_ONCE(*__PTR);                        \
                 if (cond_expr)                                  \
                         break;                                  \
-               cmpwait(__PTR, VAL);                            \
+               VAL = cmpwait(__PTR, VAL);                      \
         }                                                       \
         smp_acquire__after_ctrl_dep();                          \
         VAL;                                                    \

Cheers,
Longman
