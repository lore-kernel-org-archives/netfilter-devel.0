From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v4 5/7] locking, arch: Update spin_unlock_wait()
Date: Thu, 2 Jun 2016 18:34:25 +0200
Message-ID: <20160602163425.GV3205@twins.programming.kicks-ass.net>
References: <20160602115157.249037373@infradead.org>
 <20160602115439.085385545@infradead.org>
 <20160602142440.GE30064@insomnia>
 <20160602144424.GV3193@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com,
	Waiman.Long@hpe.com, tj@kernel.org, pablo@netfilter.org,
	kaber@trash.net, davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org, jejb@parisc-linux.org, chris@zankel.net,
	rth@twiddle.net, dhowells@redhat.com, schwidefsky@de.ibm.com,
	mpe@ellerman.id.au, ralf@linux-mips.org, linux@armlinux.org.uk,
	rkuo@codeaurora.org, vgupta@synopsys.com, james.hogan@imgtec.com,
	realmz6@gmail.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
	cmetcalf@mellanox.com
To: Boqun Feng <boqun.feng@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160602144424.GV3193@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 02, 2016 at 04:44:24PM +0200, Peter Zijlstra wrote:
> On Thu, Jun 02, 2016 at 10:24:40PM +0800, Boqun Feng wrote:
> > On Thu, Jun 02, 2016 at 01:52:02PM +0200, Peter Zijlstra wrote:
> > About spin_unlock_wait() on ppc, I actually have a fix pending review:
> > 
> > http://lkml.kernel.org/r/1461130033-70898-1-git-send-email-boqun.feng@gmail.com
> 
> > that patch fixed a different problem when people want to pair a
> > spin_unlock_wait() with a spin_lock().
> 
> Argh, indeed, and I think qspinlock is still broken there :/ But my poor
> brain is about to give in for the day.

This 'replaces' commit:

  54cf809b9512 ("locking,qspinlock: Fix spin_is_locked() and spin_unlock_wait()")

and seems to still work with the test case from that thread while
getting rid of the extra barriers.

---
 include/asm-generic/qspinlock.h | 37 +++++++----------------------------
 kernel/locking/qspinlock.c      | 43 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 30 deletions(-)

diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
index 6bd05700d8c9..9e3dff16d5dc 100644
--- a/include/asm-generic/qspinlock.h
+++ b/include/asm-generic/qspinlock.h
@@ -28,30 +28,13 @@
  */
 static __always_inline int queued_spin_is_locked(struct qspinlock *lock)
 {
-	/*
-	 * queued_spin_lock_slowpath() can ACQUIRE the lock before
-	 * issuing the unordered store that sets _Q_LOCKED_VAL.
-	 *
-	 * See both smp_cond_acquire() sites for more detail.
-	 *
-	 * This however means that in code like:
-	 *
-	 *   spin_lock(A)		spin_lock(B)
-	 *   spin_unlock_wait(B)	spin_is_locked(A)
-	 *   do_something()		do_something()
+	/* 
+	 * See queued_spin_unlock_wait().
 	 *
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
 
 /**
@@ -123,19 +106,13 @@ static __always_inline void queued_spin_unlock(struct qspinlock *lock)
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
+void queued_spin_unlock_wait(struct qspinlock *lock);
 
 #ifndef virt_spin_lock
 static __always_inline bool virt_spin_lock(struct qspinlock *lock)
diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index ce2f75e32ae1..3a4e4b34584e 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -496,6 +496,49 @@ void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 EXPORT_SYMBOL(queued_spin_lock_slowpath);
 
 /*
+ * queued_spin_lock_slowpath() can ACQUIRE the lock before
+ * issuing an _unordered_ store to set _Q_LOCKED_VAL.
+ *
+ * This means that the store can be delayed, but no later than the
+ * store-release from the unlock. This means that simply observing
+ * _Q_LOCKED_VAL is not sufficient to determine if the lock is acquired.
+ *
+ * There are two sites that can issue the unordered store:
+ *
+ *  - clear_pending_set_locked(): *,1,0 -> *,0,1
+ *  - set_locked(): t,0,0 -> t,0,1 ; t != 0
+ *
+ * In both cases we have other !0 state that is observable before the
+ * lock store comes through. This means we can use that to wait for
+ * the lock store, and then wait for an unlock.
+ */
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
+
+/*
  * Generate the paravirt code for queued_spin_unlock_slowpath().
  */
 #if !defined(_GEN_PV_LOCK_SLOWPATH) && defined(CONFIG_PARAVIRT_SPINLOCKS)
