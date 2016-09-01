From: Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 8/7] net/netfilter/nf_conntrack_core: Remove another memory barrier
Date: Thu,  1 Sep 2016 17:27:52 +0200
Message-ID: <1472743673-15585-1-git-send-email-manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>, will.deacon@arm.com,
        1vier1@web.de, Davidlohr Bueso <dave@stgolabs.net>,
        Manfred Spraul <manfred@colorfullife.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, Boqun Feng <boqun.feng@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Since spin_unlock_wait() is defined as equivalent to spin_lock();
spin_unlock(), the memory barrier before spin_unlock_wait() is
also not required.

Not for stable!

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
---
 net/netfilter/nf_conntrack_core.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7a3b5e6..0591a25 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -139,13 +139,7 @@ static void nf_conntrack_all_lock(void)
 
 	spin_lock(&nf_conntrack_locks_all_lock);
 
-	/*
-	 * Order the store of 'nf_conntrack_locks_all' against
-	 * the spin_unlock_wait() loads below, such that if
-	 * nf_conntrack_lock() observes 'nf_conntrack_locks_all'
-	 * we must observe nf_conntrack_locks[] held:
-	 */
-	smp_store_mb(nf_conntrack_locks_all, true);
+	nf_conntrack_locks_all = true;
 
 	for (i = 0; i < CONNTRACK_LOCKS; i++) {
 		spin_unlock_wait(&nf_conntrack_locks[i]);
-- 
2.7.4
