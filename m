From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -v3 7/8] locking: Move smp_cond_load_acquire() and friends into asm-generic/barrier.h
Date: Tue, 31 May 2016 11:41:41 +0200
Message-ID: <20160531094844.282806055@infradead.org>
References: <20160531094134.606249808@infradead.org>
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
Content-Disposition: inline; filename=peterz-asm-generic-barrier.patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Since all asm/barrier.h should/must include asm-generic/barrier.h the
latter is a good place for generic infrastructure like this.

This also allows archs to override the new
smp_acquire__after_ctrl_dep().

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/alpha/include/asm/spinlock.h    |    2 +
 arch/arm/include/asm/spinlock.h      |    2 +
 arch/blackfin/include/asm/spinlock.h |    2 +
 arch/hexagon/include/asm/spinlock.h  |    2 +
 arch/ia64/include/asm/spinlock.h     |    2 +
 arch/m32r/include/asm/spinlock.h     |    2 +
 arch/metag/include/asm/spinlock.h    |    3 +
 arch/mips/include/asm/spinlock.h     |    1 
 arch/mn10300/include/asm/spinlock.h  |    2 +
 arch/powerpc/include/asm/spinlock.h  |    2 +
 arch/s390/include/asm/spinlock.h     |    2 +
 arch/sh/include/asm/spinlock.h       |    3 +
 arch/sparc/include/asm/spinlock_32.h |    1 
 arch/sparc/include/asm/spinlock_64.h |    1 
 arch/xtensa/include/asm/spinlock.h   |    3 +
 include/asm-generic/barrier.h        |   58 ++++++++++++++++++++++++++++++++++-
 include/asm-generic/qspinlock.h      |    2 +
 include/linux/compiler.h             |   55 ---------------------------------
 include/linux/spinlock_up.h          |    1 
 19 files changed, 90 insertions(+), 56 deletions(-)

--- a/arch/alpha/include/asm/spinlock.h
+++ b/arch/alpha/include/asm/spinlock.h
@@ -3,6 +3,8 @@
 
 #include <linux/kernel.h>
 #include <asm/current.h>
+#include <asm/barrier.h>
+#include <asm/processor.h>
 
 /*
  * Simple spin lock operations.  There are two variants, one clears IRQ's
--- a/arch/arm/include/asm/spinlock.h
+++ b/arch/arm/include/asm/spinlock.h
@@ -6,6 +6,8 @@
 #endif
 
 #include <linux/prefetch.h>
+#include <asm/barrier.h>
+#include <asm/processor.h>
 
 /*
  * sev and wfe are ARMv6K extensions.  Uniprocessor ARMv6 may not have the K
--- a/arch/blackfin/include/asm/spinlock.h
+++ b/arch/blackfin/include/asm/spinlock.h
@@ -12,6 +12,8 @@
 #else
 
 #include <linux/atomic.h>
+#include <asm/processor.h>
+#include <asm/barrier.h>
 
 asmlinkage int __raw_spin_is_locked_asm(volatile int *ptr);
 asmlinkage void __raw_spin_lock_asm(volatile int *ptr);
--- a/arch/hexagon/include/asm/spinlock.h
+++ b/arch/hexagon/include/asm/spinlock.h
@@ -23,6 +23,8 @@
 #define _ASM_SPINLOCK_H
 
 #include <asm/irqflags.h>
+#include <asm/barrier.h>
+#include <asm/processor.h>
 
 /*
  * This file is pulled in for SMP builds.
--- a/arch/ia64/include/asm/spinlock.h
+++ b/arch/ia64/include/asm/spinlock.h
@@ -15,6 +15,8 @@
 
 #include <linux/atomic.h>
 #include <asm/intrinsics.h>
+#include <asm/barrier.h>
+#include <asm/processor.h>
 
 #define arch_spin_lock_init(x)			((x)->lock = 0)
 
--- a/arch/m32r/include/asm/spinlock.h
+++ b/arch/m32r/include/asm/spinlock.h
@@ -13,6 +13,8 @@
 #include <linux/atomic.h>
 #include <asm/dcache_clear.h>
 #include <asm/page.h>
+#include <asm/barrier.h>
+#include <asm/processor.h>
 
 /*
  * Your basic SMP spinlocks, allowing only a single CPU anywhere
--- a/arch/metag/include/asm/spinlock.h
+++ b/arch/metag/include/asm/spinlock.h
@@ -1,6 +1,9 @@
 #ifndef __ASM_SPINLOCK_H
 #define __ASM_SPINLOCK_H
 
+#include <asm/barrier.h>
+#include <asm/processor.h>
+
 #ifdef CONFIG_METAG_ATOMICITY_LOCK1
 #include <asm/spinlock_lock1.h>
 #else
--- a/arch/mips/include/asm/spinlock.h
+++ b/arch/mips/include/asm/spinlock.h
@@ -12,6 +12,7 @@
 #include <linux/compiler.h>
 
 #include <asm/barrier.h>
+#include <asm/processor.h>
 #include <asm/compiler.h>
 #include <asm/war.h>
 
--- a/arch/mn10300/include/asm/spinlock.h
+++ b/arch/mn10300/include/asm/spinlock.h
@@ -12,6 +12,8 @@
 #define _ASM_SPINLOCK_H
 
 #include <linux/atomic.h>
+#include <asm/barrier.h>
+#include <asm/processor.h>
 #include <asm/rwlock.h>
 #include <asm/page.h>
 
--- a/arch/powerpc/include/asm/spinlock.h
+++ b/arch/powerpc/include/asm/spinlock.h
@@ -27,6 +27,8 @@
 #include <asm/asm-compat.h>
 #include <asm/synch.h>
 #include <asm/ppc-opcode.h>
+#include <asm/barrier.h>
+#include <asm/processor.h>
 
 #ifdef CONFIG_PPC64
 /* use 0x800000yy when locked, where yy == CPU number */
--- a/arch/s390/include/asm/spinlock.h
+++ b/arch/s390/include/asm/spinlock.h
@@ -10,6 +10,8 @@
 #define __ASM_SPINLOCK_H
 
 #include <linux/smp.h>
+#include <asm/barrier.h>
+#include <asm/processor.h>
 
 #define SPINLOCK_LOCKVAL (S390_lowcore.spinlock_lockval)
 
--- a/arch/sh/include/asm/spinlock.h
+++ b/arch/sh/include/asm/spinlock.h
@@ -19,6 +19,9 @@
 #error "Need movli.l/movco.l for spinlocks"
 #endif
 
+#include <asm/barrier.h>
+#include <asm/processor.h>
+
 /*
  * Your basic SMP spinlocks, allowing only a single CPU anywhere
  */
--- a/arch/sparc/include/asm/spinlock_32.h
+++ b/arch/sparc/include/asm/spinlock_32.h
@@ -9,6 +9,7 @@
 #ifndef __ASSEMBLY__
 
 #include <asm/psr.h>
+#include <asm/barrier.h>
 #include <asm/processor.h> /* for cpu_relax */
 
 #define arch_spin_is_locked(lock) (*((volatile unsigned char *)(lock)) != 0)
--- a/arch/sparc/include/asm/spinlock_64.h
+++ b/arch/sparc/include/asm/spinlock_64.h
@@ -9,6 +9,7 @@
 #ifndef __ASSEMBLY__
 
 #include <asm/processor.h>
+#include <asm/barrier.h>
 
 /* To get debugging spinlocks which detect and catch
  * deadlock situations, set CONFIG_DEBUG_SPINLOCK
--- a/arch/xtensa/include/asm/spinlock.h
+++ b/arch/xtensa/include/asm/spinlock.h
@@ -11,6 +11,9 @@
 #ifndef _XTENSA_SPINLOCK_H
 #define _XTENSA_SPINLOCK_H
 
+#include <asm/barrier.h>
+#include <asm/processor.h>
+
 /*
  * spinlock
  *
--- a/include/asm-generic/barrier.h
+++ b/include/asm-generic/barrier.h
@@ -194,7 +194,7 @@ do {									\
 })
 #endif
 
-#endif
+#endif	/* CONFIG_SMP */
 
 /* Barriers for virtual machine guests when talking to an SMP host */
 #define virt_mb() __smp_mb()
@@ -207,5 +207,61 @@ do {									\
 #define virt_store_release(p, v) __smp_store_release(p, v)
 #define virt_load_acquire(p) __smp_load_acquire(p)
 
+/**
+ * smp_acquire__after_ctrl_dep() - Provide ACQUIRE ordering after a control dependency
+ *
+ * A control dependency provides a LOAD->STORE order, the additional RMB
+ * provides LOAD->LOAD order, together they provide LOAD->{LOAD,STORE} order,
+ * aka. (load)-ACQUIRE.
+ *
+ * Architectures that do not do load speculation can have this be barrier().
+ */
+#ifndef smp_acquire__after_ctrl_dep
+#define smp_acquire__after_ctrl_dep()		smp_rmb()
+#endif
+
+/**
+ * cmpwait - compare and wait for a variable to change
+ * @ptr: pointer to the variable to wait on
+ * @val: the value it should change from
+ *
+ * A simple constuct that waits for a variable to change from a known
+ * value; some architectures can do this in hardware.
+ */
+#ifndef cmpwait
+#define cmpwait(ptr, val) do {					\
+	typeof (ptr) __ptr = (ptr);				\
+	typeof (val) __val = (val);				\
+	while (READ_ONCE(*__ptr) == __val)			\
+		cpu_relax();					\
+} while (0)
+#endif
+
+/**
+ * smp_cond_load_acquire() - (Spin) wait for cond with ACQUIRE ordering
+ * @ptr: pointer to the variable to wait on
+ * @cond: boolean expression to wait for
+ *
+ * Equivalent to using smp_load_acquire() on the condition variable but employs
+ * the control dependency of the wait to reduce the barrier on many platforms.
+ *
+ * Due to C lacking lambda expressions we load the value of *ptr into a
+ * pre-named variable @VAL to be used in @cond.
+ */
+#ifndef smp_cond_load_acquire
+#define smp_cond_load_acquire(ptr, cond_expr) ({		\
+	typeof(ptr) __PTR = (ptr);				\
+	typeof(*ptr) VAL;					\
+	for (;;) {						\
+		VAL = READ_ONCE(*__PTR);			\
+		if (cond_expr)					\
+			break;					\
+		cmpwait(__PTR, VAL);				\
+	}							\
+	smp_acquire__after_ctrl_dep();				\
+	VAL;							\
+})
+#endif
+
 #endif /* !__ASSEMBLY__ */
 #endif /* __ASM_GENERIC_BARRIER_H */
--- a/include/asm-generic/qspinlock.h
+++ b/include/asm-generic/qspinlock.h
@@ -20,6 +20,8 @@
 #define __ASM_GENERIC_QSPINLOCK_H
 
 #include <asm-generic/qspinlock_types.h>
+#include <asm/barrier.h>
+#include <asm/processor.h>
 
 /**
  * queued_spin_is_locked - is the spinlock locked?
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -304,61 +304,6 @@ static __always_inline void __write_once
 	__u.__val;					\
 })
 
-/**
- * smp_acquire__after_ctrl_dep() - Provide ACQUIRE ordering after a control dependency
- *
- * A control dependency provides a LOAD->STORE order, the additional RMB
- * provides LOAD->LOAD order, together they provide LOAD->{LOAD,STORE} order,
- * aka. (load)-ACQUIRE.
- *
- * Architectures that do not do load speculation can have this be barrier().
- * XXX move into asm/barrier.h
- */
-#define smp_acquire__after_ctrl_dep()		smp_rmb()
-
-/**
- * cmpwait - compare and wait for a variable to change
- * @ptr: pointer to the variable to wait on
- * @val: the value it should change from
- *
- * A simple constuct that waits for a variable to change from a known
- * value; some architectures can do this in hardware.
- */
-#ifndef cmpwait
-#define cmpwait(ptr, val) do {					\
-	typeof (ptr) __ptr = (ptr);				\
-	typeof (val) __val = (val);				\
-	while (READ_ONCE(*__ptr) == __val)			\
-		cpu_relax();					\
-} while (0)
-#endif
-
-/**
- * smp_cond_load_acquire() - (Spin) wait for cond with ACQUIRE ordering
- * @ptr: pointer to the variable to wait on
- * @cond: boolean expression to wait for
- *
- * Equivalent to using smp_load_acquire() on the condition variable but employs
- * the control dependency of the wait to reduce the barrier on many platforms.
- *
- * Due to C lacking lambda expressions we load the value of *ptr into a
- * pre-named variable @VAL to be used in @cond.
- */
-#ifndef smp_cond_load_acquire
-#define smp_cond_load_acquire(ptr, cond_expr) ({		\
-	typeof(ptr) __PTR = (ptr);				\
-	typeof(*ptr) VAL;					\
-	for (;;) {						\
-		VAL = READ_ONCE(*__PTR);			\
-		if (cond_expr)					\
-			break;					\
-		cmpwait(__PTR, VAL);				\
-	}							\
-	smp_acquire__after_ctrl_dep();				\
-	VAL;							\
-})
-#endif
-
 #endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */
--- a/include/linux/spinlock_up.h
+++ b/include/linux/spinlock_up.h
@@ -6,6 +6,7 @@
 #endif
 
 #include <asm/processor.h>	/* for cpu_relax() */
+#include <asm/barrier.h>
 
 /*
  * include/linux/spinlock_up.h - UP-debug version of spinlocks.
