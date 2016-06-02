From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -v4 3/7] locking: Move smp_cond_load_acquire() to asm-generic/barrier.h
Date: Thu, 02 Jun 2016 13:52:00 +0200
Message-ID: <20160602115438.964652080@infradead.org>
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
Content-Disposition: inline; filename=peterz-locking-move-asm-generic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Since all asm/barrier.h should/must include asm-generic/barrier.h the
latter is a good place for generic infrastructure like this.

This also allows archs to override the new
smp_acquire__after_ctrl_dep().

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/asm-generic/barrier.h |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/compiler.h      |   37 -------------------------------------
 2 files changed, 39 insertions(+), 37 deletions(-)

--- a/include/asm-generic/barrier.h
+++ b/include/asm-generic/barrier.h
@@ -207,5 +207,44 @@ do {									\
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
+		cpu_relax();					\
+	}							\
+	smp_acquire__after_ctrl_dep();				\
+	VAL;							\
+})
+#endif
+
 #endif /* !__ASSEMBLY__ */
 #endif /* __ASM_GENERIC_BARRIER_H */
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -304,43 +304,6 @@ static __always_inline void __write_once
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
- */
-#define smp_acquire__after_ctrl_dep()		smp_rmb()
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
-		cpu_relax();					\
-	}							\
-	smp_acquire__after_ctrl_dep();				\
-	VAL;							\
-})
-#endif
-
 #endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */
