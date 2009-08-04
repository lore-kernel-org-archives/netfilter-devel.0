From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 102/103] netfilter: xtables1: remove info lock
Date: Tue,  4 Aug 2009 09:26:26 +0200
Message-ID: <1249370787-17583-103-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56965 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607AbZHDH2W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:28:22 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |   68 ------------------------------------
 net/netfilter/x_tables.c           |    9 -----
 2 files changed, 0 insertions(+), 77 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 1c37428..7befc66 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -607,74 +607,6 @@ extern int xt_proto_init(struct net *net, u_int8_t af);
 extern void xt_proto_fini(struct net *net, u_int8_t af);
 
 /*
- * Per-CPU spinlock associated with per-cpu table entries, and
- * with a counter for the "reading" side that allows a recursive
- * reader to avoid taking the lock and deadlocking.
- *
- * "reading" is used by ip/arp/ip6 tables rule processing which runs per-cpu.
- * It needs to ensure that the rules are not being changed while the packet
- * is being processed. In some cases, the read lock will be acquired
- * twice on the same CPU; this is okay because of the count.
- *
- * "writing" is used when reading counters.
- *  During replace any readers that are using the old tables have to complete
- *  before freeing the old table. This is handled by the write locking
- *  necessary for reading the counters.
- */
-struct xt_info_lock {
-	spinlock_t lock;
-	unsigned char readers;
-};
-DECLARE_PER_CPU(struct xt_info_lock, xt_info_locks);
-
-/*
- * Note: we need to ensure that preemption is disabled before acquiring
- * the per-cpu-variable, so we do it as a two step process rather than
- * using "spin_lock_bh()".
- *
- * We _also_ need to disable bottom half processing before updating our
- * nesting count, to make sure that the only kind of re-entrancy is this
- * code being called by itself: since the count+lock is not an atomic
- * operation, we can allow no races.
- *
- * _Only_ that special combination of being per-cpu and never getting
- * re-entered asynchronously means that the count is safe.
- */
-static inline void xt_info_rdlock_bh(void)
-{
-	struct xt_info_lock *lock;
-
-	local_bh_disable();
-	lock = &__get_cpu_var(xt_info_locks);
-	if (likely(!lock->readers++))
-		spin_lock(&lock->lock);
-}
-
-static inline void xt_info_rdunlock_bh(void)
-{
-	struct xt_info_lock *lock = &__get_cpu_var(xt_info_locks);
-
-	if (likely(!--lock->readers))
-		spin_unlock(&lock->lock);
-	local_bh_enable();
-}
-
-/*
- * The "writer" side needs to get exclusive access to the lock,
- * regardless of readers.  This must be called with bottom half
- * processing (and thus also preemption) disabled.
- */
-static inline void xt_info_wrlock(unsigned int cpu)
-{
-	spin_lock(&per_cpu(xt_info_locks, cpu).lock);
-}
-
-static inline void xt_info_wrunlock(unsigned int cpu)
-{
-	spin_unlock(&per_cpu(xt_info_locks, cpu).lock);
-}
-
-/*
  * This helper is performance critical and must be inlined
  */
 static inline unsigned long ifname_compare_aligned(const char *_a,
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 167332c..1e43ab3 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -664,9 +664,6 @@ void xt_compat_unlock(u_int8_t af)
 EXPORT_SYMBOL_GPL(xt_compat_unlock);
 #endif
 
-DEFINE_PER_CPU(struct xt_info_lock, xt_info_locks);
-EXPORT_PER_CPU_SYMBOL_GPL(xt_info_locks);
-
 #ifdef CONFIG_PROC_FS
 struct xt_names_priv {
 	struct seq_net_private p;
@@ -1803,12 +1800,6 @@ static int __init xt_init(void)
 	unsigned int i;
 	int rv;
 
-	for_each_possible_cpu(i) {
-		struct xt_info_lock *lock = &per_cpu(xt_info_locks, i);
-		spin_lock_init(&lock->lock);
-		lock->readers = 0;
-	}
-
 	xt = kmalloc(sizeof(struct xt_af) * NFPROTO_NUMPROTO, GFP_KERNEL);
 	if (!xt)
 		return -ENOMEM;
-- 
1.6.3.3

