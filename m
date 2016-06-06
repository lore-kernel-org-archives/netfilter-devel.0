From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v4 5/7] locking, arch: Update spin_unlock_wait()
Date: Mon, 6 Jun 2016 18:08:36 +0200
Message-ID: <20160606160836.GC30154@twins.programming.kicks-ass.net>
References: <20160602115157.249037373@infradead.org>
 <20160602115439.085385545@infradead.org>
 <20160602142440.GE30064@insomnia>
 <20160602144424.GV3193@twins.programming.kicks-ass.net>
 <20160602163425.GV3205@twins.programming.kicks-ass.net>
 <20160602175659.GB7697@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boqun Feng <boqun.feng@gmail.com>, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, manfred@colorfullife.com,
	dave@stgolabs.net, paulmck@linux.vnet.ibm.com, Waiman.Long@hpe.com,
	tj@kernel.org, pablo@netfilter.org, kaber@trash.net,
	davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org, jejb@parisc-linux.org, chris@zankel.net,
	rth@twiddle.net, dhowells@redhat.com, schwidefsky@de.ibm.com,
	mpe@ellerman.id.au, ralf@linux-mips.org, linux@armlinux.org.uk,
	rkuo@codeaurora.org, vgupta@synopsys.com, james.hogan@imgtec.com,
	realmz6@gmail.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
	cmetcalf@mellanox.com
To: Will Deacon <will.deacon@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160602175659.GB7697@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 02, 2016 at 06:57:00PM +0100, Will Deacon wrote:
> > This 'replaces' commit:
> > 
> >   54cf809b9512 ("locking,qspinlock: Fix spin_is_locked() and spin_unlock_wait()")
> > 
> > and seems to still work with the test case from that thread while
> > getting rid of the extra barriers.

New version :-)

This one has moar comments; and also tries to address an issue with
xchg_tail(), which is its own consumer. Paul, Will said you'd love the
address dependency through union members :-)

(I should split this in at least 3 patches I suppose)

ARM64 and PPC should provide private versions of is_locked and
unlock_wait; because while this one deals with the unordered store as
per qspinlock construction, it still relies on cmpxchg_acquire()'s store
being visible.

---
 include/asm-generic/qspinlock.h |  40 ++++---------
 kernel/locking/qspinlock.c      | 126 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 137 insertions(+), 29 deletions(-)

diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
index 6bd05700d8c9..3020bdb7a43c 100644
--- a/include/asm-generic/qspinlock.h
+++ b/include/asm-generic/qspinlock.h
@@ -26,33 +26,18 @@
  * @lock: Pointer to queued spinlock structure
  * Return: 1 if it is locked, 0 otherwise
  */
+#ifndef queued_spin_is_locked
 static __always_inline int queued_spin_is_locked(struct qspinlock *lock)
 {
 	/*
-	 * queued_spin_lock_slowpath() can ACQUIRE the lock before
-	 * issuing the unordered store that sets _Q_LOCKED_VAL.
+	 * See queued_spin_unlock_wait().
 	 *
-	 * See both smp_cond_acquire() sites for more detail.
-	 *
-	 * This however means that in code like:
-	 *
-	 *   spin_lock(A)		spin_lock(B)
-	 *   spin_unlock_wait(B)	spin_is_locked(A)
-	 *   do_something()		do_something()
-	 *
-	 * Both CPUs can end up running do_something() because the store
-	 * setting _Q_LOCKED_VAL will pass through the loads in
-	 * spin_unlock_wait() and/or spin_is_locked().
-	 *
-	 * Avoid this by issuing a full memory barrier between the spin_lock()
-	 * and the loads in spin_unlock_wait() and spin_is_locked().
-	 *
-	 * Note that regular mutual exclusion doesn't care about this
-	 * delayed store.
+	 * Any !0 state indicates it is locked, even if _Q_LOCKED_VAL
+	 * isn't immediately observable.
 	 */
-	smp_mb();
-	return atomic_read(&lock->val) & _Q_LOCKED_MASK;
+	return !!atomic_read(&lock->val);
 }
+#endif
 
 /**
  * queued_spin_value_unlocked - is the spinlock structure unlocked?
@@ -78,6 +63,7 @@ static __always_inline int queued_spin_is_contended(struct qspinlock *lock)
 {
 	return atomic_read(&lock->val) & ~_Q_LOCKED_MASK;
 }
+
 /**
  * queued_spin_trylock - try to acquire the queued spinlock
  * @lock : Pointer to queued spinlock structure
@@ -123,19 +109,15 @@ static __always_inline void queued_spin_unlock(struct qspinlock *lock)
 #endif
 
 /**
- * queued_spin_unlock_wait - wait until current lock holder releases the lock
+ * queued_spin_unlock_wait - wait until the _current_ lock holder releases the lock
  * @lock : Pointer to queued spinlock structure
  *
  * There is a very slight possibility of live-lock if the lockers keep coming
  * and the waiter is just unfortunate enough to not see any unlock state.
  */
-static inline void queued_spin_unlock_wait(struct qspinlock *lock)
-{
-	/* See queued_spin_is_locked() */
-	smp_mb();
-	while (atomic_read(&lock->val) & _Q_LOCKED_MASK)
-		cpu_relax();
-}
+#ifndef queued_spin_unlock_wait
+void queued_spin_unlock_wait(struct qspinlock *lock);
+#endif
 
 #ifndef virt_spin_lock
 static __always_inline bool virt_spin_lock(struct qspinlock *lock)
diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index ce2f75e32ae1..e1c29d352e0e 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -395,6 +395,8 @@ void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	 * pending stuff.
 	 *
 	 * p,*,* -> n,*,*
+	 *
+	 * RELEASE, such that the stores to @node must be complete.
 	 */
 	old = xchg_tail(lock, tail);
 	next = NULL;
@@ -405,6 +407,15 @@ void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	 */
 	if (old & _Q_TAIL_MASK) {
 		prev = decode_tail(old);
+		/*
+		 * The above xchg_tail() is also load of @lock which generates,
+		 * through decode_tail(), a pointer.
+		 *
+		 * The address dependency matches the RELEASE of xchg_tail()
+		 * such that the access to @prev must happen after.
+		 */
+		smp_read_barrier_depends();
+
 		WRITE_ONCE(prev->next, node);
 
 		pv_wait_node(node, prev);
@@ -496,6 +507,121 @@ void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 EXPORT_SYMBOL(queued_spin_lock_slowpath);
 
 /*
+ * PROBLEM: some architectures have an interesting issue with atomic ACQUIRE
+ * operations in that the ACQUIRE applies to the LOAD _not_ the STORE (ARM64,
+ * PPC). Also qspinlock has a similar issue per construction, the setting of
+ * the locked byte can be unordered acquiring the lock proper.
+ *
+ * This gets to be 'interesting' in the following cases, where the /should/s
+ * end up false because of this issue.
+ *
+ *
+ * CASE 1:
+ *
+ * So the spin_is_locked() correctness issue comes from something like:
+ *
+ *   CPU0				CPU1
+ *
+ *   global_lock();			local_lock(i)
+ *     spin_lock(&G)			  spin_lock(&L[i])
+ *     for (i)				  if (!spin_is_locked(&G)) {
+ *       spin_unlock_wait(&L[i]);	    smp_acquire__after_ctrl_dep();
+ * 					    return;
+ * 					  }
+ * 					  // deal with fail
+ *
+ * Where it is important CPU1 sees G locked or CPU0 sees L[i] locked such
+ * that there is exclusion between the two critical sections.
+ *
+ * The load from spin_is_locked(&G) /should/ be constrained by the ACQUIRE from
+ * spin_lock(&L[i]), and similarly the load(s) from spin_unlock_wait(&L[i])
+ * /should/ be constrained by the ACQUIRE from spin_lock(&G).
+ *
+ * Similarly, later stuff is constrained by the ACQUIRE from CTRL+RMB.
+ *
+ *
+ * CASE 2:
+ *
+ * For spin_unlock_wait() there is a second correctness issue, namely:
+ *
+ *   CPU0				CPU1
+ *
+ *   flag = set;
+ *   smp_mb();				spin_lock(&l)
+ *   spin_unlock_wait(&l);		if (!flag)
+ *					  // add to lockless list
+ * 					spin_unlock(&l);
+ *   // iterate lockless list
+ *
+ * Which wants to ensure that CPU1 will stop adding bits to the list and CPU0
+ * will observe the last entry on the list (if spin_unlock_wait() had ACQUIRE
+ * semantics etc..)
+ *
+ * Where flag /should/ be ordered against the locked store of l.
+ */
+
+
+/*
+ * queued_spin_lock_slowpath() can (load-)ACQUIRE the lock before
+ * issuing an _unordered_ store to set _Q_LOCKED_VAL.
+ *
+ * This means that the store can be delayed, but no later than the
+ * store-release from the unlock. This means that simply observing
+ * _Q_LOCKED_VAL is not sufficient to determine if the lock is acquired.
+ *
+ * There are two paths that can issue the unordered store:
+ *
+ *  (1) clear_pending_set_locked():	*,1,0 -> *,0,1
+ *
+ *  (2) set_locked():			t,0,0 -> t,0,1 ; t != 0
+ *      atomic_cmpxchg_relaxed():	t,0,0 -> 0,0,1
+ *
+ * However, in both cases we have other !0 state we've set before to queue
+ * ourseves:
+ *
+ * For (1) we have the atomic_cmpxchg_acquire() that set _Q_PENDING_VAL, our
+ * load is constrained by that ACQUIRE to not pass before that, and thus must
+ * observe the store.
+ *
+ * For (2) we have a more intersting scenario. We enqueue ourselves using
+ * xchg_tail(), which ends up being a RELEASE. This in itself is not
+ * sufficient, however that is followed by an smp_cond_acquire() on the same
+ * word, giving a RELEASE->ACQUIRE ordering. This again constrains our load and
+ * guarantees we must observe that store.
+ *
+ * Therefore both cases have other !0 state that is observable before the
+ * unordered locked byte store comes through. This means we can use that to
+ * wait for the lock store, and then wait for an unlock.
+ */
+#ifndef queued_spin_unlock_wait
+void queued_spin_unlock_wait(struct qspinlock *lock)
+{
+	u32 val;
+
+	for (;;) {
+		val = atomic_read(&lock->val);
+
+		if (!val) /* not locked, we're done */
+			goto done;
+
+		if (val & _Q_LOCKED_MASK) /* locked, go wait for unlock */
+			break;
+
+		/* not locked, but pending, wait until we observe the lock */
+		cpu_relax();
+	}
+
+	/* any unlock is good */
+	while (atomic_read(&lock->val) & _Q_LOCKED_MASK)
+		cpu_relax();
+
+done:
+	smp_rmb();
+}
+EXPORT_SYMBOL(queued_spin_unlock_wait);
+#endif
+
+/*
  * Generate the paravirt code for queued_spin_unlock_slowpath().
  */
 #if !defined(_GEN_PV_LOCK_SLOWPATH) && defined(CONFIG_PARAVIRT_SPINLOCKS)
