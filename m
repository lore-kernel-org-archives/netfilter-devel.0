From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH nf-next-2.6] netfilter: CLUSTERIP: RCU conversion
Date: Wed, 09 Jun 2010 18:11:01 +0200
Message-ID: <1276099861.2442.199.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62269 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab0FIQLF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:11:05 -0400
Received: by wyb40 with SMTP id 40so275480wyb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Jun 2010 09:11:03 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

- clusterip_lock becomes a spinlock
- lockless lookups

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c |   40 ++++++++++++++++-----------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index f91c94b..d83ad7f 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -53,12 +53,13 @@ struct clusterip_config {
 #endif
 	enum clusterip_hashmode hash_mode;	/* which hashing mode */
 	u_int32_t hash_initval;			/* hash initialization */
+	struct rcu_head rcu;
 };
 
 static LIST_HEAD(clusterip_configs);
 
 /* clusterip_lock protects the clusterip_configs list */
-static DEFINE_RWLOCK(clusterip_lock);
+static DEFINE_SPINLOCK(clusterip_lock);
 
 #ifdef CONFIG_PROC_FS
 static const struct file_operations clusterip_proc_fops;
@@ -71,11 +72,17 @@ clusterip_config_get(struct clusterip_config *c)
 	atomic_inc(&c->refcount);
 }
 
+
+static void clusterip_config_rcu_free(struct rcu_head *head)
+{
+	kfree(container_of(head, struct clusterip_config, rcu));
+}
+
 static inline void
 clusterip_config_put(struct clusterip_config *c)
 {
 	if (atomic_dec_and_test(&c->refcount))
-		kfree(c);
+		call_rcu_bh(&c->rcu, clusterip_config_rcu_free);
 }
 
 /* decrease the count of entries using/referencing this config.  If last
@@ -84,10 +91,10 @@ clusterip_config_put(struct clusterip_config *c)
 static inline void
 clusterip_config_entry_put(struct clusterip_config *c)
 {
-	write_lock_bh(&clusterip_lock);
+	spin_lock_bh(&clusterip_lock);
 	if (atomic_dec_and_test(&c->entries)) {
 		list_del(&c->list);
-		write_unlock_bh(&clusterip_lock);
+		spin_unlock_bh(&clusterip_lock);
 
 		dev_mc_del(c->dev, c->clustermac);
 		dev_put(c->dev);
@@ -100,7 +107,7 @@ clusterip_config_entry_put(struct clusterip_config *c)
 #endif
 		return;
 	}
-	write_unlock_bh(&clusterip_lock);
+	spin_unlock_bh(&clusterip_lock);
 }
 
 static struct clusterip_config *
@@ -108,7 +115,7 @@ __clusterip_config_find(__be32 clusterip)
 {
 	struct clusterip_config *c;
 
-	list_for_each_entry(c, &clusterip_configs, list) {
+	list_for_each_entry_rcu(c, &clusterip_configs, list) {
 		if (c->clusterip == clusterip)
 			return c;
 	}
@@ -121,16 +128,14 @@ clusterip_config_find_get(__be32 clusterip, int entry)
 {
 	struct clusterip_config *c;
 
-	read_lock_bh(&clusterip_lock);
+	rcu_read_lock_bh();
 	c = __clusterip_config_find(clusterip);
-	if (!c) {
-		read_unlock_bh(&clusterip_lock);
-		return NULL;
+	if (c) {
+		atomic_inc(&c->refcount);
+		if (entry)
+			atomic_inc(&c->entries);
 	}
-	atomic_inc(&c->refcount);
-	if (entry)
-		atomic_inc(&c->entries);
-	read_unlock_bh(&clusterip_lock);
+	rcu_read_unlock_bh();
 
 	return c;
 }
@@ -181,9 +186,9 @@ clusterip_config_init(const struct ipt_clusterip_tgt_info *i, __be32 ip,
 	}
 #endif
 
-	write_lock_bh(&clusterip_lock);
+	spin_lock_bh(&clusterip_lock);
 	list_add(&c->list, &clusterip_configs);
-	write_unlock_bh(&clusterip_lock);
+	spin_unlock_bh(&clusterip_lock);
 
 	return c;
 }
@@ -733,6 +738,9 @@ static void __exit clusterip_tg_exit(void)
 #endif
 	nf_unregister_hook(&cip_arp_ops);
 	xt_unregister_target(&clusterip_tg_reg);
+
+	/* Wait for completion of call_rcu_bh()'s (clusterip_config_rcu_free) */
+	rcu_barrier_bh();
 }
 
 module_init(clusterip_tg_init);


