From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -v3 6/8] locking,netfilter: Fix nf_conntrack_lock()
Date: Tue, 31 May 2016 11:41:40 +0200
Message-ID: <20160531094844.222530154@infradead.org>
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
Content-Disposition: inline; filename=peterz-locking-netfilter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Even with spin_unlock_wait() fixed, nf_conntrack_lock{,_all}() is
borken as it misses a bunch of memory barriers to order the whole
global vs local locks scheme.

Even x86 (and other TSO archs) are affected.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 net/netfilter/nf_conntrack_core.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -83,6 +83,12 @@ void nf_conntrack_lock(spinlock_t *lock)
 	spin_lock(lock);
 	while (unlikely(nf_conntrack_locks_all)) {
 		spin_unlock(lock);
+
+		/* Order the nf_contrack_locks_all load vs the
+		 * spin_unlock_wait() loads below, to ensure locks_all is
+		 * indeed held.
+		 */
+		smp_rmb(); /* spin_lock(locks_all) */
 		spin_unlock_wait(&nf_conntrack_locks_all_lock);
 		spin_lock(lock);
 	}
@@ -128,6 +134,12 @@ static void nf_conntrack_all_lock(void)
 	spin_lock(&nf_conntrack_locks_all_lock);
 	nf_conntrack_locks_all = true;
 
+	/* Order the above store against the spin_unlock_wait() loads
+	 * below, such that if nf_conntrack_lock() observes lock_all
+	 * we must observe lock[] held.
+	 */
+	smp_mb(); /* spin_lock(locks_all) */
+
 	for (i = 0; i < CONNTRACK_LOCKS; i++) {
 		spin_unlock_wait(&nf_conntrack_locks[i]);
 	}
@@ -135,7 +147,11 @@ static void nf_conntrack_all_lock(void)
 
 static void nf_conntrack_all_unlock(void)
 {
-	nf_conntrack_locks_all = false;
+	/* All prior stores must be complete before we clear locks_all.
+	 * Otherwise nf_conntrack_lock() might observe the false but not the
+	 * entire critical section.
+	 */
+	smp_store_release(&nf_conntrack_locks_all, false);
 	spin_unlock(&nf_conntrack_locks_all_lock);
 }
 
