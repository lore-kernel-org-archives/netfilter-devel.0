From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 6/7] net, netfilter: convert nfulnl_instance.use from atomic_t to refcount_t
Date: Wed, 15 Mar 2017 13:10:44 +0200
Message-ID: <1489576245-19472-7-git-send-email-elena.reshetova@intel.com>
References: <1489576245-19472-1-git-send-email-elena.reshetova@intel.com>
Cc: linux-kernel@vger.kernel.org, kadlec@blackhole.kfki.hu,
        pablo@netfilter.org, peterz@infradead.org, keescook@chromium.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        David Windsor <dwindsor@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:63786 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753783AbdCOLLO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 07:11:14 -0400
In-Reply-To: <1489576245-19472-1-git-send-email-elena.reshetova@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
 net/netfilter/nfnetlink_log.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 08247bf..ecd857b 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -40,6 +40,8 @@
 #include <net/netfilter/nfnetlink_log.h>
 
 #include <linux/atomic.h>
+#include <linux/refcount.h>
+
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 #include "../bridge/br_private.h"
@@ -57,7 +59,7 @@
 struct nfulnl_instance {
 	struct hlist_node hlist;	/* global list of instances */
 	spinlock_t lock;
-	atomic_t use;			/* use count */
+	refcount_t use;			/* use count */
 
 	unsigned int qlen;		/* number of nlmsgs in skb */
 	struct sk_buff *skb;		/* pre-allocatd skb */
@@ -115,7 +117,7 @@ __instance_lookup(struct nfnl_log_net *log, u_int16_t group_num)
 static inline void
 instance_get(struct nfulnl_instance *inst)
 {
-	atomic_inc(&inst->use);
+	refcount_inc(&inst->use);
 }
 
 static struct nfulnl_instance *
@@ -125,7 +127,7 @@ instance_lookup_get(struct nfnl_log_net *log, u_int16_t group_num)
 
 	rcu_read_lock_bh();
 	inst = __instance_lookup(log, group_num);
-	if (inst && !atomic_inc_not_zero(&inst->use))
+	if (inst && !refcount_inc_not_zero(&inst->use))
 		inst = NULL;
 	rcu_read_unlock_bh();
 
@@ -145,7 +147,7 @@ static void nfulnl_instance_free_rcu(struct rcu_head *head)
 static void
 instance_put(struct nfulnl_instance *inst)
 {
-	if (inst && atomic_dec_and_test(&inst->use))
+	if (inst && refcount_dec_and_test(&inst->use))
 		call_rcu_bh(&inst->rcu, nfulnl_instance_free_rcu);
 }
 
@@ -180,7 +182,7 @@ instance_create(struct net *net, u_int16_t group_num,
 	INIT_HLIST_NODE(&inst->hlist);
 	spin_lock_init(&inst->lock);
 	/* needs to be two, since we _put() after creation */
-	atomic_set(&inst->use, 2);
+	refcount_set(&inst->use, 2);
 
 	setup_timer(&inst->timer, nfulnl_timer, (unsigned long)inst);
 
@@ -1031,7 +1033,7 @@ static int seq_show(struct seq_file *s, void *v)
 		   inst->group_num,
 		   inst->peer_portid, inst->qlen,
 		   inst->copy_mode, inst->copy_range,
-		   inst->flushtimeout, atomic_read(&inst->use));
+		   inst->flushtimeout, refcount_read(&inst->use));
 
 	return 0;
 }
-- 
2.7.4

