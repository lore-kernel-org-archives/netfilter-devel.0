From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH 2/3] CLUSTERIP: introduce reference counting for entries
Date: Tue, 30 Aug 2005 14:15:38 +0200
Message-ID: <20050830121550.397433000@nienna.balabit>
References: <20050830121535.985929000@nienna.balabit>
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline; filename=02-add_entry_refcount.patch
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

CLUSTERIP: introduce reference counting for entries

The CLUSTERIP target creates a procfs entry for all different cluster
IPs.  Although more than one rules can refer to a single cluster IP (and
thus a single config structure), removal of the procfs entry is done
unconditionally in destroy(). In more complicated situations involving
deferred dereferencing of the config structure by procfs and creating a
new rule with the same cluster IP it's also possible that no entry will
be created for the new rule.

This patch fixes the problem by counting the number of entries
referencing a given config structure and moving the config list
manipulation and procfs entry deletion parts to the
clusterip_config_entry_put() function.


Signed-off-by: KOVACS Krisztian <hidden@balabit.hu>


Index: linux-2.6.13/net/ipv4/netfilter/ipt_CLUSTERIP.c
===================================================================
--- linux-2.6.13.orig/net/ipv4/netfilter/ipt_CLUSTERIP.c	2005-08-30 14:12:40.317423733 +0200
+++ linux-2.6.13/net/ipv4/netfilter/ipt_CLUSTERIP.c	2005-08-30 14:12:43.365348289 +0200
@@ -49,6 +49,7 @@
 struct clusterip_config {
 	struct list_head list;			/* list of all configs */
 	atomic_t refcount;			/* reference count */
+	atomic_t entries;			/* number of entries referencing us */
 
 	u_int32_t clusterip;			/* the IP address */
 	u_int8_t clustermac[ETH_ALEN];		/* the MAC address */
@@ -76,23 +77,44 @@
 #endif
 
 static inline void
-clusterip_config_get(struct clusterip_config *c) {
+clusterip_config_get(struct clusterip_config *c)
+{
 	atomic_inc(&c->refcount);
 }
 
 static inline void
-clusterip_config_put(struct clusterip_config *c) {
-	if (atomic_dec_and_test(&c->refcount)) {
+clusterip_config_put(struct clusterip_config *c)
+{
+	if (atomic_dec_and_test(&c->refcount))
+		kfree(c);
+}
+
+static inline void
+clusterip_config_entry_get(struct clusterip_config *c)
+{
+	atomic_inc(&c->entries);
+}
+
+static inline void
+clusterip_config_entry_put(struct clusterip_config *c)
+{
+	if (atomic_dec_and_test(&c->entries)) {
 		write_lock_bh(&clusterip_lock);
 		list_del(&c->list);
 		write_unlock_bh(&clusterip_lock);
+
 		dev_mc_delete(c->dev, c->clustermac, ETH_ALEN, 0);
 		dev_put(c->dev);
-		kfree(c);
+
+		/* In case anyone still accesses the file, the open/close
+		 * functions are also incrementing the refcount on their own,
+		 * so it's safe to remove the entry even if it's in use. */
+#ifdef CONFIG_PROC_FS
+		remove_proc_entry(c->pde->name, c->pde->parent);
+#endif
 	}
 }
 
-
 static struct clusterip_config *
 __clusterip_config_find(u_int32_t clusterip)
 {
@@ -111,7 +133,7 @@
 }
 
 static inline struct clusterip_config *
-clusterip_config_find_get(u_int32_t clusterip)
+clusterip_config_find_get(u_int32_t clusterip, int entry)
 {
 	struct clusterip_config *c;
 
@@ -122,6 +144,8 @@
 		return NULL;
 	}
 	atomic_inc(&c->refcount);
+	if (entry)
+		atomic_inc(&c->entries);
 	read_unlock_bh(&clusterip_lock);
 
 	return c;
@@ -148,6 +172,7 @@
 	c->hash_mode = i->hash_mode;
 	c->hash_initval = i->hash_initval;
 	atomic_set(&c->refcount, 1);
+	atomic_set(&c->entries, 1);
 
 #ifdef CONFIG_PROC_FS
 	/* create proc dir entry */
@@ -415,7 +440,14 @@
 
 	/* FIXME: further sanity checks */
 
-	config = clusterip_config_find_get(e->ip.dst.s_addr);
+	/* If this is not a completely new entry and already has a config
+	 * attached, simply increase the entry refcount and return */
+	if (cipinfo->config != NULL) {
+		clusterip_config_entry_get(cipinfo->config);
+		return 1;
+	}
+
+	config = clusterip_config_find_get(e->ip.dst.s_addr, 1);
 	if (!config) {
 		if (!(cipinfo->flags & CLUSTERIP_FLAG_NEW)) {
 			printk(KERN_WARNING "CLUSTERIP: no config found for %u.%u.%u.%u, need 'new'\n", NIPQUAD(e->ip.dst.s_addr));
@@ -455,13 +487,10 @@
 {
 	struct ipt_clusterip_tgt_info *cipinfo = matchinfo;
 
-	/* we first remove the proc entry and then drop the reference
-	 * count.  In case anyone still accesses the file, the open/close
-	 * functions are also incrementing the refcount on their own */
-#ifdef CONFIG_PROC_FS
-	remove_proc_entry(cipinfo->config->pde->name,
-			  cipinfo->config->pde->parent);
-#endif
+	/* if no more entries are referencing the config, remove it
+	 * from the list and destroy the proc entry */
+	clusterip_config_entry_put(cipinfo->config);
+
 	clusterip_config_put(cipinfo->config);
 }
 
@@ -533,7 +562,7 @@
 
 	/* if there is no clusterip configuration for the arp reply's 
 	 * source ip, we don't want to mangle it */
-	c = clusterip_config_find_get(payload->src_ip);
+	c = clusterip_config_find_get(payload->src_ip, 0);
 	if (!c)
 		return NF_ACCEPT;
 

--
 Regards,
  Krisztian Kovacs
 
