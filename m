From: sam@cerbere.dyndns.info (Samir Bellabes)
Subject: [PATCH] Compile error ipt_dstlimit
Date: Thu, 19 Aug 2004 02:24:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819002407.GB9523@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
  
   using p-o-m from CVS to kernel 2.6.8
   Compilation's problems with ipt_dstlimit.c

   It's seems that using the variable spinlock_t lock in struct
   ipt_dstlimit_htable introduce compilation's errors.
   There was a confusion between struct spinlock_debug and spinlock_t,
   depending on CONFIG_NETFILTER_DEBUG.

   Thanks to try this patch.

-- 
samir bellabes
sam@cerbere.dyndns.info

--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ipt_dstlimit.patch"

--- ipt_dstlimit.old.c	2004-08-19 01:44:31.000000000 +0200
+++ ipt_dstlimit.c	2004-08-19 01:34:01.000000000 +0200
@@ -83,7 +83,12 @@
 	struct dstlimit_cfg cfg;	/* config */
 
 	/* used internally */
+#ifdef CONFIG_NETFILTER_DEBUG
+	struct spinlock_debug lock;	/* lock with debug info for list_head */
+#else
 	spinlock_t lock;		/* lock for list_head */
+#endif /* CONFIG_NETFILTER_DEBUG */
+
 	u_int32_t rnd;			/* random seed for hash */
 	struct timer_list timer;	/* timer for gc */
 	atomic_t count;			/* number entries in table */
@@ -117,7 +122,9 @@
 {
 	struct dsthash_ent *ent;
 	u_int32_t hash = hash_dst(ht, dst);
+#ifdef CONFIG_NETFILTER_DEBUG
 	MUST_BE_LOCKED(&ht->lock);
+#endif
 	ent = LIST_FIND(&ht->hash[hash], dst_cmp, struct dsthash_ent *, dst);
 	return ent;
 }
@@ -165,8 +172,9 @@
 static inline void 
 __dsthash_free(struct ipt_dstlimit_htable *ht, struct dsthash_ent *ent)
 {
+#ifdef CONFIG_NETFILTER_DEBUG
 	MUST_BE_LOCKED(&ht->lock);
-
+#endif
 	list_del(&ent->list);
 	kmem_cache_free(dstlimit_cachep, ent);
 	atomic_dec(&ht->count);
@@ -212,7 +220,11 @@
 	atomic_set(&hinfo->count, 0);
 	atomic_set(&hinfo->use, 1);
 	hinfo->rnd = 0;
+#ifdef CONFIG_NETFILTER_DEBUG
+	hinfo->lock.l = SPIN_LOCK_UNLOCKED;
+#else
 	hinfo->lock = SPIN_LOCK_UNLOCKED;
+#endif
 	hinfo->pde = create_proc_entry(minfo->name, 0, dstlimit_procdir);
 	if (!hinfo->pde) {
 		vfree(hinfo);

--EeQfGwPcQSOJBaQU--
