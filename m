From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -v4 1/7] locking: Replace smp_cond_acquire with smp_cond_load_acquire
Date: Thu, 02 Jun 2016 13:51:58 +0200
Message-ID: <20160602115438.810306465@infradead.org>
References: <20160602115157.249037373@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: boqun.feng@gmail.com, Waiman.Long@hpe.com, tj@kernel.org,
	pablo@netfilter.org, kaber@trash.net, davem@davemloft.net,
	oleg@redhat.com, netfilter-devel@vger.kernel.org,
	sasha.levin@oracle.com, hofrat@osadl.org, peterz@infradead.org
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=peterz-locking-smp_cond_load_acquire.patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This new form allows using hardware assisted waiting.

Some hardware (ARM64 and x86) allow monitoring an address for changes,
so by providing a pointer we can use this to replace the cpu_relax().

Requested-by: Will Deacon <will.deacon@arm.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/compiler.h   |   25 +++++++++++++++++++------
 kernel/locking/qspinlock.c |   12 ++++++------
 kernel/sched/core.c        |    8 ++++----
 kernel/sched/sched.h       |    2 +-
 kernel/smp.c               |    2 +-
 5 files changed, 31 insertions(+), 18 deletions(-)

--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -305,21 +305,34 @@ static __always_inline void __write_once
 })
 
 /**
- * smp_cond_acquire() - Spin wait for cond with ACQUIRE ordering
+ * smp_cond_load_acquire() - (Spin) wait for cond with ACQUIRE ordering
+ * @ptr: pointer to the variable to wait on
  * @cond: boolean expression to wait for
  *
  * Equivalent to using smp_load_acquire() on the condition variable but employs
  * the control dependency of the wait to reduce the barrier on many platforms.
  *
+ * Due to C lacking lambda expressions we load the value of *ptr into a
+ * pre-named variable @VAL to be used in @cond.
+ *
  * The control dependency provides a LOAD->STORE order, the additional RMB
  * provides LOAD->LOAD order, together they provide LOAD->{LOAD,STORE} order,
  * aka. ACQUIRE.
  */
-#define smp_cond_acquire(cond)	do {		\
-	while (!(cond))				\
-		cpu_relax();			\
-	smp_rmb(); /* ctrl + rmb := acquire */	\
-} while (0)
+#ifndef smp_cond_load_acquire
+#define smp_cond_load_acquire(ptr, cond_expr) ({		\
+	typeof(ptr) __PTR = (ptr);				\
+	typeof(*ptr) VAL;					\
+	for (;;) {						\
+		VAL = READ_ONCE(*__PTR);			\
+		if (cond_expr)					\
+			break;					\
+		cpu_relax();					\
+	}							\
+	smp_rmb(); /* ctrl + rmb := acquire */			\
+	VAL;							\
+})
+#endif
 
 #endif /* __KERNEL__ */
 
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -358,7 +358,7 @@ void queued_spin_lock_slowpath(struct qs
 	 * sequentiality; this is because not all clear_pending_set_locked()
 	 * implementations imply full barriers.
 	 */
-	smp_cond_acquire(!(atomic_read(&lock->val) & _Q_LOCKED_MASK));
+	smp_cond_load_acquire(&lock->val.counter, !(VAL & _Q_LOCKED_MASK));
 
 	/*
 	 * take ownership and clear the pending bit.
@@ -434,7 +434,7 @@ void queued_spin_lock_slowpath(struct qs
 	 *
 	 * The PV pv_wait_head_or_lock function, if active, will acquire
 	 * the lock and return a non-zero value. So we have to skip the
-	 * smp_cond_acquire() call. As the next PV queue head hasn't been
+	 * smp_cond_load_acquire() call. As the next PV queue head hasn't been
 	 * designated yet, there is no way for the locked value to become
 	 * _Q_SLOW_VAL. So both the set_locked() and the
 	 * atomic_cmpxchg_relaxed() calls will be safe.
@@ -445,7 +445,7 @@ void queued_spin_lock_slowpath(struct qs
 	if ((val = pv_wait_head_or_lock(lock, node)))
 		goto locked;
 
-	smp_cond_acquire(!((val = atomic_read(&lock->val)) & _Q_LOCKED_PENDING_MASK));
+	val = smp_cond_load_acquire(&lock->val.counter, !(VAL & _Q_LOCKED_PENDING_MASK));
 
 locked:
 	/*
@@ -465,9 +465,9 @@ void queued_spin_lock_slowpath(struct qs
 			break;
 		}
 		/*
-		 * The smp_cond_acquire() call above has provided the necessary
-		 * acquire semantics required for locking. At most two
-		 * iterations of this loop may be ran.
+		 * The smp_cond_load_acquire() call above has provided the
+		 * necessary acquire semantics required for locking. At most
+		 * two iterations of this loop may be ran.
 		 */
 		old = atomic_cmpxchg_relaxed(&lock->val, val, _Q_LOCKED_VAL);
 		if (old == val)
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1843,7 +1843,7 @@ static void ttwu_queue(struct task_struc
  * chain to provide order. Instead we do:
  *
  *   1) smp_store_release(X->on_cpu, 0)
- *   2) smp_cond_acquire(!X->on_cpu)
+ *   2) smp_cond_load_acquire(!X->on_cpu)
  *
  * Example:
  *
@@ -1854,7 +1854,7 @@ static void ttwu_queue(struct task_struc
  *   sched-out X
  *   smp_store_release(X->on_cpu, 0);
  *
- *                    smp_cond_acquire(!X->on_cpu);
+ *                    smp_cond_load_acquire(&X->on_cpu, !VAL);
  *                    X->state = WAKING
  *                    set_task_cpu(X,2)
  *
@@ -1880,7 +1880,7 @@ static void ttwu_queue(struct task_struc
  * This means that any means of doing remote wakeups must order the CPU doing
  * the wakeup against the CPU the task is going to end up running on. This,
  * however, is already required for the regular Program-Order guarantee above,
- * since the waking CPU is the one issueing the ACQUIRE (smp_cond_acquire).
+ * since the waking CPU is the one issueing the ACQUIRE (smp_cond_load_acquire).
  *
  */
 
@@ -1953,7 +1953,7 @@ try_to_wake_up(struct task_struct *p, un
 	 * This ensures that tasks getting woken will be fully ordered against
 	 * their previous state and preserve Program Order.
 	 */
-	smp_cond_acquire(!p->on_cpu);
+	smp_cond_load_acquire(&p->on_cpu, !VAL);
 
 	p->sched_contributes_to_load = !!task_contributes_to_load(p);
 	p->state = TASK_WAKING;
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1104,7 +1104,7 @@ static inline void finish_lock_switch(st
 	 * In particular, the load of prev->state in finish_task_switch() must
 	 * happen before this.
 	 *
-	 * Pairs with the smp_cond_acquire() in try_to_wake_up().
+	 * Pairs with the smp_cond_load_acquire() in try_to_wake_up().
 	 */
 	smp_store_release(&prev->on_cpu, 0);
 #endif
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -107,7 +107,7 @@ void __init call_function_init(void)
  */
 static __always_inline void csd_lock_wait(struct call_single_data *csd)
 {
-	smp_cond_acquire(!(csd->flags & CSD_FLAG_LOCK));
+	smp_cond_load_acquire(&csd->flags, !(VAL & CSD_FLAG_LOCK));
 }
 
 static __always_inline void csd_lock(struct call_single_data *csd)
