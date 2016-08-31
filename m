From: Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 5/5] net/netfilter/nf_conntrack_core: update memory barriers.
Date: Wed, 31 Aug 2016 15:42:30 +0200
Message-ID: <1472650950-3131-6-git-send-email-manfred@colorfullife.com>
References: <1472650950-3131-1-git-send-email-manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>, 1vier1@web.de,
        Davidlohr Bueso <dave@stgolabs.net>,
        Manfred Spraul <manfred@colorfullife.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, Boqun Feng <boqun.feng@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472650950-3131-1-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

As explained in commit 51d7d5205d33
("powerpc: Add smp_mb() to arch_spin_is_locked()", for some architectures
the ACQUIRE during spin_lock only applies to loading the lock, not to
storing the lock state.

nf_conntrack_lock() does not handle this correctly:
    /* 1) Acquire the lock */
    spin_lock(lock);
    while (unlikely(nf_conntrack_locks_all)) {
        spin_unlock(lock);

spinlock_store_acquire() is missing between spin_lock and reading
nf_conntrack_locks_all. In addition, reading nf_conntrack_locks_all
needs ACQUIRE memory ordering.

2nd, minor issue: If there would be many nf_conntrack_all_lock() callers,
then nf_conntrack_lock() would loop forever.

Therefore: Change nf_conntrack_lock and nf_conntract_lock_all() to the
approach used by ipc/sem.c:

- add spinlock_store_acquire()
- add smp_load_acquire()
- for nf_conntrack_lock, use spin_lock(&global_lock) instead of
  spin_unlock_wait(&global_lock) and loop backward.
- use smp_store_mb() instead of a raw smp_mb()

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org

---

Question: Should I split this patch?
First a patch that uses smp_mb(), with Cc: stable.
The replace the smp_mb() with spinlock_store_acquire, not for stable

 net/netfilter/nf_conntrack_core.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7d90a5d..f840b0b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -79,20 +79,29 @@ static __read_mostly bool nf_conntrack_locks_all;
 
 void nf_conntrack_lock(spinlock_t *lock) __acquires(lock)
 {
+	/* 1) Acquire the lock */
 	spin_lock(lock);
-	while (unlikely(nf_conntrack_locks_all)) {
-		spin_unlock(lock);
 
-		/*
-		 * Order the 'nf_conntrack_locks_all' load vs. the
-		 * spin_unlock_wait() loads below, to ensure
-		 * that 'nf_conntrack_locks_all_lock' is indeed held:
-		 */
-		smp_rmb(); /* spin_lock(&nf_conntrack_locks_all_lock) */
-		spin_unlock_wait(&nf_conntrack_locks_all_lock);
-		spin_lock(lock);
-	}
+	/* 2) Order storing the lock and reading nf_conntrack_locks_all */
+	spinlock_store_acquire();
+
+	/* 3) read nf_conntrack_locks_all, with ACQUIRE semantics */
+	if (likely(smp_load_acquire(&nf_conntrack_locks_all) == false))
+		return;
+
+	/* fast path failed, unlock */
+	spin_unlock(lock);
+
+	/* Slow path 1) get global lock */
+	spin_lock(&nf_conntrack_locks_all_lock);
+
+	/* Slow path 2) get the lock we want */
+	spin_lock(lock);
+
+	/* Slow path 3) release the global lock */
+	spin_unlock(&nf_conntrack_locks_all_lock);
 }
+
 EXPORT_SYMBOL_GPL(nf_conntrack_lock);
 
 static void nf_conntrack_double_unlock(unsigned int h1, unsigned int h2)
@@ -132,15 +141,14 @@ static void nf_conntrack_all_lock(void)
 	int i;
 
 	spin_lock(&nf_conntrack_locks_all_lock);
-	nf_conntrack_locks_all = true;
 
 	/*
-	 * Order the above store of 'nf_conntrack_locks_all' against
+	 * Order the store of 'nf_conntrack_locks_all' against
 	 * the spin_unlock_wait() loads below, such that if
 	 * nf_conntrack_lock() observes 'nf_conntrack_locks_all'
 	 * we must observe nf_conntrack_locks[] held:
 	 */
-	smp_mb(); /* spin_lock(&nf_conntrack_locks_all_lock) */
+	smp_store_mb(nf_conntrack_locks_all, true);
 
 	for (i = 0; i < CONNTRACK_LOCKS; i++) {
 		spin_unlock_wait(&nf_conntrack_locks[i]);
-- 
2.7.4
