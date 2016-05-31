From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -v3 4/8] locking, arch: Update spin_unlock_wait()
Date: Tue, 31 May 2016 11:41:38 +0200
Message-ID: <20160531094844.099477353@infradead.org>
References: <20160531094134.606249808@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: boqun.feng@gmail.com, Waiman.Long@hpe.com, tj@kernel.org,
	pablo@netfilter.org, kaber@trash.net, davem@davemloft.net,
	oleg@redhat.com, netfilter-devel@vger.kernel.org,
	sasha.levin@oracle.com, hofrat@osadl.org, peterz@infradead.org,
	jejb@parisc-linux.org, rth@twiddle.net, chris@zankel.net,
	dhowells@redhat.com, schwidefsky@de.ibm.com, linux@armlinux.org.uk,
	ralf@linux-mips.org, mpe@ellerman.id.au, vgupta@synopsys.com,
	rkuo@codeaurora.org, james.hogan@imgtec.com, realmz6@gmail.com,
	tony.luck@intel.com, ysato@users.sourceforge.jp,
	cmetcalf@mellanox.com
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=peterz-locking-spin_unlock_wait.patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch updates/fixes all spin_unlock_wait() implementations.

The update is in semantics; where it previously was only a control
dependency, we now upgrade to a full load-acquire to match the
store-release from the spin_unlock() we waited on. This ensures that
when spin_unlock_wait() returns, we're guaranteed to observe the full
critical section we waited on.

This fixes a number of spin_unlock_wait() users that (not
unreasonably) rely on this.

I also fixed a number of ticket lock versions to only wait on the
current lock holder, instead of for a full unlock, as this is
sufficient.

Furthermore; again for ticket locks; I added an smp_rmb() in between
the initial ticket load and the spin loop testing the current value
because I could not convince myself the address dependency is
sufficient, esp. if the loads are of different sizes.

I'm more than happy to remove this smp_rmb() again if people are
certain the address dependency does indeed work as expected.

Cc: jejb@parisc-linux.org
Cc: davem@davemloft.net
Cc: rth@twiddle.net
Cc: chris@zankel.net
Cc: dhowells@redhat.com
Cc: schwidefsky@de.ibm.com
Cc: linux@armlinux.org.uk
Cc: ralf@linux-mips.org
Cc: mpe@ellerman.id.au
Cc: vgupta@synopsys.com
Cc: rkuo@codeaurora.org
Cc: james.hogan@imgtec.com
Cc: realmz6@gmail.com
Cc: tony.luck@intel.com
Cc: ysato@users.sourceforge.jp
Cc: cmetcalf@mellanox.com
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/alpha/include/asm/spinlock.h    |    7 +++++--
 arch/arc/include/asm/spinlock.h      |    7 +++++--
 arch/arm/include/asm/spinlock.h      |   18 ++++++++++++++++--
 arch/blackfin/include/asm/spinlock.h |    3 +--
 arch/hexagon/include/asm/spinlock.h  |    8 ++++++--
 arch/ia64/include/asm/spinlock.h     |    2 ++
 arch/m32r/include/asm/spinlock.h     |    7 +++++--
 arch/metag/include/asm/spinlock.h    |   11 +++++++++--
 arch/mips/include/asm/spinlock.h     |   18 ++++++++++++++++--
 arch/mn10300/include/asm/spinlock.h  |    6 +++++-
 arch/parisc/include/asm/spinlock.h   |    9 +++++++--
 arch/powerpc/include/asm/spinlock.h  |    6 ++++--
 arch/s390/include/asm/spinlock.h     |    1 +
 arch/sh/include/asm/spinlock.h       |    7 +++++--
 arch/sparc/include/asm/spinlock_32.h |    6 ++++--
 arch/sparc/include/asm/spinlock_64.h |    9 ++++++---
 arch/tile/lib/spinlock_32.c          |    6 ++++++
 arch/tile/lib/spinlock_64.c          |    6 ++++++
 arch/xtensa/include/asm/spinlock.h   |    7 +++++--
 include/asm-generic/qspinlock.h      |    3 +--
 include/linux/spinlock_up.h          |    9 ++++++---
 21 files changed, 121 insertions(+), 35 deletions(-)

--- a/arch/alpha/include/asm/spinlock.h
+++ b/arch/alpha/include/asm/spinlock.h
@@ -13,8 +13,11 @@
 
 #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
 #define arch_spin_is_locked(x)	((x)->lock != 0)
-#define arch_spin_unlock_wait(x) \
-		do { cpu_relax(); } while ((x)->lock)
+
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
+{
+	smp_cond_load_acquire(&lock->lock, !VAL);
+}
 
 static inline int arch_spin_value_unlocked(arch_spinlock_t lock)
 {
--- a/arch/arc/include/asm/spinlock.h
+++ b/arch/arc/include/asm/spinlock.h
@@ -15,8 +15,11 @@
 
 #define arch_spin_is_locked(x)	((x)->slock != __ARCH_SPIN_LOCK_UNLOCKED__)
 #define arch_spin_lock_flags(lock, flags)	arch_spin_lock(lock)
-#define arch_spin_unlock_wait(x) \
-	do { while (arch_spin_is_locked(x)) cpu_relax(); } while (0)
+
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
+{
+	smp_cond_load_acquire(&lock->slock, !VAL);
+}
 
 #ifdef CONFIG_ARC_HAS_LLSC
 
--- a/arch/arm/include/asm/spinlock.h
+++ b/arch/arm/include/asm/spinlock.h
@@ -50,8 +50,22 @@ static inline void dsb_sev(void)
  * memory.
  */
 
-#define arch_spin_unlock_wait(lock) \
-	do { while (arch_spin_is_locked(lock)) cpu_relax(); } while (0)
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
+{
+	u16 owner = READ_ONCE(lock->tickets.owner);
+
+	smp_rmb();
+	for (;;) {
+		arch_spinlock_t tmp = READ_ONCE(*lock);
+
+		if (tmp.tickets.owner == tmp.tickets.next ||
+		    tmp.tickets.owner != owner)
+			break;
+
+		wfe();
+	}
+	smp_acquire__after_ctrl_dep();
+}
 
 #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
 
--- a/arch/blackfin/include/asm/spinlock.h
+++ b/arch/blackfin/include/asm/spinlock.h
@@ -48,8 +48,7 @@ static inline void arch_spin_unlock(arch
 
 static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
-	while (arch_spin_is_locked(lock))
-		cpu_relax();
+	smp_cond_load_acquire(&lock->lock, !VAL);
 }
 
 static inline int arch_read_can_lock(arch_rwlock_t *rw)
--- a/arch/hexagon/include/asm/spinlock.h
+++ b/arch/hexagon/include/asm/spinlock.h
@@ -176,8 +176,12 @@ static inline unsigned int arch_spin_try
  * SMP spinlocks are intended to allow only a single CPU at the lock
  */
 #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
-#define arch_spin_unlock_wait(lock) \
-	do {while (arch_spin_is_locked(lock)) cpu_relax(); } while (0)
+
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
+{
+	smp_cond_load_acquire(&lock->lock, !VAL);
+}
+
 #define arch_spin_is_locked(x) ((x)->lock != 0)
 
 #define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
--- a/arch/ia64/include/asm/spinlock.h
+++ b/arch/ia64/include/asm/spinlock.h
@@ -86,6 +86,8 @@ static __always_inline void __ticket_spi
 			return;
 		cpu_relax();
 	}
+
+	smp_acquire__after_ctrl_dep();
 }
 
 static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
--- a/arch/m32r/include/asm/spinlock.h
+++ b/arch/m32r/include/asm/spinlock.h
@@ -27,8 +27,11 @@
 
 #define arch_spin_is_locked(x)		(*(volatile int *)(&(x)->slock) <= 0)
 #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
-#define arch_spin_unlock_wait(x) \
-		do { cpu_relax(); } while (arch_spin_is_locked(x))
+
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
+{
+	smp_cond_load_acquire(&lock->slock, VAL > 0);
+}
 
 /**
  * arch_spin_trylock - Try spin lock and return a result
--- a/arch/metag/include/asm/spinlock.h
+++ b/arch/metag/include/asm/spinlock.h
@@ -7,8 +7,15 @@
 #include <asm/spinlock_lnkget.h>
 #endif
 
-#define arch_spin_unlock_wait(lock) \
-	do { while (arch_spin_is_locked(lock)) cpu_relax(); } while (0)
+/*
+ * both lock1 and lnkget are test-and-set spinlocks with 0 unlocked and 1
+ * locked.
+ */
+
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
+{
+	smp_cond_load_acquire(&lock->lock, !VAL);
+}
 
 #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
 
--- a/arch/mips/include/asm/spinlock.h
+++ b/arch/mips/include/asm/spinlock.h
@@ -48,8 +48,22 @@ static inline int arch_spin_value_unlock
 }
 
 #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
-#define arch_spin_unlock_wait(x) \
-	while (arch_spin_is_locked(x)) { cpu_relax(); }
+
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
+{
+	u16 owner = READ_ONCE(lock->h.serving_now);
+	smp_rmb();
+	for (;;) {
+		arch_spinlock_t tmp = READ_ONCE(*lock);
+
+		if (tmp.h.serving_now == tmp.h.ticket ||
+		    tmp.h.serving_now != owner)
+			break;
+
+		cpu_relax();
+	}
+	smp_acquire__after_ctrl_dep();
+}
 
 static inline int arch_spin_is_contended(arch_spinlock_t *lock)
 {
--- a/arch/mn10300/include/asm/spinlock.h
+++ b/arch/mn10300/include/asm/spinlock.h
@@ -23,7 +23,11 @@
  */
 
 #define arch_spin_is_locked(x)	(*(volatile signed char *)(&(x)->slock) != 0)
-#define arch_spin_unlock_wait(x) do { barrier(); } while (arch_spin_is_locked(x))
+
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
+{
+	smp_cond_load_acquire(&lock->slock, !VAL);
+}
 
 static inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
--- a/arch/parisc/include/asm/spinlock.h
+++ b/arch/parisc/include/asm/spinlock.h
@@ -13,8 +13,13 @@ static inline int arch_spin_is_locked(ar
 }
 
 #define arch_spin_lock(lock) arch_spin_lock_flags(lock, 0)
-#define arch_spin_unlock_wait(x) \
-		do { cpu_relax(); } while (arch_spin_is_locked(x))
+
+static inline void arch_spin_unlock_wait(arch_spinlock_t *x)
+{
+	volatile unsigned int *a = __ldcw_align(x);
+
+	smp_cond_load_acquire(a, VAL);
+}
 
 static inline void arch_spin_lock_flags(arch_spinlock_t *x,
 					 unsigned long flags)
--- a/arch/powerpc/include/asm/spinlock.h
+++ b/arch/powerpc/include/asm/spinlock.h
@@ -165,8 +165,10 @@ static inline void arch_spin_unlock(arch
 #ifdef CONFIG_PPC64
 extern void arch_spin_unlock_wait(arch_spinlock_t *lock);
 #else
-#define arch_spin_unlock_wait(lock) \
-	do { while (arch_spin_is_locked(lock)) cpu_relax(); } while (0)
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
+{
+	smp_cond_load_acquire(&lock->slock, !VAL);
+}
 #endif
 
 /*
--- a/arch/s390/include/asm/spinlock.h
+++ b/arch/s390/include/asm/spinlock.h
@@ -97,6 +97,7 @@ static inline void arch_spin_unlock_wait
 {
 	while (arch_spin_is_locked(lock))
 		arch_spin_relax(lock);
+	smp_acquire__after_ctrl_dep();
 }
 
 /*
--- a/arch/sh/include/asm/spinlock.h
+++ b/arch/sh/include/asm/spinlock.h
@@ -25,8 +25,11 @@
 
 #define arch_spin_is_locked(x)		((x)->lock <= 0)
 #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
-#define arch_spin_unlock_wait(x) \
-	do { while (arch_spin_is_locked(x)) cpu_relax(); } while (0)
+
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
+{
+	smp_cond_load_acquire(&lock->lock, VAL > 0);
+}
 
 /*
  * Simple spin lock operations.  There are two variants, one clears IRQ's
--- a/arch/sparc/include/asm/spinlock_32.h
+++ b/arch/sparc/include/asm/spinlock_32.h
@@ -13,8 +13,10 @@
 
 #define arch_spin_is_locked(lock) (*((volatile unsigned char *)(lock)) != 0)
 
-#define arch_spin_unlock_wait(lock) \
-	do { while (arch_spin_is_locked(lock)) cpu_relax(); } while (0)
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
+{
+	smp_cond_load_acquire(&lock->lock, !VAL);
+}
 
 static inline void arch_spin_lock(arch_spinlock_t *lock)
 {
--- a/arch/sparc/include/asm/spinlock_64.h
+++ b/arch/sparc/include/asm/spinlock_64.h
@@ -8,6 +8,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm/processor.h>
+
 /* To get debugging spinlocks which detect and catch
  * deadlock situations, set CONFIG_DEBUG_SPINLOCK
  * and rebuild your kernel.
@@ -23,9 +25,10 @@
 
 #define arch_spin_is_locked(lp)	((lp)->lock != 0)
 
-#define arch_spin_unlock_wait(lp)	\
-	do {	rmb();			\
-	} while((lp)->lock)
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
+{
+	smp_cond_load_acquire(&lock->lock, !VAL);
+}
 
 static inline void arch_spin_lock(arch_spinlock_t *lock)
 {
--- a/arch/tile/lib/spinlock_32.c
+++ b/arch/tile/lib/spinlock_32.c
@@ -76,6 +76,12 @@ void arch_spin_unlock_wait(arch_spinlock
 	do {
 		delay_backoff(iterations++);
 	} while (READ_ONCE(lock->current_ticket) == curr);
+
+	/*
+	 * The TILE architecture doesn't do read speculation; therefore
+	 * a control dependency guarantees a LOAD->{LOAD,STORE} order.
+	 */
+	barrier();
 }
 EXPORT_SYMBOL(arch_spin_unlock_wait);
 
--- a/arch/tile/lib/spinlock_64.c
+++ b/arch/tile/lib/spinlock_64.c
@@ -76,6 +76,12 @@ void arch_spin_unlock_wait(arch_spinlock
 	do {
 		delay_backoff(iterations++);
 	} while (arch_spin_current(READ_ONCE(lock->lock)) == curr);
+
+	/*
+	 * The TILE architecture doesn't do read speculation; therefore
+	 * a control dependency guarantees a LOAD->{LOAD,STORE} order.
+	 */
+	barrier();
 }
 EXPORT_SYMBOL(arch_spin_unlock_wait);
 
--- a/arch/xtensa/include/asm/spinlock.h
+++ b/arch/xtensa/include/asm/spinlock.h
@@ -29,8 +29,11 @@
  */
 
 #define arch_spin_is_locked(x) ((x)->slock != 0)
-#define arch_spin_unlock_wait(lock) \
-	do { while (arch_spin_is_locked(lock)) cpu_relax(); } while (0)
+
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
+{
+	smp_cond_load_acquire(&lock->slock, !VAL);
+}
 
 #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
 
--- a/include/asm-generic/qspinlock.h
+++ b/include/asm-generic/qspinlock.h
@@ -133,8 +133,7 @@ static inline void queued_spin_unlock_wa
 {
 	/* See queued_spin_is_locked() */
 	smp_mb();
-	while (atomic_read(&lock->val) & _Q_LOCKED_MASK)
-		cpu_relax();
+	smp_cond_load_acquire(&lock->val.counter, !(VAL & _Q_LOCKED_MASK));
 }
 
 #ifndef virt_spin_lock
--- a/include/linux/spinlock_up.h
+++ b/include/linux/spinlock_up.h
@@ -25,6 +25,11 @@
 #ifdef CONFIG_DEBUG_SPINLOCK
 #define arch_spin_is_locked(x)		((x)->slock == 0)
 
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
+{
+	smp_cond_load_acquire(&lock->slock, VAL);
+}
+
 static inline void arch_spin_lock(arch_spinlock_t *lock)
 {
 	lock->slock = 0;
@@ -67,6 +72,7 @@ static inline void arch_spin_unlock(arch
 
 #else /* DEBUG_SPINLOCK */
 #define arch_spin_is_locked(lock)	((void)(lock), 0)
+#define arch_spin_unlock_wait(lock)	do { barrier(); (void)(lock); } while (0)
 /* for sched/core.c and kernel_lock.c: */
 # define arch_spin_lock(lock)		do { barrier(); (void)(lock); } while (0)
 # define arch_spin_lock_flags(lock, flags)	do { barrier(); (void)(lock); } while (0)
@@ -79,7 +85,4 @@ static inline void arch_spin_unlock(arch
 #define arch_read_can_lock(lock)	(((void)(lock), 1))
 #define arch_write_can_lock(lock)	(((void)(lock), 1))
 
-#define arch_spin_unlock_wait(lock) \
-		do { cpu_relax(); } while (arch_spin_is_locked(lock))
-
 #endif /* __LINUX_SPINLOCK_UP_H */
