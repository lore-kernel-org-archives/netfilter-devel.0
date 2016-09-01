From: Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 5/7] net/netfilter/nf_conntrack_core: Fix memory barriers.
Date: Thu,  1 Sep 2016 17:04:15 +0200
Message-ID: <1472742257-10515-6-git-send-email-manfred@colorfullife.com>
References: <1472742257-10515-1-git-send-email-manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>, will.deacon@arm.com,
        1vier1@web.de, Davidlohr Bueso <dave@stgolabs.net>,
        Manfred Spraul <manfred@colorfullife.com>,
        stable@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, Boqun Feng <boqun.feng@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35969 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933171AbcIAPF3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Sep 2016 11:05:29 -0400
Received: by mail-wm0-f66.google.com with SMTP id i138so12994480wmf.3
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Sep 2016 08:04:36 -0700 (PDT)
In-Reply-To: <1472742257-10515-1-git-send-email-manfred@colorfullife.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

1) reading nf_conntrack_locks_all needs ACQUIRE memory
ordering.

In addition, to simplify backporting, the patch also adds:

2) For some architectures the ACQUIRE during spin_lock only applies to
loading the lock, not to storing the lock state. E.g. see
commit 51d7d5205d33 ("powerpc: Add smp_mb() to arch_spin_is_locked()")

nf_conntrack_lock() does not handle this correctly:
    /* 1) Acquire the lock */
    spin_lock(lock);
    while (unlikely(nf_conntrack_locks_all)) {
        spin_unlock(lock);

Thus a memory barrier might be missing between spin_lock and reading
nf_conntrack_locks_all.

3) Between the write of nf_conntrack_locks_all and spin_unlock_wait(),
a memory barrier might be required.

As improvement:

4) Minor issue: If there would be many nf_conntrack_all_lock() callers,
then nf_conntrack_lock() would loop forever.

Therefore: Change nf_conntrack_lock and nf_conntract_lock_all() to the
approach used by ipc/sem.c:

1) add smp_load_acquire()

2) add smb_mb() after spin_lock()
  Note: redundant if spin_unlock_wait() is implemented as spin_lock();
  spin_unlock().
3) add smb_rmb() after spin_unlock_wait()
  Note: redundant after
commit 2c6100227116 ("locking/qspinlock: Fix spin_unlock_wait() some more")

4) for nf_conntrack_lock, use spin_lock(&global_lock) instead of
  spin_unlock_wait(&global_lock) and loop backward.
5) use smp_store_mb() instead of a raw smp_mb()

As the minimal bugfix, it might be sufficient just to add the
smp_load_acquire(), but then it must be checked first if all
updates to qspinlock were backported.

Fixes: b16c29191dc8
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: <stable@vger.kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
---
 net/netfilter/nf_conntrack_core.c | 41 ++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7d90a5d..3847f09 100644
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
+	smp_mb();
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
@@ -132,19 +141,23 @@ static void nf_conntrack_all_lock(void)
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
 	}
+	/* spin_unlock_wait() is at least a control barrier.
+	 * Add smp_rmb() to upgrade it to an ACQUIRE, it must
+	 * pair with the spin_unlock(&nf_conntrack_locks[])
+	 */
+	smp_rmb();
 }
 
 static void nf_conntrack_all_unlock(void)
-- 
2.7.4

