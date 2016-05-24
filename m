From: Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 1/3] locking: Introduce smp_acquire__after_ctrl_dep
Date: Tue, 24 May 2016 16:27:24 +0200
Message-ID: <20160524143649.523586684@infradead.org>
References: <20160524142723.178148277@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: boqun.feng@gmail.com, Waiman.Long@hpe.com, tj@kernel.org,
	pablo@netfilter.org, kaber@trash.net, davem@davemloft.net,
	oleg@redhat.com, netfilter-devel@vger.kernel.org,
	sasha.levin@oracle.com, hofrat@osadl.org,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=peterz-locking-smp_acquire__after_ctrl_dep.patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Introduce smp_acquire__after_ctrl_dep(), this construct is not
uncommen, but the lack of this barrier is.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/compiler.h |   14 ++++++++++----
 ipc/sem.c                |   14 ++------------
 2 files changed, 12 insertions(+), 16 deletions(-)

--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -305,20 +305,26 @@ static __always_inline void __write_once
 })
 
 /**
+ * smp_acquire__after_ctrl_dep() - Provide ACQUIRE ordering after a control dependency
+ *
+ * A control dependency provides a LOAD->STORE order, the additional RMB
+ * provides LOAD->LOAD order, together they provide LOAD->{LOAD,STORE} order,
+ * aka. ACQUIRE.
+ */
+#define smp_acquire__after_ctrl_dep()		smp_rmb()
+
+/**
  * smp_cond_acquire() - Spin wait for cond with ACQUIRE ordering
  * @cond: boolean expression to wait for
  *
  * Equivalent to using smp_load_acquire() on the condition variable but employs
  * the control dependency of the wait to reduce the barrier on many platforms.
  *
- * The control dependency provides a LOAD->STORE order, the additional RMB
- * provides LOAD->LOAD order, together they provide LOAD->{LOAD,STORE} order,
- * aka. ACQUIRE.
  */
 #define smp_cond_acquire(cond)	do {		\
 	while (!(cond))				\
 		cpu_relax();			\
-	smp_rmb(); /* ctrl + rmb := acquire */	\
+	smp_acquire__after_ctrl_dep();		\
 } while (0)
 
 #endif /* __KERNEL__ */
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -260,16 +260,6 @@ static void sem_rcu_free(struct rcu_head
 }
 
 /*
- * spin_unlock_wait() and !spin_is_locked() are not memory barriers, they
- * are only control barriers.
- * The code must pair with spin_unlock(&sem->lock) or
- * spin_unlock(&sem_perm.lock), thus just the control barrier is insufficient.
- *
- * smp_rmb() is sufficient, as writes cannot pass the control barrier.
- */
-#define ipc_smp_acquire__after_spin_is_unlocked()	smp_rmb()
-
-/*
  * Wait until all currently ongoing simple ops have completed.
  * Caller must own sem_perm.lock.
  * New simple ops cannot start, because simple ops first check
@@ -292,7 +282,7 @@ static void sem_wait_array(struct sem_ar
 		sem = sma->sem_base + i;
 		spin_unlock_wait(&sem->lock);
 	}
-	ipc_smp_acquire__after_spin_is_unlocked();
+	smp_acquire__after_ctrl_dep();
 }
 
 /*
@@ -350,7 +340,7 @@ static inline int sem_lock(struct sem_ar
 			 *	complex_count++;
 			 *	spin_unlock(sem_perm.lock);
 			 */
-			ipc_smp_acquire__after_spin_is_unlocked();
+			smp_acquire__after_ctrl_dep();
 
 			/*
 			 * Now repeat the test of complex_count:
