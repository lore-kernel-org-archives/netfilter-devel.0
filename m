From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v2 tip/core/rcu 02/10] net/netfilter/nf_conntrack_core: Fix net_conntrack_lock()
Date: Mon, 31 Jul 2017 15:58:09 -0700
Message-ID: <1501541897-5225-2-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20170731225754.GB2674@linux.vnet.ibm.com>
Cc: mingo@kernel.org, jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com,
        Manfred Spraul <manfred@colorfullife.com>,
        <stable@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        Sasha Levin <sasha.levin@oracle.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53664 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751987AbdGaW6Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2017 18:58:25 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6VMwP0U140690
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 18:58:25 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2c2ch0jnf6-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 18:58:24 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netfilter-devel@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Mon, 31 Jul 2017 18:58:21 -0400
In-Reply-To: <20170731225754.GB2674@linux.vnet.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Manfred Spraul <manfred@colorfullife.com>

As we want to remove spin_unlock_wait() and replace it with explicit
spin_lock()/spin_unlock() calls, we can use this to simplify the
locking.

In addition:
- Reading nf_conntrack_locks_all needs ACQUIRE memory ordering.
- The new code avoids the backwards loop.

Only slightly tested, I did not manage to trigger calls to
nf_conntrack_all_lock().

V2: With improved comments, to clearly show how the barriers
    pair.

Fixes: b16c29191dc8 ("netfilter: nf_conntrack: use safer way to lock all buckets")
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: <stable@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/netfilter/nf_conntrack_core.c | 52 ++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9979f46c81dc..51390febd5e3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -96,19 +96,26 @@ static struct conntrack_gc_work conntrack_gc_work;
 
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
+	/* 2) read nf_conntrack_locks_all, with ACQUIRE semantics
+	 * It pairs with the smp_store_release() in nf_conntrack_all_unlock()
+	 */
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
 EXPORT_SYMBOL_GPL(nf_conntrack_lock);
 
@@ -149,28 +156,27 @@ static void nf_conntrack_all_lock(void)
 	int i;
 
 	spin_lock(&nf_conntrack_locks_all_lock);
-	nf_conntrack_locks_all = true;
 
-	/*
-	 * Order the above store of 'nf_conntrack_locks_all' against
-	 * the spin_unlock_wait() loads below, such that if
-	 * nf_conntrack_lock() observes 'nf_conntrack_locks_all'
-	 * we must observe nf_conntrack_locks[] held:
-	 */
-	smp_mb(); /* spin_lock(&nf_conntrack_locks_all_lock) */
+	nf_conntrack_locks_all = true;
 
 	for (i = 0; i < CONNTRACK_LOCKS; i++) {
-		spin_unlock_wait(&nf_conntrack_locks[i]);
+		spin_lock(&nf_conntrack_locks[i]);
+
+		/* This spin_unlock provides the "release" to ensure that
+		 * nf_conntrack_locks_all==true is visible to everyone that
+		 * acquired spin_lock(&nf_conntrack_locks[]).
+		 */
+		spin_unlock(&nf_conntrack_locks[i]);
 	}
 }
 
 static void nf_conntrack_all_unlock(void)
 {
-	/*
-	 * All prior stores must be complete before we clear
+	/* All prior stores must be complete before we clear
 	 * 'nf_conntrack_locks_all'. Otherwise nf_conntrack_lock()
 	 * might observe the false value but not the entire
-	 * critical section:
+	 * critical section.
+	 * It pairs with the smp_load_acquire() in nf_conntrack_lock()
 	 */
 	smp_store_release(&nf_conntrack_locks_all, false);
 	spin_unlock(&nf_conntrack_locks_all_lock);
-- 
2.5.2

