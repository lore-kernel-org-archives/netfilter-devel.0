From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 7/7] net, netfilter: convert clusterip_config.refcount and clusterip_config.entries from atomic_t to refcount_t
Date: Wed, 15 Mar 2017 13:10:45 +0200
Message-ID: <1489576245-19472-8-git-send-email-elena.reshetova@intel.com>
References: <1489576245-19472-1-git-send-email-elena.reshetova@intel.com>
Cc: linux-kernel@vger.kernel.org, kadlec@blackhole.kfki.hu,
        pablo@netfilter.org, peterz@infradead.org, keescook@chromium.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        David Windsor <dwindsor@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1489576245-19472-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 52f2645..fcbdc0c 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -22,6 +22,7 @@
 #include <linux/icmp.h>
 #include <linux/if_arp.h>
 #include <linux/seq_file.h>
+#include <linux/refcount.h>
 #include <linux/netfilter_arp.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
@@ -40,8 +41,8 @@ MODULE_DESCRIPTION("Xtables: CLUSTERIP target");
 
 struct clusterip_config {
 	struct list_head list;			/* list of all configs */
-	atomic_t refcount;			/* reference count */
-	atomic_t entries;			/* number of entries/rules
+	refcount_t refcount;			/* reference count */
+	refcount_t entries;			/* number of entries/rules
 						 * referencing us */
 
 	__be32 clusterip;			/* the IP address */
@@ -77,7 +78,7 @@ struct clusterip_net {
 static inline void
 clusterip_config_get(struct clusterip_config *c)
 {
-	atomic_inc(&c->refcount);
+	refcount_inc(&c->refcount);
 }
 
 
@@ -89,7 +90,7 @@ static void clusterip_config_rcu_free(struct rcu_head *head)
 static inline void
 clusterip_config_put(struct clusterip_config *c)
 {
-	if (atomic_dec_and_test(&c->refcount))
+	if (refcount_dec_and_test(&c->refcount))
 		call_rcu_bh(&c->rcu, clusterip_config_rcu_free);
 }
 
@@ -103,7 +104,7 @@ clusterip_config_entry_put(struct clusterip_config *c)
 	struct clusterip_net *cn = net_generic(net, clusterip_net_id);
 
 	local_bh_disable();
-	if (atomic_dec_and_lock(&c->entries, &cn->lock)) {
+	if (refcount_dec_and_lock(&c->entries, &cn->lock)) {
 		list_del_rcu(&c->list);
 		spin_unlock(&cn->lock);
 		local_bh_enable();
@@ -149,10 +150,10 @@ clusterip_config_find_get(struct net *net, __be32 clusterip, int entry)
 			c = NULL;
 		else
 #endif
-		if (unlikely(!atomic_inc_not_zero(&c->refcount)))
+		if (unlikely(!refcount_inc_not_zero(&c->refcount)))
 			c = NULL;
 		else if (entry)
-			atomic_inc(&c->entries);
+			refcount_inc(&c->entries);
 	}
 	rcu_read_unlock_bh();
 
@@ -188,8 +189,8 @@ clusterip_config_init(const struct ipt_clusterip_tgt_info *i, __be32 ip,
 	clusterip_config_init_nodelist(c, i);
 	c->hash_mode = i->hash_mode;
 	c->hash_initval = i->hash_initval;
-	atomic_set(&c->refcount, 1);
-	atomic_set(&c->entries, 1);
+	refcount_set(&c->refcount, 1);
+	refcount_set(&c->entries, 1);
 
 	spin_lock_bh(&cn->lock);
 	if (__clusterip_config_find(net, ip)) {
-- 
2.7.4
